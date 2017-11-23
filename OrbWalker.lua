--[[

Reference link https://pastebin.com/jufCeE0e

Thanks

]]

local SpaceKeyCode = 32
local CKeyCode = 67
local VKeyCode = 86


local Ping = 0

local LastAATick = 0

local IsCastingInterruptSpell = false -- R Misfortune


local ResetAASpell = {
	["asheq"] = {},
	["garenq"] = {},
	["dariusnoxiantacticsonh"] = {},
	["jaycehypercharge"] = {},
	["luciane"] = {},
	["mordekaisermaceofspades"] = {},
	["nautiluspiercinggaze"] = {},
	["gangplankqwrapper"] = {},
	["renektonpreexecute"] = {},
	["shyvanadoubleattack"] = {},
	["takedown"] = {},
	["trundletrollsmash"] = {},
	["reksaiq"] = {},
	["xenzhaocombotarget"] = {},
	["itemtitanichydracleave"] = {},
	["illaoiw"] = {},
	["meditate"] = {},
	["camilleq"] = {},
	["vorpalspikes"] = {},
	["hecarimrapidslash"] = {},
	["fiorae"] = {},
	["gravesmove"] = {},
	["jaxempowertwo"] = {},
	["leonashieldofdaybreak"] = {},
	["monkeykingdoubleattack"] = {},
	["nasusq"] = {},
	["netherblade"] = {},
	["powerfist"] = {},
	["rengarq"] = {},
	["sivirw"] = {},
	["talonnoxiandiplomacy"] = {},
	["vaynetumble"] = {},
	["volibearq"] = {},
	["yorickspectral"] = {},
	["masochism"] = {},
	["elisespiderw"] = {},
	["sejuaninorthernwinds"] = {},
	["camilleq2"] = {},
	["vie"] = {},

}

local NotAttackSpell = {
	["volleyattack"] = {},
	["jarvanivcataclysmattack"] = {},
	["shyvanadoubleattack"] = {},
	["zyragraspingplantattack"] = {},
	["zyragraspingplantattackfire"] = {},
	["asheqattacknoonhit"] = {},
	["heimertyellowbasicattack"] = {},
	["heimertbluebasicattack"] = {},
	["annietibbersbasicattack"] = {},
	["yorickdecayedghoulbasicattack"] = {},
	["yorickspectralghoulbasicattack"] = {},
	["malzaharvoidlingbasicattack2"] = {},
	["kindredwolfbasicattack"] = {},
	["volleyattackwithsound"] = {},
	["monkeykingdoubleattack"] = {},
	["shyvanadoubleattackdragon"] = {},
	["zyragraspingplantattack2"] = {},
	["zyragraspingplantattack2fire"] = {},
	["elisespiderlingbasicattack"] = {},
	["heimertyellowbasicattack2"] = {},
	["gravesautoattackrecoil"] = {},
	["annietibbersbasicattack2"] = {},
	["yorickravenousghoulbasicattack"] = {},
	["malzaharvoidlingbasicattack"] = {},
	["malzaharvoidlingbasicattack3"] = {},

}

local SpellAttack = {
	["caitlynheadshotmissile"] = {},
	["garenslash2"] = {},
	["masteryidoublestrike"] = {},
	["renektonexecute"] = {},
	["rengarnewpassivebuffdash"] = {},
	["xenzhaothrust"] = {},
	["xenzhaothrust3"] = {},
	["lucianpassiveshot"] = {},
	["frostarrow"] = {},
	["kennenmegaproc"] = {},
	["quinnwenhanced"] = {},
	["renektonsuperexecute"] = {},
	["trundleq"] = {},
	["xenzhaothrust2"] = {},
	["viktorqbuff"] = {},

}


--local LastAttackCommandT = 0
--local LastMoveCommandT = 0


function UpdateHeroInfo()
	return GetMyChamp()
end


function OnLoad()
	--__PrintTextGame("Orbwalker v1.0 loaded")
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
	if unit == UpdateHeroInfo() then
		if (string.find(string.lower(GetName_Casting(spell)), "attack") ~= nil and not NotAttackSpell[string.lower(GetName_Casting(spell))]) or SpellAttack[string.lower(GetName_Casting(spell))] then
			Ping = GetLatency()
			LastAATick = GetTimeGame() - Ping/2000
		end

		if ResetAASpell[string.lower(GetName_Casting(spell))] then
			LastAATick = 0
		end

	end
end


function OnCreateObject(unit)
end

function OnDeleteObject(unit)
end

function GetTargetRange(range)
	return GetEnemyChampCanKillFastest(range)
end

function ValidTarget(Target)
	if Target ~= 0 then
		if not IsDead(Target) and not IsInFog(Target) and GetTargetableToTeam(Target) == 4 and IsEnemy(Target) then
			return true
		end
	end
	return false
end


function OnTick()

	if IsDead(UpdateHeroInfo()) then return end

	local nKeyCode = GetKeyCode()

	if nKeyCode == SpaceKeyCode then
		Orbwalker()
	end
end

function Orbwalker()
	--SetLuaCombo(true)
	SetLuaBasicAttackOnly(true)
	SetLuaMoveOnly(true)

	if IsCastingInterruptSpell then return end

	local range = GetAttackRange(UpdateHeroInfo())
	if range < 300 then range = 400 end
	range = range + 115
	local Target = GetTargetRange(range)

	if Target ~= 0 and ValidTarget(Target) and CanAttackLua() then
		BasicAttack(Target)

		--LastAttackCommandT = GetTimeGame()
		--LastMoveCommandT = 0

		return
	end

	if CanMoveLua() then
		local x,z = GetCursorPosX(), GetCursorPosZ()
		MoveToPos(x,z)
		--LastMoveCommandT = GetTimeGame()
	end


end

function CanMoveLua()
	Ping = GetLatency()
	return (GetTimeGame() + Ping/2000 >= LastAATick + GetWindupBA(UpdateHeroInfo()) + 0.08)
end


function CanAttackLua()
	Ping = GetLatency()
	return (GetTimeGame() + Ping/2000 + 0.1 >= LastAATick + GetCDBA(UpdateHeroInfo()))
end
