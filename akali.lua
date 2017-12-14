--[[

Reference link https://raw.githubusercontent.com/RK1K/RKScriptFolder/master/RK%20Heros.lua

Thanks

]]

local myHero = GetMyHero()

function UpdateHeroInfo()
	return GetMyChamp()
end

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

Q = {Range = 600}
W = {Range = 250}
E = {Range = 320}
R = {Range = 700}

local Config_AutoW = 1

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



local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Sejuani",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs", "Zoe" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne", "Xayah"},
}

function GetTarget(range)
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in pairs(Enemies) do
        if enemy ~= 0 and ValidTargetRange(enemy,range) then
			if priorityTable.p1[GetChampName(enemy)] then
				return enemy
			end
			if priorityTable.p2[GetChampName(enemy)] then
				return enemy
			end
			if priorityTable.p3[GetChampName(enemy)] then
				return enemy
			end
			if priorityTable.p4[GetChampName(enemy)] then
				return enemy
			end
			if priorityTable.p5[GetChampName(enemy)] then
				return enemy
			end
		end
	end

	return GetEnemyChampCanKillFastest(range)
end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

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
	myHero = GetMyHero()
	if GetChampName(GetMyChamp()) ~= "Akali" then return end
	if IsDead(UpdateHeroInfo()) then return end

	AutoW()

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(CKeyCode) == 1 then
		SetLuaHarass(true)
		Harass()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		Laneclear()
		Jungleclear()
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
	LastHitMinionUseQ()
	FarmE()
end

function LastHitMinionUseQ()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and getDmg(_Q, unit) > unit.HP then
				if QReady() and Setting_IsLaneClearUseQ() and CanMove() and GetDistance(minion) <  Q.Range then
					CastSpellTarget(minion, _Q)
				end
			end
		end
	end
end

function FarmE()
	if EReady() and  CountMinionsAround(E.Range) > 2 and Setting_IsLaneClearUseQ() and CanMove() then
		CastSpellTarget(myHero.Addr, _E)
	end
end

function CountMinionsAround(range)
	GetAllUnitAroundAnObject(myHero.Addr, range)
	local n = 0
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect then
				n = n + 1
			end
		end
	end
	return n
end

function Jungleclear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 and QReady() and CanMove() and Setting_IsLaneClearUseQ() then
		CastSpellTarget(jungle, _Q)
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 and EReady() and CanMove() and Setting_IsLaneClearUseE() then
		CastSpellTarget(jungle, _E)
	end
end

function Combo()
	local target = GetTarget(1000)

	local enemy = GetAIHero(target)

	if target ~= 0 and RReady() and CanMove() and Setting_IsComboUseR() and (getDmg(_R, enemy) > enemy.HP or EnemiesAround(enemy.Addr, R.Range) < 3) then
		CastR(target)
    end

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
	end

	if target ~= 0 and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
    end

end

function Harass()
	local target = GetTarget(1000)

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
	end
end

function CastR(Target)
	if ValidTargetRange(Target,R.Range) then
		CastSpellTarget(Target, _R)
	end
end

function CastQ(Target)
	if ValidTargetRange(Target,Q.Range) then
		CastSpellTarget(Target, _Q)
	end
end

function CastE(Target)
	if ValidTargetRange(Target,E.Range) then
		CastSpellTarget(Target, _E)
	end
end

function AutoW()
	if EnemiesAround(UpdateHeroInfo(), W.Range) >= Config_AutoW then
		CastSpellTarget(UpdateHeroInfo(), _W)
	end
end

function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
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

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _Q then
		if myHero.LevelSpell(_Q) == 0 then return 0 end
		local DamageSpellRTable = { 35, 55, 75, 95, 115 }
		local Percent_AP = 0.4

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellR = DamageSpellRTable[myHero.LevelSpell(_Q)]

		local Enemy_SpellBlock = Enemy.MagicArmor

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == _R then
		if myHero.LevelSpell(_R) == 0 then return 0 end
		local DamageSpellRTable = { 50, 105, 150 }
		local Percent_AP = 0.35

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellR = DamageSpellRTable[myHero.LevelSpell(_R)]

		local Enemy_SpellBlock = Enemy.MagicArmor

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end
