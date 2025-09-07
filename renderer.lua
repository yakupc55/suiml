local focus = require("focus")
local template = require("template")
local style = require("style")
local colors = require("colors")
local renderer = {}
local font
renderer.cursorX = 0
renderer.cursorY = 0
spacing = 0

function renderer.init()
    font = love.graphics.newFont(16)
    love.graphics.setFont(font)
end


function renderer.renderNode(node)
    local s = style.parseStyle(node.attrs or {})

    -- renk ve backcolor
    if s.color then
        local col = colors.get(s.color)
        s.color = {col[1], col[2], col[3], 1}
    else
        s.color = {1,1,1,1}
    end

    if s.backcolor then
        local bg = colors.get(s.backcolor)
        s.backcolor = {bg[1], bg[2], bg[3], 1}
    else
        s.backcolor = {0,0,0,0}
    end

    -- boyut ve font
    local fontsize   = tonumber(s.fontsize) or 16
    local width      = tonumber(s.width) or 200
    local height     = tonumber(s.height) or (fontsize+4)
    local radius     = tonumber(s.radius) or 5
    
    font = love.graphics.newFont(fontsize)
    love.graphics.setFont(font)
    
    local x, y
    --print(node.tag,renderer.cursorX,renderer.cursorY,x,y)
    -- bazı özel node’lar alt satıra geçer
    if node.tag == "area" then
        x = 0
        y = 0
        renderer.cursorX = 0
        renderer.cursorY = 0
    elseif node.tag == "p" or node.tag == "br" then
        -- alt satıra geç ve node boyutunu dikkate al
        renderer.cursorY = renderer.cursorY + spacing;
        renderer.cursorX = 0
        x = renderer.cursorX
        y = renderer.cursorY
        renderer.cursorY = renderer.cursorY + height;
        spacing = 0;
        --renderer.cursorX = width + spacing
        --lineHeight = height

    else
        -- normal node: x yönünde sırala
        x = renderer.cursorX
        y = renderer.cursorY
        renderer.cursorX = renderer.cursorX + width + spacing
        spacing = height;
        --lineHeight = math.max(lineHeight, height)
    end
    --print(node.tag,renderer.cursorX,renderer.cursorY,x,y)
    -- node çizimi
    if node.tag == "button" then
        --print(x,y)
        love.graphics.setColor(s.backcolor)
        love.graphics.rectangle("fill", x, y, width, height, radius, radius)

        node.focusable = true
        focus.register(node)
        local current = focus.getCurrent()
        if current == node then
            love.graphics.setColor(0.2,0.2,1,0.2)
            love.graphics.rectangle("fill", x, y, width, height, radius, radius)
        end

        love.graphics.setColor(s.color)
        love.graphics.printf(template.render(node.text or ""), x, y + (height/2 - fontsize/2), width, "center")

    elseif node.tag == "p" then
        love.graphics.setColor(s.color)
        love.graphics.print(template.render(node.text or ""), x, y)

    elseif node.tag == "area" then
        for _, child in ipairs(node.children) do
            renderer.renderNode(child)
        end
    end

    return y
end

return renderer
