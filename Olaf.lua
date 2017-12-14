--[[

Reference link https://github.com/leobogkoda/MyBoL/blob/master/Olaf.lua

Thanks

]]

function UpdateHeroInfo()
	return GetMyChamp()
end


local LaneClearUseMana = 60

local Q = 0
local W = 1
local E = 2
local R = 3


local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local Ranges = { Q = 1000, E = 325, W = 200 }
local Widths = { Q = 30 }
local Delays = { Q = 0.25}
local Speeds = { Q = 1600}


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

function OnLoad()
	--__PrintTextGame("Olaf v1.0 loaded")
end

function OnPlayAnimation(unit, action)

end

function OnDoCast(unit, spell)

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
	if GetChampName(UpdateHeroInfo()) ~= "Olaf" then return end
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
	local Target = GetTarget(1000)

	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsComboUseQ() then
				if QReady() then
					CastQ(Target)
				end
			end
		end
	end

	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsComboUseE() then
				if EReady() then
					CastE(Target)
				end
			end
		end
	end

	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsComboUseW() then
				if WReady() then
					CastW(Target)
				end
			end
		end
	end

end

function CastW(Target)
	if Target ~= 0 and ValidTargetRange(Target, Ranges.W) and not CanAttack() and CanMove() then
		CastSpellTarget(UpdateHeroInfo(), W)
		SetLuaBasicAttackOnly(true)
		BasicAttack(Target)
		SetLuaBasicAttackOnly(false)
	end
end

function CastE(Target)
	if Target ~= 0 and ValidTargetRange(Target, Ranges.E) and CanMove() then
		CastSpellTarget(Target, E)
	end
end

function CastQ(Target)
	if Target ~= 0 and ValidTargetRange(Target, Ranges.Q) and QReady() and CanMove() then
		local vp_distance = VPGetLineCastPosition(Target, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q)
		if vp_distance > 0 and vp_distance < Ranges.Q then
			CastSpellToPredictionPos(Target, Q, vp_distance)
		end
	end
end

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then

		if QReady() and CanMove() and not IsMyManaLowLaneClear() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < Ranges.Q then
				local vp_distance = VPGetLineCastPosition(jungle, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q)
				if vp_distance > 0 and vp_distance < Ranges.Q then
					CastSpellToPredictionPos(jungle, Q, vp_distance)
				end
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 then
			if EReady() and not IsMyManaLowLaneClear() then
				if ValidTargetJungle(jungle) and GetDistance(jungle) < Ranges.E then
					CastSpellTarget(jungle, E)
				end
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 then
			if WReady() and CanMove() and not IsMyManaLowLaneClear() then
				if ValidTargetJungle(jungle) and GetDistance(jungle) < Ranges.W and not CanAttack() then
					CastSpellTarget(UpdateHeroInfo(), W)
					SetLuaBasicAttackOnly(true)
					BasicAttack(jungle)
					SetLuaBasicAttackOnly(false)
				end
			end
		end

	else
		local minion = GetMinion()
		if minion ~= 0 then
			if QReady() and CanMove() and not IsMyManaLowLaneClear() then
				if GetDistance(minion) < Ranges.Q then
					local vp_distance = VPGetLineCastPosition(minion, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q)
					if vp_distance > 0 and vp_distance < Ranges.Q then
						CastSpellToPredictionPos(minion, Q, vp_distance)
					end
				end
			end
		end

		minion = GetMinion()
		if minion ~= 0 then
			if EReady() and not IsMyManaLowLaneClear() then
				if GetDistance(minion) < Ranges.E then
					CastSpellTarget(minion, E)
				end
			end
		end

		minion = GetMinion()
		if minion ~= 0 then
			if WReady() and not IsMyManaLowLaneClear() and not CanAttack() and CanMove() then
				if GetDistance(minion) < Ranges.W then
					CastSpellTarget(UpdateHeroInfo(), W)
					SetLuaBasicAttackOnly(true)
					BasicAttack(minion)
					SetLuaBasicAttackOnly(false)
				end
			end
		end
	end
end

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
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



