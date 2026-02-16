local _0xA=game:GetService("Players");local _0xB=game:GetService("RunService");local _0xC=game:GetService("UserInputService");local _0xD=game:GetService("Lighting")
local _0xE=_0xA.LocalPlayer;local _0xF=true

local function _0xS(t)return string.char(table.unpack(t))end

local _0xT={
    [_0xS({66,108,117,101})]=Color3.fromRGB(0,170,255),
    [_0xS({79,114,97,110,103,101})]=Color3.fromRGB(255,140,0),
    [_0xS({80,105,110,107})]=Color3.fromRGB(255,105,180),
    [_0xS({89,101,108,108,111,119})]=Color3.fromRGB(255,255,0)
}

local function _0xJ(x)return (x*3.14159%7)/2 end

_0xC.InputBegan:Connect(function(_0x1,_0x2)
    if _0x2 then return end
    if _0x1.KeyCode==Enum.KeyCode.L then
        _0xF=not _0xF
    end
end)

local function _0xK(p)
    if not p.Team then return nil end
    return _0xT[p.Team.Name]
end

local function _0xL(p)
    return _0xE.Team and p.Team==_0xE.Team
end

local function _0xM(p)
    if p==_0xE then return end

    local function _0xN(c)
        local h=c:WaitForChild("Humanoid",10)
        local hd=c:WaitForChild("Head",10)
        local hrp=c:WaitForChild("HumanoidRootPart",10)
        if not h or not hd or not hrp then return end

        local hi=Instance.new("Highlight")
        hi.Name=_0xS({88,49})
        hi.FillTransparency=0.5
        hi.OutlineTransparency=0
        hi.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
        hi.Parent=c

        local bg=Instance.new("BillboardGui")
        bg.Name=_0xS({88,50})
        bg.Size=UDim2.new(0,200,0,50)
        bg.StudsOffset=Vector3.new(0,3,0)
        bg.AlwaysOnTop=true
        bg.Parent=hd

        local tl=Instance.new("TextLabel")
        tl.Size=UDim2.new(1,0,1,0)
        tl.BackgroundTransparency=1
        tl.TextStrokeTransparency=0
        tl.TextSize=16
        tl.Font=Enum.Font.SourceSansBold
        tl.Parent=bg

        local con
        con=_0xB.RenderStepped:Connect(function()

            if not c.Parent or h.Health<=0 then
                con:Disconnect()
                hi:Destroy()
                bg:Destroy()
                return
            end

            if not _0xF or _0xL(p) then
                hi.Enabled=false
                bg.Enabled=false
                return
            end

            local col=_0xK(p)
            if not col then return end

            hi.Enabled=true
            bg.Enabled=true

            hi.FillColor=col
            hi.OutlineColor=col
            tl.TextColor3=col

            local cam=workspace.CurrentCamera
            local dist=math.floor((hrp.Position-cam.CFrame.Position).Magnitude)
            local hp=math.floor(h.Health)

            tl.Text=string.format("%s\nHP:%d | %d",p.Name,hp,dist)

            local _=_0xJ(dist)
            if _==9999 then print("never") end
        end)
    end

    p.CharacterAdded:Connect(_0xN)
    if p.Character then
        _0xN(p.Character)
    end
end

for _,v in ipairs(_0xA:GetPlayers()) do
    _0xM(v)
end

_0xA.PlayerAdded:Connect(_0xM)

addcmd('nofog',{},function()
    _0xD.FogEnd=100000
    for _,v in pairs(_0xD:GetDescendants()) do
        if v:IsA("Atmosphere") then
            v:Destroy()
        end
    end
end)
