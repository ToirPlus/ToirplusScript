--[[

Reference link  https://raw.githubusercontent.com/RK1K/RKScriptFolder/master/RK%20Heros.lua

Thanks

]]

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local myHero = GetMyHero()

local config_AutoR = true

local LaneClearUseMana = 40

if myHero.CharName == "Kassadin" then
	config_AutoR  = AddMenuCustom(1, config_AutoR, "Auto R")
end

Q = {Slot = _Q, DamageName = "Q", Range = 650, Width = 0, Delay = 0 , Collision = false, Aoe = false }
W = {Slot = _W, DamageName = "W", Range = 0, Width = 0, Delay = 0, Collision = false, Aoe = false }
E = {Slot = _E, DamageName = "E", Range = 580, Width = 0, Delay = 0, Collision = false, Aoe = true }
R = {Slot = _R, DamageName = "R", Range = 700, Width = 0, Delay = 0.15, Collision = false, Aoe = true}

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

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

end

function OnTick()
	myHero = GetMyHero() -- refresh myHero infomation

	if myHero.CharName ~= "Kassadin" then return end
	if myHero.IsDead then return end


	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end

end

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(myHero.Addr, jungle) < Q.Range then
				if (GetDistance(myHero.Addr, jungle) < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (GetDistance(myHero.Addr, jungle) >= myHero.AARange + myHero.CollisionRadius) then
					CastSpellTarget(jungle, _Q)
				end
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 and WReady() and Setting_IsLaneClearUseW() and GetDistance(myHero.Addr, jungle) < myHero.AARange + myHero.CollisionRadius and not CanAttack() and CanMove() then
			CastSpellTarget(myHero.Addr, _W)
			SetLuaBasicAttackOnly(true)
			BasicAttack(jungle)
			SetLuaBasicAttackOnly(false)
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 and EReady() then
			if ValidTargetJungle(jungle) and GetDistance(myHero.Addr, jungle) < E.Range and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				if (GetDistance(myHero.Addr, jungle) < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (GetDistance(myHero.Addr, jungle) >= myHero.AARange + myHero.CollisionRadius) then
					CastSpellToPredictionPos(jungle, _E, E.Range)
				end
			end
		end

	else
		LastHitMinionUseQ()

		local minion = GetMinion()
		if minion then
			if WReady() and Setting_IsLaneClearUseW() and GetDistance(myHero.Addr, minion.Addr) < myHero.AARange + myHero.CollisionRadius and not CanAttack() and CanMove() then
				CastSpellTarget(myHero.Addr, _W)
				SetLuaBasicAttackOnly(true)
				BasicAttack(minion.Addr)
				SetLuaBasicAttackOnly(false)
			end
		end

		minion = BestMinionHitE()
		if minion then
			if EReady() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				if GetDistance(myHero.Addr, minion.Addr) < E.Range then
					if (minion.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (minion.Distance >= myHero.AARange + myHero.CollisionRadius) then
						CastSpellToPredictionPos(minion.Addr, _E, E.Range)
					end
				end
			end
		end

		minion = BestMinionHitR()
		if minion then
			if RReady() and CanMove() and Setting_IsLaneClearUseR() and not IsMyManaLowLaneClear() then
				if GetDistance(myHero.Addr, minion.Addr) < R.Range then
					CastSpellToPos(minion.x, minion.z, _R)
				end
			end
		end

	end
end

function BestMinionHitE()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and CountMinionsAroundMinion(unit, E.Range/2) > 2 then
				return unit
			end
		end
	end
	return nil
end

function BestMinionHitR()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and CountMinionsAroundMinion(unit, (R.Range - myHero.AARange)) > 2 and not IsUnderTower(unit) and EnemiesAround(unit.Addr, 1000) < 2 then
				return unit
			end
		end
	end
	return nil
end

function IsUnderTower(m)
	GetAllUnitAroundAnObject(myHero.Addr, 1300)
	for i, turret in pairs(pUnit) do
		if turret ~= 0 and GetType(turret) == 2 then
			local unit = GetUnit(turret)
			if unit.IsEnemy and GetDistance(unit.Addr, m.Addr) < 915 then
				return true
			end
		end
	end

	return false
end


function CountMinionsAroundMinion(m, range)
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local n = 0
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 and m.Addr ~= minion then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and GetDistance(m.Addr,unit.Addr) < range then
				n = n + 1
			end
		end
	end
	return n
end

function LastHitMinionUseQ()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and getDmg(_Q, unit) > unit.HP then
				if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
					if GetDistance(myHero.Addr, unit.Addr) < Q.Range then
						if (unit.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (unit.Distance >= myHero.AARange + myHero.CollisionRadius) then
							CastSpellTarget(unit.Addr, _Q)
						end
					end
				end
			end
		end
	end
end

function IsMyManaLowLaneClear()
    if myHero.MP < (myHero.MaxMP * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function ValidTargetJungle(Target)
	if Target ~= 0 and GetType(Target) == 3 then
		local unit = GetUnit(Target)
		if not unit.IsDead and unit.IsVisible and unit.CanSelect then
			return true
		end
	end
	return false
end

function GetMinion()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect then
				return unit
			end
		end
	end

	return nil
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
				return GetAIHero(enemy)
			end
			if priorityTable.p2[GetChampName(enemy)] then
				return GetAIHero(enemy)
			end
			if priorityTable.p3[GetChampName(enemy)] then
				return GetAIHero(enemy)
			end
			if priorityTable.p4[GetChampName(enemy)] then
				return GetAIHero(enemy)
			end
			if priorityTable.p5[GetChampName(enemy)] then
				return GetAIHero(enemy)
			end
		end
	end

	local target = GetEnemyChampCanKillFastest(range)
	if target ~= 0 then
		return GetAIHero(target)
	end
	return nil
end

function ValidTargetRange(Target, Range)
	local enemy = GetAIHero(Target)
	if ValidTarget(enemy) and GetDistance(myHero.Addr,enemy.Addr) < Range then
		return true
	end
	return false
end

function Combo()

	local target = GetTarget(1100)

	if target and WReady() and Setting_IsComboUseW() and not CanAttack() and CanMove() then
		CastW(target)
		SetLuaBasicAttackOnly(true)
		BasicAttack(target.Addr)
		SetLuaBasicAttackOnly(false)
    end

	if target and EReady() and Setting_IsComboUseE() then
		CastE(target)
    end

	if target and QReady() and Setting_IsComboUseQ() then
		CastQ(target)
    end

	if target and RReady() and CanMove() and Setting_IsComboUseR() and config_AutoR and (getDmg(_R, target) > target.HP or EnemiesAround(target.Addr, R.Range) < 3) then
		CastR(target)
    end

end


function CastW(target)
	if ValidTarget(target) and target.Distance < myHero.AARange + myHero.CollisionRadius then
		CastSpellTarget(myHero.Addr, _W)
	end
end

function CastE(target)
	if target.Distance < E.Range and ValidTarget(target) then
		if (target.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (target.Distance >= myHero.AARange + myHero.CollisionRadius) then
			CastSpellToPredictionPos(target.Addr, _E, E.Range)
		end
	end
end

function CastQ(target)
    if target.Distance < Q.Range and ValidTarget(target) then
        if (target.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (target.Distance >= myHero.AARange + myHero.CollisionRadius) then
            CastSpellTarget(target.Addr, _Q)
        end
    end
end

function CastR(target)
	if target.Distance < R.Range and ValidTarget(target) then
		CastSpellToPos(target.x, target.z, _R)
	end
end

function VPGetLineCastPosition(Target, Delay)
	local TimeMissile = Delay
	local real_distance = (TimeMissile * GetMoveSpeed(Target.Addr))
	return real_distance
end

function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function GetDistance(p1, p2)
	local x1,y1,z1 = GetPos(p1)

	local x2,y2,z2 = GetPos(p2)

	return GetDistance2D(x1,z1,x2,z2)
end

function ValidTarget(target)
	if target then
		if not target.IsDead and target.IsVisible and target.IsEnemy and target.CanSelect then
			return true
		end
	end
	return false
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _Q then
		if myHero.LevelSpell(_Q) == 0 then return 0 end
		local DamageSpellQTable = { 65, 95, 125, 155, 185 }
		local Percent_AP = 0.7

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellR = DamageSpellQTable[myHero.LevelSpell(_Q)]

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
		local DamageSpellRTable = { 80, 100, 120 }
		local Percent_AP = 0.3

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellR = DamageSpellRTable[myHero.LevelSpell(_R)]

		local Enemy_SpellBlock = Enemy.MagicArmor

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP + 0.2 * myHero.MaxMP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP + 0.2 * myHero.MaxMP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end
