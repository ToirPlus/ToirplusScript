--[[

Reference link https://raw.githubusercontent.com/tungkh1711/bolscript/master/Sejuani-Montage.lua

Thanks Celtech team

]]

IncludeFile("Lib\\AllClass.lua")
IncludeFile("Lib\\VPrediction.lua")
IncludeFile("Lib\\DamageLib.lua")

SetPrintErrorLog(false)

myHero = GetMyHero()
player = myHero

local VP = nil
local VPHitChance = 0

local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra", "Rakan", "Ornn"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Sejuani",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne", "Xayah", "Zoe"},
}

VP = VPrediction()

local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)

Q = {Slot = _Q, DamageName = "Q", Range = 900, Width = 50,  Delay = 0.25,  Speed = 1700,       Collision = true, Aoe = false}
W = {Slot = _W, DamageName = "W", Range = 600, Width = 0,   Delay = 0,     Speed = math.huge,  Collision = false, Aoe = false}
E = {Slot = _E, DamageName = "E", Range = 800, Width = 40,  Delay = 0.25,  Speed = 1700,       Collision = true, Aoe = false}
R = {Slot = _R, DamageName = "R", Range = 575, Width = 0,   Delay = 0,     Speed = math.huge,  Collision = false, Aoe = true}

local LaneClearUseMana = 20

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

AddTickCallback(function () Tick() end)

function KillSteal()
  for i, Target in pairs(GetEnemyHeroes()) do
    if Target and ValidTarget(Target) then
      if not Target.IsDead and Target.IsVisible then      
        if CanCast(_Q) and getDmg(_Q, Target) > Target.HP and CanMove() then
          CastQ(Target)
        end
        
        if CanCast(_E) and getDmg(_E, Target) > Target.HP and CanMove() then
          CastE(Target)
        end       

        if CanCast(_R) and CanCast(_Q) and getDmg(_Q, Target) > Target.HP and CanMove() and GetDistance(Target) < Q.Range + R.Range then
          CastR(Target)
        end
        
        if CanCast(_R) and CanCast(_E) and getDmg(_E, Target) > Target.HP and CanMove() and GetDistance(Target) < E.Range + R.Range then
          CastR(Target)
        end

      end
    end
  end
end

function CheckDashes()
  for i, Target in pairs(GetEnemyHeroes()) do
    if Target and ValidTarget(Target) then
      if CanCast(_R) and Target.Distance < 260 and CanMove() and IsDashing(Target.Addr) then
        if not IsWall(Target.x,Target.y,Target.z) then
          CastSpellToPos(Target.x + R.Range, Target.z, _R)
        end
        if not IsWall(Target.x,Target.y,Target.z + R.Range) then
          CastSpellToPos(Target.x, Target.z + R.Range, _R)
        end
      end
    end
  end
end

function Tick()
	myHero = GetMyHero()
  player = myHero
	if myHero.CharName ~= "Zoe" then return end
  
	if IsTyping() then return end
	if myHero.IsDead then return end	
	if _G.evade then return end
	
	EnemyMinions:update()
  JungleMinions:update()

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

--  if GetKeyPress(CKeyCode) == 1 then
--    SetLuaHarass(true)
--    Farm()
--  end

	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)		
		Clear()
	end

	KillSteal()
	--AutoW()
	CheckDashes()
end

function CastR(Target)
  if CanCast(_R) and ValidTarget(Target) then
    if (CanCast(_Q) or CanCast(_E)) and GetDistance(Target) < Q.Range + R.Range and GetDistance(Target) > Q.Range then
      local CastPosition = Vector(myHero) + Vector(Vector(Target) - Vector(myHero)):normalized() * R.Range
      if not IsWall(CastPosition.x,CastPosition.y,CastPosition.z) then
        CastSpellToPos(CastPosition.x, CastPosition.z, _R)     
      end
    end       
  end
end

function CastQ(Target)  
  if CanCast(_Q) and ValidTarget(Target) then    
    local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, Q.Delay, Q.Width, Q.Range, Q.Speed, myHero, false)
    local CastPosition2 = Vector(CastPosition) + Vector(Vector(myHero) - Vector(CastPosition)):normalized() * Q.Range * 1.5
    --print("Q HitChance=" .. tostring(HitChance))
    if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Q.Range then
      CastSpellToPos(CastPosition2.x, CastPosition2.z, _Q)
      DelayAction(function() CastSpellToPos(CastPosition.x, CastPosition.z, _Q) end, 0.25)
    end
  end
end

function CastE(Target)
  if ValidTarget(Target) and CanCast(_E) then
    local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, E.Delay, E.Width, E.Range, E.Speed, myHero, false)
    --print("E HitChance=" .. tostring(HitChance))    
    if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= E.Range then
      CastSpellToPos(CastPosition.x, CastPosition.z, _E)
    end    
  end
end

function CastW(Target)  
    if CanCast(_W) and ValidTarget(Target) then
      
    end
end

function AutoW()
  if CanMove() and CanCast(_W) then
    CastSpellTarget(myHero.Addr, _W) 
  end
end

