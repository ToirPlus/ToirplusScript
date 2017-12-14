--[[

Reference link  https://raw.githubusercontent.com/RK1K/RKScriptFolder/master/RK%20Heros.lua

Thanks

]]

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local myHero = GetMyHero()

local config_AutoW = false
local config_AutoR = true

local LaneClearUseMana = 40

if myHero.CharName == "Tristana" then
	config_AutoW  = AddMenuCustom(1, config_AutoW, "Auto W")
	config_AutoR  = AddMenuCustom(2, config_AutoR, "Auto R When Dasing")
end

Q = {Slot = _Q, DamageName = "Q", Range = 0,   Width = 0,   Delay = 0 ,   Collision = false, Aoe = false}
W = {Slot = _W, DamageName = "W", Range = 900, Width = 450, Delay = 0.15, Collision = false, Aoe = true}
E = {Slot = _E, DamageName = "E", Range = 670, Width = 0,   Delay = 0,   Collision = false, Aoe = false}
R = {Slot = _R, DamageName = "R", Range = 670, Width = 0,   Delay = 0,   Collision = false, Aoe = true}

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
	--if buff.Name == "Burning" then
	--__PrintTextGame(buff.Name)
	--end
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

	if myHero.CharName ~= "Tristana" then return end
	if myHero.IsDead then return end

	if IsTyping() then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end

	if config_AutoR then
		CheckDashes()
	end

	KillSteal()

end

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then
		if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
			if ValidTargetJungle(jungle) and GetDistance(myHero.Addr, jungle) < E.Range then
				CastSpellTarget(myHero.Addr, _Q)
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 and EReady() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(myHero.Addr, jungle) < E.Range and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				CastSpellTarget(jungle, _E)
			end
		end

	else
		local minion = GetMinion()
		if minion then
			if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
				if GetDistance(myHero.Addr, minion.Addr) < E.Range then
					CastSpellTarget(myHero.Addr, _Q)
				end
			end
		end

		minion = GetMinion()
		if minion then
			if EReady() and CanMove() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				if GetDistance(myHero.Addr, minion.Addr) < E.Range then
					--CastSpellTarget(minion.Addr, _E)
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

function CheckDashes()
	SearchAllChamp()
	local Enemies = pObjChamp
	for idx, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			local enemyHero = GetAIHero(enemy)
			if RReady() and ValidTarget(enemyHero) and enemyHero.Distance < 260 and CanMove() and IsDashing(enemy) then
				CastSpellTarget(enemyHero.Addr, _R)
			end
		end
	end
end

function Combo()
	local target = GetTarget(1300)

	if target and QReady() and Setting_IsComboUseQ() and GetDistance(myHero.Addr, target.Addr) < myHero.AARange + myHero.CollisionRadius and not CanAttack() and CanMove() then
		CastQ(target)
		SetLuaBasicAttackOnly(true)
		BasicAttack(target.Addr)
		SetLuaBasicAttackOnly(false)
    end

	if target and WReady() and CanMove() and Setting_IsComboUseW() then
		CastW(target)
    end

	if target and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
    end

end

function CastQ(target)
	if ValidTarget(target) then
		CastSpellTarget(myHero.Addr, _Q)
	end
end

function CastW(target)
	if EnemiesAround(myHero.Addr,1000) < 2 and ValidTarget(target) and config_AutoW then
		local vp_distance = VPGetLineCastPosition(target, W.Delay)
		if vp_distance > 0 and vp_distance < W.Range then
			CastSpellToPredictionPos(target.Addr, _W, vp_distance)
		end
	end
end

function CastE(target)
	if target.Distance < E.Range and ValidTarget(target) then
		CastSpellTarget(target.Addr, _E)
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

function KillSteal()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in pairs(Enemies) do
		if enemy ~= 0 then
			local target = GetAIHero(enemy)
			if RReady() and getDmg(_R, target) > target.HP and CanMove() then
				CastSpellTarget(target.Addr, _R)
			end
		end
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _R then
		if myHero.LevelSpell(_R) == 0 then return 0 end
		local DamageSpellRTable = { 140, 210, 280 }
		local Percent_AP = 0.4

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
