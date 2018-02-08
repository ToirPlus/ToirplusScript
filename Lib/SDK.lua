-----------------------------------------------------------------------------
-- Localize standart LUA functions
-----------------------------------------------------------------------------
local base = _G
local assert = base.assert
local collectgarbage = base.collectgarbage
local dofile = base.dofile
local error = base.error
local getfenv = base.getfenv
local getmetatable = base.getmetatable
local ipairs = base.ipairs
local load = base.load
local loadfile = base.loadfile
local loadstring = base.loadstring
local module = base.module
local next = base.next
local pairs = base.pairs
local pcall = base.pcall
local print = base.print
local rawequal = base.rawequal
local rawget = base.rawget
local rawset = base.rawset
local require = base.require
local select = base.select
local setfenv = base.setfenv
local setmetatable = base.setmetatable
local tonumber = base.tonumber
local tostring = base.tostring
local type = base.type
local unpack = base.unpack
local xpcall = base.xpcall

local io_close = base.io.close
local io_flush = base.io.flush
local io_input = base.io.input
local io_lines = base.io.lines
local io_open = base.io.open
local io_output = base.io.output
local io_popen = base.io.popen
local io_read = base.io.read
local io_stderr = base.io.stderr
local io_stdin = base.io.stdin
local io_stdout = base.io.stdout
local io_tmpfile = base.io.tmpfile
local io_type = base.io.type
local io_write = base.io.write

local math_abs = base.math.abs
local math_acos = base.math.acos
local math_asin = base.math.asin
local math_atan = base.math.atan
local math_atan2 = base.math.atan2
local math_ceil = base.math.ceil
local math_cos = base.math.cos
local math_cosh = base.math.cosh
local math_deg = base.math.deg
local math_exp = base.math.exp
local math_floor = base.math.floor
local math_fmod = base.math.fmod
local math_frexp = base.math.frexp
local math_huge = base.math.huge
local math_ldexp = base.math.ldexp
local math_log = base.math.log
local math_log10 = base.math.log10
local math_max = base.math.max
local math_min = base.math.min
local math_modf = base.math.modf
local math_pi = base.math.pi
local math_pow = base.math.pow
local math_rad = base.math.rad
local math_random = base.math.random
local math_randomseed = base.math.randomseed
local math_sin = base.math.sin
local math_sinh = base.math.sinh
local math_sqrt = base.math.sqrt
local math_tan = base.math.tan
local math_tanh = base.math.tanh

local os_clock = base.os.clock
local os_date = base.os.date
local os_difftime = base.os.difftime
local os_execute = base.os.execute
local os_exit = base.os.exit
local os_getenv = base.os.getenv
local os_remove = base.os.remove
local os_rename = base.os.rename
local os_setlocale = base.os.setlocale
local os_time = base.os.time
local os_tmpname = base.os.tmpname

local package_cpath = base.package.cpath
local package_loaded = base.package.loaded
local package_loaders = base.package.loaders
local package_loadlib = base.package.loadlib
local package_path = base.package.path
local package_preload = base.package.preload
local package_seeall = base.package.seeall

local string_byte = base.string.byte
local string_char = base.string.char
local string_dump = base.string.dump
local string_find = base.string.find
local string_format = base.string.format
local string_gmatch = base.string.gmatch
local string_gsub = base.string.gsub
local string_len = base.string.len
local string_lower = base.string.lower
local string_match = base.string.match
local string_rep = base.string.rep
local string_reverse = base.string.reverse
local string_sub = base.string.sub
local string_upper = base.string.upper

local table_concat = base.table.concat
local table_insert = base.table.insert
local table_maxn = base.table.maxn
local table_remove = base.table.remove
local table_sort = base.table.sort

myHero = GetMyHero()

function class(name)
        _G[name] = {}
        _G[name].__index = _G[name]
        setmetatable(_G[name], {
                __call = function(self, ...)
                        local obj = setmetatable({}, self)
                        obj:__init(...)
                        return obj
                end
        })
end

-----------------------------------------------------------------------------
-- SDK: Enum
-----------------------------------------------------------------------------

Enum = {}

Enum.Event = {}
Enum.OrbMode = {}
Enum.SpellType = {}
Enum.SkillShotType = {}

Enum.Event.OnLoad               = 0
Enum.Event.OnTick               = 1
Enum.Event.OnUpdate             = 2
Enum.Event.OnDraw               = 3
Enum.Event.OnUpdateBuff         = 4
Enum.Event.OnRemoveBuff         = 5
Enum.Event.OnProcessSpell       = 6
Enum.Event.OnCreateObject       = 7
Enum.Event.OnDeleteObject       = 8
Enum.Event.OnWndMsg             = 9
Enum.Event.OnDoCast             = 10
Enum.Event.OnPlayAnimation      = 11
Enum.Event.OnNewPath            = 12
Enum.Event.OnVision             = 13
Enum.Event.OnDash               = 14
Enum.Event.OnKeyPress           = 15
Enum.Event.OnRecall             = 16
Enum.Event.OnBeforeAttack       = 17
Enum.Event.OnAttack             = 18
Enum.Event.OnAfterAttack        = 19
Enum.Event.OnIssueOrder         = 20
Enum.Event.OnDrawMenu           = 21

Enum.OrbMode.None               = 0
Enum.OrbMode.Combo              = 1
Enum.OrbMode.LastHit            = 2
Enum.OrbMode.Harass             = 3
Enum.OrbMode.LaneClear          = 4

Enum.SpellType.SkillShot        = 0
Enum.SpellType.Targetted        = 1
Enum.SpellType.Active           = 2

Enum.SkillShotType.Line         = 0
Enum.SkillShotType.Circle       = 1

-----------------------------------------------------------------------------
-- SDK: Common
-----------------------------------------------------------------------------

GetDistanceSqr = function(p1, p2)
        local p2 = p2 or myHero
	local dx = p1.x - p2.x
	local dz = (p1.z or p1.y) - (p2.z or p2.y)
	return dx * dx + dz * dz
end

GetDistance = function(p1, p2)
	local squaredDistance = GetDistanceSqr(p1, p2)
	return math_sqrt(squaredDistance)
end

SerializeTable = function(t, name, indent)
	local cart, autoref

        local function isEmptyTable(t)
                return next(t) == nil
        end

        local function basicSerialize(o)
                local ts = tostring(o)

                if type(o) == "function" then
                        return ts
                elseif type(o) == "number" or type(o) == "boolean" then
                        return ts
                else
                        return string_format("%q", ts)
                end
        end

        local function addToCart(value, name, indent, saved, field)
                indent = indent or ""
                saved = saved or {}
                field = field or name

                cart = cart .. indent .. field

                if type(value) ~= "table" then
                        cart = cart .. " = " .. basicSerialize(value) .. ";\n"
                else
                        if saved[value] then
                                cart = cart .. " = {}; -- " .. saved[value]
                                .. " (self reference)\n"
                                autoref = autoref ..  name .. " = " .. saved[value] .. ";\n"
                        else
                                saved[value] = name

                                if isEmptyTable(value) then
                                        cart = cart .. " = {};\n"
                                else
                                        cart = cart .. " = {\n"

                                        for k, v in pairs(value) do
                                              k = basicSerialize(k)

                                              local fname = string_format("%s[%s]", name, k)
                                              field = string_format("[%s]", k)
                                              addToCart(v, fname, indent .. "   ", saved, field)
                                        end

                                        cart = cart .. indent .. "};\n"
                                end
                        end
                end
        end

        name = name or "table"

        if type(t) ~= "table" then
                  return name .. " = " .. basicSerialize(t)
        end

        cart, autoref = "", ""
        addToCart(t, name, indent)

        return cart .. autoref
end

local typeof = function(t)
        local _type = type(t)

        if _type == "userdata" then
                local metatable = getmetatable(t)

                if not metatable or not metatable.__index then
                        t, _type = "userdata", "string"
                end
        end

        if _type == "userdata" or _type == "table" then
                local _getType = t.__type or t.type or t.Type

                _type = type(_getType) == "function" and _getType(t) or type(_getType) == "string" and _getType or _type
        end

        return _type
end

PrintChat = function(...)
	local tV, len = {}, select("#", ...)

        for i = 1, len do
                local value = select(i, ...)
                local type = typeof(value)

                if type == "string" then
                        tV[i] = value
                elseif type == "vector" then
                        tV[i] = tostring(value)
                elseif type == "number" then
                        tV[i] = tostring(value)
                elseif type == "table" then
                        tV[i] = SerializeTable(value)
                elseif type == "boolean" then
                    	tV[i] = value and "true" or "false"
                else
                    	tV[i] = "<" .. type .. ">"
                end
        end

        if len > 0 then
                __PrintTextGame(table_concat(tV))
        end
end

GetPing = function()
        local latency = GetLatency()
        return latency / 1000
end

GetTrueAttackRange = function(unit)
        local unit = unit or myHero
        local attackRange = GetAttackRange(unit.Addr)
        local boundingRadius = GetBoundingRadius(unit.Addr)
        return attackRange + boundingRadius
end

GetPercentHP = function(unit)
        return unit.HP / unit.MaxHP * 100
end

GetPercentMP = function(unit)
        return unit.MP / unit.MaxMP * 100
end

IsValidTarget = function(unit, range)
        local range = range or math_huge
        local distance = GetDistance(unit)
        return unit and not unit.IsDead and unit.IsVisible and not unit.IsInvulnerable and distance <= range
end

VectorPointProjectionOnLineSegment = function(v1, v2, v)
        local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
        local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
        local pointLine = { x = ax + rL * (bx - ax), z = ay + rL * (by - ay) }
        local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
        local isOnSegment = rS == rL
        local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), z = ay + rS * (by - ay) }
        return pointSegment, pointLine, isOnSegment
end

VectorMovementCollision = function(startPoint1, endPoint1, v1, startPoint2, v2, delay)
	local sP1x, sP1y, eP1x, eP1y, sP2x, sP2y = startPoint1.x, startPoint1.z or startPoint1.y, endPoint1.x, endPoint1.z or endPoint1.y, startPoint2.x, startPoint2.z or startPoint2.y
        local d, e = eP1x - sP1x, eP1y - sP1y
        local dist, t1, t2 = math_sqrt(d * d + e * e), nil, nil
        local S, K = dist ~= 0 and v1 * d / dist or 0, dist ~= 0 and v1 * e / dist or 0
        local GetCollisionPoint = function(t) return t and {x = sP1x + S * t, y = sP1y + K * t} or nil end
        if delay and delay ~= 0 then sP1x, sP1y = sP1x + S * delay, sP1y + K * delay end
        local r, j = sP2x - sP1x, sP2y - sP1y
        local c = r * r + j * j

        if dist > 0 then
                if v1 == math.huge then
                        local t = dist / v1
                        t1 = v2 * t >= 0 and t or nil
                elseif v2 == math.huge then
                        t1 = 0
                else
                        local a, b = S * S + K * K - v2 * v2, -r * S - j * K
                        if a == 0 then
                                if b == 0 then
                                        t1 = c == 0 and 0 or nil
                                else
                                        local t = -c / (2 * b)
                                        t1 = v2 * t >= 0 and t or nil
                                end
                        else
                                local sqr = b * b - a * c
                                if sqr >= 0 then
                                        local nom = math_sqrt(sqr)
                                        local t = (-nom - b) / a
                                        t1 = v2 * t >= 0 and t or nil
                                        t = (nom - b) / a
                                        t2 = v2 * t >= 0 and t or nil
                                end
                        end
                end
        elseif dist == 0 then
                t1 = 0
        end

        return t1, GetCollisionPoint(t1), t2, GetCollisionPoint(t2), dist
end

FileExists = function(path)
        local f = io_open(path, 3)

        if f then
                io_close(f)
                return true
        else
                return false
        end
end

WriteFile = function(text, path, mode)
        local path = path or SCRIPT_PATH .. "\\" .. "out.txt"
        local f = io_open(path, mode or "w+")

        if not f then
                return false
        end

        f:write(text)
        f:close()
        return true
end

ReadFile = function(path)
        local f = io_open(path, 3)

        if not f then
                return "WRONG PATH"
        end

        local text = f:read("*all")
        f:close()
        return text
end

GetOrbMode = function()
        local comboKey = ReadIniInteger("OrbCore", "Combo Key", 32)
        local lastHitKey = ReadIniInteger("OrbCore", "LastHit Key", 88)
        local harassKey = ReadIniInteger("OrbCore", "Harass Key", 67)
        local laneClearKey = ReadIniInteger("OrbCore", "LaneClear Key", 86)

        if GetKeyPress(comboKey) > 0 then
                return 1
        elseif GetKeyPress(lastHitKey) > 0 then
                return 2
        elseif GetKeyPress(harassKey) > 0 then
                return 3
        elseif GetKeyPress(laneClearKey) > 0 then
                return 4
        end

        return 0
end

GetTarget = function(range, dmgType)
        local range = range or 1000
        local dmgType = dmgType or 1

        local t = GetTargetSelector(range, dmgType)

        if t ~= 0 then
                local t_ai = GetAIHero(t)

                return t_ai
        end
end

local delayedActions = {}
local delayedActionsExecuter = nil
DelayAction = function(func, delay, args)
        local gameTime = GetTimeGame

        if not delayedActionsExecuter then
                delayedActionsExecuter = function()
                        for i, funcs in pairs(delayedActions) do
                                if i <= gameTime() then
                                        for _, f in ipairs(funcs) do
                                                f.func(unpack(f.args or {}))
                                        end

                                        delayedActions[i] = nil
                                end
                        end
                end

                AddEvent(Enum.Event.OnTick, delayedActionsExecuter)
        end

        local time = gameTime() + (delay or 0)

        if delayedActions[time] then
                table_insert(delayedActions[time], { func = func, args = args })
        else
                delayedActions[time] = {
                        {
                                func = func,
                                args = args,
                        }
                }
        end
end

GetPath = function(unit, index)
	return Vector(unit.GetPath(index - 1))
end

GetPathCount = function(unit)
	return unit.PathCount
end

GetPathIndex = function(unit)
	local origin 	= Vector(unit)
	local curIndex 	= 0
	local pathCount = GetPathCount(unit) - 1

	for k = pathCount, 1, -1 do
            	if unit.GetPath(k) and unit.GetPath(k - 1) and (origin.x - Vector(unit.GetPath(k)).x) ^ 2 + (origin.z - Vector(unit.GetPath(k)).z) ^ 2 < (Vector(unit.GetPath(k - 1)).x - Vector(unit.GetPath(k)).x) ^ 2 + (Vector(unit.GetPath(k - 1)).z - Vector(unit.GetPath(k)).z) ^ 2 then
                    	curIndex = pathCount - k
                    	break
            	end
        end

        local result = math_abs(curIndex - pathCount)

        return result > 2 and result + 1 or 2
end

HasMovePath = function(unit)
	local pathCount = GetPathCount(unit)
	return pathCount > 1
end

GetRealHP = function(unit, dmgType)
        local mod = dmgType == 0 and unit.MagicShield or unit.Shield
        return unit.HP + mod
end

function table.contains(t, what, member)
        for i, v in pairs(t) do
                if member and v[member] == what or v == what then
                        return i, v
                end
        end
end

