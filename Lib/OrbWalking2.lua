--IncludeFile("Lib\\TOIR_SDK.lua")

-----------------------------------------------------------------------Ultil--------------------------------------------------------------------------------

Internal				= 0
Aura					= 1
CombatEnchancer		= 2
CombatDehancer			= 3
SpellShield			= 4
Stun					= 5
Invisibility			= 6
Silence				= 7
Taunt					= 8
Polymorph				= 9
Slow					= 10
Snare					= 11
Damage					= 12
Heal					= 13
Haste					= 14
SpellImmunity			= 15
PhysicalImmunity		= 16
Invulnerability		= 17
Sleep					= 18
NearSight				= 19
Frenzy					= 20
Fear					= 21
Charm					= 22
Poison					= 23
Suppression			= 24
Blind					= 25
Counter				= 26
Shred					= 27
Flee					= 28
Knockup				= 29
Knockback				= 30
Disarm					= 31

BuffType = {
	["Internal"]      = Internal,
	["Aura"]      = Aura,
	["CombatEnchancer"]      = CombatEnchancer,
	["CombatDehancer"]      = CombatDehancer,
	["SpellShield"]      = SpellShield,
	["Stun"]      = Stun,
	["Invisibility"]      = Invisibility,
	["Silence"]      = Silence,
	["Taunt"]      = Taunt,
	["Polymorph"]      = Polymorph,
	["Slow"]      = Slow,
	["Snare"]      = Snare,
	["Damage"]      = Damage,
	["Heal"]      = Heal,
	["Haste"]      = Haste,
	["SpellImmunity"]      = SpellImmunity,
	["PhysicalImmunity"]      = PhysicalImmunity,
	["Invulnerability"]      = Invulnerability,
	["Sleep"]      = Sleep,
	["NearSight"]      = NearSight,
	["Frenzy"]      = Frenzy,
	["Fear"]      = Fear,
	["Charm"]      = Charm,
	["Poison"]      = Poison,
	["Suppression"]      = Suppression,
	["Blind"]      = Blind,
	["Counter"]      = Counter,
	["Shred"]      = Shred,
	["Flee"]      = Flee,
	["Knockup"]      = Knockup,
	["Knockback"]      = Knockback,
	["Disarm"]      = Disarm
}

-----------------------------------------------------------------------Interface--------------------------------------------------------------------------------
Orbwalking2 = class()

function Orbwalking2:__init()

    self.AttackingEnabled = true

--~ 	self.AttackResets = {}

--~ 	self.Combo = {}

--~ 	self.LaneClear = {}

--~ 	self.LastHit = {}

--~ 	self.Mixed = {}

--~ 	self.Mode = {}

