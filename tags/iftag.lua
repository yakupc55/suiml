local iftag = {}
local focus = require("focus")
local template = require("template")
function iftag.render(node,renderer)
    local ok = false
        if node.attributes["condition"] then
            ok = _G[node.attributes["condition"]] == true
        end
        if ok then
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