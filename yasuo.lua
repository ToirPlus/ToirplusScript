--[[

Reference link https://github.com/nebelwolfi/BoL/blob/master/SPlugins/Yasuo.lua

]]

IncludeFile("Lib\\AllClass.lua")
IncludeFile("Lib\\VPrediction.lua")
IncludeFile("Lib\\DamageLib.lua")

SetPrintErrorLog(false)

myHero = GetMyHero()
player = myHero

local VP = VPrediction()
local passiveTracker = false
local passiveName = "yasuoq3w"

data = {
      [_Q] = { range = 500, speed = math.huge, delay = 0.125, width = 55, type = "linear", dmgAD = function(AP, level, Level, TotalDmg, source, target) return 20*level+TotalDmg-10 end},
      [_W] = { range = 350},
      [_E] = { range = 475, dmgAP = function(AP, level, Level, TotalDmg, source, target) return 50+20*level+AP end},
      [_R] = { range = 1200, dmgAD = function(AP, level, Level, TotalDmg, source, target) return 100+100*level+1.5*TotalDmg end},
      [-2] = { range = 1200, speed = 1200, delay = 0.125, width = 65, type = "linear" }
    }

local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra", "Rakan", "Ornn"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Sejuani",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne", "Xayah", "Zoe"},
}

local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local config_AutoW = true
local config_Flee = true
if myHero.CharName == "Yasuo" then
  config_AutoW  = AddMenuCustom(1, config_AutoW, "Auto W")
  config_Flee  = AddMenuCustom(2, config_Flee, "Flee by C hot key")
end

AddTickCallback(function() Tick() end)
AddUpdateBuffCallback(function(unit, buff, stacks) UpdateBuff(unit, buff, stacks) end)
AddRemoveBuffCallback(function(unit, buff) RemoveBuff(unit, buff) end)
AddProcessSpellCallback(function(unit, spell) ProcessSpell(unit, spell) end) 

function GetCustomTarget()
  local enemy = GetTarget(1500)
  if enemy then return enemy end
end

function ValidTargetRange(Target, Range)
  local enemy = GetAIHero(Target)
  if ValidTarget(enemy) and GetDistance(enemy) < Range then
    return true
  end
  return false
end

function GetTarget(range)
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

function GetStacks(o)
  if o.HasBuff("YasuoDashWrapper") then
    return 1
  end
  return 0
end

function Move(x)
  if CanCast(_E) then
    local minion = nil
    EnemyMinions:update()
    for _,k in pairs(EnemyMinions.objects) do
      local kPos = myHero+(Vector(k)-myHero):normalized()*data[2].range
      if not minion and k and GetStacks(k) == 0 and GetDistanceSqr(k) < data[2].range*data[2].range and GetDistanceSqr(kPos,x) < GetDistanceSqr(myHero,x) then minion = k end
      if minion and k and GetStacks(k) == 0 and GetDistanceSqr(k) < data[2].range*data[2].range then
        local mPos = myHero+(Vector(minion)-myHero):normalized()*data[2].range
        if GetDistanceSqr(mPos,x) < GetDistanceSqr(kPos,x) and GetDistanceSqr(mPos,x) < GetDistanceSqr(myHero,x) then
          minion = k
        end
      end
    end
    if minion then
      CastE(minion)
      return true
    end
    return false
  end
end

function CastE(Target)
  if GetDistance(Target) < data[2].range then
    CastSpellTarget(Target.Addr, _E)
  end
end

function CastQ(Target)
  if GetDistance(Target) < data[0].range then
    CastSpellToPos(Target.x, Target.z, _Q)
  end
end
  
