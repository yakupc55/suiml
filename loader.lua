local parser = require("parser")
local router = require("router")
local htmlParser = require("libs.htmlparser")
local loadtag = require("tags.loadtag")
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
   loadtag.process(node,loader)
end

local function processPage(pageNode)
    -- Area eventleri
    pageNode._inited = false
    for _, child in ipairs(pageNode.nodes or {}) do
        if child.name == "onInit" and child:getcontent() then
            pageNode.onInit = function() load(child:getcontent())() end
        elseif child.name == "onEnter" and child:getcontent() then
            pageNode.onEnter = function() load(child:getcontent())() end
        elseif child.name == "onExit" and child:getcontent() then
            pageNode.onExit = function() load(child:getcontent())() end
        elseif child.name == "keypress" and child:getcontent() then
            pageNode.keypress = pageNode.keypress or {}
            local key = child.attributes["key"]
            print(key)
            if key then
                pageNode.keypress[key] = child:getcontent()
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
            elseif node.name =="page" then
                processPage(node)
                router.register(node)
            end
        end
    end
    if router.areas["main"] then
        router.goto("main")
    end
end

return loader