-----------------------------------------------------------------------------
-- SDK: Events
-----------------------------------------------------------------------------
local EventList = {
	[Enum.Event.OnLoad]          = {},
    	[Enum.Event.OnTick]          = {},
    	[Enum.Event.OnUpdate]        = {},
    	[Enum.Event.OnDraw]          = {},
    	[Enum.Event.OnUpdateBuff]    = {},
    	[Enum.Event.OnRemoveBuff]    = {},
    	[Enum.Event.OnProcessSpell]  = {},
    	[Enum.Event.OnCreateObject]  = {},
    	[Enum.Event.OnDeleteObject]  = {},
    	[Enum.Event.OnWndMsg]        = {},
    	[Enum.Event.OnDoCast]        = {},
    	[Enum.Event.OnPlayAnimation] = {},
    	[Enum.Event.OnNewPath]       = {},
    	[Enum.Event.OnVision]        = {},
    	[Enum.Event.OnDash]          = {},
    	[Enum.Event.OnKeyPress]      = {},
    	[Enum.Event.OnRecall] 	     = {},
    	[Enum.Event.OnBeforeAttack]  = {},
    	[Enum.Event.OnAttack]  	     = {},
    	[Enum.Event.OnAfterAttack]   = {},
    	[Enum.Event.OnIssueOrder]    = {},
	[Enum.Event.OnDrawMenu]      = {},
}

-- Custom Events
local Keys 		= {}
local Vision 		= {}
local NewPath 		= {}
local Recall 		= {}
local VisionTick 	= GetTickCount()
local WaypointTick 	= GetTickCount()
local RecallTick 	= GetTickCount()

for i = 1, 255, 1 do
        Keys[i] = false
end

local OnNewPath = function(unit)
	local unitPosTo = Vector(GetDestPos(unit.Addr))

	if not NewPath[unit.NetworkId] then
		NewPath[unit.NetworkId] = {
			pos = unitPosTo,
			speed = unit.MoveSpeed,
			time = os_clock()
		}
	end

	if NewPath[unit.NetworkId].pos ~= unitPosTo then
		local unitPos = Vector(unit)
                local isDash = unit.IsDash
                local dashSpeed = unit.DashSpeed or 0
                local dashGravity = unit.DashGravity or 0
                local dashDistance = GetDistance(unitPos, unitPosTo)

                NewPath[unit.NetworkId] = {
                	startPos = unitPos,
                	pos = unitPosTo ,
                	speed = unit.MoveSpeed,
                	time = os_clock()
                }

                local list = EventList[Enum.Event.OnNewPath]

                for i = 1, #list do
                	local cb = list[i]

                	cb(unit, unitPos, unitPosTo, isDash, dashSpeed, dashGravity, dashDistance)
                end

                if isDash then
                	local list = EventList[Enum.Event.OnDash]

                	for i = 1, #list do
                		local cb = list[i]

                		cb(unit, unitPos, unitPosTo, dashSpeed, dashGravity, dashDistance)
                	end
                end
	end
end

local OnRecall = function(unit)
	if not Recall[unit.NetworkId] then
		Recall[unit.NetworkId] = {
			state = unit.IsRecall,
			time = os_clock()
		}
	end

	if Recall[unit.NetworkId].state and not unit.IsRecall then
		Recall[unit.NetworkId].state = false
                Recall[unit.NetworkId].time = os_clock()

                local list = EventList[Enum.Event.OnRecall]

                for i = 1, #list do
                	local cb = list[i]
                	local state = Recall[unit.NetworkId].state
                	local time = Recall[unit.NetworkId].time

                	cb(unit, state, time)
                end
	end

	if not Recall[unit.NetworkId].state and unit.IsRecall then
		Recall[unit.NetworkId].state = true
                Recall[unit.NetworkId].time = os_clock()

                local list = EventList[Enum.Event.OnRecall]

                for i = 1, #list do
                	local cb = list[i]
                	local state = Recall[unit.NetworkId].state
                	local time = Recall[unit.NetworkId].time

                	cb(unit, state, time)
                end
	end
end

local OnVision = function(unit)
	if not Vision[unit.NetworkId] then
		Vision[unit.NetworkId] = {
			state = unit.IsVisible,
			time = os_clock()
		}
	end

	if Vision[unit.NetworkId].state and not unit.IsVisible then
		Vision[unit.NetworkId].state = false
                Vision[unit.NetworkId].time = os_clock()

                local list = EventList[Enum.Event.OnVision]

                for i = 1, #list do
                	local cb = list[i]
                	local state = Vision[unit.NetworkId].state
                	local time = Vision[unit.NetworkId].time

                	cb(unit, state, time)
                end
	end

	if not Vision[unit.NetworkId].state and unit.IsVisible then
		Vision[unit.NetworkId].state = true
                Vision[unit.NetworkId].time = os_clock()

                local list = EventList[Enum.Event.OnVision]

                for i = 1, #list do
                	local cb = list[i]
                	local state = Vision[unit.NetworkId].state
                	local time = Vision[unit.NetworkId].time

                	cb(unit, state, time)
                end
	end
end

local OnNewPathLoop = function()
	local tick = GetTickCount()

	if tick - WaypointTick > 50 then
                SearchAllChamp()
                local h = pObjChamp
                for k, v in pairs(h) do
                        if IsChampion(v) then
                        	local v_ai = GetAIHero(v)
                                OnNewPath(v_ai)
                        end
                end

                WaypointTick = tick
        end
end

local OnVisionLoop = function()
	local tick = GetTickCount()

	if tick - VisionTick > 50 then
                SearchAllChamp()
                local h = pObjChamp
                for k, v in pairs(h) do
                        if IsChampion(v) then
                        	local v_ai = GetAIHero(v)
                                OnVision(v_ai)
                        end
                end

                VisionTick = tick
        end
end

local OnRecallLoop = function()
	local tick = GetTickCount()

	if tick - RecallTick > 50 then
                SearchAllChamp()
                local h = pObjChamp
                for k, v in pairs(h) do
                        if IsChampion(v) then
                        	local v_ai = GetAIHero(v)
                                OnRecall(v_ai)
                        end
                end

                RecallTick = tick
        end
end

local OnKeyPressLoop = function()
	for i = 1, 255, 1 do
                if i ~= 117 and i ~= 118 then
                        local keyState = GetKeyPress(i) > 0

                        if Keys[i] ~= keyState then
                                local list = EventList[Enum.Event.OnKeyPress]

		                for j = 1, #list do
		                	local cb = list[j]

		                	cb(i, keyState)
		                end
                        end

                        Keys[i] = keyState
                end
        end
end

function OnLoad()
        local list = EventList[Enum.Event.OnLoad]
        for i = 1, #list do
        	local cb = list[i]
        	cb()
        end
end

function OnTick()
        myHero = GetMyHero()

        local list = EventList[Enum.Event.OnTick]
        for i = 1, #list do
        	local cb = list[i]
        	cb()
        end
end

function OnUpdate()
        local list = EventList[Enum.Event.OnUpdate]
        for i = 1, #list do
        	local cb = list[i]
        	cb()
        end

        local visionList   = EventList[Enum.Event.OnVision]
        local newPathList  = EventList[Enum.Event.OnNewPath]
        local keyPressList = EventList[Enum.Event.OnKeyPress]
        local recallList   = EventList[Enum.Event.OnRecall]

        if #visionList > 0 then
        	OnVisionLoop()
        end

        if #newPathList > 0 then
        	OnNewPathLoop()
        end

        if #keyPressList > 0 then
        	OnKeyPressLoop()
        end

        if #recallList > 0 then
        	OnRecallLoop()
        end
end

function OnDraw()
        local list = EventList[Enum.Event.OnDraw]
        for i = 1, #list do
        	local cb = list[i]
        	cb()
        end
end

function OnUpdateBuff(source, unit, buff, stacks)
        local list = EventList[Enum.Event.OnUpdateBuff]
        for i = 1, #list do
        	local cb = list[i]
        	cb(source, unit, buff, stacks)
        end
end

function OnRemoveBuff(unit, buff)
        local list = EventList[Enum.Event.OnRemoveBuff]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, buff)
        end
end

function OnProcessSpell(unit, spell)
        local list = EventList[Enum.Event.OnProcessSpell]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, spell)
        end
end

function OnCreateObject(unit)
        local list = EventList[Enum.Event.OnCreateObject]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit)
        end
end

function OnDeleteObject(unit)
        local list = EventList[Enum.Event.OnDeleteObject]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit)
        end
end

function OnWndMsg(msg, key)
        local list = EventList[Enum.Event.OnWndMsg]
        for i = 1, #list do
        	local cb = list[i]
        	cb(msg, key)
        end
end

function OnDoCast(unit, spell)
        local list = EventList[Enum.Event.OnDoCast]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, spell)
        end
end

function OnPlayAnimation(unit, anim)
        local list = EventList[Enum.Event.OnPlayAnimation]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, anim)
        end
end

function OnBeforeAttack(target)
	local list = EventList[Enum.Event.OnBeforeAttack]
        for i = 1, #list do
        	local cb = list[i]
        	cb(target)
        end
end

function OnAttack(unit, target)
	local list = EventList[Enum.Event.OnAttack]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, target)
        end
end

function OnAfterAttack(unit, target)
	local list = EventList[Enum.Event.OnAfterAttack]
        for i = 1, #list do
        	local cb = list[i]
        	cb(unit, target)
        end
end

function OnIssueOrder(order, x, z)
	local list = EventList[Enum.Event.OnIssueOrder]
        for i = 1, #list do
        	local cb = list[i]
        	cb(order, x, z)
        end
end

function OnDrawMenu()
	local list = EventList[Enum.Event.OnDrawMenu]
        for i = 1, #list do
        	local cb = list[i]
        	cb()
        end
end

AddEvent = function(enum, func)
	local list = EventList[enum]
	list[#list + 1] = func
end

-----------------------------------------------------------------------------
-- SDK: Vector
-----------------------------------------------------------------------------

class "Vector"

local function IsVector(v)
        return v and v.x and type(v.x) == "number" and ((v.y and type(v.y) == "number") or (v.z and type(v.z) == "number"))
end

function Vector:__init(a, b, c)
        self.type = "vector"

        if a == nil then
                self.x, self.y, self.z = 0.0, 0.0, 0.0
        elseif b == nil then

                self.x, self.y, self.z = a.x, a.y, a.z
        else
                self.x = a
                if b and type(b) == "number" then self.y = b end
                if c and type(c) == "number" then self.z = c end
        end
end

function Vector:__tostring()
        if self.y and self.z then
                return "Vector(" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ")"
        else
                return "Vector(" .. tostring(self.x) .. "," .. self.y and tostring(self.y) or tostring(self.z) .. ")"
        end
end

function Vector:__add(v)
        return Vector(self.x + v.x, (v.y and self.y) and self.y + v.y, (v.z and self.z) and self.z + v.z)
end

function Vector:__sub(v)
        return Vector(self.x - v.x, (v.y and self.y) and self.y - v.y, (v.z and self.z) and self.z - v.z)
end

function Vector.__mul(a, b)
        if type(a) == "number" and IsVector(b) then
                return Vector({ x = b.x * a, y = b.y and b.y * a, z = b.z and b.z * a })
        elseif type(b) == "number" and IsVector(a) then
                return Vector({ x = a.x * b, y = a.y and a.y * b, z = a.z and a.z * b })
        else
                return a:DotProduct(b)
        end
end

function Vector.__div(a, b)
        if type(a) == "number" and IsVector(b) then
                return Vector({ x = a / b.x, y = b.y and a / b.y, z = b.z and a / b.z })
        else
                return Vector({ x = a.x / b, y = a.y and a.y / b, z = a.z and a.z / b })
        end
end

function Vector.__lt(a, b)
        return a:Len() < b:Len()
end

function Vector.__le(a, b)
        return a:Len() <= b:Len()
end

function Vector:__eq(v)
        return self.x == v.x and self.y == v.y and self.z == v.z
end

function Vector:__unm()
        return Vector(-self.x, self.y and -self.y, self.z and -self.z)
end

function Vector:Clone()
        return Vector(self)
end

function Vector:Unpack()
    return self.x, self.y, self.z
end

function Vector:Len2(v)
        local v = v and Vector(v) or self
        return self.x * v.x + (self.y and self.y * v.y or 0) + (self.z and self.z * v.z or 0)
end

function Vector:Len()
        return math_sqrt(self:Len2())
end

function Vector:DistanceTo(v)
        local a = self - v
        return a:Len()
end

function Vector:Normalize()
        local l = self:Len()
        self.x = self.x / l
        self.y = self.y / l
        self.z = self.z / l
end

function Vector:Normalized()
        local v = self:Clone()
        v:Normalize()
        return v
end

function Vector:Center(v)
        return Vector((self + v) / 2)
end

function Vector:CrossProduct(v)
        return Vector({ x = v.z * self.y - v.y * self.z, y = v.x * self.z - v.z * self.x, z = v.y * self.x - v.x * self.y })
end

function Vector:DotProduct(v)
        return self.x * v.x + (self.y and (self.y * v.y) or 0) + (self.z and (self.z * v.z) or 0)
end

function Vector:ProjectOn(v)
        local s = self:Len2(v) / v:Len2()
        return Vector(v * s)
end

function Vector:MirrorOn(v)
        return self:ProjectOn(v) * 2
end

function Vector:Sin(v)
        local a = self:CrossProduct(v)
        return math_sqrt(a:Len2() / (self:Len2() * v:Len2()))
end

function Vector:Cos(v)
        return self:Len2(v) / math_sqrt(self:Len2() * v:Len2())
end

function Vector:Angle(v)
        return math_acos(self:Cos(v))
end

function Vector:AffineArea(v)
        local a = self:CrossProduct(v)
        return math_sqrt(a:Len2())
end

function Vector:TriangleArea(v)
        return self:AffineArea(v) / 2
end

function Vector:RotateX(phi)
        local c, s = math_cos(phi), math_sin(phi)
        self.y, self.z = self.y * c - self.z * s, self.z * c + self.y * s
end

function Vector:RotateY(phi)
        local c, s = math_cos(phi), math_sin(phi)
        self.x, self.z = self.x * c + self.z * s, self.z * c - self.x * s
end

function Vector:RotateZ(phi)
        local c, s = math_cos(phi), math_sin(phi)
        self.x, self.y = self.x * c - self.z * s, self.y * c + self.x * s
end

function Vector:Rotate(phiX, phiY, phiZ)
        if phiX ~= 0 then self:RotateX(phiX) end
        if phiY ~= 0 then self:RotateY(phiY) end
        if phiZ ~= 0 then self:RotateZ(phiZ) end
end

function Vector:Rotated(phiX, phiY, phiZ)
        local v = self:Clone()
        v:Rotate(phiX, phiY, phiZ)
        return v
end

local function close(a, b, eps)
        eps = eps or 1e-9
        return math_abs(a - b) <= eps
end

function Vector:Polar()
        if close(self.x, 0, 0) then
                if self.z or self.y > 0 then
                        return 90
                elseif self.z or self.y < 0 then
                        return 270
                else
                        return 0
                end
        else
                local theta = math_deg(math_atan((self.z or self.y) / self.x))

                if self.x < 0 then
                        theta = theta + 180
                end

                if theta < 0 then
                        theta = theta + 360
                end

                return theta
        end
end

function Vector:AngleBetween(v1, v2)
        local p1, p2 = (-self + v1), (-self + v2)
        local theta = p1:Polar() - p2:Polar()

        if theta < 0 then
                theta = theta + 360
        end

        if theta > 180 then
                theta = 360 - theta
        end

        return theta
end

function Vector:Perpendicular()
        return Vector(-self.z, self.y, self.x)
end

function Vector:Perpendicular2()
        return Vector(self.z, self.y, -self.x)
end

function Vector:Extended(to, distance)
        return self + (to - self):Normalized() * distance
end

function Vector:RotateAroundPoint(v, angle)
        local cos, sin = math_cos(angle), math_sin(angle)
        local x = ((self.x - v.x) * cos) - ((v.y - self.y) * sin) + v.x
        local y = ((v.y - self.y) * cos) + ((self.x - v.x) * sin) + v.y
        return Vector(x, y, self.z or 0)
end

-----------------------------------------------------------------------------
-- SDK: DamageLib
-----------------------------------------------------------------------------

local function GetAD(unit,factor) return (factor or 1) * unit.TotalDmg end
local function GetPer100AD(unit,factor) return (factor or 1) * (GetAD(unit) / 100) end -- value / 100 * GetAD(source)
local function GetAP(unit,factor) return (factor or 1) * unit.MagicDmg end
local function GetPer100AP(unit,factor) return (factor or 1) * (GetAP(unit) / 100) end -- value / 100 * GetAP(source)
local function GetBonusAD(unit,factor) return (factor or 1) * unit.BonusDmg end
local function GetPer100BonusAD(unit,factor) return (factor or 1) * (GetBonusAD(unit) / 100) end -- value / 100 * GetBonusAD(source)
local function GetCurrentHP(unit,factor) return (factor or 1) * unit.HP end
local function GetMaxHP(unit,factor) return (factor or 1) * unit.MaxHP end
local function GetPercentHP(unit) return unit.HP / unit.MaxHP end
local function GetMissingHP(unit,factor) return (factor or 1) * (GetMaxHP(unit) - GetCurrentHP(unit)) end  -- GetMaxHP(unit) - GetCurrentHP(unit)) / GetMaxHP(unit)
local function GetCurrentMana(unit,factor) return (factor or 1) * unit.MP end
local function GetMaxMana(unit,factor) return (factor or 1) * unit.MaxMP end
local function GetLevel(unit,factor) return unit.Level end
local function GetArmor(unit,factor) return (factor or 1) * unit.Armor end
local function GetBonusArmor(unit,factor) return (factor or 1) * unit.BonusArmor end
local function GetBaseArmor(unit,factor) return (factor or 1) * (unit.Armor - unit.BonusArmor) end
local function GetMagicArmor(unit,factor) return (factor or 1) * unit.MagicArmor end
local function GetBonusMagicArmor(unit,factor) return (factor or 1) * unit.BonusMagicArmor end
local function GetBaseMagicArmor(unit,factor) return (factor or 1) * (unit.MagicArmor - unit.BonusMagicArmor) end
local function GetBonusCriticalDamage(unit,factor) return (factor or 1) * unit.BonusCriticalDamage end
local function GetMoveSpeed(unit,factor) return (factor or 1) * unit.MoveSpeed end
local function GetCastLevel(unit, slot) return unit.LevelSpell(slot) end

