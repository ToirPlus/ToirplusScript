--[[

Reference link https://raw.githubusercontent.com/tungkh1711/bolscript/master/Sejuani-Montage.lua

Thanks Celtech team

]]


--IncludeFile("Lib\\Vector.lua")

function UpdateHeroInfo()
	return GetMyChamp()
end

local LaneClearUseMana = 40

local config_R_InTurret = false

config_R_InTurret  = AddMenuCustom(1, config_R_InTurret, "R In Turret")

local Q = 0
local W = 1
local E = 2
local R = 3

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local AARange = 150
local Ranges = {Q = 650,      W = 350,         E = 1000,     R = 1100  }
local Widths = {Q = 75,       W = 350,         E = 0,        R = 150   }
local Delays = {Q = 0.25,     W = 0.5,         E = 0.25,     R = 0.25  }
local Speeds = {Q = 2000,     W = 1500,        E = 2000,     R = 1500  }
local RWidth = {150, 250, 350}


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
	return GetEnemyChampCanKillFastest(1300)
end

function OnLoad()
	__PrintTextGame("Sejuani v1.0 loaded")
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

function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Sejuani" then return end
	if IsDead(UpdateHeroInfo()) then return end

	local nKeyCode = GetKeyCode()

	if nKeyCode == SpaceKeyCode then
		SetLuaCombo(true)
		Combo()
	end


	if nKeyCode == VKeyCode then
		JungClear()
	end

	KillSteal()

	AutoE()
end


function AutoE()
	if EReady() then
	    SearchAllChamp()
		for i, enemy in ipairs(pObjChamp) do
			if enemy ~= 0 and ValidTarget(enemy) and GetDistance(enemy) <= Ranges.E and CanMove() then
				CastE(enemy)
			end
		end
	end
end

function KillSteal()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, Target in pairs(Enemies) do
		if Target ~= 0 then
			if ValidTarget(Target) then
				if EReady() and getDmg(E, Target) > GetHealthPoint(Target) and CanMove() then
					CastE(Target)
				end

				if QReady() and getDmg(Q, Target) > GetHealthPoint(Target) and CanMove() then
					CastQ(Target)
				end

				if RReady() and getDmg(R, Target) > GetHealthPoint(Target) and CanMove() then
					local vp_distance = VPGetLineCastPosition(Target, Delays.R, Widths.R, Ranges.R, Speeds.R)
					if vp_distance > 0 and vp_distance < Ranges.R then
						CastSpellToPredictionPos(Target, R, vp_distance)
					end
				end

			end
		end
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		if GetSpellLevel(UpdateHeroInfo(),Q) == 0 then return 0 end
		local DamageSpellQTable = { 60, 90, 120, 150, 180}
		local Percent_AP = 0.4

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
		local DamageSpellETable = {20, 30, 40, 50, 60}
		local Percent_AP = 0.3

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
		local DamageSpellRTable = {100, 125, 150 }
		local Percent_AP = 0.4

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

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
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

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function JungClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if WReady() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < Ranges.W and Setting_IsLaneClearUseW() and not IsMyManaLowLaneClear() then
				local vp_distance = VPGetLineCastPosition(jungle, Delays.W, Widths.W, Ranges.W, Speeds.W)
				if vp_distance > 0 and vp_distance < Ranges.W then
					CastSpellToPredictionPos(jungle, W, vp_distance)
				end
			end
		end

		if QReady() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < Ranges.Q and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
				local vp_distance = VPGetLineCastPosition(jungle, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q)
				if vp_distance > 0 and vp_distance < Ranges.Q then
					CastSpellToPredictionPos(jungle, Q, vp_distance)
				end
			end
		end

		if EReady() and CanMove() then
			if ValidTargetJungle(jungle) and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				CastSpellTarget(jungle, E)
			end
		end

	end
end



function Combo()
	local Target = GetTarget()
	if Target ~= 0 and GetDistance(Target) < 350 - 55 and CanMove() and Setting_IsComboUseW() then
		CastW(Target)
	end

	if Target ~= 0 and  GetDistance(Target) >= 350 and WReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(Target)
	end

	if Target ~= 0 and  GetDistance(Target) >= 350 and Setting_IsComboUseE() and CanMove() then
		CastE(Target)
	end

	if Target ~= 0 and (CountEnemyHeroInRange(Widths.R, Target) > 0 or GetDistance(Target) > Ranges.Q) and CanMove() and Setting_IsComboUseR() then
		CastR(Target)
	end

end

function UnderTurret(Target)
	GetAllUnitAroundAnObject(Target, 900)
	for i, obj in pairs(pUnit) do
		if obj ~= 0 then
			if IsEnemy(obj) and IsTurret(obj) and GetTargetableToTeam(obj) == 4 and GetRange(obj, Target) < 900 then
				return true
			end
		end
	end

	return false
end

function CastR(Target)
    if RReady() and ValidTarget(Target) then
	    if (not UnderTurret(Target) or config_R_InTurret) then
			local vp_distance = VPGetLineCastPosition(Target, Delays.R, Widths.R, Ranges.R, Speeds.R)
			if vp_distance > 0 and vp_distance < Ranges.R then
				CastSpellToPredictionPos(Target, R, vp_distance)
			end
		end
	end
end

function GetRange(obj1, obj2)
	local x1 = GetPosX(obj1)
	local z1 = GetPosZ(obj1)

	local x2 = GetPosX(obj2)
	local z2 = GetPosZ(obj2)

	return GetDistance2D(x1,z1,x2,z2)
end

function CountEnemyHeroInRange(range, object)
	local enemyInRange = 0
    SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in ipairs(Enemies) do
		if enemy ~= 0 and ValidTarget(enemy) and GetRange(object, enemy) < range then
			enemyInRange = enemyInRange + 1
		end
	end
	return enemyInRange
end

function CastE(Target)
    if EReady() and GetDistance(Target) <= Ranges.E and ValidTarget(Target) then
	    CastSpellTarget(Target, E)
	end
end

function CastQ(Target)
    if QReady() and ValidTarget(Target) then
	    local vp_distance = VPGetLineCastPosition(Target, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q)
		if vp_distance > 0 and vp_distance < Ranges.Q then
			CastSpellToPredictionPos(Target, Q, vp_distance)
		end
	end
end

function CastW(Target)
    if WReady() and ValidTarget(Target) then
	    local vp_distance = VPGetLineCastPosition(Target, Delays.W, Widths.W, Ranges.W, Speeds.W)
		if vp_distance > 0 and vp_distance < Ranges.W then
			CastSpellToPredictionPos(Target, W, vp_distance)
		end
	end
end

function VPGetLineCastPosition(Target, Delay, Width, Range, Speed)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	TimeMissile = Delay + distance/Speed
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
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	return GetDistance2D(x1,z1,x2,z2)
end

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end
