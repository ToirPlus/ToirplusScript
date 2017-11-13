--[[

Reference link https://github.com/Dienofail/BoL/blob/master/Jayce.lua


]]

IncludeFile("Lib\\Vector.lua")


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

local SpellRangedQ1 = {Range = 1150, Speed = 1300, Delay = 0.1515, Width = 70}
local SpellRangedQ2 = {Range = 1750, Speed = 2350, Delay = 0.1515, Width = 70}
local SpellHammerQ = {Range = 600, Speed = math.huge, Delay = 0.250, Width = 0}
local SpellRangedW = {Range = math.huge, Speed = math.huge, Delay = 0.250, Width = 0}
local SpellHammerW = {Range = 350, Speed = math.huge, Delay = 0.264, Width = 0}
local SpellRangedE = {Range = 600, Speed = math.huge, Delay = 0.100, Width = 120}
local SpellHammerE = {Range = 240, Speed = math.huge, Delay = 0.250, Width = 80}

local isHammer = true

local LaneClearUseMana = 60

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
	return GetEnemyChampCanKillFastest(1750)
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
	if GetChampName(UpdateHeroInfo()) ~= "Jayce" then return end
	if IsDead(UpdateHeroInfo()) then return end

	CheckForm()

	KillSteal()

	local nKeyCode = GetKeyCode()

	if nKeyCode == VKeyCode then
		LaneClear()
	end


	if nKeyCode == SpaceKeyCode then
		SetLuaCombo(true)
		Combo()
	end


	if nKeyCode == CKeyCode then
		SetLuaHarass(true)
		Harass()
	end

end

function KillSteal()
	local Target = GetTarget()

	if Target ~= 0 and GetHealthPoint(Target) < getDmg(Q, Target) and ValidTargetRange(Target, 1500) then
		if isHammer and GetDistance(Target) < SpellRangedQ1.Range-150 then
			CastR('Ranged')
		elseif not isHammer and GetDistance(Target) < SpellRangedQ1.Range then
			CastRangedQ(Target)
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

function Harass()
    local Target = GetTarget()
	if isHammer then
        CastR('Ranged')
    end
    if not isHammer and ValidTargetRange(Target,750) then
        CastRangedQ(Target)
    end
end

function Combo()
	local Target = GetTarget()

	if isHammer then
        if Target ~= 0 and ValidTarget(Target) and QReady() and Setting_IsComboUseQ() and CanMove() and GetDistance(Target) < 600 then
			CastSpellTarget(Target, Q)
		end

		if Target ~= 0 and ValidTarget(Target) and WReady() and Setting_IsComboUseW() and CanMove() and GetDistance(Target) < 300 then
			CastSpellTarget(UpdateHeroInfo(), W)
		end

		if Target ~= 0 and ValidTarget(Target) and EReady() and Setting_IsComboUseE() and CanMove() and not CheckWBuffStatus() then
			CastSpellTarget(Target, E)
		end


        if RReady() and ValidTarget(Target) and Setting_IsComboUseR() and GetDistance(Target) > 300 then
            CastR('Ranged')
        end

    else
        if Target ~= 0 and ValidTarget(Target) and QReady() and Setting_IsComboUseQ() and CanMove() then
            CastRangedQ(Target)
        end

        if Target ~= 0 and ValidTarget(Target) and WReady() and Setting_IsComboUseW() and GetDistance(Target) < 600 then
            CastSpellTarget(UpdateHeroInfo(), W)
        end

        if RReady() and ValidTarget(Target) and Setting_IsComboUseR() then
            if GetDistance(Target) < 300 then
                CastR('Hammer')
            end
        end

    end

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

function CheckForm()
    if GetSpellNameByIndex(UpdateHeroInfo(), Q) ~= "JayceShockBlast" then
		isHammer = true
	else
		isHammer = false
	end

end


function CheckWBuffStatus()
    if GetBuffCount(UpdateHeroInfo(), "JayceHyperCharge") ~= 0 and Setting_IsComboUseW() then
        return true
    else
        return false
    end
end


function SpellQCollision(Target, Delay, Width, Range, Speed, vp_distance)

	local PredPosX = GetPredictionPosX(Target, vp_distance)
	local PredPosZ = GetPredictionPosZ(Target, vp_distance)

	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local nCountMinionCollision = 0


	if PredPosX ~= 0 and PredPosZ ~= 0 then

		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, PredPosX, PredPosZ, Width, Range, 10)
	else

		nCountMinionCollision = CountObjectCollision(0, Target, x1, z1, x2, z2, Width, Range, 10)
	end

	if nCountMinionCollision == 0 then
		return false
	end

	return true

end

