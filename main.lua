local renderer = require("renderer")
local focus = require("focus")
local router = require("router")
local loader = require("loader")

function love.load()
    renderer.init()
    loader.loadAll()
end

function love.draw()
    focus.reset()
    local currentArea = router.getCurrent()
    if currentArea then
        renderer.cursorX = 0
        renderer.cursorY = 0
        renderer.renderNode(currentArea)
    else
        love.graphics.print("No area loaded!")
    end
end

function love.keypressed(key)
    local router = require("router")
    router.handleKey(key)

    -- opsiyonel focus navigation
    local focus = require("focus")
    if key == "down" then focus.next() 
    elseif key == "up" then focus.prev() 
    elseif key == "return" or key == "a" then
        local current = focus.getCurrent()
        if current and current.tag == "button" then
            if current.goto then router.goto(current.goto) end
        end
    elseif key == "escape" then
        love.event.quit()
    end
end
