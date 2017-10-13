IncludeFile("KogMawRework.lua")

function sleep(s)						 -- s=second
  local ntime = os.clock() + s
  repeat until os.clock() > ntime
end

__PrintTextGame("--Injected .Lua --")
__PrintTextGame("--Finish HotKey : END key --")


while(true)
do
	bIsEndLua = IsEndLua()
	if bIsEndLua == 1 then
		__PrintTextGame("--Finished .Lua --")
		break
	end

	OnTick()
	sleep(0.001)
end
