local imgtag = {}

function imgtag.render(node,renderer)
    if node.att.src then node.src = node.att.src end
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

            love.graphics.setColor(1,1,1,1)
            love.graphics.draw(node._image, x, y, 0, drawW / w, drawH / h)
            renderer.cursorX = renderer.cursorX + drawH
            renderer.cursorY = renderer.cursorY + drawH
        end
    end
end

return imgtag