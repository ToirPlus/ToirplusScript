--[[

Reference link https://github.com/DarknessVoided/GoS-3/blob/master/Zac.lua

Thanks

]]

function UpdateHeroInfo()
	return GetMyChamp()
end



local t = {}
t.concat = assert(table.concat)
t.insert = assert(table.insert)
t.remove = assert(table.remove)
t.sort = assert(table.sort)

local function classInstance()
        local cls = {}

        cls.__index = cls
        return setmetatable(cls, { __call = function (c, ...)
                local instance = setmetatable({}, cls)

                if cls.__init then
                        cls.__init(instance, ...)
                end

                return instance
        end })
end

local Callback = classInstance()

local Callbacks = {
        ["Load"]         = {},
        ["Tick"]         = {},
        ["Update"]       = {},
        ["Draw"]         = {},
        ["UpdateBuff"]   = {},
        ["RemoveBuff"]   = {},
        ["ProcessSpell"] = {},
        ["CreateObject"] = {},
        ["DeleteObject"] = {},
}

Callback.Add = function(type, cb) t.insert(Callbacks[type], cb) end
Callback.Del = function(type, id) t.remove(Callbacks[type], id or 1) end

local delayedActions = {}
local delayedActionsExecuter = nil
local function DelayAction(func, delay, args)
        if not delayedActionsExecuter then
                function delayedActionsExecuter()
                        for i, funcs in pairs(delayedActions) do
                                if i <= GetTimeGame() then
                                        for _, f in ipairs(funcs) do
                                                f.func(unpack(f.args or {}))
                                        end

                                        delayedActions[i] = nil
                                end
                        end
                end

                Callback.Add("Tick", delayedActionsExecuter)
        end

        local time = GetTimeGame() + (delay or 0)

        if delayedActions[time] then
                t.insert(delayedActions[time], { func = func, args = args })
        else
                delayedActions[time] = { { func = func, args = args } }
        end
end

----------------------------------------

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

eTime = 0
eCharge = false
local blobb={}
local qRange = 550 + GetOverrideCollisionRadius(UpdateHeroInfo())
local wRange = 350 + GetOverrideCollisionRadius(UpdateHeroInfo())
local rRange = 300 + GetOverrideCollisionRadius(UpdateHeroInfo())
local ZacQ = { delay = 0.3, speed = math.huge , width = 100, range = qRange}
local Move = { delay = 0.5, speed = math.huge, width = 50, range = math.huge}
local cSkin = 0
local item = {3143,3748,3146}


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
	return GetEnemyChampCanKillFastest(1700)
end

function OnLoad()
end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)
	if buff.Name == "ZacE" and unit.IsMe then
		eCharge = true
		eTime = GetTickCount()
		SetLuaBasicAttackOnly(true)
		SetLuaMoveOnly(true)
	end
end

function OnRemoveBuff(unit, buff)
	if buff.Name == "ZacE" and unit.IsMe then
		eCharge = false
		SetLuaBasicAttackOnly(false)
		SetLuaMoveOnly(false)
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


function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Zac" then return end
	for i, cb in pairs(Callbacks["Tick"]) do
			cb()
	end

	if IsDead(UpdateHeroInfo()) then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		Laneclear()
		Jungleclear()
	end

	KillSteal()
end

function KillSteal()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, Target in pairs(Enemies) do
		if Target ~= 0 then
			if ValidTarget(Target) then
				if getDmg(_W, Target) > GetHealthPoint(Target) and WReady() then
					CastW(target)
				end

				if QReady() and getDmg(_Q, Target) > GetHealthPoint(Target) and CanMove() then
					CastQ(Target)
				end

				if RReady() and getDmg(_R, Target) > GetHealthPoint(Target) and CanMove() then
					CastR(Target)
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

function ValidTargetJungleRange(Target, Range)
	if ValidTargetJungle(Target) and GetDistance(Target) < Range then
		return true
	end
	return false
end

function Jungleclear()
	local jungle = GetJungleMonster(1000)

	if jungle ~= 0 and EReady() and CanMove() and Setting_IsLaneClearUseE() then
		if ValidTargetJungle(jungle) then
			if not eCharge and ValidTargetJungleRange(jungle, 1050 + GetSpellLevel(UpdateHeroInfo(),_E)*130) then
				local ZacE = { delay = 0.1, speed = 750, range = eRange(), radius = 300}
				local vp_distance = VPGetLineCastPosition(jungle, ZacE.delay, ZacE.speed)
				if vp_distance > 0 and vp_distance < ZacE.range then
					CastSpellToPredictionPos(jungle, _E, vp_distance)

					DelayAction(function() ReleaseSpellToPredictionPos(jungle, _E, vp_distance) end, GetDelayTime(jungle, ZacE.delay, ZacE.speed))
				end
			elseif eCharge then
				local ZacE = { delay = 0.1, speed = 1700, range = eRange(), radius = 300}
				local vp_distance = VPGetLineCastPosition(jungle, ZacE.delay, ZacE.speed)
				if vp_distance > 0 and vp_distance < ZacE.range then
					CastSpellToPredictionPos(jungle, _E, vp_distance)

					DelayAction(function() ReleaseSpellToPredictionPos(jungle, _E, vp_distance) end, GetDelayTime(jungle, ZacE.delay, ZacE.speed))
				end
			end
		end
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 and QReady() and CanMove() and Setting_IsLaneClearUseQ() then
		local vp_distance = VPGetLineCastPositionZac(jungle, ZacQ.delay)
		if vp_distance > 0 and vp_distance < ZacQ.range then
			CastSpellToPredictionPos(jungle, _Q, vp_distance)
		end
	end

	jungle = GetJungleMonster(1000)
	if jungle ~= 0 and WReady() and CanMove() and Setting_IsLaneClearUseW() then
		if ValidTargetJungleRange(jungle,wRange) then
			CastSpellTarget(UpdateHeroInfo(), _W)
		end
	end

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
			if GetDistance(minion) < ZacQ.range then
				CastSpellToPredictionPos(minion, _Q, GetDistance(minion))
			end
		end
	end

	minion = GetMinion()
	if minion ~= 0 then
		if WReady() and Setting_IsLaneClearUseQ() then
			if GetDistance(minion) < wRange then
				CastSpellTarget(UpdateHeroInfo(), _W)
			end
		end
	end
