local function processPets(petCondition, machineName, serverFunction, amount)
    local save = require(game.ReplicatedStorage.Library.Client.Save).Get()
    if save and save.Inventory and save.Inventory.Pet then
        for key, pet in pairs(save.Inventory.Pet) do
            if pet._am and pet._am > petCondition then
                game:GetService("ReplicatedStorage").Network[serverFunction]:InvokeServer(tostring(key), amount)
            end
        end
    end
end

local function FindGateToUnlock()
    for number = 2, 8 do
        local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()
        local area, currentArea = "Area " .. tostring(number - 1), "Area " .. tostring(number)

        for _, Gate in ipairs(gates) do
            local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")
            if Gate.Transparency == 0 and title and title.Text == currentArea then
                return area, number
            end
        end
    end
end

local gateToUnlock, gateNumber = FindGateToUnlock()

if gateToUnlock then
    for _, Gate in ipairs(workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()) do
        local title = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Title")
        if title and title.Text == gateToUnlock then
            game:GetService("ReplicatedStorage").Network.InstanceZones_RequestPurchase:InvokeServer("AutumnEvent", gateNumber)

            local currentQuest = Gate:FindFirstChild("GateHUD") and Gate.GateHUD:FindFirstChild("Quest") and Gate.GateHUD.Quest:FindFirstChild("Title") and Gate.GateHUD.Quest.Title.Text
            if not currentQuest then return end

            if currentQuest:match('golden') and currentQuest:match('Make') then
                processPets(101, "GoldMachine", "GoldMachine_Activate", 10)
            elseif currentQuest:match('Break') then
                local teleportLocations = {
                    [2] = CFrame.new(600, 16.2, -22400),
                    [3] = CFrame.new(947.247498, 16.2126942, -22448.3652),
                    [4] = CFrame.new(1100.43103, 16.2106895, -22451.1797),
                    [5] = CFrame.new(1264.19556, 16.2126942, -22446.8535),
                    [6] = CFrame.new(1429.23303, 16.2126942, -22444.2051),
                    [7] = CFrame.new(1647.22717, 16.2126942, -22450.584),
                    [8] = CFrame.new(1809.28503, 16.2126942, -22448.5898),
                }
                local targetCFrame = teleportLocations[gateNumber]
                if targetCFrame then
                    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                end
            elseif currentQuest:match('rainbow') and currentQuest:match('Make') then
                processPets(51, "RainbowMachine", "RainbowMachine_Activate", 5)
            end
        end
    end
else
    print("No gates to unlock.")
end
