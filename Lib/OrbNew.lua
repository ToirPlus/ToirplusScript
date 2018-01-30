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

	--self.EnemyMinions = minionManager(MINION_ENEMY, 2000, myHero, MINION_SORT_MAXHEALTH_ASC)
	--self.JungleMinions = minionManager(MINION_JUNGLE, 2000, myHero, MINION_SORT_MAXHEALTH_DEC)
	--self.OtherMinions = minionManager(MINION_OTHER, 2000, myHero, MINION_SORT_HEALTH_ASC)

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


end

function Orbwalking:LoadToMenu(m)

    if not m then
        self.menu = menuInst.addItem(SubMenu.new("Orbwalking", Lua_ARGB(255, 100, 250, 50)))
        menuInstSep.setValue("Orbwalking")
    else
        self.menu = m
    end
    --Main Menu
    --self.menu = menuInst.addItem(SubMenu.new("Orbwalking", Lua_ARGB(255, 100, 250, 50)))
    --__PrintTextGame("string szText")
    --TS
    self.menu_ts = TargetSelector(1750, 1, myHero, true, nil, false)

    --Draw
    self.menu_Draw = self.menu.addItem(SubMenu.new("Drawings"))
    self.menu_Draw_AA = self.menu_Draw.addItem(MenuBool.new("Auto-Attack Range", true))
    self.menu_Draw_Enemy = self.menu_Draw.addItem(MenuBool.new("Draw Target", true))
    self.menu_Draw_AAenemy = self.menu_Draw.addItem(MenuBool.new("Auto-Attack Range Enemy", true))
    self.menu_Draw_Holdzone = self.menu_Draw.addItem(MenuBool.new("Draw Hold Position", true))
    self.menu_Draw_LastHit = self.menu_Draw.addItem(MenuBool.new("Draw Last Hit Helper", true))

    --Advanced
    self.menu_advanced = self.menu.addItem(SubMenu.new("Advanced"))
    --self.menu_advanced.addItem(MenuSeparator.new("MovementAdvanced"))
    --self.menu_advanced_movementRandomize = self.menu_advanced.addItem(MenuBool.new("Randomize Location", true))
    --self.menu_advanced_movementExtraHold = self.menu_advanced.addItem(MenuSlider.new("Extra Hold Position", 100, 0, 250, 1))
    --self.menu_advanced_movementMaximumDistance1 = self.menu_advanced.addItem(MenuSlider.new("Maximum Distance", 1500, 500, 1500, 1))
    --self.menu_advanced.addItem(MenuSeparator.new("Delay"))
    --self.menu_advanced_delayMovement = self.menu_advanced.addItem(MenuSlider.new("Movement", 0, 0, 500, 1))
    self.menu_advanced_delayWindup = self.menu_advanced.addItem(MenuSlider.new("Windup", 80, 0, 200, 1))
    self.menu_advanced_delayFarm = self.menu_advanced.addItem(MenuSlider.new("Farm", 0, 0, 200, 1))
    self.menu_advanced.addItem(MenuSeparator.new("Prioritization"))
    --self.menu_advanced_prioritizeFarm = self.menu_advanced.addItem(MenuBool.new("Farm Over Harass", true))
    --self.menu_advanced_prioritizeMinions = self.menu_advanced.addItem(MenuBool.new("Minions Over Objectives", true))
    self.menu_advanced_prioritizeSmallJungle = self.menu_advanced.addItem(MenuBool.new("Small Jungle", true))
    --self.menu_advanced_prioritizeWards = self.menu_advanced.addItem(MenuBool.new("Wards", true))
    --self.menu_advanced_prioritizeSpecialMinions = self.menu_advanced.addItem(MenuBool.new("Special Minions", true))
    self.menu_advanced.addItem(MenuSeparator.new("Attack"))
    self.menu_advanced_attackWards = self.menu_advanced.addItem(MenuBool.new("Wards , Trap", true))
    self.menu_advanced_attackBarrels = self.menu_advanced.addItem(MenuBool.new("Barrels", true))
    self.menu_advanced_MissileCheck = self.menu_advanced.addItem(MenuBool.new("Use Missile Check", true))
    --self.menu_advanced_attackClones = self.menu_advanced.addItem(MenuBool.new("Clones", true))
    --self.menu_advanced_attackSpecialMinions = self.menu_advanced.addItem(MenuBool.new("Special Minions", true))

    --Key
    self.menu_keybin = self.menu.addItem(SubMenu.new("Key Bindings"))
    self.menu_keybin_combo = self.menu_keybin.addItem(MenuKeyBind.new("Combo", 32))
    self.menu_keybin_lasthitKey = self.menu_keybin.addItem(MenuKeyBind.new("Last Hit", 88))
    self.menu_keybin_laneclearKey = self.menu_keybin.addItem(MenuKeyBind.new("Lane Clear", 86))
    self.menu_keybin_harassKey = self.menu_keybin.addItem(MenuKeyBind.new("Harass", 67))
    self.menu_keybin_enable = self.menu_keybin.addItem(MenuBool.new("Enabled", true))

    --menuInstSep.setValue("Orbwalking")
    --menuInst.addItem(MenuSeparator.new("   Script Info", true))
    --menuInst.addItem(MenuSeparator.new("Script Version: 1.17"))
    --menuInst.addItem(MenuSeparator.new("LoL Version: 7.23"))
end

function Orbwalking:ComboMode(mode)
	if mode == "Combo" then
		return self.menu_keybin_combo.getValue()
	end
	if mode == "LastHit" then
		return self.menu_keybin_lasthitKey.getValue()
	end
	if mode == "LaneClear" then
		return self.menu_keybin_laneclearKey.getValue()
	end
	if mode == "Harass" then
		return self.menu_keybin_harassKey.getValue()
	end
	return false
end

function Orbwalking:AfterAttack(target)
  for i, cb in ipairs(self.AfterAttackCallbacks) do
    cb(target)
  end
end

function Orbwalking:RegisterAfterAttackCallback(f)
    table.insert(self.AfterAttackCallbacks, f)
end

function Orbwalking:BeforeAttack(target)
    local result = false
    for i, cb in ipairs(self.BeforeAttackCallbacks) do
        local ri = cb(target)
        if ri then
            result = true
        end
    end
    return result
end

function Orbwalking:RegisterBeforeAttackCallback(f)

    table.insert(self.BeforeAttackCallbacks, f)
end

function Orbwalking:OnAttack(target)
    for i, cb in ipairs(self.OnAttackCallbacks) do
        cb(target)
    end
end

