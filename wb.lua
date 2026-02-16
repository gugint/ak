local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lp = Players.LocalPlayer

local function setDebugText(text)
    local char = lp.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local billboard = head:FindFirstChild("DebugBillboard")
    if not billboard then return end
    local label = billboard:FindFirstChildWhichIsA("TextLabel")
    if not label then return end
    label.Text = text
end

-- 이미 캐릭터에 BillboardGui가 있다고 가정
local inv = ReplicatedStorage.Inventories:FindFirstChild(lp.Name)
local net = ReplicatedStorage.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit

local range = 20

local function getSword()
    return inv:FindFirstChild("wood_sword") or
           inv:FindFirstChild("stone_sword") or
           inv:FindFirstChild("iron_sword") or
           inv:FindFirstChild("diamond_sword") or
           inv:FindFirstChild("emerald_sword")
end

local function dist(p1, p2)
    return (p1 - p2).Magnitude
end

while true do
    local sword = getSword()
    if sword then
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                local pPos = p.Character.HumanoidRootPart.Position
                local lpPos = lp.Character.HumanoidRootPart.Position
                if dist(lpPos, pPos) <= range and p.Team ~= lp.Team then

                    -- 공격 이벤트 호출 전 디버깅
                    setDebugText("Firing: "..p.Name)

                    local args = {
                        [1] = {
                            ["entityInstance"] = p.Character,
                            ["chargedAttack"] = {
                                ["chargeRatio"] = 0
                            },
                            ["validate"] = {
                                ["targetPosition"] = {
                                    ["value"] = pPos
                                },
                                ["selfPosition"] = {
                                    ["value"] = lpPos
                                }
                            },
                            ["weapon"] = sword
                        }
                    }
                    net:FireServer(unpack(args))
                end
            end
        end
    else
        setDebugText("검 없음")
    end
    task.wait(0.07)
end