local DamageLibTable = {
  ["Aatrox"] = {
    {Slot = 0, Stage = 1, SpellEffectType = 2, DamageType = 1, Damage = function(source, target, level) return ({20, 50, 80, 110, 1400})[level] + GetAD(source,1.1) end},
    {Slot = 1, Stage = 1, SpellEffectType = 0, DamageType = 1, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + GetBonusAD(source,0.75) end},
    {Slot = 2, Stage = 1, SpellEffectType = 2, DamageType = 1, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetBonusAD(source,0.7) end},
    {Slot = 3, Stage = 1, SpellEffectType = 2, DamageType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source) end},
  },

  ["Ahri"] = {
    {Slot = 0, Stage = 1, SpellEffectType = 5, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.35) end},
    {Slot = 0, Stage = 2, SpellEffectType = 5, DamageType = 3, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.35) end},
    {Slot = 1, Stage = 1, SpellEffectType = 5, DamageType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 2, SpellEffectType = 0, DamageType = 2, Damage = function(source, target, level) return ({64, 104, 144, 184, 224})[level] + GetAP(source,0.45) end},
    {Slot = 2, Stage = 1, SpellEffectType = 3, DamageType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, SpellEffectType = 5, DamageType = 2, Damage = function(source, target, level) return ({70, 110, 150})[level] + GetAP(source,0.25)  end},
  },

  ["Akali"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({35, 55, 75, 95, 115})[level] + GetAP(source,0.4) end},
    {Slot = 0, Stage = 3, DamageType = 2, SpellEffectType = 0, Damage = function(source, target, level) return ({45, 70, 95, 120, 145})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + GetAP(source,0.6) + GetAD(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 100, 150})[level] + GetAP(source,0.35) end},
  },

  ["Alistar"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({55, 110, 165, 220, 275})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + GetAP(source,0.4) end}, -- 1sec per dmg
  },

  ["Amumu"] = { -- fk amumu need passvie check >> target 10% magig true dmg
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({10, 15, 20, 25, 30})[level] + GetMaxHP(target,({0.01, 0.0125, 0.015, 0.0175, 0.02})[level] + GetAP(source)/100 ) end}, -- 1sec per dmg
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 100, 125, 150, 175})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.8) end},
  },

  ["Anivia"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + GetAP(source,0.4) end},
    {Slot = 0, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 15, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level]*2 + GetAP(source) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 60, 80})[level] + GetAP(source,0.125) end},
    {Slot = 3, Stage = 15, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({120, 180, 240})[level] + GetAP(source,0.375) end},
  },

  ["Annie"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + GetAP(source,0.8) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.85) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({150, 275, 400})[level] + GetAP(source,0.65) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({10, 15, 20})[level] + GetAP(source,0.1) end}, -- per tick
  },

  ["Ashe"] = {
    {Slot = 0, Stage = 1, IsApplyOnHit = true, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({0.21, 0.22, 0.23, 0.24, 0.25})[level] * GetAD(source) end}, -- OnHit SPELL
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + GetAD(source) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({200, 400, 600})[level] + GetAP(source) end},
    {Slot = 3, Stage = 2, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 200, 300})[level] + GetAP(source,0.5) end}, -- Splash dmg
  },

  ["AurelionSol"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.65) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
  },

  ["Azir"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 62, 64, 66, 68, 70, 75, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180})[source.level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 450})[level] + GetAP(source,0.6) end},
  },

  ["Blitzcrank"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + GetAP(source) end},
    {Slot = 2, Stage = 1, IsApplyOnHit = true, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return GetAP(source) end}, -- OnHit SPELL
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({250, 375, 500})[level] + GetAP(source) end},
    {Slot = 3, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 200, 300})[level] + GetAP(source,0.2) end},
  },

  ["Bard"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetAP(source,0.65) end},
  },

  ["Brand"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + GetAP(source,0.55) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + GetAP(source,0.35) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({100, 200, 300})[level] + GetAP(source,0.25) end},
  },

  ["Braum"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetMaxHP(source,0.025) end},
    {Slot = 0, Stage = 12, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return 6.4 + GetLevel(source) * 1.6 end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.6) end},
  },

  ["Caitlyn"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({30, 70, 110, 150, 190})[level] + GetAD(source,({1.3, 1.4, 1.5, 1.6, 1.7})[level]) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({20.1, 46.9, 73.7, 100.5, 127.3})[level] + GetAD(source,({0.871, 0.938, 1.005, 1.072, 1.139})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({40, 90, 140, 190, 240})[level] + GetBonusAD(source,({0.4, 0.55, 0.7, 0.85, 1.0})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({250, 475, 700})[level] + GetBonusAD(source,2.0) end},
  },

  ["Camille"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({0.2, 0.25, 0.3, 0.35, 0.4})[level] * GetAD(source) end},
    {Slot = 0, Stage = 15, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({0.4, 0.5, 0.6, 0.7, 0.8})[level] * GetAD(source) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + GetBonusAD(source,0.6) end},
    {Slot = 1, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + GetBonusAD(source,0.6) + GetMaxHP(source,({0.06, 0.065, 0.07, 0.075, 0.08})[level] + GetAD(source,0.03) / 100) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + GetAD(source,0.75) end},
  },

  ["Cassiopeia"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + GetAP(source,0.15) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return 48 + 4 * source.level + GetAP(source,0.1) + ({10, 30, 50, 70, 90})[level] + GetAP(source,0.5) or 0 end},
    {Slot = 2, Stage = 15, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return 48 + 4 * source.level + GetAP(source,0.1) +  GetBuffStack(target.Addr, "poison") > 0 and ({10, 30, 50, 70, 90})[level] + GetAP(source,0.5) or 0 end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.5) end},
  },

  ["Chogath"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + GetAP(source) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 125, 175, 225, 275})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.3) + GetMaxHP(target,GetBuffStack(source.Addr, "vorpalspikes") > 0 and 1 * 0.005 + 0.03) end},
    {Slot = 3, Stage = 1, DamageType = 3, SpellEffectType = 3, Damage = function(source, target, level) return ({300, 475, 650})[level] + GetAP(source,0.5) + 0.1 * (source.MaxHP - (574.4 + 80 * source.level - 80)) end}, -- need check
  },

  ["Corki"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + GetAP(source,0.5) * GetBonusAD(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.4) end},
    {Slot = 1, Stage = 15, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 47.5, 65, 82.5, 100})[level] + GetBonusAD(source,1.5) + GetAP(source,0.2) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({20, 35, 50, 65, 80})[level] + GetBonusAD(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 100, 125})[level] + GetAP(source,0.2) + GetAD(source,({0.15, 0.45, 0.75})[level]) end},
    {Slot = 3, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 200, 255})[level] + GetAP(source,0.4) + GetAD(source,({0.3, 0.90, 1.5})[level]) end},
  },

  ["Darius"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + GetAD(source,(({1, 1.1, 1.2, 1.3, 1.4})[level])) end},
    {Slot = 1, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetAD(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 3, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 200, 300})[level] + GetBonusAD(source,0.75) + GetBuffStack(source.Addr, "dariushemo") > 0 and ({20, 40, 60})[level] * 0.15 end},

  },

  ["Diana"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({22, 34, 46, 58, 70})[level] + GetAP(source,0.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, DDamage = function(source, target, level) return ({100, 160, 220})[level] + GetAP(source,0.6) end},
  },

  ["DrMundo"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) if target.Type == 1 then return math.min(({300, 350, 400, 450, 500})[level],math.max(({80, 130, 180, 230, 280})[level], ({15, 17.5, 20, 22.5, 25})[level] / 100 * target.HP)) end; return math.max(({80, 130, 180, 230, 280})[level],({15, 17.5, 20, 22.5, 25})[level] / 100 * target.HP) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 55, 70, 85, 100})[level] + GetAP(source,0.2) end},
    {Slot = 2, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(source,({0.03, 0.035, 0.04, 0.045, 0.05})[level] + 0.2) end}
  },

  ["Draven"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({35, 40, 45, 50, 55})[level] + GetBonusAD(source,({0.65, 0.75, 0.85, 0.95, 0.105})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({75, 110, 145, 180, 215})[level] + GetBonusAD(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({175, 275, 375})[level] + GetBonusAD(source,1.1) end},
    {Slot = 3, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150})[level] + GetBonusAD(source,0.44) end},

  },

  ["Ekko"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 75, 90, 105, 120})[level] + GetAP(source,0.3) end},
    {Slot = 0, Stage = 2, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, IsApplyOnHit = true , SpellEffectType = 1, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 300, 450})[level] + GetAP(source,1.5) end}
  },

  ["Elise"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 75, 110, 145, 180})[level] + GetCurrentHP(target, 0.04 + (GetPer100AP(source,0.03))) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetCurrentHP(target, 0.08 + (GetPer100AP(source,0.03))) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 95, 135, 175, 215})[level] + GetAP(sourceo, 0.95) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({10, 15, 20, 25})[level] + GetAP(source,0.15) end},
  },

  ["Evelynn"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({25, 30, 35, 40, 45})[level] + GetAP(source,0.3) end},
    {Slot = 0, Stage = 3, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 20, 30, 40, 50})[level] + GetAP(source,0.25) end},
    {Slot = 0, Stage = 7, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({25, 30, 35, 40, 45})[level] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({250, 300, 350, 400, 450})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + GetMaxHP(target, 0.04 + (GetPer100AP(source,0.03))) end},
    {Slot = 2, Stage = 15, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] +  GetMaxHP(target, 0.06 + (GetPer100AP(source,0.04))) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 275, 400})[level] + GetAP(source,0.75) end},
    {Slot = 3, Stage = 15, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({300, 550, 800})[level] + GetAP(source,1.5) end},
  },

  ["Ezreal"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({35, 55, 75, 95, 115})[level] + GetAP(source,0.4) + GetAD(source,1.1) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.8) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + GetAP(source,0.75) + GetBonusAD(source, .5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({350, 500, 650})[level] + GetAP(source,0.9) + GetAD(source) end},
  },

  ["Fiddlesticks"] = {
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({80, 105, 130, 155, 180})[level] + GetAP(source,0.45) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({65, 85, 105, 125, 145})[level] + GetAP(source,0.45) end},
    {Slot = 2, Stage = 9, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({97.5, 127.5, 157.5, 187.5, 217.5})[level] + GetAP(source,0.675) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({125, 225, 325})[level] + GetAP(source,0.45) end},
  },

  ["Fiora"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 80, 90, 100, 110})[level] + GetBonusAD(source,({0.95, 1, 1.05, 1.1, 1.15})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({90, 130, 170, 210, 250})[level] + GetAP(source) end},
  },

  ["Fizz"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({10, 25, 40, 55, 70})[level] + GetAD(source) + GetAP(source,0.35) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.4) end},
    {Slot = 1, Stage = 15, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,1.2) end},
    {Slot = 1, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + GetAP(source,0.75) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 5, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({225, 325, 425})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 6, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({300, 400, 500})[level] + GetAP(source,0.6) end},
  },

  ["Galio"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + GetAP(source,0.9) end},
    {Slot = 0, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({10, 13.3, 16.7, 20, 23.3})[level] + GetAP(source,0.2) + GetMaxHP(target,GetPer100AP(source,0.03)) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.2) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({100, 130, 160, 190, 220})[level] + GetAP(source,0.9) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
  },

  ["Gangplank"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + GetAD(source) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + GetAD(source) end}, -- need add ignoring armor (-40%)
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 60, 85})[level] + GetAP(source,0.1) end},
  },

  ["Garen"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetAD(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({14, 18, 22, 26, 30})[level] + GetAD(source,({0.36, 0.37, 0.38, 0.39, 0.40})[level]) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({175, 350, 525})[level] + ({28.66, 33.33, 40})[level] / 100 * (GetMaxHP(target) - GetCurrentHP(target)) end},
  },

  ["Gnar"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({5, 45, 85, 125, 165})[level] + GetAD(source,1.15) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({5, 45, 85, 125, 165})[level] + GetAD(source,1.2) end},
    {Slot = 1, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 20, 30, 40, 50})[level] + GetAP(source) +GetMaxHP(target,({0.06, 0.08, 0.1, 0.12, 0.14})[level]) end},
    {Slot = 1, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({25, 45, 65, 85, 105})[level] + GetAD(source) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 60, 100, 140, 180})[level] + GetMaxHP(source,0.06) end},
    {Slot = 2, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 60, 100, 140, 180})[level] + GetMaxHP(source,0.06) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source,0.5) + GetBonusAD(source,0.2) end},
    {Slot = 3, Stage = 14, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({300, 450, 600})[level] + GetAP(source,0.75) + GetBonusAD(source,0.3) end},
  },

  ["Gragas"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 50, 80, 110, 140})[level] + GetMaxHP(target,0.08) + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source,0.7) end},
  },

  ["Graves"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({45, 60, 75, 90, 105})[level] + GetBonusAD(source) end},
    {Slot = 0, Stage = 2, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({85, 115, 145, 175, 205})[level] + GetBonusAD(source,({0.4, 0.7, 1, 1.3, 1.6})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({250, 400, 550})[level] + GetAD(source,1.5) end},
    {Slot = 3, Stage = 13, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 320, 440})[level] + GetAD(source,1.2) end},
  },

  ["Hecarim"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 90, 125, 160, 195})[level] + GetBonusAD(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.2) end},
    {Slot = 2, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({45, 80, 115, 150, 185})[level] + GetBonusAD(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source) end},
  },

  ["Heimerdinger"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({6, 9, 12, 15, 18})[level] + GetAP(source,0.3) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({80, 100, 120})[GetCastLevel(source, _R)] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.45) end},
    {Slot = 1, Stage = 5, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({135, 180, 225})[GetCastLevel(source, _R)] + GetAP(source,0.45) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[GetCastLevel(source, _R)] + GetAP(source,0.75) end},
  },

  ["Illaoi"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({10, 20, 30, 40, 50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180})[GetLevel(source)] + GetAD(source,1.2) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(target,({0.03, 0.035, 0.04, 0.045, 0.05})[level]) + GetPer100AD(source,0.02) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({0.25, 0.30, 0.35, 0.40, 0.45})[level] + GetPer100AD(source,0.08) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetBonusAD(source,0.5) end},
  },

  ["Irelia"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 50, 80, 110, 140})[level] + GetAD(source,1.2) end},
    {Slot = 1, Stage = 1, DamageType = 3, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({15, 30, 45, 60, 75})[level] end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({80, 120, 160})[level] + GetBonusAD(source,0.7) + GetAP(source,0.5) end},
  },

  ["Ivern"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + GetAP(source,0.8) end},
  },

  ["Janna"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + GetAP(source,0.35) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({60, 115, 170, 225, 280})[level] + GetAP(source,0.5) end},
  },

  ["JarvanIV"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetBonusAD(source,1.2) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAD(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 325, 450})[level] + GetBonusAD(source,1.5) end},
  },

  ["Jax"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetBonusAD(source) + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({40, 75, 110, 145, 180})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + GetBonusAD(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({100, 160, 220})[level] + GetAP(source,0.7) end},
  },

  ["Jayce"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({45, 80, 115, 150, 185, 220})[level] + GetBonusAD(source,1.2) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270, 320})[level] + GetBonusAD(source,1.2) end},
    {Slot = 0, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({98, 168, 238, 308, 378, 448})[level] + GetBonusAD(source,1.68) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({25, 40, 55, 70, 85, 100})[level] + GetAP(source,0.25) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return GetMaxHP(target, (({0.08, 0.104, 0.128, 0.152, 0.176, 0.2})[level]) + GetBonusAD(source)) end},
  },

  ["Jhin"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + GetAD(source,({0.3, 0.35, 0.4, 0.45, 0.5})[level]) + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + GetAD(source,0.5) end},
    {Slot = 1, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({37.5, 63.75, 90, 116.25, 142.5})[level] + GetAD(source,0.375) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 80, 140, 200, 260})[level] + GetAD(source,1.2) + GetAP(source) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 115, 180})[level] + GetAD(source,0.2) * (1 + (100 - GetPercentHP(target)) * 1.025) end},
    {Slot = 3, Stage = 5, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 230, 360})[level] + 0.4 * source.totalDamage * (1 + (100 - GetPercentHP(target)) * 1.025) + GetBonusCriticalDamage(source,0.01) end}, -- Need debug
  },

  ["Jinx"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 2, Damage = function(source, target, level) return GetAD(source,0.1) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({10, 60, 110, 160, 210})[level] + GetAD(source,1.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + GetAP(source) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({25, 35, 45})[level] + GetMissingHP(target,({0.25, 0.30, 0.35})[level]) + GetBonusAD(source,0.15) end},
    {Slot = 3, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({250, 350, 450})[level] + GetMissingHP(target,({0.25, 0.30, 0.35})[level]) + GetBonusAD(source,0.15) end},
    {Slot = 3, Stage = 13, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 28, 36})[level] + GetMissingHP(target,({0.20, 0.24, 0.28})[level]) + GetBonusAD(source,0.12) end},
  },

  ["Kalista"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({10, 70, 130, 190, 250})[level] + GetAD(source) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(target, ({0.05, 0.075, 0.1, 0.125, 0.15})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) local count = GetBuffStack(target.Addr, "kalistaexpungemarker") if count > 0 then return (({20, 30, 40, 50, 60})[level] + GetAD(source)) + ((count - 1)*(({10, 14, 19, 25, 32})[level]+({0.2, 0.225, 0.25, 0.275, 0.3})[level] * GetAD(source))) end; return 0 end},
  },

  ["Karma"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetAP(source,0.6) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + ({25, 75, 125, 175})[GetCastLevel(source, _R)] + GetAP(source,0.9) end},
    {Slot = 0, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 150, 250, 350})[level] + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetAP(source,0.45) end},
    {Slot = 1, Stage = 3, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetAP(source,0.45) end},
  },

  ["Karthus"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return (({40, 60, 80, 100, 120})[level] + GetAP(source,0.3)) end}, -- AOE / single target*2
    {Slot = 2, Stage = 4, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + GetAP(source,0.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({250, 400, 550})[level] + GetAP(source,0.75) end},
  },

  ["Kassadin"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, Damage = function(source, target, level) return ({80, 105, 130, 155, 180})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 100, 120})[level] + GetAP(source,0.3) + GetMaxMana(source,0.02) end}, -- need stack check "RiftWalk" name
    {Slot = 3, Stage = 12, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 50, 60})[level] + GetAP(source,0.1) + GetMaxMana(source,0.01) end}, -- need stack check "RiftWalk" name
  },

  ["Katarina"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({75, 105, 135, 165, 195})[level] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + GetAP(source,0.25) + GetAD(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({150.6025, 225.90375, 301.205})[level] + GetBonusAD(({1.325302, 1.325302, 1.325302})[level]) + GetAP(({1.144579, 1.144579, 1.144579})[level]) end},
  },

  ["Kayle"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + GetAP(source,0.6) + GetBonusAD(source) end},
    {Slot = 2, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 5, Damage = function(source, target, level) return source.range > 500 and ({20, 30, 40, 50, 60})[level] + GetAP(source,0.3) or ({10, 15, 20, 25, 30})[level] + GetAP(source,0.15) end},
    {Slot = 2, Stage = 13, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 5, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetAP(source,0.3) + GetAD(source,({0.2, 0.25, 0.30, 0.35, 0.4})[level]) end},
  },

  ["Kayn"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 75, 95, 115, 135})[level] + GetBonusAD(source,0.65) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 75, 95, 115, 135})[level] + GetBonusAD(source,0.65) end},
    {Slot = 0, Stage = 6, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 250, 300, 350, 400})[level] + GetBonusAD(source,0.5) + GetMaxHP(target,0.05+GetPer100AD(source,0.04)) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetBonusAD(source,1.2) end},
    {Slot = 1, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetBonusAD(source,1.3) end},
    {Slot = 1, Stage = 6, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetBonusAD(source,1.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetBonusAD(source,1.5) end},
    {Slot = 3, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetBonusAD(source,1.5) end},
    {Slot = 3, Stage = 6, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return GetMaxHP(target,0.1 + GetPer100AD(source,0.13)) end},
},

  ["Kennen"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({75, 115, 155, 195, 235})[level] + GetAP(source,0.75) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + GetAP(source,0.55) end},
    {Slot = 1, Stage = 12, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({15, 20, 25, 30, 35})[level] + GetBonusAD(source,0.6) + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({85, 125, 165, 205, 245})[level] + GetAP(source,0.8) end},
    {Slot = 2, Stage = 9, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return (({85, 125, 165, 205, 245})[level] + GetAP(source,0.8)) / 2 end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 72.5, 105})[level] + GetAP(source,0.2) end},
},

  ["Khazix"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({65, 90, 115, 145, 165})[level] + GetBonusAD(source,1.1) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({107, 148, 189, 231, 272})[level] + GetBonusAD(source,1.815) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({85, 115, 145 ,170, 205})[level] + GetBonusAD(source) end},
    {Slot = 1, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({85, 115, 145 ,170, 205})[level] + GetBonusAD(source,1.2) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({65, 100, 135, 170, 205})[level] + GetBonusAD(source,0.2) end},
  },

  ["Kindred"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + GetBonusAD(source,0.65) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({25, 30, 35, 40, 45})[level] + GetBonusAD(source,0.2) + GetCurrentHP(target,0.015) end}, -- need Add "TODO" buff check ops 1%
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({65, 85, 105, 125, 145})[level] + GetBonusAD(source,0.8) + GetMissingHP(target,0.08) end}, -- need Add "TODO" buff check ops 0.5% and minion maxdmg 300
  },

  ["Kled"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetBonusAD(source,0.6) end},
    {Slot = 0, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({37.5, 75, 1125.5, 150, 187})[level] + GetBonusAD(source,0.9) end},
    {Slot = 0, Stage = 3, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + GetBonusAD(source,1.2) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + GetBonusAD(source,0.8) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 30, 40, 50, 60})[level] + GetMaxHP(target,({0.045, 0.05, 0.055, 0.06, 0.065})[level] + (GetBonusAD(source) / 20) / 100) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({35, 60, 85, 11, 135})[level] + GetBonusAD(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return GetMaxHP(target,({0.12, 0.15, 0.18})[level] + GetPer100BonusAD(source,0.12)) end},
},