--~ 	self.ModeName = ""

	self.LastTarget = nil

	self.MovingEnabled = true

	self.WindUpTime = 0

	self.OrbwalkingMode = {
		["None"]      = "None",
		["Combo"]     = "Combo",
		["Mixed"]     = "Mixed",
		["Laneclear"] = "Laneclear",
		["Lasthit"]   = "Lasthit",
		["Freeze"]    = "Freeze",
		["Custom"]    = "Custom"
	}

	self.specialAttacks =
	{
		"caitlynheadshotmissile",
		"goldcardpreattack",
		"redcardpreattack",
		"bluecardpreattack",
		"viktorqbuff",
		"quinnwenhanced",
		"renektonexecute",
		"renektonsuperexecute",
		"trundleq",
		"xenzhaothrust",
		"xenzhaothrust2",
		"xenzhaothrust3",
		"frostarrow",
		"garenqattack",
		"kennenmegaproc",
		"masteryidoublestrike",
		"mordekaiserqattack",
		"reksaiq",
		"warwickq",
		"vaynecondemnmissile",
		"masochismattack"
	}

	self.attackResets =
	{
		"asheq",
		"dariusnoxiantacticsonh",
		"garenq",
		"gravesmove",
		"jaxempowertwo",
		"jaycehypercharge",
		"leonashieldofdaybreak",
		"luciane",
		"monkeykingdoubleattack",
		"mordekaisermaceofspades",
		"nasusq",
		"nautiluspiercinggaze",
		"netherblade",
		"gangplankqwrapper",
		"powerfist",
		"renektonpreexecute",
		"rengarq",
		"shyvanadoubleattack",
		"sivirw",
		"takedown",
		"talonnoxiandiplomacy",
		"trundletrollsmash",
		"vaynetumble",
		"vie",
		"volibearq",
		"xenzhaocombotarget",
		"yorickspectral",
		"reksaiq",
		"itemtitanichydracleave",
		"masochism",
		"illaoiw",
		"elisespiderw",
		"fiorae",
		"meditate",
		"sejuaninorthernwinds",
		"camilleq",
		"camilleq2",
		"vorpalspikes"
	}

	self.projectilespeeds = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2500.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000, ["SRU_OrderMinionRanged"] = 650, ["SRU_ChaosMinionRanged"] = 650, ["SRU_OrderMinionSiege"] = 1200, ["SRU_OrderMinionMelee"] = math.huge, ["SRU_ChaosMinionMelee"] = math.huge, ["SRU_ChaosMinionSiege"] = 1200, ["SRUAP_Turret_Chaos1"]  = 1200, ["SRUAP_Turret_Chaos2"]  = 1200, ["SRUAP_Turret_Chaos3"] = 1200, ["SRUAP_Turret_Order1"]  = 1200, ["SRUAP_Turret_Order2"]  = 1200, ["SRUAP_Turret_Order3"] = 1200, ["SRUAP_Turret_Chaos4"] = 1200, ["SRUAP_Turret_Chaos5"] = 500, ["SRUAP_Turret_Order4"] = 1200, ["SRUAP_Turret_Order5"] = 500 }

	self.PreAttackCallbacks = {}
	self.PostAttackCallbacks = {}
	self.NonKillableMinionCallbacks = {}

	self.TargetSelector = nil

	-----------------------------------------------------------------------Prediction--------------------------------------------------------------------------------
	self.Attacks = {}
	self.LastCleanUp = 0

	-----------------------------------------------------------------------Configuration--------------------------------------------------------------------------------
	self.AttackDelayReduction = 0--90/1000
	self.ExtraWindUp = 0--GetLatency()/2000
	self.HoldPositionRadius = 50
	self.ExtraDelay = 0

	self.AttackPlants = false
	self.AttackWards = true
	self.AttackBarrels = true

	-----------------------------------------------------------------------Implement--------------------------------------------------------------------------------

	self.LastAttackCommandSentTime = 0

	self.AnimationTime = myHero.Windup

	self.ServerAttackDetectionTick = 0

	self.ForcedTarget = nil

	self.noWasteAttackChamps = { ["Kalista"] = true, ["Twitch"] = true }
	self.NoCancelChamps = { "Kalista" }

	self.WindUpTime = self.AnimationTime + self.ExtraWindUp

	self.OrbwalkerModes = { }

	Callback.Add("Tick", function(...) self:OnTick(...) end)
	Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
	Callback.Add("CreateObject", function(...) self:OnCreateObject(...) end)
	Callback.Add("DeleteObject", function(...) self:OnDeleteObject(...) end)
	Callback.Add("Update", function(...) self:OnUpdate(...) end)
	Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)

end

-----------------------------------------------------------------------Implement--------------------------------------------------------------------------------
function Orbwalking2:AttackCoolDownTime()
	local champion = myHero.CharName
	local attackDelay = myHero.CDBA
	if champion == "Graves" then
		attackDelay = (1.0740296828 * myHero.CDBA - 0.7162381256175)
	end

	if champion == "Kalista" then --this.Config["Misc"]["KalistaFly"].Enabled
		return attackDelay
	end
	return attackDelay - self.AttackDelayReduction
end

function Orbwalking2:IsWindingUp()
	local detectionTime = math.max(self.ServerAttackDetectionTick, self.LastAttackCommandSentTime)
	return GetTimeGame() + GetLatency() / 2000 - detectionTime <= self.WindUpTime
end

function Orbwalking2:AddMode(mode)
	self.OrbwalkerModes = {}
	if mode ~= self.OrbwalkingMode.None then
		self.OrbwalkerModes = { [mode] = mode }
	end
end

--~ function Orbwalking2:Attach(menu)
--~ 	if menu then

--~ 	end
--~ end

function Orbwalking2:OnDrawMenu()
	if Menu_Begin("Orbwalking2") then
		if Menu_Begin("ExtraWindUp") then
			local ExtraWindUp = Menu_SliderInt("Additional Windup", 0, 0, 200, "sectionIni_Orbwalking2")
			self.ExtraWindUp = math.ceil(ExtraWindUp/1000)
			Menu_End()
		end
		if Menu_Begin("AttackDelayReduction") then
			local AttackDelayReduction = Menu_SliderInt("Attack Delay Reduction", 90, 0, 180, "sectionIni_Orbwalking2")
			self.AttackDelayReduction = math.ceil(AttackDelayReduction/1000)
			Menu_End()
		end
		if Menu_Begin("HoldPositionRadius") then
			self.HoldPositionRadius = Menu_SliderInt("Hold Radius", self.HoldPositionRadius, 0, 400, "sectionIni_Orbwalking2")
			Menu_End()
		end
		if Menu_Begin("ExtraDelay") then
			local ExtraDelay = Menu_SliderInt("ExtraDelay", 0, 0, 150, "sectionIni_Orbwalking2")
			self.ExtraDelay = math.ceil(ExtraDelay/1000)
			Menu_End()
		end
		if Menu_Begin("AttackPlants") then
			self.AttackPlants = Menu_Bool("Attack Plants", self.AttackPlants, "sectionIni_Orbwalking2")
			Menu_End()
		end
		if Menu_Begin("AttackWards") then
			self.AttackWards = Menu_Bool("Attack Wards", self.AttackWards, "sectionIni_Orbwalking2")
			Menu_End()
		end
		if Menu_Begin("AttackBarrels") then
			self.AttackBarrels = Menu_Bool("Attack Barrels", self.AttackBarrels, "sectionIni_Orbwalking2")
			Menu_End()
		end
		Menu_End()
	end
