local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")

local LocalPlayer = Players.LocalPlayer

-- ESP 토글
local ESP_ENABLED = true

-- 팀별 색상
local TEAM_COLORS = {
    Blue   = Color3.fromRGB(0, 170, 255),
    Orange = Color3.fromRGB(255, 140, 0),
    Pink   = Color3.fromRGB(255, 105, 180),
    Yellow = Color3.fromRGB(255, 255, 0)
}

-- L 키로 ESP ON / OFF
UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.L then
        ESP_ENABLED = not ESP_ENABLED
    end
end)

local function getTeamColor(player)
    if not player.Team then return nil end
    return TEAM_COLORS[player.Team.Name]
end

local function isSameTeam(player)
    return LocalPlayer.Team and player.Team == LocalPlayer.Team
end

local function createESP(player)
    if player == LocalPlayer then return end

    local function onCharacterAdded(character)
        local humanoid = character:WaitForChild("Humanoid", 10)
        local head = character:WaitForChild("Head", 10)
        local root = character:WaitForChild("HumanoidRootPart", 10)
        if not humanoid or not head or not root then return end

        -- Highlight
        local highlight = Instance.new("Highlight")
        highlight.Name = "ESPHighlight"
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = character

        -- Billboard
        local billboard = Instance.new("BillboardGui")
        billboard.Name = "ESPBillboard"
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head

        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.TextStrokeTransparency = 0
        label.TextSize = 16
        label.Font = Enum.Font.SourceSansBold
        label.Parent = billboard

        local connection
        connection = RunService.RenderStepped:Connect(function()
            if not character.Parent or humanoid.Health <= 0 then
                connection:Disconnect()
                highlight:Destroy()
                billboard:Destroy()
                return
            end

            -- ESP OFF
            if not ESP_ENABLED or isSameTeam(player) then
                highlight.Enabled = false
                billboard.Enabled = false
                return
            end

            local color = getTeamColor(player)
            if not color then return end

            highlight.Enabled = true
            billboard.Enabled = true

            highlight.FillColor = color
            highlight.OutlineColor = color
            label.TextColor3 = color

            local cam = workspace.CurrentCamera
            local distance = math.floor((root.Position - cam.CFrame.Position).Magnitude)
            local hp = math.floor(humanoid.Health)

            label.Text = string.format(
                "%s\n체력: %d | %d 스터드",
                player.Name,
                hp,
                distance
            )
        end)
    end

    player.CharacterAdded:Connect(onCharacterAdded)
    if player.Character then
        onCharacterAdded(player.Character)
    end
end

-- 기존 플레이어
for _, player in ipairs(Players:GetPlayers()) do
    createESP(player)
end

-- 새 플레이어
Players.PlayerAdded:Connect(createESP)


-- =========================
-- nofog 명령어 추가
-- =========================
addcmd('nofog', {}, function(args, speaker)
    Lighting.FogEnd = 100000
    for i, v in pairs(Lighting:GetDescendants()) do
        if v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
end)
