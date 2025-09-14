-- template.lua
local template = {}

function template.render(localData, str)
    return (str:gsub("{{(.-)}}", function(code)
        local fn, err = load("return " .. code, "template", "t", setmetatable({}, { __index = function(_, k)
            -- önce localData'da ara
            if localData[k] ~= nil then
                return localData[k]
            end
            -- yoksa globalde ara
            return _G[k]
        end }))
        if not fn then
            return "" -- hata varsa boş döndür
        end
        local ok, result = pcall(fn)
        if ok and result ~= nil then
            return tostring(result)
        else
            return ""
        end
    end))
end

return template
