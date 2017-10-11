local myHero = GetMyChamp()
 if GetChampName(myHero) ~= "KogMaw" then return end
__PrintDebug("KogMaw")
__PrintTextGame("KogMawRework Script loaded")



local Q = 0
local W = 1
local E = 2
local R = 3

local SpellQ = {Speed = 1550, Range = 925, Delay = 0.3667, Width = 60}
local SpellW = {Speed = 1600, Range = 1000, Delay = 0.111, Width = 55}
local SpellE = {Speed = 1400, Range = 1280, Delay = 0.066, Width = 120}
local SpellR = {Width = 150, Speed = math.huge, Delay= 1.1}
local RRangeTable = {1400, 1700, 2200}
local WRange, RRange = nil, nil
local QReady, WReady, EReady, RReady = nil, nil, nil, nil
local RStacks = 0
local WRangeTable = {130, 150, 170, 190, 210}

local ComboUseMana = 40

function Check()
	myHero = GetMyChamp()

	QReady = CanCast(Q)
	WReady = CanCast(W)
	EReady = CanCast(E)
	RReady = CanCast(R)
	if GetSpellLevel(myHero,R) > 0 then
		RRange = RRangeTable[GetSpellLevel(myHero,R)]
	end
	if GetSpellLevel(myHero,W) > 0 then
		WRange = 500 + WRangeTable[GetSpellLevel(myHero,W)]
	end
	RStacks = GetBuffCount(myHero, "kogmawlivingartillerycost")
end

function SpellQCollision(Target, Delay, Width, Range, Speed, vp_distance) -- need review
	--local vp_distance = VPGetLineCastPosition(Target, Delay, Width, Range, Speed)

	local PredPosX = GetPredictionPosX(Target, vp_distance)
	local PredPosZ = GetPredictionPosZ(Target, vp_distance)

	local x1 = GetPosX(myHero)
	local z1 = GetPosZ(myHero)

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local nCountMinionCollision = 0

	--__PrintDebug("SpellQCollision")
	if PredPosX ~= 0 and PredPosZ ~= 0 then
		--__PrintDebug("SpellQCollision1")
		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, PredPosX, PredPosZ, Width, Range, 10) --> crash
	else
		--__PrintDebug("SpellQCollision2")
		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, x2, z2, Width, Range, 10) --> crash
	end
	--__PrintDebug("SpellQCollision3")
	if nCountMinionCollision == 0 then
		return false
	end

	return true

end

