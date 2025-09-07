local focus = require("focus")
local template = require("template")

local renderer = {}
local font

function renderer.init()
    font = love.graphics.newFont(16)
    love.graphics.setFont(font)
end

function renderer.renderNode(node, x, y)
    if node.tag == "button" then
        -- buton kutusu
        love.graphics.setColor(0.2, 0.2, 0.8)
        love.graphics.rectangle("fill", x, y, 200, 40, 5, 5)

        node.focusable = true
        focus.register(node)
        local current = focus.getCurrent()
        if current == node then
            love.graphics.setColor(0.2, 0.2, 1.0, 0.2)
            love.graphics.rectangle("fill", x, y, 200, 40, 5, 5)
        end

        -- text (template desteği)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf(template.render(node.text or ""), x, y+12, 200, "center")

        return y + 50

    elseif node.tag == "p" then
        love.graphics.setColor(1, 1, 1)
        love.graphics.print(template.render(node.text or ""), x, y)
        return y + 25

    elseif node.tag == "area" then
        for _, child in ipairs(node.children) do
            y = renderer.renderNode(child, x, y)
        end
        return y
    end

    return y
end

return renderer
