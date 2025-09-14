local renderer = require("renderer")
local focus = require("focus")
local router = require("router")
local loader = require("loader")
FOCUS_MODE=true

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
    renderer.init()
    loader.loadAll()
end
function resetValues()
renderer.resetValues()
end
function love.draw()
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
end

function love.keypressed(key)
    local router = require("router")
    router.handleKey(key)

    -- opsiyonel focus navigation
    local focus = require("focus")
    if (key == "s" or key == "down") and FOCUS_MODE then focus.next() 
    elseif (key == "w" or key == "up") and FOCUS_MODE then focus.prev() 
    elseif key == "z" and FOCUS_MODE then
        local current = focus.getCurrent()
        if current and current.tag == "button" then
            if current.goto then router.goto(current.goto) end
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
