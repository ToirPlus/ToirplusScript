IncludeFile("Lib\\TOIR_SDK.lua")

Kassadin = class()

function OnLoad()
	if GetChampName(GetMyChamp()) == "Kassadin" then
		Kassadin:__init()
	end
end

function Kassadin:__init()
	-- VPrediction
	vpred = VPrediction(true)

	--TS
    self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)


    self.Q = Spell(_Q, 650)
    self.W = Spell(_W, 0)
    self.E = Spell(_E, 580)
    self.R = Spell(_R, 450)

    self.Q:SetTargetted()
	self.W:SetActive()
    self.E:SetSkillShot(0.4, 1000, 50, false)
    self.R:SetTargetted()



	Callback.Add("Tick", function(...) self:OnTick(...) end)
    Callback.Add("Draw", function(...) self:OnDraw(...) end)
--~     Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
--~     Callback.Add("BeforeAttack", function(...) self:OnBeforeAttack(...) end)
--~     Callback.Add("AfterAttack", function(...) self:OnAfterAttack(...) end)
    Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
    self:MenuValueDefault()
end

function Kassadin:MenuValueDefault()
	self.menu = "Kassadin_Magic"
--~ 	self.Draw_When_Already = self:MenuBool("Draw When Already", true)
--~ 	self.menu_Draw_W = self:MenuBool("Draw W Range", true)
--~ 	self.menu_Draw_E = self:MenuBool("Draw E Range", true)
--~ 	self.menu_Draw_R = self:MenuBool("Draw R Range", true)
--~ 	self.eInfo = self:MenuBool("Draw E Info", true)

--~ 	self.qcb = self:MenuBool("Auto Q Combo)", true)
--~ 	self.qlc = self:MenuBool("Use Q Lane Clear", true)

--~ 	self.Wks = self:MenuBool("W KS logic (W+E+R calculation)", true)
--~ 	self.Wtur = self:MenuBool("dont W if under turrent", true)
--~ 	self.W_Mode = self:MenuComboBox("W GapClose Mode :", 2)
--~ 	self.smartW = self:MenuKeyBinding("SmartCast W key", 84)

--~ 	self.Eturet = self:MenuBool("E on turrent laneclear", true)
--~ 	self.focusE = self:MenuBool("Focus target with E", true)
--~ 	for i, enemy in pairs(GetEnemyHeroes()) do
--~         table.insert(self.ts_prio, { Enemy = GetAIHero(enemy), Menu = self:MenuBool(GetAIHero(enemy).CharName, true)})
--~     end

--~ 	self.autoR = self:MenuBool("Auto R KS (E+R calculation)", true)
--~ 	self.turrentR = self:MenuBool("Try R under turrent", true)
--~ 	self.allyR = self:MenuBool("Try R under ally", true)
--~ 	self.Rgap = self:MenuBool("R GapCloser", true)
--~ 	self.OnInterruptableSpell = self:MenuBool("OnInterruptableSpell", true)
--~ 	self.RgapHP = self:MenuSliderInt("use gapcloser only under % hp", 40)

--~ 	self.Enalble_Mod_Skin = self:MenuBool("Enalble Mod Skin", false)
--~ 	self.Set_Skin = self:MenuSliderInt("Set Skin", 15)

	self.Combo_Key = self:MenuKeyBinding("Combo", 32)
	self.Harass_Key = self:MenuKeyBinding("Harass", 67)
	self.Lane_Clear_Key = self:MenuKeyBinding("Lane Clear", 86)
	self.Last_Hit_Key = self:MenuKeyBinding("Last Hit", 88)
end

function Kassadin:OnDrawMenu()
	if Menu_Begin(self.menu) then
--~ 		if Menu_Begin("Q Setting") then
--~ 			self.qcb = Menu_Bool("Auto Q Combo", self.qcb, self.menu)
--~ 			self.qlc = Menu_Bool("Use Q Lane Clear", self.qlc, self.menu)
--~ 			Menu_End()
--~ 		end

