local __settings = {}

function __settings.process(node)
    print(#node.attributes)
    if node.attributes["fps"] then
        __targetFPS = node.attributes["fps"]
    end
end

return __settings
    
