--[[

Reference link  https://github.com/Cloudhax23/GoS/blob/master/Common/Gangplank.lua

Thanks

]]




function UpdateHeroInfo()
	return GetMyChamp()
end


IncludeFile("Lib\\Vector.lua")

local Config_HP_W = 10

local LaneClearUseMana = 40

local Q = 0
local W = 1
local E = 2
local R = 3

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local BarrelPred = { delay = 0.25, speed = math.huge, width = 390, range = 1000 }
local GPR = { delay = 0.25, speed = math.huge, width = 575, range = math.huge }

local BarrelCount = 0
local Barrel = { }
local CT = 0

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
	return GetEnemyChampCanKillFastest(2000)
end

function ValidTarget(Target)
	if Target ~= 0 then
		if not IsDead(Target) and not IsInFog(Target) and GetTargetableToTeam(Target) == 4 and IsEnemy(Target) then
			return true
		end
	end
	return false
end

function GetDistancePos(x,z)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	return GetDistance2D(x1,z1,x,z)
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

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end

function OnWndMsg(msg, key)

end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

end

function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Gangplank" then return end

	if IsDead(UpdateHeroInfo()) then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
		AutoBarrel()
		--CastQEnemy()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end

	UseW()

	AutoKS()

end

function VPGetCircularCastPosition(Target, Delay, Width)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	local TimeMissile = Delay
	local real_distance = (TimeMissile * GetMoveSpeed(Target))

	return distance + real_distance - Width/2

end

function CanQBarrel()
	local delay = function() if GetLevel(UpdateHeroInfo()) >= 13 then return .5 elseif GetLevel(UpdateHeroInfo()) >= 7 and GetLevel(UpdateHeroInfo()) < 13 then return 1 elseif GetLevel(UpdateHeroInfo()) < 7 then return 2 end end
	local time = function(target) return GetDistance(target)/1700+ .25 end
	local mod = function(target) return GetHealthPoint(target) * delay() * 1000 end
	local barrelf = function() for i,object in pairs(Barrel) do if object ~= nil and CT ~= nil and (GetTickCount() - CT + time(object) * 1000 > mod(object) or GetHealthPoint(object) == 1) then return object end end end
	local barrel = barrelf()
	if barrel ~= nil then
		return barrel
	end
end

function GetOrigin(obj)
	return {GetPosX(obj),GetPosY(obj),GetPosZ(obj)}
end

function CastQEnemy()
	local Target = GetTarget()
	if Target == 0 then return end
	local barrel = CanQBarrel()
	if not EReady() and ValidTargetRange(Target, 625) and QReady() and (barrel == nil or GetDistance2Pos(GetPosX(barrel), GetPosZ(barrel), GetPosX(Target), GetPosZ(Target)) > 1200) and CanMove() then
		CastSpellTarget(Target, Q)
	end
end

function Combo()
	local Target = GetTarget()

	if Target == 0 then return end

	local barrel = CanQBarrel()

	--__PrintTextGame(tostring(BarrelCount))
	if QReady() and EReady() then

		if barrel ~= nil then

			--__PrintTextGame("11")
			if GetDistance(Target) < 1300 and GetDistance2Pos(GetPosX(Target), GetPosZ(Target), GetPosX(barrel), GetPosZ(barrel)) <= 780 then
				local vp_distance = VPGetCircularCastPosition(Target, BarrelPred.delay, BarrelPred.width)
				--__PrintTextGame(tostring(vp_distance))
				if vp_distance < 700 and CanMove() then
					CastSpellToPredictionPos(Target, E, vp_distance)
				end

			end

		elseif barrel == nil then
			local vectornear = Vector(GetOrigin(UpdateHeroInfo())) + (Vector(GetOrigin(Target)) - Vector(GetOrigin(UpdateHeroInfo()))):Normalized() * 150
			local vectorfar = Vector(GetOrigin(UpdateHeroInfo())) + (Vector(GetOrigin(Target)) - Vector(GetOrigin(UpdateHeroInfo()))):Normalized() * 350

			--__PrintTextGame(tostring(BarrelCount))

			if GetDistance(Target) <= 650 and GetDistancePos(vectornear.x, vectornear.z) <= 650 and BarrelCount == 0 and CanMove() then
				--__PrintTextGame("near")
				CastSpellToPos(vectornear.x, vectornear.z, E)
			elseif GetDistance(Target) >= 650 and GetDistancePos(vectorfar.x, vectorfar.z) <= 1000 and GetDistance(Target) <= 1000 and BarrelCount == 0 and CanMove() then
				--__PrintTextGame("far")
				CastSpellToPos(vectorfar.x, vectorfar.z, E)
			end
		end
	end

end

function LaneClear()
	if Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
		UseQFarm()
	end
	if Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
		MinionE()
	end
end

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function UseQFarm()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				if QReady() and GetHealthPoint(minion) <= getDmg(Q,minion) and CanMove() then
					CastSpellTarget(minion, Q)
				end

			end
		end
	end

end

function MinionsAround(obj, range)
	GetAllUnitAroundAnObject(obj, 1000)
	local count = 0
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and obj ~= minion then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 and GetDistance2Pos(GetPosX(obj), GetPosZ(obj), GetPosX(minion), GetPosZ(minion)) < range then
				count = count + 1
			end
		end
	end
	return count
end

