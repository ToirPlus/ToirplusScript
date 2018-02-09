--Credtis: PINGGIN AND DavKat, Shulepin

--Incluindo Files do Yasuo
    IncludeFile("Lib\\TOIR_SDK.lua")
--    IncludeFile("Lib\\DamageLib")

--Classes
Yasuo = class()

function Yasuo:__init()
    SetLuaCombo(true)
    SetLuaLaneClear(true)

    W_SPELLS = { -- Yea boiz and grillz its all right here.......
    ["FizzMarinerDoom"]                      = {Spellname ="FizzMarinerDoom",Name = "Fizz", Spellslot =_R},
    ["AatroxE"]                      = {Spellname ="AatroxE",Name= "Aatrox", Spellslot =_E},
    ["AhriOrbofDeception"]                      = {Spellname ="AhriOrbofDeception",Name = "Ahri", Spellslot =_Q},
    ["AhriFoxFire"]                      = {Spellname ="AhriFoxFire",Name = "Ahri", Spellslot =_W},
    ["AhriSeduce"]                      = {Spellname ="AhriSeduce",Name = "Ahri", Spellslot =_E},
    ["AhriTumble"]                      = {Spellname ="AhriTumble",Name = "Ahri", Spellslot =_R},
    ["FlashFrost"]                      = {Spellname ="FlashFrost",Name = "Anivia", Spellslot =_Q},
    ["Anivia2"]                      = {Spellname ="Frostbite",Name = "Anivia", Spellslot =_E},
    ["Disintegrate"]                      = {Spellname ="Disintegrate",Name = "Annie", Spellslot =_Q},
    ["Volley"]                      = {Spellname ="Volley",Name ="Ashe", Spellslot =_W},
    ["EnchantedCrystalArrow"]                      = {Spellname ="EnchantedCrystalArrow",Name ="Ashe", Spellslot =_R},
    ["BandageToss"]                      = {Spellname ="BandageToss",Name ="Amumu",Spellslot =_Q},
    ["RocketGrabMissile"]                      = {Spellname ="RocketGrabMissile",Name ="Blitzcrank",Spellslot =_Q},
    ["BrandBlaze"]                      = {Spellname ="BrandBlaze",Name ="Brand", Spellslot =_Q},
    ["BrandWildfire"]                      = {Spellname ="BrandWildfire",Name ="Brand", Spellslot =_R},
    ["BraumQ"]                      = {Spellname ="BraumQ",Name ="Braum",Spellslot =_Q},
    ["BraumRWapper"]                      = {Spellname ="BraumRWapper",Name ="Braum",Spellslot =_R},
    ["CaitlynPiltoverPeacemaker"]                      = {Spellname ="CaitlynPiltoverPeacemaker",Name ="Caitlyn",Spellslot =_Q},
    ["CaitlynEntrapment"]                      = {Spellname ="CaitlynEntrapment",Name ="Caitlyn",Spellslot =_E},
    ["CaitlynAceintheHole"]                      = {Spellname ="CaitlynAceintheHole",Name ="Caitlyn",Spellslot =_R},
    ["CassiopeiaMiasma"]                      = {Spellname ="CassiopeiaMiasma",Name ="Cassiopiea",Spellslot =_W},
    ["CassiopeiaTwinFang"]                      = {Spellname ="CassiopeiaTwinFang",Name ="Cassiopiea",Spellslot =_E},
    ["PhosphorusBomb"]                      = {Spellname ="PhosphorusBomb",Name ="Corki",Spellslot =_Q},
    ["MissileBarrage"]                      = {Spellname ="MissileBarrage",Name ="Corki",Spellslot =_R},
    ["DianaArc"]                      = {Spellname ="DianaArc",Name ="Diana",Spellslot =_Q},
    ["InfectedCleaverMissileCast"]                      = {Spellname ="InfectedCleaverMissileCast",Name ="DrMundo",Spellslot =_Q},
    ["dravenspinning"]                      = {Spellname ="dravenspinning",Name ="Draven",Spellslot =_Q},
    ["DravenDoubleShot"]                      = {Spellname ="DravenDoubleShot",Name ="Draven",Spellslot =_E},
    ["DravenRCast"]                      = {Spellname ="DravenRCast",Name ="Draven",Spellslot =_R},
    ["EliseHumanQ"]                      = {Spellname ="EliseHumanQ",Name ="Elise",Spellslot =_Q},
    ["EliseHumanE"]                      = {Spellname ="EliseHumanE",Name ="Elise",Spellslot =_E},
    ["EvelynnQ"]                      = {Spellname ="EvelynnQ",Name ="Evelynn",Spellslot =_Q},
    ["EzrealMysticShot"]                      = {Spellname ="EzrealMysticShot",Name ="Ezreal",Spellslot =_Q,},
    ["EzrealEssenceFlux"]                      = {Spellname ="EzrealEssenceFlux",Name ="Ezreal",Spellslot =_W},
    ["EzrealArcaneShift"]                      = {Spellname ="EzrealArcaneShift",Name ="Ezreal",Spellslot =_R},
    ["GalioRighteousGust"]                      = {Spellname ="GalioRighteousGust",Name ="Galio",Spellslot =_E},
    ["GalioResoluteSmite"]                      = {Spellname ="GalioResoluteSmite",Name ="Galio",Spellslot =_Q},
    ["Parley"]                      = {Spellname ="Parley",Name ="Gangplank",Spellslot =_Q},
    ["GnarQ"]                      = {Spellname ="GnarQ",Name ="Gnar",Spellslot =_Q},
    ["GravesClusterShot"]                      = {Spellname ="GravesClusterShot",Name ="Graves",Spellslot =_Q},
    ["GravesChargeShot"]                      = {Spellname ="GravesChargeShot",Name ="Graves",Spellslot =_R},
    ["HeimerdingerW"]                      = {Spellname ="HeimerdingerW",Name ="Heimerdinger",Spellslot =_W},
    ["IreliaTranscendentBlades"]                      = {Spellname ="IreliaTranscendentBlades",Name ="Irelia",Spellslot =_R},
    ["HowlingGale"]                      = {Spellname ="HowlingGale",Name ="Janna",Spellslot =_Q},
    ["JayceToTheSkies"]                      = {Spellname ="JayceToTheSkies" or "jayceshockblast",Name ="Jayce",Spellslot =_Q},
    ["jayceshockblast"]                      = {Spellname ="JayceToTheSkies" or "jayceshockblast",Name ="Jayce",Spellslot =_Q},
    ["JinxW"]                      = {Spellname ="JinxW",Name ="Jinx",Spellslot =_W},
    ["JinxR"]                      = {Spellname ="JinxR",Name ="Jinx",Spellslot =_R},
    ["KalistaMysticShot"]                      = {Spellname ="KalistaMysticShot",Name ="Kalista",Spellslot =_Q},
    ["KarmaQ"]                      = {Spellname ="KarmaQ",Name ="Karma",Spellslot =_Q},
    ["NullLance"]                      = {Spellname ="NullLance",Name ="Kassidan",Spellslot =_Q},
    ["KatarinaR"]                      = {Spellname ="KatarinaR",Name ="Katarina",Spellslot =_R},
    ["LeblancChaosOrb"]                      = {Spellname ="LeblancChaosOrb",Name ="Leblanc",Spellslot =_Q},
    ["LeblancSoulShackle"]                      = {Spellname ="LeblancSoulShackle" or "LeblancSoulShackleM",Name ="Leblanc",Spellslot =_E},
    ["LeblancSoulShackleM"]                      = {Spellname ="LeblancSoulShackle" or "LeblancSoulShackleM",Name ="Leblanc",Spellslot =_E},
    ["BlindMonkQOne"]                      = {Spellname ="BlindMonkQOne",Name ="Leesin",Spellslot =_Q},
    ["LeonaZenithBladeMissle"]                      = {Spellname ="LeonaZenithBladeMissle",Name ="Leona",Spellslot =_E},
    ["LissandraE"]                      = {Spellname ="LissandraE",Name ="Lissandra",Spellslot =_E},
    ["LucianR"]                      = {Spellname ="LucianR",Name ="Lucian",Spellslot =_R},
    ["LuxLightBinding"]                      = {Spellname ="LuxLightBinding",Name ="Lux",Spellslot =_Q},
    ["LuxLightStrikeKugel"]                      = {Spellname ="LuxLightStrikeKugel",Name ="Lux",Spellslot =_E},
    ["MissFortuneBulletTime"]                      = {Spellname ="MissFortuneBulletTime",Name ="Missfortune",Spellslot =_R},
    ["DarkBindingMissile"]                      = {Spellname ="DarkBindingMissile",Name ="Morgana",Spellslot =_Q},
    ["NamiR"]                      = {Spellname ="NamiR",Name ="Nami",Spellslot =_R},
    ["JavelinToss"]                      = {Spellname ="JavelinToss",Name ="Nidalee",Spellslot =_Q},
    ["NocturneDuskbringer"]                      = {Spellname ="NocturneDuskbringer",Name ="Nocturne",Spellslot =_Q},
    ["Pantheon_Throw"]                      = {Spellname ="Pantheon_Throw",Name ="Pantheon",Spellslot =_Q},
    ["QuinnQ"]                      = {Spellname ="QuinnQ",Name ="Quinn",Spellslot =_Q},
    ["RengarE"]                      = {Spellname ="RengarE",Name ="Rengar",Spellslot =_E},
    ["rivenizunablade"]                      = {Spellname ="rivenizunablade",Name ="Riven",Spellslot =_R},
    ["Overload"]                      = {Spellname ="Overload",Name ="Ryze",Spellslot =_Q},
    ["SpellFlux"]                      = {Spellname ="SpellFlux",Name ="Ryze",Spellslot =_E},
    ["SejuaniGlacialPrisonStart"]                      = {Spellname ="SejuaniGlacialPrisonStart",Name ="Sejuani",Spellslot =_R},
    ["SivirQ"]                      = {Spellname ="SivirQ",Name ="Sivir",Spellslot =_Q},
    ["SivirE"]                      = {Spellname ="SivirE",Name ="Sivir",Spellslot =_E},
    ["SkarnerFractureMissileSpell"]                      = {Spellname ="SkarnerFractureMissileSpell",Name ="Skarner",Spellslot =_E},
    ["SonaCrescendo"]                      = {Spellname ="SonaCrescendo",Name ="Sona",Spellslot =_R},
    ["SwainDecrepify"]                      = {Spellname ="SwainDecrepify",Name ="Swain",Spellslot =_Q},
    ["SwainMetamorphism"]                      = {Spellname ="SwainMetamorphism",Name ="Swain",Spellslot =_R},
    ["SyndraE"]                      = {Spellname ="SyndraE",Name ="Syndra",Spellslot =_E},
    ["SyndraR"]                      = {Spellname ="SyndraR",Name ="Syndra",Spellslot =_R},
    ["TalonRake"]                      = {Spellname ="TalonRake",Name ="Talon",Spellslot =_W},
    ["TalonShadowAssault"]                      = {Spellname ="TalonShadowAssault",Name ="Talon",Spellslot =_R},
    ["BlindingDart"]                      = {Spellname ="BlindingDart",Name ="Teemo",Spellslot =_Q},
    ["Thresh"]                      = {Spellname ="ThreshQ",Name ="Thresh",Spellslot =_Q},
    ["BusterShot"]                      = {Spellname ="BusterShot",Name ="Tristana",Spellslot =_R},
    ["VarusQ"]                      = {Spellname ="VarusQ",Name ="Varus",Spellslot =_Q},
    ["VarusR"]                      = {Spellname ="VarusR",Name ="Varus",Spellslot =_R},
    ["VayneCondemm"]                      = {Spellname ="VayneCondemm",Name ="Vayne",Spellslot =_E},
    ["VeigarPrimordialBurst"]                      = {Spellname ="VeigarPrimordialBurst",Name ="Veigar",Spellslot =_R},
    ["WildCards"]                      = {Spellname ="WildCards",Name ="Twistedfate",Spellslot =_Q},
    ["VelkozQ"]                      = {Spellname ="VelkozQ",Name ="Velkoz",Spellslot =_Q},
    ["VelkozW"]                      = {Spellname ="VelkozW",Name ="Velkoz",Spellslot =_W},
    ["ViktorDeathRay"]                      = {Spellname ="ViktorDeathRay",Name ="Viktor",Spellslot =_E},
    ["XerathArcanoPulseChargeUp"]                      = {Spellname ="XerathArcanoPulseChargeUp",Name ="Xerath",Spellslot =_Q},
    ["ZedShuriken"]                      = {Spellname ="ZedShuriken",Name ="Zed",Spellslot =_Q},
    ["ZiggsR"]                      = {Spellname ="ZiggsR",Name ="Ziggs",Spellslot =_R},
    ["ZiggsQ"]                      = {Spellname ="ZiggsQ",Name ="Ziggs",Spellslot =_Q},
    ["ZyraGraspingRoots"]                      = {Spellname ="ZyraGraspingRoots",Name ="Zyra",Spellslot =_E}

}
    self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_HEALTH_ASC)
    self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_HEALTH_ASC)
    --Target
    self.menu_ts = TargetSelector(1750, 0, myHero, true, true, true)

    self.MissileSpellsData = {}
    self:MenuYasuo()

    self.passiveTracker = false

		--Spells
		self.Q = Spell(_Q, 425)
		self.W = Spell(_W, 600)
        self.E = Spell(_E, 475)
        self.R = Spell(_R, 1200)

        self.W:SetSkillShot()
        self.E:SetTargetted()
        self.R:SetTargetted()

		Callback.Add("Tick", function() self:OnTick() end) --Call Back Yasuo <3 by: DevkAT
		--Callback.Add("Draw", function() self:OnDraw() end)
        Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
        Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)
