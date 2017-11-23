--[[

Reference link https://github.com/nebelwolfi/BoL/blob/master/SPlugins/Rumble.lua

Thanks

]]

function UpdateHeroInfo()
	return GetMyChamp()
end

data = {
      [_Q] = { range = 310, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 0-10+20*level+(0.35+0.05*level)*TotalDmg end},
      [_W] = { range = 265, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 20+30*level+TotalDmg end},
      [_E] = { range = 390},
      [_R] = { range = 930, dmgAD = function(AP, level, Level, TotalDmg, source, target) return (40+40*level+0.6*source.addDamage)*(math.min(3,math.max(1,4*(target.maxHealth-target.health)/target.maxHealth))) end},
    }

--IncludeFile("Lib\\Vector.lua")

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

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

function OnCreateObject(unit)

end

function OnDeleteObject(unit)

end

function OnWndMsg(msg, key)

end

function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Rumble" then return end
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

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then

		if QReady() and CanMove() and Setting_IsLaneClearUseQ() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < data[_Q].range then
				CastSpellToPredictionPos(jungle, _Q, data[_Q].range)
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 and WReady() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < data[_W].range and Setting_IsLaneClearUseW() then
				CastSpellTarget(UpdateHeroInfo(), _W)
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 and EReady() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < data[_E].range and Setting_IsLaneClearUseE() then
				CastSpellToPredictionPos(jungle, _E, data[_E].range)
			end
		end

	else
		local minion = GetMinion()
		if minion ~= 0 then
			if QReady() and CanMove() and Setting_IsLaneClearUseQ() then
				if GetDistance(minion) < data[_Q].range then
					CastSpellToPredictionPos(minion, _Q, data[_Q].range)
				end
			end
		end

		minion = GetMinion()
		if minion ~= 0 then
			if EReady() and CanMove() and Setting_IsLaneClearUseE() and getDmg(_E, minion) > GetHealthPoint(minion) then
				if GetDistance(minion) < data[_E].range then
					CastSpellToPredictionPos(minion, _E, data[_E].range)
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

function Combo()
	local target = GetTarget()

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
	end

     if target ~= 0 and WReady() and Setting_IsComboUseW() then
		CastW(target)
     end

	if target ~= 0 and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
    end

	if target ~= 0 and RReady() and CanMove() and Setting_IsComboUseR() and (EnemiesAround(target, 500) >= 2 or getDmg(_R,target) > GetHealthPoint(target))then
		CastR(target)
    end

end

function CastQ(Target)
	if ValidTargetRange(Target,data[_Q].range) then
		CastSpellToPredictionPos(Target, _Q, data[_Q].range)
	end
end

function CastW(Target)
	if ValidTarget(Target) and GetDistance(Target) < data[_W].range + 250 then
		CastSpellTarget(UpdateHeroInfo(), _W)
	end
end

function CastE(Target)
	if ValidTargetRange(Target,data[_E].range) then
		CastSpellToPredictionPos(Target, _E, data[_E].range)
	end
end

function CastR(Target)
	if ValidTargetRange(Target, data[_R].range) then
		CastSpellToPredictionPos(Target, _R, GetDistance(Target))
	end
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

function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function GetEnemyHeroes()
	SearchAllChamp()
	return pObjChamp
end

function Killsteal()
	for k,enemy in pairs(GetEnemyHeroes()) do
		if ValidTargetRange(enemy, data[_Q].range) and enemy ~= 0 and QReady() and getDmg(_Q, enemy) > GetHealthPoint(enemy) and CanMove() then
			CastSpellToPredictionPos(enemy, _Q, data[_Q].range)
		end

		if ValidTargetRange(enemy, data[_E].range) and enemy ~= 0 and EReady() and getDmg(_E, enemy) > GetHealthPoint(enemy) and CanMove() then
			CastSpellToPredictionPos(enemy, _E, data[_E].range)
		end

		if ValidTargetRange(enemy, data[_R].range) and enemy ~= 0 and RReady() and getDmg(_R, enemy) > GetHealthPoint(enemy) and CanMove() then
			CastSpellToPredictionPos(enemy, _R, GetDistance(enemy))
		end
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _Q then
		if GetSpellLevel(UpdateHeroInfo(),_Q) == 0 then return 0 end
		local DamageSpellQTable = {45, 60, 75, 90, 105}
		local Percent_AP = 0.36

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),_Q)]

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

	if Spell == _E then
		if GetSpellLevel(UpdateHeroInfo(),_E) == 0 then return 0 end
		local DamageSpellETable = { 60, 85, 110, 135, 160}
		local Percent_AP = 0.4

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellE = DamageSpellETable[GetSpellLevel(UpdateHeroInfo(),_E)]

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

	if Spell == _R then
		if GetSpellLevel(UpdateHeroInfo(),_R) == 0 then return 0 end
		local DamageSpellRTable = {130, 185, 240}
		local Percent_AP = 0.3

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
