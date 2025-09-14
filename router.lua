-- router.lua
local router = {}

router.areas = {}
router.current = nil

-- area kaydı
function router.register(pageNode)
    -- pageNode içinde <onInit>, <onEnter>, <onExit> node'larını ayıkla
    pageNode._inited = false
    for _, child in ipairs(pageNode.nodes or {}) do
        -- print("child ",child.name)
        if child.name == "onInit" then
            pageNode.onInit = function()
                local f, err = load(child:getcontent() or "")
                if f then f() end
            end
        elseif child.name == "onEnter" then
            pageNode.onEnter = function()
                local f, err = load(child:getcontent() or "")
                if f then f() end
            end
        elseif child.name == "onExit" then
            pageNode.onExit = function()
                local f, err = load(child:getcontent() or "")
                if f then f() end
            end
        end
    end

    router.areas[pageNode.attributes["name"]] = pageNode
    print(pageNode.attributes["name"])
end

-- area değişimi
function router.goto(areaName)
    local prevArea = router.current and router.areas[router.current] or nil
    local nextArea = router.areas[areaName]

    if not nextArea then
        print("Router: area bulunamadı -> " .. tostring(areaName))
        return
    end

    -- exit event
    if prevArea and prevArea.onExit then prevArea.onExit() end

    router.current = areaName

    -- init event (sadece ilk açılışta)
    if nextArea.onInit and not nextArea._inited then
        nextArea.onInit()
        nextArea._inited = true
    end

    -- enter event
    if nextArea.onEnter then nextArea.onEnter() end
end

function router.getCurrent()
    return router.current and router.areas[router.current] or nil
end

function router.handleKey(key)
    -- önce global load keypress
    local loader = require("loader")
    if loader.globalKeypress[key] then
        load(loader.globalKeypress[key])()
    end

    -- sonra current area keypress
    local area = router.getCurrent()
    if area and area.keypress and area.keypress[key] then
        load(area.keypress[key])()
    end
end

return router