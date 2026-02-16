
local function _x(str,k)
    local t={}
    for i=1,#str do
        t[i]=string.char(bit32.bxor(str:byte(i),k))
    end
    return table.concat(t)
end

--// 서비스
local _a=game:GetService(_x("\70\97\118\115\110",42)) 
local _b=game:GetService(_x("\83\114\119\99\118\120",42)) 
local _c=_a.LocalPlayer if not _c then return end

repeat task.wait() until _c.Character
repeat task.wait() until _c.Character:FindFirstChild(_x("\43\41\55\63\35\34\49\41\36\46\51\46",42))

local _d=20
local function _e(s)
    local ch=_c.Character if not ch then return end
    local hd=ch:FindFirstChild(_x("\56\33\36\34\57\52",42)) if not hd then return end -- Head
    local bb=hd:FindFirstChild(_x("\48\37\50\50\44\37\50\37\48\57\57",42)) if not bb then return end -- DebugBillboard
    local lbl=bb:FindFirstChildWhichIsA(_x("\56\57\52\52\43\49\47\36\36\34\57\41\36\54",42)) if not lbl then return end -- TextLabel
    lbl.Text=s
end

local _f=_b:WaitForChild(_x("\37\46\37\36\46\34\33\40\37\41",42)):WaitForChild(_c.Name) 
local _g=_b:WaitForChild(_x("\47\45\41\45\39\46\44\46\42\42\47",42))
            :WaitForChild(_x("\41\37\40\43\39\34\44",42))
            :WaitForChild(_x("\46\43\41\45\39\46\44\46\42",42))
            :WaitForChild(_x("\41\39\36\41\36\46",42))
            :WaitForChild(_x("\43\42\44\47\41\36\41\39\44\41",42))

local function _h(p1,p2) return (p1-p2).Magnitude end
local function _i()
    if not _f then return end
    local _s={_x("\63\34\35\41\36\44\41\37\36\46\36\41",42), _x("\41\36\41\37\35\42\37\36",42)} -- wood_sword, stone_sword...
    for _,v in ipairs(_s) do local w=_f:FindFirstChild(v) if w then return w end end
end

local function _j(orig,tPos,tPlr)
    local dir=tPos-orig
    local rp=RaycastParams.new()
    rp.FilterDescendantsInstances={_c.Character,tPlr.Character}
    rp.FilterType=Enum.RaycastFilterType.Blacklist
    rp.IgnoreWater=true
    return workspace:Raycast(orig,dir,rp)~=nil
end

local _k,_l,_m=nil,0,false
local _n=0.15

repeat task.wait(0.07) do
    if not _c.Character or not _c.Character:FindFirstChild(_x("\43\41\55\63\35\34\49\41\36\46\51\46",42)) then goto cont end
    local swd=_i()
    if not swd then _e(_x("\46\36\35\44\41\36",42)) goto cont end 
    local lpPos=_c.Character:FindFirstChild(_x("\43\41\55\63\35\34\49\41\36\46\51\46",42)).Position
    for _,p in pairs(_a:GetPlayers()) do
        if p~=_c and p.Character and p.Character:FindFirstChild(_x("\43\41\55\63\35\34\49\41\36\46\51\46",42)) and p.Team~=_c.Team then
            local pPos=p.Character:FindFirstChild(_x("\43\41\55\63\35\34\49\41\36\46\51\46",42)).Position
            if _h(lpPos,pPos)<=_d then
                local tgt=p
                if tgt~=_k or tick()-_l>=_n then
                    _k=tgt
                    _l=tick()
                    _m=_j(lpPos,pPos,tgt)
                end
                if _m then task.wait(0.1) goto cont end
                _e(_x("\53\36\33\57\41\44\34\35\46\37\41\44",42)..tgt.Name) 
                local dir=(pPos-lpPos).Unit
                local off=(lpPos-pPos).Unit*3.8
                local _on=lpPos+dir*3.8 -- fakePos → _on
                _g:FireServer({[1]={entityInstance=tgt.Character,chargedAttack={chargeRatio=0},validate={targetPosition={value=pPos+off},selfPosition={value=_on}},weapon=swd}})
            end
        end
    end
    ::cont::
end
