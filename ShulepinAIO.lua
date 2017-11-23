--[[
  ____                  _ ____
 / ___|  __ _ _ __   __| | __ )  _____  __
 \___ \ / _` | '_ \ / _` |  _ \ / _ \ \/ /
  ___) | (_| | | | | (_| | |_) | (_) >  <
 |____/ \__,_|_| |_|\__,_|____/ \___/_/\_\

--]]


--Main functions
local assert = assert
local getmetatable = assert(getmetatable )
local ipairs = assert(ipairs)
local next = assert(next)
local pairs = assert(pairs)
local rawequal = assert(rawequal)
local rawset = assert(rawset)
local select = assert(select)
local setmetatable = assert(setmetatable)
local tonumber = assert(tonumber)
local tostring = assert(tostring)
local type = assert(type)
local require = assert(require)
local unpack = assert(unpack)

--Table Library
local t = {}
t.concat = assert(table.concat)
t.insert = assert(table.insert)
t.remove = assert(table.remove)
t.sort = assert(table.sort)

--String Library
local str = {}
str.byte = assert(string.byte)
str.char = assert(string.char)
str.dump = assert(string.dump)
str.find = assert(string.find)
str.format = assert(string.format)
str.gmatch = assert(string.gmatch)
str.gsub = assert(string.gsub)
str.len = assert(string.len)
str.lower = assert(string.lower)
str.match = assert(string.match)
str.reverse = assert(string.reverse)
str.sub = assert(string.sub)
str.upper = assert(string.upper)

--Math Library
local m = {}
m.pi = assert(math.pi)
m.huge = assert(math.huge)
m.floor = assert(math.floor)
m.ceil = assert(math.ceil)
m.abs = assert(math.abs)
m.deg = assert(math.deg)
m.atan = assert(math.atan)
m.sqrt = assert(math.sqrt)
m.sin = assert(math.sin)
m.cos = assert(math.cos)
m.acos = assert(math.acos)
m.max = assert(math.max)
m.min = assert(math.min)

--IO Library
local IO = {}
IO.open = assert(io.open)
IO.close = assert(io.close)

local function classInstance()
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

local myHero = GetMyHero()
local comboKey = 32
local laneClearKey = 86
local LaneClearUseMana = 60