function Orbwalking:RegisterOnAttackCallback(f)
    table.insert(self.OnAttackCallbacks, f)
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
    --[[local extraAttackDelay = 0
    if myHero.CharName == "Graves" then
        if not myHero.HasBuff("gravesbasicattackammo1") then
            return false
        end
        extraAttackDelay =  1.0740296828 * self.AnimationTimeOrb() - 0.7162381256175 - self.AnimationTimeOrb()
    end

    if myHero.CharName == "Jhin" and myHero.HasBuff("JhinPassiveReload") then
        return false
    end
    return self:GameTimeTickCount() + self:GamePing() + 0.08  > self.LastAATick + self:AnimationTimeOrb() + extraAttackDelay --+ self.menu_advanced_delayWindup.getValue() /1000]]

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
            --__PrintTextGame(tostring(myHero.HasBuff("gravesbasicattackammo1")))
            return true

        end
        return false
    end

    if myHero.CharName == "Jhin" then
        --__PrintTextGame(tostring(myHero.HasBuff("JhinPassiveReload")))
        if myHero.HasBuff("JhinPassiveReload") then
            return false
        end
    end

    --if self.LastAATick <= self:GameTimeTickCount() then
        --return (self:GameTimeTickCount() + self:GamePing()  > self.LastAATick + self:AnimationTimeOrb())
        return (self:GameTimeTickCount() + self:GamePing() + 0.08  > self.LastAATick + self:AnimationTimeOrb())
        --return CanAttack() --or (self:GameTimeTickCount() + self:GamePing()  > self.LastAATick + self:AnimationTimeOrb())
    --end
    --return false
    --return CanAttack()
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

function Orbwalking:GetHitBox(object)
    if nohitboxmode and GetType(object) and GetType(object) == myHero.Type then
        return 0
    end
    return (self.hitboxes[GetChampName(object)] ~= nil and self.hitboxes[GetChampName(object)] ~= 0) and self.hitboxes[GetChampName(object)]  or 65
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

function Orbwalking:MoveTo(position, holdAreaRadius, overrideTimer, useFixedDistance, randomizeMinDistance)
    holdAreaRadius = holdAreaRadius and holdAreaRadius or 0
    overrideTimer = overrideTimer and overrideTimer or false
    useFixedDistance = useFixedDistance and useFixedDistance or true
    randomizeMinDistance = randomizeMinDistance and randomizeMinDistance or true

    local playerPosition = Vector(myHero.x, myHero.y, myHero.z)
    if GetDistance(position) < holdAreaRadius then
        if myHero.PathCount > 0 then
            self.LastMoveCommandPosition = playerPosition
            self.LastMoveCommandT = self:GameTimeTickCount() - 0.070
        end
        return
    end
    local point = position
    --[[if GetDistance(point) < 150 then
        point = playerPosition:Extend(position, self._minDistance)
    end
    local angle = 0
    local currentPath = self:GetWaypoints()

    count = 0
    for _ in pairs(self:GetWaypoints()) do count = count + 1 end

    if count > 1 and self:PathLength() > 100 then
        --local movePath =
    end

    if self:GameTimeTickCount() - self.LastMoveCommandT < 0.070 + math.min(0.060, self:GamePing()) and not overrideTimer and angle < 60 then
        return
    end

    if angle >= 60 and self:GameTimeTickCount() - self.LastMoveCommandT < 0.060 then
        return
    end]]

    MoveToPos(point.x, point.z)
    self.LastMoveCommandPosition = point
    self.LastMoveCommandT = self:GameTimeTickCount()
end

function Orbwalking:OrbWalk1(target, position, extraWindup, holdAreaRadius, useFixedDistance, randomizeMinDistance)
    extraWindup = extraWindup or 80
    holdAreaRadius = holdAreaRadius or 0
    useFixedDistance = useFixedDistance or true
    randomizeMinDistance = randomizeMinDistance or true

    --if  self:GameTimeTickCount() - self.LastAttackCommandT < 0.070 + math.min(0.06, self:GamePing()) then
        --return
    --end

    if IsValidTarget(target, math.huge) and self:CanAttack() and not self:BeforeAttack(target) then
        --if self:Attack(target) then
            --self.LastAttackCommandT = self:GameTimeTickCount()
            --self._lastTarget = target
        --end
        --return
        self:Attack(target)
    end

    if self:CanMove() then
        self:MoveTo(position, math.max(holdAreaRadius, 30), false, useFixedDistance, randomizeMinDistance)
    end
end

function Orbwalking:OrbWalk(target, point)
    --point = point or forceorbwalkpos
    --__PrintTextGame(IsValidTarget(target, 1000))
    --if  self:GameTimeTickCount() - self.LastAttackCommandT < 0.070 + math.min(0.06, self:GamePing()) then
        --return
    --end
    if point ~= nil then
	    if self.Attacks and self:CanAttack() and IsValidTarget(target, 1000) and not self:BeforeAttack(target) then
	    	if myHero.CharName ~= "Kalista" then
	    		self._missileLaunched = false;
	    	end
	        self:Attack(target)
	    elseif self:CanMove(self.menu_advanced_delayWindup.getValue() /1000) and self.Move then
	        if not point then
	            local OBTarget = self:GetTargetOrb() or target

	            local mousePos = GetMousePos()
	            local targetPos = Vector(GetPosX(target), GetPosY(target), GetPosZ(target))

	            if self.menu_keybin_harassKey.getValue() or not OBTarget then
	                local Mv = myHeroPos + 400 * (mousePos - myHeroPos):Normalized()
	                MoveToPos(Mv.x, Mv.z)
	            elseif self:GetDistanceSqr(OBTarget) > 100*100 + math.pow(GetBoundingRadius(OBTarget), 2) then
	                local point = targetPos

	                if self:GetDistanceSqr(point) < 100*100 + math.pow(GetBoundingRadius(OBTarget), 2) then
	                    point = Vector(myHeroPos - point):Normalized() * 50
	                end
	                MoveToPos(point.x, point.z)
	            end
	        else
	            MoveToPos(point.x, point.z)
	        end
	    end
	end
end

function Orbwalking:ResetAutoAttackTimer()
    self.LastAATick = 0
end

function Orbwalking:GetHealthPrediction(unit, time, delay)
    local predictedDamage = 0
    local i = 1
    delay = delay and delay or 0.07
    while i <= #self.ActiveAttacks do
        local attackDamage = 0
        if self.ActiveAttacks[i].Processed == false and self.ActiveAttacks[i].Source.Addr ~= 0 and not IsDead(self.ActiveAttacks[i].Source.Addr) and self.ActiveAttacks[i].Target and GetIndex(self.ActiveAttacks[i].Target) == unit.NetworkId then
            local landTime = self.ActiveAttacks[i].StartTick + self.ActiveAttacks[i].Delay + math.max(0, GetDistance(self.ActiveAttacks[i].Source.Addr, unit.Addr) - GetBoundingRadius(self.ActiveAttacks[i].Source.Addr))
                                   / self.ActiveAttacks[i].ProjectileSpeed + delay
            if GetTimeGame() < landTime - delay and landTime < GetTimeGame() + time then
                attackDamage = self.ActiveAttacks[i].Damage
            end
        end
        predictedDamage = predictedDamage + attackDamage
        i = i + 1
    end
    return unit.HP - predictedDamage
