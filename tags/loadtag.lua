local loadtag = {}
local focus = require("focus")
local template = require("template")
local settings = require("template")
function loadtag.process(node,loader)
    for _, child in ipairs(node.nodes or {}) do
        -- print(child.name)
        if child.name == "script" and child:getcontent() then
            local func, err = load(child:getcontent())
            if func then func() end
        elseif child.name == "settings" then
            settings.process(node)
        elseif child.name == "config" then
            -- print(type(child.attributes))
            -- for i in child.attributes do
            --     print(i)
            -- end
            -- printTable(child.attributes)
            local key = child.attributes["key"] or "none"
            local typeAttr = child.attributes["type"] or "string"
            local value = child:getcontent() or ""
            local ltype = child.attributes["listtype"] or "string"
            if key then
                local val
                if typeAttr == "boolean" then
                    val = (value == "true")
                elseif typeAttr == "number" then
                    val = tonumber(value) or 0
                elseif typeAttr == "list" then
                    val = {}
                    for item in value:gmatch("[^,]+") do
                        item = item:match("^%s*(.-)%s*$") -- trim
                        if ltype == "number" then
                            item = tonumber(item) or 0
                        elseif ltype == "boolean" then
                            item = (item == "true")
                        end
                        table.insert(val, item)
                    end
                elseif typeAttr == "table" then
                    val = {}
                    for k,v in value:gmatch("([^,=]+)=([^,=]+)") do
                        k = k:match("^%s*(.-)%s*$")
                        v = v:match("^%s*(.-)%s*$")
                        val[k] = v
                    end
                else
                    val = value -- string (default)
                end

                _G[key] = val
                if type(val) == "table" then
                    local t = {}
                    for k,v in pairs(val) do
                        table.insert(t, k.."="..v)
                    end
                    print("Config yüklendi:", key, "=", "{"..table.concat(t,", ").."}")
                else
                    print("Config yüklendi:", key, "=", tostring(val))
                end
            end
        elseif child.name == "keypress" then
            local key = child.attributes["key"]
            if key and child:getcontent() then
                loader.globalKeypress[key] = child:getcontent()
            end
        end
    end
end

return loadtag