--[[
https://github.com/Hellsing/BoL/blob/master/common/SOW.lua
]]

--IncludeFile("Lib\\AllClass.lua")
--class "SOW"

--GetTarget function for test only
function GetTarget(Range)
  for i, h in pairs(GetEnemyHeroes()) do
    if ValidTarget(h,range,true) then
      return h
    end
  end
end

SOW = Class()

function SOW:__init(VP)

  self.ProjectileSpeed = VP:GetProjectileSpeed(myHero)--myHero.AARange > 300 and VP:GetProjectileSpeed(myHero) or math.huge
  self.BaseWindupTime = 3
  self.BaseAnimationTime = 0.65
  self.DataUpdated = false

  self.VP = VP

  --__PrintTextGame(tostring(VP.BaseWindupTime))

  --Callbacks
  self.AfterAttackCallbacks = {}
  self.OnAttackCallbacks = {}
  self.BeforeAttackCallbacks = {}

  self.AttackTable =
    {
      ["Ashes Q"] = "frostarrow",
    }

  self.NoAttackTable =
    {
      ["Shyvana1"] = "shyvanadoubleattackdragon",
      ["Shyvana2"] = "ShyvanaDoubleAttack",
      ["Wukong"] = "MonkeyKingDoubleAttack",
    }

  self.AttackResetTable =
    {
      ["ashe"] = _Q,
      ["blitzcrank"] = _E,
      ["camille"] = _Q,
      ["darius"] = _W,
      ["drmundo"] = _E,
      ["ekko"] = _E,
      ["elise"] = _W,
      ["fiora"] = _E,
      ["fizz"] = _Q,
      ["garen"] = _Q,
      ["graves"] = _E,
      ["hecarim"] = _E,
      ["illaoi"] = _W,
      ["irelia"] = _W,
      ["jax"] = _W,
      ["jayce"] = _W,
      ["kassadin"] = _W,
      ["leona"] = _Q,
      ["lucian"] = _E,
      ["masteryi"] = _W,
      ["mordekaiser"] = _Q,
      ["nasus"] = _Q,
      ["nautilus"] = _W,
      ["nidalee"] = _Q,
      ["reksai"] = _Q,
      ["renekton"] = _W,
      ["rengar"] = _Q,
      ["riven"] = _Q,
      ["shyvana"] = _Q,
      ["sivir"] = _W,
      ["sona"] = _P,
      ["talon"] = _Q,
      ["trundle"] = _Q,
      ["vayne"] = _Q,
      ["vi"] = _E,
      ["volibear"] = _Q,
      ["monkeyking"] = _Q,
      ["xinzhao"] = _Q,
      ["yorick"] = _Q,
    }


  self.LastAttack = 0
  self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_MAXHEALTH_ASC)
  self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
  self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)
  --[[
  GetSave("SOW").FarmDelay = GetSave("SOW").FarmDelay and GetSave("SOW").FarmDelay or 0
  GetSave("SOW").ExtraWindUpTime = GetSave("SOW").ExtraWindUpTime and GetSave("SOW").ExtraWindUpTime or 50
  GetSave("SOW").Mode3 = GetSave("SOW").Mode3 and GetSave("SOW").Mode3 or string.byte("X")
  GetSave("SOW").Mode2 = GetSave("SOW").Mode2 and GetSave("SOW").Mode2 or string.byte("V")
  GetSave("SOW").Mode1 = GetSave("SOW").Mode1 and GetSave("SOW").Mode1 or string.byte("C")
  GetSave("SOW").Mode0 = GetSave("SOW").Mode0 and GetSave("SOW").Mode0 or 32
  ]]
  self.Attacks = true
  self.Move = true
  self.mode = -1
  self.checkcancel = 0

  self.Mode0 = 32
  self.Mode2 = 88 --X=88, V=86
  self.forcetarget = nil
  self.forceorbwalkpos = {x=0,y=0,z=0}
  self.lasttarget = nil

  AddTickCallback(function() self:OnTick() end)
  AddProcessSpellCallback(function(unit, spell) self:OnProcessSpell(unit, spell) end)

	return self
