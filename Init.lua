--IncludeFile("player.lua")

function UpdateHeroInfo()
	return GetMyChamp()
end

IncludeFile("kogmaw.lua")
IncludeFile("xayah.lua")
IncludeFile("sivir.lua")
IncludeFile("yasuo.lua")
IncludeFile("PrestigiousVayne.lua")

function sleep(s)						 -- s=second
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end


__PrintDebug("Injected")

while(true)
do

	local bIsEndLua = IsEndLua()
	--__PrintDebug("========>bIsEndLua: " .. tostring(bIsEndLua))
	if bIsEndLua == 1 then
		__PrintDebug("========>bIsEndLua: " .. tostring(bIsEndLua))
		__PrintTextGame("========>bIsEndLua: " .. tostring(bIsEndLua))
		break
	end



	OnTick()
	sleep(0.01)



	--get_player_info()
	--__PrintDebug("1111...")

	--sleep(2)
	--myHero = GetMyChamp()

	--__PrintDebug(GetItemID(0))
	--BuyItem(2003)
	--sleep(3.1)
--[[
	nKeyCode = GetKeyCode()
	sleep(0.0001)
	if  nKeyCode == 84 then
		myHero = GetMyChamp()
		nCountMinionCollision = 0
		local fRange_BrandQ = 1000
		local fWidth_BrandQ = 55
		local fMissileSpeed_BrandQ = 1500
		pEnemy = GetEnemyChampCanKillFastest(fRange_BrandQ)
		if pEnemy ~= 0 then
			pBuff = GetBuffByName(pEnemy, "BrandAblaze")
			if pBuff ~= 0 then
				x1 = GetPosX(myHero)
				z1 = GetPosZ(myHero)
				x2 = GetPosX(pEnemy)
				z2 = GetPosZ(pEnemy)
				fDistant = GetDistance2D(x1, z1, x2, z2)
				fTimeMissile = 0.25 + fDistant/fMissileSpeed_BrandQ
				fPredDist = fTimeMissile*GetMoveSpeed(pEnemy)

				if fDistant < 350 then fPredDist = 100 end

				PredPosX = GetPredictionPosX(pEnemy, fPredDist)
				PredPosZ = GetPredictionPosZ(pEnemy, fPredDist)

				if PredPosX ~= 0 and PredPosZ ~= 0 then
					nCountMinionCollision = CountObjectCollision(0, pEnemy, x1, z1, PredPosX, PredPosZ, fWidth_BrandQ, fRange_BrandQ, 10)
				else
					nCountMinionCollision = CountObjectCollision(0, pEnemy, x1, z1, x2, z2, fWidth_BrandQ, fRange_BrandQ, 10)
				end

				if nCountMinionCollision == 0 then
					CastSpellToPredictionPos(pEnemy, 0, fPredDist)
				end
			end
		end
	end
--]]
--[[
	GetAllObjectAroundAnObject(myHero, 25000)

	for k,v in pairs(pObject) do
		__PrintDebug(k)
		__PrintDebug(v)
	end
--]]
	--__PrintDebug("IsDashing()						=" .. tostring(IsDashing(myHero)))
	--nDist = GetDistance2D(GetPosX(myHero), GetPosZ(myHero),  GetPosX(843509728), GetPosZ(843509728))
	--nDist2 = nDist - 1
	--nEnemy = GetEnemyChampCanKillFastest(nDist2)
	--__PrintDebug(nDist)
	--__PrintDebug(nEnemy)
	--__PrintDebug("================")