end

function Orbwalking:LaneClearHealthPrediction(unit, t)
    local damage = 0
    local i = 1

    while i <= #self.ActiveAttacks do
        local n = 0
        if (GetTimeGame() - 0.1) <= self.ActiveAttacks[i].StartTick + self.ActiveAttacks[i].AnimationTime and self.ActiveAttacks[i].Target --[[and self.ActiveAttacks[i].Target.IsValid]] and GetIndex(self.ActiveAttacks[i].Target) == unit.NetworkId
            and self.ActiveAttacks[i].Source.Addr and self.ActiveAttacks[i].Source.IsValid and not IsDead(self.ActiveAttacks[i].Source.Addr) then
            local FromT = self.ActiveAttacks[i].StartTick
            local ToT = t + GetTimeGame()

            while FromT < ToT do
                --__PrintTextGame(tostring(GetDistance(self.ActiveAttacks[i].Source, unit) - GetBoundingRadius(self.ActiveAttacks[i].Source.Addr)))
                if FromT >= GetTimeGame() and (FromT + (self.ActiveAttacks[i].Delay + math.max(0, GetDistance(self.ActiveAttacks[i].Source.Addr, unit.Addr) - GetBoundingRadius(self.ActiveAttacks[i].Source.Addr))
                 / self.ActiveAttacks[i].ProjectileSpeed)) < ToT then
                    n = n + 1
                end
                FromT = FromT + self.ActiveAttacks[i].AnimationTime
            end
        end
        damage = damage + n * self.ActiveAttacks[i].Damage
        i = i + 1
    end

    return unit.HP - damage
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

--local i = 0
function Orbwalking:OnProcessSpell(unit, spell)
	--__PrintDebug(spell.Name)
    local spellName = spell.Name:lower()
    if unit.IsMe and self:IsAutoAttack(spellName)  then
        --if (string.find(string.lower(spellName), "attack") ~= nil and not self.NotAttackSpell[string.lower(spellName)]) or self.SpellAttack[string.lower(spellName)] then
        if GetType(GetTargetById(spell.TargetId)) == 2 or GetType(GetTargetById(spell.TargetId)) == 0 or GetType(GetTargetById(spell.TargetId)) == 1 or GetType(GetTargetById(spell.TargetId)) == 3 then
            self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing()
            self.LastMoveCommandT = 0
        end
        self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing()
        self:OnAttack(GetTargetById(spell.TargetId))
        self._missileLaunched = false;

        --DelayAction(function(t) self:AfterAttack(t) end, self:WindUpTime() - GetLatency(), {GetTargetById(spell.TargetId)})
    end

    if unit.IsMe and self.SpellAttack[string.lower(spellName)] then
    	self.LastAATick = GetLastBATick() --self:GameTimeTickCount() - self:GamePing() / 2
    end

    if unit.IsMe and self.ResetAASpell[string.lower(spellName)] then
        DelayAction(function() self:ResetAutoAttackTimer() end, 0)
    end
    --__PrintTextGame(tostring(GetTargetById(spell.TargetId)))
    if unit.IsValid and unit.TeamId == myHero.TeamId and unit.Type ~= myHero.Type
        and GetType(GetTargetById(spell.TargetId)) == 1
        and spellName:find("attack") ~= 0
        and (unit.Type == 1)
        and spell.TargetId ~= nil then

        if self:GetDistanceSqr(unit) < 4000000 then
            if self.projectilespeeds[GetChampName(unit.Addr)] then
    ---------------------- L# ------------------------
                local aniTime = 0
                if unit.Type == 2 then
                    aniTime = 0.07
                elseif unit.Type == 1 then
                    aniTime = 0
                end

                if self:IsBaseTurret(unit) then -- fps drops
					return;
				end

                local time = GetTimeGame() + GetDistance(GetTargetById(spell.TargetId), unit) / self.projectilespeeds[GetChampName(unit.Addr)] - self:GamePing()


                local i = 1
                while i <= #self.ActiveAttacks do
                    if (self.ActiveAttacks[i].Source.Addr ~= 0 and self.ActiveAttacks[i].Source.IsValid and self.ActiveAttacks[i].Source.NetworkId == unit.NetworkId) or self.ActiveAttacks[i].Hittime + 3 < GetTimeGame() then
                    	--__PrintTextGame(i)
                        table.remove(self.ActiveAttacks, i)
                    else
                    	 i = i + 1
                    end
                end

                --__PrintTextGame(tostring(spell.Delay).."<->"..tostring(self:WindUpTime()).."<->"..tostring(GetCDBA(unit.Addr) - aniTime).."<->"..tostring(self:AnimationTimeOrb()))--.."<->"..tostring(GetChampName(GetTargetById(spell.TargetId))))

                table.insert(self.ActiveAttacks, {
                    Source = unit,
                    Target = GetTargetById(spell.TargetId),
                    StartTick = (spell.TimeCast or GetTimeGame()  - GetLatency()/2),
                    Delay = spell.Delay,  --AttackCastDelay -- WindUpTime()
                    ProjectileSpeed = self.projectilespeeds[GetChampName(unit.Addr)], --spell.MissileSpeed, --projectilespeeds[GetChampName(unit.Addr)], -- spell.MissileSpeed,
                    Damage = self:CalcDamageOfAttack(unit.Addr, GetTargetById(spell.TargetId), spell, 0),
                    AnimationTime = GetCDBA(unit.Addr) - aniTime, --AttackDelay -- AnimationTimeOrb()
                    Hittime=time,
                    Processed = false
                    })
            end
        end
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
    	DelayAction(function(t) self:AfterAttack(t) end, self:WindUpTime() - GetLatency(), {GetTargetById(spell.TargetId)})
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

--[[function Orbwalking:GetWaypoints(object)
    local result = {}
    if object.IsVisible then
        table.insert(result, Vector({object.x, object.y, object.z}))
        if object.PathCount > 0 then

            local first = Vector(object.GetPath(0))
            if GetDistance(first, Vector(result[0])) > 40 then
                table.insert(result, first)
            end

            for i=1, object.PathCount - 1 do
                table.insert(result, Vector(object.GetPath(i)))
            end
        end
    end
    return result
end]]

function Orbwalking:PathLength()
    local distance = 0
    for i=1,myHero.PathCount - 1 do
        distance = distance + GetDistance(Vector(myHero.GetPath(i)), Vector(myHero.GetPath(i + 1)))
    end
    return distance
end