end

function Yasuo:MenuYasuo()
	self.menu = "Yasuo"
    self.Use_Combo_Q = self:MenuBool("Use Combo Q", true)
    self.AutoQStack = self:MenuBool("Auto Q", true)

    self.Use_Combo_W = self:MenuBool("Auto W", true)

	self.Enable_E = self:MenuBool("Enable E", true)

	self.Enable_R = self:MenuBool("Enable R", true)
    self.Use_R_Kill_Steal = self:MenuBool("Use R Kill Steal", true)
    self.Life = self:MenuSliderInt("Hero Life Utimate", 50)
    self.MinInimigo = self:MenuSliderInt("Range Heros {R}", 2)

    self.UseQClear = self:MenuBool("Use Q LaneClear", true)
    self.UseEClear = self:MenuBool("Use E LaneClear", true)

	self.menu_key_combo = self:MenuKeyBinding("Combo", 32)
    self.Lane_Clear = self:MenuKeyBinding("Lane Clear", 86)
    self.ActiveR = self:MenuKeyBinding("Active R Utimate", 84)
    self.Flee = self:MenuKeyBinding("Flee {E}", 65)
    self.Last_Hit = self:MenuKeyBinding("Last Hit", 88)
    self.Harass = self:MenuKeyBinding("Harass", 67)