end
--[[
function SOW:LoadToMenu(m, STS)
  if not m then
    self.Menu = scriptConfig("Simple OrbWalker", "SOW")
  else
    self.Menu = m
  end

  if STS then
    self.STS = STS
    self.STS.VP = self.VP
  end

  self.Menu:addParam("Enabled", "Enabled", SCRIPT_PARAM_ONOFF, true)
  self.Menu:addParam("FarmDelay", "Farm Delay", SCRIPT_PARAM_SLICE, -150, 0, 150)
  self.Menu:addParam("ExtraWindUpTime", "Extra WindUp Time", SCRIPT_PARAM_SLICE, -150,  0, 150)

  self.Menu.FarmDelay = GetSave("SOW").FarmDelay
  self.Menu.ExtraWindUpTime = GetSave("SOW").ExtraWindUpTime

  self.Menu:addParam("Attack",  "Attack", SCRIPT_PARAM_LIST, 2, { "Only Farming", "Farming + Carry mode"})
  self.Menu:addParam("Mode",  "Orbwalking mode", SCRIPT_PARAM_LIST, 1, { "To mouse", "To target"})

  self.Menu:addParam("Hotkeys", "", SCRIPT_PARAM_INFO, "")

  self.Menu:addParam("Mode3", "Last hit!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("X"))
  self.Mode3ParamID = #self.Menu._param
  self.Menu:addParam("Mode1", "Mixed Mode!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("C"))
  self.Mode1ParamID = #self.Menu._param
  self.Menu:addParam("Mode2", "Laneclear!", SCRIPT_PARAM_ONKEYDOWN, false, string.byte("V"))
  self.Mode2ParamID = #self.Menu._param
  self.Menu:addParam("Mode0", "Carry me!", SCRIPT_PARAM_ONKEYDOWN, false, 32)
  self.Mode0ParamID = #self.Menu._param

  self.Menu._param[self.Mode3ParamID].key = GetSave("SOW").Mode3
  self.Menu._param[self.Mode2ParamID].key = GetSave("SOW").Mode2
  self.Menu._param[self.Mode1ParamID].key = GetSave("SOW").Mode1
  self.Menu._param[self.Mode0ParamID].key = GetSave("SOW").Mode0

  AddTickCallback(function() self:OnTick() end)
  AddTickCallback(function() self:CheckConfig() end)
end

function SOW:CheckConfig()
  GetSave("SOW").FarmDelay = self.Menu.FarmDelay
  GetSave("SOW").ExtraWindUpTime = self.Menu.ExtraWindUpTime

  GetSave("SOW").Mode3 = self.Menu._param[self.Mode3ParamID].key
  GetSave("SOW").Mode2 = self.Menu._param[self.Mode2ParamID].key
  GetSave("SOW").Mode1 = self.Menu._param[self.Mode1ParamID].key
  GetSave("SOW").Mode0 = self.Menu._param[self.Mode0ParamID].key
end
]]
function SOW:DisableAttacks()
  self.Attacks = false
end

function SOW:EnableAttacks()
  self.Attacks = true
end

function SOW:ForceTarget(target)
  self.forcetarget = target
end

function SOW:GetTime()
  return os.clock()
end

function SOW:MyRange(target)
  local myRange = myHero.AARange + self.VP:GetHitBox(myHero)
  if target and ValidTarget(target) then
    myRange = myRange + self.VP:GetHitBox(target)
  end
  return myRange - 20
end

function SOW:InRange(target)
  local MyRange = self:MyRange(target)
  --print("MyRange " .. tostring(MyRange))
  --print("MyRange " .. tostring(GetDistanceSqr(target, myHero)))
  if target and GetDistanceSqr(target, myHero) <= MyRange * MyRange then
    return true
  end
end

function SOW:ValidTarget(target)
  --[[if target and target.Type and (target.Type == "obj_BarracksDampener" or target.Type == "obj_HQ")  then
    return false
  end]]
  --[[if target then
	print("2 " .. tostring(target.Type))
	end]]

  return ValidTarget(target) and self:InRange(target)
end

function SOW:Attack(target)
  self.LastAttack = self:GetTime() + self:Latency()
  BasicAttack(target.Addr)
end

function SOW:WindUpTime(exact)

  return (1 / (myHero.AttackSpeed * self.BaseWindupTime)) + (exact and 0 or 50 --[[GetSave("SOW").ExtraWindUpTime]] / 1000)
end

function SOW:AnimationTime()
  return (1 / (myHero.AttackSpeed * self.BaseAnimationTime))
end

function SOW:Latency()
  return GetLatency() / 2000
end

function SOW:CanAttack()
  if self.LastAttack <= self:GetTime() then
    return (self:GetTime() + self:Latency() + 0.02 > self.LastAttack + self:AnimationTime())
  end
  return false
end

function SOW:CanMove()
  if self.LastAttack <= self:GetTime() then
    return ( (self:GetTime() + self:Latency() > self.LastAttack + self:WindUpTime() + 0.01 )  ) and not _G.evade
  end
end

function SOW:BeforeAttack(target)
  local result = false
  for i, cb in ipairs(self.BeforeAttackCallbacks) do
    local ri = cb(target, self.mode)
    if ri then
      result = true
    end
  end
  return result
end

function SOW:RegisterBeforeAttackCallback(f)
  table.insert(self.BeforeAttackCallbacks, f)
end

function SOW:OnAttack(target)
  for i, cb in ipairs(self.OnAttackCallbacks) do
    cb(target, self.mode)
  end
end

function SOW:RegisterOnAttackCallback(f)
  table.insert(self.OnAttackCallbacks, f)
end

function SOW:AfterAttack(target)
  for i, cb in ipairs(self.AfterAttackCallbacks) do
    cb(target, self.mode)
  end
end

function SOW:RegisterAfterAttackCallback(f)
  table.insert(self.AfterAttackCallbacks, f)
end

function SOW:MoveTo(x, y)
  MoveToPos(x, y)
end

function SOW:OrbWalk(target, point)
	if self.forceorbwalkpos.x == 0 and self.forceorbwalkpos.y == 0 and self.forceorbwalkpos.z == 0 then
		--nothing
	else
		point = point or self.forceorbwalkpos
	end
  if self.Attacks and self:CanAttack() and self:ValidTarget(target) and not self:BeforeAttack(target) then
    self:Attack(target)
	--print("11")
  elseif self:CanMove() and self.Move then

    if not point then
      local OBTarget = GetTarget(2000) or target

      if self.mode == 1 or not OBTarget then
		--print("22---")
		local mousePos = Vector(GetMousePos())
		if mousePos.x == myHero.x and mousePos.z == myHero.z then return end
        local Mv = Vector(myHero) + 400 * (Vector(mousePos) - Vector(myHero)):normalized()
        self:MoveTo(Mv.x, Mv.z)
      elseif GetDistanceSqr(OBTarget) > 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
        local point = self.VP:GetPredictedPos(OBTarget, 0, 2*myHero.MoveSpeed, myHero, false)

		--print("22")

		 --point = CastPosition
        if GetDistanceSqr(point) < 100*100 + math.pow(self.VP:GetHitBox(OBTarget), 2) then
          point = Vector(Vector(myHero) - point):normalized() * 50
        end
        self:MoveTo(point.x, point.z)
      end
    else
      self:MoveTo(point.x, point.z)
	  --print("44")
    end
  end
end

function SOW:IsAttack(SpellName)
  return (SpellName:lower():find("attack") or table.contains(self.AttackTable, SpellName:lower())) and not table.contains(self.NoAttackTable, SpellName:lower())
end

function SOW:IsAAReset(SpellName)
  local SpellID
  if SpellName:lower() == GetSpellNameByIndex(myHero,_Q):lower() then
    SpellID = _Q
  elseif SpellName:lower() == GetSpellNameByIndex(myHero,_W):lower() then
    SpellID = _W
  elseif SpellName:lower() == GetSpellNameByIndex(myHero,_E):lower() then
    SpellID = _E
  elseif SpellName:lower() == GetSpellNameByIndex(myHero,_R):lower() then
    SpellID = _R
  end

  if SpellID then
    return self.AttackResetTable[myHero.CharName:lower()] == SpellID
  end
  return false
end

function SOW:OnProcessSpell(unit, spell)
  if unit.isMe and self:IsAttack(spell.Name) then
    spell.target = GetTargetFromTargetId(spell.TargetId)
    --[[if self.debugdps then
      DPS = DPS and DPS or 0
      print("DPS: "..(1000/(self:GetTime()- DPS)).." "..(1000/(self:AnimationTime())))
      DPS = self:GetTime()
    end]]
    if not self.DataUpdated and not spell.Name:lower():find("card") then
      self.BaseAnimationTime = 1 / (spell.TimeCast * myHero.AttackSpeed)
      self.BaseWindupTime = 1 / (spell.Delay * myHero.AttackSpeed)
      --[[if self.debug then
        print("<font color=\"#FF0000\">Basic Attacks data updated: </font>")
        print("<font color=\"#FF0000\">BaseWindupTime: "..self.BaseWindupTime.."</font>")
        print("<font color=\"#FF0000\">BaseAnimationTime: "..self.BaseAnimationTime.."</font>")
        print("<font color=\"#FF0000\">ProjectileSpeed: "..self.ProjectileSpeed.."</font>")
      end]]
      self.DataUpdated = true
    end
    self.LastAttack = self:GetTime() - self:Latency()
    self.checking = true
    self.LastAttackCancelled = false
    self:OnAttack(spell.target)
    self.checkcancel = self:GetTime()
    DelayAction(function(t) self:AfterAttack(t) end, self:WindUpTime() - self:Latency(), {spell.target})

  elseif unit.isMe and self:IsAAReset(spell.Name) then
    DelayAction(function() self:resetAA() end, 0.25)
  end
end

function SOW:resetAA()
  self.LastAttack = 0
end

SUPRESSED = false
--TODO: Change this.
function SOW:BonusDamage(minion)
  local AD = myHero.CalcDamage(minion.Addr, myHero.TotalDmg)
  local BONUS = 0
  if myHero.CharName == 'Vayne' then
    if myHero.LevelSpell(_Q) > 0 and myHero.CanCast(_Q) == SUPRESSED then
      BONUS = BONUS + myHero.CalcDamage(minion.Addr, ((0.05 * myHero.LevelSpell(_Q) + 0.25 ) * myHero.TotalDmg))
    end
    if not VayneCBAdded then
      VayneCBAdded = true
      function VayneParticle(obj)
        if GetDistance(obj) < 1000 and obj.Name:lower():find("vayne_w_ring2.troy") then
          VayneWParticle = obj
        end
      end
      AddCreateObjCallback(VayneParticle)
    end
    if VayneWParticle and VayneWParticle.IsValid and GetDistance(VayneWParticle, minion) < 10 then
      BONUS = BONUS + 10 + 10 * myHero.LevelSpell(_W) + (0.03 + (0.01 * myHero.LevelSpell(_W))) * minion.MaxHP
    end
  elseif myHero.CharName == 'Teemo' and myHero.LevelSpell(_E) > 0 then
    BONUS = BONUS + myHero.CalcMagicDamage(minion, (myHero.LevelSpell(_E) * 10) + (myHero.MagicDmg * 0.3) )
  elseif myHero.CharName == 'Corki' then
    BONUS = BONUS + myHero.TotalDmg/10
  elseif myHero.CharName == 'MissFortune' and myHero.LevelSpell(_W) > 0 then
    BONUS = BONUS + myHero.CalcMagicDamage(minion, (4 + 2 * myHero.LevelSpell(_W) + (myHero.MagicDmg/20)))
  elseif myHero.CharName == 'Varus' and myHero.LevelSpell(_W) > 0 then
    BONUS = BONUS + (6 + (myHero.LevelSpell(_W) * 4) + (myHero.MagicDmg * 0.25))
  elseif myHero.charName == 'Caitlyn' then
      if not CallbackCaitlynAdded then
        function CaitlynParticle(obj)
          if GetDistance(obj) < 100 and obj.Name:lower():find("caitlyn_headshot_rdy") then
              HeadShotParticle = obj
          end
        end
        AddCreateObjCallback(CaitlynParticle)
        CallbackCaitlynAdded = true
      end
      if HeadShotParticle and HeadShotParticle.IsValid then
        BONUS = BONUS + AD * 1.5
      end
  elseif myHero.CharName == 'Orianna' then
    BONUS = BONUS + myHero.CalcMagicDamage(minion, 10 + 8 * ((myHero.Level - 1) % 3))
  elseif myHero.CharName == 'TwistedFate' then
      if not TFCallbackAdded then
        function TFParticle(obj)
          if GetDistance(obj) < 100 and obj.Name:lower():find("cardmaster_stackready.troy") then
            TFEParticle = obj
          elseif GetDistance(obj) < 100 and obj.Name:lower():find("card_blue.troy") then
            TFWParticle = obj
          end
        end
        AddCreateObjCallback(TFParticle)
        TFCallbackAdded = true
      end
      if TFEParticle and TFEParticle.IsValid then
        BONUS = BONUS + myHero.CalcMagicDamage(minion, myHero.LevelSpell(_E) * 15 + 40 + 0.5 * myHero.MagicDmg)
      end
      if TFWParticle and TFWParticle.valid then
        BONUS = BONUS + math.max(myHero.CalcMagicDamage(minion, myHero.LevelSpell(_W) * 20 + 20 + 0.5 * myHero.MagicDmg) - 40, 0)
      end
  elseif myHero.CharName == 'Draven' then
      if not CallbackDravenAdded then
        function DravenParticle(obj)
          if GetDistance(obj) < 100 and obj.Name:lower():find("draven_q_buf") then
              DravenParticleo = obj
          end
        end
        AddCreateObjCallback(DravenParticle)
        CallbackDravenAdded = true
      end
      if DravenParticleo and DravenParticleo.IsValid then
        BONUS = BONUS + AD * (0.3 + (0.10 * myHero.LevelSpell(_Q)))
      end
  elseif myHero.CharName == "Ziggs" then
    if not CallbackZiggsAdded then
      function ZiggsParticle(obj)
        if GetDistance(obj) < 100 and obj.Name:lower():find("ziggspassive") then
            ZiggsParticleObj = obj
        end
      end
      AddCreateObjCallback(ZiggsParticle)
      CallbackZiggsAdded = true
    end
    if ZiggsParticleObj and ZiggsParticleObj.IsValid then
      local base = {20, 24, 28, 32, 36, 40, 48, 56, 64, 72, 80, 88, 100, 112, 124, 136, 148, 160}
      BONUS = BONUS + myHero.CalcMagicDamage(minion, base[myHero.Level] + (0.25 + 0.05 * (myHero.Level % 7)) * myHero.MagicDmg)
    end
  end

  return BONUS
end

function SOW:KillableMinion()
  local result
	--self.EnemyMinions:update()
	--print(tostring(self.EnemyMinions.iCount))
  for i, minion in ipairs(self.EnemyMinions.objects) do
    local time = self:WindUpTime(true) + GetDistance(minion, myHero) / self.ProjectileSpeed - 0.07
    local PredictedHealth = self.VP:GetPredictedHealth(minion, time, 0 / 1000)
		--print(tostring(PredictedHealth))
		--print(tostring(minion.HP))
		--print(tostring(self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion)))

    if self:ValidTarget(minion) and PredictedHealth < self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) and PredictedHealth > -40 then
      result = minion

      break
    end
	--print(tostring("-------------"))
  end
  return result
