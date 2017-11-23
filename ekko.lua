--[[

Reference link https://github.com/nebelwolfi/BoL/blob/master/SPlugins/Ekko.lua

Thanks

]]


function UpdateHeroInfo()
	return GetMyChamp()
end

IncludeFile("Lib\\Vector.lua")

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86


local LaneClearUseMana = 40

local objTrackList = {
      "Ekko",
      "Ekko_Base_Q_Aoe_Dilation.troy",
      "Ekko_Base_W_Detonate_Slow.troy",
      "Ekko_Base_W_Indicator.troy",
      "Ekko_Base_W_Cas.troy"
    }
local objTimeTrackList = {
      math.huge,
      1.565,
      1.70,
      3,
      1
    }
local objHolder = {}
local objTimeHolder = {}

function QReady()
	return CanCast(_Q)
end

function WReady()
	return CanCast(_W)
end

function EReady()
	return CanCast(_E)
end

function RReady()
	return CanCast(_R)
end

function GetTarget()
	return GetEnemyChampCanKillFastest(995)
end

function GetTarget3()
	return GetEnemyChampCanKillFastest(900)
end

function GetTarget2()
	return GetEnemyChampCanKillFastest(1900)
end

function OnLoad()
end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)
end

function OnRemoveBuff(unit, buff)
end

function OnProcessSpell(unit, spell)
end

function OnWndMsg(msg, key)

end

function OnCreateObject(unit)
	if unit.Addr ~= 0 then
      for _,name in pairs(objTrackList) do
        if GetObjName(unit.Addr) == name then
          objHolder[unit.Addr] = unit.Addr
          objTimeHolder[unit.Addr] = GetTimeGame() + objTimeTrackList[_]
        end
      end
    end
end

function OnDeleteObject(unit)
	if unit.Addr ~= 0 then
      for _,name in pairs(objTrackList) do
        if GetObjName(unit.Addr) == name then
          objHolder[unit.Addr] = nil
        end
      end
    end
end

local data = {
      [_Q] = { speed = 1050, delay = 0.25, range = 925, width = 140, collision = false, aoe = false, type = "linear", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 15*level+45+0.2*AP end},
      [_W] = { speed = math.huge, delay = 2, range = 1050, width = 450, collision = false, aoe = true, type = "circular"},
      [_E] = { delay = 0.50, range = 350, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 30*level+20+0.2*AP+TotalDmg end},
      [_R] = { speed = math.huge, delay = 0.5, range = 0, width = 400, collision = false, aoe = true, type = "circular", dmgAP = function(AP, level, Level, TotalDmg, source, target) return 150*level+50+1.3*AP end}
    }



function OnTick()
	if GetChampName(GetMyChamp()) ~= "Ekko" then return end
	if IsDead(UpdateHeroInfo()) then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end


	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end

	Killsteal()
end

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function LaneClear()
	if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() and CanMove() then
		local QPos = GetBestEPositionFarm()
		if QPos then
			local distance = GetDistance2D(GetPosX(UpdateHeroInfo()),GetPosZ(UpdateHeroInfo()),GetPosX(QPos),GetPosZ(QPos))
			if distance > 0 and distance < data[0].range then
				CastSpellToPredictionPos(QPos, _Q, data[0].range)
			end
		end
    end

	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < data[0].range then
				local vp_distance = VPGetLineCastPosition(jungle, data[0].delay, data[0].width)
				if vp_distance > 0 and vp_distance < data[0].range then
					CastSpellToPredictionPos(jungle, _Q, data[0].range)
				end
			end
		end
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if WReady() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() and CanMove() then
			if ValidTargetJungle(jungle) then
				CastSpellToPos(GetPosX(jungle), GetPosZ(jungle), _W)
			end
		end
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if EReady() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() and CanMove() then
			if ValidTargetJungle(jungle) then
				local BestPos = Vector({GetPosX(jungle), GetPosZ(jungle), GetPosZ(jungle)}) - (Vector({GetPosX(jungle), GetPosZ(jungle), GetPosZ(jungle)}) - Vector({GetPosX(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo())})):Perpendicular():Normalized() * 350
				if BestPos then
					CastSpellToPos(BestPos.x, BestPos.z, _E)
				else
					CastSpellToPos(GetCursorPosX(), GetCursorPosZ(), _E)
				end
			end
		end
	end
end

function ValidTargetJungle(Target)
	if Target ~= 0 then
		if not IsDead(Target) and not IsInFog(Target) and GetTargetableToTeam(Target) == 4 and IsJungleMonster(Target) then
			return true
		end
	end
	return false
end