["Kogmaw"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + GetAP(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) local dmg = (({0.03, 0.04, 0.05, 0.06, 0.07})[level] + GetPer100AP(source,0.01)) * GetMaxHP(target) ; if target.Type == 1 and dmg > 100 then dmg = 100 end ; return dmg end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return (({100, 140, 180})[level] + GetBonusAD(source,0.65) + GetAP(source,0.25)) * (GetPercentHP(target) < 0.4 and 2 or ((1 - GetPercentHP(target)) * 0.83) + 1) end},

  },

  ["Leblanc"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({55, 90, 125, 160, 195})[level] + GetAP(source,0.5) end},
    {Slot = 0, Stage = 3, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({33, 54, 75, 96, 117})[level] + GetAP(source,0.3) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 275, 400})[GetCastLevel(source, _R)] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 55, 70, 85, 100})[level] + GetAP(source,0.2) end},
    {Slot = 1, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 120, 180})[GetCastLevel(source, _R)] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 160, 220})[GetCastLevel(source, _R)] + GetAP(source,0.4) end},
  },

  ["LeeSin"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 85, 115, 145, 175})[level] + GetBonusAD(source,0.9) end},
    {Slot = 0, Stage = 7, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({55, 85, 115, 145, 175})[level] + GetBonusAD(source,0.9) + GetMissingHP(target,0.08) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + GetBonusAD(source) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 300,450})[level] + GetBonusAD(source,2) end},
    {Slot = 3, Stage = 14, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({150, 300,450})[level] + GetBonusAD(source,2) end}, -- need BonusHealth 0.12, 0.15, 0.18
  },

  ["Leona"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 80, 120, 160, 200})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAP(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 175, 250})[level] + GetAP(source,0.8) end},
  },

  ["Lissandra"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] +GetAP (source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
  },

  ["Lucian"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({85, 120, 155, 190, 225})[level] + GetBonusAD(source,({0.6, 0.7, 0.8, 0.9, 1})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAP(source,0.9) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 35, 50})[level] + GetAP(source,0.1) + GetAD(source,0.2) end},
    {Slot = 3, Stage = 9, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 140, 200})[level] + GetAP(source,0.4) + GetAD(source,0.8) end},
  },

  ["Lulu"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 125, 170, 215, 260})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + GetAP(source,0.4) end},
  },

  ["Lux"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 100, 150, 200, 250})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({300, 400, 500})[level] + GetAP(source,0.75) end},
  },

  ["Malphite"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 120, 170, 220, 270})[level] + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({15, 30, 45, 60, 75})[level] + GetAP(source,0.1) + GetArmor(source,0.15)end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + GetAP(source,0.2) + GetArmor(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source) end},
  },

  ["Malzahar"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + GetAP(source,0.8) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({12, 14, 16, 18, 20})[level] + ({5, 8.5, 12, 15.5, 19, 22.5, 26, 29.5, 33, 36.5, 40, 43.5, 47, 50.5, 54, 57.5, 61, 64.5})[GetLevel(source)] + GetAP(source,0.2) + GetBonusAD(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + GetAP(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({125, 200, 275})[level] + GetAP(source,0.8) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({125, 200, 275})[level] + GetMaxHP(target,({0.02, 0.03, 0.04})[level] + GetPer100AP(source,0.05)) end},
  },

  ["Maokai"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({65, 105, 145, 185, 225})[level] + GetAP(source,0.4) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({25, 50, 75, 100, 125})[level] + GetMaxHP(target,({0.06, 0.065, 0.07, 0.075, 0.08})[level] + GetPer100AP(source,0.01)) end},
    {Slot = 2, Stage = 15, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({50, 100, 150, 200, 250})[level] + GetMaxHP(target,({0.12, 0.13, 0.14, 0.15, 0.16})[level] + GetPer100AP(source,0.02)) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + GetAP(source,0.75) end},
  },

  ["MasterYi"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({25, 60, 95, 130, 165})[level] + GetAD(source,1) end},
    {Slot = 0, Stage = 9, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 160, 220, 280, 340})[level] + GetAD(source,1) end},
    {Slot = 2, Stage = 1, DamageType = 3, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({14, 23, 32, 41, 50})[level] + GetBonusAD(source,0.25) end},
  },

  ["MissFortune"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAP(source,0.35) + GetAD(source,1) end},
    {Slot = 0, Stage = 15, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 80, 120, 160, 200})[level] + GetAP(source,0.7) + GetAD(source,2) + GetBonusCriticalDamage(source,0.01) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 57.5, 75, 92.5, 110})[level] + GetAP(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return GetAD(source,0.75) + GetAP(source,0.2) end},
  },

  ["MonkeyKing"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] + GetAD(source,0.1) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({65, 110, 155, 200, 245})[level] + GetBonusAD(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 110, 200})[level] + GetAD(source,1.1) end},
  },

  ["Mordekaiser"] = {
    {Slot = 0, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 20, 30, 40, 50})[level] + GetAD(source,({0.5, 0.6, 0.7, 0.8 ,0.9})[level]) + GetAP(source,0.6) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAD(source,({1, 1.2, 1,4, 1.6, 1.8})[level]) + GetAP(source,1.2) end},
    {Slot = 0, Stage = 6, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({40, 80, 120, 160, 200})[level] + GetAD(source,({2, 2.4, 2.8, 3.2, 3.6})[level]) + GetAP(source,2.4) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({35, 45, 55, 65, 75})[level] + GetAP(source,0.225) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 65, 95, 125, 155})[level] + GetAD(source,0.3) + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return GetMaxHP(target,({0.0625, 0.075, 0.0875})[level] + GetPer100AP(source,0.01)) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return GetMaxHP(target,({0.01875, 0.0225, 0.02625})[level] + GetPer100AP(source,0.003)) end},
  },

  ["Morgana"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 135, 190, 245, 300})[level] + GetAP(source,0.9) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({24, 48, 72, 96, 120})[level] + GetAP(source,0.33) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + GetAP(source,0.7) end},
  },

  ["Nami"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 130, 185, 240, 295})[level] + GetAP(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({25, 40, 55, 70, 85})[level] + GetAP(source,0.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.6) end},
  },

  ["Nasus"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return GetBuffStack(source.Addr, "nasusqstacks") + ({30, 50, 70, 90, 110})[level] end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 95, 135, 175, 215})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 4, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({11, 19, 27, 35, 43})[level] + GetAP(source,0.12) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return GetMaxHP(target,({0.03, 0.04, 0.05})[level]+GetPer100AP(source,0.01)) end},
  },

  ["Nautilus"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.75) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 85, 115, 145, 175})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({200, 325, 450})[level] + GetAP(source,0.8) end},
    {Slot = 3, Stage = 13, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({125, 175, 225})[level] + GetAP(source,0.4) end},
  },

  ["Nidalee"] = { -- need debug
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 85, 100, 115, 130})[level] + GetAP(source,0.4) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) local dmg = (({5, 30, 55, 80})[GetCastLevel(source, _R)] + GetAP(source,0.4) + GetAD(source,0.75)) * (GetMissingHP(target,1) / GetMaxHP(target,1) * 1.5 + 1) dmg = dmg * (GetBuffStack(target.Addr, "nidaleepassivehunted") > 0 and 1.4 or 1) return dmg end},-- IsModifiedDamage = true but what?
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({10, 20, 30, 40, 50})[level] + GetAP(source,0.05) end},
    {Slot = 1, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210})[GetCastLevel(source, _R)] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 130, 190, 250})[GetCastLevel(source, _R)] + GetAP(source,0.45) end},
  },

  ["Nocturne"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({65, 110, 155, 200, 245})[level] + GetBonusAD(source,0.75) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetAP(source,1) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetBonusAD(source,1.2) end},
  },

  ["Nunu"] = {
    {Slot = 0, Stage = 1, DamageType = 3, SpellEffectType = 3, Damage = function(source, target, level) return ({340, 500, 660, 820, 980})[level] end},
    {Slot = 0, Stage = 13, DamageType = 3, SpellEffectType = 3, Damage = function(source, target, level) return ({500, 660, 820, 980, 1140})[level] end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.9) end},
    {Slot = 2, Stage = 13, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({120, 160, 200, 240, 280})[level] + GetAP(source,0.9) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({78.1, 109.4, 140.6})[level] + GetBonusAP(source,({0.3125, 0.3125, 0.3125})[level]) end},
    {Slot = 3, Stage = 13, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({109.4, 140.6, 171.9})[level] + GetBonusAP(source,({0.3125, 0.3125, 0.3125})[level]) end},
  },

  ["Olaf"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetBonusAD(source,1) end},
    {Slot = 2, Stage = 1, DamageType = 3, SpellEffectType = 1, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAD(source,0.4) end},
  },

  ["Orianna"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({24, 36, 48, 60, 72})[level] + GetAP(source,0.2) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 225, 300})[level] + GetAP(source,0.7) end},
  },

  ["Ornn"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 50, 80, 110, 140})[level] + GetAD(source,1) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return GetMaxHP(target,({0.10, 0.12, 0.14, 0.16, 0.18})[level]) end}, -- need min/max dmg check "MinDamage": [80, 130, 180, 230, 280], "MaxDamageOnMonster": [155, 180, 205, 230, 255],
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 5, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + GetBonusArmor(source,0.3) + GetBonusMagicArmor(source,0.3) end},
    {Slot = 2, Stage = 14, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 90, 130, 170, 210})[level] + GetBonusArmor(source,0.3) + GetBonusMagicArmor(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({125, 175, 225})[level] + GetAP(source,0.2) end},
    {Slot = 3, Stage = 7, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({125, 175, 225})[level] + GetAP(source,0.2) end},
  },

  ["Pantheon"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({75, 115, 155, 195, 235})[level] + GetBonusAD(source,1.4) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + GetAP(source,1) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({33.33, 50, 66.66, 83.33, 100})[level] + GetBonusAD(source,1) end},
    {Slot = 2, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({19.998, 30, 39.996, 49.998, 60})[level] + GetBonusAD(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 350, 500})[level] + GetAP(source,0.5) end},
  },

  ["Poppy"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetBonusAD(source,0.8) + GetMaxHP(source,0.08) end},
    {Slot = 0, Stage = 3, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetBonusAD(source,0.8) + GetMaxHP(source,0.08) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({55, 75, 95, 115, 135})[level] + GetBonusAD(source,0.5) end},
    {Slot = 2, Stage = 14, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({55, 75, 95, 115, 135})[level] + GetBonusAD(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({210, 310, 410})[level] + GetBonusAD(source,0.9) end},
  },

  ["Quinn"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + GetAP(source,0.5) + GetAD(source,1.2) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + GetBonusAD(source,0.2) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return GetAD(source,0.4) end},
  },

  ["Rakan"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 200, 300})[level] + GetAP(source,0.5) end},
  },

  ["Rammus"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 135, 170, 205, 240})[level] + GetAP(source,1) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({40, 80, 120})[level] + GetAP(source,0.2) end},
  },

  ["RekSai"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType= 1, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + GetBonusAD(source,0.4) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType= 3, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetBonusAD(source,0.4) + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 70, 85, 100, 115})[level] + GetBonusAD(source,0.8) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({55, 65, 75, 85, 95})[level] + GetBonusAD(source,0.85) end},
    {Slot = 2, Stage = 15, DamageType = 3, SpellEffectType = 1, Damage = function(source, target, level) return ({100, 120, 140, 160, 180})[level] + GetBonusAD(source,1.7) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 250, 400})[level] + GetBonusAD(source,1.85) + GetMissingHP(target,({0.2, 0.25, 0.3})[level]) end},
  },

  ["Renekton"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + GetBonusAD(source,0.8) end},
    {Slot = 0, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({97.5, 142.5, 187.5, 232.5, 277.5})[level] + GetBonusAD(source,1.2) end},
    {Slot = 1, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + GetAD(source,1.5) end},
    {Slot = 1, Stage = 15, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({15, 45, 75, 105, 135})[level] + GetAD(source,2.25) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + GetBonusAD(source,0.9) end},
    {Slot = 2, Stage = 7, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + GetBonusAD(source,0.9) end},
    {Slot = 2, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 100, 145, 190, 235})[level] + GetBonusAD(source,1.35) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 40, 60})[level] + GetAP(source,0.1) end},
  },

  ["Rengar"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 90, 130, 170, 210})[level] + GetBonusAD(source,({0.4, 0.6, 0.8, 1, 1.2})[level]) end},
    {Slot = 0, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({120, 136, 152, 168, 184, 200, 216, 232, 248, 264, 280, 296, 312, 328, 344, 360, 376, 392})[GetLevel(source)] + GetBonusAD(source,2.2) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 80, 110, 140, 170})[level] + GetAP(source,0.8) end},
    {Slot = 1, Stage = 15, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90, 100, 110, 120, 130, 140, 150, 160, 170, 180, 190, 200, 210, 220})[GetLevel(source)] + GetAP(source,0.8) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 95, 140, 185, 230})[level] + GetBonusAD(source,0.7) end},
    {Slot = 2, Stage = 15, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 65, 80, 95, 110, 125, 140, 155, 170, 185, 200, 215, 230, 245, 260, 275, 290, 305})[GetLevel(source)] + GetBonusAD(source,0.7) end},
  },

  ["Riven"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({15, 35, 55, 75, 95})[level] + GetAD(source,0.8) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 85, 115, 145, 175})[level] + GetBonusAD(source,1) end},
    {Slot = 3, Stage = 1, DamageType = 1, Damage = function(source, target, level) return (({100, 150, 200})[level] + GetBonusAD(source,0.6)) * math.max(0.02667 * math.min(100 - GetPercentHP(target), 75), 1) end}, -- need check
  },

  ["Rumble"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 4,  Damage = function(source, target, level) return ({45, 60, 75, 90, 105})[level] + GetAP(source,0.366) end},
    {Slot = 0, Stage = 15, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({67.5, 90, 112.5, 135, 157.5})[level] + GetAP(source,0.55) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 85, 110, 135, 160})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 15, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({90, 127.5, 165, 202.5, 240})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({130, 185, 240})[level] + GetAP(source,0.3) end},
  },

  ["Ryze"] = { -- GetMAxMana ==>> BonusMana need change
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return (({60, 85, 110, 135, 160, 185})[level] + GetAP(source,0.45) + GetMaxMana(source,0.03)) * (1 + (GetBuffStack(target.Addr, "RyzeE") > 0 and ({40, 50, 60, 70, 80, 80})[level] / 100 or 0)) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + GetAP(source,0.6) + GetMaxMana(source,0.01) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + GetAP(source,0.3) + GetMaxMana(source,0.02) end},
  },

  ["Sejuani"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.4) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + GetMaxHP(source,0.015) end},
    {Slot = 1, Stage = 2, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({30, 65, 100, 135, 170})[level] + GetMaxHP(source,0.045) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 125, 150})[level] + GetAP(source,0.4) end},
    {Slot = 3, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.8) end},
  },

 ["Shaco"] = {
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 50, 65, 80, 95})[level] + GetAP(source,0.2) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + GetAP(source,0.75) + GetBonusAD(source,({0.6, 0.75, 0.9, 1.05, 1.2})[level]) + GetMissingHP(target,0.05) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source,1) end},
  },

  ["Shen"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) local dmg = ({5, 5, 5, 10, 10, 10, 15, 15, 15, 20, 20, 20, 25, 25, 25, 30, 30, 30})[GetLevel(source)] + GetMaxHP(target,({0.02, 0.025, 0.03, 0.035, 0.04})[level] + GetPer100AP(source,0.015)); if target.Type == 0 then return dmg end; return math.min(({30, 50, 70, 90, 110})[level]+dmg, ({75, 100, 125, 150, 175})[level]) end},
    {Slot = 0, Stage = 15, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) local dmg = ({15, 15, 15, 20, 20, 20, 25, 25, 25, 30, 30, 30, 35, 35, 35, 40, 40, 40})[GetLevel(source)] + GetMaxHP(target,({0.04, 0.045, 0.05, 0.055, 0.06})[level] + GetPer100AP(source,0.02)); if target.Type == 0 then return dmg end; return math.min(({30, 50, 70, 90, 110})[level]+dmg, ({75, 100, 125, 150, 175})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 75, 100, 125, 150})[level] + GetMaxHP(source,0.12) end}, -- GetMaxHP ==>> BonusHP need change
  },

  ["Shyvana"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetAD(source,({0.4, 0.55, 0.7, 0.85, 1})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({20, 32, 45, 57, 70})[level] + GetBonusAD(source,0.2) + GetAP(source,0.1) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAD(source,0.3) + GetAP(source,0.3)  end},
    {Slot = 2, Stage = 5, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAD(source,0.3) + GetAP(source,0.3)  end},
    {Slot = 2, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({60, 60, 60, 60, 60, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120})[GetLevel(source)] + GetAD(source,0.3) + GetAP(source,0.3)  end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
},

  ["Singed"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 65, 80, 95, 110})[level] + GetAP(source,0.75) + GetMaxHP(target,({0.04, 0.055, 0.07, 0.085, 0.01})[level]) end},
  },

  ["Sion"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({12, 24, 36, 48, 60})[level] + GetAD(source,0.39) end},
    {Slot = 0, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({16, 32, 48, 64, 80})[level] + GetAD(source,0.52) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.4) + GetMaxHP(target,({0.1, 0.11, 0.12, 0.13, 0.14})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 15, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({91, 136.5, 182, 227.5, 273})[level] + GetAP(source,0.52) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 400, 600})[level] + GetBonusAD(source,0.4) end},
    {Slot = 3, Stage = 15, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({400, 800, 1200})[level] + GetBonusAD(source,0.8) end},
  },

  ["Sivir"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 55, 75, 95, 115})[level] + GetAD(source,({0.07, 0.08, 0.09, 0.1, 0.11})[level]) + GetAP(source,0.5) end},
    {Slot = 1, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetAD(source,({0.5, 0.55, 0.6, 0.65, 0.7})[level]) end},
  },

  ["Skarner"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return GetAD(source,({0.33, 0.36, 0.39, 042, 0.45})[level]) end},
    {Slot = 0, Stage = 7, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return GetAD(source,({0.33, 0.36, 0.39, 042, 0.45})[level] * 2) + GetAP(source,0.3) end}, --fking mix dmg
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.2) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.2) + ({25, 35, 45, 55, 65})[level] end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 120, 200})[level] + GetAP(source,1) + GetAD(source,1.2) end},
  },

  ["Sona"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 70, 100, 130, 160})[level] + GetAP(source,0.5) end},
    {Slot = 0, Stage = 16, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 15, 20 ,25, 30})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.5) end},
  },

  ["Soraka"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.35) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.4) end},
  },

  ["Swain"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({30, 48, 65, 83, 100})[level] + GetAP(source,0.3) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({60, 96, 132, 168, 204})[level] + GetAP(source,1.2) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({50, 70, 90})[level] + GetAP(source,0.2) end},
  },

  ["Syndra"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 95, 140, 185, 230})[level] + GetAP(source,0.65) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.7) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({270, 405, 540})[level] + GetAP(source,0.6) end},