end

function Orbwalking2:RegisterPreAttackCallback(f)
    table.insert(self.PreAttackCallbacks, f)
end

function Orbwalking2:FirePreAttack(target)
	local preAttackargs = { ["Cancel"] = false, ["Target"] = target }
	for i, cb in ipairs(self.PreAttackCallbacks) do
        cb(target)
	end
	return preAttackargs
end

function Orbwalking2:Attack(target)
	local preAttackargs = self:FirePreAttack(target)
	if not preAttackargs.Cancel then
		local targetToAttack = preAttackargs.Target
		if self.ForcedTarget ~= nil and self:IsValidAutoRange(self.ForcedTarget) then
			targetToAttack = self.ForcedTarget
		end

		BasicAttack(targetToAttack) --core
		self.LastAttackCommandSentTime = GetTimeGame()
		return true
	end

	return false
end

function Orbwalking2:RegisterNonKillableMinionCallback(f)
    table.insert(self.NonKillableMinionCallbacks, f)
end

function Orbwalking2:FireNonKillableMinion(target)
	local args = { ["Target"] = target }
	for i, cb in ipairs(self.NonKillableMinionCallbacks) do
        cb(target)
	end
	return args
end

function Orbwalking2:RegisterPostAttackCallback(f)
    table.insert(self.PostAttackCallbacks, f)
end

function Orbwalking2:FirePostAttack(target)
	local postAttackargs = { ["Target"] = target }
	for i, cb in ipairs(self.PostAttackCallbacks) do
        cb(target)
	end
	return postAttackargs
end

function Orbwalking2:CanAttack(mode)
	if mode == nil then
		return false
	end

	if not self.AttackingEnabled then --mode.AttackingEnabled
		return false
	end

	if myHero.HasBuffType(BuffType.Polymorph) then
		return false
	end

	if myHero.HasBuffType(BuffType.Blind) and not self.noWasteAttackChamps[myHero.CharName] then
		return false
	end

	if myHero.CharName == "Jhin"and myHero.HasBuff("JhinPassiveReload") then
		return false
	end

	if myHero.CharName == "Graves" and not myHero.HasBuff("GravesBasicAttackAmmo1") then
		return false
	end

	if self.NoCancelChamps[myHero.CharName] then
		if myHero.CharName == "Kalista" then -- this.Config["Misc"]["KalistaFly"].Enabled)
			return true
		end
	end

	if self:IsWindingUp() then
		return false
	end

	return GetTimeGame() + GetLatency() / 2000 - self.ServerAttackDetectionTick >= self:AttackCoolDownTime()

end

function Orbwalking2:CanMove(mode)
	if mode == nil then
		return false
	end

	if not self.MovingEnabled then -- !mode.MovingEnabled
		return false
	end

	if GetDistance(self:GetCursorPos()) < self.HoldPositionRadius then
		return false
	end

	if self.NoCancelChamps[myHero.CharName] then
		return true
	end

	if self:IsWindingUp() then
		return false
	end

	return true
end

function Orbwalking2:ForceTarget(unit)
	self.ForcedTarget = unit
end

function Orbwalking2:GetActiveMode()
	if #self.OrbwalkerModes then
		for k,v in pairs(self.OrbwalkerModes) do
			return v
		end
	end
end

function Orbwalking2:FindTarget(mode)
	if self.ForcedTarget ~= nil and self:IsValidAutoRange(self.ForcedTarget) then
		return self.ForcedTarget
	end

	if mode == self.OrbwalkingMode.None then
		return nil
	end

	if mode == self.OrbwalkingMode.Combo then
		return self:GetHeroTarget()
	end

	if mode == self.OrbwalkingMode.Laneclear then
		return self:GetLaneClearTarget()
	end

	if mode == self.OrbwalkingMode.Lasthit then
		return self:GetLastHitTarget()
	end

	return nil
end


function Orbwalking2:GetOrbwalkingTarget()
	return self.LastTarget
end

function Orbwalking2:IsReset(missileName)
	if self.attackResets[missileName] then
		return true
	end
	return false
end

function Orbwalking2:Move(movePosition)
	MoveToPos(movePosition.x, movePosition.z) --core
end

function Orbwalking2:IsValidAutoRange(target)
	return GetDistance(target) < GetTrueAttackRange() --core
end

function Orbwalking2:GetCursorPos()
	return { x = GetMousePosX(), y = GetMousePosY(), z = GetMousePosZ() } -- core
end

