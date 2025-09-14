local buttontag = {}
local focus = require("focus")
local template = require("template")
function buttontag.render(node,style,renderer)
    x = renderer.cursorX
    y = renderer.cursorY

    local fontsize   = tonumber(style.fontsize) or 16
    local height     = tonumber(style.height) or (fontsize+4)
    local radius     = tonumber(style.radius) or 5

    local text = template.render(renderer.context,node:getcontent() or "")
    local spaceValue = 5
    local width = tonumber(style.width) or love.graphics.getFont():getWidth(text)+(spaceValue*2)
    font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    
    
    node.focusable = true
    focus.register(node)
    local current = focus.getCurrent()
    if current == node then
        love.graphics.setColor(0.2,0.2,1,0.2)
        love.graphics.rectangle("fill", x, y, width, height, radius, radius)
    else
        love.graphics.setColor(style.backcolor)
        love.graphics.rectangle("fill", x, y, width, height, radius, radius)
    end

    love.graphics.setColor(style.color)
    love.graphics.printf(text, x, y + (height/2 - fontsize/2), width, "center")


    --konum güncelleme
    renderer.cursorX = renderer.cursorX + width
    renderer.spacing = math.max(renderer.spacing,height);
end

return buttontag