--  {Slot = 3, Stage = 0, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({90, 135, 180})[level] + GetAP(source,0.2) end},
  },

  ["TahmKench"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 130, 180, 230, 280})[level] + GetAP(source,0.7) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return target.Type == 1 and ({400, 450, 500, 550, 600})[level] or GetMaxHP(target,({0.20, 0.23, 0.26, 0.29, 0.32})[level] + GetPer100AP(source,0.02)) end},
    {Slot = 1, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + GetAP(source,0.6) end},
  },

  ["Taliyah"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + GetAP(source,0.45) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 90, 110, 130, 150})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({35, 45, 55, 65, 75})[level] + GetAP(source,0.2) end},
  },

  ["Talon"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({65, 90, 115, 140, 165})[level] + GetBonusAD(source,1.1) end},
    {Slot = 0, Stage = 5, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({90, 127.5, 165, 202.5, 240})[level] + GetBonusAD(source,1.65) end}, -- criti 0.005
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + GetBonusAD(source,0.4) end},
    {Slot = 1, Stage = 2, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + GetBonusAD(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({90, 120, 160})[level] + GetBonusAD(source,0.8) end},
    {Slot = 3, Stage = 2, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({90, 120, 160})[level] + GetBonusAD(source,0.8) end},
  },

  ["Taric"] = {
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({105, 150, 195, 240, 285})[level] + GetAP(source,0.5) + GetBonusArmor(source,0.3) end},
  },

  ["Teemo"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 125, 170, 215, 260})[level] + GetAP(source,0.8) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({34, 68, 102, 136, 170})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 325, 450})[level] + GetAP(source,0.7) end},
  },

  ["Thresh"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({65, 95, 125, 155, 185})[level] + GetAP(source,0.4) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({250, 400, 550})[level] + GetAP(source,1) end},
  },

  ["Tristana"] = {
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 70, 80, 90, 100})[level] + GetBonusAD(source,({0.5, 0.6, 0.7, 0.8, 0.9})[level]) + GetAP(source,0.5) end},
  --{Slot = 2, Stage = 12, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({18, 21, 24, 27, 30})[level] + GetBonusAD(source,({0.15, 0.195, 0.24, 0.285, 0.33})[level]) + GetAP(source,0.15) end}, need SBuffname "tristanaecharge"
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({300, 400, 500})[level] + GetAP(source,1) end},
  },

  ["Trundle"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAD(source,({0, 0.05, 0.1, 0.15, 0.2})[level]) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return GetMaxHP(target,({0.1, 0.1375, 0.175})[level] + GetPer100AP(source,0.01)) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return GetMaxHP(target,({0.025, 0.034, 0.044})[level] + GetPer100AP(source,0.0025)) end},
  },

  ["Tryndamere"] = {
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + GetAP(source,1) + GetBonusAD(source,1.2) end},
  },

  ["TwistedFate"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.65) end},
    {Slot = 1, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetAP(source,0.5) + GetAD(source,1) end}, -- BLUE
    {Slot = 1, Stage = 5, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + GetAP(source,0.5) + GetAD(source,1) end}, -- RED
    {Slot = 1, Stage = 6, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return ({15, 22.5, 30, 37.5, 45})[level] + GetAP(source,0.5) + GetAD(source,1) end}, -- GOLD
    {Slot = 2, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + GetAP(source,0.5) end},
  },

  ["Twitch"] = {
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return (GetBuffStack(target.Addr, "twitchdeadlyvenom") * ({15, 20, 25, 30, 35})[level] + GetAP(source,0.2) + GetBonusAD(source,0.25) + ({20, 35, 50, 65, 80})[level]) end},
    --{Slot = 2, Stage = 2, DamageType = 1, Damage = function(source, target, level) return ({15, 20, 25, 30, 35})[level] + GetAP(source,0.2) + GetBonusAD(source,0.25) + ({20, 35, 50, 65, 80})[level] end},
  },

  ["Udyr"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] + GetAD(source,({1.2, 1.35, 1.5, 1.65, 1.8})[level]) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 80, 120, 160, 200})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({10, 20, 30, 40, 50})[level] + GetAP(source,0.25) end},
  },

  ["Urgot"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({10, 40, 70, 100, 130})[level] + GetAD(source,0.85) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 4, Damage = function(source, target, level) return ({15, 26, 37, 48, 59})[level] + GetBonusAD(source,0.12) end},
  },

  ["Varus"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({3.3, 15.6, 27.8, 40, 52.2})[level] + GetAD(source,0.33) end},
    {Slot = 0, Stage = 12, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(target,({0.02, 0.0275, 0.035, 0.0425, 0.05})[level] + GetPer100AP(source,0.02)) * (GetBuffStack(target.Addr, "VarusWDebuff")) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 14, 18, 22, 26})[level] + GetAP(source,0.25) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + GetBonusAD(source,0.6) end},
    {Slot = 2, Stage = 12, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(target,({0.02, 0.0275, 0.035, 0.0425, 0.05})[level] + GetPer100AP(source,0.02)) * (GetBuffStack(target.Addr, "VarusWDebuff")) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType =2, Damage = function(source, target, level) return ({100, 175, 250})[level] + GetAP(source,1) end},
    {Slot = 3, Stage = 12, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(target,({0.02, 0.0275, 0.035, 0.0425, 0.05})[level] + GetPer100AP(source,0.02)) * (GetBuffStack(target.Addr, "VarusWDebuff")) end},
  },

  ["Vayne"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetAD(source,({0.5, 0.55, 0.6, 0.65, 0.75})[level]) end},
    {Slot = 1, Stage = 1, DamageType = 3, SpellEffectType = 1, Damage = function(source, target, level) return math.max(({50, 65, 80, 95, 110})[level],GetMaxHP(target,({0.04, 0.06, 0.08, 0.1, 0.12})[level])) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 85, 120, 155, 190})[level] + GetBonusAD(source,0.5) end},
    {Slot = 2, Stage = 14, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({45, 80, 115, 150, 185})[level] + GetBonusAD(source,0.5) end},
  },

  ["Veigar"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 150, 200, 250, 300})[level] + GetAp(source,1) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({175, 250, 325})[level] + GetAP(source,0.75) + GetMissingHP(target,0.015) end},
  },

  ["Velkoz"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({30, 50, 70, 90, 110})[level] + GetAP(source,0.15) end},
    {Slot = 1, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({45, 75, 105, 135, 165})[level] + GetAP(source,0.25) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 100, 130, 160, 190})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 1, DamageType = 3, SpellEffectType = 2, Damage = function(source, target, level) return (GetBuffStack(target.Addr, "velkozresearchedstack") > 0 and ({450, 625, 800})[level] + GetAP(source,1.25) or CalcMagicalDamage(source, target, ({450, 625, 800})[level] + GetAP(source,1.25))) end},
  },

  ["Vi"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({55, 80, 105, 130, 155})[level] + GetBonusAD(source,0.8) end},
    {Slot = 0, Stage = 9, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 1200})[level] + GetBonusAD(source,0.6) end},
    {Slot = 1, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return GetMaxHP(source,({0.04, 0.055, 0.07, 0.085, 0.1})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + GetAD(source,1.15) + GetAP(source,0.7) end},
    {Slot = 2, Stage = 13, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 30, 50, 70, 90})[level] + GetAD(source,1.15) + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({150, 300, 450})[level] + GetAP(source,1.4) end},
    {Slot = 3, Stage = 13, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return ({117.5, 243.75, 337.5})[level] + GetAP(source,1.05) end},
  },

  ["Viktor"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 80, 100, 120, 140})[level] + GetAP(source,0.4) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 110, 150, 190, 230})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 60, 100, 140, 180})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 175, 250})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 4, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.6) end},
  },

  ["Vladimir"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({80, 100, 120, 140, 160})[level] + GetAP(source,0.6) end},
    {Slot = 0, Stage = 15, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({148, 185, 220, 259, 296})[level] + GetAP(source,1.1) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 4, Damage = function(source, target, level) return ({40, 67.5, 95, 122.5, 150})[level] end}, -- need GetBonusHealth(source,0.025)
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({30, 45, 60, 75, 90})[level] + GetMaxHP(source,0.025) + GetAP(source,0.35) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
  },

  ["Volibear"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 60, 90, 120, 150})[level] end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return (({60, 110, 160, 210, 260})[level]) end}, -- need GetBonusHealth(source,0.15)
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 105, 150, 195, 240})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 115, 155})[level] + GetAP(source,0.3) end},
    {Slot = 3, Stage = 16, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({75, 115, 155})[level] + GetAP(source,0.3) end},
  },

  ["Warwick"] = {
    {Slot = 0, Stage = 1, DamageType = 2, IsApplyOnHit = true, SpellEffectType = 3, Damage = function(source, target, level) return GetAD(source,1.2) + GetAP(source,0.9) + GetMaxHP(target,({0.06, 0.07, 0.08, 0.09, 0.1})[level]) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({175, 325, 525})[level] + GetBonusAD(source,1.67) end},
  },

  ["Xayah"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 60, 80, 100, 120})[level] + GetBonusAD(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({50, 60, 70, 80, 90})[level] + GetBonusAD(source,0.6) + GetBonusCriticalDamage(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({100, 150, 200})[level] + GetBonusAD(source,1) end},
  },

  ["Xerath"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 120, 160, 200, 240})[level] + GetAP(source,0.75) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 90, 120, 150, 180})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({80, 110, 140, 170, 200})[level] + GetAP(source,0.45) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 230, 260})[level] + GetAP(source,0.43) end},
  },

 ["XinZhao"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({20, 25, 30, 35, 40})[level] + GetBonusAD(source,0.2) end},
    {Slot = 1, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + GetAD(source,0.3) end},
    {Slot = 1, Stage = 5, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 65, 100, 135, 170})[level] + GetAD(source,0.75) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({50, 75, 100, 1250, 150})[level] + GetAP(source,0.6) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 175, 275})[level] + GetAD(source,1) + GetCurrentHP(target,0.15) end},
  },

  ["Yasuo"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 45, 70, 95, 120})[level] + GetAD(source,1) end},
    {Slot = 0, Stage = 5, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAD(source,1) end},
    {Slot = 0, Stage = 6, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 2, Damage = function(source, target, level) return ({20, 40, 60, 80, 100})[level] + GetAD(source,1) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({60, 70, 80, 90, 100})[level] + GetAP(source,0.6) + GetBonusAD(source,0.2) end},
    {Slot = 2, Stage = 12, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({15, 17.5, 20, 22.5, 25})[level] end}, -- need check buff name Source."YasuoDashScalar"
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 1, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetBonusAD(source,1.5) end},
  },

  ["Yorick"] = {
    {Slot = 0, Stage = 1, DamageType = 1, IsApplyOnHit = true, SpellEffectType = 1, Damage = function(source, target, level) return ({30, 55, 80, 105, 130})[level] + GetAD(source,0.4) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return math.min(({70, 105, 140, 175, 210})[level], GetAP(source,0.7)) + GetCurrentHP(target,0.15) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 1, Damage = function(source, target, level) return ({10, 20, 40})[level] + GetAD(source,0.5) end},
  },

  ["Zac"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + GetAP(source,0.3) + GetMaxHP(source,0.025) end},
    {Slot = 0, Stage = 5, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({30, 40, 50, 60, 70})[level] + GetAP(source,0.3) + GetMaxHP(source,0.025) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({15, 30, 45, 60, 75})[level] + GetMaxHP(target,({0.04, 0.05, 0.06, 0.07, 0.08})[level] + GetPer100AP(source,0.02)) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 110, 160, 210, 260})[level] + GetAP(source,0.7) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({150, 250, 350})[level] + GetAP(source,0.7) end},
  },

  ["Zed"] = {
    {Slot = 0, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({80, 115, 150, 185, 220})[level] + GetBonusAD(source,0.9) end},
    {Slot = 2, Stage = 1, DamageType = 1, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 95, 120, 145, 170})[level] + GetBonusAD(source,0.8) end},
    {Slot = 3, Stage = 1, DamageType = 1, SpellEffectType = 3, Damage = function(source, target, level) return GetAD(source,1) end},
  },

  ["Ziggs"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 120, 165, 210, 255})[level] + GetAP(source,0.65) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({70, 105, 140, 175, 210})[level] + GetAP(source,0.65) end},
    {Slot = 1, Stage = 11, DamageType = 3, SpellEffectType = 2, Damage = function(source, target, level) return GetMaxHP(target,({0.25, 0.275, 0.3, 0.325, 0.35})[level]) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({40, 65, 90, 115, 140})[level] + GetAP(source,0.3) end},
    {Slot = 2, Stage = 3, DamageType = 2, SpellEffectType = 3, Damage = function(source, target, level) return ({16, 26, 36, 46, 56})[level] + GetAP(source,0.12) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({200, 300, 400})[level] + GetAP(source,0.733) end},
    {Slot = 3, Stage = 15, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({300, 450, 600})[level] + GetAP(source,1.1) end},
  },

  ["Zilean"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({75, 115, 165, 230, 300})[level] + GetAP(source,0.9) end},
  },

  ["Zoe"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({58, 95, 132, 169, 206})[level] + GetAP(source,0.675) end},
    {Slot = 1, Stage = 1, DamageType = 2, SpellEffectType = 5, Damage = function(source, target, level) return ({70, 115, 160, 205, 250})[level] + GetAP(source,0.5) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAP(source,0.4) end},
    {Slot = 2, Stage = 14, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 100, 140, 180, 220})[level] + GetAP(source,0.4) end},
  },

  ["Zyra"] = {
    {Slot = 0, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + GetAP(source,0.6) end},
    {Slot = 2, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({60, 95, 130, 165, 200})[level] + GetAP(source,0.5) end},
    {Slot = 3, Stage = 1, DamageType = 2, SpellEffectType = 2, Damage = function(source, target, level) return ({180, 265, 350})[level] + GetAP(source,0.7) end},
},
}

