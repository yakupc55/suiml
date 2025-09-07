-- script.lua
local scriptSystem = {}
scriptSystem.events = {}

-- Global paylaşmak istediğimiz şeyleri ortamda tanıtıyoruz
function scriptSystem.run(code)
    local env = {
        scriptSystem = scriptSystem,
        print = print,
        renderer = renderer   -- <---- burada ekledik
    }
    setmetatable(env, {__index = _G})
    local func, err = load(code, "script", "t", env)
    if func then
        func()
    else
        print("Script hatası:", err)
    end
end

function scriptSystem.trigger(eventName, ...)
    local f = scriptSystem.events[eventName]
    if f then f(...) end
end

return scriptSystem
