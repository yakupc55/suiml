local renderer = require("renderer")
local focus = require("focus")
local router = require("router")
local loader = require("loader")
local __functions = require("functions.functionList")
local template = require("template")
FOCUS_MODE=true
__targetFPS = 60
local __sleepTime 
local __lastTime = love.timer.getTime()
math.randomseed(os.time())

function indexlist(count, start, step)
    local t = {}
    start = start or 1
    step  = step or 1
    for i = 0, count-1 do
        t[#t+1] = start + i * step 
    end
    return t
end
function love.load()
    love.timer.step()
    windowWidth, windowHeight = 720, 720
    -- Pencereyi belirtilen boyutta açmak için setMode kullanılır
    love.window.setMode(windowWidth, windowHeight)
    renderer.init()
    loader.loadAll()
    print("fps : ",__targetFPS )
end
function resetValues()
renderer.resetValues()
end
function love.draw()
    local __currentTime = love.timer.getTime()
    -- print("---start---")
    resetValues()
    focus.reset()
    local currentArea = router.getCurrent()
    if currentArea then
        renderer.resetValues()
        renderer.renderArea(currentArea)
    else
        love.graphics.print("No area loaded!")
    end
    local __elapsedTime = __currentTime - __lastTime
    __lastTime = love.timer.getTime()
    __sleepTime = (1 / __targetFPS)
    if __elapsedTime>__sleepTime then __sleepTime = 0 else __sleepTime = __sleepTime-__elapsedTime end
    love.timer.sleep(__sleepTime)
    -- print(__sleepTime)
end

function love.keypressed(key)
    local router = require("router")
    router.handleKey(key)

    -- opsiyonel focus navigation
    local focus = require("focus")
    if (key == "s" or key == "down") and FOCUS_MODE then focus.next() 
    elseif (key == "w" or key == "up") and FOCUS_MODE then focus.prev() 
    elseif key == "z" and FOCUS_MODE then
        -- print("z key")
        local current = focus.getCurrent()
        if current and current.name == "button" then
            -- print("yes")
            if current.attributes["goto"] then router.goto(current.attributes["goto"]) end
            if current.attributes["onclick"] then
                local code = current.attributes["onclick"]
                 load(code )() 
                 end
        end
    elseif key=="return" then
        FOCUS_MODE = (not FOCUS_MODE)
        if not FOCUS_MODE then
            focus.index = 0
        end
    elseif key == "escape" then
        love.event.quit()
    end
end
