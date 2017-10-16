--IncludeFile("player.lua")

function UpdateHeroInfo()
	return GetMyChamp()
end

IncludeFile("kogmaw.lua")
IncludeFile("xayah.lua")



function sleep(s)						 -- s=second
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end


__PrintDebug("Injected")

while(true)
do

	local bIsEndLua = IsEndLua()
	
	if bIsEndLua == 1 then
		__PrintDebug("========>bIsEndLua: " .. tostring(bIsEndLua))
		break
	end



	OnTick()
	sleep(0.01)

end