end

function Yasuo:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Combo") then
			self.Use_Combo_Q = Menu_Bool("Use Combo Q", self.Use_Combo_Q, self.menu)
            self.Use_Combo_W = Menu_Bool("Auto W", self.Use_Combo_W, self.menu)
            self.AutoQStack = Menu_Bool("Auto Q", self.AutoQStack, self.menu)
			self.Enable_E = Menu_Bool("Enable E", self.Enable_E, self.menu)
			self.Enable_R = Menu_Bool("Enable R", self.Enable_R, self.menu)
            self.Use_R_Kill_Steal = Menu_Bool("Use R Kill Steal", self.Use_R_Kill_Steal, self.menu)
            self.Life = Menu_SliderInt("Hero Life Utimate", self.Life, 0, 100, self.menu)
            self.MinInimigo = Menu_SliderInt("Range Heros {R}", self.MinInimigo, 0, 5, self.menu)
			Menu_End()
        end
        if Menu_Begin("LaneClear") then
            self.UseQClear = Menu_Bool("Use Q Clear", self.UseQClear, self.menu)
            self.UseEClear = Menu_Bool("Use E Clear", self.UseEClear, self.menu)
            Menu_End()
        end

		if Menu_Begin("Keys Yasuo") then
			self.menu_key_combo = Menu_KeyBinding("Combo", self.menu_key_combo, self.menu)
            self.Lane_Clear = Menu_KeyBinding("Lane Clear", self.Lane_Clear, self.menu)
            self.ActiveR = Menu_KeyBinding("Active R Utimate", self.ActiveR, self.menu)
            self.Flee = Menu_KeyBinding("Flee {E}", self.Flee, self.menu)
            self.Last_Hit = Menu_KeyBinding("Last Hit", self.Last_Hit, self.menu)
            self.Harass = Menu_KeyBinding("Harass", self.Harass, self.menu)
			Menu_End()
		end
		Menu_End()
	end
