local parser = require("parser")
local router = require("router")

local loader = {}

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
    for _, child in ipairs(node.children or {}) do
        if child.tag == "script" and child.text then
            local func, err = load(child.text)
            if func then func() end
        elseif child.tag == "config" then
            local key = child.attrs:match('key%s*=%s*"(.-)"')
            local typeAttr = child.attrs:match('type%s*=%s*"(.-)"') or "string"
            local value = child.text or ""

            if key then
                local val
                if typeAttr == "boolean" then
                    if value == "true" then val = true
                    else val = false end
                elseif typeAttr == "number" then
                    val = tonumber(value) or 0
                else -- string
                    val = value
                end

                _G[key] = val
                print("Config yüklendi:", key, "=", tostring(val))
            end
        elseif child.tag == "keypress" then
            local key = child.attrs:match('key%s*=%s*"(.-)"')
            if key and child.text then
                loader.globalKeypress[key] = child.text
            end
        end
    end
end

local function processArea(areaNode)
    -- Area eventleri
    areaNode._inited = false
    for _, child in ipairs(areaNode.children or {}) do
        if child.tag == "onInit" and child.text then
            areaNode.onInit = function() load(child.text)() end
        elseif child.tag == "onEnter" and child.text then
            areaNode.onEnter = function() load(child.text)() end
        elseif child.tag == "onExit" and child.text then
            areaNode.onExit = function() load(child.text)() end
        elseif child.tag == "keypress" and child.text then
            areaNode.keypress = areaNode.keypress or {}
            local key = child.attrs:match('key%s*=%s*"(.-)"')
            if key then
                areaNode.keypress[key] = child.text
            end
        end
    end
end

function loader.loadAll()
    local files = {}
    scanDir("src", files)

    for _, file in ipairs(files) do
        local content = love.filesystem.read(file)
        local dom = parser.parseHTML(content)
        for _, node in ipairs(dom) do
            if node.tag == "load" then
                processLoad(node)
            elseif node.tag == "area" and node.name then
                processArea(node)
                require("router").register(node)
            end
        end
    end

    local router = require("router")
    if router.areas["main"] then
        router.goto("main")
    end
end

return loader