end

function Combo()
	local target = GetTarget()

	if target ~= 0 and EReady() and CanMove() and Setting_IsComboUseE() then
		CastE(target)
    end

	if target ~= 0 and QReady() and CanMove() and Setting_IsComboUseQ() then
		CastQ(target)
    end

	if target ~= 0 and WReady() and Setting_IsComboUseW() then
		CastW(target)
    end



end

function CastW(Target)
	if ValidTargetRange(Target,wRange) then
		CastSpellTarget(UpdateHeroInfo(), _W)
	end
end

function CastR(Target)
	if ValidTargetRange(Target,rRange) then
		CastSpellTarget(UpdateHeroInfo(), _R)
		DelayAction(function() CastSpellTarget(UpdateHeroInfo(), _R) end, 0.5)
	end
end


function CastQ(Target)
	if QReady() and ValidTarget(Target) then
	    local vp_distance = VPGetLineCastPositionZac(Target, ZacQ.delay)
		if vp_distance > 0 and vp_distance < ZacQ.range then
			CastSpellToPredictionPos(Target, _Q, vp_distance)
		end
	end
end


function CastE(Target)
	if not ValidTarget(Target) then return end

	if not eCharge and ValidTargetRange(Target, 1050 + GetSpellLevel(UpdateHeroInfo(),_E)*130) then
		local ZacE = { delay = 0.1, speed = 750, range = eRange(), radius = 300}
		local vp_distance = VPGetLineCastPosition(Target, ZacE.delay, ZacE.speed)
		if vp_distance > 0 and vp_distance < ZacE.range then
			CastSpellToPredictionPos(Target, _E, vp_distance)
			DelayAction(function() ReleaseSpellToPredictionPos(Target, _E, vp_distance) end, GetDelayTime(Target, ZacE.delay, ZacE.speed))
		end
	elseif eCharge then
		local ZacE = { delay = 0.1, speed = 1700, range = eRange(), radius = 300}
		local vp_distance = VPGetLineCastPosition(Target, ZacE.delay, ZacE.speed)
		if vp_distance > 0 and vp_distance < ZacE.range then
			CastSpellToPredictionPos(Target, _E, vp_distance)
			DelayAction(function() ReleaseSpellToPredictionPos(Target, _E, vp_distance) end, GetDelayTime(Target, ZacE.delay, ZacE.speed))
		end
	end

end

function eRange()
	local maxRange = 1050 + GetSpellLevel(UpdateHeroInfo(),_E) * 150
	local mt = 750 + GetSpellLevel(UpdateHeroInfo(),_E) * 150
	local currentRange = maxRange * ((GetTickCount()- eTime)/mt)
	if currentRange > maxRange then
		currentRange = maxRange
	end
	return currentRange
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

function GetDelayTime(Target, Delay, Speed)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	return Delay + distance/Speed
end

function VPGetLineCastPosition(Target, Delay, Speed)
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

function VPGetLineCastPositionZac(Target, Delay)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	local x2 = GetPosX(Target)
	local z2 = GetPosZ(Target)

	local distance = GetDistance2D(x1,z1,x2,z2)

	TimeMissile = Delay
	local real_distance = (TimeMissile * GetMoveSpeed(Target))

	if real_distance == 0 then return distance end
	return real_distance

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
		if GetSpellLevel(UpdateHeroInfo(),_Q) == 0 then return 0 end
		local DamageSpellQTable = {30, 40, 50, 60, 70}
		local Percent_AP = 0.3

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),_Q)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellQ + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellQ + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == _W then
		if GetSpellLevel(UpdateHeroInfo(),_W) == 0 then return 0 end
		local DamageSpellETable = {15, 30, 45, 60, 75}
		local DamageSpellPercentETable = {4, 5, 6, 7, 8}

		local Percent_AP = 0.2

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellE = DamageSpellETable[GetSpellLevel(UpdateHeroInfo(),_W)]

		local DamageSpellPercentE = DamageSpellPercentETable[GetSpellLevel(UpdateHeroInfo(),_W)] * GetHealthPointMax(Enemy) / 100

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellE + Percent_AP * AP + DamageSpellPercentE) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellE + Percent_AP * AP + DamageSpellPercentE) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == _R then
		if GetSpellLevel(UpdateHeroInfo(),_R) == 0 then return 0 end
		local DamageSpellRTable = {140, 210, 280 }
		local Percent_AP = 0.4

		local AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(UpdateHeroInfo(),_R)]

		local Enemy_SpellBlock = GetSpellBlock(Enemy)

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - GetMagicPenetration(UpdateHeroInfo())

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end
