Piece = {}

function Piece:new(s, p)
    if s == "white" then
        pColor = "imgs/white_m.png"
    else
        pColor = "imgs/black_m.png"
    end
    local piece = {side = s, position = {x = p.x, y = p.y}, img = display.newImageRect(pColor, 200, 200)}
    piece.img.x = position.x
    piece.img.y = position.y
    self.__index = self

    function piece.img:touch(event)
        if ( event.phase == "moved") then
            piece.img:toFront()
            piece.position.x = event.x
            piece.position.y = event.y
            piece.img.x = event.x
            piece.img.y = event.y
        end
        return true
    end
    piece.img:addEventListener("touch", piece.img)

    return setmetatable(piece, self)
end

function Piece:getSide()
    return self.side
end


return Piece