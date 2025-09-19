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