--~ 		if Menu_Begin("W Setting") then
--~ 			self.Wks = Menu_Bool("W KS logic (W+E+R calculation)", self.Wks, self.menu)
--~ 			self.Wtur = Menu_Bool("dont W if under turrent", self.Wtur, self.menu)
--~ 			self.W_Mode = Menu_ComboBox("W GapClose Mode :", self.W_Mode, "Mouse\0Side\0Safe position\0\0\0", self.menu)
--~ 			self.smartW = Menu_KeyBinding("SmartCast W key", self.smartW, self.menu)
--~ 			Menu_End()
--~ 		end

--~ 		if Menu_Begin("E Setting") then
--~ 			self.Eturet = Menu_Bool("E on turrent laneclear", self.Eturet, self.menu)
--~ 			self.focusE = Menu_Bool("Focus target with E", self.focusE, self.menu)
--~ 			Menu_Text("Auto E to target :")
--~ 			for i, enemy in pairs(GetEnemyHeroes()) do
--~             	self.ts_prio[i].Menu = Menu_Bool(GetAIHero(enemy).CharName, self.ts_prio[i].Menu, self.menu)
--~         	end
--~ 			Menu_End()
--~ 		end

--~ 		if Menu_Begin("R Setting") then
--~ 			self.autoR = Menu_Bool("Auto R KS (E+R calculation)", self.autoR, self.menu)
--~ 			self.turrentR = Menu_Bool("Try R under turrent", self.turrentR, self.menu)
--~ 			self.allyR = Menu_Bool("Try R under ally", self.allyR, self.menu)
--~ 			self.OnInterruptableSpell = Menu_Bool("OnInterruptableSpell", self.OnInterruptableSpell, self.menu)
--~ 			self.RgapHP = Menu_SliderInt("use gapcloser only under % hp", self.RgapHP, 0, 100, self.menu)
--~ 			self.Rgap = Menu_Bool("R GapCloser", self.Rgap, self.menu)
--~ 			Menu_End()
--~ 		end

--~ 		if Menu_Begin("Draw Spell") then
--~ 			self.menu_Draw_W = Menu_Bool("Draw W Range", self.menu_Draw_W, self.menu)
--~ 			self.menu_Draw_E = Menu_Bool("Draw E Range", self.menu_Draw_E, self.menu)
--~ 			self.menu_Draw_R = Menu_Bool("Draw R Range", self.menu_Draw_R, self.menu)
--~ 			self.eInfo = Menu_Bool("Draw E Info", self.eInfo, self.menu)
--~ 			Menu_End()
--~ 		end
--~ 		if Menu_Begin("Mod Skin") then
--~ 			self.Enalble_Mod_Skin = Menu_Bool("Enalble Mod Skin", self.Enalble_Mod_Skin, self.menu)
--~ 			self.Set_Skin = Menu_SliderInt("Set Skin", self.Set_Skin, 0, 20, self.menu)
--~ 			Menu_End()
--~ 		end
--~ 		if Menu_Begin("Key Mode") then
--~ 			self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
--~ 			self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
--~ 			self.Lane_Clear = Menu_KeyBinding("Lane Clear", self.Lane_Clear, self.menu)
--~ 			self.Last_Hit = Menu_KeyBinding("Last Hit", self.Last_Hit, self.menu)
--~ 			Menu_End()
--~ 		end

		Menu_End()
	end
end

