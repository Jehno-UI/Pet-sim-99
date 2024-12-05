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
        print("Area 3 Quest Process")
        
        for _, Gate in ipairs(gates) do
            local gateHUD = Gate:FindFirstChild("GateHUD")
            if gateHUD then
                local title = gateHUD:FindFirstChild("Title")
                if title and title.Text:match("Area 3") then -- Match "Area 3" in the title
                    print("Found Area 3")
                    
                    local currentQuest = gateHUD:FindFirstChild("Quest") and gateHUD.Quest:FindFirstChild("Title") and gateHUD.Quest.Title.Text
                    if currentQuest and currentQuest:match('golden') and currentQuest:match('Make') then
                        print("Found Gold Quest")
                        processPets(201, "GoldMachine", "GoldMachine_Activate", 20)
                    end
                end
            end
        end
    end
    print("Next gate to unlock is: " .. gateToUnlock)
else
    print("No gate found to unlock!")
end
