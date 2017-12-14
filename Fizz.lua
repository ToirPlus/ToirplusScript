--[[

Reference link https://raw.githubusercontent.com/RK1K/RKScriptFolder/master/RK%20Heros.lua, https://github.com/dd2repo/BoL/blob/master/Fisherman%20Fizz.lua

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

local Spells = {
	Q = {range = 550,   delay = 0.5, width = 0,   speed = math.huge},
	W = {range = 900,   delay = 0.5, width = 80,  speed = 1450},
	E = {range = 700,   delay = 0.5, width = 100, speed = 1300},
	R = {range = 1275,  delay = 0.5, width = 250, speed = 1200}
}

local wactive = false

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
	return GetEnemyChampCanKillFastest(1275)
end

function OnLoad()
	--__PrintTextGame("Fizz v1.0 loaded")
end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)
	if buff.Name == "FizzSeastonePassive" and unit.IsMe then
		wactive = true
	end
end

function OnRemoveBuff(unit, buff)
	if buff.Name == "FizzSeastonePassive" and unit.IsMe then
		wactive = false
	end
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
	if GetChampName(UpdateHeroInfo()) ~= "Fizz" then return end
	if IsDead(UpdateHeroInfo()) then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(VKeyCode) == 1 then
		LaneClear()
	end
end

function Combo()
	local Target = GetTarget()

	if Target ~= 0 and GetDistance(Target) < Spells.R.range and CanMove() and Setting_IsComboUseR() and RReady() then
		CastR(Target)
	end

	if Target ~= 0 and GetDistance(Target) < Spells.Q.range and CanMove() and Setting_IsComboUseQ() and QReady() then
		CastQ(Target)
	end

	if Target ~= 0 and GetDistance(Target) < Spells.W.range and Setting_IsComboUseW() and WReady() then
		CastW(Target)
	end

	if Target ~= 0 and GetDistance(Target) < Spells.E.range and CanMove() and Setting_IsComboUseE() and EReady() then
		CastE(Target)
	end

end

function CastE(Target)
	if ValidTarget(Target) then
		local vp_distance = VPGetCircularCastPosition(Target, Spells.E.delay, Spells.E.width)
		if vp_distance > 0 and vp_distance < Spells.E.range then
			CastSpellToPredictionPos(Target, E, vp_distance)
		end
	end
end

function CastW(Target)
	if ValidTarget(Target) and not wactive then
		CastSpellTarget(UpdateHeroInfo(), W)
	end
end

function CastQ(Target)
	if ValidTarget(Target) then
		CastSpellTarget(Target, Q)
	end
end

function CastR(Target)
	if ValidTarget(Target) then
		local vp_distance = VPGetLineCastPosition(Target, Spells.R.delay, Spells.R.width, Spells.R.range, Spells.R.speed)
		if vp_distance > 0 and vp_distance < Spells.R.range then
			CastSpellToPredictionPos(Target, R, vp_distance)
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

function VPGetCircularCastPosition(Target, Delay, Width)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	local TimeMissile = Delay
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

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then

		if QReady() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < Spells.Q.range and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
				CastSpellTarget(jungle, Q)
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 then
			if WReady() and not wactive then
				if ValidTargetJungle(jungle) and GetDistance(jungle) < Spells.W.range and Setting_IsLaneClearUseW() and not IsMyManaLowLaneClear() then
					CastSpellTarget(UpdateHeroInfo(), W)
				end
			end
		end

		jungle = GetJungleMonster(1000)
		if jungle ~= 0 then
			if EReady() and CanMove() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				if ValidTargetJungle(jungle) and GetDistance(jungle) < Spells.E.range then
					local vp_distance = VPGetCircularCastPosition(jungle, Spells.E.delay, Spells.E.width)
					if vp_distance > 0 and vp_distance < Spells.E.range then
						CastSpellToPredictionPos(jungle, E, vp_distance)
					end
				end
			end
		end

	else
		local minion = GetMinion()
		if minion ~= 0 then
			if QReady() and CanMove() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
				if GetDistance(minion) < Spells.Q.range then
					CastSpellTarget(minion, Q)
				end
			end
		end

		minion = GetMinion()
		if minion ~= 0 then
			if WReady() and not wactive and Setting_IsLaneClearUseW() and not IsMyManaLowLaneClear() then
				if GetDistance(minion) < Spells.W.range then
					CastSpellTarget(UpdateHeroInfo(), W)
				end
			end
		end

		minion = GetMinion()
		if minion ~= 0 then
			if EReady() and CanMove() and Setting_IsLaneClearUseE() and not IsMyManaLowLaneClear() then
				if GetDistance(minion) < Spells.E.range then
					local vp_distance = VPGetCircularCastPosition(minion, Spells.E.delay, Spells.E.width)
					if vp_distance > 0 and vp_distance < Spells.E.range then
						CastSpellToPredictionPos(minion, E, vp_distance)
					end
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
