local ptag = {}
local template = require("template")

function ptag.render(node,renderer)
    --renderer.cursorY = renderer.cursorY + renderer.spacing;
    x = renderer.cursorX
    y = renderer.cursorY

    local fontsize   = tonumber(node.style.fontsize) or 16
    local height     = tonumber(node.style.height) or (fontsize+4)
    local text = template.render(renderer.context,node:getcontent() or "")
    local spaceValue = 0
    local font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    local width = tonumber(node.style.width) or love.graphics.getFont():getWidth(text)+(spaceValue*2)
    
    love.graphics.setColor(node.style.color)
    love.graphics.printf(text, x, y , width, "center")

    --konum güncelleme
    renderer.spacing = height;
    renderer.cursorY = renderer.cursorY + renderer.spacing;
    renderer.cursorX = 0

end

return ptag