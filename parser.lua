-- parser.lua
local parser = {}

function parser.parseHTML(html)
    local nodes = {}
    for tag, attrs, inner in html:gmatch("<(%w+)(.-)>(.-)</%1>") do
        local node = {
            tag = tag,
            attrs = attrs,
            children = {}
        }

        local innerNodes = parser.parseHTML(inner)
        if #innerNodes > 0 then
            node.children = innerNodes
        else
            node.text = inner
        end

        local name = attrs:match('name%s*=%s*"(.-)"')
        if name then node.name = name end

        local gotoTarget = attrs:match('goto%s*=%s*"(.-)"')
        if gotoTarget then node.goto = gotoTarget end

        table.insert(nodes, node)
    end
    return nodes
end

return parser
