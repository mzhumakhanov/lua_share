package.cpath = getScriptPath() .. "/?.dll"
sh = require "lua_share"

exitflag = false

function main()
    local ns = sh.GetNameSpace("queues") -- get predefined "queues" namespace
    local i = 0
    while not exitflag do
        i = i + 1
        ns["queue1"] = i                   -- queue some payload
        sleep(100 + math.random(900))      -- 10 times per second or less
    end
end

function OnStop()
    exitflag = true
end