end

function Yasuo:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Yasuo:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Yasuo:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Yasuo:IsAfterAttack()
    if CanMove() and not CanAttack() then
        return true
    else
        return false
	end
end

function Yasuo:OnProcessSpell(unit, spell)
    if GetChampName(GetMyChamp()) ~= "Yasuo" then return end
	if self.W:IsReady()  and IsValidTarget(unit.Addr, 1500) then
		if spell and unit.IsEnemy then
			if myHero == spell.target and spell.Name:lower():find("attack") and (unit.AARange >= 450 or unit.IsRanged) then
				local wPos = Vector(myHero) + (Vector(unit) - Vector(myHero)):Normalized() * self.W.range
				CastSpellToPos(wPos.x, wPos.z, _W)
			end
			spell.endPos = {x=spell.DestPos_x, y=spell.DestPos_y, z=spell.DestPos_z}
			if W_SPELLS[spell.Name] and not unit.IsMe and GetDistance(unit) <= GetDistance(unit, spell.endPos) then
				CastSpellToPos(unit.x, unit.z, _W)
			end
		end
	end
end


function Yasuo:DashEndPos(target)
    local Estent = 0

    if GetDistance(target) < 410 then
        Estent = Vector(myHero):Extended(Vector(target), 475)
    else
        Estent = Vector(myHero):Extended(Vector(target), GetDistance(target) + 65)
    end

    return Estent
