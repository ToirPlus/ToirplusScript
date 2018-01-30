IncludeFile("Lib\\TOIR_SDK.lua")

Orbwalking = class()

--function OnLoad()
    --Orbwalking:__init()
--end

function Orbwalking:__init()
    --Orbwalking:LoadToMenu()
    self.projectilespeeds = {["Velkoz"]= 2000,["TeemoMushroom"] = math.huge,["TestCubeRender"] = math.huge ,["Xerath"] = 2000.0000 ,["Kassadin"] = math.huge ,["Rengar"] = math.huge ,["Thresh"] = 1000.0000 ,["Ziggs"] = 1500.0000 ,["ZyraPassive"] = 1500.0000 ,["ZyraThornPlant"] = 1500.0000 ,["KogMaw"] = 1800.0000 ,["HeimerTBlue"] = 1599.3999 ,["EliseSpider"] = 500.0000 ,["Skarner"] = 500.0000 ,["ChaosNexus"] = 500.0000 ,["Katarina"] = 467.0000 ,["Riven"] = 347.79999 ,["SightWard"] = 347.79999 ,["HeimerTYellow"] = 1599.3999 ,["Ashe"] = 2500.0000 ,["VisionWard"] = 2000.0000 ,["TT_NGolem2"] = math.huge ,["ThreshLantern"] = math.huge ,["TT_Spiderboss"] = math.huge ,["OrderNexus"] = math.huge ,["Soraka"] = 1000.0000 ,["Jinx"] = 2750.0000 ,["TestCubeRenderwCollision"] = 2750.0000 ,["Red_Minion_Wizard"] = 650.0000 ,["JarvanIV"] = 20.0000 ,["Blue_Minion_Wizard"] = 650.0000 ,["TT_ChaosTurret2"] = 1200.0000 ,["TT_ChaosTurret3"] = 1200.0000 ,["TT_ChaosTurret1"] = 1200.0000 ,["ChaosTurretGiant"] = 1200.0000 ,["Dragon"] = 1200.0000 ,["LuluSnowman"] = 1200.0000 ,["Worm"] = 1200.0000 ,["ChaosTurretWorm"] = 1200.0000 ,["TT_ChaosInhibitor"] = 1200.0000 ,["ChaosTurretNormal"] = 1200.0000 ,["AncientGolem"] = 500.0000 ,["ZyraGraspingPlant"] = 500.0000 ,["HA_AP_OrderTurret3"] = 1200.0000 ,["HA_AP_OrderTurret2"] = 1200.0000 ,["Tryndamere"] = 347.79999 ,["OrderTurretNormal2"] = 1200.0000 ,["Singed"] = 700.0000 ,["OrderInhibitor"] = 700.0000 ,["Diana"] = 347.79999 ,["HA_FB_HealthRelic"] = 347.79999 ,["TT_OrderInhibitor"] = 347.79999 ,["GreatWraith"] = 750.0000 ,["Yasuo"] = 347.79999 ,["OrderTurretDragon"] = 1200.0000 ,["OrderTurretNormal"] = 1200.0000 ,["LizardElder"] = 500.0000 ,["HA_AP_ChaosTurret"] = 1200.0000 ,["Ahri"] = 1750.0000 ,["Lulu"] = 1450.0000 ,["ChaosInhibitor"] = 1450.0000 ,["HA_AP_ChaosTurret3"] = 1200.0000 ,["HA_AP_ChaosTurret2"] = 1200.0000 ,["ChaosTurretWorm2"] = 1200.0000 ,["TT_OrderTurret1"] = 1200.0000 ,["TT_OrderTurret2"] = 1200.0000 ,["TT_OrderTurret3"] = 1200.0000 ,["LuluFaerie"] = 1200.0000 ,["HA_AP_OrderTurret"] = 1200.0000 ,["OrderTurretAngel"] = 1200.0000 ,["YellowTrinketUpgrade"] = 1200.0000 ,["MasterYi"] = math.huge ,["Lissandra"] = 2000.0000 ,["ARAMOrderTurretNexus"] = 1200.0000 ,["Draven"] = 1700.0000 ,["FiddleSticks"] = 1750.0000 ,["SmallGolem"] = math.huge ,["ARAMOrderTurretFront"] = 1200.0000 ,["ChaosTurretTutorial"] = 1200.0000 ,["NasusUlt"] = 1200.0000 ,["Maokai"] = math.huge ,["Wraith"] = 750.0000 ,["Wolf"] = math.huge ,["Sivir"] = 1750.0000 ,["Corki"] = 2000.0000 ,["Janna"] = 1200.0000 ,["Nasus"] = math.huge ,["Golem"] = math.huge ,["ARAMChaosTurretFront"] = 1200.0000 ,["ARAMOrderTurretInhib"] = 1200.0000 ,["LeeSin"] = math.huge ,["HA_AP_ChaosTurretTutorial"] = 1200.0000 ,["GiantWolf"] = math.huge ,["HA_AP_OrderTurretTutorial"] = 1200.0000 ,["YoungLizard"] = 750.0000 ,["Jax"] = 400.0000 ,["LesserWraith"] = math.huge ,["Blitzcrank"] = math.huge ,["ARAMChaosTurretInhib"] = 1200.0000 ,["Shen"] = 400.0000 ,["Nocturne"] = math.huge ,["Sona"] = 1500.0000 ,["ARAMChaosTurretNexus"] = 1200.0000 ,["YellowTrinket"] = 1200.0000 ,["OrderTurretTutorial"] = 1200.0000 ,["Caitlyn"] = 2500.0000 ,["Trundle"] = 347.79999 ,["Malphite"] = 1000.0000 ,["Mordekaiser"] = math.huge ,["ZyraSeed"] = math.huge ,["Vi"] = 1000.0000 ,["Tutorial_Red_Minion_Wizard"] = 650.0000 ,["Renekton"] = math.huge ,["Anivia"] = 1400.0000 ,["Fizz"] = math.huge ,["Heimerdinger"] = 1500.0000 ,["Evelynn"] = 467.0000 ,["Rumble"] = 347.79999 ,["Leblanc"] = 1700.0000 ,["Darius"] = math.huge ,["OlafAxe"] = math.huge ,["Viktor"] = 2300.0000 ,["XinZhao"] = 20.0000 ,["Orianna"] = 1450.0000 ,["Vladimir"] = 1400.0000 ,["Nidalee"] = 1750.0000 ,["Tutorial_Red_Minion_Basic"] = math.huge ,["ZedShadow"] = 467.0000 ,["Syndra"] = 1800.0000 ,["Zac"] = 1000.0000 ,["Olaf"] = 347.79999 ,["Veigar"] = 1100.0000 ,["Twitch"] = 2500.0000 ,["Alistar"] = math.huge ,["Akali"] = 467.0000 ,["Urgot"] = 1300.0000 ,["Leona"] = 347.79999 ,["Talon"] = math.huge ,["Karma"] = 1500.0000 ,["Jayce"] = 347.79999 ,["Galio"] = 1000.0000 ,["Shaco"] = math.huge ,["Taric"] = math.huge ,["TwistedFate"] = 1500.0000 ,["Varus"] = 2000.0000 ,["Garen"] = 347.79999 ,["Swain"] = 1600.0000 ,["Vayne"] = 2000.0000 ,["Fiora"] = 467.0000 ,["Quinn"] = 2000.0000 ,["Kayle"] = math.huge ,["Blue_Minion_Basic"] = math.huge ,["Brand"] = 2000.0000 ,["Teemo"] = 1300.0000 ,["Amumu"] = 500.0000 ,["Annie"] = 1200.0000 ,["Odin_Blue_Minion_caster"] = 1200.0000 ,["Elise"] = 1600.0000 ,["Nami"] = 1500.0000 ,["Poppy"] = 500.0000 ,["AniviaEgg"] = 500.0000 ,["Tristana"] = 2250.0000 ,["Graves"] = 3000.0000 ,["Morgana"] = 1600.0000 ,["Gragas"] = math.huge ,["MissFortune"] = 2000.0000 ,["Warwick"] = math.huge ,["Cassiopeia"] = 1200.0000 ,["Tutorial_Blue_Minion_Wizard"] = 650.0000 ,["DrMundo"] = math.huge ,["Volibear"] = 467.0000 ,["Irelia"] = 467.0000 ,["Odin_Red_Minion_Caster"] = 650.0000 ,["Lucian"] = 2800.0000 ,["Yorick"] = math.huge ,["RammusPB"] = math.huge ,["Red_Minion_Basic"] = math.huge ,["Udyr"] = 467.0000 ,["MonkeyKing"] = 20.0000 ,["Tutorial_Blue_Minion_Basic"] = math.huge ,["Kennen"] = 1600.0000 ,["Nunu"] = 500.0000 ,["Ryze"] = 2400.0000 ,["Zed"] = 467.0000 ,["Nautilus"] = 1000.0000 ,["Gangplank"] = 1000.0000 ,["Lux"] = 1600.0000 ,["Sejuani"] = 500.0000 ,["Ezreal"] = 2000.0000 ,["OdinNeutralGuardian"] = 1800.0000 ,["Khazix"] = 500.0000 ,["Sion"] = math.huge ,["Aatrox"] = 347.79999 ,["Hecarim"] = 500.0000 ,["Pantheon"] = 20.0000 ,["Shyvana"] = 467.0000 ,["Zyra"] = 1700.0000 ,["Karthus"] = 1200.0000 ,["Rammus"] = math.huge ,["Zilean"] = 1200.0000 ,["Chogath"] = 500.0000 ,["Malzahar"] = 2000.0000 ,["YorickRavenousGhoul"] = 347.79999 ,["YorickSpectralGhoul"] = 347.79999 ,["JinxMine"] = 347.79999 ,["YorickDecayedGhoul"] = 347.79999 ,["XerathArcaneBarrageLauncher"] = 347.79999 ,["Odin_SOG_Order_Crystal"] = 347.79999 ,["TestCube"] = 347.79999 ,["ShyvanaDragon"] = math.huge ,["FizzBait"] = math.huge ,["Blue_Minion_MechMelee"] = math.huge ,["OdinQuestBuff"] = math.huge ,["TT_Buffplat_L"] = math.huge ,["TT_Buffplat_R"] = math.huge ,["KogMawDead"] = math.huge ,["TempMovableChar"] = math.huge ,["Lizard"] = 500.0000 ,["GolemOdin"] = math.huge ,["OdinOpeningBarrier"] = math.huge ,["TT_ChaosTurret4"] = 500.0000 ,["TT_Flytrap_A"] = 500.0000 ,["TT_NWolf"] = math.huge ,["OdinShieldRelic"] = math.huge ,["LuluSquill"] = math.huge ,["redDragon"] = math.huge ,["MonkeyKingClone"] = math.huge ,["Odin_skeleton"] = math.huge ,["OdinChaosTurretShrine"] = 500.0000 ,["Cassiopeia_Death"] = 500.0000 ,["OdinCenterRelic"] = 500.0000 ,["OdinRedSuperminion"] = math.huge ,["JarvanIVWall"] = math.huge ,["ARAMOrderNexus"] = math.huge ,["Red_Minion_MechCannon"] = 1200.0000 ,["OdinBlueSuperminion"] = math.huge ,["SyndraOrbs"] = math.huge ,["LuluKitty"] = math.huge ,["SwainNoBird"] = math.huge ,["LuluLadybug"] = math.huge ,["CaitlynTrap"] = math.huge ,["TT_Shroom_A"] = math.huge ,["ARAMChaosTurretShrine"] = 500.0000 ,["Odin_Windmill_Propellers"] = 500.0000 ,["TT_NWolf2"] = math.huge ,["OdinMinionGraveyardPortal"] = math.huge ,["SwainBeam"] = math.huge ,["Summoner_Rider_Order"] = math.huge ,["TT_Relic"] = math.huge ,["odin_lifts_crystal"] = math.huge ,["OdinOrderTurretShrine"] = 500.0000 ,["SpellBook1"] = 500.0000 ,["Blue_Minion_MechCannon"] = 1200.0000 ,["TT_ChaosInhibitor_D"] = 1200.0000 ,["Odin_SoG_Chaos"] = 1200.0000 ,["TrundleWall"] = 1200.0000 ,["HA_AP_HealthRelic"] = 1200.0000 ,["OrderTurretShrine"] = 500.0000 ,["OriannaBall"] = 500.0000 ,["ChaosTurretShrine"] = 500.0000 ,["LuluCupcake"] = 500.0000 ,["HA_AP_ChaosTurretShrine"] = 500.0000 ,["TT_NWraith2"] = 750.0000 ,["TT_Tree_A"] = 750.0000 ,["SummonerBeacon"] = 750.0000 ,["Odin_Drill"] = 750.0000 ,["TT_NGolem"] = math.huge ,["AramSpeedShrine"] = math.huge ,["OriannaNoBall"] = math.huge ,["Odin_Minecart"] = math.huge ,["Summoner_Rider_Chaos"] = math.huge ,["OdinSpeedShrine"] = math.huge ,["TT_SpeedShrine"] = math.huge ,["odin_lifts_buckets"] = math.huge ,["OdinRockSaw"] = math.huge ,["OdinMinionSpawnPortal"] = math.huge ,["SyndraSphere"] = math.huge ,["Red_Minion_MechMelee"] = math.huge ,["SwainRaven"] = math.huge ,["crystal_platform"] = math.huge ,["MaokaiSproutling"] = math.huge ,["Urf"] = math.huge ,["TestCubeRender10Vision"] = math.huge ,["MalzaharVoidling"] = 500.0000 ,["GhostWard"] = 500.0000 ,["MonkeyKingFlying"] = 500.0000 ,["LuluPig"] = 500.0000 ,["AniviaIceBlock"] = 500.0000 ,["TT_OrderInhibitor_D"] = 500.0000 ,["Odin_SoG_Order"] = 500.0000 ,["RammusDBC"] = 500.0000 ,["FizzShark"] = 500.0000 ,["LuluDragon"] = 500.0000 ,["OdinTestCubeRender"] = 500.0000 ,["TT_Tree1"] = 500.0000 ,["ARAMOrderTurretShrine"] = 500.0000 ,["Odin_Windmill_Gears"] = 500.0000 ,["ARAMChaosNexus"] = 500.0000 ,["TT_NWraith"] = 750.0000 ,["TT_OrderTurret4"] = 500.0000 ,["Odin_SOG_Chaos_Crystal"] = 500.0000 ,["OdinQuestIndicator"] = 500.0000 ,["JarvanIVStandard"] = 500.0000 ,["TT_DummyPusher"] = 500.0000 ,["OdinClaw"] = 500.0000 ,["EliseSpiderling"] = 2000.0000 ,["QuinnValor"] = math.huge ,["UdyrTigerUlt"] = math.huge ,["UdyrTurtleUlt"] = math.huge ,["UdyrUlt"] = math.huge ,["UdyrPhoenixUlt"] = math.huge ,["ShacoBox"] = 1500.0000 ,["HA_AP_Poro"] = 1500.0000 ,["AnnieTibbers"] = math.huge ,["UdyrPhoenix"] = math.huge ,["UdyrTurtle"] = math.huge ,["UdyrTiger"] = math.huge ,["HA_AP_OrderShrineTurret"] = 500.0000 ,["HA_AP_Chains_Long"] = 500.0000 ,["HA_AP_BridgeLaneStatue"] = 500.0000 ,["HA_AP_ChaosTurretRubble"] = 500.0000 ,["HA_AP_PoroSpawner"] = 500.0000 ,["HA_AP_Cutaway"] = 500.0000 ,["HA_AP_Chains"] = 500.0000 ,["ChaosInhibitor_D"] = 500.0000 ,["ZacRebirthBloblet"] = 500.0000 ,["OrderInhibitor_D"] = 500.0000 ,["Nidalee_Spear"] = 500.0000 ,["Nidalee_Cougar"] = 500.0000 ,["TT_Buffplat_Chain"] = 500.0000 ,["WriggleLantern"] = 500.0000 ,["TwistedLizardElder"] = 500.0000 ,["RabidWolf"] = math.huge ,["HeimerTGreen"] = 1599.3999 ,["HeimerTRed"] = 1599.3999 ,["ViktorFF"] = 1599.3999 ,["TwistedGolem"] = math.huge ,["TwistedSmallWolf"] = math.huge ,["TwistedGiantWolf"] = math.huge ,["TwistedTinyWraith"] = 750.0000 ,["TwistedBlueWraith"] = 750.0000 ,["TwistedYoungLizard"] = 750.0000 ,["Red_Minion_Melee"] = math.huge ,["Blue_Minion_Melee"] = math.huge ,["Blue_Minion_Healer"] = 1000.0000 ,["Ghast"] = 750.0000 ,["blueDragon"] = 800.0000 ,["Red_Minion_MechRange"] = 3000, ["SRU_OrderMinionRanged"] = 650, ["SRU_ChaosMinionRanged"] = 650, ["SRU_OrderMinionSiege"] = 1200, ["SRU_OrderMinionMelee"] = math.huge, ["SRU_ChaosMinionMelee"] = math.huge, ["SRU_ChaosMinionSiege"] = 1200, ["SRUAP_Turret_Chaos1"]  = 1200, ["SRUAP_Turret_Chaos2"]  = 1200, ["SRUAP_Turret_Chaos3"] = 1200, ["SRUAP_Turret_Order1"]  = 1200, ["SRUAP_Turret_Order2"]  = 1200, ["SRUAP_Turret_Order3"] = 1200, ["SRUAP_Turret_Chaos4"] = 1200, ["SRUAP_Turret_Chaos5"] = 500, ["SRUAP_Turret_Order4"] = 1200, ["SRUAP_Turret_Order5"] = 500 }
    self.hitboxes = {['Braum'] = 80, ['RecItemsCLASSIC'] = 65, ['TeemoMushroom'] = 50.0, ['TestCubeRender'] = 65, ['Xerath'] = 65, ['Kassadin'] = 65, ['Rengar'] = 65, ['Thresh'] = 55.0, ['RecItemsTUTORIAL'] = 65, ['Ziggs'] = 55.0, ['ZyraPassive'] = 20.0, ['ZyraThornPlant'] = 20.0, ['KogMaw'] = 65, ['HeimerTBlue'] = 35.0, ['EliseSpider'] = 65, ['Skarner'] = 80.0, ['ChaosNexus'] = 65, ['Katarina'] = 65, ['Riven'] = 65, ['SightWard'] = 1, ['HeimerTYellow'] = 35.0, ['Ashe'] = 65, ['VisionWard'] = 1, ['TT_NGolem2'] = 80.0, ['ThreshLantern'] = 65, ['RecItemsCLASSICMap10'] = 65, ['RecItemsODIN'] = 65, ['TT_Spiderboss'] = 200.0, ['RecItemsARAM'] = 65, ['OrderNexus'] = 65, ['Soraka'] = 65, ['Jinx'] = 65, ['TestCubeRenderwCollision'] = 65, ['Red_Minion_Wizard'] = 48.0, ['JarvanIV'] = 65, ['Blue_Minion_Wizard'] = 48.0, ['TT_ChaosTurret2'] = 88.4, ['TT_ChaosTurret3'] = 88.4, ['TT_ChaosTurret1'] = 88.4, ['ChaosTurretGiant'] = 88.4, ['Dragon'] = 100.0, ['LuluSnowman'] = 50.0, ['Worm'] = 100.0, ['ChaosTurretWorm'] = 88.4, ['TT_ChaosInhibitor'] = 65, ['ChaosTurretNormal'] = 88.4, ['AncientGolem'] = 100.0, ['ZyraGraspingPlant'] = 20.0, ['HA_AP_OrderTurret3'] = 88.4, ['HA_AP_OrderTurret2'] = 88.4, ['Tryndamere'] = 65, ['OrderTurretNormal2'] = 88.4, ['Singed'] = 65, ['OrderInhibitor'] = 65, ['Diana'] = 65, ['HA_FB_HealthRelic'] = 65, ['TT_OrderInhibitor'] = 65, ['GreatWraith'] = 80.0, ['Yasuo'] = 65, ['OrderTurretDragon'] = 88.4, ['OrderTurretNormal'] = 88.4, ['LizardElder'] = 65.0, ['HA_AP_ChaosTurret'] = 88.4, ['Ahri'] = 65, ['Lulu'] = 65, ['ChaosInhibitor'] = 65, ['HA_AP_ChaosTurret3'] = 88.4, ['HA_AP_ChaosTurret2'] = 88.4, ['ChaosTurretWorm2'] = 88.4, ['TT_OrderTurret1'] = 88.4, ['TT_OrderTurret2'] = 88.4, ['TT_OrderTurret3'] = 88.4, ['LuluFaerie'] = 65, ['HA_AP_OrderTurret'] = 88.4, ['OrderTurretAngel'] = 88.4, ['YellowTrinketUpgrade'] = 1, ['MasterYi'] = 65, ['Lissandra'] = 65, ['ARAMOrderTurretNexus'] = 88.4, ['Draven'] = 65, ['FiddleSticks'] = 65, ['SmallGolem'] = 80.0, ['ARAMOrderTurretFront'] = 88.4, ['ChaosTurretTutorial'] = 88.4, ['NasusUlt'] = 80.0, ['Maokai'] = 80.0, ['Wraith'] = 50.0, ['Wolf'] = 50.0, ['Sivir'] = 65, ['Corki'] = 65, ['Janna'] = 65, ['Nasus'] = 80.0, ['Golem'] = 80.0, ['ARAMChaosTurretFront'] = 88.4, ['ARAMOrderTurretInhib'] = 88.4, ['LeeSin'] = 65, ['HA_AP_ChaosTurretTutorial'] = 88.4, ['GiantWolf'] = 65.0, ['HA_AP_OrderTurretTutorial'] = 88.4, ['YoungLizard'] = 50.0, ['Jax'] = 65, ['LesserWraith'] = 50.0, ['Blitzcrank'] = 80.0, ['brush_D_SR'] = 65, ['brush_E_SR'] = 65, ['brush_F_SR'] = 65, ['brush_C_SR'] = 65, ['brush_A_SR'] = 65, ['brush_B_SR'] = 65, ['ARAMChaosTurretInhib'] = 88.4, ['Shen'] = 65, ['Nocturne'] = 65, ['Sona'] = 65, ['ARAMChaosTurretNexus'] = 88.4, ['YellowTrinket'] = 1, ['OrderTurretTutorial'] = 88.4, ['Caitlyn'] = 65, ['Trundle'] = 65, ['Malphite'] = 80.0, ['Mordekaiser'] = 80.0, ['ZyraSeed'] = 65, ['Vi'] = 50, ['Tutorial_Red_Minion_Wizard'] = 48.0, ['Renekton'] = 80.0, ['Anivia'] = 65, ['Fizz'] = 65, ['Heimerdinger'] = 55.0, ['Evelynn'] = 65, ['Rumble'] = 80.0, ['Leblanc'] = 65, ['Darius'] = 80.0, ['OlafAxe'] = 50.0, ['Viktor'] = 65, ['XinZhao'] = 65, ['Orianna'] = 65, ['Vladimir'] = 65, ['Nidalee'] = 65, ['Tutorial_Red_Minion_Basic'] = 48.0, ['ZedShadow'] = 65, ['Syndra'] = 65, ['Zac'] = 80.0, ['Olaf'] = 65, ['Veigar'] = 55.0, ['Twitch'] = 65, ['Alistar'] = 80.0, ['Akali'] = 65, ['Urgot'] = 80.0, ['Leona'] = 65, ['Talon'] = 65, ['Karma'] = 65, ['Jayce'] = 65, ['Galio'] = 80.0, ['Shaco'] = 65, ['Taric'] = 65, ['TwistedFate'] = 65, ['Varus'] = 65, ['Garen'] = 65, ['Swain'] = 65, ['Vayne'] = 65, ['Fiora'] = 65, ['Quinn'] = 65, ['Kayle'] = 65, ['Blue_Minion_Basic'] = 48.0, ['Brand'] = 65, ['Teemo'] = 55.0, ['Amumu'] = 55.0, ['Annie'] = 55.0, ['Odin_Blue_Minion_caster'] = 48.0, ['Elise'] = 65, ['Nami'] = 65, ['Poppy'] = 55.0, ['AniviaEgg'] = 65, ['Tristana'] = 55.0, ['Graves'] = 65, ['Morgana'] = 65, ['Gragas'] = 80.0, ['MissFortune'] = 65, ['Warwick'] = 65, ['Cassiopeia'] = 65, ['Tutorial_Blue_Minion_Wizard'] = 48.0, ['DrMundo'] = 80.0, ['Volibear'] = 80.0, ['Irelia'] = 65, ['Odin_Red_Minion_Caster'] = 48.0, ['Lucian'] = 65, ['Yorick'] = 80.0, ['RammusPB'] = 65, ['Red_Minion_Basic'] = 48.0, ['Udyr'] = 65, ['MonkeyKing'] = 65, ['Tutorial_Blue_Minion_Basic'] = 48.0, ['Kennen'] = 55.0, ['Nunu'] = 65, ['Ryze'] = 65, ['Zed'] = 65, ['Nautilus'] = 80.0, ['Gangplank'] = 65, ['shopevo'] = 65, ['Lux'] = 65, ['Sejuani'] = 80.0, ['Ezreal'] = 65, ['OdinNeutralGuardian'] = 65, ['Khazix'] = 65, ['Sion'] = 80.0, ['Aatrox'] = 65, ['Hecarim'] = 80.0, ['Pantheon'] = 65, ['Shyvana'] = 50.0, ['Zyra'] = 65, ['Karthus'] = 65, ['Rammus'] = 65, ['Zilean'] = 65, ['Chogath'] = 80.0, ['Malzahar'] = 65, ['YorickRavenousGhoul'] = 1.0, ['YorickSpectralGhoul'] = 1.0, ['JinxMine'] = 65, ['YorickDecayedGhoul'] = 1.0, ['XerathArcaneBarrageLauncher'] = 65, ['Odin_SOG_Order_Crystal'] = 65, ['TestCube'] = 65, ['ShyvanaDragon'] = 80.0, ['FizzBait'] = 65, ['ShopKeeper'] = 65, ['Blue_Minion_MechMelee'] = 65.0, ['OdinQuestBuff'] = 65, ['TT_Buffplat_L'] = 65, ['TT_Buffplat_R'] = 65, ['KogMawDead'] = 65, ['TempMovableChar'] = 48.0, ['Lizard'] = 50.0, ['GolemOdin'] = 80.0, ['OdinOpeningBarrier'] = 65, ['TT_ChaosTurret4'] = 88.4, ['TT_Flytrap_A'] = 65, ['TT_Chains_Order_Periph'] = 65, ['TT_NWolf'] = 65.0, ['ShopMale'] = 65, ['OdinShieldRelic'] = 65, ['TT_Chains_Xaos_Base'] = 65, ['LuluSquill'] = 50.0, ['TT_Shopkeeper'] = 65, ['redDragon'] = 100.0, ['MonkeyKingClone'] = 65, ['Odin_skeleton'] = 65, ['OdinChaosTurretShrine'] = 88.4, ['Cassiopeia_Death'] = 65, ['OdinCenterRelic'] = 48.0, ['Ezreal_cyber_1'] = 65, ['Ezreal_cyber_3'] = 65, ['Ezreal_cyber_2'] = 65, ['OdinRedSuperminion'] = 55.0, ['TT_Speedshrine_Gears'] = 65, ['JarvanIVWall'] = 65, ['DestroyedNexus'] = 65, ['ARAMOrderNexus'] = 65, ['Red_Minion_MechCannon'] = 65.0, ['OdinBlueSuperminion'] = 55.0, ['SyndraOrbs'] = 65, ['LuluKitty'] = 50.0, ['SwainNoBird'] = 65, ['LuluLadybug'] = 50.0, ['CaitlynTrap'] = 65, ['TT_Shroom_A'] = 65, ['ARAMChaosTurretShrine'] = 88.4, ['Odin_Windmill_Propellers'] = 65, ['DestroyedInhibitor'] = 65, ['TT_NWolf2'] = 50.0, ['OdinMinionGraveyardPortal'] = 1.0, ['SwainBeam'] = 65, ['Summoner_Rider_Order'] = 65.0, ['TT_Relic'] = 65, ['odin_lifts_crystal'] = 65, ['OdinOrderTurretShrine'] = 88.4, ['SpellBook1'] = 65, ['Blue_Minion_MechCannon'] = 65.0, ['TT_ChaosInhibitor_D'] = 65, ['Odin_SoG_Chaos'] = 65, ['TrundleWall'] = 65, ['HA_AP_HealthRelic'] = 65, ['OrderTurretShrine'] = 88.4, ['OriannaBall'] = 48.0, ['ChaosTurretShrine'] = 88.4, ['LuluCupcake'] = 50.0, ['HA_AP_ChaosTurretShrine'] = 88.4, ['TT_Chains_Bot_Lane'] = 65, ['TT_NWraith2'] = 50.0, ['TT_Tree_A'] = 65, ['SummonerBeacon'] = 65, ['Odin_Drill'] = 65, ['TT_NGolem'] = 80.0, ['Shop'] = 65, ['AramSpeedShrine'] = 65, ['DestroyedTower'] = 65, ['OriannaNoBall'] = 65, ['Odin_Minecart'] = 65, ['Summoner_Rider_Chaos'] = 65.0, ['OdinSpeedShrine'] = 65, ['TT_Brazier'] = 65, ['TT_SpeedShrine'] = 65, ['odin_lifts_buckets'] = 65, ['OdinRockSaw'] = 65, ['OdinMinionSpawnPortal'] = 1.0, ['SyndraSphere'] = 48.0, ['TT_Nexus_Gears'] = 65, ['Red_Minion_MechMelee'] = 65.0, ['SwainRaven'] = 65, ['crystal_platform'] = 65, ['MaokaiSproutling'] = 48.0, ['Urf'] = 65, ['TestCubeRender10Vision'] = 65, ['MalzaharVoidling'] = 10.0, ['GhostWard'] = 1, ['MonkeyKingFlying'] = 65, ['LuluPig'] = 50.0, ['AniviaIceBlock'] = 65, ['TT_OrderInhibitor_D'] = 65, ['yonkey'] = 65, ['Odin_SoG_Order'] = 65, ['RammusDBC'] = 65, ['FizzShark'] = 65, ['LuluDragon'] = 50.0, ['OdinTestCubeRender'] = 65, ['OdinCrane'] = 65, ['TT_Tree1'] = 65, ['ARAMOrderTurretShrine'] = 88.4, ['TT_Chains_Order_Base'] = 65, ['Odin_Windmill_Gears'] = 65, ['ARAMChaosNexus'] = 65, ['TT_NWraith'] = 50.0, ['TT_OrderTurret4'] = 88.4, ['Odin_SOG_Chaos_Crystal'] = 65, ['TT_SpiderLayer_Web'] = 65, ['OdinQuestIndicator'] = 1.0, ['JarvanIVStandard'] = 65, ['TT_DummyPusher'] = 65, ['OdinClaw'] = 65, ['EliseSpiderling'] = 1.0, ['QuinnValor'] = 65, ['UdyrTigerUlt'] = 65, ['UdyrTurtleUlt'] = 65, ['UdyrUlt'] = 65, ['UdyrPhoenixUlt'] = 65, ['ShacoBox'] = 10, ['HA_AP_Poro'] = 65, ['AnnieTibbers'] = 80.0, ['UdyrPhoenix'] = 65, ['UdyrTurtle'] = 65, ['UdyrTiger'] = 65, ['HA_AP_OrderShrineTurret'] = 88.4, ['HA_AP_OrderTurretRubble'] = 65, ['HA_AP_Chains_Long'] = 65, ['HA_AP_OrderCloth'] = 65, ['HA_AP_PeriphBridge'] = 65, ['HA_AP_BridgeLaneStatue'] = 65, ['HA_AP_ChaosTurretRubble'] = 88.4, ['HA_AP_BannerMidBridge'] = 65, ['HA_AP_PoroSpawner'] = 50.0, ['HA_AP_Cutaway'] = 65, ['HA_AP_Chains'] = 65, ['HA_AP_ShpSouth'] = 65, ['HA_AP_HeroTower'] = 65, ['HA_AP_ShpNorth'] = 65, ['ChaosInhibitor_D'] = 65, ['ZacRebirthBloblet'] = 65, ['OrderInhibitor_D'] = 65, ['Nidalee_Spear'] = 65, ['Nidalee_Cougar'] = 65, ['TT_Buffplat_Chain'] = 65, ['WriggleLantern'] = 1, ['TwistedLizardElder'] = 65.0, ['RabidWolf'] = 65.0, ['HeimerTGreen'] = 50.0, ['HeimerTRed'] = 50.0, ['ViktorFF'] = 65, ['TwistedGolem'] = 80.0, ['TwistedSmallWolf'] = 50.0, ['TwistedGiantWolf'] = 65.0, ['TwistedTinyWraith'] = 50.0, ['TwistedBlueWraith'] = 50.0, ['TwistedYoungLizard'] = 50.0, ['Red_Minion_Melee'] = 48.0, ['Blue_Minion_Melee'] = 48.0, ['Blue_Minion_Healer'] = 48.0, ['Ghast'] = 60.0, ['blueDragon'] = 100.0, ['Red_Minion_MechRange'] = 65.0, ['Test_CubeSphere'] = 65,}

    self.SpellAttack =
{
    ["caitlynheadshotmissile"] = {},
    ["garenslash2"] = {},
    ["masteryidoublestrike"] = {},
    ["renektonexecute"] = {},
    ["rengarnewpassivebuffdash"] = {},
    ["xenzhaothrust"] = {},
    ["xenzhaothrust3"] = {},
    ["lucianpassiveshot"] = {},
    ["frostarrow"] = {},
    ["kennenmegaproc"] = {},
    ["quinnwenhanced"] = {},
    ["renektonsuperexecute"] = {},
    ["trundleq"] = {},
    ["xenzhaothrust2"] = {},
    ["viktorqbuff"] = {},
    ["lucianpassiveattack"] = {},
}

