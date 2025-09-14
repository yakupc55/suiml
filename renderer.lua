local focus = require("focus")
local template = require("template")
local styleParse = require("style")
local colors = require("colors")
local imgtag = require("tags.imgtag")
local buttontag = require("tags.buttontag")
local ptag = require("tags.ptag")
local renderer = {}
local font
renderer.context = {}
renderer.cursorX = 0
renderer.cursorY = 0
renderer.spacing = 0

function renderer.init()
    font = love.graphics.newFont(16)
    love.graphics.setFont(font)
end

function renderer.resetValues()
context ={}
renderer.cursorX = 0
renderer.cursorY = 0
renderer.spacing = 0
end
function renderer.renderArea(area)
    for _, node in ipairs(area.nodes or {}) do
        -- print("node name",node.name)
        renderer.renderNode(node)
    end
end
function renderer.renderNode(node)

    
    --local s = style.parseStyle(node.style or {})
    local style = {}
    
    if node.attributes["style"] then
        style=styleParse.parseStyle(node.attributes["style"])
    end
    -- renk ve backcolor
    if style.color then
        local col = colors.get(style.color)
        style.color = {col[1], col[2], col[3], 1}
    else
        style.color = {1,1,1,1}
    end

    if style.backcolor then
        local bg = colors.get(style.backcolor)
        style.backcolor = {bg[1], bg[2], bg[3], 1}
    else
        style.backcolor = {0,0,0,0}
    end

    -- -- boyut ve font
    -- local fontsize   = tonumber(s.fontsize) or 16
    -- local width      = tonumber(s.width) or 200
    -- local height     = tonumber(s.height) or (fontsize+4)
    -- local radius     = tonumber(s.radius) or 5
    
    -- font = love.graphics.newFont(fontsize)
    -- love.graphics.setFont(font)
    
    local x, y
    -- print(node.name,renderer.cursorX,renderer.cursorY,x,y,renderer.spacing)
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
    -- elseif node.name == "p" or node.name == "br" then
    --     -- alt satıra geç ve node boyutunu dikkate al
    --     print("renderer.spacing p: ",renderer.spacing)
    --     x = renderer.cursorX
    --     y = renderer.cursorY
    --     renderer.cursorY = renderer.cursorY + renderer.spacing;
    --     renderer.cursorX = 0
    --     --renderer.cursorY = renderer.cursorY + height;
    --     renderer.spacing = height;
    --     --renderer.cursorX = width + renderer.spacing
    --     --lineHeight = height

    else
        -- -- normal node: x yönünde sırala
        -- x = renderer.cursorX
        -- y = renderer.cursorY
        -- renderer.cursorX = renderer.cursorX + width + renderer.spacing
        -- renderer.spacing = height;
        -- --lineHeight = math.max(lineHeight, height)
    end
    -- print(node.name,renderer.cursorX,renderer.cursorY,x,y,renderer.spacing)
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
                --_G[node.attributes["each"]] = val
                
                renderer.context[node.attributes["each"]] = val
                -- her child node'u render et
                for _, child in ipairs(node.nodes) do
                    y = renderer.renderNode(child, x, y)
                end
            end
        end
    elseif node.name == "button" then
        buttontag.render(node,style,renderer)
    elseif node.name == "p" then
        ptag.render(node,style,renderer)
        -- -- print(x,y)
        -- love.graphics.setColor(s.color)
        -- love.graphics.print(template.render(context,node:getcontent() or ""), x, y)
    elseif node.name == "l" then
        -- love.graphics.setColor(s.color)
        -- love.graphics.print(template.render(context,node:getcontent() or ""), x, y)
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
