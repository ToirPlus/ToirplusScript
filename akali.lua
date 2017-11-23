--[[

Reference link https://raw.githubusercontent.com/RK1K/RKScriptFolder/master/RK%20Heros.lua

Thanks

]]





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

function GetTarget()
	return GetEnemyChampCanKillFastest(900)
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
	if GetChampName(GetMyChamp()) ~= "Akali" then return end
	if IsDead(UpdateHeroInfo()) then return end

	AutoW()

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
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
	local minion = GetMinion()
	if minion ~= 0 then
		if QReady() and CanMove() and Setting_IsLaneClearUseQ() then
			CastSpellTarget(minion, _Q)
		end
	end

	minion = GetMinion()
	if minion ~= 0 then
		if QReady() and CanMove() and Setting_IsLaneClearUseQ() then
			CastSpellTarget(minion, _E)
		end
	end

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
	local target = GetTarget()

	if target ~= 0 and RReady() and CanMove() and Setting_IsComboUseR() then
		CastR(target)
    end

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
	end

	if target ~= 0 and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
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