function Orbwalking:GetWaypoints(object)
    local result = {}
    if object.PathCount > 0 then
        table.insert(result, Vector(object))
        for i=1, object.PathCount - 1 do
            table.insert(result, Vector(object.GetPath(i)))
        end
    else
        table.insert(result, Vector(object))
    end
    return result
end

function Orbwalking:OnDraw()

    if self.menu_Draw_AA.getValue() and not myHero.IsDead then
        DrawCircleGame(myHero.x , myHero.y, myHero.z, self:GetAttackRange(myHero), Lua_ARGB(255, 0, 255, 10))
    end

    --if self.menu_Draw_AAenemy.getValue() then
        --local target = self.menu_ts:GetTarget()
        --if IsValidTarget(target, 1000) and self:InAutoAttackRange(target) then
                --return target
            --DrawCircleGame(target.x , target.y, target.z, self:GetAttackRange(target), Lua_ARGB(255, 255, 255, 10))
        --end
    --end

    --self:AttackGPBarrel()

    if self.menu_Draw_Holdzone.getValue() then
        DrawCircleGame(myHero.x , myHero.y, myHero.z, self.menu_advanced_movementExtraHold.getValue(), Lua_ARGB(255, 0, 255, 10))
    end

    if self.menu_Draw_LastHit.getValue() then
        local N = math.huge
        for i, minions in pairs(self:EnemyMinionsTbl()) do
        	if minions ~= 0 then
	            local minion = GetUnit(minions)
	            if  IsEnemy(minions) and not IsDead(minions) and not IsInFog(minions) and (GetType(minions) == 1 or GetType(minions) == 2) then
	                local time1 = self:WindUpTime() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr))  / self:GetMyProjectileSpeed() - 0.07
	                local time = self:WindUpTime() - 0.1 + self:GamePing() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr)) / self:GetMyProjectileSpeed()
	                -- __PrintTextGame(tostring(GetAADamageHitEnemy(minion.Addr)))
	                local PredictedHealth = self:GetHealthPrediction(minion, time1, 0)--self.menu_advanced_delayFarm.getValue())
	                local damage = GetAADamageHitEnemy(minion.Addr) --self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) + self:BonusDamage(minion)
	                local tokill = PredictedHealth / damage

	                if IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) and minion.TeamId ~= 300 then
	                    if PredictedHealth < damage and PredictedHealth > - damage then
	                        if (tokill < N or result == nil) then
	                            N = tokill
	                            DrawCircleGame(minion.x , minion.y, minion.z, minion.CollisionRadius, Lua_ARGB(255, 0, 255, 10))
	                        end
	                    end
	                    if minion.HP < damage then
	                        DrawCircleGame(minion.x , minion.y, minion.z, minion.CollisionRadius, Lua_ARGB(255, 0, 255, 10))
	                    end
	                end
	            end
	        end
        end
    end

    --[[GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, wards in pairs(pUnit) do
    	if wards ~= 0 then
    		ward = GetUnit(wards)
    		--if ward.CharName == "IllaoiMinion" and IsValidTarget(ward.Addr, 1000) and self:InAutoAttackRange(ward.Addr) then
	            __PrintDebug(GetObjName(ward.Addr))
	        --end
	    end
	end]]

	--/*Champions*/
    if self.menu_Draw_Enemy.getValue() then
        local target = self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange()) --self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange())
        --if IsValidTarget(target, math.huge) and self:InAutoAttackRange(target) then
        if target ~= 0 and  self:InAutoAttackRange(target) then
            local targetPos = Vector(GetPosX(target), GetPosY(target), GetPosZ(target))
            DrawCircleGame(targetPos.x , targetPos.y, targetPos.z, 200, Lua_ARGB(255, 255, 0, 10))
        end
    end

    for i, minions in pairs(self:EnemyMinionsTbl()) do
        if minions ~= nil then
            local minion = GetUnit(minions)

            --local time = WindUpTime() - 0.1 + GetLatency() / 2000 + math.max(0, GetDistance(minion) - myHero.CollisionRadius) / GetMyProjectileSpeed()
            local timeGetHealth = self:WindUpTime() + math.max(0, GetDistance(minion)) / self:GetMyProjectileSpeed() - 0.07
            --local timeGetHealth = self:WindUpTime() + math.max(0, GetDistance(minion) - GetBoundingRadius(myHero.Addr)) / self:GetMyProjectileSpeed() - 0.07
            --local timeLaneClear = self:AnimationTimeOrb() + math.max(0, GetDistance(minion) - myHero.CollisionRadius) / self:GetMyProjectileSpeed()

            --local time1 = self:WindUpTime() -0.1 + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr))  / self:GetMyProjectileSpeed() - 0.07

            --local PredictedHealth = LaneClearHealthPrediction(minion, timeLaneClear)
            local PredictedHealth = self:GetHealthPrediction(minion, timeGetHealth, 0)-- self.menu_advanced_delayFarm.getValue())
            local damage = GetAADamageHitEnemy(minion.Addr) --CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0)


            --DrawTextD3DX(a, b, tostring(PredictedHealth), Lua_ARGB(255, 255, 255, 10))
            --if GetChampName(minion.Addr):find("Siege")then
            	local pos = Vector({GetPosX(minion.Addr), GetPosY(minion.Addr), GetPosZ(minion.Addr)})
            	local a,b = WorldToScreen(minion.x + 50, minion.y + 50, minion.z + 50)
            	--DrawTextD3DX(a, b, tostring(PredictedHealth), Lua_ARGB(255, 255, 255, 10))
            --end
        end
    end
end

--[[function Orbwalking:GetTarget(range)
    local result = nil
    local N = math.huge
    for i,hero in pairs(GetEnemyHeroes()) do
	table.sort(GetEnemyHeroes(), function(a, b) return GetDistance(a) < GetDistance(b) end)
        if hero~= 0 and IsValidTarget(hero, range) and IsEnemy(hero) then
            local dmgtohero = GetAADamageHitEnemy(hero) or 1
            local tokill = GetHealthPoint(hero)/dmgtohero
            if tokill < N or result == nil then
                N = tokill
                result = hero
            end
        end
    end
    return result
end]]


function Orbwalking:OnTick()
    if not self.menu_keybin_enable.getValue() then return end

	if myHero.IsDead or IsTyping() or IsDodging() then return end

    local result = nil
    local mousePos = nil
    if self.menu_keybin_combo.getValue() then --or self.menu_keybin_lasthitKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_laneclearKey.getValue() then
    	result = self:GetTargetOrb()
    	mousePos = GetMousePos()
    end

    self:OrbWalk(result, mousePos)
end

function Orbwalking:ModeCombo()
	if IsValidTarget(self.forcetarget, GetTrueAttackRange()) then
        return self.forcetarget
    elseif self.forcetarget ~= nil then
        return nil
    end
    --/*Champions*/
    if not self.menu_keybin_lasthitKey.getValue() then
        local target = self.menu_ts:GetTarget(GetTrueAttackRange())
        if target ~= 0 then
            return target
        end
    end
