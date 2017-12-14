--[[

Reference link https://raw.githubusercontent.com/BoLFantastik/BoL/master/Fantastik%20Aatrox.lua

Thanks

]]


function OnLoad()

end



function UpdateHeroInfo()
	return GetMyChamp()
end

local Q = {range = 650, delay = 0.5, speed = 1800, width = 140,IsReady = function() return myHero:CanUseSpell(_Q) == READY end}
local W = {range = 125, IsReady = function() return myHero:CanUseSpell(_W) == READY end}
local E = {range = 1000, delay = 0.25, speed = 1000, width = 80,IsReady = function() return myHero:CanUseSpell(_E) == READY end}
local R = {range = 300, delay = 0.25, speed = math.huge, width = 100,IsReady = function() return myHero:CanUseSpell(_R) == READY end}


IncludeFile("Lib\\Vector.lua")

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local minEnemiesAround = 2
local minHealthW = 60


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
	return GetEnemyChampCanKillFastest(1000)
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

function OnCreateObject(unit)

end

function OnDeleteObject(unit)

end

function OnWndMsg(msg, key)

end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

end

function OnTick()
	if GetChampName(GetMyChamp()) ~= "Aatrox" then return end
	if IsDead(UpdateHeroInfo()) then return end

	SmartW()

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end


	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		Laneclear()
		Jungleclear()
	end

	Killsteal()
end

function Combo()
	local target = GetTarget()

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
	end

	if target ~= 0 and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
    end

	if target ~= 0 and RReady() and CanMove() and Setting_IsComboUseR() and (EnemiesAround(target, 500) <= minEnemiesAround) then
		CastR(target)
    end

end

function CastQ(Target)
	if ValidTargetRange(Target,Q.range) then
		local vp_distance = VPGetCircularCastPosition(Target, Q.delay, Q.width)
		if vp_distance > 0 and vp_distance < Q.range then
			CastSpellToPredictionPos(Target, _Q, vp_distance)
		end
	end
end

function CastE(Target)
	if ValidTargetRange(Target,E.range) then
		local vp_distance = VPGetLineCastPosition(Target, E.delay, E.speed)
		if vp_distance > 0 and vp_distance < E.range then
			CastSpellToPredictionPos(Target, _E, vp_distance)
		end
	end
end

function CastR(Target)
	if ValidTargetRange(Target,R.range) then
		CastSpellTarget(UpdateHeroInfo(), _R)
	end
end


function HealthWManager()
	if GetHealthPoint(UpdateHeroInfo()) >= GetHealthPointMax(UpdateHeroInfo()) * (minHealthW / 100) then
		return true
	else
		return false
	end
end

function SmartW()
    if Setting_IsComboUseW() then
        if not HealthWManager() and isWOn() then
            CastSpellTarget(UpdateHeroInfo(), _W)
        end
        if HealthWManager() and not isWOn() then
            CastSpellTarget(UpdateHeroInfo(), _W)
        end
    end
end

function isWOn()
	if GetSpellNameByIndex(UpdateHeroInfo(), _W) == "AatroxW2" then
		return true
    else
		return false
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

function GetMinion()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				return minion
			end
		end
	end

	return 0
end

function Laneclear()
	local minion = GetMinion()
	if minion ~= 0 then
		if QReady() and CanMove() and Setting_IsLaneClearUseQ() and CountminionsAround(minion) > 2 then
			local vp_distance = VPGetCircularCastPosition(minion, Q.delay, Q.width)
			if vp_distance > 0 and vp_distance < Q.range then
				CastSpellToPredictionPos(minion, _Q, vp_distance)
			end
		end
	end

	GetAllUnitAroundAnObject(UpdateHeroInfo(), E.range)
	local Enemies = pUnit

	if EReady() and  table.getn(Enemies) > 0 and CanMove() and Setting_IsLaneClearUseQ() then
		local EPos = GetBestEPositionFarm()
		if EPos then
			local distance = GetDistance2D(GetPosX(UpdateHeroInfo()),GetPosZ(UpdateHeroInfo()),GetPosX(EPos),GetPosZ(EPos))
			if distance > 0 and distance < E.range and CanMove() then
				CastSpellToPredictionPos(EPos, _E, distance)
			end
		end
	end

end

function CountminionsAround(minion)
	GetAllUnitAroundAnObject(minion, Q.range)
	local Enemies = pUnit

	local Max = 0

	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				Max = Max + 1
			end
		end
	end

	return Max
end

function Jungleclear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 and QReady() and CanMove() and Setting_IsLaneClearUseQ() then
		local vp_distance = VPGetCircularCastPosition(jungle, Q.delay, Q.width)
		if vp_distance > 0 and vp_distance < Q.range then
			CastSpellToPredictionPos(jungle, _Q, vp_distance)
		end
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 and EReady() and CanMove() and Setting_IsLaneClearUseE() then
		local vp_distance = VPGetLineCastPosition(jungle, E.delay, E.speed)
		if vp_distance > 0 and vp_distance < E.range then
			CastSpellToPredictionPos(jungle, _E, vp_distance)
		end
	end
end

function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function GetEnemyHeroes()
	SearchAllChamp()
	return pObjChamp
end

