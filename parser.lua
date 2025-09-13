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
    -- self-closing tags (<img ... />, <br/>, vs.)
    -- for tag, attrs in html:gmatch("<(%w+)(.-)/>") do
    --     local att = parseAttributes(attrs)
    --     local node = { tag = tag, attrs = att, children = {}, text = "" }

    --     -- özel alanlar

    --     -- all attrs get
    --     node.att = att
    --     table.insert(nodes, node)
    -- end
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
       
        if att.name then node.name = att.name end

        if gotoTarget then node.goto = att.goto end

        --if for sistemleri
        if tag == "if" then
            node.condition = att.condition
        elseif tag == "for" then
            node.each = att.each
            node.inVar =att["in"]
        elseif tag == "img" then
            print("dkkdf")
            node.src = att.src
        end
        -- all attrs get
        node.att = att
        table.insert(nodes, node)
        -- print(att.style)
        
    end
    return nodes
end

return parser
