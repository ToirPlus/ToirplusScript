--[[

Reference link  https://github.com/Dienofail/BoL/blob/master/KogMaw.lua

Thanks Dienofail

]]

IncludeFile("Lib\\Vector.lua")


--__PrintDebug(GetChampName(UpdateHeroInfo()))
function UpdateHeroInfo()
	return GetMyChamp()
end




-- Configuration ----------------------------------------------------------------------------------------------

local Q = 0
local W = 1
local E = 2
local R = 3

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86


local config_Combo_RStacks = 8
local config_Harass_RStacks = 2
local config_AutoUlt = false

local ComboUseMana = 30
local HarassUseMana = 60

-- Game Data ---------------------------------------------------------------------------------------------------

local SpellQ = {Speed = 1550, Range = 925, Delay = 0.3667, Width = 60}
local SpellW = {Speed = 1600, Range = 1000, Delay = 0.111, Width = 55}
local SpellE = {Speed = 1400, Range = 1280, Delay = 0.066, Width = 120}
local SpellR = {Width = 150, Speed = math.huge, Delay= 1.1}
local RRangeTable = {1400, 1700, 2200}
local WRange, RRange = nil, nil
local QReady, WReady, EReady, RReady = nil, nil, nil, nil
local RStacks = 0
local WRangeTable = {130, 150, 170, 190, 210}


function QReady()
	return CanCast(Q)
end

function WReady()
	return CanCast(W)
end

function EReady()
	return CanCast(E)
end

function RReady()
	return CanCast(R)
end

function GetTarget()
	return GetEnemyChampCanKillFastest(1800)
end

-- Script function ---------------------------------------------------------------------------------------------

function Check()
	if GetSpellLevel(UpdateHeroInfo(),R) > 0 then
		RRange = RRangeTable[GetSpellLevel(UpdateHeroInfo(),R)]
	end
	if GetSpellLevel(UpdateHeroInfo(),W) > 0 then
		WRange = 500 + WRangeTable[GetSpellLevel(UpdateHeroInfo(),W)]
	end
	--RStacks = GetBuffCount(UpdateHeroInfo(), "kogmawlivingartillerycost")
end

function SpellQCollision(Target, Delay, Width, Range, Speed, vp_distance)

	local PredPosX = GetPredictionPosX(Target, vp_distance)
	local PredPosZ = GetPredictionPosZ(Target, vp_distance)

	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local nCountMinionCollision = 0


	if PredPosX ~= 0 and PredPosZ ~= 0 then

		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, PredPosX, PredPosZ, Width, Range, 10)
	else

		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, x2, z2, Width, Range, 10)
	end

	if nCountMinionCollision == 0 then
		return false
	end

	return true

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

function VPGetLineCastPosition(Target, Delay, Width, Range, Speed)
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


function CastQ(Target)
	if Target ~= 0 and ValidTarget(Target, 1300) and QReady() then

		local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)

		if vp_distance > 0 and vp_distance < SpellQ.Range then
			if not SpellQCollision(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed, vp_distance) then

				CastSpellToPredictionPos(Target, Q, vp_distance)
			end
		end
	end
end

function CastW(Target)
	if Target ~= 0 and ValidTargetRange(Target, 1300) and WReady() and GetDistance(Target) < WRange then

		CastSpellTarget(UpdateHeroInfo(), W)
	end
end

function CastE(Target)
	if Target ~= 0 and ValidTargetRange(Target, 1300) and EReady() then

		local vp_distance = VPGetLineCastPosition(Target, SpellE.Delay, SpellE.Width, SpellE.Range, SpellE.Speed)

		if vp_distance > 0 and vp_distance < SpellE.Range then

			CastSpellToPredictionPos(Target, E, vp_distance)
		end
	end
end