function GetSpellDamage(spellSlot, target, spellStage)
    local source = myHero
    local name = source.CharName
    local stage = spellStage or 1
    local spellTable = {}
    if stage > 4 then stage = 4 end

    if (spellSlot == 0 or spellSlot == 1 or spellSlot == 2 or spellSlot == 3) and target then
        local level = GetCastLevel(source, spellSlot)
        if level <= 0 then return 0 end

        if DamageLibTable[name] then
            for i=1, #DamageLibTable[name] do
                local spell = DamageLibTable[name][i]
                if spell.Slot == spellSlot then
                    table.insert(spellTable, spell)
                end
            end
            if stage > #spellTable then stage = #spellTable end

            for v = #spellTable, 1, -1 do
                local spells = spellTable[v]
                if spells.Stage == stage then
                    if spells.DamageType == 1 then
                        return source.CalcDamage(target.Addr, spells.Damage(source, target, level))
                    elseif spells.DamageType == 2 then
                        return source.CalcMagicDamage(target.Addr, spells.Damage(source, target, level))
                    elseif spells.DamageType == 3 then
                        return spells.Damage(source, target, level)
                    end
                end
            end
        end
    end
    return 0
end

-----------------------------------------------------------------------------
-- SDK: Prediction
-----------------------------------------------------------------------------

class "Prediction"

function Prediction:__init()
        self.ImmobileHandler 	= {}
        self.SlowHandler     	= {}
        self.DashHandler     	= {}
        self.AutoAttackHandler  = {}
        self.SpellHandler 	= {}
        self.DontShoot          = {}

        self.buffer = 0.02

        self.DashSpells = {
        	{name = "ahritumble", duration = 0.25},			--ahri's r
                {name = "akalishadowdance", duration = 0.25},		--akali r
                {name = "headbutt", duration = 0.25},			--alistar w
                {name = "caitlynentrapment", duration = 0.25},		--caitlyn e
                {name = "carpetbomb", duration = 0.25},			--corki w
                {name = "dianateleport", duration = 0.25},		--diana r
                {name = "fizzpiercingstrike", duration = 0.25},		--fizz q
                {name = "fizzjump", duration = 0.25},			--fizz e
                {name = "gragasbodyslam", duration = 0.25},		--gragas e
                {name = "gravesmove", duration = 0.25},			--graves e
                {name = "ireliagatotsu", duration = 0.25},		--irelia q
                {name = "jarvanivdragonstrike", duration = 0.25},	--jarvan q
                {name = "jaxleapstrike", duration = 0.25},		--jax q
                {name = "khazixe", duration = 0.25},			--khazix e and e evolved
                {name = "leblancslide", duration = 0.25},		--leblanc w
                {name = "leblancslidem", duration = 0.25},		--leblanc w (r)
                {name = "blindmonkqtwo", duration = 0.25},		--lee sin q
                {name = "blindmonkwone", duration = 0.25},		--lee sin w
                {name = "luciane", duration = 0.25},			--lucian e
                {name = "maokaiunstablegrowth", duration = 0.25},	--maokai w
                {name = "nocturneparanoia2", duration = 0.25},		--nocturne r
                {name = "pantheon_leapbash", duration = 0.25},	        --pantheon e?
                {name = "renektonsliceanddice", duration = 0.25},	--renekton e
                {name = "riventricleave", duration = 0.25},		--riven q
                {name = "rivenfeint", duration = 0.25},			--riven e
                {name = "sejuaniarcticassault", duration = 0.25},	--sejuani q
                {name = "shene", duration = 0.25},			--shen e
                {name = "shyvanatransformcast", duration = 0.25},	--shyvana r
                {name = "rocketjump", duration = 0.25},			--tristana w
                {name = "slashcast", duration = 0.25},			--tryndamere e
                {name = "vaynetumble", duration = 0.25},		--vayne q
                {name = "viq", duration = 0.25},			--vi q
                {name = "monkeykingnimbus", duration = 0.25},		--wukong q
                {name = "xenzhaosweep", duration = 0.25},		--xin xhao q
                {name = "yasuodashwrapper", duration = 0.25},		--yasuo e
        }

        self.BlinkSpells = {
        	{name = "ezrealarcaneshift", range = 475, delay = 0.25, delay2=0.8},		--Ezreals E
                {name = "deceive", range = 400, delay = 0.25, delay2=0.8}, 			--Shacos Q
                {name = "riftwalk", range = 700, delay = 0.25, delay2=0.8},			--KassadinR
                {name = "gate", range = 5500, delay = 1.5, delay2=1.5},				--Twisted fate R
                {name = "katarinae", range = math.huge, delay = 0.25, delay2=0.8},		--Katarinas E
                {name = "elisespideredescent", range = math.huge, delay = 0.25, delay2=0.8},	--Elise E
                {name = "elisespidere", range = math.huge, delay = 0.25, delay2=0.8},		--Elise insta E
        }

        AddEvent(Enum.Event.OnNewPath, function(...) self:OnNewPath(...) end)
        AddEvent(Enum.Event.OnProcessSpell, function(...) self:OnProcessSpell(...) end)
        AddEvent(Enum.Event.OnUpdateBuff, function(...) self:OnUpdateBuff(...) end)