end

function Orbwalking:ModeLastHit()
	--/*Killable Minion*/
	local result = nil
    local N = math.huge
    for i, minions in pairs(self:EnemyMinionsTbl()) do
        local minion = GetUnit(minions)
        --if self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
            if minions ~= 0 and GetType(minions) == 1 then
                --local time1 = self:WindUpTime() - 0.1 + self:GamePing() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr))  / self:GetMyProjectileSpeed() - 0.07
                --local time = self:WindUpTime() - 0.1 + self:GamePing() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr)) / self:GetMyProjectileSpeed()
                --local timeGetHealth = self:WindUpTime() + self:GamePing() + math.max(0, GetDistance(minion) - GetBoundingRadius(myHero.Addr)) / self:GetMyProjectileSpeed() - 0.07
                local timeGetHealth = self:WindUpTime() + math.max(0, GetDistance(minion.Addr)) / self:GetMyProjectileSpeed() - 0.07

                local PredictedHealth = self:GetHealthPrediction(minion, timeGetHealth, 0)-- self.menu_advanced_delayFarm.getValue())
                local damage = GetAADamageHitEnemy(minion.Addr)
                local tokill = PredictedHealth / damage

                if IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) and minion.TeamId ~= 300 then
                    if PredictedHealth < damage and PredictedHealth > - damage then
                        if (tokill < N or result == nil) then
                            N = tokill
                            result = minion.Addr
                        end

                    end
                    --[[if minion.HP < damage then
                        result = minion.Addr
                    end]]
                end
            end
        --end
    end
    return result
end

function Orbwalking:LaneClearMode()
	local result = nil
		for i, minions in pairs(self:EnemyMinionsTbl()) do
            if minions ~= 0  then --and GetType(minions.Addr) == 1 then
                local minion = GetUnit(minions)
                    if IsValidTarget(minion.Addr, GetTrueAttackRange()) and self:InAutoAttackRange(minion.Addr) then
                        if 1 / self:AnimationTimeOrb() >= 1.2 then
                            return minion.Addr
                        end
                    end
                    if not self:ShouldWait() then
                        if IsValidTarget(minion.Addr, GetTrueAttackRange()) and self:InAutoAttackRange(minion.Addr) then
                            local time2 = self:AnimationTimeOrb() + GetDistance(minion.Addr) / self:GetMyProjectileSpeed() - 0.07
                            local predHealth = self:LaneClearHealthPrediction(minion, time2 * 2)
                            if predHealth > 2 * GetAADamageHitEnemy(minion.Addr) then
                                result = minion.Addr
                            elseif self.menu_advanced_attackBarrels.getValue() then
                                    --if self.menu_keybin_combo.getValue() or self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
                                return self:AttackWard() or self:AttackGPBarrel()
                                    --end
                            end
                        end
                    end
                --end
            end
        end
        return result
end

function Orbwalking:BuildingMode()
	--/* turrets / inhibitors / nexus */
    if self.menu_keybin_laneclearKey.getValue() then
    	for i, minions in pairs(self:EnemyMinionsTbl()) do
            if minions ~= 0 then
                local minion = GetUnit(minions)
                if minion.Type == 2 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    return minion.Addr
                end
                if minion.Type == 4 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    return minion.Addr
                end
                if minion.Type == 5 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    return minion.Addr
                end
            end
        end
    end
end

function Orbwalking:JungleMode()
	--/*Jungle minions*/
    --if self.menu_keybin_laneclearKey.getValue() then

        for i, minions in ipairs(self:JungleTbl()) do
            table.sort(self:JungleTbl(), function(a, b)

            if self.menu_advanced_prioritizeSmallJungle.getValue() then
                return GetHealthPoint(a) < GetHealthPoint(b)
            end
            return GetHealthPoint(a) > GetHealthPoint(b)
        	end)

            if minions ~= 0 then
                local jungle = GetUnit(minions)
                if jungle.Type == 3 and jungle.TeamId == 300 and GetDistance(jungle.Addr) < GetTrueAttackRange() and
                    (GetObjName(jungle.Addr) ~= "PlantSatchel" and GetObjName(jungle.Addr) ~= "PlantHealth" and GetObjName(jungle.Addr) ~= "PlantVision") then
                    if IsValidTarget(jungle.Addr, GetTrueAttackRange()) and self:InAutoAttackRange(jungle.Addr) then
                        return jungle.Addr
                    end
                end
            end
        end
    --end
end

function Orbwalking:IsBaseTurret(turret)
	return self.BaseTurrets[turret.CharName] ~= nil;
end


function Orbwalking:GetTargetOrb()
    local result = nil
    --local i = 0
    --/*Killable Minion*/
    --[[local N = math.huge
    for i, minions in pairs(self:EnemyMinionsTbl()) do
        local minion = GetUnit(minions)
        if self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
            --if minions ~= 0  and IsEnemy(minions) and not IsDead(minions) and not IsInFog(minions) and (GetType(minions) == 1 or GetType(minions) == 2) then

                --local time1 = self:WindUpTime() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr))  / self:GetMyProjectileSpeed() - 0.07
                --local time = self:WindUpTime() - 0.1 + self:GamePing() + math.max(0, GetDistance(minion, myHero) - GetBoundingRadius(minion.Addr)) / self:GetMyProjectileSpeed()
                local timeGetHealth = self:WindUpTime() - 0.1 + self:GamePing() + math.max(0, GetDistance(minion) - GetBoundingRadius(myHero.Addr)) / self:GetMyProjectileSpeed()
                --local timeGetHealth = self:WindUpTime() + math.max(0, GetDistance(minion)) / self:GetMyProjectileSpeed() - 0.07

                local PredictedHealth = self:GetHealthPrediction(minion, timeGetHealth, 0)-- self.menu_advanced_delayFarm.getValue())
                local damage = GetAADamageHitEnemy(minion.Addr) --self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) + self:BonusDamage(minion)
                local tokill = PredictedHealth / damage

                if IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) and minion.TeamId ~= 300 then
                    if PredictedHealth < damage and PredictedHealth > - damage then
                        if (tokill < N or result == nil) then
                            N = tokill
                            result = minion.Addr
                        end

                    end
                    if minion.HP < damage then
                        result = minion.Addr
                    end
                end
            --end
        end
--/* turrets / inhibitors / nexus */
        if self.menu_keybin_laneclearKey.getValue() then
            --if minions ~= 0 then
                --local minion = GetUnit(minions)
                if minion.Type == 2 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    --__PrintTextGame("tru")
                    return minion.Addr
                end
                if minion.Type == 4 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    return minion.Addr
                end
                if minion.Type == 5 and IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                    return minion.Addr
                end
            --end
        end
