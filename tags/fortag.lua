local fortag = {}
local focus = require("focus")
local template = require("template")

local function deepCopy(orig, seen)
    if type(orig) ~= "table" then
        return orig
    end
    if seen and seen[orig] then
        return seen[orig]
    end

    local copy = {}
    seen = seen or {}
    seen[orig] = copy

    for k, v in pairs(orig) do
        copy[deepCopy(k, seen)] = deepCopy(v, seen)
    end

    setmetatable(copy, deepCopy(getmetatable(orig), seen))
    return copy
end


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
            if node.attributes["global"]=="true" then
                _G[node.attributes["each"]] = val
            end
            renderer.context[node.attributes["each"]] = val
            -- her child node'u render et
            for _, child in ipairs(node.nodes) do
                local cloned = deepCopy(child)
                y = renderer.renderNode(cloned, x, y)
            end
        end
    end
end

return fortag