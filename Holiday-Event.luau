
function FindGateToUnlock()
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.HolidayEvent.Gates:GetChildren()

    for number = 2, 4 do
        local area = "Area " .. tostring(number)
        local nextArea = "Area " .. tostring(number + 1)

        for _, Gate in ipairs(gates) do
            local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")

            if Gate.Transparency == 0 then
                return nextArea
            end
        end
    end
    return nil
end

local function processPets(petCondition, machineName, serverFunction, amount)
    local save = require(game.ReplicatedStorage.Library.Client.Save).Get()
    if save and save.Inventory and save.Inventory.Pet then
        for key, pet in pairs(save.Inventory.Pet) do
            if pet._am and pet._am > petCondition then
                local args = { tostring(key), amount }
                game:GetService("ReplicatedStorage").Network[serverFunction]:InvokeServer(unpack(args))
            end
        end
    end
end

local function hatchegg(area)

   EggsPath = game.Workspace.__THINGS.CustomEggs:GetChildren()
   
   if area == 2 then

      game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(782, 16, -20871)

	  for _, Egg in ipairs(EggsPath) do
         
		 if Egg:FindFirstChild('Egg') then
            print(Egg.Egg.MeshId .. " " .. Egg.Name)
            if Egg:FindFirstChild('Egg') and Egg.Egg:IsA('MeshPart') and Egg.Egg.MeshId == "rbxassetid://6446249501" then
                local args = {
                        [1] = Egg.Name,
                        [2] = 1
                    }

                game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("CustomEggs_Hatch"):InvokeServer(unpack(args))
			end
		    
		 end
	  
	  end     
   
   end

end

local gateToUnlock = FindGateToUnlock()
if gateToUnlock then
    print(gateToUnlock)
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.HolidayEvent.Gates:GetChildren()

    for _, Gate in ipairs(gates) do
        local title = Gate:FindFirstChild("GateHUD")
        if title.Title.Text == gateToUnlock then
            print("Found Gate")
            local gateNumber = tonumber(gateToUnlock:match("%d+"))
            game:GetService("ReplicatedStorage").Network.InstanceZones_RequestPurchase:InvokeServer("HolidayEvent", gateNumber)

            local currentQuest = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Quest") and Gate.GateHUD.Quest:FindFirstChild("Title") and Gate.GateHUD.Quest.Title.Text

            if currentQuest then
                print(gateNumber)
                if currentQuest:match('golden') and currentQuest:match('Make') then
                    processPets(101, "GoldMachine", "GoldMachine_Activate", 10)
                elseif currentQuest:match('Break') and (currentQuest:match('breakables') or currentQuest:match('breakable')) then
                    if gateNumber == 2 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(777, 16, -20841)
					elseif gateNumber == 3 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(943, 16, -20840)
					elseif gateNumber == 4 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1103, 16, -20844)
					elseif gateNumber == 5 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1427, 16, -20845)
					end
                elseif currentQuest:match('rainbow') and currentQuest:match('Make') then
                    processPets(51, "RainbowMachine", "RainbowMachine_Activate", 5)
				elseif currentQuest:match('Hatch') and currentQuest:match('eggs') then
				    hatchegg(gateNumber)
                end
            end
        end
    end
else
    print("No gates to unlock.")
end
