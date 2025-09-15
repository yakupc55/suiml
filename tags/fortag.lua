local fortag = {}
local focus = require("focus")
local template = require("template")
function fortag.render(node,renderer)
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
end

return fortag