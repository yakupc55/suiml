-- colors.lua
local colors = {
    red   = {1,0,0},
    blue  = {0,0,1},
    gray  = {0.5,0.5,0.5},
    white = {1,1,1},
    black = {0,0,0}
}

-- Hex (#rrggbb) -> {r,g,b}
local function hexToRgb(hex)
    hex = hex:gsub("#","")
    if #hex == 6 then
        local r = tonumber(hex:sub(1,2), 16) / 255
        local g = tonumber(hex:sub(3,4), 16) / 255
        local b = tonumber(hex:sub(5,6), 16) / 255
        return {r,g,b}
    elseif #hex == 3 then
        -- #rgb -> #rrggbb
        local r = tonumber(hex:sub(1,1)..hex:sub(1,1),16) / 255
        local g = tonumber(hex:sub(2,2)..hex:sub(2,2),16) / 255
        local b = tonumber(hex:sub(3,3)..hex:sub(3,3),16) / 255
        return {r,g,b}
    end
    return {1,1,1} -- fallback
end

-- Renk alma fonksiyonu
function colors.get(nameOrHex)
    if not nameOrHex then return {1,1,1} end
    if nameOrHex:sub(1,1) == "#" then
        return hexToRgb(nameOrHex)
    end
    return colors[nameOrHex] or {1,1,1}
end

return colors
