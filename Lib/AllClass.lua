--[[
https://raw.githubusercontent.com/nebelwolfi/BoL/master/BoL-api/AllClass.lua
]]

_G.evade = false

player = GetMyHero()
myHero = player

SPELL_1, SPELL_2, SPELL_3, SPELL_4 = _Q + 1, _W + 1, _E + 1, _R + 1

function Class() -- for Vector class
  local cls = {}

        cls.__index = cls
        return setmetatable(cls, { __call = function (c, ...)
                local instance = setmetatable({}, cls)

                if cls.__init then
                        cls.__init(instance, ...)
                end

                return instance
        end })
end

function _has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

_objManager = Class()

function _objManager:__init()
	self.objects = {}
	self.maxObjects = 0

	player = GetMyHero()
	myHero = player

	GetAllObjectAroundAnObject(myHero.Addr, 3000)

	-- 0=champ, 1=minion, 2=turret, 3=jungle, 4= Inhibitor, 5=Nexus, 6=Missile, -1= other
	for i, obj in pairs(pObject) do
		if obj ~= 0 then
			local object = nil
			if GetType(obj) == 0 then
				object = GetAIHero(obj)
			elseif _has_value({1,2,3}, GetType(obj)) then
				object = GetUnit(obj)
			elseif GetType(obj) == 6 then
				object = GetMissile(obj)
			elseif _has_value({4,5}, GetType(obj)) then
				object = GetBarrack(obj)
			elseif GetType(obj) == -1 then
				object = {}
				object.Addr = obj
				object.Type = -1
				object.Id = GetId(obj)
				--object.Name = GetObjName(obj)
				--object.CharName = GetChampName(obj)
			end

			if object then
				table.insert(self.objects, object)
				self.maxObjects = self.maxObjects + 1
			end
		end
	end

	setmetatable(self.objects,{
					__newindex = function(self, key, value)
						error("Adding to EnemyHeroes is not granted. Use table.copy.")
					end,
				})

	return self
end

function _objManager:getObject(i)
	return self.objects[i]
end

function _objManager:GetObjectByNetworkId(NetworkID)
	for i=1, self.maxObjects do
		if self.objects[i].NetworkId == NetworkID then
			return self.objects[i]
		end
	end
end

function _objManager:AddObject(object)
	if object and object.Addr ~= 0 then
		table.insert(self.objects, object)
		self.maxObjects = self.maxObjects + 1

		setmetatable(self.objects,{
			__newindex = function(self, key, value)
				error("Adding to EnemyHeroes is not granted. Use table.copy.")
			end,
		})
	end
end

function _objManager:update()
	self.objects = {}
	self.maxObjects = 0

	player = GetMyHero()
	myHero = player

	GetAllObjectAroundAnObject(myHero.Addr, 3000)

	-- 0=champ, 1=minion, 2=turret, 3=jungle, 4= Inhibitor, 5=Nexus, 6=Missile, -1= other
	for i, obj in pairs(pObject) do
		if obj ~= 0 then
			local object = nil
			if GetType(obj) == 0 then
				object = GetAIHero(obj)
			elseif _has_value({1,2,3}, GetType(obj)) then
				object = GetUnit(obj)
			elseif GetType(obj) == 6 then
				object = GetMissile(obj)
			elseif _has_value({4,5}, GetType(obj)) then
				object = GetBarrack(obj)
			elseif GetType(obj) == -1 then
				object = {}
				object.Addr = obj
				object.Type = -1
				object.Id = GetId(obj)
				--object.Name = GetObjName(obj)
				--object.CharName = GetChampName(obj)
			end

			if object then
				table.insert(self.objects, object)
				self.maxObjects = self.maxObjects + 1
			end
		end
	end

	setmetatable(self.objects,{
					__newindex = function(self, key, value)
						error("Adding to EnemyHeroes is not granted. Use table.copy.")
					end,
				})
end

function _objManager:RemoveObject(object)
	if object and object.Addr ~= 0 then
		for i=1, self.maxObjects do
			if self.objects[i] and self.objects[i].Addr == object.Addr then
				table.remove(self.objects, i)
				self.maxObjects = self.maxObjects - 1		
				break		
			end
		end
		setmetatable(self.objects,{
          __newindex = function(self, key, value)
            error("Adding to EnemyHeroes is not granted. Use table.copy.")
          end,
        })
	end
end

_heroManager = Class()

function _heroManager:__init()
    self.heroes = {}
    self.iCount = 0
    SearchAllChamp()
    for i,h in ipairs(pObjChamp) do
        if h ~= 0 then
          local hero = GetAIHero(h)
          table.insert(self.heroes, hero)
          self.iCount = self.iCount + 1
        end
    end

	return self
end

function _heroManager:update()
    self.heroes = {}
    self.iCount = 0
    SearchAllChamp()
    for i,h in ipairs(pObjChamp) do
        if h ~= 0 then
          local hero = GetAIHero(h)
          table.insert(self.heroes, hero)
          self.iCount = self.iCount + 1
        end
    end
end

function _heroManager:GetHero(i)
  return self.heroes[i]
end

objManager = _objManager()
heroManager = _heroManager()

local Callbacks = {
        ["Load"]         = {},
        ["Tick"]         = {},
        ["TickWayPoints"]= {},
        ["Update"]       = {},
        ["Draw"]         = {},
        ["UpdateBuff"]   = {},
        ["RemoveBuff"]   = {},
        ["ProcessSpell"] = {},
        ["CreateObject"] = {},
        ["DeleteObject"] = {},
		    ["WndMsg"]       = {},
		    ["Animation"]    = {},
		    ["DoCast"]       = {},
}

AddTickCallback = function(cb) table.insert(Callbacks["Tick"], cb) end
AddCreateObjCallback = function(cb) table.insert(Callbacks["CreateObject"], cb) end
AddDeleteObjCallback = function(cb) table.insert(Callbacks["DeleteObject"], cb) end
AddProcessSpellCallback = function(cb) table.insert(Callbacks["ProcessSpell"], cb) end
AddTickWayPointsCallback = function(cb) table.insert(Callbacks["TickWayPoints"], cb) end
AddAnimationCallback = function(cb) table.insert(Callbacks["Animation"], cb) end
AddUpdateBuffCallback = function(cb) table.insert(Callbacks["UpdateBuff"], cb) end
AddRemoveBuffCallback = function(cb) table.insert(Callbacks["RemoveBuff"], cb) end
AddDoCastCallback = function(cb) table.insert(Callbacks["DoCast"], cb) end

function OnLoad()
	for i, cb in pairs(Callbacks["Load"]) do
		cb()
    end
end

function OnTick()
	player = GetMyHero()
	myHero = player
	
	_G.evade = GetEvade()

	objManager:update()
	heroManager:update()

	for i, cb in pairs(Callbacks["Tick"]) do
		cb()
	end
  for i, cb in pairs(Callbacks["TickWayPoints"]) do
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        cb(hero)
    end
  end

end

function OnUpdate()
	for i, cb in pairs(Callbacks["Update"]) do
		cb()
    end
end

function OnDraw()
	for i, cb in pairs(Callbacks["Draw"]) do
		cb()
    end
end

function OnUpdateBuff(unit, buff, stacks)
	for i, cb in pairs(Callbacks["UpdateBuff"]) do
		cb(unit, buff, stacks)
    end
end

function OnRemoveBuff(unit, buff)
	for i, cb in pairs(Callbacks["RemoveBuff"]) do
		cb(unit, buff)
    end
end

function OnProcessSpell(unit, spell)
	for i, cb in pairs(Callbacks["ProcessSpell"]) do
		cb(unit, spell)
    end
end

function OnCreateObject(object)
	for i, cb in pairs(Callbacks["CreateObject"]) do
		cb(object)
    end
end

function OnDeleteObject(object)
	--objManager:RemoveObject(object)
	for i, cb in pairs(Callbacks["DeleteObject"]) do
		cb(object)
    end
end

function OnWndMsg(msg, key)
	for i, cb in pairs(Callbacks["WndMsg"]) do
		cb(msg, key)
    end
end

function OnPlayAnimation(unit, action)
  for i, cb in pairs(Callbacks["Animation"]) do
    cb(unit,action)
  end
end

function OnDoCast(unit, spell)
  for i, cb in pairs(Callbacks["DoCast"]) do
    cb(unit,spell)
  end
end

