local function parseStyle(styleStr)
    local style = {}
    if not styleStr then return style end
    for prop, val in styleStr:gmatch("([%w%-]+)%s*:%s*([^;]+)") do
        prop = prop:gsub("%-", "")
        val = val:gsub("^%s*(.-)%s*$", "%1")
        -- sayı veya renk dönüşümü
        if val:match("^%d+$") then
            val = tonumber(val)
        elseif val:match("^#%x%x%x%x%x%x$") then
            local r = tonumber(val:sub(2,3),16)/255
            local g = tonumber(val:sub(4,5),16)/255
            local b = tonumber(val:sub(6,7),16)/255
            val = {r,g,b}
        end
        style[prop] = val
    end
    return style
end

-- node parser
node.style = parseStyle(attrs:match('style%s*=%s*"(.-)"'))
node.styleFocus = parseStyle(attrs:match('style%-focus%s*=%s*"(.-)"'))
node.styleHover = parseStyle(attrs:match('style%-hover%s*=%s*"(.-)"'))
