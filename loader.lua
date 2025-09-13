local parser = require("parser")
local router = require("router")
local htmlParser = require("libs.htmlparser")
local loader = {}
function printTable(t, seen)
    seen = seen or {}
    if seen[t] then return "{...}" end
    seen[t] = true

    if type(t) ~= "table" then
        return tostring(t)
    end

    local parts = {}
    for k, v in pairs(t) do
        table.insert(parts, tostring(k) .. "=" .. printTable(v, seen))
    end
    return "{" .. table.concat(parts, ", ") .. "}"
end




loader.globalKeypress = {} -- <load> içindeki keypress eventleri

local function scanDir(path, files)
    local items = love.filesystem.getDirectoryItems(path)
    for _, item in ipairs(items) do
        local fullPath = path .. "/" .. item
        local info = love.filesystem.getInfo(fullPath)
        if info and info.type == "directory" then
            scanDir(fullPath, files)
        elseif info and info.type == "file" and item:match("%.suiml$") then
            table.insert(files, fullPath)
        end
    end
end

local function processLoad(node)
    for _, child in ipairs(node.nodes or {}) do
        -- print(child.name)
        if child.name == "script" and child:getcontent() then
            local func, err = load(child:getcontent())
            if func then func() end
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

local function processArea(areaNode)
    -- Area eventleri
    areaNode._inited = false
    for _, child in ipairs(areaNode.nodes or {}) do
        if child.name == "onInit" and child:getcontent() then
            areaNode.onInit = function() load(child:getcontent())() end
        elseif child.name == "onEnter" and child:getcontent() then
            areaNode.onEnter = function() load(child:getcontent())() end
        elseif child.name == "onExit" and child:getcontent() then
            areaNode.onExit = function() load(child:getcontent())() end
        elseif child.name == "keypress" and child:getcontent() then
            areaNode.keypress = areaNode.keypress or {}
            local key = child.attributes["key"]
            print(key)
            if key then
                areaNode.keypress[key] = child:getcontent()
            end
        end
    end
end

function loader.loadAll()
    local files = {}
    scanDir("src", files)
    for _, file in ipairs(files) do
        local content = love.filesystem.read(file)
        local root = htmlParser.parse(content)
        local elements = root("*")
        for _,node in ipairs(elements) do
            -- print(node.name)
            if node.name =="load" then
                processLoad(node)
            elseif node.name =="area" then
                processArea(node)
                router.register(node)
            end
        end
    end
    if router.areas["main"] then
        router.goto("main")
    end
end

return loader