function CastRangedQ(Target)
	if EReady() and GetManaPoint(UpdateHeroInfo()) > 105 then
		local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }
		local objPos = { GetPosX(Target), GetPosY(Target), GetPosZ(Target) }

		local GateVector = Vector(myHeroPos) + Vector(Vector(objPos) - Vector(myHeroPos)):Normalized()*150

		CastSpellToPos(GateVector.x, GateVector.z, E)

		local vp_distance = VPGetLineCastPosition(Target, SpellRangedQ2.Delay, SpellRangedQ2.Width, SpellRangedQ2.Range, SpellRangedQ2.Speed)
		if vp_distance > 0 and vp_distance < SpellRangedQ2.Range + 150 then
			if not SpellQCollision(Target, SpellRangedQ2.Delay, SpellRangedQ2.Width, SpellRangedQ2.Range, SpellRangedQ2.Speed, vp_distance) then
				CastSpellToPredictionPos(Target, Q, vp_distance)
			end
		end
	end

	if not EReady() then
		local vp_distance = VPGetLineCastPosition(Target, SpellRangedQ1.Delay, SpellRangedQ1.Width, SpellRangedQ1.Range, SpellRangedQ1.Speed)
		if vp_distance > 0 and vp_distance < SpellRangedQ1.Range then
			if not SpellQCollision(Target, SpellRangedQ1.Delay, SpellRangedQ1.Width, SpellRangedQ1.Range, SpellRangedQ1.Speed, vp_distance) then
				CastSpellToPredictionPos(Target, Q, vp_distance)
			end
		end
	end
end


function CastR(form)
	local target = GetTarget()
    if RReady() and form == 'Hammer' then
        if not isHammer then
            if WReady() and target ~= 0 and ValidTarget(target) and GetDistance(target) < 600 then
                CastSpellTarget(UpdateHeroInfo(), W)
				--sleep(0.1)
                CastSpellTarget(UpdateHeroInfo(), R)
            else
                CastSpellTarget(UpdateHeroInfo(), R)
            end
        end
    elseif RReady() and form == 'Ranged' then
        if isHammer then
            CastSpellTarget(UpdateHeroInfo(), R)
        end
    end
end


function OnLoad()
	__PrintTextGame("Jayce v1.0 loaded")
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

function LaneClear()
	if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() then
        FarmQ()
    end

    if WReady() and Setting_IsLaneClearUseW() and not IsMyManaLowLaneClear() then
        CastSpellTarget(UpdateHeroInfo(), W)
    end
end

function CastEQFarm(pos)
    if not isHammer then
		local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }
		local objPos = { GetPosX(pos), GetPosY(pos), GetPosZ(pos) }

		local GateVector = Vector(myHeroPos) + Vector(Vector(objPos) - Vector(myHeroPos)):Normalized()*150

		if EReady() and GetManaPoint(UpdateHeroInfo()) > 105 then
			CastSpellToPos(GateVector.x, GateVector.z, E)
		end

		local vp_distance = VPGetLineCastPosition(pos, SpellRangedQ2.Delay, SpellRangedQ2.Width, SpellRangedQ2.Range, SpellRangedQ2.Speed)
		if vp_distance > 0 and vp_distance < SpellRangedQ2.Range + 150 then
			CastSpellToPredictionPos(pos, Q, vp_distance)
		end
    end
end



function FarmQ()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellRangedQ1.Range)
	local Enemies = pUnit

	if QReady() and table.getn(Enemies) > 0 and CanMove() then
        local QPos = GetBestQPositionFarm()
        if QPos then
            if not isHammer then
                CastEQFarm(QPos)
            else
				CastSpellTarget(QPos, Q)
            end
        end
    end
end

function GetBestQPositionFarm()
    local MaxQ = 0
    local MaxQPos

	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellRangedQ1.Range)
	local Enemies = pUnit

    for i, minion in pairs(Enemies) do
		if minion ~= 0 and IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
			local hitQ = countminionshitQ(minion)
			if hitQ ~= nil and hitQ > MaxQ or MaxQPos == nil then
				MaxQPos = minion
				MaxQ = hitQ
			end
		end
    end

    if MaxQPos then
        local CastPosition = MaxQPos
        return CastPosition
    else
        return nil
    end
end

function countminionshitQ(pos)
    local n = 0

	GetAllUnitAroundAnObject(UpdateHeroInfo(), SpellRangedQ1.Range)
	local Enemies = pUnit

	for i, minion in ipairs(Enemies) do
        if minion ~= 0 and IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 and GetDistance2Obj(minion, pos) < SpellRangedQ1.Width then
            n = n +1
        end
    end
    return n
end

function GetDistance2Obj(obj1,obj2)
	local x1 = GetPosX(obj1)
	local z1 = GetPosZ(obj1)

	local x2 = GetPosX(obj2)
	local z2 = GetPosZ(obj2)

	return GetDistance2D(x1,z1,x2,z2)
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		if GetSpellLevel(UpdateHeroInfo(),Q) == 0 then return 0 end

		local DamageSpellQTable = { 70, 120, 170, 220, 270, 320}

		local Percent_Bonus_AD = 1.2

		local Damage_Bonus_AD = GetFlatPhysicalDamage(UpdateHeroInfo())

		local DamageSpellR = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),Q)]

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
