local imgtag = {}

function imgtag.render(node,renderer)
    --draw kısmı
    if node.attributes["src"] then node.src = node.attributes["src"] end
    if node.src then
        -- cache mekanizması: aynı resmi tekrar tekrar load etmesin
        if not node._image then
            local ok, img = pcall(love.graphics.newImage, "src/"..node.src)
            if ok then
                node._image = img
            else
                print("Resim yüklenemedi:", node.src)
            end
        end

        if node._image then
            local w, h = node._image:getDimensions()
            local drawW = node.width or w
            local drawH = node.height or h
            local x = renderer.cursorX
            local y = renderer.cursorY
            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(node._image, x, y, 0, drawW / w, drawH / h)
            renderer.cursorX = renderer.cursorX + drawW
            renderer.spacing = math.max(renderer.spacing,drawH);
            print("spacing :",renderer.spacing)
        end
    end
end

return imgtag