self.NotAttackSpell =
{
    ["volleyattack"] = {},
    ["jarvanivcataclysmattack"] = {},
    ["shyvanadoubleattack"] = {},
    ["zyragraspingplantattack"] = {},
    ["zyragraspingplantattackfire"] = {},
    ["asheqattacknoonhit"] = {},
    ["heimertyellowbasicattack"] = {},
    ["heimertbluebasicattack"] = {},
    ["annietibbersbasicattack"] = {},
    ["yorickdecayedghoulbasicattack"] = {},
    ["yorickspectralghoulbasicattack"] = {},
    ["malzaharvoidlingbasicattack2"] = {},
    ["kindredwolfbasicattack"] = {},
    ["volleyattackwithsound"] = {},
    ["monkeykingdoubleattack"] = {},
    ["shyvanadoubleattackdragon"] = {},
    ["zyragraspingplantattack2"] = {},
    ["zyragraspingplantattack2fire"] = {},
    ["elisespiderlingbasicattack"] = {},
    ["heimertyellowbasicattack2"] = {},
    ["gravesautoattackrecoil"] = {},
    ["annietibbersbasicattack2"] = {},
    ["yorickravenousghoulbasicattack"] = {},
    ["malzaharvoidlingbasicattack"] = {},
    ["malzaharvoidlingbasicattack3"] = {},

}

    self.ResetAASpell =
{
    ["asheq"] = {},
    ["garenq"] = {},
    ["dariusnoxiantacticsonh"] = {},
    ["jaycehypercharge"] = {},
    ["luciane"] = {},
    --["lucianw"] = {},
    --["lucianq"] = {},
    ["mordekaisermaceofspades"] = {},
    ["nautiluspiercinggaze"] = {},
    ["gangplankqwrapper"] = {},
    ["renektonpreexecute"] = {},
    ["shyvanadoubleattack"] = {},
    ["takedown"] = {},
    ["trundletrollsmash"] = {},
    ["reksaiq"] = {},
    ["xenzhaocombotarget"] = {},
    ["itemtitanichydracleave"] = {},
    ["illaoiw"] = {},
    ["meditate"] = {},
    ["camilleq"] = {},
    ["vorpalspikes"] = {},
    ["hecarimrapidslash"] = {},
    ["fiorae"] = {},
    ["gravesmove"] = {},
    ["jaxempowertwo"] = {},
    ["leonashieldofdaybreak"] = {},
    ["monkeykingdoubleattack"] = {},
    ["nasusq"] = {},
    ["netherblade"] = {},
    ["powerfist"] = {},
    ["rengarq"] = {},
    ["sivirw"] = {},
    ["talonnoxiandiplomacy"] = {},
    ["vaynetumble"] = {},
    ["volibearq"] = {},
    ["yorickspectral"] = {},
    ["masochism"] = {},
    ["elisespiderw"] = {},
    ["sejuaninorthernwinds"] = {},
    ["camilleq2"] = {},
    ["vie"] = {},
}

	self.BaseTurrets = {
		["SRUAP_Turret_Order3"] = true,
		["SRUAP_Turret_Order4"] = true,
		["SRUAP_Turret_Chaos3"] = true,
		["SRUAP_Turret_Chaos4"] = true,
	};

	--TS
    self.menu_ts = TargetSelector(1750, 0, true, true, nil, false)

	self.OnPostAttackCallbacks = {};
    self.AfterAttackCallbacks = {}
    self.OnAttackCallbacks = {}
    self.BeforeAttackCallbacks = {}
    self.ActiveAttacks = {}
    self.enemyMinions = {}
    self.OnPostAttackCallbacks = {};
    self.MyHeroIsAutoAttacking = false;

    self.Attacks = true
    self.Move = true
    self.LastAATick = 0
    self.LastMoveCommandPosition = Vector({0,0,0})
    self.LastMoveCommandT = 0
    self.LastAttackCommandT = 0
    self._minDistance = 400
    self._missileLaunched = false
    self.AA = {LastTime = 0, LastTarget = nil, IsAttacking = false, Object = nil}

    Callback.Add("Tick", function(...) self:OnTick(...) end)
    Callback.Add("Draw", function(...) self:OnDraw(...) end)
    Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)
    Callback.Add("DoCast", function(...) self:OnDoCast(...) end)
    Callback.Add("PlayAnimation", function(...) self:OnPlayAnimation(...) end)

    Callback.Add("DrawMenu", function(...) self:OnDrawMenu(...) end)

    self:MenuValueDefault()
