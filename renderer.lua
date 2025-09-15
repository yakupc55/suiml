local focus = require("focus")
local template = require("template")
local styleParse = require("style")
local colors = require("colors")
local imgtag = require("tags.imgtag")
local buttontag = require("tags.buttontag")
local ptag = require("tags.ptag")
local ltag = require("tags.ltag")
local backtag = require("tags.backtag")
local iftag = require("tags.iftag")
local fortag = require("tags.fortag")
local brtag = require("tags.brtag")
local spacetag = require("tags.spacetag")
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

function getStyle(node)
    node.style = {}
    
    if node.attributes["style"] then
        -- print("node: ",node.name)
        node.style=styleParse.parseStyle(node.attributes["style"])
        -- print("len : ",#node.style)
    end
    -- renk ve backcolor
    if node.style.color then
    --    print("node: ",node.name)
        local col = colors.get(node.style.color)
        node.style.color = {col[1], col[2], col[3], 1}
    else
        node.style.color = {0,0,0,1}
    end

    if node.style.backcolor then
        local bg = colors.get(node.style.backcolor)
        node.style.backcolor = {bg[1], bg[2], bg[3], 1}
    else
        node.style.backcolor = {0,0,0,0}
    end

end

function renderTag(node)
    if node.name == "if" then
         iftag.render(node,renderer)
    elseif node.name == "for" then
        fortag.render(node,renderer)
    elseif node.name == "button" then
        buttontag.render(node,renderer)
    elseif node.name == "p" then
        ptag.render(node,renderer)
    elseif node.name == "l" then
        ltag.render(node,renderer)
    elseif node.name == "back" then
        backtag.render(node,renderer)
    elseif node.name == "br" then
        brtag.render(node,renderer)
    elseif node.name == "space" then
        spacetag.render(node,renderer)
    elseif node.name == "img" then
        imgtag.render(node,renderer)
    end
    if node.name =="if" or node.name =="else" or node.name =="for" then
        
    else
    for _, child in ipairs(node.nodes) do
                renderer.renderNode(child)
            end
    end
end

function renderer.renderNode(node)
    getStyle(node)
    renderTag(node)
end

return renderer