function VectorPointProjectionOnLineSegment(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = { x = ax + rL * (bx - ax), z = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), z = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

function Distance(MinionPointSegment3D, pos)
	return GetDistance2D(MinionPointSegment3D.x,MinionPointSegment3D.z,GetPosX(pos),GetPosZ(pos))
end

function countminionshitQ(obj)
	local n = 0

	local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }
	local objPos = { GetPosX(obj), GetPosY(obj), GetPosZ(obj) }

	local ExtendedVector = Vector(myHeroPos) + Vector(Vector(objPos) - Vector(myHeroPos)):Normalized()*data[0].range

	GetAllUnitAroundAnObject(UpdateHeroInfo(), data[0].range)
	local Enemies = pUnit

	for i, minion in ipairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local minionPos = {GetPosX(minion), GetPosY(minion), GetPosZ(minion)}
				local MinionPointSegment, MinionPointLine, MinionIsOnSegment =  VectorPointProjectionOnLineSegment(Vector(myHeroPos), Vector(ExtendedVector), Vector(minionPos))
				local MinionPointSegment3D = {x=MinionPointSegment.x, y=GetPosY(obj), z=MinionPointSegment.y}
				if MinionIsOnSegment and Distance(MinionPointSegment3D, obj) < data[0].width then
					n = n +1
				end
			end
		end
	end
	return n

end

function GetBestEPositionFarm()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), data[0].range)
	local Enemies = pUnit

	local MaxQ = 0
	local MaxQPos
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local hitQ = countminionshitQ(minion)
				if hitQ > MaxQ or MaxQPos == nil then
					MaxQPos = minion
					MaxQ = hitQ
				end
			end
		end
	end

	if MaxQPos then
		return MaxQPos
	else
		return nil
	end
end


function Combo()
	local target = GetTarget3()
	local Qtarget = GetTarget()
	local Wtarget = GetTarget2()


	if Qtarget ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(Qtarget)
	end

     if Wtarget ~= 0 and WReady() and CanMove() and Setting_IsComboUseW() then
		if GetDistance(Wtarget) < data[1].range then
			CastW(Wtarget)
		end
     end

	if EReady() and ValidTargetRange(Wtarget,data[2].range+GetOverrideCollisionRadius(UpdateHeroInfo())*2*2) and CanMove() and Setting_IsComboUseE() then
		local BestPos = Vector({GetPosX(target), GetPosZ(target), GetPosZ(target)}) - (Vector({GetPosX(target), GetPosZ(target), GetPosZ(target)}) - Vector({GetPosX(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo())})):Perpendicular():Normalized() * 350
		if BestPos then
			CastSpellToPos(BestPos.x, BestPos.z, _E)
		else
			CastSpellToPos(GetCursorPosX(), GetCursorPosZ(), _E)
		end
    end

end

function CastQ(Target)
	if ValidTarget(Target) then
		local vp_distance = VPGetLineCastPosition(Target, data[_Q].delay, data[_Q].speed)
		if vp_distance > 0 and vp_distance < data[_Q].range  then
			CastSpellToPredictionPos(Target, _Q, data[_Q].range)
		end
	end
end

function CastW(Target)
	if ValidTarget(Target) then
		CastSpellToPos(GetPosX(Target), GetPosZ(Target), _W)
	end
end

function VPGetLineCastPosition(Target, Delay, Speed)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	local TimeMissile = Delay + distance/Speed
	local real_distance = (TimeMissile * GetMoveSpeed(Target))

	if real_distance == 0 then return distance end
	return real_distance

end

function GetDistance2Pos(x1, z1, x2, z2)

	return GetDistance2D(x1,z1,x2,z2)
end

function GetDistance(Target)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	return GetDistance2D(x1,z1,x2,z2)
end

function ValidTarget(Target)
	if Target ~= 0 then
		if not IsDead(Target) and not IsInFog(Target) and GetTargetableToTeam(Target) == 4 and IsEnemy(Target) then
			return true
		end
	end
	return false
end

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end

function GetEnemyHeroes()
	SearchAllChamp()
	return pObjChamp
end

function Killsteal()
	for k,enemy in pairs(GetEnemyHeroes()) do
		if ValidTarget(enemy) and enemy ~= 0 and RReady() and getDmg(_R, enemy) > GetHealthPoint(enemy) and CanMove() and GetTwin() and GetDistance2Pos(GetPosX(GetTwin()), GetPosZ(GetTwin()), GetPosX(enemy), GetPosZ(enemy)) < 375 then
			CastSpellTarget(UpdateHeroInfo(), _R)
		end
	end
end

 function GetTwin()
    local twin = nil
    for _,k in pairs(objHolder) do
      if k and GetObjName(k) == "Ekko" then
        twin = k
      end
    end
    return twin
  end

function getDmg(Spell, Enemy)
	local Damage = 0


	if Spell == _R then
		if GetSpellLevel(UpdateHeroInfo(),_R) == 0 then return 0 end
		local DamageSpellRTable = { 200, 350, 500 }
		local Percent_AP = 1.3

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(UpdateHeroInfo(),_R)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end