function Orbwalking2:Orbwalk()
	local mode = self:GetActiveMode()

	if mode == nil then
		return
	end

	if self.ForcedTarget ~= nil and not self:IsValidAutoRange(self.ForcedTarget) then
		self.ForcedTarget = nil
	end

	if self:CanAttack(mode) then
		self.LastTarget = self:FindTarget(mode)
		local target = self.LastTarget
		if target ~= nil then
			self:Attack(target)
		end
	end

	if self:CanMove(mode) then
		self:Move(self:GetCursorPos())
	end

end

function Orbwalking2:ResetAutoAttackTimer()
	self.ServerAttackDetectionTick = 0
	self.LastAttackCommandSentTime = 0
end

function Orbwalking2:OnTick()
	if myHero.IsDead or IsTyping() or IsDodging() then return end

	self:Orbwalk()
end

function Orbwalking2:OnProcessAutoAttack(unit, spell)
	if spell.TargetId ~= nil then
		self.ServerAttackDetectionTick = GetTimeGame() - GetLatency() / 2000
		self.LastTarget = GetTargetById(spell.TargetId)
		self.ForcedTarget = nil
		DelayAction(function(t) self:FirePostAttack(t) end, 0, {self.LastTarget})
	end
end

function Orbwalking2:OnProcessSpell(unit, spell)
	if unit.IsMe then
		local name = string.lower(spell.Name)
		if self.specialAttacks[name] or string.find(name, "attack") ~= nil then
			self:OnProcessAutoAttack(unit, spell)
		end

		if self:IsReset(name) then
			self:ResetAutoAttackTimer()
		end

		--Prediction
		if string.find(name, "attack") ~= nil then
			self:Pred_OnProcessAutoAttack(unit, spell)
		end
	end
end
-----------------------------------------------------------------------Prediction--------------------------------------------------------------------------------

function Orbwalking2:GetAutoAttackDamage(source, target, spell, additionalDamage)
    local source = GetUnit(source)
    local target = GetUnit(target)
    -- read initial armor and damage values
    local armorPenPercent = 1 --source.armorPenPercent
    local armorPen = 0 --source.ArmorPen
    local totalDamage = source.TotalDmg + (additionalDamage or 0)
    local damageMultiplier = spell.Name:find("CritAttack") and 2 or 1

	--if true then return totalDamage end

    -- minions give wrong values for armorPen and armorPenPercent
    if source.Type == 1 then
        armorPenPercent = 1
    elseif source.Type == 2 then
        armorPenPercent = 0.7
    end

    -- turrets ignore armor penetration and critical attacks
    if target.Type == 2 then
        armorPenPercent = 1
        armorPen = 0
        damageMultiplier = 1
    end

    -- calculate initial damage multiplier for negative and positive armor

    local targetArmor = (target.Armor * armorPenPercent) - armorPen
    if targetArmor < 0 then -- minions can't go below 0 armor.
        --damageMultiplier = (2 - 100 / (100 - targetArmor)) * damageMultiplier
        damageMultiplier = 1 * damageMultiplier
    else
        damageMultiplier = 100 / (100 + targetArmor) * damageMultiplier
    end

    -- use ability power or ad based damage on turrets
    if source.Type == myHero.Type and target.Type == 2 then
        totalDamage = math.max(source.TotalDmg, source.TotalDmg + 0.4 * source.MagicDmg)
    end

    -- minions deal less damage to enemy heros
    if source.Type == 1 and target.Type == myHero.Type and source.TeamId ~= 300 then
        damageMultiplier = 0.60 * damageMultiplier
    end

    -- heros deal less damage to turrets
    if source.Type == myHero.Type and target.Type == 2 then
        damageMultiplier = 0.95 * damageMultiplier
    end

    -- minions deal less damage to turrets
    if source.Type == 1 and target.Type == 2 then
        damageMultiplier = 0.475 * damageMultiplier
    end

    -- siege minions and superminions take less damage from turrets
    if source.Type == 2 and (target.CharName == "Red_Minion_MechCannon" or target.CharName == "Blue_Minion_MechCannon") then
        damageMultiplier = 0.8 * damageMultiplier
    end

    -- caster minions and basic minions take more damage from turrets
    if source.Type == 2 and (target.CharName == "Red_Minion_Wizard" or target.CharName == "Blue_Minion_Wizard" or target.CharName == "Red_Minion_Basic" or target.CharName == "Blue_Minion_Basic") then
        damageMultiplier = (1 / 0.875) * damageMultiplier
    end

    -- turrets deal more damage to all units by default
    if source.Type == 2 then
        damageMultiplier = 1.05 * damageMultiplier
    end

    -- calculate damage dealt
    return damageMultiplier * totalDamage
end