--[[
	GetAllBuffNameActive(myHero)

	for k,v in pairs(pBuffName) do
		__PrintDebug(k)
		__PrintDebug(v)
	end
--]]
	--__PrintDebug("GetWindupBA						=" .. tostring(GetWindupBA(myHero)))
	--__PrintDebug("GetCDBA							=" .. tostring(GetCDBA(myHero)))
	--__PrintDebug("GetCDExpiresBA					=" .. tostring(GetCDExpiresBA(myHero)))

	--__PrintDebug("GetTimeGame							=" .. tostring(GetTimeGame()))
	--__PrintDebug("GetTickCount							=" .. tostring(GetTickCount()))
	--sleep(5.1)
	--[[


	__PrintDebug("IsDodging					=" .. tostring(IsDodging()))
	__PrintDebug("======================================")
	__PrintDebug("CanCastQ					=" .. tostring(CanCast(Q)))
	__PrintDebug("CanCastW					=" .. tostring(CanCast(W)))
	__PrintDebug("CanCastE					=" .. tostring(CanCast(E)))
	__PrintDebug("CanCastR					=" .. tostring(CanCast(R)))

	SetLuaBasicAttackOnly(true)
	SetLuaMoveOnly(false)
	SetLuaCombo(true)
	SearchAllChamp()
	__PrintDebug("pObjChamp[1]					=" .. tostring(pObjChamp[1]))
	__PrintDebug("NameChamp[1]					=" .. tostring(GetChampName(pObjChamp[1])))
	__PrintDebug("pObjChamp[2]					=" .. tostring(pObjChamp[2]))
	__PrintDebug("NameChamp[2]					=" .. tostring(GetChampName(pObjChamp[2])))
	--]]
	--SetLuaBasicAttackOnly(false)
	--SetLuaMoveOnly(false)
	--SetLuaCombo(false)
	--nKeyCode = GetKeyCode()
	--sleep(0.0001)

	--MoveToPos(GetCursorPosX(), GetCursorPosZ())
--[[
	if  nKeyCode == 32 then
		--__PrintDebug(nKeyCode)
		--sleep(0.451)
		pEnemy = GetEnemyChampNearest(myHero, 1000)
		if pEnemy ~= 0 then
			CastSpellTarget(myHero, Q)
			BasicAttack(pEnemy)
			sleep(0.15)
			MoveToPos(GetCursorPosX(), GetCursorPosZ())
			sleep(0.25)
		--end
		else
			MoveToPos(GetCursorPosX(), GetCursorPosZ())
		end
	end
--]]
	--__PrintDebug(CountEnemyTurretAroundObject(myHero, 23000))

	--__PrintDebug(GetAnimationBA(myHero))
	--__PrintDebug(GetDelayBA(myHero))
	--CastSpellToPos(7896,4956, GetSpellIndexByName("SummonerFlash"))
	--BasicAttack(849003288)
	--CastSpellTargetByName(849003288, "ItemSwordOfFeastAndFamine")
	  --- Use to cast Item-Spell, D-F-Spell (target): SummonerDot, SummonerHeal, SummonerDot, ItemSwordOfFeastAndFamine, ZhonyasHourglass ..


	--CastSpellTarget(759232024, W)
	--CastSpellToPredictionPos(759232024, Q, 500)

	--CastSpellToPos(7896,4956, Q)
	--sleep(0.901)
	--ReleaseSpellToPos(7896,4956, Q)
	--ReleaseSpellToPredictionPos(849003288 , Q, 500)
	--CastSpellToPos(7896,4956, Q)
	--CastSpellToPos_2(7896,4956, 7896,4956, Q)

	--__PrintDebug("\n")
	--get_player_info()

	--__PrintTextGame("1234--xxxx")


	--pNpc   = 692572584


	--GetBuffByName(myHero, "123xxx")

	--GetBuffByName(myHero, "frostquestdisplay")
	--GetItemByID(1231)
	--__PrintDebug(GetItemID(1))
--[[
	__PrintDebug(GetBuffCount(myHero, "frostquestdisplay"))
	__PrintDebug(GetBuffStack  (myHero, "frostquestdisplay"))
	__PrintDebug(GetBuffCount    (myHero, "kagesluckypickdisplay"))
	__PrintDebug(GetBuffStack    (myHero, "kagesluckypickdisplay"))
	__PrintDebug(GetBuffType    (myHero, "kagesluckypickdisplay"))
	__PrintDebug("nCount = ".. tostring(CountBuffByType    (myHero, 26)))
--]]
	--__PrintDebug("PosX					=" .. tostring(GetPosX(myHero)))
	--__PrintDebug("PosY					=" .. tostring(GetPosY(myHero)))
	--__PrintDebug("PosZ					=" .. tostring(GetPosZ(myHero)))
	--__PrintDebug("PosX-					=" .. tostring(GetCursorPosX()))
	--__PrintDebug("PosY-					=" .. tostring(GetCursorPosY()))
	--__PrintDebug("PosZ-					=" .. tostring(GetCursorPosZ()))
	--__PrintDebug("bIsMoving = ".. tostring(IsMoving    (myHero)))
	--__PrintDebug("bIsMovingxxx = ".. tostring(IsTyping()))

	--__PrintDebug("bIsMovingxxx = ".. tostring(IsWall(GetCursorPosX(), GetCursorPosY(), GetCursorPosZ())))


	--MoveToPos(2600,1800)
	--UnBlockMove()
	--sleep(1.001)




end
