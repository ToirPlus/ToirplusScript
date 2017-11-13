--[[

Reference link https://github.com/Dienofail/BoL/blob/master/Sivir.lua

Thanks Dienofail

]]

IncludeFile("Lib\\Vector.lua")

--__PrintDebug("Sirvir")



function UpdateHeroInfo()
	return GetMyChamp()
end





local Q = 0
local W = 1
local E = 2
local R = 3

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86


local HarassUseMana = 60
local LaneClearUseMana = 60

local SpellQ = {Speed = 1350, Range = 1075, Delay = 0.250, Width = 85}
local SpellQ2 = {Speed = 1350, Range = 1100, Delay = 1.04, Width = 90}

E_SPELLS = { -- Yea boiz and grillz its all right here.......
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
	return GetEnemyChampCanKillFastest(1100)
end

function OnLoad()
	__PrintTextGame("Sivir v1.0 loaded")
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

function OnTick()
	if GetChampName(UpdateHeroInfo()) ~= "Sivir" then return end

	if IsDead(UpdateHeroInfo()) then return end

	local nKeyCode = GetKeyCode()

	if nKeyCode == SpaceKeyCode then
		SetLuaCombo(true)
		Combo()
	end

	if nKeyCode == CKeyCode then
		SetLuaHarass(true)
		Harass()
	end

	if nKeyCode == VKeyCode then
		Farm()
	end


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

function Combo()

	if Setting_IsComboUseE() then
		if EReady() then
			AutoE()
		end
	end

	local Target = GetTarget()

	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsComboUseQ() and CanMove() then
				if QReady() and GetDistance(Target) < SpellQ.Range then
					CastQ(Target)
				end
			end
		end
	end

	Target = GetTarget()
	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsComboUseW() then
				if WReady() and GetDistance(Target) < 600 then
					CastSpellTarget(UpdateHeroInfo(), W)
				end
			end
		end
	end

	Target = GetTarget()

	KS(Target)

end

function AutoE()
	SearchAllChamp()
	local Enemies = pObjChamp
	for i, enemy in ipairs(Enemies) do
		if enemy ~= 0 then
			if ValidTargetRange(enemy, 1500) and GetDistance(enemy) >= 475 then
				local spell = GetSpellCasting(enemy)
				if spell ~= 0 then
					--__PrintDebug(GetName_Casting(spell))
					if E_SPELLS[GetName_Casting(spell)] then
						CastSpellTarget(UpdateHeroInfo(), E)
					end
				end
			end
		end
	end
end

function KS(Target)
	if Target ~= 0 then
		if QReady() and CanMove() and getDmg(Q, Target) > GetHealthPoint(Target) then
			CastQ(Target)
		end
	end
end

function Harass()
	local Target = GetTarget()

	if Target ~= 0 then
		if ValidTarget(Target) then
			if Setting_IsHarassUseQ() and CanMove() then
				if QReady() and GetDistance(Target) < SpellQ.Range then
					CastQ(Target)
				end
			end
		end
	end
end

function CastQ(Target)
	if Target ~= 0 and ValidTarget(Target, SpellQ.Range) and QReady() and CanMove() then
		local vp_distance = VPGetLineCastPosition(Target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
		if vp_distance > 0 and vp_distance < SpellQ.Range then
			CastSpellToPredictionPos(Target, Q, vp_distance)
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


function IsMyManaLowHarass()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( HarassUseMana / 100)) then
        return true
    else
        return false
    end
end

function IsMyManaLowLaneClear()
    if GetManaPoint(UpdateHeroInfo()) < (GetManaPointMax(UpdateHeroInfo()) * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
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

function Farm()
	local jungle = GetJungleMonster(1100)
	if jungle ~= 0 then
		if QReady() and not IsMyManaLowLaneClear() and CanMove() then
			if ValidTargetJungle(jungle) and GetDistance(jungle) < SpellQ.Range then
				local vp_distance = VPGetLineCastPosition(jungle, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
				if vp_distance > 0 and vp_distance < SpellQ.Range then
					CastSpellToPredictionPos(jungle, Q, vp_distance)
				end
			end
		end

		jungle = GetJungleMonster(1100)
		if jungle ~= 0 then
			if WReady() and not IsMyManaLowLaneClear() then
				if ValidTargetJungle(jungle) and GetDistance(jungle) < SpellQ.Range then
					CastSpellTarget(UpdateHeroInfo(), W)

				end
			end
		end

	end

	if QReady() and Setting_IsLaneClearUseQ() and not IsMyManaLowLaneClear() and CanMove() then
		FarmQ()
	end

	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1100)
	local Enemies = pUnit
	if WReady() and table.getn(Enemies) > 3 and Setting_IsLaneClearUseW() and not IsMyManaLowLaneClear() then
		CastSpellTarget(UpdateHeroInfo(), W)
	end
end


function FarmQ()
	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1100)

	local Enemies = pUnit

	if QReady() and table.getn(Enemies) > 0 and CanMove() then
		local QPos = GetBestQPositionFarm()

		if QPos then
			local vp_distance = VPGetLineCastPosition(QPos, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed)
			if vp_distance > 0 and vp_distance < SpellQ.Range then
				CastSpellToPredictionPos(QPos, Q, vp_distance)
			end
		end
	end
end

function GetBestQPositionFarm()
	local MaxQ = 0
	local MaxQPos
	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1100)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local hitQ = countminionshitQ(minion)
				if hitQ > MaxQ or MaxQPos == nil then
					MaxQPos = minion
					MaxQ = hitQ
				end
			end
		end
	end

	if MaxQPos then
		return MaxQPos
	else
		return nil
	end