function Orbwalking2:Pred_OnProcessAutoAttack(unit, spell)
	unit = GetUnit(unit.Addr)
	--Ignore auto attacks happening too far away
	if unit == nil or GetDistance(unit) > 4000 or not unit.IsMelee or unit.Type == 0 then
		return
	end

	--Only process for minion targets
	if spell.TargetId == nil or spell.TargetId == 0 then
		return
	end
	local targetM = GetUnit(spell.TargetId)
	if targetM.Type ~= 1 then
		return
	end

	if unit.IsMelee then
		local sender = GetUnit(GetTargetById(spell.OwnerId))
		local target = GetUnit(GetTargetById(spell.TargetId))

		if sender == 0 or target == 0 then return end

		local Sender = GetTargetById(spell.OwnerId)
		local Target = GetTargetById(spell.TargetId)

		local StartPosition = {x=unit.SourcePos_x,y=unit.SourcePos_y,z=unit.SourcePos_z}
		local EndPosition = {x=unit.DestPos_x,y=unit.DestPos_y,z=unit.DestPos_z}

		local TimeToLand = GetDistance(StartPosition,EndPosition) / spell.MissileSpeed

		local attack = {
			AttackStatus = "Detected",
			DetectTime = GetTimeGame() - GetLatency() / 2000,
			Sender = sender,
			Target = target,
			SNetworkId = sender.NetworkId,
			NetworkId = target.NetworkId,
			Damage = self:GetAutoAttackDamage(Sender, Target, {Name="attack"}, 0),
			StartPosition = StartPosition,
			AnimationDelay = sender.Windup,
			Type = "Melee",
			TimeToLand = TimeToLand,
		}
		self:AddAttack(attack)
	end
end

function Orbwalking2:OnCreateObject(unit)
	if unit and unit.Type == 6 then --missile
		unit = GetMissile(unit.Addr)
		local sender = GetUnit(GetTargetById(unit.OwnerId))
		local target = GetUnit(GetTargetById(unit.TargetId))

		if sender == 0 or target == 0 then return end

		local Sender = GetTargetById(unit.OwnerId)
		local Target = GetTargetById(unit.TargetId)

		local StartPosition = {x=unit.SrcPos_x,y=unit.SrcPos_y,z=unit.SrcPos_z}
		local EndPosition = {x=unit.DestPos_x,y=unit.DestPos_y,z=unit.DestPos_z}

		local TimeToLand = GetDistance(StartPosition,EndPosition) / unit.MissileSpeed

		local attack = {
			AttackStatus = "Detected",
			DetectTime = GetTimeGame() - GetLatency() / 2000,
			Sender = sender,
			Target = target,
			SNetworkId = sender.NetworkId,
			NetworkId = target.NetworkId,
			Damage = self:GetAutoAttackDamage(Sender, Target, {Name="attack"}, 0),
			StartPosition = StartPosition,
			AnimationDelay = sender.Windup,
			Type = "Ranged",
			TimeToLand = TimeToLand,
		}
		self:AddAttack(attack)
	end
end

function Orbwalking2:OnUpdate()
	if GetTimeGame() - self.LastCleanUp <= 1 then
		return
	end

	for k, v in pairs(self.Attacks) do
		for i, attack in pairs(self.Attacks[k]) do
			if not attack.Sender.IsValid or attack.Sender.IsDead or not attack.Target.IsValid or attack.Target.IsDead then
			    self.Attacks[k][i].AttackStatus = "Completed"
            end

			--Remove All
			if GetTimeGame() - attack.DetectTime > 5 then
				self:RemoveAttack(attack)
			end
		end
	end

	self.LastCleanUp = GetTimeGame()
end

function Orbwalking2:OnDeleteObject(unit)
	if unit and unit.Type == 6 then --missile
		local target = GetUnit(GetTargetById(unit.TargetId))
		local attacks = self.Attacks[unit.NetworkId]
		local minDetectTime = 0
		local attack = nil
		if attacks then
			for i, a in pairs(attacks) do
				if a.Target.NetworkId == target.NetworkId and a.AttackStatus ~= "Completed" and a.Type == "Ranged" then
					if minDetectTime == 0 then
						minDetectTime = a.DetectTime
						attack = a
					end

					if minDetectTime > a.DetectTime then
						minDetectTime = a.DetectTime
						attack = a
					end
				end
			end
		end

		if attack ~= nil then
			for i, a in pairs(self.Attacks[attack.Sender.NetworkId]) do
				if a.Target.NetworkId == attack.Target.NetworkId then
					self.Attacks[attack.Sender.NetworkId][i].AttackStatus = "Completed"
				end
			end
		end
	end
end

function Orbwalking2:AddAttack(attack)
	local k = attack.Sender.NetworkId
	if not self.Attacks[k] then
		self.Attacks[k] = {}
	end

	for i, a in pairs(self.Attacks[k]) do
		if a.Type == "Melee" then
			self.Attacks[k][i].AttackStatus = "Completed"
		end
	end

	table.insert(self.Attacks[k], attack)
end

function Orbwalking2:RemoveAttack(attack)
	local k = attack.Sender.NetworkId
	local id = 0
	for i, a in pairs(self.Attacks[k]) do
		if a.Target.NetworkId == attack.Target.NetworkId then
			id = i
		end
	end
	if id > 0 then
		table.remove(self.Attacks[k], id)
	end
