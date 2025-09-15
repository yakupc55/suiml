local brtag = {}
function brtag.render(node,renderer)
    if node.attributes["height"] then
        renderer.spacing = renderer.spacing + node.attributes["height"];
    end
    renderer.cursorY = renderer.cursorY + renderer.spacing;
    renderer.spacing = 0
    renderer.cursorX = 0
end

return brtag