end

function Prediction:OnNewPath(unit, startPos, endPos, isDash, dashSpeed ,dashGravity, dashDistance)
        if isDash then
                local dash = {}

                if unit.Type == myHero.Type then
                        local latency 	= GetLatency()
                        local distance 	= GetDistance(startPos, endPos)

                        dash.startPos 	= startPos
                        dash.endPos 	= endPos
                        dash.speed 	= dashSpeed
                        dash.startT 	= os_clock() - latency / 2000
                        dash.endT 	= dash.startT + (distance / dashSpeed)

                        self.DashHandler[unit.NetworkId] = dash
                end
        end
end

function Prediction:OnProcessSpell(unit, spell)
        if unit and unit.Type == myHero.Type then
                self.SpellHandler[unit.NetworkId] = os_clock() + 0.25

                if string_match(spell.Name:lower(), "attack") then
                        self.AutoAttackHandler[unit.NetworkId] = os_clock() + spell.Delay
                end

                for i = 1, #self.BlinkSpells do
                        local blinkSpell = self.BlinkSpells[i]

                        if blinkSpell then
                                local startPos = Vector(spell.SourcePos_x, spell.SourcePos_y, spell.SourcePos_z)
                                local endPos = Vector(spell.DestPos_x, spell.DestPos_y, spell.DestPos_z)
                                local landingPos = GetDistanceSqr(unit, endPos) < blinkSpell.range * blinkSpell.range and endPos or Vector(unit) + blinkSpell.range * (endPos - Vector(unit)):Normalized()

                                if blinkSpell.name == spell.Name:lower() and not IsWall(endPos.x, endPos.y, endPos.z) then
                                        self.DashHandler[unit.NetworkId] = {
                                                isBlink   = true,
                                                duration  = blinkSpell.delay,
                                                endT      = os_clock() + blinkSpell.delay,
                                                endT2     = os_clock() + blinkSpell.delay2,
                                                startPos  = Vector(unit),
                                                endPos    = landingPos
                                        }
                                end
                        end
                end

                for i = 1, #self.DashSpells do
                        local dashSpell = self.DashSpells[i]

                        if dashSpell and dashSpell.name == spell.Name:lower() then
                                self.DontShoot[unit.NetworkId] = os_clock() + dashSpell.duration
                        end
                end
        end
end

function Prediction:OnUpdateBuff(source, unit, buff)
        if not unit or not buff or unit.Type ~= myHero.Type then return end

        if buff.Type == 5 or buff.Type == 11 or buff.Type == 29 or buff.Type == 24 then
                self.ImmobileHandler[unit.NetworkId] = os_clock() + (buff.EndT - buff.BeginT)
                return
        end

        if buff.Type == 10 or buff.Type == 22 or buff.Type == 21 or buff.Type == 8 then
                self.SlowHandler[unit.NetworkId] = os_clock() + (buff.EndT - buff.BeginT)
                return
        end
end

function Prediction:IsSlowed(unit, delay, speed, from)
        if self.SlowHandler[unit.NetworkId] then
                local distance = GetDistance(unit, from)

                if self.SlowHandler[unit.NetworkId] > (os_clock() + delay + distance / speed) then
                        return true
                end
        end

        return false
end

function Prediction:IsImmobile(unit, delay, width, speed, from, spelltype)
        local radius = width / 2

        if self.ImmobileHandler[unit.NetworkId] then
                local ExtraDelay = speed == math_huge and  0 or (GetDistance(from, unit) / speed)

                if (self.ImmobileHandler[unit.NetworkId] > (os_clock() + delay + ExtraDelay) and spelltype == 0) then
                        return true, Vector(unit), Vector(unit) + (radius / 3) * (Vector(from) - Vector(unit)):Normalized()
                elseif (self.ImmobileHandler[unit.NetworkId] + (radius / unit.MoveSpeed)) > (os_clock() + delay + ExtraDelay) then
                        return true, Vector(unit), Vector(unit)
                end
        end

        return false, Vector(unit), Vector(unit)
end

function Prediction:IsDashing(unit, delay, width, speed, from)
        local radius = width / 2

        local TargetDashing 	= false
        local CanHit 		= false
        local Position 		= Vector(unit)

        if self.DashHandler[unit.NetworkId] then
                local dash = self.DashHandler[unit.NetworkId]

                if dash.endT >= os_clock() then
                        TargetDashing = true

                        if dash.isBlink then
                                if (dash.endT - os_clock()) <= (delay + GetDistance(from, dash.endPos) / speed) then
                                        Position = Vector(dash.endPos.x, 0, dash.endPos.z)
                                        CanHit   = (unit.MoveSpeed * (delay + GetDistance(from, dash.endPos) / speed - (dash.endT2 - os_clock()))) < radius
                                end

                                if ((dash.endT - os_clock()) >= (delay + GetDistance(from, dash.startPos) / speed)) and not CanHit then
                                        Position = Vector(dash.startPos.x, 0, dash.startPos.z)
                                        CanHit = true
                                end
                        else
                                local t1, p1, t2, p2, dist = VectorMovementCollision(dash.startPos, dash.endPos, dash.speed, from, speed, (os_clock() - dash.startT) + delay)

                                t1, t2 = (t1 and 0 <= t1 and t1 <= (dash.endT - os_clock() - delay)) and t1 or nil, (t2 and 0 <= t2 and t2 <=  (dash.endT - os_clock() - delay)) and t2 or nil

                                local t = t1 and t2 and math_min(t1, t2) or t1 or t2

                                if t then
                                        Position = t == t1 and Vector(p1.x, 0, p1.y) or Vector(p2.x, 0, p2.y)
                                        CanHit = true
                                else
                                        Position = Vector(dash.endPos.x, 0, dash.endPos.z)
                                        CanHit = (unit.MoveSpeed * (delay + GetDistance(from, Position) / speed - (dash.endT - os_clock()))) < radius
                                end
                        end
                end
        end

        return TargetDashing, CanHit, Position
end

function Prediction:SRT(unit, unitPredPos, from, type, delay, range, speed, width, radius, angle)
        local result = math_huge

        local hasMovePath = HasMovePath(unit)
        local pathCount = GetPathCount(unit)
        local ping = GetPing()
        local unitMS = unit.MoveSpeed
        local boundingRadius = GetBoundingRadius(unit.Addr)
        local distance = GetDistance(unitPredPos, from)

        if type == Enum.SkillShotType.Line then
                if speed == math_huge then
                        result = delay - (math_min(width / 2, range - distance, distance) + boundingRadius) / unitMS + ping + self.buffer
                else
                        if hasMovePath and pathCount >= 2 then
                                if speed >= unitMS then
                                        result = delay + math_max(0, distance - boundingRadius) / (speed - unitMS)
                                        - (math_min(width / 2, range - distance, distance) + boundingRadius) / unitMS
                                        + ping + self.buffer
                                else
                                        result = math_huge
                                end
                        else
                                result = delay + math_max(0, distance - boundingRadius) / speed
                                - (math_min(width / 2, range - distance, distance) + boundingRadius) / unitMS
                                + ping + self.buffer
                        end
                end
        elseif type == Enum.SkillShotType.Circle then
                if speed == math_huge then
                        result = delay - radius / unitMS + ping + self.buffer

                        if range == 0 then
                                result = result + distance / unitMS
                        end
                else
                        result = delay + distance / speed - radius / unitMS + ping + self.buffer
                end
        end

        return result
end

function Prediction:GetPredict(spell, unit, from)
        local type = spell.SkillShotType
        local delay = spell.Delay
        local range = spell.Range
        local speed = spell.Speed
        local width = spell.Width
        local collision = spell.Collision
        local addmyboundingRadius = spell.addmyboundingRadius
        local addunitboundingRadius = spell.addunitboundingRadius
        local radius = spell.Radius
        local angle = spell.Angle
        local IsLowAccuracy = spell.IsLowAccuracy
        local IsVeryLowAccuracy = spell.IsVeryLowAccuracy

        local RT = 0.4

        if IsVeryLowAccuracy then
                RT = 0.6
        elseif IsLowAccuracy then
                RT = 0.5
        end

        local RT_S = RT + 0.3

        local TotalDST = 0

        local unitPredPos = nil
        local unitPredPos_S = nil
        local unitPredPos_E = nil
        local unitPredPos_D = nil
        local unitPredPos_C = nil
        local CastPos = nil
        local HitChance = 0

        local hasMovePath = HasMovePath(unit)
        local pathCount = GetPathCount(unit)
        local pathIndex = GetPathIndex(unit)
        local unitMS = unit.MoveSpeed
        local ping = GetPing()

        if hasMovePath and pathCount >= 2 then
                local unitIndexPos = GetPath(unit, pathIndex)

                if unitIndexPos == nil then
                        unitIndexPos = GetPath(unit, pathIndex - 1)
                end

                TotalDST = GetDistance(unitIndexPos, unit)

                local DST, DST_S, DST_D = GetDistance(unitIndexPos, unit), GetDistance(unitIndexPos, unit), GetDistance(unitIndexPos, unit)
                local ExDST, ExDST_S, ExDST_D = nil, nil, nil
                local LastIndex, LastIndex_S, LastIndex_D = nil, nil, nil

                for i = pathIndex, pathCount do
                        local Path = GetPath(unit, i)
                        local Path2 = GetPath(unit, i + 1)

                        if pathCount == i then
                                Path2 = GetPath(unit, i)
                        end

                        if LastIndex == nil and DST > RT * unitMS then
                                LastIndex = i
                                ExDST = DST - RT * unitMS
                        end

                        if LastIndex_S == nil and DST_S > RT_S * unitMS then
                                LastIndex_S = i
                                ExDST_S = DST_S - RT_S * unitMS
                        end

                        if range == 0 and delay < RT and LastIndex_D == nil and DST_D > delay * unitMS then
                                LastIndex_D = i
                                ExDST_D = DST_D - delay * unitMS
                        end

                        DST = DST + GetDistance(Path2, Path)
                        DST_S = DST_S + GetDistance(Path2, Path)
                        DST_D = DST_D + GetDistance(Path2, Path)
                        TotalDST = TotalDST + GetDistance(Path2, Path)
                end

                if LastIndex_S ~= nil then
                        LastIndexPos = GetPath(unit, LastIndex)
                        LastIndexPos2 = GetPath(unit, LastIndex - 1)
                        unitPredPos = LastIndexPos + (LastIndexPos2 - LastIndexPos):Normalized() * ExDST
                        LastIndexPos_S = GetPath(unit, LastIndex_S)
                        LastIndexPos_S2 = GetPath(unit, LastIndex_S - 1)
                        unitPredPos_S = LastIndexPos_S + (LastIndexPos_S2 - LastIndexPos_S):Normalized() * ExDST_S
                elseif LastIndex ~= nil then
                        LastIndexPos = GetPath(unit, LastIndex)
                        LastIndexPos2 = GetPath(unit, LastIndex - 1)
                        unitPredPos = LastIndexPos + (LastIndexPos2 - LastIndexPos):Normalized() * ExDST
                else
                        unitPredPos_E = GetPath(unit, pathCount)
                end

                if LastIndex_D ~= nil then
                        LastIndexPos_D = GetPath(unit, LastIndex_D)
                        LastIndexPos_D2 = GetPath(unit, LastIndex_D - 1)
                        unitPredPos_D = LastIndexPos_D + (LastIndexPos_D2 - LastIndexPos_D):Normalized() * ExDST_D
                end

        else
                unitPredPos = Vector(unit.x, unit.y, unit.z)
                unitPredPos_S = Vector(unit.x, unit.y, unit.z)

                if range == 0 and delay < RT then
                        unitPredPos_D = Vector(unit.x, unit.y, unit.z)
                end

        end

        if unitPredPos_S ~= nil then
                CastPos = unitPredPos_S

                local SRT_S = self:SRT(unit, unitPredPos_S, from, type, delay, range, speed, width, radius, angle)

                if SRT_S <= RT_S then
                        SRT_S = math_max(ping + self.buffer, SRT_S)

                        if hasMovePath and pathCount >= 2 then
                                HitChance = (RT_S - SRT_S) / RT_S + 1
                        else
                                HitChance = (RT_S - SRT_S) / RT_S + 0.5
                        end

                end
        end

        if unitPredPos ~= nil then
                if unitPredPos_S == nil then
                        CastPos = unitPredPos
                end

                local SRT = self:SRT(unit, unitPredPos, from, type, delay, range, speed, width, radius, angle)

                if SRT <= RT then
                        SRT = math_max(ping + self.buffer, SRT)

                        if hasMovePath and pathCount >= 2 then
                                CastPos = unitPredPos
                                HitChance = (RT - SRT) / RT + 2
                        else
                                CastPos = unitPredPos
                                HitChance = (RT - SRT) / RT + 1.5
                        end

                end
        end

        if unitPredPos_E ~= nil then
                CastPos = unitPredPos_E

                local SRT_E = self:SRT(unit, unitPredPos_E, from, type, delay, range, speed, width, radius, angle)

                if SRT_E <= TotalDST / unitMS then
                        SRT_E = math_max(ping + self.buffer, SRT_E)
                        HitChance = (TotalDST / unitMS - SRT_E) / (TotalDST / unitMS) + 2
                end

        end

        if unitPredPos_D ~= nil and (unitPredPos_E == nil or delay <= TotalDST / unitMS) then
                CastPos = unitPredPos_D
                HitChance = 0

                local SRT_D = self:SRT(unit, unitPredPos_D, from, type, delay, range, speed, width, radius, angle)

                if SRT_D <= delay then
                        SRT_D = math_max(ping + self.buffer, SRT_D)

                        if hasMovePath and pathCount >= 2 then
                                HitChance = (delay - SRT_D) / delay + 2
                        else
                                HitChance = (delay - SRT_D) / delay + 1.5
                        end
                end
        end

        if unitPredPos_C ~= nil then
                CastPos = unitPredPos_C

                local SRT_C = self:SRT(unit, unitPredPos_C, from, type, delay, range, speed, width, radius, angle)
                local Time_C = GetDistance(unitPredPos_C, unit) / unitMS

                if SRT_C <= Time_C then
                        SRT_C = math_max(ping + self.buffer, SRT_C)

                        HitChance = (Time_C - SRT_C) / Time_C + 1
                end
        end

        return CastPos, HitChance
