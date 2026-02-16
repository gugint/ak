local function _x(s) return game:GetService("Players") end 
local _a,_b,_c,_d,_e,_f,_g,_h,_i={},game:GetService("ReplicatedStorage"),game:GetService("Players").LocalPlayer,nil,nil,nil,nil,nil,nil


local _tbl={
["inv"]="Inventories",
["wpn"]="SwordHit",
["hrp"]="HumanoidRootPart"
}
_a=_b[_tbl["inv"]]:WaitForChild(_c.Name)
_e=_b.rbxts_include.node_modules["@rbxts"].net.out._NetManaged[_tbl["wpn"]]
local function _y()
 local _z={"wood_sword","noctium_blade","noctium_blade_2","noctium_blade_3","noctium_blade_4","stone_sword","iron_sword","diamond_sword","emerald_sword"}
 for _,v in ipairs(_z) do local t=_a:FindFirstChild(v) if t then return t end end
end

local function _dist(p1,p2) return (p1-p2).Magnitude end
local _last,_flag,_target=0,false,nil

repeat task.wait() do
 local tgt,pos=nil,nil
 do
  local ch=_c.Character if ch then
   local part=ch:FindFirstChild(_tbl["hrp"])
   if part then pos=part.Position end
  end
  for _,p in ipairs(_c:GetPlayers()) do
   if p~=_c and p.Team~=_c.Team then
    local ch=p.Character
    if ch then
     local part=ch:FindFirstChild(_tbl["hrp"])
     if part then
      local d=_dist(pos,part.Position)
      if d<35 then tgt=p break end
     end
    end
   end
  end
 end
 if not tgt then goto cont end
 local wpn=_y()
 if not wpn then goto cont end
 local hrp=tgt.Character:FindFirstChild(_tbl["hrp"])
 if not hrp then goto cont end
 local tpos=hrp.Position
 if tgt~=_target or tick()-_last>=0.2 then
  _target=tgt
  _last=tick()
  _flag=false 
 end
 if _flag then goto cont end
 local dir=(pos-tpos).Unit
 local look=(tpos-pos).Unit
 if look:Dot(dir)<0 then goto cont end
 local off=dir*3.8
 local fake=pos+dir*3.8
 _e:FireServer({entityInstance=tgt.Character,chargedAttack={chargeRatio=0},validate={targetPosition={value=tpos+off},selfPosition={value=fake}},weapon=wpn})
 ::cont::
end
