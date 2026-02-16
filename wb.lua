
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer or Players.PlayerAdded:Wait()

lp.CharacterAdded:Wait()
local char = lp.Character

local invFolder = ReplicatedStorage:WaitForChild("Inventories")
local inv = invFolder:WaitForChild(lp.Name)

local net = ReplicatedStorage
    :WaitForChild("rbxts_include")
    :WaitForChild("node_modules")
    :WaitForChild("@rbxts")
    :WaitForChild("net")
    :WaitForChild("out")
    :WaitForChild("_NetManaged")
    :WaitForChild("SwordHit")

local function getSword()
    return inv:FindFirstChild("wood_sword")
        or inv:FindFirstChild("noctium_blade")
        or inv:FindFirstChild("noctium_blade_2")
        or inv:FindFirstChild("noctium_blade_3")
        or inv:FindFirstChild("noctium_blade_4")
        or inv:FindFirstChild("stone_sword")
        or inv:FindFirstChild("iron_sword")
        or inv:FindFirstChild("diamond_sword")
        or inv:FindFirstChild("emerald_sword")
end

local function dist(p1, p2)
    return (p1 - p2).Magnitude
end

local function getClosestEnemy()
    local char = lp.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local lpPos = hrp.Position
    local closest = nil
    local closestDist = 35 

    for _, p in pairs(Players:GetPlayers()) do
        if p ~= lp and p.Team ~= lp.Team and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
            local pPos = p.Character.HumanoidRootPart.Position
            local d = dist(lpPos, pPos)
            if d < closestDist then
                closestDist = d
                closest = p
            end
        end
    end

    return closest, lpPos
end


local lastRayCheck = 0
local rayCheckInterval = 0.2

local function isBlocked(fromPos, toPos, target)
    if (fromPos - toPos).Magnitude > 35 then
        return false
    end

    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    rayParams.FilterDescendantsInstances = {lp.Character, target.Character}

    local rayResult = workspace:Raycast(fromPos, toPos - fromPos, rayParams)
    if rayResult then
        return true
    end
    return false
end


local lastTarget = nil
local lastBlocked = false

while true do
    local target, lpPos = getClosestEnemy()
    if not target then
        wait(0.1)
        continue
    end

    local sword = getSword()
    if not sword then
        wait(0.5)
        continue
    end

    local hrp = target.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then
        wait(0.1)
        continue
    end
    local targetPos = hrp.Position


    if target ~= lastTarget or tick() - lastRayCheck >= rayCheckInterval then
        lastTarget = target
        lastRayCheck = tick()
        lastBlocked = isBlocked(lpPos, targetPos, target)
    end

    if lastBlocked then
        wait(0.1)
        continue
    end


    local toPlayerDir = (lpPos - targetPos).Unit
    local targetLookDir = (targetPos - lpPos).Unit
    local dot = targetLookDir:Dot(toPlayerDir)
    if dot < 0 then

        wait(0.1)
        continue
    end


    local offset = toPlayerDir * 3.8
    local fakeSelfPos = lpPos + toPlayerDir * 3.8

    local args = {
        [1] = {
            entityInstance = target.Character,
            chargedAttack = { chargeRatio = 0 },
            validate = {
                targetPosition = { value = targetPos + offset },
                selfPosition = { value = fakeSelfPos }
            },
            weapon = sword
        }
    }

    net:FireServer(unpack(args))

    task.wait(0.007) 
end  