function Killsteal()
	for k,enemy in pairs(GetEnemyHeroes()) do
		if ValidTargetRange(enemy, Q.range) and enemy ~= 0 and QReady() and getDmg(_Q, enemy) > GetHealthPoint(enemy) and CanMove() then
			local vp_distance = VPGetCircularCastPosition(enemy, Q.delay, Q.width)
			if vp_distance > 0 and vp_distance < Q.range then
				CastSpellToPredictionPos(enemy, _Q, vp_distance)
			end
		end

		if ValidTargetRange(enemy, E.range) and enemy ~= 0 and EReady() and getDmg(_E, enemy) > GetHealthPoint(enemy) and CanMove() then
			local vp_distance = VPGetLineCastPosition(enemy, E.delay, E.speed)
			if vp_distance > 0 and vp_distance < E.range then
				CastSpellToPredictionPos(enemy, _E, vp_distance)
			end
		end


	end
end

function VPGetCircularCastPosition(Target, Delay, Width)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	local TimeMissile = Delay
	local real_distance = (TimeMissile * GetMoveSpeed(Target))
	if real_distance == 0 then
		if distance - Width/2 > 0 then
			return distance - Width/2
		end
		return distance
	end
	if real_distance - Width/2 > 0 then
		return real_distance - Width/2
	end
	return real_distance

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

function ValidTarget(Target)
	if Target ~= 0 then
		if not IsDead(Target) and not IsInFog(Target) and GetTargetableToTeam(Target) == 4 and IsEnemy(Target) then
			return true
		end
	end
	return false
end

function GetDistance(Target)
	x1 = GetPosX(UpdateHeroInfo())
	z1 = GetPosZ(UpdateHeroInfo())

	x2 = GetPosX(Target)
	z2 = GetPosZ(Target)

	return GetDistance2D(x1,z1,x2,z2)
end

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
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

function countminionshitE(obj)
	local n = 0

	local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }
	local objPos = { GetPosX(obj), GetPosY(obj), GetPosZ(obj) }

	local ExtendedVector = Vector(myHeroPos) + Vector(Vector(objPos) - Vector(myHeroPos)):Normalized()*E.range

	GetAllUnitAroundAnObject(UpdateHeroInfo(), E.range)
	local Enemies = pUnit

	for i, minion in ipairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local minionPos = {GetPosX(minion), GetPosY(minion), GetPosZ(minion)}
				local MinionPointSegment, MinionPointLine, MinionIsOnSegment =  VectorPointProjectionOnLineSegment(Vector(myHeroPos), Vector(ExtendedVector), Vector(minionPos))
				local MinionPointSegment3D = {x=MinionPointSegment.x, y=GetPosY(obj), z=MinionPointSegment.y}
				if MinionIsOnSegment and Distance(MinionPointSegment3D, obj) < E.width then
					n = n +1
				end
			end
		end
	end
	return n

end


function GetBestEPositionFarm()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), E.range)
	local Enemies = pUnit

	local MaxE = 0
	local MaxEPos
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local hitE = countminionshitE(minion)
				if hitE > MaxE or MaxEPos == nil then
					MaxEPos = minion
					MaxE = hitE
				end
			end
		end
	end

	if MaxEPos then
		return MaxEPos
	else
		return nil
	end
end


function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _Q then
		if GetSpellLevel(UpdateHeroInfo(),_Q) == 0 then return 0 end

		local DamageSpellQTable = {10, 35, 60, 95, 120}

		local Percent_Bonus_AD = 1.1

		local Damage_Bonus_AD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),_Q)]

		local Enemy_Armor = GetArmor(Enemy)

		local Dominik_ID = 3036--Lord Dominik's Regards
		local Mortal_Reminder_ID = 3033--Mortal Reminder

		if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
			Enemy_Armor = Enemy_Armor - GetBonusArmor(Enemy) * 45/100
		end

		local ArmorPenetration = 60 * GetArmorPenetration(UpdateHeroInfo()) / 100 + (1 - 60/100) * GetArmorPenetration(UpdateHeroInfo()) * GetLevel(Enemy) / 18

		Enemy_Armor = Enemy_Armor - ArmorPenetration

		if Enemy_Armor >= 0 then
			Damage = (DamageSpellQ + Percent_Bonus_AD * Damage_Bonus_AD) * (100/(100 + Enemy_Armor))
		else
			Damage = (DamageSpellQ + Percent_Bonus_AD * Damage_Bonus_AD) * (2 - 100/(100 - Enemy_Armor))
		end


		return Damage
	end

	if Spell == _E then
		if GetSpellLevel(UpdateHeroInfo(),_E) == 0 then return 0 end

		local DamageSpellQTable = {75, 115, 155, 195, 235 }

		local Percent_Bonus_AD = 0.7

		local Damage_Bonus_AD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),_E)]

		local Enemy_Armor = GetArmor(Enemy)

		local Dominik_ID = 3036--Lord Dominik's Regards
		local Mortal_Reminder_ID = 3033--Mortal Reminder

		if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
			Enemy_Armor = Enemy_Armor - GetBonusArmor(Enemy) * 45/100
		end

		local ArmorPenetration = 60 * GetArmorPenetration(UpdateHeroInfo()) / 100 + (1 - 60/100) * GetArmorPenetration(UpdateHeroInfo()) * GetLevel(Enemy) / 18

		Enemy_Armor = Enemy_Armor - ArmorPenetration

		if Enemy_Armor >= 0 then
			Damage = (DamageSpellQ + Percent_Bonus_AD * Damage_Bonus_AD) * (100/(100 + Enemy_Armor))
		else
			Damage = (DamageSpellQ + Percent_Bonus_AD * Damage_Bonus_AD) * (2 - 100/(100 - Enemy_Armor))
		end


		return Damage
	end

end
