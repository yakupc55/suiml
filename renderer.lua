local focus = require("focus")
local template = require("template")
local style = require("style")
local colors = require("colors")
local imgtag = require("tags.imgtag")
local renderer = {}
local font
renderer.cursorX = 0
renderer.cursorY = 0
spacing = 0

function renderer.init()
    font = love.graphics.newFont(16)
    love.graphics.setFont(font)
end

function renderer.resetValues()
renderer.cursorX = 0
renderer.cursorY = 0
spacing = 0
end
function renderer.renderArea(area)
    for _, node in ipairs(area.nodes or {}) do
        -- print("node name",node.name)
        renderer.renderNode(node)
    end
end
function renderer.renderNode(node)

    
    --local s = style.parseStyle(node.style or {})
    local s = {}
    
    if node.attributes["style"] then
        s=style.parseStyle(node.attributes["style"])
    end
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
    -- print(node.name,renderer.cursorX,renderer.cursorY,x,y,spacing)
    -- bazı özel node’lar alt satıra geçer
    if node.name == "page" or node.name == "load" then
        x = 0
        y = 0
        renderer.cursorX = 0
        renderer.cursorY = 0
    --es geçilip kendi sisteminde ayarlananlar
    elseif node.name == "img" then
    elseif node.name == "for" or node.name == "if" or node.name == "else" then
        renderer.cursorX = renderer.cursorX
        renderer.cursorY = renderer.cursorY
    elseif node.name == "p" or node.name == "br" then
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
    -- print(node.name,renderer.cursorX,renderer.cursorY,x,y,spacing)
    -- node çizimi
    if node.name == "if" then
            local ok = false
            if node.attributes["condition"] then
                ok = _G[node.attributes["condition"]] == true
            end
            if ok then
                for _, child in ipairs(node.nodes) do
                    y = renderer.renderNode(child, x, y)
                end
            else
                -- check for else
                for _, child in ipairs(node.nodes) do
                    if child.name == "else" then
                        for _, c in ipairs(child.nodes) do
                            y = renderer.renderNode(c, x, y)
                        end
                    end
                end
            end
    elseif node.name == "for" then
        -- Lua kodunu çalıştır (örneğin "indexlist(#PLAYER_LIST)")
        local ok, list = pcall(load("return " .. node.attributes["in"]))
        if not ok then
            print("For error:", list)
            return y
        end

        if type(list) == "table" then
            for _, val in ipairs(list) do
                -- döngü değişkenini global ortama ekle
                _G[node.attributes["each"]] = val

                -- her child node'u render et
                for _, child in ipairs(node.nodes) do
                    y = renderer.renderNode(child, x, y)
                end
            end
        end
    elseif node.name == "button" then
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
        love.graphics.printf(template.render(node:getcontent() or ""), x, y + (height/2 - fontsize/2), width, "center")

    elseif node.name == "p" then
        -- print(x,y)
        love.graphics.setColor(s.color)
        love.graphics.print(template.render(node:getcontent() or ""), x, y)
    elseif node.name == "img" then
        imgtag.render(node,renderer)
    end
    if node.name =="if" or node.name =="else" or node.name =="for" then
        
    else
    for _, child in ipairs(node.nodes) do
                renderer.renderNode(child)
            end
    end

    return y
end

return renderer
