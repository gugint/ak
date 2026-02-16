--// Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Local Player 대기
local lp = Players.LocalPlayer
if not lp then return end

repeat task.wait() until lp.Character
repeat task.wait() until lp.Character:FindFirstChild("HumanoidRootPart")

local range = 20

--// Debug 텍스트
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

--// 안전한 경로 대기
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

--// 거리 계산
local function dist(p1, p2)
    return (p1 - p2).Magnitude
end

--// 검 찾기
local function getSword()
    if not inv then return nil end
    return inv:FindFirstChild("wood_sword")
        or inv:FindFirstChild("stone_sword")
        or inv:FindFirstChild("iron_sword")
        or inv:FindFirstChild("diamond_sword")
        or inv:FindFirstChild("emerald_sword")
end

--// 메인 루프
while task.wait(0.07) do

    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        continue
    end

    local sword = getSword()

    if sword then
        local lpPos = lp.Character.HumanoidRootPart.Position

        for _, p in pairs(Players:GetPlayers()) do
            if p ~= lp
            and p.Character
            and p.Character:FindFirstChild("HumanoidRootPart")
            and p.Team ~= lp.Team then

                local pPos = p.Character.HumanoidRootPart.Position

                if dist(lpPos, pPos) <= range then

                    setDebugText("Firing: "..p.Name)

                    net:FireServer({
                        entityInstance = p.Character,
                        chargedAttack = {
                            chargeRatio = 0
                        },
                        validate = {
                            targetPosition = { value = pPos },
                            selfPosition = { value = lpPos }
                        },
                        weapon = sword
                    })

                end
            end
        end
    else
        setDebugText("검 없음")
    end
end