--/*Lane Clear minions*/
        if self.menu_keybin_laneclearKey.getValue() then
            --if minions ~= 0  and IsEnemy(minions) and not IsDead(minions) and not IsInFog(minions) and (GetType(minions) == 1 or GetType(minions) == 2) then
                --local minion = GetUnit(minions)
                --if minion.Type == 1 then
                    if IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                        if 1 / self:AnimationTimeOrb() >= 1.2 then
                            --i = i + 1
                            --__PrintTextGame(tostring(i).."-->"..tostring(1 / self:AnimationTimeOrb()))
                            return minion.Addr
                        end
                    end
                    if not self:ShouldWait() then
                        --__PrintTextGame(tostring(IsValidTarget(minion.Addr, 1000)))
                        if IsValidTarget(minion.Addr, 1000) and self:InAutoAttackRange(minion.Addr) then
                            local time2 = self:AnimationTimeOrb() --+ GetDistance(minion) / self:GetMyProjectileSpeed() - 0.07
                            local predHealth = self:LaneClearHealthPrediction(minion, time2 * 2)
                            if predHealth > 2 * GetAADamageHitEnemy(minion.Addr) then --self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) then --or math.abs(minion.HP - predHealth) < 1E-12 then
                            	--__PrintTextGame(self:BonusDamage(minion))
                                result = minion.Addr
                            elseif self.menu_advanced_attackBarrels.getValue() then
                                    --if self.menu_keybin_combo.getValue() or self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
                                        return self:AttackWard() or self:AttackGPBarrel()
                                    --end
                            end
                        end
                    end
                --end
            --end
        end
    end

    --/*Jungle minions*/
    if self.menu_keybin_laneclearKey.getValue() then

        for i, minions in ipairs(self:JungleTbl()) do
            table.sort(self:JungleTbl(), function(a, b)

            if self.menu_advanced_prioritizeSmallJungle.getValue() then
                return GetHealthPoint(a) < GetHealthPoint(b)
            end
            return GetHealthPoint(a) > GetHealthPoint(b)
        end)

            if minions ~= 0 then
                local jungle = GetUnit(minions)

                if jungle.Type == 3 and jungle.TeamId == 300 and GetDistance(jungle.Addr) < GetTrueAttackRange() and
                    (GetObjName(jungle.Addr) ~= "PlantSatchel" and GetObjName(jungle.Addr) ~= "PlantHealth" and GetObjName(jungle.Addr) ~= "PlantVision") then
                    --__PrintDebug(jungle.TeamId .. "--".. GetChampName(jungle.Addr))
                    if IsValidTarget(jungle.Addr, 1000) and self:InAutoAttackRange(jungle.Addr) then
                        return jungle.Addr
                    end
                end
            end
        end
    end]]

    if IsValidTarget(self.forcetarget, GetTrueAttackRange()) then
        return self.forcetarget
    elseif self.forcetarget ~= nil then
        return nil
    end

    -- //GankPlank barrels and trap teemo jhin catlyn Illaoi
    --if self.menu_advanced_attackBarrels.getValue() then
    	--if self.menu_keybin_combo.getValue() or self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
    		--return self:AttackWard() --self:AttackGPBarrel() --or
    	--end
    --end

    --/*Champions*/
    if not self.menu_keybin_lasthitKey.getValue() then
        --if not self.menu_keybin_laneclearKey or not self:ShouldWait() then
            local target = self.menu_ts:GetTarget(GetTrueAttackRange()) --self:GetTarget(GetTrueAttackRange())--self.menu_ts:GetTarget(GetTrueAttackRange())
            --local target = TargetSelector:GetTarget()
            --if IsValidTarget(target, math.huge) and self:InAutoAttackRange(target) then
            if target ~= 0 then
                return target
            end
        --end
    end

    --/* UnderTurret Farming */
    --[[if self.menu_keybin_laneclearKey.getValue() or self.menu_keybin_harassKey.getValue() or self.menu_keybin_lasthitKey.getValue() then
        self:UnderTurretMode()
    end]]

    return result
end

function Orbwalking:AttackGPBarrel()
	--local result = nil
	local enemyGangPlank
	for i, enemy in pairs(GetEnemyHeroes()) do
        if enemy ~= 0 then
           enemyGangPlank = GetAIHero(enemy)
           if GetChampName(enemyGangPlank.Addr):lower() == "gangplank" then
                GetAllUnitAroundAnObject(myHero.Addr, 2000)
                for i, barrels in pairs(pUnit) do
                    if barrels ~= 0 then
                        barrel = GetUnit(barrels)
                        if  GetObjName(barrel.Addr) == "Barrel" and GetTeamId(barrel.Addr) == 300 and IsValidTarget(barrel.Addr, 1000) and self:InAutoAttackRange(barrel.Addr) then
                            if barrel.HP <= 1 then
                                --BasicAttack(barrel.Addr)
                                return barrel.Addr
                            end
                            --__PrintTextGame(string szText)
                            local t = self:WindUpTime() + math.max(0, GetDistance(barrel.Addr, myHero) - GetBoundingRadius(myHero.Addr))  / self:GetMyProjectileSpeed()

                            --pBuff = GetBuffByName(barrel.Addr, "gangplankebarrelactive")
                            barrelBuff = GetBuff(GetBuffByName(barrel.Addr, "gangplankebarrelactive"))
                            --barrelBuff = GetBuff(barrel.HasBuff("gangplankebarrelactive"))
                            --if barrelBuff ~= nil then
                                --__PrintTextGame(barrelBuff.BeginT.."-->"..tostring(enemyGangPlank.Level))
                            --end
                            --GetBuff(pBuff)
                            if barrelBuff ~= nil and barrel.HP <= 2 then
                                if enemyGangPlank.Level >= 13 then
                                    healthDecayRate = 0.5
                                elseif enemyGangPlank.Level >= 7 then
                                    healthDecayRate = 1
                                else
                                    healthDecayRate = 2
                                end

                                if GetLatency() < barrelBuff.BeginT + healthDecayRate then
                                    nextHealthDecayTime = barrelBuff.BeginT + healthDecayRate
                                else
                                    nextHealthDecayTime = barrelBuff.BeginT + healthDecayRate * 2
                                end
                                if nextHealthDecayTime <= GetLatency() + t / 1000 then
                                    return barrel.Addr
                                end
                            end
                        end
                    end
                end
            end
        end
    end


    --return result
end

