-- focus.lua
local focus = {
    items = {},
    index = 1
}

-- sadece buton listesini sıfırla, index’i koru
function focus.reset()
    focus.items = {}
end

function focus.register(node)
    table.insert(focus.items, node)
end

function focus.next()
    if #focus.items > 0 then
        focus.index = (focus.index % #focus.items) + 1
    end
end

function focus.prev()
    if #focus.items > 0 then
        focus.index = (focus.index - 2) % #focus.items + 1
    end
end

function focus.getCurrent()
    if #focus.items > 0 then
        return focus.items[focus.index]
    end
    return nil
end

-- aktif alan değiştiğinde index sıfırlama fonksiyonu
function focus.resetIndex()
    focus.index = 1
end

return focus
