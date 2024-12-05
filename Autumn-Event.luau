function FindGateHUD(GatesToLookFor)
    local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()
    
    for _, Gate in ipairs(gates) do
        local gateHUD = Gate:FindFirstChild("GateHUD")
        if gateHUD then
            local title = gateHUD:FindFirstChild("Title")
            if title and title.Text:match(GatesToLookFor) then -- Use `match` to search for the area in Title
                return true
            end
        end
    end
    return false
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

function FindGateToUnlock()
    for number = 7, 2, -1 do
        local area = "Area " .. tostring(number)
        if not FindGateHUD(area) then
            local nextArea = "Area " .. tostring(number + 1)
            return nextArea
        end
    end
    return nil
end

local gateToUnlock = FindGateToUnlock()
if gateToUnlock then
    if gateToUnlock == "Area 3" then
        local gates = workspace.__THINGS.__INSTANCE_CONTAINER.Active.AutumnEvent.Gates:GetChildren()
        
        for _, Gate in ipairs(gates) do
            local gateHUD = Gate:FindFirstChild("GateHUD")
            if gateHUD then
                local title = gateHUD:FindFirstChild("Title")
                if title and title.Text:match("Area 3") then 
                    
                    local currentQuest = gateHUD:FindFirstChild("Quest") and gateHUD.Quest:FindFirstChild("Title") and gateHUD.Quest.Title.Text
                    if currentQuest and currentQuest:match('golden') and currentQuest:match('Make') then
                        processPets(101, "GoldMachine", "GoldMachine_Activate", 10)
                    elseif currentQuest and currentQuest:match('Break') and currentQuest:match('breakables') or currentQuest:match('breakable') then
                        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(947.247498, 16.2126942, -22448.3652, -0.420525283, -6.65844879e-10, -0.907280803, -1.90858732e-10, 1, -6.45427489e-10, 0.907280803, -9.82561185e-11, -0.420525283)
                    end
                end
            end
        end
    end

else

end