function Orbwalking:AttackWard()
	--local result = nil
	GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, wards in pairs(pUnit) do
    	if wards ~= 0 then
    		ward = GetUnit(wards)
    		if ((string.find(string.lower(GetObjName(ward.Addr)), "ward")) ~= nil or GetObjName(ward.Addr) == "JammerDevice") and GetObjName(ward.Addr) ~= "WardCorpse"
    		and IsValidTarget(ward.Addr, 1000) and ward.IsEnemy and self:InAutoAttackRange(ward.Addr) then
	            return ward.Addr
	        end

	        if (GetObjName(ward.Addr) == "Noxious Trap" or GetObjName(ward.Addr) == "Jack In The Box") and IsValidTarget(ward.Addr, 1000) and self:InAutoAttackRange(ward.Addr) then
	            return ward.Addr
	        end

	        if ward.CharName == "IllaoiMinion" and IsValidTarget(ward.Addr, 1000) and self:InAutoAttackRange(ward.Addr) then
	            return ward.Addr
	        end
	    end
	end
	--return result
end

function Orbwalking:UnderTurretMode()
    local turretMinion = nil
    local farmUnderTurretMinion
    local noneKillableMinion
    --local result = UnderTurretFarming1()

    local closestTower = nil
    for i, turrent in ipairs(self:TurrentAlly()) do
        if turrent ~= 0 and GetDistance(turrent.Addr) < 1500 then
            closestTower = turrent
        end
    end

    for i,minions in ipairs(self:turretMinions()) do
        if self:HasTurretAggro(minions.Addr) then
            DrawCircleGame(closestTower.x , closestTower.y, closestTower.z, 200, Lua_ARGB(0, 255, 0, 0.3))
            --DrawCircleGame(minions.x , minions.y, minions.z, 200, Lua_ARGB(0, 255, 0, 0.3))
            turretMinion = minions        -- linh dang bi tru ban
        end

        if turretMinion ~= nil then
            local hpLeftBeforeDie = 0  -- mau linh truoc khi bi tru danh chet
            local hpLeft = 0    -- mau con lai cua linh
            local turretAttackCount = 0 -- so lan tru danh
            local turretStarTick = self:TurretAggroStartTick(turretMinion) -- thoi diem tru bat dau danh
            local turretLandTick = turretStarTick + self:getAttackCastDelay(closestTower) + (math.max(0, GetDistance(turretMinion.Addr, closestTower) - closestTower.CollisionRadius) / (self:GetProjectileSpeed(closestTower) + 0.07))

            for i= turretLandTick + 50, turretLandTick + 50 + 10 * self:getAttackDelay(closestTower.Addr), self:getAttackDelay(closestTower.Addr) do
                local time = i - self:GameTimeTickCount() + self:GamePing()
                if time > 0 then
                    time = time
                else
                    time = 0
                end

                local predHP = self:LaneClearHealthPrediction(turretMinion, time)
                if predHP > 0 then
                    hpLeft = predHP
                    turretAttackCount = turretAttackCount + 1
                else
                    return
                end
                hpLeftBeforeDie = hpLeft
                hpLeft = 0
                --__PrintTextGame("1-> "..tostring(hpLeft).." 2-> "..tostring(hpLeftBeforeDie).." 3->"..tostring(time).." 4->"..tostring(predHP).." 5->"..tostring(turretAttackCount))
                break
            end

            if hpLeft == 0 and turretAttackCount ~= 0 and hpLeftBeforeDie ~= 0 then
                local damage = GetAADamageHitEnemy(turretMinion.Addr) --self:CalcDamageOfAttack(myHero, turretMinion, {Name = "Basic"}, 0)
                local hits = hpLeftBeforeDie / damage
                local timeBeforeDie = turretLandTick + (turretAttackCount + 1) * self:getAttackDelay(closestTower.Addr) - self:GameTimeTickCount()

                if self.LastAATick + self:AnimationTimeOrb() > self:GameTimeTickCount() + 0.025 then --+ self:GamePing() then
                    timeUntilAttackReady = self.LastAATick + self:AnimationTimeOrb() - (self:GameTimeTickCount() + self:GamePing() + 0.025)
                else
                    timeUntilAttackReady = 0
                end

                if GetTrueAttackRange() < 300 then
                    timeToLandAttack = self:WindUpTime()
                else
                    timeToLandAttack = self:WindUpTime() + math.max(GetDistance(turretMinion.Addr) - myHero.CollisionRadius) / self:GetProjectileSpeed(myHero)
                end
                --__PrintTextGame("1-> "..tostring(damage).." 2-> "..tostring(hpLeftBeforeDie).." 3->"..tostring(timeBeforeDie).." 4->"..tostring(timeUntilAttackReady).." 5->"..tostring(timeToLandAttack))

                if hits >= 1 and hits * self:AnimationTimeOrb() + timeUntilAttackReady + timeToLandAttack < timeBeforeDie then
                    farmUnderTurretMinion = turretMinion-- as Obj_AI_Minion
                elseif hits >= 1 and hits * self:AnimationTimeOrb() + timeUntilAttackReady + timeToLandAttack > timeBeforeDie then
                    noneKillableMinion = turretMinion-- as Obj_AI_Minion
                    --__PrintDebug("noneKillableMinion-->"..tostring(noneKillableMinion))
                end
            elseif (hpLeft == 0 and  turretAttackCount == 0 and  hpLeftBeforeDie == 0) then
                noneKillableMinion = turretMinion
            end
            if self:ShouldWaitUnderTurret(noneKillableMinion) then
                --__PrintTextGame("noneKillableMinion")
                --__PrintTextGame("1")
                return nil
            end
                --__PrintTextGame(turretMinion)
                --__PrintDebug(GetChampName(farmUnderTurretMinion))
            if (farmUnderTurretMinion ~= 0) then
                --local farmUnderTurretMinionPos = Vector({GetPosX(farmUnderTurretMinion), GetPosY(farmUnderTurretMinion), GetPosZ(farmUnderTurretMinion)})
                --DrawCircleGame(farmUnderTurretMinionPos.x , farmUnderTurretMinionPos.y, farmUnderTurretMinionPos.z, 200, Lua_ARGB(255,255,0,0))
                --__PrintTextGame("2")
                return farmUnderTurretMinion
            --else
                --return UnderTurretFarming1()
            end
        elseif minions.NetworkId ~= GetIndex(turretMinion) and not self:HasMinionAggro(minions.Addr) then
            local leftHP = minions.HP % self:CalcDamageOfAttack(closestTower, minions, {Name = "Basic"}, 0)
            if leftHP > GetAADamageHitEnemy(minions.Addr) then --self:CalcDamageOfAttack(myHero, minions, {Name = "Basic"}, 5) then
                return minions.Addr
            end
        else
            if self:ShouldWaitUnderTurret(noneKillableMinion) then
                return nil
            end
            if closestTower ~= nil then
                for i,minion in pairs(self:turretMinions()) do
                    --local minion = GetUnit(minions)
                    if not self:HasMinionAggro(minion.Addr) then
                        local leftHP = minion.HP % self:CalcDamageOfAttack(closestTower, minion, {Name = "Basic"}, 0)
                        if leftHP > GetAADamageHitEnemy(minion.Addr) then --self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) then
                            --__PrintTextGame("444--> "..tostring(minion.HP).." turretMinion "..tostring(CalcDamageOfAttack(closestTower, minion, {Name = "Basic"}, 0)))
                            return minion.Addr
                        end
                    end
                end
            end
        end
    end
    return nil
