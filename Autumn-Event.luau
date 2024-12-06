
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

local function FindGateToUnlock()
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()

    for number = 2, 8 do
        local area = "Area " .. tostring(number - 1)
        local currentArea = "Area " .. tostring(number)

        for _, Gate in ipairs(gates) do
            if Gate:FindFirstChild("GateHUD") and Gate.Transparency == 0 then
                local title = Gate.GateHUD:FindFirstChild("Title")
                if title and title.Text == currentArea then
                    return area, number
                    print(area, number)
                end
            end
        end
    end

    return nil, nil
end



local gateToUnlock, gateNumber = FindGateToUnlock()

if gateToUnlock then
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()

    for _, Gate in ipairs(gates) do
        local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")
        if title and title.Text == gateToUnlock then
            -- Unlock the gate
            game:GetService("ReplicatedStorage").Network.InstanceZones_RequestPurchase:InvokeServer("AutumnEvent", gateNumber)

            local currentQuest = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Quest") and Gate.GateHUD.Quest:FindFirstChild("Title") and Gate.GateHUD.Quest.Title.Text

            if currentQuest then
                -- Process specific quests
                if currentQuest:match('golden') and currentQuest:match('Make') then
                    processPets(101, "GoldMachine", "GoldMachine_Activate", 10)
                elseif currentQuest:match('Break') and (currentQuest:match('breakables') or currentQuest:match('breakable')) then
                    -- Handle teleportation to specific gate areas
                    if gateNumber == 2 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(600, 16.2, -22400) -- Replace with correct coordinates
                    elseif gateNumber == 3 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(947.247498, 16.2126942, -22448.3652)
                    elseif gateNumber == 4 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1100.43103, 16.2106895, -22451.1797)
                    elseif gateNumber == 5 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1264.19556, 16.2126942, -22446.8535)
                    elseif gateNumber == 6 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1429.23303, 16.2126942, -22444.2051)
                    elseif gateNumber == 7 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1647.22717, 16.2126942, -22450.584)
                    elseif gateNumber == 8 then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(1809.28503, 16.2126942, -22448.5898)
                    end
                elseif currentQuest:match('rainbow') and currentQuest:match('Make') then
                    processPets(51, "RainbowMachine", "RainbowMachine_Activate", 5)
                end
            end
        end
    end
else
    print(gateToUnlock, gateNumber, "A")
    print("No gates to unlock.")
end