end

function Orbwalking2:GetAttack(unitId)
	return self.Attacks[unitId]
end

function Orbwalking2:AutoAttack_LandTime(attack)
	if attack.Type == "Ranged" then
		return GetTimeGame() + attack.TimeToLand
	end
	if attack.Type == "Melee" then
		return attack.DetectTime + attack.Sender.Windup + self.ExtraDelay + 0.1
	end
end

function Orbwalking2:AutoAttack_ETA(attack)
	return self:AutoAttack_LandTime(attack) - GetTimeGame()
end

function Orbwalking2:AutoAttack_IsValid(attack)
	return attack and attack.Sender.IsValid and attack.Target.IsValid
end

function Orbwalking2:AutoAttack_HasReached(attack)
	if attack.Type == "Ranged" then
		if attack == nil or not self:AutoAttack_IsValid(attack) or attack.AttackStatus == "Completed" or self:AutoAttack_ETA(attack) < -0.2 then
			return true
		end
	end

	if attack.Type == "Melee" then
		if attack.AttackStatus == "Completed" or not self:AutoAttack_IsValid(attack) or self:AutoAttack_ETA(attack) < -0.1 then
			return true
		end
	end
	return false
end
-----------------------------------------------------------------------Mode--------------------------------------------------------------------------------

function Orbwalking2:IsValidAttackableObject(unit)

	--Valid check
	if not self:IsValidAutoRange(unit) then
		return false
	end

	if GetType(unit) == 0 or GetType(unit) == 1 or GetType(unit) == 2 or GetType(unit) == 4 or GetType(unit) == 5 then
		return true
	end

	local name = string.lower(GetUnit(unit).CharName)
	if not self.AttackPlants and string.find(name,"sru_plant_") ~= nil then
		return false
	end

	if not self.AttackWards and string.find(name,"ward") ~= nil then
		return false
	end

	if GetType(unit) == 3 then
		return true
	end

--~ 	J4 flag
	if string.find(GetUnit(unit).CharName,"Beacon") ~= nil then
		return false
	end

	if string.find(name,"zyraseed") ~= nil then
		return false
	end

	if string.find(name,"gangplankbarrel") ~= nil then
		if not self.AttackBarrels then
			return false
		end

		--dont attack ally barrels
		if IsAlly(unit) then
			return false
		end
	end

	--[[
	var mBase = unit as Obj_AI_Base;

	if (mBase == null || !mBase.IsFloatingHealthBarActive)
	{
		return false;
	}

]]

	return true
end

function Orbwalking2:GetNearestTurret()
	GetAllUnitAroundAnObject(myHero.Addr, 4000)
    local nearestTurret = nil
	local dist = 0

    for i, unit in pairs(pUnit) do
        if unit ~= 0  then
            turret = GetUnit(unit)
            if not turret.IsEnemy and not turret.IsDead and turret.IsVisible and turret.Type == 2 then
				if dist == 0 then
					dist = GetDistance(turret)
					nearestTurret = turret.Addr
				else
					if GetDistance(turret) < dist then
						dist = GetDistance(turret)
						nearestTurret = turret
					end
				end
            end
        end
    end
    return nearestTurret
end

function Orbwalking2:UnderTurretMode()
	local nearestTurret = self:GetNearestTurret()
	if nearestTurret ~= nil and GetDistance(nearestTurret) + myHero.AARange * 1.1 < 950 then
		return true
	end
	return false
end

function Orbwalking2:GetBasicAttackMissileSpeed(hero)
	if hero.IsMelee then
		return math.huge
	end

	if hero.CharName == "Azir" or hero.CharName == "Velkoz" or hero.CharName == "Thresh" or hero.CharName == "Rakan" then
		return math.huge
	end

	if hero.CharName == "Kayle" then
		if hero.HasBuff("JudicatorRighteousFury") then
			return math.huge
		end
	end

	if hero.CharName == "Viktor" then
		if hero.HasBuff("ViktorPowerTransferReturn") then
			return math.huge
		end
	end

	return self.projectilespeeds[hero.CharName]
end

-- ReSharper disable once SuggestBaseTypeForParameter
function Orbwalking2:TimeForAutoToReachTarget(minion)
	local dist = GetDistance(minion)
	local attackTravelTime = dist / self:GetBasicAttackMissileSpeed(myHero)
	local totalTime = self.AnimationTime + attackTravelTime + GetLatency() / 2000
	return totalTime
end

function Orbwalking2:GetPrediction(target, time)
	local predictedDamage = 0

	for k, v in pairs(self.Attacks) do
		for i, attack in pairs(self.Attacks[k]) do

			local check1 = self:AutoAttack_HasReached(attack) or not self:AutoAttack_IsValid(attack)
			local check2 = attack.Target.NetworkId ~= target.NetworkId or GetTimeGame() - attack.DetectTime > 3
			if not check1 and not check2 then
				mlt = GetTimeGame() + time
				alt = GetTimeGame() + self:AutoAttack_ETA(attack)

				if mlt - alt > 0.1 + self.ExtraDelay then
					predictedDamage = predictedDamage + attack.Damage
				end
			end
		end
	end

	local health = target.HP - predictedDamage
	return health