--Faster for comparison of distances, returns the distance^2
function GetDistanceSqr(p1, p2)
    p2 = p2 or player
    return (p1.x - p2.x) ^ 2 + ((p1.z or p1.y) - (p2.z or p2.y)) ^ 2
end

function GetDistance(p1, p2)  
    return math.sqrt(GetDistanceSqr(p1, p2))
end

--p1 should be the BBoxed object
function GetDistanceBBox(p1, p2)
    if p2 == nil then p2 = player end
    p1.minBBox = {x = p1.minBBox_x,y = p1.minBBox_y,z = p1.minBBox_z}
    p2.minBBox = {x = p2.minBBox_x,y = p2.minBBox_y,z = p2.minBBox_z}
    assert(p1 and p1.minBBox and p2 and p2.minBBox, "GetDistanceBBox: wrong argument types (<object><object> expected for p1, p2)")
    local bbox1 = GetDistance(p1, p1.minBBox)
    return GetDistance(p1, p2) - (bbox1)
end

function ctype(t)
    local _type = type(t)
    if _type == "userdata" then
        local metatable = getmetatable(t)
        if not metatable or not metatable.__index then
            t, _type = "userdata", "string"
        end
    end
    if _type == "userdata" or _type == "table" then
        local _getType = t.type or t.Type or t.__type
        _type = type(_getType)=="function" and _getType(t) or type(_getType)=="string" and _getType or _type
    end
    return _type
end

function ctostring(t)
    local _type = type(t)
    if _type == "userdata" then
        local metatable = getmetatable(t)
        if not metatable or not metatable.__index then
            t, _type = "userdata", "string"
        end
    end
    if _type == "userdata" or _type == "table" then
        local _tostring = t.tostring or t.toString or t.__tostring
        if type(_tostring)=="function" then
            local tstring = _tostring(t)
            t = _tostring(t)
        else
            local _ctype = ctype(t) or "Unknown"
            if _type == "table" then
                t = tostring(t):gsub(_type,_ctype) or tostring(t)
            else
                t = _ctype
            end
        end
    end
    return tostring(t)
end

function print(...)
    local t, len = {}, select("#",...)
    for i=1, len do
        local v = select(i,...)
        local _type = type(v)
        if _type == "string" then t[i] = v
        elseif _type == "number" then t[i] = tostring(v)
        elseif _type == "table" then t[i] = table.serialize(v)
        elseif _type == "boolean" then t[i] = v and "true" or "false"
        elseif _type == "userdata" then t[i] = ctostring(v)
        else t[i] = _type
        end
    end
    if len>0 then __PrintTextGame(tostring(table.concat(t))) end
end

function ValidTarget(object, distance, enemyTeam)
  if object == nil then return false end
    local enemyTeam = (enemyTeam ~= false)

	if object ~= nil and _has_value({1,2,3}, object.Type) then
		object = GetUnit(object.Addr)
	elseif object ~= nil and _has_value({0}, object.Type) then
		object = GetAIHero(object.Addr)
	elseif object ~= nil then
		object.IsInvulnerable = false -- not sure
	end

	-- 0=champ, 1=minion, 2=turret, 3=jungle, 4= Inhibitor, 5=Nexus, 6=Missile, -1= other
	if object ~= nil and object.Type == 3 then enemyTeam = true end --for jungle
	--[[if object then
		print("3 " .. tostring(object.Type))
		print("IsValid " .. tostring(object.IsValid))
		print("IsVisible " .. tostring(object.IsVisible))
		print("IsDead " .. tostring(object.IsDead))
		print("CanSelect " .. tostring(object.CanSelect))
		print("enemyTeam " .. tostring(enemyTeam))
		print("IsEnemy " .. tostring(object.IsEnemy))
	end]]

    return object ~= nil and object.IsValid and (object.TeamId ~= player.TeamId) == enemyTeam and object.IsVisible and not object.IsDead and object.CanSelect and (enemyTeam == false or object.IsInvulnerable == false) and (distance == nil or GetDistanceSqr(object) <= distance * distance)
end

function ValidBBoxTarget(object, distance, enemyTeam)
    local enemyTeam = (enemyTeam ~= false)
    
    if object ~= nil and _has_value({1,2,3}, object.Type) then
      object = GetUnit(object.Addr)
    elseif object ~= nil and _has_value({0}, object.Type) then
      object = GetAIHero(object.Addr)
    elseif object ~= nil then
      object.IsInvulnerable = false -- not sure
    end

  -- 0=champ, 1=minion, 2=turret, 3=jungle, 4= Inhibitor, 5=Nexus, 6=Missile, -1= other
  if object ~= nil and object.Type == 3 then enemyTeam = true end --for jungle
  
    return object ~= nil and object.IsValid and (object.TeamId ~= player.TeamId) == enemyTeam and object.IsVisible and not object.IsDead and object.CanSelect and (enemyTeam == false or object.IsInvulnerable == false) and (distance == nil or GetDistanceBBox(object) <= distance)
end

function ValidTargetNear(object, distance, target)
    return object ~= nil and object.IsValid and object.TeamId == target.TeamId and object.NetworkId ~= target.NetworkId and object.IsVisible and not object.IsDead and object.CanSelect and GetDistanceSqr(target, object) <= distance * distance
end

function GetDistanceFromMouse(object)
	local mousePos = Vector(GetMousePos())
    if object ~= nil and VectorType(object) then return GetDistance(object, mousePos) end
    return math.huge
end

local _enemyHeroes
function GetEnemyHeroes()
    if _enemyHeroes then return _enemyHeroes end
    _enemyHeroes = {}
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if hero.IsEnemy and hero.TeamId ~= myHero.TeamId then
            table.insert(_enemyHeroes, hero)
        end
    end
    return setmetatable(_enemyHeroes,{
        __newindex = function(self, key, value)
            error("Adding to EnemyHeroes is not granted. Use table.copy.")
        end,
    })
end

local _allyHeroes
function GetAllyHeroes()
    if _allyHeroes then return _allyHeroes end
    _allyHeroes = {}
    for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if not hero.IsEnemy and hero.TeamId == myHero.TeamId and hero.NetworkId ~= player.NetworkId then
            table.insert(_allyHeroes, hero)
        end
    end
    return setmetatable(_allyHeroes,{
        __newindex = function(self, key, value)
            error("Adding to AllyHeroes is not granted. Use table.copy.")
        end,
    })
end

function GetDrawClock(time, offset)
    time, offset = time or 1, offset or 0
    return (os.clock() + offset) % time / time
end

function table.clear(t)
    for i, v in pairs(t) do
        t[i] = nil
    end
end

function table.copy(from, deepCopy)
    if type(from) == "table" then
        local to = {}
        for k, v in pairs(from) do
            if deepCopy and type(v) == "table" then to[k] = table.copy(v)
            else to[k] = v
            end
        end
        return to
    end
end

function table.contains(t, what, member) --member is optional
    assert(type(t) == "table", "table.contains: wrong argument types (<table> expected for t)")
    for i, v in pairs(t) do
        if member and v[member] == what or v == what then return i, v end
    end
end

