local buttontag = {}
local focus = require("focus")
local template = require("template")
function buttontag.render(node,renderer)
    x = renderer.cursorX
    y = renderer.cursorY

    local fontsize   = tonumber(node.style.fontsize) or 16
    local height     = tonumber(node.style.height) or (fontsize+4)
    local radius     = tonumber(node.style.radius) or 5

    local text = template.render(renderer.context,node:getcontent() or "")
    local spaceValue = 5
    local font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    local width = tonumber(node.style.width) or love.graphics.getFont():getWidth(text)+(spaceValue*2)
    
    
    node.focusable = true
    focus.register(node)
    local current = focus.getCurrent()
    if current == node then
        love.graphics.setColor(0,0,1,0.5)
        love.graphics.rectangle("fill", x, y, width, height, radius, radius)
    else
        love.graphics.setColor(node.style.backcolor)
        love.graphics.rectangle("fill", x, y, width, height, radius, radius)
    end

    love.graphics.setColor(node.style.color)
    love.graphics.printf(text, x, y + (height/2 - fontsize/2), width, "center")


    --konum güncelleme
    renderer.cursorX = renderer.cursorX + width
    renderer.spacing = math.max(renderer.spacing,height);
end

return buttontag