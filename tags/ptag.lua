local ptag = {}
local template = require("template")

function ptag.render(node,style,renderer)
    x = renderer.cursorX
    y = renderer.cursorY

    local fontsize   = tonumber(style.fontsize) or 16
    local height     = tonumber(style.height) or (fontsize+4)
    local text = template.render(renderer.context,node:getcontent() or "")
    local spaceValue = 5
    local width = tonumber(style.width) or love.graphics.getFont():getWidth(text)+(spaceValue*2)
    font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    
    love.graphics.setColor(style.color)
    love.graphics.printf(text, x, y + (height/2 - fontsize/2), width, "center")

    --konum güncelleme
    renderer.cursorY = renderer.cursorY + renderer.spacing;
    renderer.cursorX = 0
    renderer.spacing = height;

end

return ptag