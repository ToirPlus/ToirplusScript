--[[

Reference link https://github.com/powerblobb/GoS-Scripts-for-LoL/blob/master/Fiora.lua

Thanks Celtech team

]]

--IncludeFile("Lib\\Vector.lua")

local myHero = GetMyHero()

function UpdateHeroInfo()
	return GetMyChamp()
end

local LaneClearUseMana = 40

local SpellQ = {Speed = 1700, Range = 400, Delay = 0.25, Width = 50}

local Q = 0
local W = 1
local E = 2
local R = 3


local config_AutoW = true

if GetChampName(UpdateHeroInfo()) == "Fiora" then
	config_AutoW  = AddMenuCustom(1, config_AutoW, "Auto W")
end

local Defender = {["Aatrox"] = {_E},["Ahri"] = {_Q,_W,_E,_R},["Anivia"] = {_Q,_E},["Annie"] = {_Q},["Amumu"] = {_Q},["Blitzcrank"] = {_Q},["Brand"] = {_Q,_R},["Caitlyn"] = {_Q,_E},["Cassiopeia"] = {_W,_E},["Corki"] = {_R},["DrMundo"] = {_Q},["Elise"] = {_Q,_E},["Ezreal"] = {_Q,_W},["Galio"] = {_Q,_E},["Gangplank"] = {_Q},["Gnar"] = {_Q},["Graves"] = {_Q,_R},["Heimerdinger"] = {_W},["Irelia"] = {_R},["Jinx"] = {_W},["Kalista"] = {_Q},["Karma"] = {_Q},["Kassadin"] = {_Q},["Leblanc"] = {_Q,_E},["Leesin"] = {_Q},["Leona"] = {_E},["Lux"] = {_Q,_E},["Morgana"] = {_Q},["Pantheon"] = {_Q},["Quinn"] = {_Q},["Rengar"] = {_E},["Ryze"] = {_Q},["Sejuani"] = {_R},["Sivir"] = {_Q},["Skarner"] = {_E},["Teemo"] = {_Q},["Thresh"] = {_Q},["Varus"] = {_Q},["Vayne"] = {_E},["Veigar"] = {_R},["Twistedfate"] = {_Q},["Velkoz"] = {_Q},["Zed"] = {_Q}}

local Fiora_Base_Passive_Obj = nil

local Fiora_Base_Passive_Speed_Buf = nil

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

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
	return GetEnemyChampCanKillFastest(range)

	--[[SearchAllChamp()
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
	]]

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
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	return GetDistance2D(x1,z1,x2,z2)
end

function GetDistance2Pos(x,z)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	return GetDistance2D(x1,z1,x,z)
end

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

end

function OnTick()
	myHero = GetMyHero()

	if GetChampName(UpdateHeroInfo()) ~= "Fiora" then return end
	if IsDead(UpdateHeroInfo()) then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		LaneClear()
	end

end