function CastR(Target)
	if Target ~= 0 and RReady() and ValidTargetRange(Target, 1800) then

		local vp_distance = VPGetCircularCastPosition(Target, SpellR.Delay, SpellR.Width)

		if vp_distance > 0 and vp_distance < RRange and RStacks < config_Combo_RStacks and not IsMyManaLowCombo() then

			CastSpellToPredictionPos(Target, R, vp_distance)
			--RStacks = GetBuffCount(UpdateHeroInfo(), "kogmawlivingartillerycost")
		end
	end
end

function Combo()
	local Target = GetTarget()

	if QReady() and Setting_IsComboUseQ() and not IsMyManaLowCombo() and CanMove() then
		CastQ(Target)
	end

	if WReady() and Setting_IsComboUseW() then
		CastW(Target)
	end

	if EReady() and Setting_IsComboUseE() and not IsMyManaLowCombo() and CanMove() then
		CastE(Target)
	end

	if RReady() and Setting_IsComboUseR() and not IsMyManaLowCombo() and CanMove() then
		CastR(Target)
	end
end

function Harass()
	local Target = GetTarget()
	if QReady() and Setting_IsHarassUseQ() and not IsMyManaLowHarass() and CanMove() then
		CastQ(Target)
	end

	if EReady() and Setting_IsHarassUseE() and not IsMyManaLowHarass() and CanMove() then
		CastE(Target)
	end

	if RReady() and Setting_IsHarassUseR() and RStacks < config_Harass_RStacks and not IsMyManaLowHarass() and CanMove() then
		CastR(Target)
	end

	if WReady() and Setting_IsHarassUseW() then
		CastW(Target)
	end
end


function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "KogMaw" then return end
	--__PrintTextGame("KogMaw: OnTick() --------------")
	Check()

	local nKeyCode = GetKeyCode()

	--__PrintTextGame("nKeyCode: OnTick(): ".. tostring(nKeyCode))

	if nKeyCode == SpaceKeyCode then
		SetLuaCombo(true)
		Combo()
	end

	if nKeyCode == CKeyCode then
		SetLuaHarass(true)
		Harass()
	end

	if nKeyCode == VKeyCode then
		Farm()
	end

	CheckDashes()

	if config_AutoUlt then
		AutoUlt()
	end

	KillSteal()
end


function AutoUlt()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if RReady() and ValidTargetRange(enemy, 1400) and GetDistance(enemy) < 1400 and CanMove() then
				local vp_distance = VPGetCircularCastPosition(enemy, SpellR.Delay, SpellR.Width)
				if vp_distance > 0 and vp_distance < RRange and RStacks < config_Harass_RStacks then
					CastSpellToPredictionPos(enemy, R, vp_distance)
					--RStacks = GetBuffCount(UpdateHeroInfo(), "kogmawlivingartillerycost")
				end
			end
		end
	end
end

function CheckDashes()
	SearchAllChamp()
	local Enemies = pObjChamp
	for idx, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if EReady() and ValidTarget(enemy) and GetDistance(enemy) < SpellE.Range and CanMove() then
				local vp_distance = VPGetLineCastPosition(enemy, SpellE.Delay, SpellE.Width, SpellE.Range, SpellE.Speed)
				if vp_distance > 0 and IsDashing(enemy) and vp_distance < SpellE.Range then
					CastSpellToPredictionPos(enemy, E, vp_distance)
				end
			end
		end
	end
end

function KillSteal()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in pairs(Enemies) do
		if enemy ~= 0 then
			if ValidTargetRange(enemy, 1800) and GetDistance(enemy) < 1800 then
				if QReady and getDmg(Q, enemy) > GetHealthPoint(enemy) and CanMove() then
					CastQ(enemy)
				end

				if EReady and getDmg(E, enemy) > GetHealthPoint(enemy) and CanMove() then
					CastE(enemy)
				end

				if RReady and getDmg(R, enemy) > GetHealthPoint(enemy) and CanMove() then
					CastR(enemy)
				end
			end
		end
	end

end