function VPGetCircularCastPosition(Target, Delay, Width) -- need review
	local x1 = GetPosX(myHero)
	local z1 = GetPosZ(myHero)

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	TimeMissile = Delay
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
	local x1 = GetPosX(myHero)
	local z1 = GetPosZ(myHero)

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	TimeMissile = Delay + distance/Speed
	local real_distance = (TimeMissile * GetMoveSpeed(Target))
	--__PrintDebug(GetMoveSpeed(Target))
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
	x1 = GetPosX(myHero)
	z1 = GetPosZ(myHero)

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
	if Target ~= 0 and ValidTarget(Target, 1300) and QReady then
		--__PrintDebug("Q")
		local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
		--__PrintDebug(vp_distance)
		if vp_distance > 0 and vp_distance < SpellQ.Range then --and not SpellQCollision(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
			if not SpellQCollision(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed, vp_distance) then
				--__PrintDebug("Q2")
				CastSpellToPredictionPos(Target, Q, vp_distance)
			end
		end
	end
end

function CastW(Target)
	if Target ~= 0 and ValidTarget(Target, 1300) and WReady and GetDistance(Target) < WRange then
		--__PrintDebug("W")
		CastSpellTarget(myHero, W)
	end
end

function CastE(Target)
	if Target ~= 0 and ValidTargetRange(Target, 1300) and EReady then
		--__PrintDebug("E")
		local vp_distance = VPGetLineCastPosition(Target, SpellE.Delay, SpellE.Width, SpellE.Range, SpellE.Speed)
		--__PrintDebug(vp_distance)
		if vp_distance > 0 and vp_distance < SpellE.Range then
			--__PrintDebug("E")
			CastSpellToPredictionPos(Target, E, vp_distance)
		end
	end
end

function CastR(Target)
	if Target ~= 0 and RReady and ValidTargetRange(Target, 1800) then
		--__PrintDebug("CastR")
		local vp_distance = VPGetCircularCastPosition(Target, SpellR.Delay, SpellR.Width)
		--__PrintDebug(vp_distance)
		if vp_distance > 0 and vp_distance < RRange and RStacks < 4 and not IsMyManaLowCombo() then
			--__PrintDebug("CastR1")
			CastSpellToPredictionPos(Target, R, vp_distance)
			RStacks = GetBuffCount(myHero, "kogmawlivingartillerycost")
		end
	end
end

function Combo(Target)
	--__PrintDebug("Combo")
	if QReady and Setting_IsComboUseQ() and not IsMyManaLowCombo() then
		CastQ(Target)
	end

	if WReady and Setting_IsComboUseW() then
		CastW(Target)
	end

	if EReady and Setting_IsComboUseE() and not IsMyManaLowCombo() then
		CastE(Target)
	end

	if RReady and Setting_IsComboUseR() and not IsMyManaLowCombo() then
		--__PrintDebug("R")
		CastR(Target)
	end
end


function OnTick()

	Check()

	target = GetEnemyChampCanKillFastest(1300)

	--Qtarget = nil

	SetLuaCombo(true)
	Combo(target)

	--Harass(Qtarget)

	CheckDashes()

	AutoUlt()

	KillSteal()
end


function AutoUlt()
	--__PrintDebug("AutoUlt")
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if RReady and ValidTargetRange(enemy, 1800) and GetDistance(enemy) < 1800 then
				local vp_distance = VPGetCircularCastPosition(enemy, SpellR.Delay, SpellR.Width)
				if vp_distance > 0 and vp_distance < RRange then
					CastSpellToPredictionPos(enemy, R, vp_distance)
				end
			end
		end
	end
end

function CheckDashes()
	--__PrintDebug("CheckDashes")
	SearchAllChamp()
	local Enemies = pObjChamp
	for idx, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if EReady and ValidTarget(enemy) and GetDistance(enemy) < SpellE.Range then
				local _IsDashing = IsDashing(enemy)

				local vp_distance = VPGetLineCastPosition(enemy, SpellE.Delay, SpellE.Width, SpellE.Range, SpellE.Speed)
				if vp_distance > 0 and not _IsDashing and vp_distance < SpellE.Range then
					CastSpellToPredictionPos(enemy, E, vp_distance)
				end
			end
		end
	end
end

function KillSteal()
	--__PrintDebug("KillSteal")
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in pairs(Enemies) do
		if enemy ~= 0 then
			if ValidTargetRange(enemy, 1800) and GetDistance(enemy) < 1800 then
				if QReady and getDmg(Q, enemy) > GetHealthPoint(enemy) then
					CastQ(enemy)
				end

				if EReady and getDmg(E, enemy) > GetHealthPoint(enemy) then
					CastE(enemy)
				end

				if RReady and getDmg(R, enemy) > GetHealthPoint(enemy) then
					CastR(enemy)
				end
			end
		end
	end

end

function IsMyManaLowCombo()
    if GetManaPoint(myHero) < (GetManaPointMax(myHero) * ( ComboUseMana / 100)) then
        return true
    else
        return false
    end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		local DamageSpellQTable = {0, 80, 130, 180, 230, 280}
		local Percent_AP = 0.5

		local AP = GetFlatMagicDamage(myHero) + GetFlatMagicDamage(myHero) * GetPercentMagicDamage(myHero)

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(myHero,Q)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy) - GetMagicPenetration(myHero)
		-- Add more Magic Penetration Item

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellQ + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellQ + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == E then
		local DamageSpellETable = {0, 60, 105, 150, 195, 240}
		local Percent_AP = 0.5

		local AP = GetFlatMagicDamage(myHero) + GetFlatMagicDamage(myHero) * GetPercentMagicDamage(myHero)

		local DamageSpellE = DamageSpellETable[GetSpellLevel(myHero,E)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy) - GetMagicPenetration(myHero)
		-- Add more Magic Penetration Item

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellE + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellE + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == R then
		local DamageSpellRTable = {0, 100, 140, 180}
		local Percent_AP = 0.25

		local AP = GetFlatMagicDamage(myHero) + GetFlatMagicDamage(myHero) * GetPercentMagicDamage(myHero)

		local BonusAD = GetFlatPhysicalDamage(myHero)

		local Percent_BonusAD = 0.65

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(myHero,R)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy) - GetMagicPenetration(myHero)
		-- Add more Magic Penetration Item

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_BonusAD * BonusAD + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_BonusAD * BonusAD + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		local PercentHP = 100 * GetHealthPoint(myHero)/GetHealthPointMax(myHero)

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


--[[
function Harass(Target)
	if QReady and Config.HarassSub.useQ and not IsMyManaLowHarass() then
		CastQ(Target)
	end

	if EReady and Config.HarassSub.useE and not IsMyManaLowHarass() then
		CastE(Target)
	end

	if RReady and Config.HarassSub.useR and RStacks < Config.HarassSub.RStacks and not IsMyManaLowHarass() and GetDistance(Target) > Config.Extras.RMinRange then
		CastR(Target)
	end

	if WReady and Config.HarassSub.useW then
		CastW(Target)
	end
end

--]]








