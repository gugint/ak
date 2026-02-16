local _A = game:GetService("Players")
local _B = game:GetService("ReplicatedStorage")

local _C = _A.LocalPlayer
local _D = _B.Inventories:WaitForChild(_C.Name)

local _E = _B.rbxts_include.node_modules["@rbxts"].net.out._NetManaged.SwordHit

local function _F()
    local _G = {
        "wood_sword","noctium_blade","noctium_blade_2","noctium_blade_3",
        "noctium_blade_4","stone_sword","iron_sword","diamond_sword","emerald_sword"
    }
    for _,v in ipairs(_G) do
        local _H = _D:FindFirstChild(v)
        if _H then return _H end
    end
end

local function _I(a,b)
    return (a-b).Magnitude
end

local function _J()
    local _K = _C.Character
    if not _K then return end
    local _L = _K:FindFirstChild("HumanoidRootPart")
    if not _L then return end
    local _M = _L.Position

    local _N,_O = nil,35

    for _,_P in ipairs(_A:GetPlayers()) do
        if _P ~= _C and _P.Team ~= _C.Team then
            local _Q = _P.Character
            if _Q and _Q:FindFirstChild("HumanoidRootPart") then
                local _R = _Q.HumanoidRootPart.Position
                local _S = _I(_M,_R)
                if _S < _O then
                    _O = _S
                    _N = _P
                end
            end
        end
    end

    return _N,_M
end

local _T = 0
local _U = 0.2
local _V,_W = nil,false

local function _X(_Y,_Z,_a)
    if (_Y-_Z).Magnitude > 35 then return false end
    local _b = RaycastParams.new()
    _b.FilterType = Enum.RaycastFilterType.Blacklist
    _b.FilterDescendantsInstances = {_C.Character,_a.Character}
    return workspace:Raycast(_Y,_Z-_Y,_b) ~= nil
end

while task.wait() do
    local _c,_d = _J()
    if not _c then continue end

    local _e = _F()
    if not _e then continue end

    local _f = _c.Character and _c.Character:FindFirstChild("HumanoidRootPart")
    if not _f then continue end
    local _g = _f.Position

    if _c ~= _V or (tick()-_T) >= _U then
        _V = _c
        _T = tick()
        _W = _X(_d,_g,_c)
    end
    if _W then continue end

    local _h = (_d-_g).Unit
    local _i = (_g-_d).Unit
    if _i:Dot(_h) < 0 then continue end

    local _j = _h*3.8
    local _k = _d+_j

    _E:FireServer({
        entityInstance = _c.Character,
        chargedAttack = {chargeRatio = 0},
        validate = {
            targetPosition = {value = _g+_j},
            selfPosition = {value = _k}
        },
        weapon = _e
    })

    task.wait(0.007)
end