function IsMyManaLowCombo()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( ComboUseMana / 100)) then
        return true
    else
        return false
    end
end

function IsMyManaLowHarass()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( HarassUseMana / 100)) then
        return true
    else
        return false
    end
end

function Farm()
	if Setting_IsLaneClearUseE() then
		FarmE()
	end
	if Setting_IsLaneClearUseW() then
		FarmW()
	end
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

	local ExtendedVector = Vector(myHeroPos) + Vector(Vector(objPos) - Vector(myHeroPos)):Normalized()*SpellE.Range

	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellE.Range)
	local Enemies = pUnit

	for i, minion in ipairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local minionPos = {GetPosX(minion), GetPosY(minion), GetPosZ(minion)}
				local MinionPointSegment, MinionPointLine, MinionIsOnSegment =  VectorPointProjectionOnLineSegment(Vector(myHeroPos), Vector(ExtendedVector), Vector(minionPos))
				local MinionPointSegment3D = {x=MinionPointSegment.x, y=GetPosY(obj), z=MinionPointSegment.y}
				if MinionIsOnSegment and Distance(MinionPointSegment3D, obj) < SpellQ.Width then
					n = n +1
				end
			end
		end
	end
	return n

end

function GetBestEPositionFarm()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellE.Range)
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


function FarmE()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellE.Range)
	local Enemies = pUnit

	if EReady() and  table.getn(Enemies) > 0 then
		local EPos = GetBestEPositionFarm()
		if EPos then
			local distance = GetDistance2D(GetPosX(UpdateHeroInfo()),GetPosZ(UpdateHeroInfo()),GetPosX(EPos),GetPosZ(EPos))
			if distance > 0 and distance < SpellE.Range and CanMove() then
				CastSpellToPredictionPos(EPos, E, distance)
			end
		end
	end

end

function FarmW()
	local jungle_monster = GetJungleMonster(1000)

	if WReady() and (CountEnemyMinionAroundObject(UpdateHeroInfo(), 1000) > 2 or jungle_monster ~= 0) then
		CastSpellTarget(UpdateHeroInfo(), W)
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		if GetSpellLevel(UpdateHeroInfo(),Q) == 0 then return 0 end
		local DamageSpellQTable = {80, 130, 180, 230, 280}
		local Percent_AP = 0.5

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),Q)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellQ + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellQ + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == E then
		if GetSpellLevel(UpdateHeroInfo(),E) == 0 then return 0 end
		local DamageSpellETable = {60, 105, 150, 195, 240}
		local Percent_AP = 0.5

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellE = DamageSpellETable[GetSpellLevel(UpdateHeroInfo(),E)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellE + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellE + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == R then
		if GetSpellLevel(UpdateHeroInfo(),R) == 0 then return 0 end
		local DamageSpellRTable = {100, 140, 180}
		local Percent_AP = 0.25

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local BonusAD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local Percent_BonusAD = 0.65

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(UpdateHeroInfo(),R)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_BonusAD * BonusAD + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_BonusAD * BonusAD + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		local PercentHP = 100 * GetHealthPoint(UpdateHeroInfo())/GetHealthPointMax(UpdateHeroInfo())

		if PercentHP < 40 then
			Damage = 2 * Damage
		else
			if (1 + (100 - PercentHP) * 0.0083) < 1.5 then
				Damage = (1 + (100 - PercentHP) * 0.0083)*Damage
			else
				Damage = 1.5*Damage
			end
		end

		return Damage
	end

end

-------------------------- have to ---------------------------------------------
function OnLoad()
	__PrintTextGame("KogMawRework v1.4 loaded")
end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)
	if GetBuffName(buff) == "kogmawlivingartillerycost" and unit == GetMyChamp() then
		RStacks = stacks
	end
end

function OnRemoveBuff(unit, buff)
end

function OnProcessSpell(unit, spell)
end

function OnCreateObject(unit)
end

function OnDeleteObject(unit)
end