function Combo()
  local Target = GetCustomTarget()      
  if Target ~= nil and ValidTarget(Target) and not Target.IsDead and Target.IsVisible then
    if CanMove() and Setting_IsComboUseR() then
      CastR(Target)
    end
  
    if CanMove() and Setting_IsComboUseQ() then
      CastQ(Target)
    end  

    if CanMove() and Setting_IsComboUseE() then
      CastE(Target)
    end            
    
  end
end

function Clear()
  FarmClear()
  JungClear()
end

function FarmClear()
   for _, minion in pairs(EnemyMinions.objects) do
    if minion and Setting_IsLaneClearUseQ() and CanCast(_Q) and ValidTarget(minion) and getDmg(_Q,minion) > minion.HP and not IsMyManaLowLaneClear() then
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, Q.Delay, Q.Width, Q.Range, Q.Speed, myHero, false)
      local CastPosition2 = Vector(CastPosition) + Vector(Vector(myHero) - Vector(CastPosition)):normalized() * Q.Range
      if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Q.Range then
        CastSpellToPos(CastPosition2.x, CastPosition2.z, _Q)
        DelayAction(function() CastSpellToPos(CastPosition.x, CastPosition.z, _Q) end, 0.25)
      end
    end    
  end
end

function GetJungle()
  for _, minion in pairs(JungleMinions.objects) do
    if ValidTarget(minion) then
      return minion
    end
  end
end

function JungClear()
  local JungleMob = GetJungle()
  if JungleMob ~= nil then
    if Setting_IsLaneClearUseQ() and CanCast(_Q) and GetDistance(JungleMob) < Q.Range and CanMove() and not IsMyManaLowLaneClear() then
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(JungleMob, Q.Delay, Q.Width, Q.Range, Q.Speed, myHero, false)
      local CastPosition2 = Vector(CastPosition) + Vector(Vector(myHero) - Vector(CastPosition)):normalized() * Q.Range * 1.5
      if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Q.Range then
        CastSpellToPos(CastPosition2.x, CastPosition2.z, _Q)
        DelayAction(function() CastSpellToPos(CastPosition.x, CastPosition.z, _Q) end, 0.25)
      end
    end
    if Setting_IsLaneClearUseE() and CanCast(_E) and GetDistance(JungleMob) < E.Range and CanMove() and not IsMyManaLowLaneClear() then
        CastSpellToPos(JungleMob.x, JungleMob.z, _E)
    end
  end
end

function IsMyManaLowLaneClear()
    if myHero.MP < (myHero.MaxMP * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function GetCustomTarget()
  local enemy = GetTarget2(1500)
    if enemy then return enemy end
end

function GetTarget2(range)
  SearchAllChamp()
  local Enemies = pObjChamp
  for i, enemy in pairs(Enemies) do
    if enemy ~= 0 and ValidTargetRange(enemy,range) then
      if priorityTable.p1[GetChampName(enemy)] then
        return GetAIHero(enemy)
      end
      if priorityTable.p2[GetChampName(enemy)] then
        return GetAIHero(enemy)
      end
      if priorityTable.p3[GetChampName(enemy)] then
        return GetAIHero(enemy)
      end
      if priorityTable.p4[GetChampName(enemy)] then
        return GetAIHero(enemy)
      end
      if priorityTable.p5[GetChampName(enemy)] then
        return GetAIHero(enemy)
      end
    end
  end

  local target = GetEnemyChampCanKillFastest(range)
  if target ~= 0 then
    return GetAIHero(target)
  end
  return nil
end

function ValidTargetRange(Target, Range)
  local enemy = GetAIHero(Target)
  if ValidTarget(enemy) and GetDistance(enemy) < Range then
    return true
  end
  return false
end

function getDmg(Spell, Enemy)
  local Damage = 0
  if Spell == _Q then
    if myHero.LevelSpell(_Q) == 0 then return 0 end
    local DamageSpellQTable = {0, 30, 60, 90, 120}
    local Percent_AP = 0.68
    local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent
    local DamageSpellQ = DamageSpellQTable[myHero.LevelSpell(_Q)]
    local Enemy_SpellBlock = Enemy.MagicArmor
    
    local DamageSpellQBaseTable = {58,60,63,67,72,76,82,88,95,102,110,118,127,136,147,157,168,180}

    local Void_Staff_Id = 3135 -- Void Staff Item
    if GetItemByID(Void_Staff_Id) > 0 then
      Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
    end

    Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen
    if Enemy_SpellBlock >= 0 then
      Damage = (DamageSpellQBaseTable[myHero.Level] + DamageSpellQ + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
    else
      Damage = (DamageSpellQBaseTable[myHero.Level] + DamageSpellQ + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
    end
    return Damage
  end

  if Spell == _E then
    if myHero.LevelSpell(_E) == 0 then return 0 end
    local DamageSpellETable = {60, 100, 140, 180, 220}
    local Percent_AP = 0.4
    local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent
    local DamageSpellE = DamageSpellETable[myHero.LevelSpell(_E)]
    local Enemy_SpellBlock = Enemy.MagicArmor

    local Void_Staff_Id = 3135 -- Void Staff Item
    if GetItemByID(Void_Staff_Id) > 0 then
      Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
    end

    Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen
    if Enemy_SpellBlock >= 0 then
      Damage = (DamageSpellE + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
    else
      Damage = (DamageSpellE + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
    end

    return Damage
  end
  
end