end

function Orbwalking:EnemyMinionsTbl()
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    local result = {}
    for i, obj in pairs(pUnit) do
        if obj ~= 0  then
            local minions = GetUnit(obj)
            if IsEnemy(minions.Addr) and not IsDead(minions.Addr) and not IsInFog(minions.Addr) and (GetType(minions.Addr) == 1 or GetType(minions.Addr) == 2) then
                table.insert(result, minions.Addr)
            end
        end
    end

    table.sort(result, function(a, b)
                if GetChampName(a) ~= GetChampName(b) then
                    return GetChampName(a):find("Siege")
                end

                if GetChampName(a) ~= GetChampName(b) then
                    return GetChampName(a):find("Super")
                end

                return GetHealthPoint(a) < GetHealthPoint(b)
            end)
    return result
end


function Orbwalking:turretMinions()
    local result = {}
    local closestTower = nil
    for i, turrent in ipairs(self:TurrentAlly()) do
        if turrent ~= 0 and GetDistance(turrent.Addr) < 1500 then
            closestTower = turrent
        end
    end
    if closestTower ~= nil then
        for i, minion in ipairs(self:EnemyMinionsTbl()) do
            if minion ~= 0 then
                local minions = GetUnit(minion)
                if minions.Type == 1 then
                    if IsValidTarget(minions.Addr, 1000)
                        and self:InAutoAttackRange(minions.Addr)
                        and GetDistance(minions, closestTower.Addr) < 900 then

                        table.insert(result, minions)
                    end
                end
            end
        end
    end
    return result
end

function Orbwalking:TurrentAlly()
    GetAllUnitAroundAnObject(myHero.Addr, 4000)
    local result = {}

    for i, units in pairs(pUnit) do
        if units ~= 0  then
            turret = GetUnit(units)
            if not turret.IsEnemy and not turret.IsDead and turret.IsVisible and turret.Type == 2 then
                table.insert(result, turret)
            end
        end
    end
    return result
end

function Orbwalking:JungleTbl()
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    local result = {}
    for i, minions in pairs(pUnit) do
        if minions ~= 0 and not IsDead(minions) and not IsInFog(minions) and GetType(minions) == 3 then
            table.insert(result, minions)
        end
    end

    return result
end

--[[function Orbwalking:ShouldWait()
    --GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, minions in pairs(self:EnemyMinionsTbl()) do
            local minion = GetUnit(minions)
            if minion ~= 0 and not minion.IsDead then
            --local timeLaneClear = self:AnimationTimeOrb() -- + math.max(0, GetDistance(minion) - myHero.CollisionRadius) / self:GetMyProjectileSpeed()
            local timeLaneClear = self:AnimationTimeOrb() + GetDistance(minion, myHero) / self:GetMyProjectileSpeed() - 0.07
            --__PrintTextGame(InAutoAttackRange(minion.Addr))
            if IsValidTarget(minion.Addr, 1000) and minion.TeamId ~= 300 and self:InAutoAttackRange(minion.Addr) and
            	self:LaneClearHealthPrediction(minion, 2 * timeLaneClear) <= GetAADamageHitEnemy(minion.Addr) then --self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) + self:BonusDamage(minion) then
                return true
            end
        end
    end
    return false
end]]

function Orbwalking:ShouldWait()
	for i, minions in ipairs(self:EnemyMinionsTbl()) do
		local minion = GetUnit(minions)
		local timeLaneClear = self:AnimationTimeOrb() -- + GetDistance(minion.Addr) / self:GetMyProjectileSpeed() - 0.07
		if IsValidTarget(minion.Addr) and self:LaneClearHealthPrediction(minion, 2 * timeLaneClear) < GetAADamageHitEnemy(minion.Addr) then
			return true
		end
	end
end

function Orbwalking:ShouldWaitUnderTurret(noneKillableMinion)
    GetAllUnitAroundAnObject(myHero.Addr, 2000)
    for i, minions in pairs(pUnit) do
        if minions ~= 0 then
            --local minion = GetAIHero(minions)
            local minion = GetUnit(minions)
            if (noneKillableMinion ~= null and GetIndex(noneKillableMinion) ~= minion.NetworkId or true) and IsValidTarget(minion.Addr, 1000) and GetTeamId(minion.Addr) ~= 300 and self:InAutoAttackRange(minion.Addr) then
                --__PrintTextGame(tostring(noneKillableMinion).."<->"..tostring(GetIndex(noneKillableMinion.Addr)).."<->"..tostring(GetIndex(minions)).."<->"..
                    --tostring(IsValidTarget(minions, 1000)).."<->"..tostring(GetTeamId(minions)).."<->"..tostring(InAutoAttackRange(minions)))
                if GetTrueAttackRange() < 300 then
                    t = self:WindUpTime()
                else
                    t = self:WindUpTime() + (myHero.AARange + 2 * myHero.CollisionRadius) / self:GetMyProjectileSpeed()
                end
                local timeLaneClear = self:AnimationTimeOrb() + t
                 --__PrintTextGame(timeLaneClear.."<->"..tostring(LaneClearHealthPrediction(minion, timeLaneClear)).."<->"..tostring(CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0)))
                if self:LaneClearHealthPrediction(minion, timeLaneClear) <  GetAADamageHitEnemy(minion.Addr) then--self:CalcDamageOfAttack(myHero, minion, {Name = "Basic"}, 0) then
                    --__PrintTextGame("fffffffffffffff")
                    return true
                end
                --__PrintTextGame(tostring(time))
            end
        end
        --__PrintTextGame(tostring(noneKillableMinion).."<->"..tostring(GetIndex(noneKillableMinion)).."<->"..tostring(minion.NetworkId).."<->"..tostring(IsValidTarget(minion.Addr, 1000)).."<->"..tostring(minion.TeamId).."<->"..tostring(InAutoAttackRange(minion.Addr)))
    end
    return false
end

function Orbwalking:CalcDamageOfAttack(source, target, spell, additionalDamage)
    source = GetUnit(source)
    target = GetUnit(target)
    -- read initial armor and damage values
    local armorPenPercent = 1 --source.armorPenPercent
    local armorPen = 1 --source.ArmorPen
    local totalDamage = source.TotalDmg + (additionalDamage or 0)
    local damageMultiplier = spell.Name:find("CritAttack") and 2 or 1

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
