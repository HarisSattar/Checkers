Board = {}
Board.__index = Board

function Board:new(topLeftX, topLeftY, scale)
    require("piece")
    local board = {}
    for i = 1, 8 do
        board[i] = {}
        for j = 1, 8 do
            if j > 4 then
                pieceColor = "white"
            else
                pieceColor = "black"
            end
            if j == 4 or j == 5 then
    
            elseif i % 2 == 0 and j % 2 ~= 0 then
                position = {x = topLeftX + scale * (i-1), y = topLeftY + scale * (j-1)}
                board[i][j] = Piece:new(pieceColor, position)
            elseif i % 2 ~= 0 and j % 2 == 0 then
                position = {x = topLeftX + scale * (i-1), y = topLeftY + scale * (j-1)}
                board[i][j] = Piece:new(pieceColor, position)
            end
        end
    end
    
    setmetatable(board, self)
    return board
end

local function positionToIndex(x, y)
    return math.floor(x / (display.contentWidth / 8)) + 1, math.floor(y / (display.contentWidth / 8)) - 2
end

local function positionToCell(x, y)
    local x = math.floor(x / (display.contentWidth / 8))
    local y = math.floor(y / (display.contentWidth / 8))
    if (y < 3 or x < 0 or x > 7 or y > 10) then
        return positionToCell(sx, sy)
    end
    x = x * display.contentWidth / 8 + 90
    y = y * display.contentWidth / 8 + 110
    return x, y
end

local function setPosition(p, x, y)
    p.x = x
    p.y = y
end

function Board:checkNewPositionMoved(x, y, sx, sy)
    local x, y = positionToCell(x, y)
    local sx, sy = positionToCell(sx, sy)
    local i, j = positionToIndex(x, y)

    if (board[i][j] ~= nil) then
        return false
    end
    if (sx == x and sy == y) then
        return false
    end
    return true
end

local turn

local function checkDarkCell(x, y)
    local x, y = positionToIndex(x, y)
    if (x % 2 == 0 and y % 2 ~= 0) then
        return true
    end
    if (x % 2 ~= 0 and y % 2 == 0) then
        return true
    end
    return false
end 

function Board:getValidMoves(piece) 
    local moves = {}
    local side = piece.side
    local i, j = positionToIndex(piece.x, piece.y)
    if (side == "white" and not piece.isKing) then
        print("white not king", i, j)
        if (i < 8 and j > 1 and board[i+1][j-1] == nil) then
            indices = {x = i+1, y = j-1}
            table.insert(moves, indices)
        elseif (i < 7 and j > 2 and board[i+1][j-1].side == "black" and board[i+2][j-2] == nil) then
            indices = {x = i+2, y = j-2}
            table.insert(moves, indices)
        end
        if (i > 1 and j > 1 and board[i-1][j-1] == nil) then
            indices = {x = i-1, y = j-1}
            table.insert(moves, indices)
        elseif (i > 2 and j > 2 and board[i-1][j-1].side == "black" and board[i-2][j-2] == nil) then
            indices = {x = i-2, y = j-2}
            table.insert(moves, indices)
        end
        print(#moves)
        -- print(moves[1].x, moves[1].y)
    end
    if (side == "black" and not piece.isKing) then
        print("black not king", i, j)
        if (i < 8 and j < 8 and board[i+1][j+1] == nil) then
            indices = {x = i+1, y = j-1}
            table.insert(moves, indices)
        end
        if (i > 1 and j < 8 and board[i-1][j+1] == nil) then
            indices = {x = i-1, y = j-1}
            table.insert(moves, indices)
        end
        print(#moves)
        -- print(moves[1].x, moves[1].y)
    end
    return moves
end

local function move(event)
    x = 0; y = 0
    local p = event.target
    if (event.phase == "began") then
        isDraggedAllowed = true
        display.getCurrentStage():setFocus( event.target, event.id )
        saveX = p.x
        saveY = p.y
        moves = Board:getValidMoves(p)
    elseif (event.phase == "moved" and isDraggedAllowed) then
        print(p.x,' ', p.y)
        p:toFront()
        setPosition(p, event.x, event.y)
        if (p.x > display.contentWidth) then
            p.x = display.contentWidth
        end
        if (p.x < 0) then
            p.x = 0
        end
        if (p.y > display.contentHeight) then
            p.y = display.contentHeight
        end
        if (p.y < 0) then
            p.y = 0
        end
    elseif (event.phase == "ended") then
        if (saveX == nil and saveY == nil) then
            saveX = 0; saveY = 0
        end
        local x, y = positionToCell(event.x, event.y, saveX, saveY)
        if Board:checkIfValidMove(x, y, saveX, saveY, moves) then
            Board:updateBoard(p, x, y, saveX, saveY)
            Board:nextTurn(turn)
        else
            local sx, sy = positionToCell(saveX, saveY)
            setPosition(p, sx, sy)
        end
        isDraggedAllowed = false
        display.getCurrentStage():setFocus(event.target, nil)
    end
    return true
end

function Board:checkIfValidMove(x, y, sx, sy, moves)
    return Board:checkNewPositionMoved(x, y, sx, sy) and checkDarkCell(x, y) and #moves > 0
end

function Board:updateBoard(piece, x, y, sx, sy)
    print("board updated")
    i, j = positionToIndex(x, y)
    oldI, oldJ = positionToIndex(sx, sy)

    board[i][j] = piece
    board[oldI][oldJ] = nil
    setPosition(piece, x, y)
    if (piece.side == "white" and j == 1) then
        piece:removeSelf()
        piece = display.newImageRect("imgs/white_k.png", 200, 200)
        board[i][j] = piece
        setPosition(piece, x, y)
        piece.side = "white"
        piece.isKing = true
    end
    if (piece.side == "black" and j == 8) then
        piece:removeSelf()
        piece = display.newImageRect("imgs/black_k.png", 200, 200)
        board[i][j] = piece
        setPosition(piece, x, y)
        piece.side = "black"
        piece.isKing = true
    end

    print(i,j,board[i][j].side, board[i][j].isKing)
end

function Board:nextTurn(side)
    turn = side
    for i = 1, 8 do
        for j = 1, 8 do
            if board[i][j] ~= nil and board[i][j].side ~= turn then
                board[i][j]:removeEventListener("touch", move)
            elseif board[i][j] ~= nil then
                board[i][j]:addEventListener("touch", move)
            end
        end
    end

    if (turn == "white") then
        turn = "black"
    else
        turn = "white"
    end
end