end

function SOW:ShouldWait()

  for i, minion in ipairs(self.EnemyMinions.objects) do
    local time = self:AnimationTime() + GetDistance(minion, myHero) / self.ProjectileSpeed - 0.07
    if self:ValidTarget(minion) and self.VP:GetPredictedHealth2(minion, time * 2) < (self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion)) then
      return true
    end
  end
end

function SOW:ValidStuff()
  local result = self:GetTarget()

  if result then
    return result
  end

  for i, minion in ipairs(self.EnemyMinions.objects) do
    local time = self:AnimationTime() + GetDistance(minion, myHero) / self.ProjectileSpeed - 0.07
    local pdamage2 = minion.HP - self.VP:GetPredictedHealth(minion, time, 0 / 1000)
    local pdamage = self.VP:GetPredictedHealth2(minion, time * 2)
    if self:ValidTarget(minion) and ((pdamage) > 2*self.VP:CalcDamageOfAttack(myHero, minion, {name = "Basic"}, 0) + self:BonusDamage(minion) or pdamage2 == 0) then
      return minion
    end
  end


  for i, jungle in ipairs(self.JungleMinions.objects) do
	--print("1 " .. tostring(jungle.Type))
    if self:ValidTarget(jungle) then
      return jungle
    end
	--print(tostring("-------------"))
  end

  for i, minion in ipairs(self.OtherMinions.objects) do
    if self:ValidTarget(minion) then
      return minion
    end
  end