end

function Yasuo:IsMarked(target)
    return target.HasBuff("YasuoDashWrapper")
end

function Yasuo:ClosetMinion(target)
    GetAllUnitAroundAnObject(myHero.Addr, 1500)
    local bestMinion = nil
    local closest = 0
    local units = pUnit
    for i, unit in pairs(units) do
        if unit and unit ~= 0 and IsMinion(unit) and IsEnemy(unit) and not IsDead(unit) and not IsInFog(unit) and GetTargetableToTeam(unit) == 4 and not self:IsMarked(GetUnit(unit)) and GetDistance(GetUnit(unit)) < 375 then
            if GetDistance(self:DashEndPos(GetUnit(unit)), target) < GetDistance(target) and closest < GetDistance(GetUnit(unit)) then
                closest = GetDistance(GetUnit(unit))
                bestMinion = unit
            end
        end
    end
    return bestMinion
end

function Yasuo:Combo(target)
    if target and target ~= 0 and IsEnemy(target) then

        if self.E:IsReady() then
            if self.Enable_E and IsValidTarget(target, self.E.range) and not self:IsMarked(GetAIHero(target)) and GetDistance(GetAIHero(target), self:DashEndPos(GetAIHero(target))) <= GetDistance(GetAIHero(target)) then
                self.E:Cast(target)
            end

            if self.Enable_E and not self.passiveTracker then
                local gapMinion = self:ClosetMinion(GetAIHero(target))

                if gapMinion and gapMinion ~= 0 and not self:IsUnderTurretEnemy(GetUnit(gapMinion)) then
                    self.E:Cast(gapMinion)
                end
            end
        end

        if self.Q:IsReady() and IsValidTarget(target, self.Q.range) then
            if self.Use_Combo_Q and not myHero.IsDash then
                self.Q:Cast(target)
            end

            if self.Use_Combo_Q and myHero.IsDash and GetDistance(GetAIHero(target)) <= 250 then
                self.Q:Cast(target)
            end
        end
    end
end

