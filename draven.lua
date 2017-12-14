--[[

Reference link https://github.com/Dienofail/BoL/blob/master/common/SidasAutoCarryPlugin%20-%20Draven.lua


]]

function UpdateHeroInfo()
	return GetMyChamp()
end


local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local Q = 0
local W = 1
local E = 2
local R = 3


local config_Auto_caughtAxe = true

if GetChampName(UpdateHeroInfo()) == "Draven" then
	config_Auto_caughtAxe = AddMenuCustom(1, config_Auto_caughtAxe, "Auto Caught Axe")
end

local LaneClearUseMana = 60
local HarassUseMana = 60

local SpellE = {Delay = 0.251, Width = 130, Range = 1100, Speed = 1400 }
local SpellR = {Delay = 0.500, Width = 160, Range = 2500, Speed = 2000 }



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


local Axe = 0

local time1 = 0
local time2 = 0

local delay = 0

function OnWndMsg(msg, key)

end

function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Draven" then return end
	if IsDead(UpdateHeroInfo()) then return end
	if IsTyping() then return end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end


	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	time2 = GetTimeGame()
	if time2 - time1 > delay and delay > 0 and config_Auto_caughtAxe then
		delay = 0
		SetLuaMoveOnly(false)
		UnBlockMove()
	end

	--[[
	if nKeyCode == CKeyCode then
		SetLuaHarass(true)
		Harass()
	end



	KillSteal()
	]]



end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

end

function OnLoad()
	--__PrintTextGame("Draven v1.0 loaded")
end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)
	--__PrintTextGame(GetBuffName(buff))
end

function OnRemoveBuff(unit, buff)
end

function OnProcessSpell(unit, spell)
end

function OnCreateObject(unit)
	local name = GetObjName(unit.Addr)
	if name == "Draven_Base_Q_reticle" then
		Axe = unit
	end
end

function OnDeleteObject(unit)
	local name = GetObjName(unit.Addr)
	if name == "Draven_Base_Q_reticle" then
		Axe = 0
	end
end


function LaneClear()
	if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
		CastSpellTarget(UpdateHeroInfo(), Q)
	end

	if config_Auto_caughtAxe then
		Auto_caughtAxe()
	end

end

function Auto_caughtAxe()
	if Axe ~= 0 then

		local x= GetPosX(Axe.Addr)
		local z= GetPosZ(Axe.Addr)


		if CanMove() and CheckDistance(x,z) < 300 and CheckDistance(x,z) > 90 then
			BlockMove()
			SetLuaMoveOnly(true)
			MoveToPos(x, z)
			delay = CheckDistance(x,z) / GetMoveSpeed(UpdateHeroInfo())
			time1 = GetTimeGame()
		end
	end

end

function Auto_caughtAxe_combo()
	if Axe ~= 0 then

		local x= GetPosX(Axe.Addr)
		local z= GetPosZ(Axe.Addr)

		if CanMove() and CheckDistance(x,z) < 300 and CheckDistance(x,z) > 90 then
			SetLuaMoveOnly(true)
			MoveToPos(x, z)
			delay = CheckDistance(x,z) / GetMoveSpeed(UpdateHeroInfo())
			time1 = GetTimeGame()

		end
	end

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

function CheckDistance(x,z)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	return GetDistance2D(x1,z1,x,z)
end

function IsMyManaLowHarass()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( HarassUseMana / 100)) then
        return true
    else
        return false
    end
end

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end


function Combo()
	local Target = GetTarget(1200)

	if QReady() and ValidTarget(Target) and Setting_IsComboUseQ() and CanMove() then
		CastQ(Target)
	end

	if config_Auto_caughtAxe then
		Auto_caughtAxe_combo()
	end

	if WReady() and ValidTarget(Target) and Setting_IsComboUseW() and CanMove() then
		CastW(Target)
	end

	if EReady() and ValidTarget(Target) and Setting_IsComboUseE() and CanMove() then
		CastE(Target)
	end

	if RReady() and ValidTarget(Target) and Setting_IsComboUseR() and CanMove() then
		CastR(Target)
	end
end


function CastQ(Target)
	if Target ~= 0 then
		CastSpellTarget(UpdateHeroInfo(), Q)
	end
end

function CastW(Target)
	if Target ~= 0 and ValidTargetRange(Target, 1200) and WReady() and GetBuffStack(UpdateHeroInfo(), "dravenfurybuff") == 0 then
		CastSpellTarget(UpdateHeroInfo(), W)
	end
end


function CastE(Target)
	if Target ~= 0 and ValidTargetRange(Target, 800) and EReady() then

		local vp_distance = VPGetLineCastPosition(Target, SpellE.Delay, SpellE.Width, SpellE.Range, SpellE.Speed)
		--__PrintTextGame("Cast E")
		--__PrintTextGame(tostring(vp_distance))
		if vp_distance > 0 and vp_distance < SpellE.Range then
			--__PrintTextGame("Cast E 2")
			CastSpellToPredictionPos(Target, E, vp_distance)
		end
	end
end

function CastR(Target)
	if Target ~= 0 and RReady() and ValidTargetRange(Target, 2000) and getDmg(R, Target) * 2 > GetHealthPoint(Target) then

		local vp_distance = VPGetLineCastPosition(Target, SpellR.Delay, SpellR.Width, SpellR.Range, SpellR.Speed)

		if vp_distance > 0 and vp_distance < SpellR.Range then

			CastSpellToPredictionPos(Target, R, vp_distance)
		end
	end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == R then
		if GetSpellLevel(UpdateHeroInfo(),R) == 0 then return 0 end

		local DamageSpellRTable = {175, 275, 375}

		local Percent_Bonus_AD = 1

		local Damage_Bonus_AD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(UpdateHeroInfo(),R)]

		local Enemy_Armor = GetArmor(Enemy)

		local Dominik_ID = 3036--Lord Dominik's Regards
		local Mortal_Reminder_ID = 3033--Mortal Reminder

		if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
			Enemy_Armor = Enemy_Armor - GetBonusArmor(Enemy) * 45/100
		end

		local ArmorPenetration = 60 * GetArmorPenetration(UpdateHeroInfo()) / 100 + (1 - 60/100) * GetArmorPenetration(UpdateHeroInfo()) * GetLevel(Enemy) / 18

		Enemy_Armor = Enemy_Armor - ArmorPenetration

		if Enemy_Armor >= 0 then
			Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (100/(100 + Enemy_Armor))
		else
			Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (2 - 100/(100 - Enemy_Armor))
		end

		return Damage
	end

end