end

function Prediction:GetBestCastPosition(spell, unit, from)
        local type = spell.SkillShotType
        local delay = spell.Delay
        local range = spell.Range
        local speed = spell.Speed
        local width = spell.Width
        local collision = spell.Collision
        local addmyboundingRadius = spell.addmyboundingRadius
        local addunitboundingRadius = spell.addunitboundingRadius
        local radius = spell.Radius
        local angle = spell.Angle
        local IsLowAccuracy = spell.IsLowAccuracy
        local IsVeryLowAccuracy = spell.IsVeryLowAccuracy

        local CastPosition, HitChance = Vector(unit), 0
        local TargetDashing, CanHitDashing, DashPosition = self:IsDashing(unit, delay, width, speed, from)
        local TargetImmobile, ImmobilePos, ImmobileCastPosition = self:IsImmobile(unit, delay, width, speed, from, type)

        if self.DontShoot[unit.NetworkId] and self.DontShoot[unit.NetworkId] > os_clock() then
                HitChance = -1

                CastPosition = Vector(unit)
        elseif TargetDashing then
                if CanHitDashing then
                        HitChance = 3
                else
                        HitChance = 0
                end

                CastPosition = DashPosition
        elseif TargetImmobile then
                CastPosition = ImmobileCastPosition
                HitChance = 3
        else
                CastPosition, HitChance = self:GetPredict(spell, unit, from)
        end

        if self.SpellHandler[unit.NetworkId] and self.SpellHandler[unit.NetworkId] > os_clock() then
                HitChance = 2
        end

        if self.AutoAttackHandler[unit.NetworkId] and self.AutoAttackHandler[unit.NetworkId] > os_clock() then
                HitChance = 2
        end

        if self:IsSlowed(unit, delay, speed, from) then
                HitChance = 2
        end

        if GetDistanceSqr(from, CastPosition) >= range * range then
                HitChance = -1
        end

        if CastPosition and collision and CountObjectCollision(0, unit.Addr, myHero.x, myHero.z, CastPosition.x, CastPosition.z, width, range, 10) > 0 then
                HitChance = -1
        end

        return CastPosition, HitChance
end

Prediction = Prediction()

-----------------------------------------------------------------------------
-- SDK: Hero Manager
-----------------------------------------------------------------------------

class "HeroManager"

function HeroManager:__init()
        self.Enemy = {}
        self.Ally = {}
        self.All = {}

        AddEvent(Enum.Event.OnLoad, function() self:OnLoad() end)
end

function HeroManager:OnLoad()
        SearchAllChamp()

        local heroes = pObjChamp
        for i, hero in pairs(heroes) do
                if hero ~= 0 then
                        self.All[#self.All + 1] = hero

                        if GetTeamId(hero) == myHero.TeamId then
                                self.Ally[#self.Ally + 1] = hero
                        elseif GetTeamId(hero) ~= myHero.TeamId then
                                self.Enemy[#self.Enemy + 1] = hero
                        end
                end
        end
end

HeroManager = HeroManager()

-----------------------------------------------------------------------------
-- SDK: Minion Manager
-----------------------------------------------------------------------------

class "MinionManager"

function MinionManager:__init()
        self.All = {}
        self.Ally = {}
        self.Enemy = {}
        self.Jungle = {}

        AddEvent(Enum.Event.OnLoad, function() self:OnLoad() end)
        AddEvent(Enum.Event.OnCreateObject, function(...) self:OnCreateObject(...) end)
        AddEvent(Enum.Event.OnDeleteObject, function(...) self:OnDeleteObject(...) end)
end

function MinionManager:OnLoad()
        GetAllUnitAroundAnObject(myHero.Addr, 20000)

        local list = pUnit
        for i = 1, #list do
                local v = list[i]
                if v ~= 0 then
                        local object = GetUnit(v)

                        if object and not object.IsDead and not object.Name:lower():find("plant") then
                                if IsMinion(object.Addr) then
                                        self.All[#self.All + 1] = object.Addr

                                        if object.TeamId ~= myHero.TeamId then
                                                self.Enemy[#self.Enemy + 1] = object.Addr
                                        elseif object.TeamId == myHero.TeamId then
                                                self.Ally[#self.Ally + 1] = object.Addr
                                        end
                                end

                                if IsJungleMonster(object.Addr) then
                                        self.All[#self.All + 1] = object.Addr
                                        self.Jungle[#self.Jungle + 1] = object.Addr
                                end
                        end
                end
        end
end

function MinionManager:OnCreateObject(object)
        if object and not object.IsDead then
                if object.Name:lower():find("attack") or
                object.Name:lower():find("camprespawn") or
                object.Name:lower():find("plant") then return end

                if IsMinion(object.Addr) then
                        self.All[#self.All + 1] = object.Addr

                        if object.TeamId ~= myHero.TeamId then
                                self.Enemy[#self.Enemy + 1] = object.Addr
                        elseif object.TeamId == myHero.TeamId then
                                self.Ally[#self.Ally + 1] = object.Addr
                        end
                end

                if IsJungleMonster(object.Addr) then
                        self.All[#self.All + 1] = object.Addr
                        self.Jungle[#self.Jungle + 1] = object.Addr
                end
        end
end

function MinionManager:OnDeleteObject(object)
        if object then
                if IsMinion(object.Addr) then
                        for i, k in pairs(self.All) do
                                if k == object.Addr then
                                        table_remove(self.All, i)
                                end
                        end

                        if object.TeamId ~= myHero.TeamId then
                                for i, k in pairs(self.Enemy) do
                                        if k == object.Addr then
                                                table_remove(self.Enemy, i)
                                        end
                                end
                        elseif object.TeamId == myHero.TeamId then
                                for i, k in pairs(self.Ally) do
                                        if k == object.Addr then
                                                table_remove(self.Ally, i)
                                        end
                                end
                        end
                end

                if IsJungleMonster(object.Addr) then
                        for i, k in pairs(self.All) do
                                if k == object.Addr then
                                        table_remove(self.All, i)
                                end
                        end

                        for i, k in pairs(self.Jungle) do
                                if k == object.Addr then
                                        table_remove(self.Jungle, i)
                                end
                        end
                end
        end
end

MinionManager = MinionManager()

-----------------------------------------------------------------------------
-- SDK: Orbwalker
-----------------------------------------------------------------------------

class "Orbwalker"

function Orbwalker:__init()
	SetLuaBasicAttackOnly(true)
	SetLuaMoveOnly(true)

        self.AttackingEnabled = true
	self.LastTarget = nil
	self.MovingEnabled = true
	self.LastAttackCommandSentTime = 0
	self.ServerAttackDetectionTick = 0
	self.ForcedTarget = nil

	Orb = {}
	Orb.Keys = {}
	Orb.Keys.Combo = ReadIniInteger("OrbCore", "Combo Key", string.byte(" "))
	Orb.Keys.Harass = ReadIniInteger("OrbCore", "Harass Key", string.byte("C"))
	Orb.Keys.LaneClear = ReadIniInteger("OrbCore", "LaneClear Key", string.byte("V"))
	Orb.Keys.LastHit = ReadIniInteger("OrbCore", "LastHit Key", string.byte("X"))

	AddEvent(Enum.Event.OnTick, function()
		Orb.Keys.Combo = ReadIniInteger("OrbCore", "Combo Key", string.byte(" "))
		Orb.Keys.Harass = ReadIniInteger("OrbCore", "Harass Key", string.byte("C"))
		Orb.Keys.LaneClear = ReadIniInteger("OrbCore", "LaneClear Key", string.byte("V"))
		Orb.Keys.LastHit = ReadIniInteger("OrbCore", "LastHit Key", string.byte("X"))
	end)

	--self.ExtraWindUp = function() return Orb.Menu.Misc.ExtraWindUp end
	--self.HoldPositionRadius = function() return Orb.Menu.Misc.HoldRadius end
	--self.DrawHoldPosition = function() return true end 			--bool
	--self.ExtraDelay = function() return Orb.Menu.Misc.ExtraDelay end
	--self.AnimationTime = function() return myHero.Windup end
	--self.WindUpTime = function() return self.AnimationTime() + self.ExtraWindUp() end

	self.OrbwalkingMode = {
		["None"]      = "None",
		["Combo"]     = "Combo",
		["Mixed"]     = "Mixed",
		["Laneclear"] = "Laneclear",
		["Lasthit"]   = "Lasthit",
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

	self.PreAttackCallbacks = {}
	self.PreMoveCallbacks = {}
	self.PostAttackCallbacks = {}
	--self.NonKillableMinionCallbacks = {}

	AddEvent(Enum.Event.OnTick, function(...) self:OnTick(...) end)
	AddEvent(Enum.Event.OnAttack, function(...) self:OnProcessAutoAttack(...) end)
	AddEvent(Enum.Event.OnProcessSpell, function(...) self:OnProcessSpell(...) end)
end

function Orbwalker:AllowAttack(bool)
	self.AttackingEnabled = bool
end

function Orbwalker:AllowMovement(bool)
	self.MovingEnabled = bool
end

function Orbwalker:RegisterPreAttackCallback(f)
        table_insert(self.PreAttackCallbacks, f)
end

--function Orbwalker:RegisterNonKillableMinionCallback(f)
--    insert(self.NonKillableMinionCallbacks, f)
--end

function Orbwalker:RegisterPostAttackCallback(f)
        table_insert(self.PostAttackCallbacks, f)
end

function Orbwalker:ForceTarget(unit)
	self.ForcedTarget = unit
end

function Orbwalker:GetActiveMode()
	if GetKeyPress(Orb.Keys.Combo) ~= 0 then
		return self.OrbwalkingMode.Combo
	elseif GetKeyPress(Orb.Keys.Harass) ~= 0 then
		return self.OrbwalkingMode.Mixed
	elseif GetKeyPress(Orb.Keys.LaneClear) ~= 0 then
		return self.OrbwalkingMode.Laneclear
	elseif GetKeyPress(Orb.Keys.LastHit) ~= 0 then
		return self.OrbwalkingMode.Lasthit
	end
end

function Orbwalker:FindTarget()
    if self.ForcedTarget ~= nil and self:IsValidAutoRange(self.ForcedTarget) then
        return self.ForcedTarget
    end
    return GetUnit(GetTargetOrb())
end

function Orbwalker:GetOrbwalkingTarget()
	return self.LastTarget
end

function Orbwalker:IsValidAutoRange(target)
	return GetDistance(target) < GetTrueAttackRange()
end

function Orbwalker:GetCursorPos()
	return { x = GetMousePosX(), y = GetMousePosY(), z = GetMousePosZ() }
end

function Orbwalker:CanAttack()
	return self.AttackingEnabled and CanAttack()
end

function Orbwalker:CanMove()
	return self.MovingEnabled and CanMove()
end

function Orbwalker:Move(movePosition)
	local args = {Process = true, Target = movePosition}
	for k, cb in pairs(self.PreMoveCallbacks) do
		cb(args)
	end
	if args.Process then
		MoveToPos(args.Target.x, args.Target.z) --core
	end
end

function Orbwalker:Attack(target)
    local args = { ["Process"] = true, ["Target"] = target }
    for i, cb in ipairs(self.PreAttackCallbacks) do
        cb(args)
    end
    if args.Process then
        local targetToAttack = args.Target
        if self.ForcedTarget ~= nil and self:IsValidAutoRange(self.ForcedTarget) then
            targetToAttack = self.ForcedTarget
        end
        BasicAttack(targetToAttack.Addr) --core
        self.LastAttackCommandSentTime = GetTimeGame()
    end
end

function Orbwalker:Orbwalk()
    if GetTimeGame() - self.LastAttackCommandSentTime < 0.070 + math_min(60/1000, GetLatency()/1000) or myHero.IsRecall or IsTyping() then return end
    local mode = self:GetActiveMode()
    if mode == nil then
        return
    end
    if self.ForcedTarget ~= nil and not self:IsValidAutoRange(self.ForcedTarget) then
        self.ForcedTarget = nil
    end

    if self:CanMove() then
        self:Move(self:GetCursorPos())
    end

    if self:CanAttack() then
        self.LastTarget = self:FindTarget()
        if self.LastTarget and self.LastTarget ~= 0 then
            self:Attack(self.LastTarget)
        end
    end
end

function Orbwalker:ResetAutoAttackTimer()
	self.ServerAttackDetectionTick = 0
	self.LastAttackCommandSentTime = 0
end

function Orbwalker:OnTick()
	if myHero.IsDead or IsTyping() then return end
	self:Orbwalk()
end

function Orbwalker:OnProcessSpell(unit, spell)
	if unit.IsMe then
		local name = spell.Name:lower()
		if table.contains(self.specialAttacks, name) then
			self:OnProcessAutoAttack(sender, spell)
		end
		if table.contains(self.attackResets, name) then
			self:ResetAutoAttackTimer()
		end
	end
end

function Orbwalker:OnProcessAutoAttack(sender, target)
    if sender and sender.IsMe and target then
        local spell = GetSpellCasting(myHero.Addr)
        local name = spell and GetName_Casting(spell)
        self.ServerAttackDetectionTick = GetTimeGame() - GetLatency() / 2000
        self.LastTarget = target
        self.ForcedTarget = nil
        local args = {Target = self.LastTarget}
        DelayAction(function()
            for i, cb in ipairs(self.PostAttackCallbacks) do
                                cb(args)
            end
        end, 0.3)

        if table.contains(self.attackResets, name) then
            self:ResetAutoAttackTimer()
        end
    end
end

function Orbwalker:GetPrediction(target, time, delay) --Not Used atm
	return GetHealthPred(target, time, delay)
end

function Orbwalker:GetLaneClearHealthPrediction(target, time, delay) --Not Used atm
	LaneClearHealthPred(target, time, delay)
end

Orbwalker = Orbwalker()

-----------------------------------------------------------------------------
-- SDK: Spell
-----------------------------------------------------------------------------

class "Spell"

function Spell:__init(spellTable)
        self.SpellData = spellTable
        self.Slot = spellTable.Slot
        self.SpellType = spellTable.SpellType
        self.SkillShotType = spellTable.SkillShotType
        self.Delay = spellTable.Delay
        self.Range = spellTable.Range
        self.Speed = spellTable.Speed
        self.Width = spellTable.Width
        self.Radius = spellTable.Radius
        self.Collision = spellTable.Collision
        self.Angle = spellTable.Angle

        return self
end

function Spell:IsReady()
        return CanCast(self.Slot)
end

function Spell:CanCast(target, range, source)
        local range = range or self.Range
        local source = source or myHero

        if self.Collision then
                local collision = CountObjectCollision(0, target.Addr, source.x, source.z, target.x, target.z, self.Width, self.Range, 10)

                if collision < 1 then
                        return IsValidTarget(target, range)
                end

                return false
        end

        return IsValidTarget(target, range)
end

function Spell:GetDamage(target, stage)
        return GetSpellDamage(self.Slot, target, stage)
end

function Spell:GetPrediction(target, from)
        local from = from or myHero

        return Prediction:GetBestCastPosition(self.SpellData, target, from)
end

function Spell:Cast(target)
        if not self:IsReady() then return end

        if Enum.SpellType.SkillShot then
                CastSpellToPos(target.x, target.z, self.Slot)
        elseif Enum.SpellType.Targetted then
                CastSpellTarget(target.Addr, self.Slot)
        elseif Enum.SpellType.Active then
                CastSpellTarget(myHero.Addr, self.Slot)
        end
end