end

function VectorPointProjectionOnLineSegment(v1, v2, v)
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = { x = ax + rL * (bx - ax), z = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), z = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

function countminionshitQ(obj)
	local n = 0

	local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }
    local objPos = { GetPosX(obj), GetPosY(obj), GetPosZ(obj) }

	local myHeroVector = Vector(myHeroPos)
    local objVector = Vector(objPos)

	local distanceToObj = myHeroVector:DistanceTo(objVector)
    local endPos = myHeroVector:Extend(objVector, distanceToObj)

	GetAllUnitAroundAnObject(UpdateHeroInfo(), 1100)

	local Enemies = pUnit
	for i, minion in pairs(Enemies) do
		if minion ~= 0 then
			if IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
				local targetPos = { GetPosX(minion), GetPosY(minion), GetPosZ(minion) }
				local MinionPointSegment, MinionPointLine, MinionIsOnSegment =  VectorPointProjectionOnLineSegment(myHeroVector, endPos, Vector(targetPos))
				local MinionPointSegment3D = {x=MinionPointSegment.x, y=GetPosY(obj), z=MinionPointSegment.y}
				if MinionIsOnSegment and GetDistance2D(MinionPointSegment3D.x, MinionPointSegment3D.z, GetPosX(obj), GetPosZ(obj)) < SpellQ.Width then
					n = n +1
				end
			end
		end
	end
	return n
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == Q then
		if GetSpellLevel(UpdateHeroInfo(),Q) == 0 then return 0 end

		local DamageSpellQTable = {35, 55, 75, 95, 115}

		local PercentDamageSpellQTable = {70, 80, 90, 100, 110}

		local Percent_AD_Bonus = PercentDamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),Q)]
		local Damage_AD = GetFlatPhysicalDamage(UpdateHeroInfo()) + GetBaseAttackDamage(UpdateHeroInfo())

		local Damage_AP = GetFlatMagicDamage(UpdateHeroInfo()) + GetFlatMagicDamage(UpdateHeroInfo()) * GetPercentMagicDamage(UpdateHeroInfo())
		local Percent_AP = 0.5

		local DamageSpellQ = DamageSpellQTable[GetSpellLevel(UpdateHeroInfo(),Q)] + Damage_AD * Percent_AD_Bonus / 100 + Percent_AP * Damage_AP

		local Enemy_Armor = GetArmor(Enemy)

		local Dominik_ID = 3036--Lord Dominik's Regards
		local Mortal_Reminder_ID = 3033--Mortal Reminder

		if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
			Enemy_Armor = Enemy_Armor - GetBonusArmor(Enemy) * 45/100
		end

		local ArmorPenetration = 60 * GetArmorPenetration(UpdateHeroInfo()) / 100 + (1 - 60/100) * GetArmorPenetration(UpdateHeroInfo()) * GetLevel(Enemy) / 18

		Enemy_Armor = Enemy_Armor - ArmorPenetration

		if Enemy_Armor >= 0 then
			Damage = DamageSpellQ * (100/(100 + Enemy_Armor))
		else
			Damage = DamageSpellQ * (2 - 100/(100 - Enemy_Armor))
		end


		return Damage
	end
end