function table.serialize(t, tab, functions)
    assert(type(t) == "table", "table.serialize: Wrong Argument, table expected")
    local s, len = {"{\n"}, 1
    for i, v in pairs(t) do
        local iType, vType = type(i), type(v)
        if vType~="userdata" and (functions or vType~="function") then
            if tab then
                s[len+1] = tab
                len = len + 1
            end
            s[len+1] = "\t"
            if iType == "number" then
                s[len+2], s[len+3], s[len+4] = "[", i, "]"
            elseif iType == "string" then
                s[len+2], s[len+3], s[len+4] = '["', i, '"]'
            end
            s[len+5] = " = "
            if vType == "number" then
                s[len+6], s[len+7], len = v, ",\n", len + 7
            elseif vType == "string" then
                s[len+6], s[len+7], s[len+8], len = '"', v:unescape(), '",\n', len + 8
            elseif vType == "table" then
                s[len+6], s[len+7], len = table.serialize(v, (tab or "") .. "\t", functions), ",\n", len + 7
            elseif vType == "boolean" then
                s[len+6], s[len+7], len = tostring(v), ",\n", len + 7
            elseif vType == "function" and functions then
                local dump = string.dump(v)
                s[len+6], s[len+7], s[len+8], len = "load(Base64Decode(\"", Base64Encode(dump, #dump), "\")),\n", len + 8
            end
        end
    end
    if tab then
        s[len+1] = tab
        len = len + 1
    end
    s[len+1] = "}"
    return table.concat(s)
end

function table.merge(base, t, deepMerge)
    for i, v in pairs(t) do
        if deepMerge and type(v) == "table" and type(base[i]) == "table" then
            base[i] = table.merge(base[i], v)
        else base[i] = v
        end
    end
    return base
end

--from http://lua-users.org/wiki/SplitJoin
function string.split(str, delim, maxNb)
    -- Eliminate bad cases...
    if not delim or delim == "" or string.find(str, delim) == nil then
        return { str }
    end
    maxNb = (maxNb and maxNb >= 1) and maxNb or 0
    local result = {}
    local pat = "(.-)" .. delim .. "()"
    local nb = 0
    local lastPos
    for part, pos in string.gmatch(str, pat) do
        nb = nb + 1
        if nb == maxNb then
            result[nb] = lastPos and string.sub(str, lastPos, #str) or str
            break
        end
        result[nb] = part
        lastPos = pos
    end
    -- Handle the last field
    if nb ~= maxNb then
        result[nb + 1] = string.sub(str, lastPos)
    end
    return result
end

function string.join(arg, del)
    return table.concat(arg, del)
end

function string.trim(s)
    return s:match'^%s*(.*%S)' or ''
end

function string.unescape(s)
    return s:gsub(".",{
        ["\a"] = [[\a]],
        ["\b"] = [[\b]],
        ["\f"] = [[\f]],
        ["\n"] = [[\n]],
        ["\r"] = [[\r]],
        ["\t"] = [[\t]],
        ["\v"] = [[\v]],
        ["\\"] = [[\\]],
        ['"'] = [[\"]],
        ["'"] = [[\']],
        ["["] = "\\[",
        ["]"] = "\\]",
      })
end

function math.isNaN(num)
    return num ~= num
end

-- Round half away from zero
function math.round(num, idp)
    assert(type(num) == "number", "math.round: wrong argument types (<number> expected for num)")
    assert(type(idp) == "number" or idp == nil, "math.round: wrong argument types (<integer> expected for idp)")
    local mult = 10 ^ (idp or 0)
    if num >= 0 then return math.floor(num * mult + 0.5) / mult
    else return math.ceil(num * mult - 0.5) / mult
    end
end

function math.close(a, b, eps)
    assert(type(a) == "number" and type(b) == "number", "math.close: wrong argument types (at least 2 <number> expected)")
    eps = eps or 1e-9
    return math.abs(a - b) <= eps
end

function math.limit(val, min, max)
    assert(type(val) == "number" and type(min) == "number" and type(max) == "number", "math.limit: wrong argument types (3 <number> expected)")
    return math.min(max, math.max(min, val))
end

local delayedActions, delayedActionsExecuter = {}, nil
function DelayAction(func, delay, args) --delay in seconds
    if not delayedActionsExecuter then
        function delayedActionsExecuter()
            for t, funcs in pairs(delayedActions) do
                if t <= os.clock() then
                    --for _, f in ipairs(funcs) do f.func(table.unpack(f.args or {})) end --lua 5.2
					          for _, f in ipairs(funcs) do f.func(unpack(f.args or {})) end --lua 5.1
                    delayedActions[t] = nil
                end
            end
        end

        AddTickCallback(delayedActionsExecuter)
    end
    local t = os.clock() + (delay or 0)
    if delayedActions[t] then table.insert(delayedActions[t], { func = func, args = args })
    else delayedActions[t] = { { func = func, args = args } }
    end
end

local _intervalFunction
function SetInterval(userFunction, timeout, count, params)
    if not _intervalFunction then
        function _intervalFunction(userFunction, startTime, timeout, count, params)
            if userFunction(table.unpack(params or {})) ~= false and (not count or count > 1) then
                DelayAction(_intervalFunction, (timeout - (os.clock() - startTime - timeout)), { userFunction, startTime + timeout, timeout, count and (count - 1), params })
            end
        end
    end
    DelayAction(_intervalFunction, timeout, { userFunction, os.clock(), timeout or 0, count, params })
end

function GetHeroLeveled()
    return myHero.LevelSpell(_Q) + myHero.LevelSpell(_W) + myHero.LevelSpell(_E) + myHero.LevelSpell(_R)
end
--[[
-- return the target particle
function GetParticleObject(particle, target, range)
    assert(type(particle) == "string", "GetParticleObject: wrong argument types (<string> expected for particle)")
    local target = target or player
    local range = range or 50
    for i = 1, objManager.maxObjects do
        local object = objManager:GetObject(i)
        if object ~= nil and object.valid and object.name == particle and GetDistanceSqr(target, object) < range * range then return object end
    end
    return nil
end

-- return if target have particle
function TargetHaveParticle(particle, target, range)
    assert(type(particle) == "string", "TargetHaveParticule: wrong argument types (<string> expected for particle)")
    return (GetParticleObject(particle, target, range) ~= nil)
end
]]
function BuffIsValid(buff)
    return buff and buff.Name and buff.BeginT <= GetTimeGame() and buff.EndT >= GetTimeGame()
end

-- return if target have buff
function TargetHaveBuff(buffName, target)
    return target.HasBuff(buffName)
end

-- return number of enemy in range
function CountEnemyHeroInRange(range, object)
    object = object or myHero
    range = range and range * range or myHero.AARange * myHero.AARange
    local enemyInRange = 0
   	for i = 1, heroManager.iCount do
        local hero = heroManager:GetHero(i)
        if ValidTarget(hero) and GetDistanceSqr(object, hero) <= range then
            enemyInRange = enemyInRange + 1
        end
    end
    return enemyInRange
end

-- STAND ALONE FUNCTIONS
function VectorType(v)
    return v and v.x and type(v.x) == "number" and ((v.y and type(v.y) == "number") or (v.z and type(v.z) == "number"))
end

local function IsClockWise(A,B,C)
    return VectorDirection(A,B,C)<=0
end

local function IsCounterClockWise(A,B,C)
    return not IsClockWise(A,B,C)
end

function IsLineSegmentIntersection(A,B,C,D)
    return IsClockWise(A, C, D) ~= IsClockWise(B, C, D) and IsClockWise(A, B, C) ~= IsClockWise(A, B, D)
end

function VectorIntersection(a1, b1, a2, b2) --returns a 2D point where to lines intersect (assuming they have an infinite length)
    assert(VectorType(a1) and VectorType(b1) and VectorType(a2) and VectorType(b2), "VectorIntersection: wrong argument types (4 <Vector> expected)")
    --http://thirdpartyninjas.com/blog/2008/10/07/line-segment-intersection/
    local x1, y1, x2, y2, x3, y3, x4, y4 = a1.x, a1.z or a1.y, b1.x, b1.z or b1.y, a2.x, a2.z or a2.y, b2.x, b2.z or b2.y
    local r, s, u, v, k, l = x1 * y2 - y1 * x2, x3 * y4 - y3 * x4, x3 - x4, x1 - x2, y3 - y4, y1 - y2
    local px, py, divisor = r * u - v * s, r * k - l * s, v * k - l * u
    return divisor ~= 0 and Vector(px / divisor, py / divisor)
end

function LineSegmentIntersection(A,B,C,D)
    return IsLineSegmentIntersection(A,B,C,D) and VectorIntersection(A,B,C,D)
end

function VectorDirection(v1, v2, v)
    --assert(VectorType(v1) and VectorType(v2) and VectorType(v), "VectorDirection: wrong argument types (3 <Vector> expected)")
    return ((v.z or v.y) - (v1.z or v1.y)) * (v2.x - v1.x) - ((v2.z or v2.y) - (v1.z or v1.y)) * (v.x - v1.x)
end

function VectorPointProjectionOnLine(v1, v2, v)
    assert(VectorType(v1) and VectorType(v2) and VectorType(v), "VectorPointProjectionOnLine: wrong argument types (3 <Vector> expected)")
    local line = Vector(v2) - v1
    local t = ((-(v1.x * line.x - line.x * v.x + (v1.z - v.z) * line.z)) / line:len2())
    return (line * t) + v1
end

--[[
    VectorPointProjectionOnLineSegment: Extended VectorPointProjectionOnLine in 2D Space
    v1 and v2 are the start and end point of the linesegment
    v is the point next to the line
    return:
        pointSegment = the point closest to the line segment (table with x and y member)
        pointLine = the point closest to the line (assuming infinite extent in both directions) (table with x and y member), same as VectorPointProjectionOnLine
        isOnSegment = if the point closest to the line is on the segment
]]
function VectorPointProjectionOnLineSegment(v1, v2, v)
    assert(v1 and v2 and v, "VectorPointProjectionOnLineSegment: wrong argument types (3 <Vector> expected)")
    local cx, cy, ax, ay, bx, by = v.x, (v.z or v.y), v1.x, (v1.z or v1.y), v2.x, (v2.z or v2.y)
    local rL = ((cx - ax) * (bx - ax) + (cy - ay) * (by - ay)) / ((bx - ax) ^ 2 + (by - ay) ^ 2)
    local pointLine = { x = ax + rL * (bx - ax), y = ay + rL * (by - ay) }
    local rS = rL < 0 and 0 or (rL > 1 and 1 or rL)
    local isOnSegment = rS == rL
    local pointSegment = isOnSegment and pointLine or { x = ax + rS * (bx - ax), y = ay + rS * (by - ay) }
    return pointSegment, pointLine, isOnSegment
end

function VectorMovementCollision(startPoint1, endPoint1, v1, startPoint2, v2, delay)
    local sP1x, sP1y, eP1x, eP1y, sP2x, sP2y = startPoint1.x, startPoint1.z or startPoint1.y, endPoint1.x, endPoint1.z or endPoint1.y, startPoint2.x, startPoint2.z or startPoint2.y
    --v2 * t = Distance(P, A + t * v1 * (B-A):Norm())
    --(v2 * t)^2 = (r+S*t)^2+(j+K*t)^2 and v2 * t >= 0
    --0 = (S*S+K*K-v2*v2)*t^2+(-r*S-j*K)*2*t+(r*r+j*j) and v2 * t >= 0
    local d, e = eP1x-sP1x, eP1y-sP1y
    local dist, t1, t2 = math.sqrt(d*d+e*e), nil, nil
    local S, K = dist~=0 and v1*d/dist or 0, dist~=0 and v1*e/dist or 0
    local function GetCollisionPoint(t) return t and {x = sP1x+S*t, y = sP1y+K*t} or nil end
    if delay and delay~=0 then sP1x, sP1y = sP1x+S*delay, sP1y+K*delay end
    local r, j = sP2x-sP1x, sP2y-sP1y
    local c = r*r+j*j
    if dist>0 then
        if v1 == math.huge then
            local t = dist/v1
            t1 = v2*t>=0 and t or nil
        elseif v2 == math.huge then
            t1 = 0
        else
            local a, b = S*S+K*K-v2*v2, -r*S-j*K
            if a==0 then
                if b==0 then --c=0->t variable
                    t1 = c==0 and 0 or nil
                else --2*b*t+c=0
                    local t = -c/(2*b)
                    t1 = v2*t>=0 and t or nil
                end
            else --a*t*t+2*b*t+c=0
                local sqr = b*b-a*c
                if sqr>=0 then
                    local nom = math.sqrt(sqr)
                    local t = (-nom-b)/a
                    t1 = v2*t>=0 and t or nil
                    t = (nom-b)/a
                    t2 = v2*t>=0 and t or nil
                end
            end
        end
    elseif dist==0 then
        t1 = 0
    end
    return t1, GetCollisionPoint(t1), t2, GetCollisionPoint(t2), dist
end

--class'Vector'
Vector = Class()
-- INSTANCED FUNCTIONS
function Vector:__init(a, b, c)
    if a == nil then
        self.x, self.y, self.z = 0.0, 0.0, 0.0
    elseif b == nil then
        assert(VectorType(a), "Vector: wrong argument types (expected nil or <Vector> or 2 <number> or 3 <number>)")
        self.x, self.y, self.z = a.x, a.y, a.z
    else
        assert(type(a) == "number" and (type(b) == "number" or type(c) == "number"), "Vector: wrong argument types (<Vector> or 2 <number> or 3 <number>)")
        self.x = a
        if b and type(b) == "number" then self.y = b end
        if c and type(c) == "number" then self.z = c end
    end

end

function Vector:__type()
    return "Vector"
end

function Vector:__add(v)
    assert(VectorType(v) and VectorType(self), "add: wrong argument types (<Vector> expected)")
    return Vector(self.x + v.x, (v.y and self.y) and self.y + v.y, (v.z and self.z) and self.z + v.z)
end

function Vector:__sub(v)
    assert(VectorType(v) and VectorType(self), "Sub: wrong argument types (<Vector> expected)")
    return Vector(self.x - v.x, (v.y and self.y) and self.y - v.y, (v.z and self.z) and self.z - v.z)
end

function Vector.__mul(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = b.x * a, y = b.y and b.y * a, z = b.z and b.z * a })
    elseif type(b) == "number" and VectorType(a) then
        return Vector({ x = a.x * b, y = a.y and a.y * b, z = a.z and a.z * b })
    else
        assert(VectorType(a) and VectorType(b), "Mul: wrong argument types (<Vector> or <number> expected)")
        return a:dotP(b)
    end
end

function Vector.__div(a, b)
    if type(a) == "number" and VectorType(b) then
        return Vector({ x = a / b.x, y = b.y and a / b.y, z = b.z and a / b.z })
    else
        assert(VectorType(a) and type(b) == "number", "Div: wrong argument types (<number> expected)")
        return Vector({ x = a.x / b, y = a.y and a.y / b, z = a.z and a.z / b })
    end
end

function Vector.__lt(a, b)
    assert(VectorType(a) and VectorType(b), "__lt: wrong argument types (<Vector> expected)")
    return a:len() < b:len()
end

function Vector.__le(a, b)
    assert(VectorType(a) and VectorType(b), "__le: wrong argument types (<Vector> expected)")
    return a:len() <= b:len()
end

function Vector:__eq(v)
    assert(VectorType(v), "__eq: wrong argument types (<Vector> expected)")
    return self.x == v.x and self.y == v.y and self.z == v.z
end

function Vector:__unm() --redone, added check for y and z
    return Vector(-self.x, self.y and -self.y, self.z and -self.z)
end

function Vector:__vector(v)
    assert(VectorType(v), "__vector: wrong argument types (<Vector> expected)")
    return self:crossP(v)
end

function Vector:__tostring()
    if self.y and self.z then
        return "(" .. tostring(self.x) .. "," .. tostring(self.y) .. "," .. tostring(self.z) .. ")"
    else
        return "(" .. tostring(self.x) .. "," .. self.y and tostring(self.y) or tostring(self.z) .. ")"
    end
end

function Vector:clone()
    return Vector(self)
end

function Vector:unpack()
    return self.x, self.y, self.z
end

function Vector:len2(v)
    assert(v == nil or VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local v = v and Vector(v) or self
    return self.x * v.x + (self.y and self.y * v.y or 0) + (self.z and self.z * v.z or 0)
end

function Vector:len()
    return math.sqrt(self:len2())
end

function Vector:dist(v)
    assert(VectorType(v), "dist: wrong argument types (<Vector> expected)")
    local a = self - v
    return a:len()
end

function Vector:normalize()
    local a = self:len()
    self.x = self.x / a
    if self.y then self.y = self.y / a end
    if self.z then self.z = self.z / a end
end

function Vector:normalized()
    local a = self:clone()
    a:normalize()
    return a
end

function Vector:center(v)
    assert(VectorType(v), "center: wrong argument types (<Vector> expected)")
    return Vector((self + v) / 2)
end

function Vector:crossP(other)
    assert(self.y and self.z and other.y and other.z, "crossP: wrong argument types (3 Dimensional <Vector> expected)")
    return Vector({
        x = other.z * self.y - other.y * self.z,
        y = other.x * self.z - other.z * self.x,
        z = other.y * self.x - other.x * self.y
    })
end

function Vector:dotP(other)
    assert(VectorType(other), "dotP: wrong argument types (<Vector> expected)")
    return self.x * other.x + (self.y and (self.y * other.y) or 0) + (self.z and (self.z * other.z) or 0)
end

function Vector:projectOn(v)
    assert(VectorType(v), "projectOn: invalid argument: cannot project Vector on " .. type(v))
    if type(v) ~= "Vector" then v = Vector(v) end
    local s = self:len2(v) / v:len2()
    return Vector(v * s)
end

function Vector:mirrorOn(v)
    assert(VectorType(v), "mirrorOn: invalid argument: cannot mirror Vector on " .. type(v))
    return self:projectOn(v) * 2
end

function Vector:sin(v)
    assert(VectorType(v), "sin: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2() / (self:len2() * v:len2()))
end

function Vector:cos(v)
    assert(VectorType(v), "cos: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    return self:len2(v) / math.sqrt(self:len2() * v:len2())
end

function Vector:angle(v)
    assert(VectorType(v), "angle: wrong argument types (<Vector> expected)")
    return math.acos(self:cos(v))
end

function Vector:affineArea(v)
    assert(VectorType(v), "affineArea: wrong argument types (<Vector> expected)")
    if type(v) ~= "Vector" then v = Vector(v) end
    local a = self:__vector(v)
    return math.sqrt(a:len2())
end

function Vector:triangleArea(v)
    assert(VectorType(v), "triangleArea: wrong argument types (<Vector> expected)")
    return self:affineArea(v) / 2
end

function Vector:rotateXaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.y, self.z = self.y * c - self.z * s, self.z * c + self.y * s
end

function Vector:rotateYaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.z = self.x * c + self.z * s, self.z * c - self.x * s
end

function Vector:rotateZaxis(phi)
    assert(type(phi) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    local c, s = math.cos(phi), math.sin(phi)
    self.x, self.y = self.x * c - self.z * s, self.y * c + self.x * s
end

function Vector:rotate(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotate: wrong argument types (expected <number> for phi)")
    if phiX ~= 0 then self:rotateXaxis(phiX) end
    if phiY ~= 0 then self:rotateYaxis(phiY) end
    if phiZ ~= 0 then self:rotateZaxis(phiZ) end
end

function Vector:rotated(phiX, phiY, phiZ)
    assert(type(phiX) == "number" and type(phiY) == "number" and type(phiZ) == "number", "Rotated: wrong argument types (expected <number> for phi)")
    local a = self:clone()
    a:rotate(phiX, phiY, phiZ)
    return a
end

-- not yet full 3D functions
function Vector:polar()
    if math.close(self.x, 0) then
        if (self.z or self.y) > 0 then return 90
        elseif (self.z or self.y) < 0 then return 270
        else return 0
        end
    else
        local theta = math.deg(math.atan((self.z or self.y) / self.x))
        if self.x < 0 then theta = theta + 180 end
        if theta < 0 then theta = theta + 360 end
        return theta
    end
end

function Vector:angleBetween(v1, v2)
    assert(VectorType(v1) and VectorType(v2), "angleBetween: wrong argument types (2 <Vector> expected)")
    local p1, p2 = (-self + v1), (-self + v2)
    local theta = p1:polar() - p2:polar()
    if theta < 0 then theta = theta + 360 end
    if theta > 180 then theta = 360 - theta end
    return theta
end

function Vector:compare(v)
    assert(VectorType(v), "compare: wrong argument types (<Vector> expected)")
    local ret = self.x - v.x
    if ret == 0 then ret = self.z - v.z end
    return ret
end

function Vector:perpendicular()
    return Vector(-self.z, self.y, self.x)
end

function Vector:perpendicular2()
    return Vector(self.z, self.y, -self.x)
end

function D3DXVECTOR2(x,y)
  return Vector(x,y,nil)
end

function D3DXVECTOR3(x,y,z)
  return Vector(x,y,z)
end

--[[
    Class: Queue
    Performance optimized implementation of a queue, much faster as if you use table.insert and table.remove
        Members:
            pushleft
            pushright
            popleft
            popright
        Sample:
            local myQueue = Queue()
            myQueue:pushleft("a"); myQueue:pushright(2);
            for i=1, #myQueue, 1 do
                PrintChat(tostring(myQueue[i]))
            end
        Notes:
            Don't use ipairs or pairs!
            It's a queue, dont try to insert values by yourself, only use the push functions to add values
]]
function Queue()
    local _queue = { first = 0, last = -1, list = {} }
    _queue.pushleft = function(self, value)
        self.first = self.first - 1
        self.list[self.first] = value
    end
    _queue.pushright = function(self, value)
        self.last = self.last + 1
        self.list[self.last] = value
    end
    _queue.popleft = function(self)
        if self.first > self.last then error("Queue is empty") end
        local value = self.list[self.first]
        self.list[self.first] = nil
        self.first = self.first + 1
        return value
    end
    _queue.popright = function(self)
        if self.first > self.last then error("Queue is empty") end
        local value = self.list[self.last]
        self.list[self.last] = nil
        self.last = self.last - 1
        return value
    end
    setmetatable(_queue,
        {
            __index = function(self, key)
                if type(key) == "number" then
                    return self.list[key + self.first - 1]
                end
            end,
            __newindex = function(self, key, value)
                error("Cant assign value to Queue, use Queue:pushleft or Queue:pushright instead")
            end,
            __len = function(self)
                return self.last - self.first + 1
            end,
        })
    return _queue
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Circle Class
--[[
    Methods:
        circle = Circle(center (opt),radius (opt))
    Function :
        circle:Contains(v)      -- return if Vector point v is in the circle
    Members :
        circle.center           -- Vector point for circle's center
        circle.radius           -- radius of the circle
]]
--class'Circle'
Circle = Class()
function Circle:__init(center, radius)
    assert((VectorType(center) or center == nil) and (type(radius) == "number" or radius == nil), "Circle: wrong argument types (expected <Vector> or nil, <number> or nil)")
    self.center = Vector(center) or Vector()
    self.radius = radius or 0

	return self
end

function Circle:Contains(v)
    assert(VectorType(v), "Contains: wrong argument types (expected <Vector>)")
    return math.close(self.center:dist(v), self.radius)
end

function Circle:__tostring()
    return "{center: " .. tostring(self.center) .. ", radius: " .. tostring(self.radius) .. "}"
end
----------------------------------------------------------------------
-- minionManager
--[[
        minionManager Class :
    Methods:
        minionArray = minionManager(mode, range, fromPos, sortMode)     --return a minionArray instance
    Functions :
        minionArray:update()                -- update the minionArray instance
    Members:
        minionArray.objects                 -- minionArray objects table
        minionArray.iCount                  -- minionArray objects count
        minionArray.mode                    -- minionArray instance mode (MINION_ALL, etc)
        minionArray.range                   -- minionArray instance range
        minionArray.fromPos                 -- minionArray instance x, z from which the range is based (player by default)
        minionArray.sortMode                -- minionArray instance sort mode (MINION_SORT_HEALTH_ASC, etc... or nil if no sorted)
    Usage ex:
        function OnLoad()
            enemyMinions = minionManager(MINION_ENEMY, 600, player, MINION_SORT_HEALTH_ASC)
            allyMinions = minionManager(MINION_ALLY, 300, player, MINION_SORT_HEALTH_DES)
        end
        function OnTick()
            enemyMinions:update()
            allyMinions:update()
            for index, minion in pairs(enemyMinions.objects) do
                -- what you want
            end
            -- ex changing range
            enemyMinions.range = 250
            enemyMinions:update() --not needed
        end
]]
local _minionTable = { {}, {}, {}, {}, {} }
local _minionManager = { init = true, tick = 0, ally = "##", enemy = "##" }
-- Class related constants
MINION_ALL = 1
MINION_ENEMY = 2
MINION_ALLY = 3
MINION_JUNGLE = 4
MINION_OTHER = 5
MINION_SORT_HEALTH_ASC = function(a, b) return a.HP < b.HP end
MINION_SORT_HEALTH_DEC = function(a, b) return a.HP > b.HP end
MINION_SORT_MAXHEALTH_ASC = function(a, b) return a.MaxHP < b.MaxHP end
MINION_SORT_MAXHEALTH_DEC = function(a, b) return a.MaxHP > b.MaxHP end
MINION_SORT_AD_ASC = function(a, b) return a.TotalDmg < b.TotalDmg end
MINION_SORT_AD_DEC = function(a, b) return a.TotalDmg > b.TotalDmg end

local __minionManager__OnCreateObj
local function minionManager__OnLoad()
    if _minionManager.init then
        --[[local mapIndex = GetGame().map.index
        if mapIndex ~= 4 then
            _minionManager.ally = "Minion_T" .. player.team
            _minionManager.enemy = "Minion_T" .. TEAM_ENEMY
        else
            _minionManager.ally = (player.team == TEAM_BLUE and "Blue" or "Red")
            _minionManager.enemy = (player.team == TEAM_BLUE and "Red" or "Blue")
        end]]
        if not __minionManager__OnCreateObj then
            function __minionManager__OnCreateObj(object)
                if object and object.IsValid and _has_value({1,3},object.Type) then
                    DelayAction(function(object)
                      
                        if object and object.IsValid and _has_value({1,3},object.Type) --[["obj_AI_Minion"]] and object.IsVisible and not object.IsDead then
                            --local name = object.name
                            --table.insert(_minionTable[MINION_ALL], object)
            							if not object.IsEnemy and object.Type == 1 then table.insert(_minionTable[MINION_ALLY], object)
            							elseif object.IsEnemy and object.Type == 1 then table.insert(_minionTable[MINION_ENEMY], object)
            							elseif object.Type == 3 then table.insert(_minionTable[MINION_JUNGLE], object)
            							else table.insert(_minionTable[MINION_OTHER], object)
            							end
                        end
                    end, 0, { object })
                end
            end

            --AddCreateObjCallback(__minionManager__OnCreateObj)
        end
        for i = 1, objManager.maxObjects do
            __minionManager__OnCreateObj(objManager:getObject(i))
        end
        _minionManager.init = nil
    end
end

function __minionManager__OnCreateObj2(object, mode)
	if object and object.IsValid and _has_value({1,3},object.Type) then
			if object and object.IsValid and _has_value({1,3},object.Type) --[["obj_AI_Minion"]] and object.IsVisible and not object.IsDead then
				--local name = object.name
				--table.insert(_minionTable[MINION_ALL], object)
				if not object.IsEnemy and object.Type == 1 and mode == MINION_ALLY then table.insert(_minionTable[MINION_ALLY], object)
				elseif object.IsEnemy and object.Type == 1 and mode == MINION_ENEMY then table.insert(_minionTable[MINION_ENEMY], object)
				elseif object.Type == 3 and mode == MINION_JUNGLE then table.insert(_minionTable[MINION_JUNGLE], object)
				elseif mode == MINION_OTHER then table.insert(_minionTable[MINION_OTHER], object)
				end
			end
	end
end

--class'minionManager'

minionManager = Class()

function minionManager:__init(mode, range, fromPos, sortMode)
    assert(type(mode) == "number" and type(range) == "number", "minionManager: wrong argument types (<mode>, <number> expected)")
    --minionManager__OnLoad()
    self.mode = mode
    self.range = range
    self.fromPos = fromPos or player
    self.sortMode = type(sortMode) == "function" and sortMode
    self.objects = {}
    self.iCount = 0
    self:update()
    
	return self
end

function minionManager:update()
	self.fromPos = player
  self.objects = {}
  
	_minionTable[self.mode] = {}
	--objManager:update()
	--print("maxObjects=" .. tostring(objManager.maxObjects))
	for i = 1, objManager.maxObjects do
		__minionManager__OnCreateObj2(objManager:getObject(i), self.mode)
	end

  for _, object in pairs(_minionTable[self.mode]) do
      if object and object.IsValid and not object.IsDead and object.IsVisible and GetDistanceSqr(self.fromPos, object) <= (self.range) ^ 2 then
          table.insert(self.objects, object)
      end
  end
  if self.sortMode then table.sort(self.objects, self.sortMode) end
  self.iCount = #self.objects
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- GetMinionCollision
--[[
    Goblal Function :
    GetMinionCollision(posEnd, spellWidth)          -> return true/false if collision with minion from player to posEnd with spellWidth.
]]
local function _minionInCollision(minion, posStart, posEnd, spellSqr, sqrDist)
    if GetDistanceSqr(minion, posStart) < sqrDist and GetDistanceSqr(minion, posEnd) < sqrDist then
        local _, p2, isOnLineSegment = VectorPointProjectionOnLineSegment(posStart, posEnd, minion)
        if isOnLineSegment and GetDistanceSqr(minion, p2) <= spellSqr then return true end
    end
    return false
end

function GetMinionCollision(posStart, posEnd, spellWidth, minionTable)
    assert(VectorType(posStart) and VectorType(posEnd) and type(spellWidth) == "number", "GetMinionCollision: wrong argument types (<Vector>, <Vector>, <number> expected)")
    local sqrDist = GetDistanceSqr(posStart, posEnd)
    local spellSqr = spellWidth * spellWidth / 4
    if minionTable then
        for _, minion in pairs(minionTable) do
            if _minionInCollision(minion, posStart, posEnd, spellSqr, sqrDist) then return true end
        end
    else
        for i = 0, objManager.maxObjects, 1 do
            local object = objManager:getObject(i)
            if object and object.IsValid and object.TeamId ~= player.TeamId and (object.Type == 1 or object.Type == 3) and not object.IsDead and object.IsVisible and object.CanSelect then
                if _minionInCollision(object, posStart, posEnd, spellSqr, sqrDist) then return true end
            end
        end
    end
    return false
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Minimum Enclosing Circle class
--[[
    Global function ;
        GetMEC(R, range)                    -- Find Group Center From Nearest Enemies
        GetMEC(R, range, target)            -- Find Group Center Near Target
    MEC Class :
        Methods:
            mec = MEC(points (opt))
        Function :
            mec:SetPoints(points)
            mec:HalfHull(left, right, pointTable, factor)   -- return table
            mec:ConvexHull()                                -- return table
            mec:Compute()
        Members :
            mec.circle
            mec.points
]]
--class'MEC'
MEC = Class()

function MEC:__init(points)
    self.circle = Circle()
    self.points = {}
    if points then
        self:SetPoints(points)
    end

	return self
end

function MEC:SetPoints(points)
    -- Set the points
    self.points = {}
    for _, p in ipairs(points) do
        table.insert(self.points, Vector(p))
    end
end

function MEC:HalfHull(left, right, pointTable, factor)
    -- Computes the half hull of a set of points
    local input = pointTable
    table.insert(input, right)
    local half = {}
    table.insert(half, left)
    for _, p in ipairs(input) do
        table.insert(half, p)
        while #half >= 3 do
            local dir = factor * VectorDirection(half[(#half + 1) - 3], half[(#half + 1) - 1], half[(#half + 1) - 2])
            if dir <= 0 then
                table.remove(half, #half - 1)
            else
                break
            end
        end
    end
    return half
end

function MEC:ConvexHull()
    -- Computes the set of points that represent the convex hull of the set of points
    local left, right = self.points[1], self.points[#self.points]
    local upper, lower, ret = {}, {}, {}
    -- Partition remaining points into upper and lower buckets.
    for i = 2, #self.points - 1 do
        if VectorType(self.points[i]) == false then print("self.points[i]") end
        table.insert((VectorDirection(left, right, self.points[i]) < 0 and upper or lower), self.points[i])
    end
    local upperHull = self:HalfHull(left, right, upper, -1)
    local lowerHull = self:HalfHull(left, right, lower, 1)
    local unique = {}
    for _, p in ipairs(upperHull) do
        unique["x" .. p.x .. "z" .. p.z] = p
    end
    for _, p in ipairs(lowerHull) do
        unique["x" .. p.x .. "z" .. p.z] = p
    end
    for _, p in pairs(unique) do
        table.insert(ret, p)
    end
    return ret
end

function MEC:Compute()
    -- Compute the MEC.
    -- Make sure there are some points.
    if #self.points == 0 then return nil end
    -- Handle degenerate cases first
    if #self.points == 1 then
        self.circle.center = self.points[1]
        self.circle.radius = 0
        self.circle.radiusPoint = self.points[1]
    elseif #self.points == 2 then
        local a = self.points
        self.circle.center = a[1]:center(a[2])
        self.circle.radius = a[1]:dist(self.circle.center)
        self.circle.radiusPoint = a[1]
    else
        local a = self:ConvexHull()
        local point_a = a[1]
        local point_b
        local point_c = a[2]
        if not point_c then
            self.circle.center = point_a
            self.circle.radius = 0
            self.circle.radiusPoint = point_a
            return self.circle
        end
        -- Loop until we get appropriate values for point_a and point_c
        while true do
            point_b = nil
            local best_theta = 180.0
            -- Search for the point "b" which subtends the smallest angle a-b-c.
            for _, point in ipairs(self.points) do
                if (not point == point_a) and (not point == point_c) then
                    local theta_abc = point:angleBetween(point_a, point_c)
                    if theta_abc < best_theta then
                        point_b = point
                        best_theta = theta_abc
                    end
                end
            end
            -- If the angle is obtuse, then line a-c is the diameter of the circle,
            -- so we can return.
            if best_theta >= 90.0 or (not point_b) then
                self.circle.center = point_a:center(point_c)
                self.circle.radius = point_a:dist(self.circle.center)
                self.circle.radiusPoint = point_a
                return self.circle
            end
            local ang_bca = point_c:angleBetween(point_b, point_a)
            local ang_cab = point_a:angleBetween(point_c, point_b)
            if ang_bca > 90.0 then
                point_c = point_b
            elseif ang_cab <= 90.0 then
                break
            else
                point_a = point_b
            end
        end
        local ch1 = (point_b - point_a) * 0.5
        local ch2 = (point_c - point_a) * 0.5
        local n1 = ch1:perpendicular2()
        local n2 = ch2:perpendicular2()
        ch1 = point_a + ch1
        ch2 = point_a + ch2
        self.circle.center = VectorIntersection(ch1, n1, ch2, n2)
        self.circle.radius = self.circle.center:dist(point_a)
        self.circle.radiusPoint = point_a
    end
    return self.circle
end

function GetMEC(radius, range, target)
    assert(type(radius) == "number" and type(range) == "number" and (target == nil or target.team ~= nil), "GetMEC: wrong argument types (expected <number>, <number>, <object> or nil)")
    local points = {}
    for i = 1, heroManager.iCount do
        local object = heroManager:GetHero(i)
        if (target == nil and ValidTarget(object, (range + radius))) or (target and ValidTarget(object, (range + radius), (target.TeamId ~= player.TeamId)) and (ValidTargetNear(object, radius * 2, target) or object.NetworkId == target.NetworkId)) then
            table.insert(points, Vector(object))
        end
    end
    return _CalcSpellPosForGroup(radius, range, points)
end

function _CalcSpellPosForGroup(radius, range, points)
    if #points == 0 then
        return nil
    elseif #points == 1 then
        return Circle(Vector(points[1]))
    end
    local mec = MEC()
    local combos = {}
    for j = #points, 2, -1 do
        local spellPos
        combos[j] = {}
        _CalcCombos(j, points, combos[j])
        for _, v in ipairs(combos[j]) do
            mec:SetPoints(v)
            local c = mec:Compute()
            if c ~= nil and c.radius <= radius and c.center:dist(player) <= range and (spellPos == nil or c.radius < spellPos.radius) then
                spellPos = Circle(c.center, c.radius)
            end
        end
        if spellPos ~= nil then return spellPos end
    end
end

function _CalcCombos(comboSize, targetsTable, comboTableToFill, comboString, index_number)
    local comboString = comboString or ""
    local index_number = index_number or 1
    if string.len(comboString) == comboSize then
        local b = {}
        for i = 1, string.len(comboString), 1 do
            local ai = tonumber(string.sub(comboString, i, i))
            table.insert(b, targetsTable[ai])
        end
        return table.insert(comboTableToFill, b)
    end
    for i = index_number, #targetsTable, 1 do
        _CalcCombos(comboSize, targetsTable, comboTableToFill, comboString .. i, i + 1)
    end
end

-- for combat
FindGroupCenterFromNearestEnemies = GetMEC
function FindGroupCenterNearTarget(target, radius, range)
    return GetMEC(radius, range, target)
end

--[[
    Class: WayPointManager
        Note: Only works for VIP user
            uses the Packet Conversion Library, might change in future

    Methods:
        WayPointManager:GetWayPoints(object) --returns all next waypoints of an object
                                             --The first WayPoint is always close to the position of the object itself.
                                             --A Waypoint is a Point with x and y values.
        WayPointManager:GetSimulatedWayPoints(object, [fromT, toT])
                                             --return waypoints, estimated duration(s) until target arrives at the last wayPoint (0 if already reached it)
                                             --Simulates the WayPoints in a time interval
                                             --Will simulate the target movement after going in FoW
        WayPointManager:GetWayPointChangeRate(object, [time])
                                             --only works for hero's
                                             --return how often the wayPoints changed in the last specific amount of time (default 1s)
                                             --max. Value when you hold MouseRight is 4s^-1, max. is 6s^-1
        WayPointManager:DrawWayPoints(obj, [color, size, fromT, toT])
                                             --Draws the WayPoints of an Object
    Example: local wayPointManager = WayPointManager()
    function OnDraw()
        wayPointManager:DrawWayPoints(player)
        wayPointManager:DrawWayPoints(player, ARGB(255,0,0,255), 2, 1, 2) --Draws from 1second ahead to 2seconds ahead of the object
        DrawText3D(tostring(wayPointManager:GetWayPointChangeRate(player)), player.x, player.y, player.z, 30, ARGB(255,0,255,0), true)
    end
]]

--class'WayPointManager'
WayPointManager = Class()

local WayPoints, WayPointRate, WayPointVisibility, WayPointCallbacks

local function WayPointManager_Callback(networkId)
    if WayPointCallbacks then
        for i, foo in pairs(WayPointCallbacks) do
            if type(foo)=="function" then
                foo(networkId)
            end
        end
    end
end

local function WayPointManager_OnTick(h)
    if h.PathCount == 1 then
        local networkID = h.NetworkId
        WayPoints[networkID] = {h.GetPath(h.PathCount)}
        WayPointManager_Callback(networkID)
    elseif h.PathCount > 1 then
        local hWayPoints = {}
        for i=1, h.PathCount do
          table.insert(hWayPoints[h.NetworkId], {h.GetPath(i)})
        end
        for networkID, wayPoints in pairs(hWayPoints) do
            if WayPoints[networkID] then
                if WayPointRate[networkID] then
                    local wps = WayPoints[networkID]
                    local lwp, found = wps[#wps], false
                    for i = #wayPoints - 1, math.max(2, #wayPoints - 3), -1 do
                        local A, B = wayPoints[i], wayPoints[i + 1]
                        if lwp and A and B and GetDistanceSqr(lwp, VectorPointProjectionOnLineSegment(lwp, A, B)) < 1000 then found = true break end
                    end
                    if not found then WayPointRate[networkID]:pushleft(os.clock()) end
                    if #WayPointRate[networkID] > 20 then WayPointRate[networkID]:popright() end --Avoid memory leaks
                end
            end
            WayPoints[networkID] = wayPoints
            WayPointManager_Callback(networkID)
        end
    end
end

local function WayPointManager_OnDeleteObject(obj)
    local nwID = obj.NetworkId
    if nwID and nwID ~= 0 then WayPoints[nwID] = nil end
end

function WayPointManager:__init()
    if not WayPoints then
        WayPoints = {}
        WayPointRate = {}
        for i = 1, heroManager.iCount do
            local hero = heroManager:GetHero(i)
            if hero ~= nil and hero.IsValid and hero.NetworkId and hero.NetworkId ~= 0 then
                WayPointRate[hero.NetworkId] = Queue()
            end
        end
        WayPointVisibility = {}
        if AddTickWayPointsCallback then
            AddDeleteObjCallback(WayPointManager_OnDeleteObject)
            AddTickWayPointsCallback(WayPointManager_OnTick)
            
            --AdvancedCallback:bind('OnLoseVision', function(hero) if hero.valid and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPointVisibility[hero.networkID] = os.clock() end end)
            --AdvancedCallback:bind('OnGainVision', function(hero) if hero.valid and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPointVisibility[hero.networkID] = nil end end)
            --AdvancedCallback:bind('OnFinishRecall', function(hero) if hero.valid and hero.team == TEAM_ENEMY and hero.networkID == hero.networkID and hero.networkID ~= 0 then WayPoints[hero.networkID] = { { x = GetEnemySpawnPos().x, y = GetEnemySpawnPos().z } } WayPointVisibility[hero.networkID] = nil end end)
        end
        WayPointCallbacks = {}
    end

	return self
end

function WayPointManager.AddCallback(foo)
    WayPointManager()
    WayPointCallbacks[#WayPointCallbacks+1] = foo
end

function WayPointManager:GetRawWayPoints(object)
    return WayPoints[object.NetworkId]
end

function WayPointManager:GetWayPoints(object)
    local wayPoints, lineSegment, distanceSqr, fPoint = WayPoints[object.NetworkId], 0, math.huge, nil
    if not wayPoints then return { { x = object.x, y = object.z } } end
    for i = 1, #wayPoints - 1 do
        local p1, _, _ = VectorPointProjectionOnLineSegment(wayPoints[i], wayPoints[i + 1], object)
        local distanceSegmentSqr = GetDistanceSqr(p1, object)
        if distanceSegmentSqr < distanceSqr then
            fPoint = p1
            lineSegment = i
            distanceSqr = distanceSegmentSqr
        else break --not necessary, but makes it faster
        end
    end
    local result = { fPoint or { x = object.x, y = object.z } }
    for i = lineSegment + 1, #wayPoints do
        result[#result + 1] = wayPoints[i]
    end
    if #result == 2 and GetDistanceSqr(result[1], result[2]) < 400 then result[2] = nil end
    WayPoints[object.NetworkId] = result --not necessary, but makes later runs faster
    return result
end

function WayPointManager:GetPathLength(wayPointList, startIndex, endIndex)
    local tDist = 0
    for i = math.max(startIndex or 1, 1), math.min(#wayPointList, endIndex or math.huge) - 1 do
        tDist = tDist + GetDistance(wayPoints[i], wayPoints[i + 1])
    end
    return tDist
end

function WayPointManager:GetSimulatedWayPoints(object, fromT, toT)
    local wayPoints, fromT, toT = self:GetWayPoints(object), fromT or 0, toT or math.huge
    local invisDur = (not object.IsVisible and WayPointVisibility[object.NetworkId]) and os.clock() - WayPointVisibility[object.NetworkId] or ((not object.IsVisible and not WayPointVisibility[object.NetworkId]) and math.huge or 0)
    fromT = fromT + invisDur
    local tTime, fTime, result = 0, 0, {}
    for i = 1, #wayPoints - 1 do
        local A, B = wayPoints[i], wayPoints[i + 1]
        local dist = GetDistance(A, B)
        local cTime = dist / object.MoveSpeed
        if tTime + cTime >= fromT then
            if #result == 0 then
                fTime = fromT - tTime
                result[1] = { x = A.x + object.ms * fTime * ((B.x - A.x) / dist), y = A.y + object.MoveSpeed * fTime * ((B.y - A.y) / dist) }
            end
            if tTime + cTime >= toT then
                result[#result + 1] = { x = A.x + object.MoveSpeed * (toT - tTime) * ((B.x - A.x) / dist), y = A.y + object.MoveSpeed * (toT - tTime) * ((B.y - A.y) / dist) }
                fTime = fTime + toT - tTime
                break
            else
                result[#result + 1] = B
                fTime = fTime + cTime
            end
        end
        tTime = tTime + cTime
    end
    if #result == 0 and (tTime >= toT or invisDur) then result[1] = wayPoints[#wayPoints] end
    return result, fTime
end


function WayPointManager:GetWayPointChangeRate(object, time)
    local lastChanges = WayPointRate[object.NetworkId]
    if not lastChanges then return 0 end
    local time, rate = time or 1, 0
    for i = 1, #lastChanges do
        local t = lastChanges[i]
        if os.clock() - t >= time then break end
        rate = rate + 1
    end
    return rate
end
--[[
function WayPointManager:DrawWayPoints(obj, color, size, fromT, toT)
    local wayPoints = self:GetSimulatedWayPoints(obj, fromT, toT)
    local points = {}
    for i = 1, #wayPoints do
        local wayPoint = wayPoints[i]
        local c = WorldToScreen(D3DXVECTOR3(wayPoint.x, obj.y, wayPoint.y))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, size or 1, color or 4294967295)
end]]
---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Turrets
--[[
]]
local _turrets, __turrets__OnTick
local function __Turrets__init()
    if _turrets == nil then
        _turrets = {}
        local turretRange = 950
        local fountainRange = 1050
        local visibilityRange = 1300
        for i = 1, objManager.maxObjects do
            local object = objManager:getObject(i)
            if object ~= nil and object.Type == 2--[["obj_AI_Turret"]] then
                local turretName = object.Name
                _turrets[turretName] = {
                    object = object,
                    team = object.TeamId,
                    range = turretRange,
                    visibilityRange = visibilityRange,
                    x = object.x,
                    y = object.y,
                    z = object.z,
                }
               --[[ if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
                    _turrets[turretName].range = fountainRange
                    for j = 1, objManager.maxObjects do
                        local object2 = objManager:getObject(j)
                        if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistanceSqr(object, object2) < 1000000 then
                            _turrets[turretName].x = object2.x
                            _turrets[turretName].z = object2.z
                        elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
                            _turrets[turretName].y = object2.y
                        end
                    end
                end
                ]]
            end
        end
        function __turrets__OnTick()
            for name, turret in pairs(_turrets) do
                if turret.object.IsValid == false or turret.object.IsDead or turret.object.HP == 0 then
                    _turrets[name] = nil
                end
            end
        end

        AddTickCallback(__turrets__OnTick)
    end
end

function GetTurrets()
    __Turrets__init()
    return _turrets
end

function UnderTurret(pos, enemyTurret)
    __Turrets__init()
    local enemyTurret = (enemyTurret ~= false)
    for _, turret in pairs(_turrets) do
        if turret ~= nil and (turret.team ~= player.TeamId) == enemyTurret and GetDistanceSqr(turret, pos) <= (turret.range) ^ 2 then
            return true
        end
    end
    return false
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--  autoLevel
--[[
autoLevelSetSequence(sequence)  -- set the sequence
autoLevelSetFunction(func)      -- set the function used if sequence level == 0
    Usage :
        On your script :
        Set the levelSequence :
            local levelSequence = {1,nil,0,1,1,4,1,nil,1,nil,4,nil,nil,nil,nil,4,nil,nil}
            autoLevelSetSequence(levelSequence)
                The levelSequence is table of 18 fields
                1-4 = spell 1 to 4
                nil = will not auto level on this one
                0 = will use your own function for this one, that return a number between 1-4
        Set the function if you use 0, example :
            local onChoiceFunction = function()
                if player:GetSpellData(SPELL_2).level < player:GetSpellData(SPELL_3).level then
                    return 2
                else
                    return 3
                end
            end
            autoLevelSetFunction(onChoiceFunction)
]]
local _autoLevel = { spellsSlots = { SPELL_1, SPELL_2, SPELL_3, SPELL_4 }, levelSequence = {}, nextUpdate = 0, tickUpdate = 500 }
local __autoLevel__OnTick
local function autoLevel__OnLoad()
    if not __autoLevel__OnTick then
        function __autoLevel__OnTick()
            local tick = GetTickCount()
            if _autoLevel.nextUpdate > tick then return end
            _autoLevel.nextUpdate = tick + _autoLevel.tickUpdate
            local realLevel = GetHeroLeveled()
            if player.Level > realLevel and _autoLevel.levelSequence[realLevel + 1] ~= nil then
                local splell = _autoLevel.levelSequence[realLevel + 1]
                if splell == 0 and type(_autoLevel.onChoiceFunction) == "function" then splell = _autoLevel.onChoiceFunction() end
                if type(splell) == "number" and splell >= 1 and splell <= 4 then UpSpellLevel(_autoLevel.spellsSlots[splell] - 1) end
            end
        end

        AddTickCallback(__autoLevel__OnTick)
    end
end

function autoLevelSetSequence(sequence)
    assert(sequence == nil or type(sequence) == "table", "autoLevelSetSequence : wrong argument types (<table> or nil expected)")
    autoLevel__OnLoad()
    local sequence = sequence or {}
    for i = 1, 18 do
        local spell = sequence[i]
        if type(spell) == "number" and spell >= 0 and spell <= 4 then
            _autoLevel.levelSequence[i] = spell
        else
            _autoLevel.levelSequence[i] = nil
        end
    end
end

function autoLevelSetFunction(func)
    assert(func == nil or type(func) == "function", "autoLevelSetFunction : wrong argument types (<function> or nil expected)")
    autoLevel__OnLoad()
    _autoLevel.onChoiceFunction = func
end

---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

function GetTargetFromTargetId(targetid)
	player = GetMyHero()
	GetAllObjectAroundAnObject(myHero.Addr, 3000)
	-- 0=champ, 1=minion, 2=turret, 3=jungle, 4= Inhibitor, 5=Nexus, 6=Missile, -1= other
	for i, obj in pairs(pObject) do
		if obj ~= 0 then
			local object = nil
			if GetType(obj) == 0 then
				object = GetAIHero(obj)
			elseif _has_value({1,2,3}, GetType(obj)) then
				object = GetUnit(obj)
			elseif GetType(obj) == 6 then
				object = GetMissile(obj)
			elseif _has_value({4,5}, GetType(obj)) then
				object = GetBarrack(obj)
			elseif GetType(obj) == -1 then
				object = {}
				object.Addr = obj
				object.Type = -1
				object.Id = GetId(obj)
				--object.Name = GetObjName(obj)
				--object.CharName = GetChampName(obj)
			end

			if object and object.Id == targetid then
				return object
			end
		end
	end

	return nil
end



---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

