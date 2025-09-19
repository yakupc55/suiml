local iftag = {}
local focus = require("focus")
local template = require("template")
function iftag.render(node,renderer)
    local ok = false
    local result = false
    local condition = template.renderAction(renderer,node.attributes["condition"])
    local fn, err = load("return " .. condition)
    if condition then
        ok, result = pcall(fn)
    end
    if (ok and result) or false then
        for _, child in ipairs(node.nodes) do
            y = renderer.renderNode(child, x, y)
        end
    else
        -- check for else
        for _, child in ipairs(node.nodes) do
            if child.name == "else" then
                for _, c in ipairs(child.nodes) do
                    y = renderer.renderNode(c, x, y)
                end
            end
        end
    end
end

return iftag