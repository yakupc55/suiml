-- parser.lua
local parser = {}

-- attrs stringini tabloya çevirir
local function parseAttributes(attrStr)
    local attrs = {}
    if not attrStr then return attrs end
    -- hem "..." hem '...' tırnakları desteklenir
    for k,v in attrStr:gmatch("([%w-]+)%s*=%s*['\"](.-)['\"]") do
        attrs[k] = v
    end
    return attrs
end

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
        local att = parseAttributes(attrs)
        local name = att.name
       
        if name then node.name = name end

        local gotoTarget = att.goto
        if gotoTarget then node.goto = gotoTarget end

        --if for sistemleri
        if tag == "if" then
            local condition = att.condition
            node.condition = condition 
        end
        if tag == "for" then
        local each = att.each
        local inVar = att["in"]
        node.each = each;
        node.inVar = inVar end
        table.insert(nodes, node)
    end
    return nodes
end

return parser