end

function Orbwalking2:GetLaneClearHealthPrediction(target, time)
	local predictedDamage = 0
	local rTime = time

	for k, v in pairs(self.Attacks) do
		for i, attack in pairs(self.Attacks[k]) do
			local check2 = attack.Target.NetworkId ~= target.NetworkId or GetTimeGame() - attack.DetectTime > rTime
			if not check2 then
				predictedDamage = predictedDamage + attack.Damage
			end
		end
	end

	return target.HP - predictedDamage
end

function Orbwalking2:GetPredictedHealth(minion, time)
	if time == nil then time = 0 end
	local rtime = time == 0 and self:TimeForAutoToReachTarget(minion) or time
	return math.ceil(self:GetPrediction(minion, rtime))
end

function Orbwalking2:CanKillMinion(minion, time)
	if minion.HP + minion.TotalDmg < self:GetRealAutoAttackDamage(minion) then return true end
	if time == nil then time = 0 end
	local rtime = time == 0 and self:TimeForAutoToReachTarget(minion) or time
	local pred = self:GetPredictedHealth(minion, rtime)
	if pred <= 0 then
		self:FireNonKillableMinion(minion)
--~ 		print("FireNonKillableMinion=" .. tostring(pred))
		return false
	end
--~ 	print("++++++++++++++++++++++")
--~ 	print(pred)
--~ 	print(self:GetRealAutoAttackDamage(minion))
--~ 	print("++++++++++++++++++++++")
	return pred <= self:GetRealAutoAttackDamage(minion)
end

function Orbwalking2:GetRealAutoAttackDamage(minion)
--~ 	if minion.IsWard()
--~ 		return 1
--~ 	end
--~ 	print("AD=" .. tostring(math.ceil(myHero.CalcDamage(minion.Addr, myHero.TotalDmg))))
--~ 	print("AD2=" .. tostring(math.ceil(self:GetAutoAttackDamage(myHero.Addr, minion.Addr, {Name="attack"}, 0))))
--~ 	return math.ceil(myHero.CalcDamage(minion.Addr, myHero.TotalDmg))
	return self:GetAutoAttackDamage(myHero.Addr, minion.Addr, {Name="attack"}, 0)
end

function Orbwalking2:ShouldWaitMinion(minion)
	local time = self:TimeForAutoToReachTarget(minion) + myHero.CDBA - 0.07 --+ 0.1
	local pred = self:GetLaneClearHealthPrediction(minion, (time * 2))
	if pred < self:GetRealAutoAttackDamage(minion) then
--~ 		print("ShouldWaitMinion=" .. tostring(pred))
		return true
	end

	return false
end

function Orbwalking2:GetHeroTarget()
	if self.TargetSelector == nil then
		self.TargetSelector = TargetSelector(2000, 1, myHero, true, nil, true)
	end
	local target =self.TargetSelector:GetTarget(GetTrueAttackRange())
	if target > 0 then
		local t = GetAIHero(target)
		if t.CharName == "Jax" and t.HasBuff("JaxCounterStrike") then
			return nil
		end
		return target
	end

	return nil
end

function Orbwalking2:GetLastHitTarget(attackable)
	if attackable == nil then
		GetAllUnitAroundAnObject(myHero.Addr, 4000)
		attackable = {}
		for i, unit in pairs(pUnit) do
			if unit ~= 0  then
				m = GetUnit(unit)
				if m.IsEnemy and not m.IsDead and m.IsVisible and m.Type == 1 and self:IsValidAttackableObject(m) then
					table.insert(attackable, m)
				end
			end
		end
	end

	local availableMinionTargets = {}

	for i, m in pairs(attackable) do
		if self:CanKillMinion(m) then
			table.insert(availableMinionTargets, m)
		end
	end

	table.sort(availableMinionTargets, function(a,b)
			if a.MaxHP>b.MaxHP then return true end
			if a.HP>b.HP then return true end
	end)

	for i, m in pairs(availableMinionTargets) do
		local bestMinionTarget = m
		return bestMinionTarget.Addr -- FirstOrDefault
	end
end

