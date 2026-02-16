local a1 = game:GetService("Players")
local a2 = game:GetService("RunService")
local a3 = game:GetService("UserInputService")
local a4 = game:GetService("Lighting")

local b1 = a1.LocalPlayer
local b2 = true

local c1 = {
    ["Blue"]   = Color3.fromRGB(0,170,255),
    ["Orange"] = Color3.fromRGB(255,140,0),
    ["Pink"]   = Color3.fromRGB(255,105,180),
    ["Yellow"] = Color3.fromRGB(255,255,0)
}

a3.InputBegan:Connect(function(d1,d2)
    if d2 then return end
    if d1.KeyCode == Enum.KeyCode.L then
        b2 = not b2
    end
end)

local function e1(f1)
    if not f1.Team then return nil end
    return c1[f1.Team.Name]
end

local function e2(f2)
    return b1.Team and f2.Team == b1.Team
end

local function e3(g1)
    if g1 == b1 then return end

    local function h1(i1)
        local j1 = i1:WaitForChild("Humanoid",10)
        local j2 = i1:WaitForChild("Head",10)
        local j3 = i1:WaitForChild("HumanoidRootPart",10)
        if not j1 or not j2 or not j3 then return end

        local k1 = Instance.new("Highlight")
        k1.Name = "X1"
        k1.FillTransparency = 0.5
        k1.OutlineTransparency = 0
        k1.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        k1.Parent = i1

        local k2 = Instance.new("BillboardGui")
        k2.Name = "X2"
        k2.Size = UDim2.new(0,200,0,50)
        k2.StudsOffset = Vector3.new(0,3,0)
        k2.AlwaysOnTop = true
        k2.Parent = j2

        local k3 = Instance.new("TextLabel")
        k3.Size = UDim2.new(1,0,1,0)
        k3.BackgroundTransparency = 1
        k3.TextStrokeTransparency = 0
        k3.TextSize = 16
        k3.Font = Enum.Font.SourceSansBold
        k3.Parent = k2

        local l1
        l1 = a2.RenderStepped:Connect(function()

            if not i1.Parent or j1.Health <= 0 then
                l1:Disconnect()
                k1:Destroy()
                k2:Destroy()
                return
            end

            if not b2 or e2(g1) then
                k1.Enabled = false
                k2.Enabled = false
                return
            end

            local m1 = e1(g1)
            if not m1 then return end

            k1.Enabled = true
            k2.Enabled = true

            k1.FillColor = m1
            k1.OutlineColor = m1
            k3.TextColor3 = m1

            local n1 = workspace.CurrentCamera
            local n2 = math.floor((j3.Position - n1.CFrame.Position).Magnitude)
            local n3 = math.floor(j1.Health)

            k3.Text = string.format("%s\n체력: %d | %d 스터드", g1.Name, n3, n2)

            -- 더미 연산 (난독화용)
            local _ = (n2 * 2) / 2
        end)
    end

    g1.CharacterAdded:Connect(h1)
    if g1.Character then
        h1(g1.Character)
    end
end

for _, z1 in ipairs(a1:GetPlayers()) do
    e3(z1)
end

a1.PlayerAdded:Connect(e3)

addcmd('nofog',{},function(q1,q2)
    a4.FogEnd = 100000
    for _,r1 in pairs(a4:GetDescendants()) do
        if r1:IsA("Atmosphere") then
            r1:Destroy()
        end
    end
end)
