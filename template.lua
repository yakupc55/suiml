-- template.lua
local template = {}

function template.render(str)
    return (str:gsub("{{(.-)}}", function(code)
        local ok, result = pcall(load("return " .. code))
        if ok and result ~= nil then
            return tostring(result)
        else
            return ""
        end
    end))
end

return template
