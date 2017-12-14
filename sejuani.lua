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

--local ts = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1300, DAMAGE_MAGIC)
--ts.name = "Sejuani"
--local Target = nil
local VP = nil
local VPHitChance = 2

local JungleMobs = {}
local JungleFocusMobs = {}
local JungleTeamNames = {}

local priorityTable = {
    p5 = {"Alistar", "Amumu", "Blitzcrank", "Braum", "ChoGath", "DrMundo", "Garen", "Gnar", "Hecarim", "Janna", "JarvanIV", "Leona", "Lulu", "Malphite", "Nami", "Nasus", "Nautilus", "Nunu","Olaf", "Rammus", "Renekton", "Sejuani", "Shen", "Shyvana", "Singed", "Sion", "Skarner", "Sona","Soraka", "Taric", "Thresh", "Volibear", "Warwick", "MonkeyKing", "Yorick", "Zac", "Zyra", "Rakan", "Ornn"},
    p4 = {"Aatrox", "Darius", "Elise", "Evelynn", "Galio", "Gangplank", "Gragas", "Irelia", "Jax","LeeSin", "Maokai", "Morgana", "Nocturne", "Pantheon", "Poppy", "Rengar", "Rumble", "Ryze", "Swain","Trundle", "Tryndamere", "Udyr", "Urgot", "Vi", "XinZhao", "RekSai"},
    p3 = {"Akali", "Diana", "Fiddlesticks", "Fiora", "Fizz", "Heimerdinger", "Jayce", "Kassadin","Kayle", "KhaZix", "Lissandra", "Mordekaiser", "Nidalee", "Riven", "Shaco", "Vladimir", "Yasuo","Zilean"},
    p2 = {"Ahri", "Anivia", "Annie",  "Brand",  "Cassiopeia", "Karma", "Karthus", "Katarina", "Kennen", "Sejuani",  "Lux", "Malzahar", "MasterYi", "Orianna", "Syndra", "Talon",  "TwistedFate", "Veigar", "VelKoz", "Viktor", "Xerath", "Zed", "Ziggs" },
    p1 = {"Ashe", "Caitlyn", "Corki", "Draven", "Ezreal", "Graves", "Jinx", "Kalista", "KogMaw", "Lucian", "MissFortune", "Quinn", "Sivir", "Teemo", "Tristana", "Twitch", "Varus", "Vayne", "Xayah", "Zoe"},
}

function SetPriority(table, hero, priority)
    for i=1, #table, 1 do
        if hero.CharName:find(table[i]) ~= nil then
            TS_SetHeroPriority(priority, hero.CharName)
        end
    end
end

function arrangePrioritys()
     local priorityOrder = {
        [1] = {1,1,1,1,1},
        [2] = {1,1,2,2,2},
        [3] = {1,1,2,2,3},
        [4] = {1,1,2,3,4},
        [5] = {1,2,3,4,5},
    }
    local enemies = #GetEnemyHeroes()
    for i, enemy in ipairs(GetEnemyHeroes()) do
        SetPriority(priorityTable.p1, enemy, priorityOrder[enemies][1])
        SetPriority(priorityTable.p2, enemy, priorityOrder[enemies][2])
        SetPriority(priorityTable.p3,  enemy, priorityOrder[enemies][3])
        SetPriority(priorityTable.p4,  enemy, priorityOrder[enemies][4])
        SetPriority(priorityTable.p5,  enemy, priorityOrder[enemies][5])
    end
end

VP = VPrediction()
--DelayAction(arrangePrioritys,3)

local EnemyMinions = minionManager(MINION_ENEMY, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)
local JungleMinions = minionManager(MINION_JUNGLE, 1200, myHero, MINION_SORT_MAXHEALTH_DEC)

local LaneClearUseMana = 20

local config_R_InTurret = false
local config_Q_InTurret = false
local config_R_ally = true
local config_Use_Smite = true

local wStartTime = 0

if myHero.CharName == "Sejuani" then
	config_R_InTurret  = AddMenuCustom(1, config_R_InTurret, "R In Turret")
	config_Q_InTurret  = AddMenuCustom(2, config_Q_InTurret, "Q In Turret")
	config_R_ally      = AddMenuCustom(3, config_R_ally, "R with ally")
	config_Use_Smite   = AddMenuCustom(4, config_Use_Smite, "Use Smite")