end

function SOW:GetTarget(OnlyChampions)
  local result
  local healthRatio

  if self:ValidTarget(self.forcetarget) then
    return self.forcetarget
  elseif self.forcetarget ~= nil then
    return nil
  end

  for i, champion in ipairs(GetEnemyHeroes()) do
    local hr = champion.HP / myHero.CalcDamage(champion.Addr, 200)
    if self:ValidTarget(champion) and ((healthRatio == nil) or hr < healthRatio) then
      result = champion
      healthRatio = hr
    end
  end

  return result
end

function SOW:Farm(mode, point)
  if mode == 1 then
--~     self.EnemyMinions:update()
--~     local target = self:KillableMinion() or self:GetTarget()
--~     self:OrbWalk(target, point)
--~     self.mode = 1
  elseif mode == 2 then
    self.EnemyMinions:update()
    self.OtherMinions:update()
    self.JungleMinions:update()

    local target = self:KillableMinion()
	--print(tostring(target))
    if target then
		self:OrbWalk(target, point)

	  --print("o1")
    elseif not self:ShouldWait() then

      if self:ValidTarget(self.lasttarget) then
		target = self.lasttarget
		--print("o3")
      else
        target = self:ValidStuff()
		--print(tostring(target))
		--print("o4")
      end
      self.lasttarget = target
		--print("o5")
      self:OrbWalk(target, point)
    else
      self:OrbWalk(nil, point)
    end
    self.mode = 1

  elseif mode == 3 then
--~     self.EnemyMinions:update()
--~     local target = self:KillableMinion()
--~     self:OrbWalk(target, point)
--~     self.mode = 3
  end
end

function SOW:OnTick()


	myHero = GetMyHero()
	player = myHero

	if IsTyping() then return end

  if GetKeyPress(self.Mode0) == 1 then

    local target = self:GetTarget(true)
		if target then
			self:OrbWalk(target)

		else
			self:OrbWalk()

		end
		self.mode = 1
  --elseif self.Mode1 then
    --self:Farm(1)
  elseif GetKeyPress(self.Mode2) == 1 then
    self:Farm(2)
	self.mode = 1
  --elseif self.Mode3 then
    --self:Farm(3)]]
  else
    self.mode = -1
  end
end