function Combo()
  local Target = GetCustomTarget()  
  if Target ~= nil and ValidTarget(Target) then
    if GetDistance(Target) > myHero.AARange and Setting_IsComboUseE() then
      if Move(Target) then
        if CanCast(_Q) and Setting_IsComboUseQ() then
          DelayAction(function() CastQ(Target) end, 0.125)
        end
      elseif GetDistance(Target) < data[2].range and GetDistance(Target) > data[2].range/2 and GetStacks(Target) == 0 then
        CastE(Target)
        if CanCast(_Q) and Setting_IsComboUseQ() then
          DelayAction(function() CastQ(Target) end, 0.125)
        end
      end
    end    
    
    if CanCast(_R) and Setting_IsComboUseR() and Target.y > myHero.y+5 or Target.y < myHero.y-5 then
      if CanCast(_Q) and GetDistance(Target) < 500 then
        SetLuaBasicAttackOnly(true)
        BasicAttack(Target.Addr)
        SetLuaBasicAttackOnly(false)
      else
        CastSpellTarget(Target.Addr,_R)
      end
    end
    
    if CanCast(_E) and Setting_IsComboUseE() and passiveTracker and GetDistance(Target) < data[2].range then
      CastE(Target)
    end
    
    if CanCast(_Q) and Setting_IsComboUseQ() then
      if passiveTracker and GetDistance(Target) < 1200 then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, data[-2].delay, data[-2].width, data[-2].range, data[-2].speed, myHero, false)
        if HitChance >= 2 and GetDistance(CastPosition) <= data[-2].range then
          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
        end
      elseif GetDistance(Target) < 500 then
        if CanMove() then
          CastQ(Target)
        end
      end
    end
  end  
end
 
function UpdateBuff(unit,buff,stacks)
  if unit and unit.IsMe and buff.Name:lower() == passiveName then
    passiveTracker = true
  end
end

function RemoveBuff(unit,buff)
  if unit and unit.IsMe and buff.Name:lower() == passiveName then
    passiveTracker = false
  end
end

function GetDmgADAttackMe(unit)
  unit = GetAIHero(unit.Addr)
  local myArmor = myHero.Armor
  local Damage = 0
    
  local Dominik_ID = 3036--Lord Dominik's Regards
  local Mortal_Reminder_ID = 3033--Mortal Reminder

  if unit.HasItem(Dominik_ID) > 0 or unit.HasItem(Mortal_Reminder_ID) > 0 then
    myArmor = myArmor - myArmor.BonusArmor * 45/100
  end 

  local ArmorPenetration = 60 * unit.ArmorPen / 100 + (1 - 60/100) * unit.ArmorPen * myHero.Level / 18
  myArmor = myArmor - ArmorPenetration
  if myArmor >= 0 then
    Damage = unit.TotalDmg * (100/(100 + myArmor))
  else
    Damage = unit.TotalDmg * (2 - 100/(100 - myArmor))
  end
  
  return Damage
end

function ProcessSpell(unit, spell)
  if config_AutoW and unit and unit.TeamId ~= myHero.TeamId and myHero.CharName == "Yasuo" and unit.Type == myHero.Type and GetDistance(unit) < 1500 then
    spell.target = GetTargetFromTargetId(spell.TargetId)
    spell.endPos = {x=spell.DestPos_x, y=spell.DestPos_y, z=spell.DestPos_z}
    local spell_slot_name = ""
    if spell.Slot == _Q then spell_slot_name = "Q" end
    if spell.Slot == _W then spell_slot_name = "W" end
    if spell.Slot == _E then spell_slot_name = "E" end
    if spell.Slot == _R then spell_slot_name = "R" end
    if myHero == spell.target and spell.Name:lower():find("attack") and (unit.AARange >= 450 or unit.IsRanged) and GetDmgADAttackMe(unit)/myHero.MaxHP > 0.1337 then
      local wPos = myHero + (Vector(unit) - myHero):normalized() * data[1].range 
      CastSpellToPos(wPos.x, wPos.z, _W)
    elseif spell.endPos and not spell.target and not _G.evade then
      local makeUpPos = unit + (Vector(spell.endPos)-unit):normalized()*GetDistance(unit)
      if GetDistance(makeUpPos) < myHero.CollisionRadius*3 or GetDistance(spell.endPos) < myHero.CollisionRadius*3 then
        local wPos = myHero + (Vector(unit) - myHero):normalized() * data[1].range 
        CastSpellToPos(wPos.x, wPos.z, _W)
      end
    end
  end
end

function GetLowestMinion(range)
  local closest_distance = range
  local closest_minion = nil
  for _,minion in pairs(EnemyMinions.objects) do
    if GetDistanceSqr(minion) < range*range and GetStacks(minion) == 0 and ValidTarget(minion) then
      if GetDistance(minion) < closest_distance then
        closest_distance = GetDistance(minion)
        closest_minion = minion
      end
    end
  end  
  if closest_minion then return closest_minion end
end

function NearTower()
  GetAllUnitAroundAnObject(myHero.Addr, 1400)
  for i, obj in pairs(pUnit) do
    if obj ~= 0 then
      local tower = GetUnit(obj)
      if tower and ValidTarget(tower) and tower.Type == 2 and GetDistance(tower) < 915 + 475 then
        return true
      end
    end
  end
  return false