function Yasuo:AntiDashsing()
  SearchAllChamp()
  local Enemies = pObjChamp
  for idx, enemy in ipairs(Enemies) do
    if enemy ~= 0 then
      if self.Q:IsReady() and IsValidTarget(enemy, self.Q.range) and IsDashing(enemy) and self.passiveTracker and IsEnemy(enemy) then
            self.Q:Cast(enemy)
		end
    end
  end
end

function Yasuo:AutoUtimatey()
	local target = self.menu_ts:GetTarget()
	if target ~= 0 and IsEnemy(target) then
		local hero = GetAIHero(target)
		if self.R:IsReady() and IsValidTarget(target, self.R.range) and CountEnemyChampAroundObject(target, self.R.range) <= 1 and hero.HP*100/hero.MaxHP < self.Life then --solo
			self.R:Cast(target)
		end
	end
end

function Yasuo:Utimatey(target)
    if self.R:IsReady() and IsValidTarget(target, self.R.range) and IsEnemy(target) then
        self.R:Cast(target)
    end
end

function Yasuo:Fleey()
    local mousePos = Vector(GetMousePos())
    MoveToPos(mousePos.x,mousePos.z)
    self.EnemyMinions:update()
    for k, v in pairs(self.EnemyMinions.objects) do
    if CanCast(E) and GetDistance(v) < self.E.range then
        CastSpellTarget(v.Addr, _E)
        end
    end
end

function Yasuo:JungleClear()
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    local result = {}
    for i, minions in pairs(pUnit) do
        if minions ~= 0 and not IsDead(minions) and not IsInFog(minions) and GetType(minions) == 3 then
            table.insert(result, minions)
        end
    end

    return result
end

local function GetDistanceSqr(p1, p2)
    p2 = p2 or GetOrigin(myHero)
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end


function Yasuo:IsUnderTurretEnemy(pos)
	GetAllObjectAroundAnObject(myHero.Addr, 2000)
	local objects = pObject
	for k,v in pairs(objects) do
		if IsTurret(v) and not IsDead(v) and IsEnemy(v) and GetTargetableToTeam(v) == 4 then
			local turretPos = Vector(GetPosX(v), GetPosY(v), GetPosZ(v))
			if GetDistanceSqr(turretPos,pos) < (915+475)*(915+475) then
				return true
			end
		end
	end
	return false
end


function Yasuo:FarmJungle(target)
	for i, minions in ipairs(self:JungleClear()) do
        if minions ~= 0 then
		local jungle = GetUnit(minions)
		if jungle.Type == 3 then

	  if CanCast(_Q) then
		if jungle ~= nil and GetDistance(jungle) < self.Q.range then
			self.Q:Cast(jungle.Addr)
        end
	   end
	  if CanCast(_E) then
		if jungle ~= nil and GetDistance(jungle) < self.E.range then
		  self.E:Cast(jungle.Addr)
		end
    end
 end
end
end
end

function Yasuo:PositionDash(dashPos)
	local Seguimento = self.E.range / 5;
	local myHeroPos = Vector(myHero.x, myHero.y, myHero.z)
	for i = 1, 5, 1 do
		pos = myHeroPos:Extended(dashPos, i * Seguimento)
		if IsWall(pos.x, pos.y, pos.z) then
			return false
		end
	end

	if self:IsUnderTurretEnemy(dashPos)  then
		return false
	end

	local Check = 2
    local enemyCountDashPos = self:CountEnemiesInRange(dashPos, 600);
    if Check > enemyCountDashPos then
    	return true
    end
    local CountEnemy = CountEnemyChampAroundObject(myHero.Addr, 400)
    if enemyCountDashPos <= CountEnemy then
    	return true
    end

    return false
end


function Yasuo:WQ(target)
    if self.W:IsReady() and self.Q:IsReady() and GetDistance(target) < 425 then
        self.W:Cast(target)
        self.Q:Cast(target)
    end
end

function Yasuo:HarassQ3(target)
    if self.Q:IsReady() and GetDistance(target) < self.Q.range and self.passiveTracker then
        self.Q:Cast(target)
    end
end

function Yasuo:UtimoHit()
    self.EnemyMinions:update()
    for k, v in pairs(self.EnemyMinions.objects) do
        if CanCast(_Q) and IsValidTarget(v, self.Q.range) and v.IsEnemy then
        CastSpellToPos(v.x,v.z, _Q)
        end
    end
