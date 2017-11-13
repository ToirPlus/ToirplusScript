
IncludeFile("Lib\\Vector.lua")

function UpdateHeroInfo()
	return GetMyChamp()
end

local time1 = 0
local time2 = 0

local delay = 0

function OnTick()
	time2 = GetTimeGame()
	if time2 - time1 > delay and delay > 0 then
		delay = 0
		SetLuaMoveOnly(false)
	end
end

function OnLoad()

end

function OnUpdate()
end

function OnDraw()
end

function OnUpdateBuff(unit, buff, stacks)

end

function OnRemoveBuff(unit, buff)
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

function IsOnThreshQ(StartQPos, EndQPos)

	local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }

	local myHeroVector = Vector(myHeroPos)
	local startQVector = Vector(StartQPos)
	local endQVector = Vector(EndQPos)

	local distanceToObj = startQVector:DistanceTo(endQVector)
    local endPos = startQVector:Extend(endQVector, distanceToObj)
    local pointSegment, pointLine, isOnSegment = VectorPointProjectionOnLineSegment(startQVector, endPos, myHeroVector)

	local pointSegmentVector = Vector(pointSegment.x, myHeroVector.y, pointSegment.z)
    if isOnSegment and myHeroVector:DistanceTo(pointSegmentVector) <= 50 then
        return true
    end
    return false
end

function FindDodgePos(pos1, pos2, distance)
	local dX = pos2.x - pos1.x
    local dZ = pos2.z - pos1.z

    local C1 = dZ*pos1.x - dX*pos1.z
    local C2 = dX*pos1.x + dZ*pos1.z

	local calc1    = sqrt(dZ*dZ + dX*dX)

    local x0,z0 = FirstOrderEquations(dZ, -dX, C1, dX, dZ, C2)

	if x0 == 0 and z0 == 0 then return 0,0 end

	local C4_1 = dZ*pos1.x - dX*pos1.z - distance*calc1
    local C4_2 = dZ*pos1.x - dX*pos1.z + distance*calc1

	local x1,z1 = FirstOrderEquations(dX, dZ, C2, dZ, -dX, C4_1)

	if x1 == 0 and z1 == 0 then
		local x2,z2 = FirstOrderEquations(dZ, C2, dZ, -dX, C4_2)
		if x2 == 0 and z2 == 0 then
			return 0,0
		else
			return x2, z2
		end
	else
		return x1, z1
	end

end

function FirstOrderEquations(a1, b1, c1, a2, b2, c2)

    local _D  = a1*b2 - a2*b1
    local _Dx = c1*b2 - c2*b1
    local _Dz = a1*c2 - a2*c1
    if _D == 0 then return 0, 0 end

    local x = _Dx/_D;
    local z = _Dz/_D;
	return x, z
end

function GetDistancePos(x,z)
	local x1 = GetPosX(UpdateHeroInfo())
	local z1 = GetPosZ(UpdateHeroInfo())

	return GetDistance2D(x1,z1,x,z)
end

function OnProcessSpell(unit, spell)
	if spell ~= 0 then
		if GetName_Casting(spell) == "ThreshQInternal" then

			--__PrintTextGame(GetSrcPosX_Casting(spell))
			--__PrintTextGame(GetSrcPosZ_Casting(spell))

			--__PrintTextGame(GetDestPosX_Casting(spell))
			--__PrintTextGame(GetDestPosZ_Casting(spell))

			local StartQPos = {GetSrcPosX_Casting(spell), GetSrcPosY_Casting(spell), GetSrcPosZ_Casting(spell)}
			local EndQPos = {GetDestPosX_Casting(spell), GetDestPosY_Casting(spell), GetDestPosZ_Casting(spell)}

			local startQVector = Vector(StartQPos)

			local myHeroPos = { GetPosX(UpdateHeroInfo()), GetPosY(UpdateHeroInfo()), GetPosZ(UpdateHeroInfo()) }

			local myHeroVector = Vector(myHeroPos)

			if IsOnThreshQ(StartQPos, EndQPos) then
				local x, z = FindDodgePos(myHeroVector, startQVector, 60)
				if x > 0 and z > 0 then
					SetLuaMoveOnly(true)
					MoveToPos(x, z)
					delay = GetDistancePos(x,z) / GetMoveSpeed(UpdateHeroInfo())
					time1 = GetTimeGame()
				end
			end

		end
	end


end

function OnCreateObject(unit)
end

function OnDeleteObject(unit)
end