--Gets a structure target based on the following order (Nexus, Turret, Inihibitor)
function Orbwalking2:GetStructureTarget(attackable)
	--Nexus
	local nexus = {}
	for i, m in pairs(attackable) do
		if m.IsEnemy and not m.IsDead and m.IsVisible and m.Type == 5 and self:IsValidAttackableObject(m) then
			table.insert(nexus, m)
		end
	end

	table.sort(nexus, function(a,b) return GetDistance(a)<GetDistance(b) end)

	for i, m in pairs(nexus) do
		if m ~= nil and self:IsValidAutoRange(m) then
			return m --Min Distance
		end
	end

	--Turret
	local turret = {}
	for i, m in pairs(attackable) do
		if m.IsEnemy and not m.IsDead and m.IsVisible and m.Type == 2 and self:IsValidAttackableObject(m) then
			table.insert(turret, m)
		end
	end

	table.sort(turret, function(a,b) return GetDistance(a)<GetDistance(b) end)

	for i, m in pairs(turret) do
		if m ~= nil and self:IsValidAutoRange(m) then
			return m --Min Distance
		end
	end

	--Inhib
	local inhib = {}
	for i, m in pairs(attackable) do
		if m.IsEnemy and not m.IsDead and m.IsVisible and m.Type == 4 and self:IsValidAttackableObject(m) then
			table.insert(inhib, m)
		end
	end

	table.sort(inhib, function(a,b) return GetDistance(a)<GetDistance(b) end)

	for i, m in pairs(inhib) do
		if m ~= nil and self:IsValidAutoRange(m) then
			return m --Min Distance
		end
	end

	return nil
end

function Orbwalking2:GetLaneClearTarget()
--~ 	print("-----------------------------------------------------------")
	if self:UnderTurretMode() then
		--Temporarily...
--~ 		print("UnderTurretMode")
		return self:GetLastHitTarget()
	end

	--list all minions sort by Max Health
	GetAllUnitAroundAnObject(myHero.Addr, 4000)
    local minions = {}
	local attackableUnits = {}

    for i, unit in pairs(pUnit) do
        if unit ~= 0  then
            m = GetUnit(unit)
            if m.IsEnemy and not m.IsDead and m.IsVisible and m.Type == 1 and self:IsValidAttackableObject(m) and m.CanSelect then
                table.insert(minions, m)
            end
            if not m.IsDead and m.IsVisible and self:IsValidAttackableObject(m) and m.CanSelect then
                table.insert(attackableUnits, m)
            end
        end
    end

	table.sort(minions, function(a,b) return a.MaxHP>b.MaxHP end)

	local killableMinion = {}
	for i, m in pairs(minions) do
		if self:CanKillMinion(m) then
			table.insert(killableMinion, m)
		end
	end

	if #killableMinion > 0 then
		table.sort(killableMinion, function(a,b)
			if a ~= nil and b ~= nil and a.MaxHP>b.MaxHP then return true end
			if a ~= nil and b ~= nil and a.HP>b.HP then return true end
		end)
	end

	if #killableMinion then
		for i, m in pairs(killableMinion) do
			--print("killableMinion")
			return m.Addr
		end
	end

	-- check again
	local waitableMinion = false
	for i, m in pairs(minions) do
		if not waitableMinion and self:ShouldWaitMinion(m) then
--~ 			print("waitableMinion=" .. tostring(m.HP))
			waitableMinion = true
		end
	end

	local allyMinion = {}
	for i, m in pairs(attackableUnits) do
		if not m.IsEnemy and m.Type == 1 then
			table.insert(allyMinion, m)
		end
	end

	if waitableMinion then
--~ 		print("waitableMinion")
--~ 		self:Move(self:GetCursorPos())
		if #allyMinion == 0 or myHero.Level > 14 then --don't wait
			table.sort(minions, function(a,b) return a.HP>b.HP end)
			for i, m in pairs(minions) do
				--print("minions2 first")
				return m.Addr --FirstOrDefault
			end
		end
		return nil
	end

	local structure = self:GetStructureTarget(attackableUnits)
	if structure ~= nil then
--~ 		print("structure")
		return structure.Addr
	end

	if self.LastTarget ~= nil and self:IsValidAutoRange(self.LastTarget) then
		local LastTarget = GetUnit(self.LastTarget)
		local predHealth = self:GetPredictedHealth(LastTarget)
		if math.abs(LastTarget.HP - predHealth) < 0 then
--~ 			print("LastTarget")
			return self.LastTarget
		end
	end

	for i, m in pairs(minions) do
		predHealth = self:GetPredictedHealth(m)

		--taking damage
		if m.HP - predHealth <= 0 and m.IsRanged then
			return m.Addr
		end
	end

	--attack minion full HP
	for i, m in pairs(minions) do
		--local predHealth = self:GetPredictedHealth(m)
		if m.HP == m.MaxHP then
			return m.Addr
		end
	end

	if #allyMinion == 0 then
		table.sort(minions, function(a,b) return a.HP>b.HP end)
		for i, m in pairs(minions) do
			--print("minions2 first")
			return m.Addr --FirstOrDefault
		end
	end

	local jungle = {}
	for i, m in pairs(attackableUnits) do
		if m.Type == 3 then
			table.insert(jungle, m)
		end
	end

	table.sort(jungle, function(a,b) return a.MaxHP<b.MaxHP end)
	for i, m in pairs(jungle) do
--~ 		print("jungle first")
		return m.Addr
	end

	local hero = self:GetHeroTarget()
	if (hero ~= nil) then
		return hero
	end

	return nil
end


