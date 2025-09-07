-- template.lua
local template = {}

function template.render(text)
    if not text then return "" end
    -- {{VAR}} şeklindeki ifadeleri global değişkenlerle değiştir
    return text:gsub("{{(.-)}}", function(var)
        var = var:match("^%s*(.-)%s*$") -- trim
        local value = _G[var]
        if value ~= nil then
            return tostring(value)
        else
            return "{{"..var.."}}" -- bulunmazsa olduğu gibi bırak
        end
    end)
end

return template
