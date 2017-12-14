IncludeFile("Lib\\AllClass.lua")
IncludeFile("Lib\\VPrediction.lua")
IncludeFile("SOW.lua")

SetLuaCombo(true)
SetLuaHarass(true)
SetLuaLaneClear(true)
SetLuaBasicAttackOnly(true)
SetLuaMoveOnly(true)

local VP, SOWi = nil, nil

if VPrediction then
	VP = VPrediction()
--~ 	if VP then
--~ 		__PrintTextGame('VPrediction Loaded')
--~ 	end
end

if SOW then
	SOWi = SOW(VP)

--~ 	if SOWi then
--~ 		__PrintTextGame('SOW Loaded')
--~ 	end
end

function Tick()
	SOWi:EnableAttacks()

	myHero = GetMyHero()

	if GetKeyPress(32) == 1 then

		local target = GetTarget(1800)

		--print(tostring(target.CharName))

		local SpellQ = {Speed = 1550, Range = 925, Delay = 0.3667, Width = 60}

		if target and CanCast(_Q) and SOWi:CanMove() then
			local CastPosition, HitChance, Position = VP:GetLineCastPosition(target, SpellQ.Delay, SpellQ.Width, SpellQ.Range, SpellQ.Speed, myHero, true)
			--print(tostring(HitChance))
			if HitChance >= 2 then
				CastSpellToPos(CastPosition.x, CastPosition.z, _Q)
			end
		end

	end
end


AddTickCallback(function () Tick() end)