end

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86

local AARange = 150
local Ranges = {Q = 650,      W = 650,         E = 1000,     R = 1100  }
local Widths = {Q = 75,       W = 350,         E = 0,        R = 150   , R2 = 450}
local Delays = {Q = 0.25,     W = 0.5,         E = 0.25,     R = 0.25  }
local Speeds = {Q = 2000,     W = 1500,        E = 2000,     R = 1500  }
local RWidth = {150, 250, 350}

AddTickCallback(function () Tick() end)
--AddCreateObjCallback(function (obj) _OnCreateObj(obj) end)
--AddDeleteObjCallback(function (obj) _OnDeleteObj(obj) end)

--QCooldow = 0
--WCooldow = 0
--ECooldow = 0
--RCooldow = 0

function AutoE()
  if CanCast(_E) then
    for i, enemy in ipairs(GetEnemyHeroes()) do
      if enemy and ValidTarget(enemy) and GetDistance(enemy) <= Ranges.E and CanMove() and FrozenBuff(enemy) then
        CastE(enemy)
      end
    end
  end
end

function KillSteal()
  for i, Target in pairs(GetEnemyHeroes()) do
    if Target and ValidTarget(Target) then
      if not Target.IsDead and Target.IsVisible then
        if CanCast(_E) and getDmg(_E, Target) > Target.HP and CanMove() then
          CastE(Target)
        end

        if CanCast(_Q) and getDmg(_Q, Target) > Target.HP and CanMove() then
          CastQ(Target)
        end

        if CanCast(_R) and getDmg(_R, Target) > Target.HP and CanMove() then
          CastR(Target)
        end

      end
    end
  end
end

function Tick()
	myHero = GetMyHero()
  player = myHero
	if myHero.CharName ~= "Sejuani" then return end

--  QCooldow = GetCDSpell(myHero.Addr,_Q)
--  WCooldow = GetCDSpell(myHero.Addr,_W)
--  ECooldow = GetCDSpell(myHero.Addr,_E)
--  RCooldow = GetCDSpell(myHero.Addr,_R)
  
--  if CanCast(_Q) then
--    ts.range = 1500
--  else
--    ts.range = 900
--  end
  
	if IsTyping() then return end
	if myHero.IsDead then return end	
	if _G.evade then return end

	if GetKeyPress(SpaceKeyCode) == 1 then
		SetLuaCombo(true)
		Combo()
	end

  if GetKeyPress(CKeyCode) == 1 then
    SetLuaHarass(true)
    EnemyMinions:update()
    JungleMinions:update()
    Farm()
  end
  
	if GetKeyPress(VKeyCode) == 1 then
		SetLuaLaneClear(true)
		EnemyMinions:update()
    JungleMinions:update()
		Clear()
	end

	--KillSteal()
	AutoE()
	--AutoR()
end

function CastR(Target)
  local unit = Target
  if CanCast(_R) then    
    local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
    if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.R then      
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if enemy.NetworkID ~= unit.NetworkID and ValidTarget(enemy, Ranges.R * 1.5) then
          local ColCastPos = VP:CheckCol(unit, enemy, CastPosition, Delays.R, Widths.R, Ranges.R, Speeds.R, myHero, false)
          if not ColCastPos then
            if (not UnderTurret(CastPosition) or config_R_InTurret) then
              CastSpellToPos(CastPosition.x, CastPosition.z, _R)
            end
          end
        else
          if (not UnderTurret(CastPosition) or config_R_InTurret) then
            CastSpellToPos(CastPosition.x, CastPosition.z, _R)
          end
        end
      end
    end     
  end
end

