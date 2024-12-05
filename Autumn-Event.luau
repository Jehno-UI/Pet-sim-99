function FindGateToUnlock()
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()

    for number = 7, 2, -1 do
        local area = "Area " .. tostring(number)
        local nextArea = "Area " .. tostring(number + 1)

        for _, Gate in ipairs(gates) do
            local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")
            if title and title.Text == area and Gate.Transparency == 1 then
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

local gateToUnlock = FindGateToUnlock()
if gateToUnlock then
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()

    for _, Gate in ipairs(gates) do
        local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")
        if title and title.Text == gateToUnlock then
            local gateNumber = tonumber(gateToUnlock:match("%d+"))
            game:GetService("ReplicatedStorage").Network.InstanceZones_RequestPurchase:InvokeServer("AutumnEvent", gateNumber)

            local currentQuest = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Quest") and Gate.GateHUD.Quest:FindFirstChild("Title") and Gate.GateHUD.Quest.Title.Text

            if currentQuest then
                if currentQuest:match('golden') and currentQuest:match('Make') then
                    processPets(101, "GoldMachine", "GoldMachine_Activate", 10)
                elseif currentQuest:match('Break') and (currentQuest:match('breakables') or currentQuest:match('breakable')) then
                    if gateNumber == 3 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(947.247498, 16.2126942, -22448.3652)
                    elseif gateNumber == 4 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1100.43103, 16.2106895, -22451.1797)
                    end
                elseif currentQuest:match('rainbow') and currentQuest:match('Make') then
                    processPets(51, "RainbowMachine", "RainbowMachine_Activate", 5)
                end
            end
        end
    end
else
    print("No gates to unlock.")
end
