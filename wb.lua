local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local lp = Players.LocalPlayer
local inv = ReplicatedStorage.Inventories:WaitForChild(lp.Name)

local net = ReplicatedStorage
    .rbxts_include
    .node_modules["@rbxts"]
    .net.out._NetManaged
    .SwordHit

local function getSword()
    return inv:FindFirstChild("wood_sword")
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
    local closestDist = math.huge

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


while true do
    local target, lpPos = getClosestEnemy()
    if not target then
        wait(0.2)
        continue
    end

    local sword = getSword()
    if not sword then
        wait(0.5) 
        continue
    end

    local targetPos = target.Character.HumanoidRootPart.Position
    local offset = (lpPos - targetPos).Unit * 3.8

    local args = {
        [1] = {
            entityInstance = target.Character,
            chargedAttack = { chargeRatio = 0 },
            validate = {
                targetPosition = { value = targetPos + offset },
                selfPosition = { value = lpPos }
            },
            weapon = sword
        }
    }

    net:FireServer(unpack(args))

    wait(0.01) 
end