function CastQ(Target)  
    local unit = Target
    if CanCast(_Q) and ValidTarget(Target) then
      local CastPosition, HitChance, Position = VP:GetLineCastPosition(unit, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
      if CastPosition and HitChance >= VPHitChance and GetDistance(CastPosition) <= Ranges.Q then
          for i, enemy in ipairs(GetEnemyHeroes()) do
            if enemy.NetworkID ~= unit.NetworkID and ValidTarget(enemy, Ranges.Q) and GetDistance(enemy,unit) > Widths.Q then
                local ColCastPos = VP:CheckCol(unit, enemy, CastPosition, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
                local ColPredictPos = VP:CheckCol(unit, enemy, Position, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
                local ColUnitPos = VP:CheckCol(unit, enemy, unit, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
                if not ColCastPos and not ColPredictPos and not ColUnitPos then
                  if not IsWall(CastPosition.x, CastPosition.y, CastPosition.z) and (not UnderTurret(CastPosition) or config_Q_InTurret) then
                    CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
                  end
                end
            else
              if not IsWall(CastPosition.x, CastPosition.y, CastPosition.z) and (not UnderTurret(CastPosition) or config_Q_InTurret) then
                  CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
              end
            end
          end
      end
  end
end

function CastE(Target)
  if GetDistance(Target) <= Ranges.E and ValidTarget(Target) and CanCast(_E) then
    CastSpellTarget(Target.Addr, _E)    
    SetLuaBasicAttackOnly(true)
    BasicAttack(Target.Addr)
    SetLuaBasicAttackOnly(false)
  end
end

function CastW(Target)  
    if CanCast(_W) then
      wStartTime = GetTimeGame()
      CastSpellToPos(Target.x, Target.z, _W)
    end
end

function Combo()
  local Target = GetCustomTarget()      
  if Target ~= nil and ValidTarget(Target) and not Target.IsDead and Target.IsVisible then
    --print(Target.CharName)      
    if config_Use_Smite then      
      CastSpellTargetByName(Target.Addr, "S5_SummonerSmitePlayerGanker")
      CastSpellTargetByName(Target.Addr, "S5_SummonerSmiteDuel")
    end
    
    if (GetDistance(Target) <= myHero.AARange + 55 or (--[[QCooldow < 2 and]] GetDistance(Target) < Ranges.Q)) and CanMove() and Setting_IsComboUseW() then
      CastW(Target)
    end
  
    if --[[GetDistance(Target) >= 250 and]] CanMove() and Setting_IsComboUseQ() then
      CastQ(Target)
    end  
    local wActive = false
    if GetCDExpiresSpell(myHero.Addr,_W) - wStartTime >= GetTimeGame() - wStartTime then
      wActive = true
    else
      -- _W Expire
      wStartTime = 0
    end
    if --[[( not wActive or GetDistance(Target) >= 350) and]] FrozenBuff(Target) and Setting_IsComboUseE() then
      CastE(Target)
    end
            
    if --[[(CountEnemyHeroInRange(Widths.R2, Target) > 1 or GetDistance(Target) > Ranges.Q) and]] CanMove() and Setting_IsComboUseR() then
      CastR(Target)
    end
  end
end

function Farm()
  if not IsMyManaLowLaneClear() then return end
  if Setting_IsLaneClearUseW() then
    WLastHit()
  end
  if Setting_IsLaneClearUseQ() then
    QLastHit()
  end
  if Setting_IsLaneClearUseE() then
    ELastHit()
  end
end

function WLastHit()
  for _, minion in pairs(EnemyMinions.objects) do
    if ValidTarget(minion) then
      if GetDistance(minion, myHero) < Ranges.W then
        local AAdmg = myHero.CalcDamage(minion.Addr,200) or 0
        if minion.HP <= AAdmg + GetDamage("W", minion) and CanCast(_W) and CanAttack() then
          CastSpellToPos(minion.x, minion.z, _W)
        end
       end
    end
  end
end

function QLastHit()
  if CanCast(_Q) and #EnemyMinions.objects > 2 then
    local QPos = GetBestQPositionFarm()
    if QPos and GetDistance(QPos) <= Ranges.Q then 
      CastSpellToPos(QPos.x, QPos.z, _Q)
    end
  end
end

function countminionshitQ(pos)
  local n = 0
  for i, minion in ipairs(EnemyMinions.objects) do
      if GetDistance(minion, myHero) < Ranges.Q then 
        if minion.HP <= GetDamage("Q", minion) then 
          if pos and GetDistance(minion, pos) < Widths.Q then 
            n = n +1
          end
        end
      end
  end
  return n
end

function countminionshitE()
  local n = 0
  for i, minion in ipairs(EnemyMinions.objects) do
      if GetDistance(minion, myHero) < Ranges.E and FrozenBuff(minion) then
        if minion.HP <= GetDamage("E", minion) then
          n = n +1
      end
    end
  end
  return n
end

function GetBestQPositionFarm()
  local MaxQ = 3
  local MaxQPos 
  for i, minion in pairs(EnemyMinions.objects) do
    local hitQ = countminionshitQ(minion)
    if hitQ >= MaxQ or MaxQPos == nil then
      MaxQPos = minion
      MaxQ = hitQ
    end
  end

  if MaxQPos then
    local CastPosition, HitChance, Position = VP:GetLineAOECastPosition(MaxQPos, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
    return CastPosition
  else
    return nil
  end
end

function ELastHit()
  if CanCast(_E) and #EnemyMinions.objects > 2 then
    local hitE = countminionshitE()
    if hitE >= 2 then
        CastSpellTarget(myHero.Addr, _E)
    end
  end
end

function Clear()
  FarmClear()
  JungClear()
end

function FarmClear()
   for _, minion in pairs(EnemyMinions.objects) do
    if minion and Setting_IsLaneClearUseQ() and CanCast(_Q) then
        local AOECastPosition, MainTargetHitChance, nTargets = VP:GetLineAOECastPosition(minion, Delays.Q, Widths.Q, Ranges.Q, Speeds.Q, myHero, false)
        if AOECastPosition then
            CastSpellToPos(AOECastPosition.x, AOECastPosition.z, _Q)
        end
    end
    if Setting_IsLaneClearUseW() then
      if CanCast(_W) and #EnemyMinions.objects > 2 then
          CastSpellToPos(EnemyMinions.objects[1].x, EnemyMinions.objects[1].z, _W)
      end
    end
    if Setting_IsLaneClearUseE() then
        ELastHit()
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
  --print("JungClear")
  local JungleMob = GetJungle() or GetJungleMob()
  if JungleMob ~= nil then
      if Setting_IsLaneClearUseW() and CanCast(_W) and GetDistance(JungleMob) < Ranges.W and CanMove() then
          CastSpellToPos(JungleMob.x, JungleMob.z, _W)
      end
      if Setting_IsLaneClearUseQ() and CanCast(_Q) and GetDistance(JungleMob) < Ranges.Q and CanMove() then
          CastSpellToPos(JungleMob.x, JungleMob.z, _Q)
      end
      if Setting_IsLaneClearUseE() and CanCast(_E) and FrozenBuff(JungleMob) and not CanCast(_Q) and not CanCast(_W) then
          CastSpellTarget(JungleMob.Addr, _E)          
          SetLuaBasicAttackOnly(true)
          BasicAttack(JungleMob.Addr)
          SetLuaBasicAttackOnly(false)          
      end
    end
end

function GetJungleMob()
--  for _, Mob in pairs(JungleFocusMobs) do
--      if ValidTarget(Mob, 500) then
--          return Mob
--      end
--    end
    for _, Mob in pairs(JungleMobs) do
      if ValidTarget(Mob, 500) then
          return Mob
      end
    end
end

function _OnCreateObj(obj)
  if not obj then return end
  if obj.Type == 3 then
      table.insert(JungleMobs, obj)
  --elseif JungleMobNames[obj.CharName] then
      --table.insert(JungleMobs, obj)
  --elseif JungleTeamNames[obj.name] then
    --table.insert(JungleTeamNames, obj)
  end
end

function _OnDeleteObj(obj)
    if not obj then return end
    for i, Mob in pairs(JungleMobs) do
        if obj.Type == 3 and obj.CharName == Mob.CharName then
          table.remove(JungleMobs, i)
        end
    end
--    for i, Mob in pairs(JungleFocusMobs) do
--        if obj.CharName == Mob.CharName then
--          table.remove(JungleFocusMobs, i)
--        end
--    end
    --for i, Mob in pairs(JungleTeamNames) do
        --if obj.name == Mob.name then
          --table.remove(JungleTeamNames, i)
        --end
    --end
end

function CountAllysInRange(range, object)
  local allyInRange = 0
  local allies = GetAllyHeroes()
  if object ~= nil and range then
    for i, ally in pairs(allies) do
      if not ally.dead and  ValidTarget(ally) and range > GetDistance(ally, object) then
        allyInRange = allyInRange + 1
      end
    end
  end
  return allyInRange
end

function IsMyManaLowLaneClear()
    if myHero.MP < (myHero.MaxMP * ( LaneClearUseMana / 100)) then
        return true
    else
        return false
    end
end

function FrozenBuff(unit)
	if unit ~= nil then
	 if unit.Addr ~= 0 and GetBuffByName(unit.Addr, "SejuaniEMarkerMax") ~= 0 then 
		return true
	 end
	end
	return false
end

function GetCustomTarget()
  local enemy = GetTarget2(1500)
    if enemy then return enemy end
--  ts:update()  
--  if ValidTarget(ts.target) and ts.target.Type == myHero.Type then
--    return ts.target
--  else
--    local enemy = GetEnemyChampCanKillFastest(1500)
--    if enemy ~= 0 then return GetAIHero(enemy) end
--    return nil
--  end
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
    local DamageSpellQTable = { 60, 90, 120, 150, 180}
    local Percent_AP = 0.4
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

  if Spell == _E then
    if myHero.LevelSpell(_E) == 0 then return 0 end
    local DamageSpellETable = {20, 30, 40, 50, 60}
    local Percent_AP = 0.3
    local AP = myHero.MagicDmg + myHero.MagicDmg * myHero.MagicDmgPercent
    local DamageSpellR = DamageSpellETable[myHero.LevelSpell(_E)]
    local Enemy_SpellBlock = Enemy.MagicArmor

    local Void_Staff_Id = 3135 -- Void Staff Item
    if GetItemByID(Void_Staff_Id) > 0 then
      Enemy_SpellBlock = Enemy_SpellBlock * (1 - 35/100)
    end

    Enemy_SpellBlock = Enemy_SpellBlock - myHero.MagicPen
    if Enemy_SpellBlock >= 0 then
      Damage = (DamageSpellR + Percent_AP * AP) * (100/(100 + Enemy_SpellBlock))
    else
      Damage = (DamageSpellR + Percent_AP * AP) * (2 - 100/(100 - Enemy_SpellBlock))
    end

    return Damage
  end
  
  if Spell == _R then
    if myHero.LevelSpell(_R) == 0 then return 0 end
    local DamageSpellRTable = {100, 125, 150 }
    local Percent_AP = 0.4
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

function AutoR()
    if CanCast(_R) then
      for i, enemy in ipairs(GetEnemyHeroes()) do
        if ValidTarget(enemy,Ranges.R * 1.5) then
          local UseQR = false
          local DelayR = nil
        local RangeR = Ranges.R
        if GetDistance(enemy) <= Ranges.R and CanCast(_R) then
            DelayR = Delays.R
        elseif GetDistance(enemy) <= Ranges.Q + Ranges.R and GetDistance(enemy) > Ranges.R and CanCast(_Q) and CanCast(_R) then
                    local DelayR = (Ranges.Q/Speeds.Q + Delays.R + 0.125)
          RangeR = Ranges.R + Ranges.Q
          UseQR = true
                end 
                if DelayR ~= nil then       
          local CastPosition, HitChance, Position = VP:GetLineCastPosition(enemy, DelayR, Widths.R, RangeR, Speeds.R, myHero, false)            
          local MaxHit = 1
          for j, enemyx in ipairs(GetEnemyHeroes()) do
              if enemyx.NetworkId ~= enemy.NetworkId and ValidTarget(enemyx,Ranges.R * 1.5) and CastPosition then
              local PredictedPos = VP:GetPredictedPos(enemyx, DelayR)
              if GetDistance(CastPosition, PredictedPos) < Widths.R2 and GetDistance(CastPosition, enemyx) < Widths.R2 then
                  MaxHit = MaxHit + 1
              end
            end
          end               
          
          if CastPosition and HitChance >= VPHitChance and MaxHit >= 1 then
              for k, enemyy in ipairs(GetEnemyHeroes()) do
                if enemyy.NetworkId ~= enemy.NetworkId and ValidTarget(enemyy,Ranges.R * 1.5) then
                  local ColCastPos = VP:CheckCol(enemy, enemyy, CastPosition, DelayR, Widths.R, RangeR, Speeds.R, myHero, false)
                  if not ColCastPos then
                    if not config_R_ally or (config_R_ally and CountAllysInRange(1000, enemy) >= 1) then
                      if UseQR then
                          CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
                        if not CanCast(_Q) then
                            CastSpellToPos(CastPosition.x, CastPosition.z, _R)
                        end
                      else
                          CastSpellToPos(CastPosition.x, CastPosition.z, _R)
                      end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end