function MinionE()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local barrel = CanQBarrel()
				if barrel ~= nil then
					local barrelwithenemyf = function() for i,z in pairs(Barrel) do if barrel ~= z and z ~= nil and GetDistance2Pos(GetPosX(barrel),GetPosZ(barrel),GetPosX(z),GetPosZ(z)) < 700 then return z end end end
					local barrelwithenemy = barrelwithenemyf()
					if barrelwithenemy ~= nil and barrel ~= nil and GetDistance(barrel) < 625 and GetHealthPoint(barrel) == 1 and CanMove() then
						CastSpellTarget(barrel, Q)
					end
					if barrel ~= nil and GetDistance(barrel) < 625 and GetHealthPoint(barrel) == 1 and CanMove() then
						CastSpellTarget(barrel, Q)
					end
				end
				if barrel == nil and BarrelCount <= 1 and EReady() and CanMove() then
					if MinionsAround(minion, 370) > 3 then
						CastSpellToPos(GetPosX(minion), GetPosZ(minion), E)
					end
				end
			end
		end
	end
end

local function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function AutoBarrel()
	local barrel = CanQBarrel()
	if barrel ~= nil then
		local barrelwithenemyf = function() for i,z in pairs(Barrel) do if barrel ~= z and EnemiesAround(z, 370) >= 1 and GetDistance2Pos(GetPosX(barrel),GetPosZ(barrel),GetPosX(z),GetPosZ(z)) < 700 then return z end end end
		local barrelwithenemy = barrelwithenemyf()

		if barrelwithenemy ~= nil and barrel ~= nil and GetDistance(barrel) < 625 and EnemiesAround(barrelwithenemy, 370) >= 1 and GetHealthPoint(barrel) == 1 and CanMove() then

			CastSpellTarget(barrel, Q)
		end
		if barrel ~= nil and EnemiesAround(barrel, 370) >= 1 and GetDistance(barrel) < 625 and GetHealthPoint(barrel) == 1 and CanMove() then
			CastSpellTarget(barrel, Q)
		end
	end
end

function UseW()
	local Internal_Buff				= 0
	local Aura_Buff					= 1
	local CombatEnchancer_Buff		= 2
	local CombatDehancer_Buff		= 3
	local SpellShield_Buff			= 4
	local Stun_Buff					= 5
	local Invisibility_Buff			= 6
	local Silence_Buff				= 7
	local Taunt_Buff				= 8
	local Polymorph_Buff			= 9
	local Slow_Buff					= 10
	local Snare_Buff				= 11
	local Damage_Buff				= 12
	local Heal_Buff					= 13
	local Haste_Buff				= 14
	local SpellImmunity_Buff		= 15
	local PhysicalImmunity_Buff		= 16
	local Invulnerability_Buff		= 17
	local Sleep_Buff				= 18
	local NearSight_Buff			= 19
	local Frenzy_Buff				= 20
	local Fear_Buff					= 21
	local Charm_Buff				= 22
	local Poison_Buff				= 23
	local Suppression_Buff			= 24
	local Blind_Buff				= 25
	local Counter_Buff				= 26
	local Shred_Buff				= 27
	local Flee_Buff					= 28
	local Knockup_Buff				= 29
	local Knockback_Buff			= 30
	local Disarm_Buff				= 31

	local CC = {Stun_Buff, Taunt_Buff, Snare_Buff, Fear_Buff, Charm_Buff, Suppression_Buff, Blind_Buff, Silence_Buff, Slow_Buff }

	for _,v in pairs(CC) do
		if WReady() and CountBuffByType(UpdateHeroInfo(), v) >= 1 then
			CastSpellTarget(UpdateHeroInfo(), W)
		end
	end
	if WReady() and (100*GetHealthPoint(UpdateHeroInfo())/GetHealthPointMax(UpdateHeroInfo())) <= Config_HP_W and IsRecall(UpdateHeroInfo()) == 0 then
		CastSpellTarget(UpdateHeroInfo(), W)
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		if GetSpellLevel(UpdateHeroInfo(),Q) == 0 then return 0 end

		local DamageSpellQTable = {20, 45, 70, 95, 120}

		local Percent_Bonus_AD = 1

		local Damage_Bonus_AD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),Q)]

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

	if Spell == R then
		if GetSpellLevel(UpdateHeroInfo(),R) == 0 then return 0 end
		local DamageSpellRTable = { 35, 60, 85}
		local Percent_AP = 0.1

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(UpdateHeroInfo(),R)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = ((DamageSpellR + Percent_AP * AP) * wavetime()) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = ((DamageSpellR + Percent_AP * AP) * wavetime()) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end

function AutoKS()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in pairs(Enemies) do
		if enemy ~= 0 and ValidTarget(enemy) then

			if RReady() and getDmg(R, enemy) > GetHealthPoint(enemy) and CanMove() then
				CastSpellToPos(GetPosX(enemy), GetPosZ(enemy), R)
			end

			if QReady() and ValidTargetRange(enemy, 625) and getDmg(Q, enemy) >= GetHealthPoint(enemy) and CanMove() then
				CastSpellTarget(enemy, Q)
			end
		end
	end
end

function wavetime()
	if GetBuffByName(UpdateHeroInfo(), "GangplankRUpgrade1") >=1 then
		return 18
	else
		return 12
	end
end

function OnLoad()
	--__PrintTextGame("GangPlank v1.4 loaded")
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
	if GetObjName(unit.Addr) == "Barrel" then
		BarrelCount = BarrelCount + 1
		table.insert(Barrel, unit.Addr)
		if BarrelCount == 1 then
			CT = GetTickCount()
		end
	end
end

function OnDeleteObject(unit)
	if GetObjName(unit.Addr) == "Gangplank_Base_E_AoE_Green.troy" then
		BarrelCount = BarrelCount - 1
		if BarrelCount < 0 then BarrelCount = 0 end
		table.remove(Barrel, 1)
		CT = nil
	end
end