end

function Orbwalking:MenuValueDefault()
	self.menu = "Orbwalking"
	self.Draw_Target = self:MenuBool("Draw Target", true)
	self.Windup = self:MenuSliderInt("Windup", 80)
	self.Farm = self:MenuSliderInt("Farm", 0)
	self.Use_Missile_Check = self:MenuBool("Use Missile Check", true)
	self.EnableKey = self:MenuBool("Enable Key", true)
	self.Combo = self:MenuKeyBinding("Combo", 32)
end

function Orbwalking:OnDrawMenu()
	if Menu_Begin(self.menu) then
		if Menu_Begin("Drawings") then
			self.Draw_Target = Menu_Bool("Draw Target", self.Draw_Target, self.menu)
			Menu_End()
		end
		if Menu_Begin("Advanced") then
			self.Windup = Menu_SliderInt("Windup", self.Windup, 0, 200, self.menu)
			self.Farm = Menu_SliderInt("Farm", self.Farm, 0, 200, self.menu)
			Menu_End()
		end
		if Menu_Begin("Attack") then
			self.Use_Missile_Check = Menu_Bool("Use Missile Check", self.Use_Missile_Check, self.menu)
			Menu_End()
		end
		if Menu_Begin("Key Mode") then
			self.EnableKey = Menu_Bool("Enable Key", self.EnableKey, self.menu)
			self.Combo = Menu_KeyBinding("Combo", self.Combo, self.menu)
			Menu_End()
		end
		Menu_End()
	end