end

function LastHit()
  local minion = GetLowestMinion(data[2].range)  
  if minion and GetStacks(minion) == 0 and minion.HP < GetDamage("E", minion) and CanCast(_E) and not UnderTurret(minion) and not NearTower() then
    CastE(minion)
  end
  if minion and GetStacks(minion) == 0 and minion.HP < GetDamage("Q", minion)+GetDamage("E", minion) and CanCast(_Q) and CanCast(_E) and not UnderTurret(minion) and not NearTower() then
    CastE(minion)
    DelayAction(function() CastQ(minion) end, 0.125)
  end      
  LastHitQ3()
end

function LastHitQ3()
  --Harass
  if passiveTracker then
    local Target = GetCustomTarget()  
    if Target ~= nil and ValidTarget(Target) and CanCast(_Q) then
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(Target, data[-2].delay, data[-2].width, data[-2].range, data[-2].speed, myHero, false)
      if HitChance >= 2 and GetDistance(CastPosition) <= data[-2].range then
        CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
        return
      end
    end
    --Last hit Q3
    for _,minion in pairs(EnemyMinions.objects) do
      if minion and ValidTarget(minion) and GetDistance(minion) < 1200 and minion.HP < GetDamage("Q", minion) and CanCast(_Q) then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(minion, data[-2].delay, data[-2].width, data[-2].range, data[-2].speed, myHero, false)
        if HitChance >= 2 and GetDistance(CastPosition) <= data[-2].range then
          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
        end
      end
    end
  end  
end

function GetJungle()
  for _, jungle in pairs(JungleMinions.objects) do
    if ValidTarget(jungle) then
      return jungle
    end
  end
end

function JungClear()
  local JungleMob = GetJungle()
  if JungleMob ~= nil then
      if Setting_IsLaneClearUseQ() and CanCast(_Q) and GetDistance(JungleMob) < data[0].range and CanMove() then
          CastSpellToPos(JungleMob.x, JungleMob.z, _Q)
      end
      if Setting_IsLaneClearUseE() and CanCast(_E) and GetDistance(JungleMob) < data[2].range and CanMove() then
          CastSpellTarget(JungleMob.Addr, _E)         
      end
      
      if passiveTracker and CanCast(_Q) then
        local CastPosition, HitChance, Position = VP:GetLineCastPosition(JungleMob, data[-2].delay, data[-2].width, data[-2].range, data[-2].speed, myHero, false)
        if HitChance >= 2 and GetDistance(CastPosition) <= data[-2].range then
          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
        end
      end
    end
end

function Farm()
  for _,minion in pairs(EnemyMinions.objects) do
    if minion and ValidTarget(minion) and not passiveTracker and GetDistance(minion) < 500 and minion.HP > GetDamage("Q", minion) and CanCast(_Q) then
      CastQ(minion)
    end
  end
end

function Tick()
  myHero = GetMyHero()
  player = myHero
  if myHero.CharName ~= "Yasuo" then return end
  
  if IsTyping() then return end
  if myHero.IsDead then return end  
  if _G.evade then return end
  
  if config_Flee and GetKeyPress(CKeyCode) == 1 then
    local mousePos = Vector(GetMousePos())
    MoveToPos(mousePos.x,mousePos.z)
    Move(mousePos)
  end
  
  if passiveTracker then
    data[0].range = 1200
  else
    data[0].range = 500
  end
    
  if GetKeyPress(SpaceKeyCode) == 1 then
    SetLuaCombo(true)
    Combo()
  end
  
  if GetKeyPress(VKeyCode) == 1 then
    SetLuaLaneClear(true)
    EnemyMinions:update()
    JungleMinions:update()
    Farm()
    LastHit()
    JungClear()
  end

  Killsteal()
end

