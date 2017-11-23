--[[

Reference link https://github.com/powerblobb/GoS-Scripts-for-LoL/blob/master/Fiora.lua

Thanks Celtech team

]]



function UpdateHeroInfo()
	return GetMyChamp()
end


local SpellQ = {Speed = 1700, Range = 400, Delay = 0.25, Width = 50}

local Q = 0
local W = 1
local E = 2
local R = 3

local config_AutoUlt_10_Percent = true
local config_AutoW = true

if GetChampName(UpdateHeroInfo()) == "Fiora" then
	config_AutoUlt_10_Percent  = AddMenuCustom(1, config_AutoUlt_10_Percent, "Auto Ultil When 10%HP")
	config_AutoW  = AddMenuCustom(2, config_AutoW, "Auto W")
end


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

function GetTarget()
	return GetEnemyChampCanKillFastest(1550)
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

function ValidTargetRange(Target, Range)
	if ValidTarget(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end

function OnTick()
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
	local Target = GetTarget()
	if Target ~= 0 then
		if QReady() and ValidTarget(Target) and Setting_IsComboUseQ() and CanMove() then
			if GetItemByID(3077) == 0 and GetItemByID(3074) == 0 then
				if GetDistance(Target) < 400 then
					local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
					if vp_distance > 0 and vp_distance < SpellQ.Range then
						CastSpellToPredictionPos(Target, Q, vp_distance)
					end
				end
			end

			if GetItemByID(3077) ~= 0 or GetItemByID(3074) ~= 0 then
				if GetDistance(Target) < 450 then
					local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, 400, 450, SpellQ.Speed)
					if vp_distance > 0 and vp_distance < 450 then
						CastSpellToPredictionPos(Target, Q, vp_distance)
					end
				end
			end
		end

		if GetDistance(Target) < 550 then
			-- ItemTiamatCleave, ItemTitanicHydraCleave
			local ItemTiamatCleave = GetSpellIndexByName("ItemTiamatCleave")
			local ItemTitanicHydraCleave = GetSpellIndexByName("ItemTitanicHydraCleave")
			if ItemTiamatCleave and CanCast(ItemTiamatCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTiamatCleave")
			elseif ItemTitanicHydraCleave and CanCast(ItemTitanicHydraCleave) then
				CastSpellTargetByName(UpdateHeroInfo(), "ItemTitanicHydraCleave")
			end
		end

		if WReady() and ValidTarget(Target) and Setting_IsComboUseW() and CanMove() and config_AutoW then
			if GetDistance(Target) < 750 then
				local vp_distance = VPGetLineCastPosition(Target, 0.25, 50, 750, 1700)
				if vp_distance > 0 and vp_distance < 750 then
					CastSpellToPredictionPos(Target, W, vp_distance)
				end
			end
		end

		if EReady() and ValidTarget(Target) and Setting_IsComboUseE() and CanMove() then
			if GetDistance(Target) < 260 then
				CastSpellTarget(UpdateHeroInfo(), E)
			end
		end

		if RReady() and ValidTarget(Target) and Setting_IsComboUseR() and CanMove() then
			if GetDistance(Target) < 500 then
				if config_AutoUlt_10_Percent then
					if 10 > (100 * GetHealthPoint(Target) / GetHealthPointMax(Target)) then
						CastSpellTarget(Target, R)
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

function LaneClear()
	local jungle = GetJungleMonster(1000)
	if jungle ~= 0 then

		if QReady() and ValidTargetJungle(jungle) and Setting_IsLaneClearUseQ() and CanMove() then
			if GetItemByID(3077) == 0 and GetItemByID(3074) == 0 then
				if GetDistance(jungle) < 400 then
					local vp_distance = VPGetLineCastPosition(jungle, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
					if vp_distance > 0 and vp_distance < SpellQ.Range then
						CastSpellToPredictionPos(jungle, Q, vp_distance)
					end
				end
			end

			if GetItemByID(3077) ~= 0 or GetItemByID(3074) ~= 0 then
				if GetDistance(jungle) < 450 then
					local vp_distance = VPGetLineCastPosition(jungle, SpellQ.Delay, 400, 450, SpellQ.Speed)
					if vp_distance > 0 and vp_distance < 450 then
						CastSpellToPredictionPos(jungle, Q, vp_distance)
					end
				end
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

		if WReady() and ValidTargetJungle(jungle) and Setting_IsLaneClearUseW() and CanMove() and config_AutoW then
			if GetDistance(jungle) < 750 then
				local vp_distance = VPGetLineCastPosition(jungle, 0.25, 50, 750, 1700)
				if vp_distance > 0 and vp_distance < 750 then
					CastSpellToPredictionPos(jungle, W, vp_distance)
				end
			end
		end

		if EReady() and ValidTargetJungle(jungle) and Setting_IsLaneClearUseE() and CanMove() then
			if GetDistance(jungle) < 450 then
				CastSpellTarget(UpdateHeroInfo(), E)
			end
		end

	else
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

function OnProcessSpell(unit, spell)
end

function OnCreateObject(unit)
end

function OnDeleteObject(unit)
end

function OnWndMsg(msg, key)

end
