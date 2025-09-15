local spacetag = {}
function spacetag.render(node,renderer)
    if node.attributes["width"] then
        renderer.cursorX = renderer.cursorX + node.attributes["width"]
    end
    if node.attributes["height"] then
        renderer.spacing = math.max(renderer.spacing,node.attributes["height"]);
    end
end

return spacetag