function Killsteal()
    for k,enemy in pairs(GetEnemyHeroes()) do
      if ValidTarget(enemy) and enemy ~= nil and not enemy.IsDead then
        if enemy.y > myHero.y+25 and GetDmg(_R,enemy) > enemy.HP and GetDistance(enemy) < data[3].range then
          CastSpellTarget(enemy.Addr,_R)
        elseif GetDmg(_Q,enemy) > enemy.HP and GetDistance(enemy) < data[0].range then
          CastQ(enemy)
        elseif passiveTracker and GetDmg(_Q,enemy) > enemy.HP and GetDistance(enemy) < 1200 then
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(enemy, data[-2].delay, data[-2].width, data[-2].range, data[-2].speed, myHero, false)
          if HitChance >= 2 and GetDistance(CastPosition) <= data[-2].range then
            CastSpellToPos(CastPosition.x, CastPosition.z, _Q)            
          end
        elseif GetDmg(_E,enemy) > enemy.HP and GetDistance(enemy) < data[2].range then
          CastE(enemy)
        elseif GetDmg(_Q,enemy)+GetDmg(_E,enemy) > enemy.HP and GetDistance(enemy) < data[2].range then
          CastE(enemy)
          DelayAction(function() CastQ(enemy) end, 0.25)
        end
      end
    end
  end
  
function getDmg(Spell, Enemy)
  local Damage = 0

  if Spell == _Q then
    if myHero.LevelSpell(_Q) == 0 then return 0 end    
    local Percent_AD = 1
    local Damage_AD = myHero.TotalDmg
    local DamageSpellQTable = {20, 40, 60, 80, 100}
    local DamageSpellQ = DamageSpellQTable[myHero.LevelSpell(_Q)]
    local Enemy_Armor = Enemy.Armor
    local Dominik_ID = 3036--Lord Dominik's Regards
    local Mortal_Reminder_ID = 3033--Mortal Reminder
    if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
      Enemy_Armor = Enemy_Armor - Enemy.BonusArmor * 45/100
    end

    local ArmorPenetration = 60 * myHero.ArmorPen / 100 + (1 - 60/100) * myHero.ArmorPen * Enemy.Level / 18
    Enemy_Armor = Enemy_Armor - ArmorPenetration
    if Enemy_Armor >= 0 then
      Damage = (DamageSpellQ + Percent_AD * Damage_AD) * (100/(100 + Enemy_Armor))
    else
      Damage = (DamageSpellQ + Percent_AD * Damage_AD) * (2 - 100/(100 - Enemy_Armor))
    end
    return Damage
  end

  if Spell == _E then
    if myHero.LevelSpell(_E) == 0 then return 0 end
    
    local Percent_Bonus_AD = 0.2
    local Damage_Bonus_AD = myHero.BaseDmg

    local Percent_AP = 0.6
    local Damage_AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent

    local DamageSpellETable = {60, 70, 80, 90, 100}
    local DamageSpellE = DamageSpellETable[myHero.LevelSpell(_E)]

    local Enemy_Armor = Enemy.Armor    
    local Dominik_ID = 3036--Lord Dominik's Regards
    local Mortal_Reminder_ID = 3033--Mortal Reminder
    if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
      Enemy_Armor = Enemy_Armor - Enemy.BonusArmor * 45/100
    end
    local ArmorPenetration = 60 * myHero.ArmorPen / 100 + (1 - 60/100) * myHero.ArmorPen * Enemy.Level / 18
    Enemy_Armor = Enemy_Armor - ArmorPenetration
    if Enemy_Armor >= 0 then
      Damage = (DamageSpellE + Percent_Bonus_AD * Damage_Bonus_AD + Percent_AP * Damage_AP) * (100/(100 + Enemy_Armor))
    else
      Damage = (DamageSpellE + Percent_Bonus_AD * Damage_Bonus_AD + Percent_AP * Damage_AP) * (2 - 100/(100 - Enemy_Armor))
    end
    return Damage
  end

  if Spell == _R then
    if myHero.LevelSpell(_R) == 0 then return 0 end
    local Percent_Bonus_AD = 1.5
    local Damage_Bonus_AD = myHero.BaseDmg

    local DamageSpellRTable = {200, 300, 400}
    local DamageSpellR = DamageSpellRTable[myHero.LevelSpell(_R)]

    local Enemy_Armor = Enemy.Armor
    local Dominik_ID = 3036--Lord Dominik's Regards
    local Mortal_Reminder_ID = 3033--Mortal Reminder
    if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
      Enemy_Armor = Enemy_Armor - Enemy.BonusArmor * 45/100
    end
    
    local ArmorPenetration = 60 * myHero.ArmorPen / 100 + (1 - 60/100) * myHero.ArmorPen * Enemy.Level / 18
    Enemy_Armor = Enemy_Armor - ArmorPenetration
    if Enemy_Armor >= 0 then
      Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (100/(100 + Enemy_Armor))
    else
      Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (2 - 100/(100 - Enemy_Armor))
    end
    return Damage
  end
end