end

function Orbwalking:MenuBool(stringKey, bool)
	return ReadIniBoolean(self.menu, stringKey, bool)
end

function Orbwalking:MenuSliderInt(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orbwalking:MenuSliderFloat(stringKey, valueDefault)
	return ReadIniFloat(self.menu, stringKey, valueDefault)
end

function Orbwalking:MenuComboBox(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orbwalking:MenuKeyBinding(stringKey, valueDefault)
	return ReadIniInteger(self.menu, stringKey, valueDefault)
end

function Orbwalking:ComboMode(mode)
	if mode == "Combo" then
		return GetKeyPress(self.Combo) > 0
	end
	return false
end

function Orbwalking:GetDistanceSqr(p1, p2)
    assert(p1, "GetDistance: invalid argument: cannot calculate distance to "..type(p1))
    p2 = p2 or GetOrigin(myHero)
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function Orbwalking:IsAutoAttack(spell)
    --return spell:find("attack") or spell:find("attack") or self.AttacksTbl[spell]
    return (string.find(string.lower(spell), "attack") ~= nil and not self.NotAttackSpell[string.lower(spell)]) or self.SpellAttack[string.lower(GetName_Casting(spell))]
end

function Orbwalking:IsAutoAttackReset(spell)
    return self.AttackResets[spell]
end

function Orbwalking:GetMyProjectileSpeed()
    if myHero.IsMelee or myHero.CharName == "Azir" or myHero.CharName == "Velkoz" or (myHero.CharName == "Viktor" and GetBuffByName(myHero.Addr, "ViktorPowerTransferReturn"))then
        return math.huge
    end
    return self:GetProjectileSpeed(myHero)
end

function Orbwalking:GetProjectileSpeed(unit)
    return self.projectilespeeds[GetChampName(unit.Addr)] and self.projectilespeeds[GetChampName(unit.Addr)] or math.huge
end

function Orbwalking:DisableAttacks()
    self.Attacks = false
end

function Orbwalking:EnableAttacks()
    self.Attacks = true
end


function Orbwalking:DisableMove()
	self.Move = false
end

function Orbwalking:EnableMove()
	self.Move = true
end

function Orbwalking:ForceTarget(target)
    self.forcetarget = target
end

function Orbwalking:GameTimeTickCount()
    return GetTimeGame()
end

function Orbwalking:GamePing()
    return GetLatency() / 2000
end

function Orbwalking:Attack(target)
    BasicAttack(target)
    --self.LastAATick = self:GameTimeTickCount() - self:GamePing()
end

function Orbwalking:WindUpTime()
    return GetWindupBA(myHero.Addr)-- (1 / (myHero.AttackSpeed * self.BaseWindupTime))
end

function Orbwalking:AnimationTimeOrb()
    return GetCDBA(myHero.Addr)--(1 / (myHero.AttackSpeed * self.BaseAnimationTime))
end

function Orbwalking:OnPlayAnimation(unit, anim)
    if unit.IsMe and myHero.CharName == "Graves" then

        if anim == "Spell3" or anim == "Spell3withReload" then
            DelayAction(function() self:ResetAutoAttackTimer() end, 0)
        end
    end
    if unit.IsMe then
    	if anim:lower():find("attack") == 1 and GetTimeGame() - self.AA.LastTime + GetLatency() >= 1 * self:AnimationTimeOrb() - 25/1000 then
            self.AA.IsAttacking = true
            self.AA.LastTime = GetTimeGame() - GetLatency()
        end
    end
end

function Orbwalking:CanAttack()
    if CountBuffByType(myHero.Addr, 25) == 1 and myHero.CharName ~= "Kalista" then
    	return false
    end

    if myHero.CharName == "Graves" then
        local attackDelay = 1.0740296828 * self.AnimationTimeOrb() - 0.7162381256175
        if myHero.HasBuff("gravesbasicattackammo1") and not myHero.HasBuff("gravesbasicattackammo2") then
        	nBonusAS = GetAttackSpeed(myHero.Addr) - 1
        	if nBonusAS > 2.5 then nBonusAS = 2.5 end
        	attackDelay = 1 / (0.65 + 0.65 * nBonusAS)
        end
        if self:GameTimeTickCount() + self:GamePing() + 0.08 >= self.LastAATick + attackDelay and myHero.HasBuff("gravesbasicattackammo1") then
            return true

        end
        return false
    end

    if myHero.CharName == "Jhin" then
        if myHero.HasBuff("JhinPassiveReload") then
            return false
        end
    end

    return (self:GameTimeTickCount() + self:GamePing() + 0.08  > self.LastAATick + self:AnimationTimeOrb())
end

function Orbwalking:CanMove(extraWindup)--, disableMissileCheck)
 	--disableMissileCheck and disableMissileCheck or false
 	if self._missileLaunched then -- and self.menu_advanced_MissileCheck.getValue() and not disableMissileCheck then
        return true;
    end
    local localExtraWindup = 0;
    if myHero.Nam == "Rengar" and (myHero.HasBuff("rengarqbase") or myHero.HasBuff("rengarqemp")) then
    	localExtraWindup = 200;
    end

    return myHero.CharName == "Kalista" or self:GameTimeTickCount() + self:GamePing() > self.LastAATick + self:WindUpTime() + extraWindup + localExtraWindup --self.menu_advanced_delayWindup.getValue() /1000
end

function Orbwalking:IsAttacking()
    return not self:CanMove()
end

function Orbwalking:CanCast()
    return not self:IsAttacking()
end

function Orbwalking:InAutoAttackRange(target)
    if not IsValidTarget(target, math.huge) then
        return false
    end

    return GetDistance(target) < GetTrueAttackRange()
end

function Orbwalking:GetAttackRange(target)
    return target.AARange + target.CollisionRadius
end

function Orbwalking:GetLastMovePosition()
    return self.LastMoveCommandPosition
end

function Orbwalking:GetLastMoveTime()
    return self.LastMoveCommandT
end

function Orbwalking:OrbWalk(target, point)
    if point ~= nil then
	    if self.Attacks and self:CanAttack() and IsValidTarget(target, 1000) then -- and not self:BeforeAttack(target) then
	    	if myHero.CharName ~= "Kalista" then
	    		self._missileLaunched = false;
	    	end
	        self:Attack(target)
	    elseif self:CanMove(self.Windup /1000) and self.Move then
	        --[[if not point then
	            local OBTarget = self:GetTargetOrb() or target

	            local mousePos = GetMousePos()
	            local targetPos = Vector(GetPosX(target), GetPosY(target), GetPosZ(target))

	            if not OBTarget then
	                local Mv = myHeroPos + 400 * (mousePos - myHeroPos):Normalized()
	                MoveToPos(Mv.x, Mv.z)
	            elseif self:GetDistanceSqr(GetOrigin(OBTarget)) > 100*100 + math.pow(GetBoundingRadius(OBTarget), 2) then
	                local point = targetPos

	                if self:GetDistanceSqr(point) < 100*100 + math.pow(GetBoundingRadius(OBTarget), 2) then
	                    point = Vector(myHeroPos - point):Normalized() * 50
	                end
	                MoveToPos(point.x, point.z)
	            end
	        else]]
	            MoveToPos(point.x, point.z)
	        --end
	    end
	end
end

function Orbwalking:ResetAutoAttackTimer()
    self.LastAATick = 0
end

function Orbwalking:TurretAggroStartTick(minionEnemy)
    local i = 1
    while i <= #self.ActiveAttacks do
        if GetType(self.ActiveAttacks[i].Source.Addr) == 2 and GetIndex(self.ActiveAttacks[i].Target) == GetIndex(minionEnemy) then
            return self.ActiveAttacks[i].StartTick
        else
            i = i + 1
        end
    end
    return 0
end

function Orbwalking:HasTurretAggro(minionEnemy)
    local i = 1
    while i <= #self.ActiveAttacks do
        --__PrintTextGame("-->"..tostring(GetType(self.ActiveAttacks[i].Source.Addr)).."<->"..tostring(GetIndex(self.ActiveAttacks[i].Target)).."<->"..tostring(GetIndex(minionEnemy)))
        if GetType(self.ActiveAttacks[i].Source.Addr) == 2 and GetIndex(self.ActiveAttacks[i].Target) == GetIndex(minionEnemy) then
            return true
        end
        i = i + 1
    end
    return false
end

function Orbwalking:HasMinionAggro(minionEnemy)
    local i = 1
    while i <= #self.ActiveAttacks do
        if GetType(self.ActiveAttacks[i].Source.Addr) == 1 and GetIndex(self.ActiveAttacks[i].Target) == GetIndex(minionEnemy) then
            return true
        end
        i = i + 1
    end
    return false
end

function Orbwalking:getAttackCastDelay(minionEnemy)
    local i = 1
    while i <= #self.ActiveAttacks do
        if GetType(self.ActiveAttacks[i].Source.Addr) == 2 and GetIndex(self.ActiveAttacks[i].Source.Addr) == GetIndex(minionEnemy) then
            return self.ActiveAttacks[i].Delay
        else
            i = i + 1
        end
    end
    return 0
end

function Orbwalking:getAttackDelay(minionEnemy)
    local i = 1
    --local result
    while i <= #self.ActiveAttacks do
        --__PrintTextGame("-->"..tostring(GetType(self.ActiveAttacks[i].Source.Addr)).."<->"..tostring(GetIndex(self.ActiveAttacks[i].Source.Addr)).."<->"..tostring(GetIndex(minionEnemy)))
        if GetType(self.ActiveAttacks[i].Source.Addr) == 2 and GetIndex(self.ActiveAttacks[i].Source.Addr) == GetIndex(minionEnemy) then

            return self.ActiveAttacks[i].AnimationTime
        else
            i = i + 1
        end
    end
    return 0
end

function Orbwalking:LocalGetTargetById(targetid)
    GetAllUnitAroundAnObject(GetMyChamp(), 3000)
    for i, obj in pairs(pUnit) do
        if obj ~= 0 and (GetType(obj) == 1 or GetType(obj) == 2 or GetType(obj) == 0) then
            local unit = GetUnit(obj)
            if unit.Id == targetid then
                return unit.Addr
            end
        end
    end
    return 0
end

function Orbwalking:OnProcessSpell(unit, spell)
    local spellName = spell.Name:lower()
    if unit.IsMe and self:IsAutoAttack(spellName)  then
        --if (string.find(string.lower(spellName), "attack") ~= nil and not self.NotAttackSpell[string.lower(spellName)]) or self.SpellAttack[string.lower(spellName)] then
        if GetType(GetTargetById(spell.TargetId)) == 2 or GetType(GetTargetById(spell.TargetId)) == 0 or GetType(GetTargetById(spell.TargetId)) == 1 or GetType(GetTargetById(spell.TargetId)) == 3 then
            self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing()
            self.LastMoveCommandT = 0
        end
        self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing()
        self._missileLaunched = false;
    end

    if unit.IsMe and self.SpellAttack[string.lower(spellName)] then
    	self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing() / 2
    end

    if unit.IsMe and self.ResetAASpell[string.lower(spellName)] then
        DelayAction(function() self:ResetAutoAttackTimer() end, 0)
    end
end

function Orbwalking:OnDoCast(unit, spell)
	local spellName = spell.Name:lower()
    if unit.Type == 1 then
        local minion = GetUnit(unit.Addr)

        local i = 1
        while i <= #self.ActiveAttacks do
            if self.ActiveAttacks[i].Source.NetworkId == minion.NetworkId and minion.IsMelee then
                self.ActiveAttacks[i].Processed = true
            end
            i = i + 1
        end
    end

    if unit.IsMe and self.ResetAASpell[string.lower(spellName)] then
        DelayAction(function() self:ResetAutoAttackTimer() end, 0)
    end

    if unit.IsMe and self:IsAutoAttack(spellName) then
    	self._missileLaunched = true;
    	--DelayAction(function(t) self:AfterAttack(t) end, self:WindUpTime() - GetLatency(), {GetTargetById(spell.TargetId)})
   	end
end

function Orbwalking:OnDeleteObject(obj)
    if obj and obj.Type == 6 then
        local i = 1
        while i <= #self.ActiveAttacks do
            if GetId(self.ActiveAttacks[i].Source.Addr) == obj.OwnerId then
                self.ActiveAttacks[i].Processed = true
            end
            i = i + 1
        end
    end
end

function Orbwalking:OnDraw()
	--/*Champions*/
    if self.Draw_Target then
        local target = self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange()) --self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange())
        --if IsValidTarget(target, math.huge) and self:InAutoAttackRange(target) then
        if target ~= 0 and  self:InAutoAttackRange(target) then
            local targetPos = Vector(GetPosX(target), GetPosY(target), GetPosZ(target))
            DrawCircleGame(targetPos.x , targetPos.y, targetPos.z, 200, Lua_ARGB(255, 255, 0, 10))
        end
    end
end

function Orbwalking:OnTick()
    if not self.EnableKey then return end

	if myHero.IsDead or IsTyping() or IsDodging() then return end

    local result = nil
    local mousePos = nil
    if GetKeyPress(self.Combo) > 0 then --or self.menu_keybin_lasthitKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_laneclearKey.getValue() then
    	result = self:GetTargetOrb()
    	mousePos = GetMousePos()
    end

    self:OrbWalk(result, mousePos)
end


function Orbwalking:GetTargetOrb()
    local result = nil

    if IsValidTarget(self.forcetarget, GetTrueAttackRange()) then
        return self.forcetarget
    elseif self.forcetarget ~= nil then
        return nil
    end

    --/*Champions*/
    if GetKeyPress(self.Combo) > 0 then
        --if not self.menu_keybin_laneclearKey or not self:ShouldWait() then
            local target = self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange())--self.menu_ts:GetTarget(GetTrueAttackRange())
            --local target = TargetSelector:GetTarget()
            --if IsValidTarget(target, math.huge) and self:InAutoAttackRange(target) then
            if target ~= 0 then
                return target
            end
        --end
    end

    return result
end
