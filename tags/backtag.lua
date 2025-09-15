local ltag = {}
local focus = require("focus")
local template = require("template")
function ltag.render(node,renderer)
    print(node.attributes["style"])
    print("st len: ",#node.style)
    local w, h = love.graphics.getDimensions()
    -- print("dimensions : w: ",w," h:",h)
    if node.style.backcolor then
        print("background is goed")
        love.graphics.setColor(node.style.backcolor)
        love.graphics.rectangle("fill", 0, 0, w, h)
    end
end

return ltag