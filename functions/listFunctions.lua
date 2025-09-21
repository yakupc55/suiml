_G.randomChoiceFromList = function (list, count)
    if type(list) ~= "table" or #list == 0 then
        return {}
    end

    -- count, listedeki eleman sayısından fazla olamaz
    count = math.min(count, #list)

    -- listedeki elemanları kopyala
    local copy = {unpack(list)}

    -- Fisher-Yates shuffle ile karıştır
    for i = #copy, 2, -1 do
        local j = math.random(i)
        copy[i], copy[j] = copy[j], copy[i]
    end

    -- ilk N elemanı al
    local result = {}
    for i = 1, count do
        table.insert(result, copy[i])
    end

    return result
end

_G.printList = function(list)
    for i, v in ipairs(list) do
        print(i, v)
    end
end

_G.listsEqual = function (t1, t2)
    if #t1 ~= #t2 then
        return false
    end
    for i = 1, #t1 do
        if t1[i] ~= t2[i] then
            return false
        end
    end
    return true
end

_G.listPushMax = function (list,max, value)
    table.insert(list, value)
    if #list > max then
        table.remove(list, 1) -- en eskiyi sil (başından)
    end
end

_G.findInList = function (list, value)
    for i, v in ipairs(list) do
        -- print("i",i,v)
        if v == value then
            return true, i
        end
    end
    return false, nil
end

-- İki listeyi karşılaştır
_G.mapListMatches = function(list1, list2)
    local result = {}
    for i, v in ipairs(list1) do
        local found, index = findInList(list2, v)
        if found then
            if index == i then
                table.insert(result, 1) -- aynı sırada
            else
                table.insert(result, 2) -- farklı sırada
            end
        else
            table.insert(result, 0) -- yok
        end
    end
    return result
end
_G.copyOfList = function(list)
    local newList ={}
    for i = 1, #list do
            newList[i] = list[i]
    end
    return newList
end
_G.listValuesCopy = function(src, dest)
    for i = 1, math.min(#src, #dest) do
        dest[i] = src[i]
    end
end