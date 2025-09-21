local iftag = {}
local template = require("template")

-- Koşul stringini çalıştır
local function evalCondition(renderer, expr)
    if not expr or expr == "" then return false end
    local condition = template.renderAction(renderer, expr)
    local fn, err = load("return " .. condition)
    if not fn then
        print("IfTag Error:", err)
        return false
    end
    local ok, result = pcall(fn)
    if ok then
        return result and true or false
    else
        print("IfTag Runtime Error:", result)
        return false
    end
end

function iftag.render(node, renderer)
    local executed = false

    -- Önce ana <if> condition
    if evalCondition(renderer, node.attributes["condition"]) then
        for _, child in ipairs(node.nodes or {}) do
            if child.name ~= "else" and child.name ~= "elif" then
                renderer.renderNode(child)
            end
        end
        executed = true
    end

    -- Eğer if çalışmadıysa -> elif zinciri
    if not executed then
        for _, child in ipairs(node.nodes or {}) do
            if child.name == "elif" then
                if evalCondition(renderer, child.attributes["condition"]) then
                    for _, c in ipairs(child.nodes or {}) do
                        renderer.renderNode(c)
                    end
                    executed = true
                    break
                end
            end
        end
    end

    -- Hâlâ çalışmadıysa -> else bloğu
    if not executed then
        for _, child in ipairs(node.nodes or {}) do
            if child.name == "else" then
                for _, c in ipairs(child.nodes or {}) do
                    renderer.renderNode(c)
                end
            end
        end
    end
end

return iftag