--[[
   ____      _ _ _                _
  / ___|__ _| | | |__   __ _  ___| | _____
 | |   / _` | | | '_ \ / _` |/ __| |/ / __|
 | |__| (_| | | | |_) | (_| | (__|   <\__ \
  \____\__,_|_|_|_.__/ \__,_|\___|_|\_\___/

--]]

local Callback = classInstance()

local Callbacks = {
        ["Load"]         = {},
        ["Tick"]         = {},
        ["Update"]       = {},
        ["Draw"]         = {},
        ["UpdateBuff"]   = {},
        ["RemoveBuff"]   = {},
        ["ProcessSpell"] = {},
        ["CreateObject"] = {},
        ["DeleteObject"] = {},
}

Callback.Add = function(type, cb) t.insert(Callbacks[type], cb) end
Callback.Del = function(type, id) t.remove(Callbacks[type], id or 1) end

function OnLoad()
        for i, cb in pairs(Callbacks["Load"]) do
                cb()
        end
end

function OnTick()
        for i, cb in pairs(Callbacks["Tick"]) do
                cb()
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
        if unit and buff then
                for i, cb in pairs(Callbacks["UpdateBuff"]) do
                        cb(unit, buff, stacks)
                end
        end
end

function OnRemoveBuff(unit, buff)
        if unit and buff then
                for i, cb in pairs(Callbacks["RemoveBuff"]) do
                        cb(unit, buff)
                end
        end
end

function OnProcessSpell(unit, spell)
        if unit and spell then
                for i, cb in pairs(Callbacks["ProcessSpell"]) do
                        cb(unit, {
                                addr = spell,
                                name = GetName_Casting(spell),
                                owner = GetOwnerID_Casting(spell),
                                target = GetTargetID_Casting(spell),
                                startPos = { x = GetSrcPosX_Casting(spell), y = GetSrcPosY_Casting(spell), z = GetSrcPosZ_Casting(spell) },
                                endPos = { x = GetDestPosX_Casting(spell), y = GetDestPosY_Casting(spell), z = GetDestPosZ_Casting(spell) },
                                cursorPos = { x = GetCursorPosX_Casting(spell), y = GetCursorPosY_Casting(spell), z = GetCursorPosZ_Casting(spell) },
                                delay = GetDelay_Casting(spell),
                                time = GetTimeGame()
                        })
                end
        end
end

function OnCreateObject(unit)
        if unit then
                for i, cb in pairs(Callbacks["CreateObject"]) do
                        cb(unit)
                end
        end
end

function OnDeleteObject(unit)
        if unit then
                for i, cb in pairs(Callbacks["DeleteObject"]) do
                        cb(unit)
                end
        end
end

--[[
   ____
  / ___|___  _ __ ___  _ __ ___   ___  _ __
 | |   / _ \| '_ ` _ \| '_ ` _ \ / _ \| '_ \
 | |__| (_) | | | | | | | | | | | (_) | | | |
  \____\___/|_| |_| |_|_| |_| |_|\___/|_| |_|

--]]

local function IsVector(v)
        return v and v.x and type(v.x) == "number" and ((v.y and type(v.y) == "number") or (v.z and type(v.z) == "number"))
end

--String
function string.join(arg, del)
        return t.concat(arg, del)
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

--Math
function math.round(num, idp)
        local mult = 10 ^ (idp or 0)

        if num >= 0 then
                return m.floor(num * mult + 0.5) / mult
        else
                return m.ceil(num * mult - 0.5) / mult
        end
end

function math.close(a, b, eps)
        eps = eps or 1e-9
        return m.abs(a - b) <= eps
end

function math.limit(val, min, max)
        return m.min(max, m.max(min, val))
end

--Table
function table.copy(from, dcopy)
        if type(from) == "table" then
                local to = {}

                for k, v in pairs(from) do
                        if dcopy and type(v) == "table" then
                                to[k] = table.copy(v)
                        else
                                to[k] = v
                        end
                end

                return to
        end
end

function table.clear(t)
        for i, v in pairs(t) do
            t[i] = nil
        end
end

function table.contains(t, what, member)
        for i, v in pairs(t) do
                if member and v[member] == what or v == what then
                        return i, v
                end
        end
end

function table.merge(base, t, dmerge)
        for i, v in pairs(t) do
                if dmerge and type(v) == "table" and type(base[i]) == "table" then
                                base[i] = table.merge(base[i], v)
                else
                        base[i] = v
                end
        end

        return base
end

function table.serialize(t, name, indent)
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
                        return str.format("%q", ts)
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

                                              local fname = str.format("%s[%s]", name, k)
                                              field = str.format("[%s]", k)
                                              addToCart(v, fname, indent .. "   ", saved, field)
                                        end

                                        cart = cart .. indent .. "};\n"
                                end
                        end
                end
        end

        name = name or "<table>"

        if type(t) ~= "table" then
                  return name .. " = " .. basicSerialize(t)
        end

        cart, autoref = "", ""
        addToCart(t, name, indent)

        return cart .. autoref
end

--Custom print functions
local function ctype(t)
        local _type = type(t)
        if _type == "userdata" then
                local metatable = getmetatable(t)
                if not metatable or not metatable.__index then
                        t, _type = "userdata", "string"
                end
        end
        if _type == "userdata" or _type == "table" then
                local _getType = t.__type or t.type or t.Type
                _type = type(_getType)=="function" and _getType(t) or type(_getType)=="string" and _getType or _type
        end
        return _type
end

local function print(...)
        local tV, len = {}, select("#", ...)

        for i = 1, len do
                local value = select(i, ...)
                local type = ctype(value)

                if type == "string" then
                        tV[i] = value
                elseif type == "vector" then
                        tV[i] = tostring(value)
                elseif type == "number" then
                        tV[i] = tostring(value)
                elseif type == "table" then
                        tV[i] = table.serialize(value)
                elseif type == "boolean" then
                    tV[i] = value and "true" or "false"
                else
                    tV[i] = "<" .. type .. ">"
                end
        end

        if len > 0 then
                __PrintTextGame(t.concat(tV))
        end
end

local function printDebug(...)
        local tV, len = {}, select("#", ...)

        for i = 1, len do
                local value = select(i, ...)
                local type = ctype(value)

                if type == "string" then
                        tV[i] = value
                elseif type == "vector" then
                        tV[i] = tostring(value)
                elseif type == "number" then
                        tV[i] = tostring(value)
                elseif type == "table" then
                        tV[i] = table.serialize(value)
                elseif type == "boolean" then
                    tV[i] = value and "true" or "false"
                else
                    tV[i] = "<" .. type .. ">"
                end
        end

        if len > 0 then
                __PrintDebug("[TOIR_DEBUG]" .. t.concat(tV))
        end
end

local function GetOrigin(unit)
        if type(unit) == "number" then
                return { x = GetPosX(unit), y = GetPosY(unit), z = GetPosZ(unit) }
        elseif type(unit) == "table" then
                if unit.x and type(unit.x) == "number" then
                        return { x = unit.x, y = unit.y, z = unit.z }
                elseif unit[1] and type(unit[1]) == "number" then
                        return { x = unit[1], y = unit[2], z = unit[3] }
                end
        end
end

local function GetPing()
        return GetLatency()/1000
end

local function GetTrueAttackRange()
        return GetAttackRange(myHero.Addr) + GetOverrideCollisionRadius(myHero.Addr)
end

local function GetDistance(p1, p2)
        local p2 = p2 or GetOrigin(myHero)

        return GetDistance2D(p1.x, p1.z or p1.y, p2.x, p2.z or p2.y)
end

local function GetPercentHP(unit)
        return GetHealthPoint(unit) / GetHealthPointMax(unit) * 100
end

local function GetPercentMP(unit)
        return GetManaPoint(unit) / GetManaPointMax(unit) * 100
end

local function GetPredictionPos(unit)
        if type(unit) == "number" then
                return { x = GetPredictionPosX(unit), y = GetPredictionPosY(unit), z = GetPredictionPosZ(unit) }
        end
end

local function IsValidTarget(unit, range)
        local range = range or huge
        return unit ~= 0 and not IsDead(unit) and not IsInFog(unit) and GetTargetableToTeam(unit) == 4 and IsEnemy(unit) and GetDistance(GetOrigin(unit)) <= range
end

local function WorldToScreen(x, y, z)
        local scrX, scrY = 0, 0

        if type(x) == "table" then
                scrX = GetScreenPosX_FromWolrdPos(x.x, x.y, x.z)
                scrY = GetScreenPosY_FromWolrdPos(x.x, x.y, x.z)
        else
                scrX = GetScreenPosX_FromWolrdPos(x, y, z)
                scrY = GetScreenPosY_FromWolrdPos(x, y, z)
        end

        return { x = scrX, y = scrY }
end

local function GetMousePos()
        return { x = GetCursorPosX(), y = GetCursorPosY(), z = GetCursorPosZ() }
end

local function GetCursorPos()
        return WorldToScreen(GetMousePos())
end

local function CircleCircleIntersection(c1, c2, r1, r2)
        local D = GetDistance(c1, c2)
        if D > r1 + r2 or D <= m.abs(r1 - r2) then return nil end
        local A = (r1 * r2 - r2 * r1 + D * D) / (2 * D)
        local H = m.sqrt(r1 * r1 - A * A)
        local Direction = (c2 - c1):Normalized()
        local PA = c1 + A * Direction
        local S1 = PA + H * Direction:Perpendicular()
        local S2 = PA - H * Direction:Perpendicular()
        return S1, S2
end

local delayedActions = {}
local delayedActionsExecuter = nil
local function DelayAction(func, delay, args)
        if not delayedActionsExecuter then
                function delayedActionsExecuter()
                        for i, funcs in pairs(delayedActions) do
                                if i <= GetTimeGame() then
                                        for _, f in ipairs(funcs) do
                                                f.func(unpack(f.args or {}))
                                        end

                                        delayedActions[i] = nil
                                end
                        end
                end

                Callback.Add("Tick", delayedActionsExecuter)
        end

        local time = GetTimeGame() + (delay or 0)

        if delayedActions[time] then
                t.insert(delayedActions[time], { func = func, args = args })
        else
                delayedActions[time] = { { func = func, args = args } }
        end
end

local function VPGetLineCastPosition(target, delay, speed)
        local distance = GetDistance(GetOrigin(target))
        local time = delay + distance / speed
        local realDistance = (time * GetMoveSpeed(target))
        if realDistance == 0 then return distance end
        return realDistance
end

local function GetCollision(target, width, range, distance)
        local predPos = GetPredictionPos(target)
        local myHeroPos = GetOrigin(myHero)
        local targetPos = GetOrigin(target)

        local count = 0

        if predPos.x ~= 0 and predPos.z ~= 0 then
                count = CountObjectCollision(0, target, myHeroPos.x, myHeroPos.z, predPos.x, predPos.z, width, range, 10)
        else
                count = CountObjectCollision(0, target, myHeroPos.x, myHeroPos.z, targetPos.x, targetPos.z, width, range, 10)
        end

        if count == 0 then
                return false
        end

        return true
end

Callback.Add("Update", function()
        myHero = GetMyHero()
end)

--[[
 __     __        _
 \ \   / /__  ___| |_ ___  _ __
  \ \ / / _ \/ __| __/ _ \| '__|
   \ V /  __/ (__| || (_) | |
    \_/ \___|\___|\__\___/|_|

--]]

local Vector = classInstance()

function Vector:__init(a, b, c)
        self.type = "vector"

        if a == nil then
                self.x, self.y, self.z = 0.0, 0.0, 0.0
        elseif b == nil then
                --a = a.position or a
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

function Vector:__tostring()
        return "Vector(" .. self.x .. ", " .. self.y .. ", " .. self.z .. ")"
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
        return m.sqrt(self:Len2())
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
        return m.sqrt(a:Len2() / (self:Len2() * v:Len2()))
end

function Vector:Cos(v)
        return self:Len2(v) / sqrt(self:Len2() * v:Len2())
end

function Vector:Angle(v)
        return m.acos(self:Cos(v))
end

function Vector:AffineArea(v)
        local a = self:CrossProduct(v)
        return m.sqrt(a:Len2())
end

function Vector:TriangleArea(v)
        return self:AffineArea(v) / 2
end

function Vector:RotateX(phi)
        local c, s = m.cos(phi), m.sin(phi)
        self.y, self.z = self.y * c - self.z * s, self.z * c + self.y * s
end

function Vector:RotateY(phi)
        local c, s = m.cos(phi), m.sin(phi)
        self.x, self.z = self.x * c + self.z * s, self.z * c - self.x * s
end

function Vector:RotateZ(phi)
        local c, s = m.cos(phi), m.sin(phi)
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

function Vector:Polar()
        if math.close(self.x, 0, 0) then
                if self.z or self.y > 0 then
                        return 90
                elseif self.z or self.y < 0 then
                        return 270
                else
                        return 0
                end
        else
                local theta = m.deg(m.atan((self.z or self.y) / self.x))

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

function Vector:To2D()
        local v = self:Clone()
        local v2D = WorldToScreen(v.x, v.y, v.z)
        return Vector(v2D.x, v2D.y)
end

--[[
  ____             _ _
 / ___| _ __   ___| | |
 \___ \| '_ \ / _ \ | |
  ___) | |_) |  __/ | |
 |____/| .__/ \___|_|_|
       |_|
--]]

local Spell = classInstance()

function Spell:__init(slot, range)
        self.slot = slot
        self.range = range
end

function Spell:IsReady()
        return CanCast(self.slot)
end

function Spell:SetSkillShot(delay, speed, width, collision)
        self.delay = delay or 0.25
        self.speed = speed or 0
        self.width = width or 0
        self.collision = collision or false
        self.isSkillshot = true
end

function Spell:SetTargetted(delay, speed)
        self.delay = delay or 0.25
        self.speed = speed or 0
        self.isTargetted = true
end

function Spell:SetActive(delay)
        self.delay = delay or 0
        self.isActive = true
end

function Spell:VPGetLineCastPosition(target, delay, speed)
        local distance = GetDistance(GetOrigin(target))
        local time = delay + distance / speed
        local realDistance = (time * GetMoveSpeed(target))
        if realDistance == 0 then return distance end
        return realDistance
end

function Spell:GetCollision(target, width, range, distance)
        local predPos = GetPredictionPos(target)
        local myHeroPos = GetOrigin(myHero)
        local targetPos = GetOrigin(target)

        local count = 0

        if predPos.x ~= 0 and predPos.z ~= 0 then
                count = CountObjectCollision(0, target, myHeroPos.x, myHeroPos.z, predPos.x, predPos.z, width, range, 10)
        else
                count = CountObjectCollision(0, target, myHeroPos.x, myHeroPos.z, targetPos.x, targetPos.z, width, range, 10)
        end

        if count == 0 then
                return false
        end

        return true
end

function Spell:Cast(target)
        if self.isSkillshot then
                local distance = self:VPGetLineCastPosition(target, self.delay, self.speed)

                if distance > 0 and distance < self.range then
                        if self.collision then
                                if not self:GetCollision(target, self.width, self.range, distance) then
                                        CastSpellToPredictionPos(target, self.slot, distance)
                                end
                        else
                                CastSpellToPredictionPos(target, self.slot, distance)
                        end
                end
        elseif self.isTargetted then
                CastSpellTarget(target, self.slot)
        elseif self.isActive then
                CastSpellTarget(myHero.Addr, self.slot)
        end
end

--[[
  ____
 |  _ \ _ __ __ ___      __
 | | | | '__/ _` \ \ /\ / /
 | |_| | | | (_| |\ V  V /
 |____/|_|  \__,_| \_/\_/

--]]

local Draw = classInstance()

local function DrawLines(t, c)
        for i = 1, #t - 1 do
                if t[i].x > 0 and t[i].y > 0 and t[i+1].x > 0 and t[i+1].y > 0 then
                        DrawLineD3DX(t[i].x, t[i].y, t[i + 1].x, t[i + 1].y, c)
                end
        end
end

function Draw:Circle2D(x, y, radius, quality, color)
        local quality, radius = quality and 2 * m.pi / quality or 2 * m.pi / 20, radius or 50
        local points = {}

        for theta = 0, 2 * m.pi + quality, quality do
                points[#points + 1] = Vector(x + radius * m.cos(theta), y - radius * m.sin(theta))
        end

        DrawLines(points, color or Lua_ARGB(255, 255, 255, 255))
end

function Draw:Circle3D(x, y, z, radius, quality, color)
        local radius = radius or 300
        local quality = quality and 2 * m.pi / quality or 2 * m.pi / (radius / 5)
        local points = {}

        for theta = 0, 2 * m.pi + quality, quality do
                local c = WorldToScreen(Vector(x + radius * m.cos(theta), y, z - radius * m.sin(theta)))
                points[#points + 1] = Vector(c.x, c.y)
        end

        DrawLines(points, color or Lua_ARGB(255, 255, 255, 255))
end

function Draw:Line3D(x, y, z, a, b, c, color)
        local p1 = WorldToScreen(x, y, z)
        local p2 = WorldToScreen(a, b, c)
        DrawLineD3DX(p1.x, p1.y, p2.x, p2.y, color or Lua_ARGB(255, 255, 255, 255))
end

--[[
  ____
 |  _ \ _ __ __ ___   _____ _ __
 | | | | '__/ _` \ \ / / _ \ '_ \
 | |_| | | | (_| |\ V /  __/ | | |
 |____/|_|  \__,_| \_/ \___|_| |_|

--]]

Draven = classInstance()

function Draven:__init()
        self.Axes = {}

        self.Q = Spell(_Q, GetTrueAttackRange())
        self.Q:SetActive()
        self.W = Spell(_W, 0)
        self.W:SetActive()
        self.E = Spell(_E, 1050)
        self.E:SetSkillShot(0.25, 1400, 130, false)
        self.R = Spell(_R, 15000)
        self.R:SetSkillShot(0.4, 2000, 160, false)

        Callback.Add("Update", function(...) self:OnUpdate(...) end)
        Callback.Add("Draw", function(...) self:OnDraw(...) end)
        Callback.Add("CreateObject", function(...) self:OnCreateObject(...) end)
        Callback.Add("DeleteObject", function(...) self:OnDeleteObject(...) end)

        DelayAction(function() print("Draven Loaded! (v1.0)") end, 1)
end

function Draven:BestAxe()
        local BestAxe = nil
        local distance = 0

        for i, Axe in pairs(self.Axes) do
                if Axe then
                        local axePos = GetOrigin(Axe)

                        if GetDistance(GetMousePos()) <= 750 and distance < GetDistance(axePos) then
                                BestAxe = Axe
                                distance = GetDistance(axePos)
                        end
                end
        end

        return BestAxe
end

function Draven:Orbwalk(target)
        if target then
                local attackRange = GetTrueAttackRange()

                if GetDistance(GetOrigin(target)) <= attackRange and IsValidTarget(target, attackRange) then
                        if CanAttack() then
                                BasicAttack(target)
                        end

                        if CanMove() and not CanAttack() then
                                if self:BestAxe() then
                                        local axe = Vector(GetOrigin(self:BestAxe()))
										MoveToPos(axe.x, axe.z)
                                else
                                        MoveToPos(GetMousePos().x, GetMousePos().z)
                                end
                        end
                else
                        if CanMove() then
                                if self:BestAxe() then
                                        local axe = Vector(GetOrigin(self:BestAxe()))
                                        MoveToPos(axe.x, axe.z)
                                else
                                        MoveToPos(GetMousePos().x, GetMousePos().z)
                                end
                        end
                end
        end
end

function Draven:LaneClear()
        if CountEnemyMinionAroundObject(myHero.Addr, GetTrueAttackRange()) > 0 and GetPercentMP(myHero.Addr) >= LaneClearUseMana then
                if self.Q:IsReady() and GetBuffCount(myHero.Addr, "DravenSpinningAttack") < 2 then
                        self.Q:Cast()
                end

                if CanMove() and not CanAttack() then
                        if self:BestAxe() then
                                SetLuaMoveOnly(true)
                                local axe = Vector(GetOrigin(self:BestAxe()))
                                MoveToPos(axe.x, axe.z)
								DelayAction(function() local i = 1 end, GetDistance(GetOrigin(axe)) / GetMoveSpeed(myHero.Addr))
                        else
                                --SetLuaMoveOnly(false)
                                MoveToPos(GetMousePos().x, GetMousePos().z)
                        end
                end
        end
end

function Draven:Combo(target)
        if target ~= 0 then
                if self.Q:IsReady() and IsValidTarget(target, GetTrueAttackRange()) and GetBuffCount(myHero.Addr, "DravenSpinningAttack") < 2 then
                        self.Q:Cast()
                end

                if self.W:IsReady() and IsValidTarget(target, GetTrueAttackRange()) and GetBuffCount(myHero.Addr, "dravenfurybuff") < 1 then
                        self.W:Cast()
                end

                if self.E:IsReady() and IsValidTarget(target, self.E.range) then
                        self.E:Cast(target)
                end

				if self.R:IsReady() and IsValidTarget(target, 2000) and getDmg(_R, target) * 2 > GetHealthPoint(target) and CanMove() then
					self.R:Cast(target)
				end
        end
end

function getDmg(Spell, Enemy)
	local Damage = 0

	if Spell == _R then
		if GetSpellLevel(myHero.Addr,_R) == 0 then return 0 end

		local DamageSpellRTable = {175, 275, 375}

		local Percent_Bonus_AD = 1

		local Damage_Bonus_AD = GetFlatPhysicalDamage(myHero.Addr)

		local DamageSpellR = DamageSpellRTable[GetSpellLevel(myHero.Addr,_R)]

		local Enemy_Armor = GetArmor(Enemy)

		local Dominik_ID = 3036--Lord Dominik's Regards
		local Mortal_Reminder_ID = 3033--Mortal Reminder

		if GetItemByID(Dominik_ID) > 0 or GetItemByID(Mortal_Reminder_ID) > 0 then
			Enemy_Armor = Enemy_Armor - GetBonusArmor(Enemy) * 45/100
		end

		local ArmorPenetration = 60 * GetArmorPenetration(myHero.Addr) / 100 + (1 - 60/100) * GetArmorPenetration(myHero.Addr) * GetLevel(Enemy) / 18

		Enemy_Armor = Enemy_Armor - ArmorPenetration

		if Enemy_Armor >= 0 then
			Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (100/(100 + Enemy_Armor))
		else
			Damage = (DamageSpellR + Percent_Bonus_AD * Damage_Bonus_AD) * (2 - 100/(100 - Enemy_Armor))
		end

		return Damage
	end

end

function Draven:OnUpdate()
        local nKeyCode = GetKeyCode()
        local target = GetEnemyChampCanKillFastest(1800)
		myHero = GetMyHero()

        if nKeyCode == comboKey then

				SetLuaCombo(true)
                SetLuaBasicAttackOnly(true)
                SetLuaMoveOnly(true)

                self:Orbwalk(target)
                self:Combo(target)


        end
                SetLuaCombo(false)
                SetLuaBasicAttackOnly(false)
                SetLuaMoveOnly(false)


        if nKeyCode == laneClearKey then
                SetLuaLaneClear(true)
				self:LaneClear()
        end
                SetLuaLaneClear(false)
                SetLuaMoveOnly(false)

end

function Draven:OnDraw()
        for i, Axe in pairs(self.Axes) do
                local axeVector = Vector(GetOrigin(Axe))
                local color = GetDistance(axeVector) <= 100 and Lua_ARGB(255, 255, 0, 0) or Lua_ARGB(255, 255, 255, 255)

                if axeVector and not IsDead(Axe) then
                        --Draw:Circle3D(axeVector.x, axeVector.y, axeVector.z, 100, 10, color)
                end
        end

        if self:BestAxe() then
                local axe = Vector(GetOrigin(self:BestAxe()))
                --Draw:Line3D(myHero.x, myHero.y, myHero.z, axe.x, axe.y, axe.z, Lua_ARGB(255, 255, 255, 0))
        end

        --Draw:Circle3D(GetMousePos().x, GetMousePos().y, GetMousePos().z, 750, 20, Lua_ARGB(100, 255, 255, 255))
end

function Draven:OnCreateObject(obj)
        if string.find(GetObjName(obj), "reticle_self") and not IsDead(obj) then
                self.Axes[#self.Axes + 1] = obj
        end
end

function Draven:OnDeleteObject(obj)
        for i, Axe in pairs(self.Axes) do
                if Axe == obj then
                        table.remove(self.Axes, i)
                end
        end
end

--[[
      _
     | | __ _ _   _  ___ ___
  _  | |/ _` | | | |/ __/ _ \
 | |_| | (_| | |_| | (_|  __/
  \___/ \__,_|\__, |\___\___|
              |___/
--]]

Jayce = classInstance()

function Jayce:__init()
        self.Spells = {
                ["Range"] = {
                        [_Q] = { CD = GetCDSpell(myHero.Addr, _Q) == 0 and 8 or GetCDSpell(myHero.Addr, _Q), CDT = 0, T = 0, Name = "JayceShockBlast", Status = false, Range = 1150, RangeExt = 1750, Speed = 1300, SpeedExt = 2350, Delay = 0.15, Width = 70 },
                        [_W] = { CD = GetCDSpell(myHero.Addr, _W) == 0 and 13 or GetCDSpell(myHero.Addr, _W), CDT = 0, T = 0, Name = "JayceHyperCharge", Status = false },
                        [_E] = { CD = GetCDSpell(myHero.Addr, _E) == 0 and 16 or GetCDSpell(myHero.Addr, _E), CDT = 0, T = 0, Name = "JayceAccelerationGate", Status = false },
                        [_R] = { CD = GetCDSpell(myHero.Addr, _R) == 0 and 6 or GetCDSpell(myHero.Addr, _R), CDT = 0, T = 0, Name = "JayceStanceGtH", Status = false }
                },
                ["Melee"] = {
                        [_Q] = { CD = GetCDSpell(myHero.Addr, _Q) == 0 and 16 or GetCDSpell(myHero.Addr, _Q), CDT = 0, T = 0, Name = "JayceToTheSkies", Status = false, Range = 600 },
                        [_W] = { CD = GetCDSpell(myHero.Addr, _W) == 0 and 10 or GetCDSpell(myHero.Addr, _W), CDT = 0, T = 0, Name = "JayceStaticField", Status = false, Range = 350 },
                        [_E] = { CD = GetCDSpell(myHero.Addr, _E) == 0 and 15 or GetCDSpell(myHero.Addr, _E), CDT = 0, T = 0, Name = "JayceThunderingBlow", Status = false, Range = 250 },
                        [_R] = { CD = GetCDSpell(myHero.Addr, _R) == 0 and 6 or GetCDSpell(myHero.Addr, _R), CDT = 0, T = 0, Name = "JayceStanceHtG", Status = false }
                }
        }

        Callback.Add("Update", function(...) self:OnUpdate(...) end)
        Callback.Add("Draw", function(...) self:OnDraw(...) end)
        Callback.Add("ProcessSpell", function(...) self:OnProcessSpell(...) end)

        DelayAction(function() print("Jayce Loaded! (v1.0)") end, 1)
end

function Jayce:CD()
        for i = 0, 3, 1 do
                self.Spells.Range[i].T = self.Spells.Range[i].CDT + self.Spells.Range[i].CD - GetTimeGame()
                self.Spells.Melee[i].T = self.Spells.Melee[i].CDT + self.Spells.Melee[i].CD - GetTimeGame()

                if self.Spells.Range[i].T <= 0 and GetSpellLevel(myHero.Addr, i) > 0 then
                        self.Spells.Range[i].Status = true
                        self.Spells.Range[i].T = 0
                else
                        self.Spells.Range[i].Status = false
                end

                if self.Spells.Melee[i].T <= 0 and GetSpellLevel(myHero.Addr, i) > 0 then
                        self.Spells.Melee[i].Status = true
                        self.Spells.Melee[i].T = 0
                else
                        self.Spells.Melee[i].Status = false
                end
        end
end

function Jayce:IsMelee()
        return GetSpellNameByIndex(myHero.Addr, _Q) ~= "JayceShockBlast"
end

function Jayce:Orbwalk(target)
        if target then
                local attackRange = GetTrueAttackRange()

                if GetDistance(GetOrigin(target)) <= attackRange and IsValidTarget(target, attackRange) then
                        if CanAttack() then
                                BasicAttack(target)
                        end

                        if CanMove() and not CanAttack() then
                                MoveToPos(GetMousePos().x, GetMousePos().z)
                        end
                else
                        if CanMove() then
                                MoveToPos(GetMousePos().x, GetMousePos().z)
                        end
                end
        end
end

function Jayce:Combo(target)
        if target ~= 0 then
                if not self:IsMelee() then
                        if CanCast(_Q) and IsValidTarget(target, self.Spells.Range[_Q].RangeExt) then
                                if CanCast(_E) then
                                        local distance = VPGetLineCastPosition(target, self.Spells.Range[_Q].Delay, self.Spells.Range[_Q].SpeedExt)

                                        if distance > 0 and distance < self.Spells.Range[_Q].RangeExt then
                                                if not GetCollision(target, self.Spells.Range[_Q].Width, self.Spells.Range[_Q].RangeExt, distance) then
                                                        CastSpellToPredictionPos(target, _Q, distance)
                                                end
                                        end
                                else
                                        local distance = VPGetLineCastPosition(target, self.Spells.Range[_Q].Delay, self.Spells.Range[_Q].Speed)

                                        if distance > 0 and distance < self.Spells.Range[_Q].Range then
                                                if not GetCollision(target, self.Spells.Range[_Q].Width, self.Spells.Range[_Q].Range, distance) then
                                                        CastSpellToPredictionPos(target, _Q, distance)
                                                end
                                        end
                                end
                        end

                        if CanCast(_W) and IsValidTarget(target, GetTrueAttackRange() + 150) then
                                CastSpellTarget(myHero.Addr, _W)
                        end

                        if CanCast(_R) and not CanCast(_Q) and not CanCast(_W) and self.Spells.Melee[_Q].Status == true and GetDistance(GetOrigin(target)) <= self.Spells.Melee[_Q].Range then
                                CastSpellTarget(myHero.Addr, _R)
                        end
                else
                        if CanCast(_Q) and IsValidTarget(target, self.Spells.Melee[_Q].Range) then
                                CastSpellTarget(target, _Q)
                        end

                        if CanCast(_W) and IsValidTarget(target, self.Spells.Melee[_W].Range) then
                                CastSpellTarget(myHero.Addr, _W)
                        end

                        if CanCast(_E) and IsValidTarget(target, self.Spells.Melee[_E].Range) and GetBuffCount(myHero.Addr, "JayceHyperCharge") < 1 then
                                CastSpellTarget(target, _E)
                        end

                        if CanCast(_R) then
                                if not CanCast(_Q) and not CanCast(_W) and self.Spells.Range[_Q].Status == true and (self.Spells.Range[_W].Status == true or self.Spells.Range[_E].Status == true) then
                                        CastSpellTarget(myHero.Addr, _R)
                                end

                                if not CanCast(_Q) and not CanCast(_W) and not CanCast(_E) then
                                        CastSpellTarget(myHero.Addr, _R)
                                end
                        end
                end
        end
end

function Jayce:CountMinionsHitQ(pos)
        local n = 0

        GetAllUnitAroundAnObject(myHero.Addr, self.Spells.Range[_Q].Range)
        local Enemies = pUnit

        for i, minion in ipairs(Enemies) do
                if minion ~= 0 and IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 and GetDistance(GetOrigin(minion), GetOrigin(pos)) < self.Spells.Range[_Q].Width then
                        n = n +1
                end
        end

        return n
end

function Jayce:GetBestQPositionFarm()
        local MaxQ = 0
        local MaxQPos

        GetAllUnitAroundAnObject(myHero.Addr, self.Spells.Range[_Q].Range)
        local Enemies = pUnit

        for i, minion in pairs(Enemies) do
                if minion ~= 0 and IsMinion(minion) and IsEnemy(minion) and not IsDead(minion) and not IsInFog(minion) and GetTargetableToTeam(minion) == 4 then
                        local hitQ = self:CountMinionsHitQ(minion)
                        if hitQ ~= nil and hitQ > MaxQ or MaxQPos == nil then
                                MaxQPos = minion
                                MaxQ = hitQ
                        end
                end
        end

        if MaxQPos then
                return MaxQPos
        else
                return nil
        end
end

function Jayce:FarmQ()
        GetAllUnitAroundAnObject(myHero.Addr, self.Spells.Range[_Q].Range)
        local Enemies = pUnit

        if CanCast(_Q) and table.getn(Enemies) > 0 and CanMove() then
                local QPos = self:GetBestQPositionFarm()
                if QPos then
                        if not self:IsMelee() then
                                self:QEFarm(QPos)
                        else
                                CastSpellTarget(QPos, _Q)
                        end
                end
        end
end

function Jayce:QEFarm(pos)
        if CanCast(_Q) and GetDistance(GetOrigin(pos)) <= self.Spells.Range[_Q].RangeExt then
                if CanCast(_E) then
                        local distance = VPGetLineCastPosition(pos, self.Spells.Range[_Q].Delay, self.Spells.Range[_Q].SpeedExt)

                        if distance > 0 and distance < self.Spells.Range[_Q].RangeExt then
                                 if not GetCollision(pos, self.Spells.Range[_Q].Width, self.Spells.Range[_Q].RangeExt, distance) then
                                        CastSpellToPredictionPos(pos, _Q, distance)
                                end
                        end
                else
                        local distance = VPGetLineCastPosition(pos, self.Spells.Range[_Q].Delay, self.Spells.Range[_Q].Speed)

                        if distance > 0 and distance < self.Spells.Range[_Q].Range then
                                if not GetCollision(pos, self.Spells.Range[_Q].Width, self.Spells.Range[_Q].Range, distance) then
                                        CastSpellToPredictionPos(pos, _Q, distance)
                                end
                        end
                end
        end
end

function Jayce:LaneClear()
        if CanCast(_Q) and GetPercentMP(myHero.Addr) >= LaneClearUseMana then
                self:FarmQ()
        end
end

function Jayce:OnUpdate()
		myHero = GetMyHero()
        self:CD()

        local nKeyCode = GetKeyCode()
        local target = GetEnemyChampCanKillFastest(1800)

        if nKeyCode == comboKey then
                self:Orbwalk(target)
                self:Combo(target)
                SetLuaCombo(true)
                SetLuaBasicAttackOnly(true)
                SetLuaMoveOnly(true)
        else
                SetLuaCombo(false)
                SetLuaBasicAttackOnly(false)
                SetLuaMoveOnly(false)
        end

        if nKeyCode == laneClearKey then
                self:LaneClear()
        end
end

function Jayce:OnDraw()
        local pos = WorldToScreen(myHero.x, myHero.y, myHero.z)

        if self:IsMelee() then
                for i = 0, 3, 1 do
                        local slot = ({ [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R" })[i]
                        local color = self.Spells.Range[i].Status == true and Lua_ARGB(255, 0, 255, 10) or Lua_ARGB(255, 255, 0, 0)
                        --DrawTextD3DX(pos.x - 60 + (i * 40), pos.y + 50, slot .. ": " .. tostring(math.round(self.Spells.Range[i].T > 0 and self.Spells.Range[i].T or 0)), color)
                end
        else
                for i = 0, 3, 1 do
                        local slot = ({ [_Q] = "Q", [_W] = "W", [_E] = "E", [_R] = "R" })[i]
                        local color = self.Spells.Melee[i].Status == true and Lua_ARGB(255, 0, 255, 10) or Lua_ARGB(255, 255, 0, 0)
                        --DrawTextD3DX(pos.x - 60 + (i * 40), pos.y + 50, slot .. ": " .. tostring(math.round(self.Spells.Melee[i].T > 0 and self.Spells.Melee[i].T or 0)), color)
                end
        end
end

function Jayce:OnProcessSpell(unit, spell)
        if unit == myHero.Addr then
                for i = 0, 3, 1 do
                        if spell.name == self.Spells.Range[i].Name then
                                self.Spells.Range[i].CDT = GetTimeGame()
                        end
                end

                for i = 0, 3, 1 do
                        if spell.name == self.Spells.Melee[i].Name then
                                self.Spells.Melee[i].CDT = GetTimeGame()
                        end
                end

                local nKeyCode = GetKeyCode()

                if nKeyCode == comboKey or nKeyCode == laneClearKey then
                        if spell.name == "JayceShockBlast" then
                                local gatePos = Vector(myHero.x, myHero.y, myHero.z):Extended(spell.endPos, 300 + (GetPing()/2))
                                if gatePos then
                                        if CanCast(_E) then
                                                DelayAction(function() CastSpellToPos(gatePos.x, gatePos.z, _E) end, spell.delay + (GetPing()/2))
                                        end
                                end
                        end
                end
        end
end

--[[
  _                    _
 | |    ___   __ _  __| |
 | |   / _ \ / _` |/ _` |
 | |__| (_) | (_| | (_| |
 |_____\___/ \__,_|\__,_|

--]]

Callback.Add("Load", function()
        if _G[GetChampName(myHero.Addr)] then
              _G[GetChampName(myHero.Addr)]()
        end
end)

Callback.Add("UpdateBuff", function(unit, buff)
        --print(GetBuffName(buff))
end)