end

function Yasuo:StackQ()
	if not self.passiveTracker then
		self.EnemyMinions:update()
		for k, v in pairs(self.EnemyMinions.objects) do
			if v and CanCast(_Q) and IsValidTarget(v, self.Q.range) and v.IsEnemy then
			CastSpellToPos(v.x,v.z, _Q)
			end
		end

		self.JungleMinions:update()
		for k, v in pairs(self.JungleMinions.objects) do
			if v and CanCast(_Q) and IsValidTarget(v, self.Q.range) and v.IsEnemy then
			CastSpellToPos(v.x,v.z, _Q)
			end
		end
	end

	SearchAllChamp()
	for i, enemy in pairs(pObjChamp) do
		if enemy ~= 0 then
			local hero = GetAIHero(enemy)
			if hero and CanCast(_Q) and IsValidTarget(hero, self.Q.range) and not self:IsUnderTurretEnemy(hero) and GetDistance(hero) > 0 and hero.IsEnemy then
				CastSpellToPos(hero.x,hero.z, _Q)
			end
		end
	end
end

function Yasuo:OnTick()

	if IsDead(myHero.Addr) or IsTyping() or IsDodging() then return end

	self.passiveTracker = false

    if GetSpellNameByIndex(myHero.Addr, _Q) == "YasuoQW" then
        self.Q.range = 425
        self.Q:SetSkillShot(0.25, math.huge, 30, false)
    elseif GetSpellNameByIndex(myHero.Addr, _Q) == "YasuoQ3W" then
		self.passiveTracker = true
        self.Q.range = 1000
        self.Q:SetSkillShot(0.25, 1200, 90, false)
    end

    self:AntiDashsing()
    self:AutoUtimatey()

    if GetKeyPress(self.Harass) > 0 then
        self:UtimoHit()
    end

    if GetKeyPress(self.Flee) > 0 then
        self:Fleey()
        self:FleeJG()
    end

    if GetKeyPress(self.Lane_Clear) > 0 then
		local target = self.menu_ts:GetTarget()
		self:HarassQ3(target)
        self:FarmClear()
        self:FarmJungle()
    end

    if GetKeyPress(self.ActiveR) > 0 then
        local target = self.menu_ts:GetTarget()
        self:Utimatey(target)
    end

    if GetKeyPress(self.menu_key_combo) > 0 then
        local target = self.menu_ts:GetTarget()
		self:WQ(target)
        self:Combo(target)
        self:UseR(target)
    end

	self:StackQ()
end

function Yasuo:FleeJG()
    local mousePos = Vector(GetMousePos())
    MoveToPos(mousePos.x,mousePos.z)
    for i, minions in ipairs(self:JungleClear()) do
        if minions ~= 0 then
        local jungle = GetUnit(minions)
        if jungle.Type == 3 then
        if CanCast(_E) then
            if jungle ~= nil and GetDistance(jungle) < self.E.range then
              self.E:Cast(jungle.Addr)
            end
        end
    end
end
end
end

function Yasuo:FarmClear()
    self.EnemyMinions:update()
        for k, v in pairs(self.EnemyMinions.objects) do
            if CanCast(_Q) and IsValidTarget(v, self.Q.range) and self.UseQClear and v.IsEnemy then
            CastSpellToPos(v.x,v.z, _Q)
            end
            if Setting_IsLaneClearUseE() and CanCast(_E) and GetDistance(v) < self.E.range and self.UseEClear and not self.passiveTracker and v.IsEnemy and not self:IsUnderTurretEnemy(v) then
            CastSpellTarget(v.Addr, _E)
        end
    end
end

function Yasuo:UseR(target)
    if target ~= 0 then
		local hero = GetAIHero(target)
    if self.R:IsReady() and IsValidTarget(target, self.R.range) and CountEnemyChampAroundObject(target, self.R.range) < self.MinInimigo and hero.HP*100/hero.MaxHP < self.Life and hero.IsEnemy then
        self.R:Cast(target)
       end
    end
end

function OnLoad()
	if GetChampName(GetMyChamp()) == "Yasuo" then
		Yasuo:__init()
    end
end
