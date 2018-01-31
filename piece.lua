Piece = {}
Piece.__index = Piece

function Piece:new(s, p)
    if s == "white" then
        pColor = "imgs/white_m.png"
    else
        pColor = "imgs/black_m.png"
    end
    
    local piece = display.newImageRect(pColor, 200, 200)
    piece.side = s
    piece.x = p.x
    piece.y = p.y

    return piece
end

return Piece