function Combo()
	local Target = GetTarget(1100)
	if Target ~= 0 then
		if QReady() and ValidTarget(Target) and Setting_IsComboUseQ() and CanMove() then
			local t = GetAIHero(Target)
			if t and getDmg(_Q, t) > t.HP then
				local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
				if vp_distance > 0 and vp_distance < SpellQ.Range + 350 then
					CastSpellToPredictionPos(Target, _Q, vp_distance)
				end
			end
			if Fiora_Base_Passive_Speed_Buf then
				if GetDistance(Target) < SpellQ.Range + 350 then
					CastSpellToPos(GetPosX(Target), GetPosZ(Target), _Q)
				end
			elseif Fiora_Base_Passive_Obj then
				local name = GetObjName(Fiora_Base_Passive_Obj.Addr)
				local distance = 80

				if name then
					local x, z = 0, 0
					if name:lower():find("fiora_base_passive_se.troy") then
						x, z = Fiora_Base_Passive_Obj.x - distance, Fiora_Base_Passive_Obj.z
					end

					if name:lower():find("fiora_base_passive_ne.troy") then
						x, z = Fiora_Base_Passive_Obj.x, Fiora_Base_Passive_Obj.z + distance
					end

					if name:lower():find("fiora_base_passive_sw.troy") then
						x, z = Fiora_Base_Passive_Obj.x, Fiora_Base_Passive_Obj.z - distance
					end

					if name:lower():find("fiora_base_passive_nw.troy") then
						x, z = Fiora_Base_Passive_Obj.x + distance, Fiora_Base_Passive_Obj.z
					end

					if GetDistance2Pos(x,z) < SpellQ.Range + 350 then
						CastSpellToPos(x, z, _Q)
					end
				end
			end
		end

		if CanAttack() and not QReady() then
			SetLuaBasicAttackOnly(true)
			BasicAttack(Target)
			SetLuaBasicAttackOnly(false)
			--__PrintTextGame("AA1")
		end

		if EReady() and ValidTarget(Target) and Setting_IsComboUseE() and CanMove() and not CanAttack() then
			if GetDistance(Target) < GetAttackRange(UpdateHeroInfo()) + GetOverrideCollisionRadius(UpdateHeroInfo()) then
				CastSpellTarget(UpdateHeroInfo(), E)
				--__PrintTextGame("E")
				SetLuaBasicAttackOnly(true)
				BasicAttack(Target)
				SetLuaBasicAttackOnly(false)
				--__PrintTextGame("AA2")
			end
		end

		if GetDistance(Target) < 550 and not EReady() then
			-- ItemTiamatCleave, ItemTitanicHydraCleave
			local ItemTiamatCleave = GetSpellIndexByName("ItemTiamatCleave")
			local ItemTitanicHydraCleave = GetSpellIndexByName("ItemTitanicHydraCleave")
			if ItemTiamatCleave and CanCast(ItemTiamatCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTiamatCleave")
				--__PrintTextGame("ItemTiamatCleave")
			elseif ItemTitanicHydraCleave and CanCast(ItemTitanicHydraCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTitanicHydraCleave")
				--__PrintTextGame("ItemTitanicHydraCleave")
			end

		end

		if CanAttack() and not EReady() then
			SetLuaBasicAttackOnly(true)
			BasicAttack(Target)
			SetLuaBasicAttackOnly(false)
			--__PrintTextGame("AA3")
		end

		if WReady() and ValidTarget(Target) and config_AutoW and EnemiesAround(Target, 1100) == 0 and (getDmg(_R, GetAIHero(Target)) > GetHealthPoint(Target) or getDmg(_Q, GetAIHero(Target)) > GetHealthPoint(Target)) and RReady() then
			if GetDistance(Target) < 700 then
				local vp_distance = VPGetLineCastPosition(Target, 0.25, 50, 750, 1700)
				if vp_distance > 0 and vp_distance < 700 then
					CastSpellToPredictionPos(Target, W, vp_distance)
				end
			end
		end

		if RReady() and ValidTarget(Target) and Setting_IsComboUseR() and CanMove() and ( (AlliesAround(Target,1100) > EnemiesAround(Target, 1100) and EnemiesAround(Target, 1100) < 2 and getDmg(_R, GetAIHero(Target)) > GetHealthPoint(Target)) or (getDmg(_R, GetAIHero(Target))/2 > GetHealthPoint(Target)) or (EnemiesAround(Target, 1100) < 1 and getDmg(_R, GetAIHero(Target)) > GetHealthPoint(Target))) then
			if GetDistance(Target) < 500 then
				CastSpellTarget(Target, R)
			end
		end

	end
end

function EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function AlliesAround(object, range)
	return CountAllyChampAroundObject(object, range)
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

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then

		if QReady() and ValidTargetJungle(jungle) and Setting_IsLaneClearUseQ() and CanMove() then
			local vp_distance = VPGetLineCastPosition(jungle, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
			if vp_distance > 0 and vp_distance < SpellQ.Range then
				CastSpellToPredictionPos(jungle, Q, vp_distance)
			end
		end

		if ValidTargetJungle(jungle) and GetDistance(jungle) < 550 then
			local ItemTiamatCleave = GetSpellIndexByName("ItemTiamatCleave")
			local ItemTitanicHydraCleave = GetSpellIndexByName("ItemTitanicHydraCleave")
			if ItemTiamatCleave and CanCast(ItemTiamatCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTiamatCleave")
			elseif ItemTitanicHydraCleave and CanCast(ItemTitanicHydraCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTitanicHydraCleave")
			end
		end

		if EReady() and ValidTargetJungle(jungle) and Setting_IsLaneClearUseE() and CanMove() then
			if GetDistance(jungle) < 450 then
				CastSpellTarget(UpdateHeroInfo(), E)
			end
		end

	else
		LastHitMinionUseQ()

		local minion = GetMinion()
		if minion ~= 0 then
			if GetDistance(minion) < 550 then
				-- ItemTiamatCleave, ItemTitanicHydraCleave
				local ItemTiamatCleave = GetSpellIndexByName("ItemTiamatCleave")
				local ItemTitanicHydraCleave = GetSpellIndexByName("ItemTitanicHydraCleave")
				if ItemTiamatCleave and CanCast(ItemTiamatCleave) then
					CastSpellTargetByName(UpdateHeroInfo(), "ItemTiamatCleave")
				elseif ItemTitanicHydraCleave and CanCast(ItemTitanicHydraCleave) then
					CastSpellTargetByName(UpdateHeroInfo(), "ItemTitanicHydraCleave")
				end
			end
		end


	end
end

function LastHitMinionUseQ()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and getDmg(_Q, unit) > unit.HP then
				if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
					if GetDistance(unit.Addr) < SpellQ.Range then
						if (unit.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (unit.Distance >= myHero.AARange + myHero.CollisionRadius) then
							CastSpellToPos(unit.x, unit.z, _Q)
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

function OnLoad()
	--__PrintTextGame("Fiora v1.0 loaded")
end

function OnUpdate()
end


function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)

end

function OnRemoveBuff(unit, buff)
end

function CheckEnemyHero(Target)
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if ValidTarget(enemy) and enemy == Target then
				return true
			end
		end
	end

	return false
end

function OnProcessSpell(unit, spell)
	if GetChampName(UpdateHeroInfo()) ~= "Fiora" then return end
	if unit and spell and not unit.IsMe and CheckEnemyHero(unit.Addr) then

		--[[
		local spell_distance = 0
		if spell.DestPos_x > 0 then
			spell_distance = GetDistance2D(spell.DestPos_x,spell.DestPos_z,spell.SourcePos_x,spell.SourcePos_z)
		end
		]]

		if Defender[unit.OwnerCharName] then
			local Spellslots = Defender[unit.OwnerCharName]
			for i, Spellslot in ipairs(Spellslots) do
				if Spellslot == _Q or Spellslot == _W or Spellslot == _E or Spellslot == _R then
					if WReady() and ValidTarget(unit.Addr) and config_AutoW then
						if GetDistance(unit.Addr) < 700 then
							local vp_distance = VPGetLineCastPosition(unit.Addr, 0.25, 50, 750, 1700)
							if vp_distance > 0 and vp_distance < 700 then
								CastSpellToPredictionPos(unit.Addr, _W, vp_distance)
							end
						end
					end
				end
			end
		else
			--[[if WReady() and ValidTarget(unit.Addr) and config_AutoW and EnemiesAround(Target, 1100) < 2 then
				if GetDistance(unit.Addr) < 700 then
					local vp_distance = VPGetLineCastPosition(unit.Addr, 0.25, 50, 750, 1700)
					if vp_distance > 0 and vp_distance < 750 then
						CastSpellToPredictionPos(unit.Addr, W, vp_distance)
					end
				end
			end]]
		end
	end
end

function OnCreateObject(unit)
	local name = GetObjName(unit.Addr)
	if name:lower():find("fiora_base_passive_speed_buf.troy") then
		Fiora_Base_Passive_Speed_Buf = unit
		Fiora_Base_Passive_Obj = nil
	end

	if (name:lower():find("fiora_base_passive_se.troy") or name:lower():find("fiora_base_passive_ne.troy") or name:lower():find("fiora_base_passive_sw.troy") or name:lower():find("fiora_base_passive_nw.troy"))
		or (name:lower():find("fiora_base_passive_se_warning.troy") or name:lower():find("fiora_base_passive_ne_warning.troy") or name:lower():find("fiora_base_passive_sw_warning.troy") or name:lower():find("fiora_base_passive_nw_warning.troy"))
	then --se ne sw nw
		Fiora_Base_Passive_Obj = unit
	end
end

function OnDeleteObject(unit)
	local name = GetObjName(unit.Addr)
	if name:lower():find("fiora_base_passive_speed_buf.troy") then
		Fiora_Base_Passive_Speed_Buf = nil
	end
	if name:lower():find("fiora_base_passive_se_timeout.troy") or name:lower():find("fiora_base_passive_ne_timeout.troy") or name:lower():find("fiora_base_passive_sw_timeout.troy") or name:lower():find("fiora_base_passive_nw_timeout.troy") then --se ne sw nw
		Fiora_Base_Passive_Obj = nil
	end
end

function OnWndMsg(msg, key)

end

function getDmg(Spell, Enemy)
	local Damage = 0


	if Spell == _Q then
		if GetSpellLevel(UpdateHeroInfo(),_Q) == 0 then return 0 end

		local DamageSpellQTable = {65, 75, 85, 95, 105}

		local DamageSpellQTable_Bonus_AD = {0.95, 1, 1.05, 1.1, 1.15}

		local Percent_Bonus_AD = DamageSpellQTable_Bonus_AD[GetSpellLevel(UpdateHeroInfo(),_Q)]

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

	if Spell == _R then
		if GetSpellLevel(UpdateHeroInfo(),_R) == 0 then return 0 end

		Damage = 0.1 * GetHealthPointMax(Enemy)

		return Damage
	end
end