function Kassadin:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Kassadin:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Kassadin:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Kassadin:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Kassadin:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Kassadin:Combo(target)

	if target and self.E:IsReady() and Setting_IsComboUseE() then
		if GetDistance(target) < self.E.range and ValidTarget(target) then
			if (GetDistance(target) < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (GetDistance(target) >= myHero.AARange + myHero.CollisionRadius) then
				CastSpellToPredictionPos(target, _E, self.E.range)
			end
		end
    end

	if target and self.Q:IsReady() and Setting_IsComboUseQ() then
		if GetDistance(target) < self.Q.range and ValidTarget(target) then
			if (GetDistance(target) < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (GetDistance(target) >= myHero.AARange + myHero.CollisionRadius) then
				CastSpellTarget(target, _Q)
			end
		end
    end

	if target and target ~= 0 and self.R:IsReady() and CanMove() and Setting_IsComboUseR() then
		if GetDistance(target) < self.R.range + 270 and ValidTarget(target) then
			local t = GetAIHero(target)
			if t and (self:getDmg(_R, t) > t.HP or self:CountEnemiesInRange(t, self.R.range) < 3) then
				CastSpellToPos(t.x, t.z, _R)
			end
		end
    end

	if target and target ~= 0 and IsEnemy(target) and ValidTarget(target) and self.W:IsReady() and Setting_IsComboUseW() and not CanAttack() and CanMove() then
		if GetDistance(target) < myHero.AARange + myHero.CollisionRadius then
			CastSpellTarget(myHero.Addr, _W)
		end
--~ 		SetLuaBasicAttackOnly(true)
--~ 		BasicAttack(target)
--~ 		SetLuaBasicAttackOnly(false)
    end
end

function Kassadin:OnTick()
	if IsDead(myHero.Addr) or IsTyping() or IsDodging() then return end
	SetLuaCombo(true)
	SetLuaLaneClear(true)

	if GetKeyPress(self.Combo_Key) > 0 then
        local target = self.menu_ts:GetTarget()
        self:Combo(target)
    end

	if GetKeyPress(self.Harass_Key) > 0 then
		local target = self.menu_ts:GetTarget()
		if target and self.Q:IsReady() and Setting_IsComboUseQ() then
			if GetDistance(target) < self.Q.range and ValidTarget(target) then
				if (GetDistance(target) < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (GetDistance(target) >= myHero.AARange + myHero.CollisionRadius) then
					CastSpellTarget(target, _Q)
				end
			end
		end
	end

	if GetKeyPress(self.Lane_Clear_Key) > 0 then
        self:LastHitMinionUseQ()
		self:FarmUseE()
		self:FarmUseR()
    end

	if GetKeyPress(self.Last_Hit_Key) > 0 then
        self:LastHitMinionUseQ()
    end

end

function Kassadin:BestMinionHitE()
	local Epos = nil
	local Most = 0
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect then
				local Count = self:CountMinionsAroundMinion(unit, 400)
				if Count > Most then
					Most = Count
					EPos = unit
				end
			end
		end
	end
	return Epos, Most
end

function Kassadin:FarmUseE()
	local minion, count = self:BestMinionHitE()
	print("E=" .. tostring(count))
	if minion then
		if self.E:IsReady() and Setting_IsLaneClearUseE() and count > 2 then
			CastSpellToPredictionPos(minion.Addr, _E, self.E.range)
		end
	end
end

function Kassadin:BestMinionHitR()
	local Rpos = nil
	local Most = 0
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and not self:IsUnderTower(unit) and self:EnemiesAround(unit.Addr, 1000) < 2 then
				local Count = self:CountMinionsAroundMinion(unit, self.R.range/2)
				if Count > Most then
					Most = Count
					Rpos = unit
				end
			end
		end
	end
	return Rpos, Most
end

function Kassadin:FarmUseR()
	local minion, count = self:BestMinionHitR()
	print("R=" .. tostring(count))
	if minion then
		if self.R:IsReady() and CanMove() and Setting_IsLaneClearUseR() and count > 3 then
			CastSpellToPos(minion.x, minion.z, _R)
		end
	end
end

function Kassadin:LastHitMinionUseQ()
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and self:getDmg(_Q, unit) > unit.HP then
				if self.Q:IsReady() and Setting_IsLaneClearUseQ() then
					if GetDistance(myHero.Addr, unit.Addr) < self.Q.range then
						if (unit.Distance < myHero.AARange + myHero.CollisionRadius and CanMove() and not CanAttack()) or (unit.Distance >= myHero.AARange + myHero.CollisionRadius) then
							CastSpellTarget(unit.Addr, _Q)
						end
					end
				end
			end
		end
	end
end

function Kassadin:CountMinionsAroundMinion(m, range)
	GetAllUnitAroundAnObject(myHero.Addr, 1000)
	local n = 0
	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 and GetType(minion) == 1 and m.Addr ~= minion then
			local unit = GetUnit(minion)
			if unit.IsEnemy and not unit.IsDead and unit.IsVisible and unit.CanSelect and GetDistance(m.Addr,unit.Addr) < range then
				n = n + 1
			end
		end
	end
	return n
end

function Kassadin:EnemiesAround(object, range)
	return CountEnemyChampAroundObject(object, range)
end

function Kassadin:IsUnderTower(m)
	GetAllUnitAroundAnObject(myHero.Addr, 1300)
	for i, turret in pairs(pUnit) do
		if turret ~= 0 and GetType(turret) == 2 then
			local unit = GetUnit(turret)
			if unit.IsEnemy and GetDistance(unit.Addr, m.Addr) < 915 then
				return true
			end
		end
	end

	return false
end

function Kassadin:OnDraw()

end



function Kassadin:IsUnderTurretEnemy(pos)			--Will Only work near myHero
	GetAllUnitAroundAnObject(myHero.Addr, 2000)
	local objects = pUnit
	for k,v in pairs(objects) do
		if IsTurret(v) and not IsDead(v) and IsEnemy(v) and GetTargetableToTeam(v) == 4 then
			local turretPos = Vector(GetPosX(v), GetPosY(v), GetPosZ(v))
			if GetDistance(turretPos,pos) < 915 then
				return true
			end
		end
	end
	return false
end

function Kassadin:IsUnderAllyTurret(pos)
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
  for k,v in pairs(pUnit) do
    if not IsDead(v) and IsTurret(v) and IsAlly(v) and GetTargetableToTeam(v) == 4 then
      local turretPos = Vector(GetPosX(v), GetPosY(v), GetPosZ(v))
      if GetDistance(turretPos,pos) < 915 then
        return true
      end
    end
  end
    return false
end

function Kassadin:CountEnemiesInRange(pos, range)
    local n = 0
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, object in ipairs(pUnit) do
        if GetType(object) == 0 and not IsDead(object) and not IsInFog(object) and GetTargetableToTeam(object) == 4 and IsEnemy(object) then
        	local objectPos = Vector(GetPos(object))
          	if GetDistance(pos, objectPos) <= range then
            	n = n + 1
          	end
        end
    end
    return n
end

function Kassadin:CountAlliesInRange(pos, range)
    local n = 0
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, object in ipairs(pUnit) do
        if GetType(object) == 0 and not IsDead(object) and not IsInFog(object) and GetTargetableToTeam(object) == 4 and IsAlly(object) then
          if GetDistance(pos, object) <= range then
              n = n + 1
          end
        end
    end
    return n
end


function Kassadin:getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _Q then
		if myHero.LevelSpell(_Q) == 0 then return 0 end
		local DamageSpellQTable = { 65, 95, 125, 155, 185 }
		local Percent_AP = 0.7

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellQ = DamageSpellQTable[myHero.LevelSpell(_Q)]

		local Enemy_SpellBlock = Enemy.MagicArmor

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellQ + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellQ + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

	if Spell == _R then
		if myHero.LevelSpell(_R) == 0 then return 0 end
		local DamageSpellRTable = { 80, 100, 120 }
		local Percent_AP = 0.3

		local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

		local DamageSpellR = DamageSpellRTable[myHero.LevelSpell(_R)]

		local Enemy_SpellBlock = Enemy.MagicArmor

		local Void_Staff_Id = 3135 -- Void Staff Item
		if GetItemByID(Void_Staff_Id) > 0 then
			Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
		end

		Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen

		if Enemy_SpellBlock >= 0 then
			Damage = (DamageSpellR + Percent_AP * AP + 0.2 * myHero.MaxMP) * (100/(100 + Enemy_SpellBlock))
		else
			Damage = (DamageSpellR + Percent_AP * AP + 0.2 * myHero.MaxMP) * (2 - 100/(100 - Enemy_SpellBlock))
		end

		return Damage
	end

end



