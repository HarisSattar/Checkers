Board = {}
Board.__index = Board

blackScore = 12
whiteScore = 12

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

    -- position = {x = topLeftX + scale * (2), y = topLeftY + scale * 1}
    -- board[3][2] = Piece:new("black", position)
    
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
    local jumpmoves = {}
    local side = piece.side
    local i, j = positionToIndex(piece.x, piece.y)
    local jumped = false

    if (side == "white" and not piece.isKing) then
        if (i < 7 and j > 2 and board[i+1][j-1] ~= nil and board[i+1][j-1].side == "black" and board[i+2][j-2] == nil) then
            indices = {x = i+2, y = j-2, jmp = {true, i+1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j > 2 and board[i-1][j-1] ~= nil and board[i-1][j-1].side == "black" and board[i-2][j-2] == nil) then
            indices = {x = i-2, y = j-2, jmp = {true, i-1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (not jumped) then
            if (i < 8 and j > 1 and board[i+1][j-1] == nil) then
                indices = {x = i+1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j > 1 and board[i-1][j-1] == nil) then
                indices = {x = i-1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
        end
    elseif (side == "white" and piece.isKing) then
        if (i < 7 and j > 2 and board[i+1][j-1] ~= nil and board[i+1][j-1].side == "black" and board[i+2][j-2] == nil) then
            indices = {x = i+2, y = j-2, jmp =  {true, i+1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j > 2 and board[i-1][j-1] ~= nil and board[i-1][j-1].side == "black" and board[i-2][j-2] == nil) then
            indices = {x = i-2, y = j-2, jmp = {true, i-1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i < 7 and j < 7 and board[i+1][j+1] ~= nil and board[i+1][j+1].side == "black" and board[i+2][j+2] == nil) then
            indices = {x = i+2, y = j+2, jmp = {true, i+1, j+1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j < 7 and board[i-1][j+1] ~= nil and board[i-1][j+1].side == "black" and board[i-2][j+2] == nil) then
            indices = {x = i-2, y = j+2, jmp = {true, i-1, j+1}}
            table.insert(jumpmoves, indices)
        end
        if (not jumped) then
            print(i, j)
            if (i < 8 and j > 1 and board[i+1][j-1] == nil) then
                indices = {x = i+1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j > 1 and board[i-1][j-1] == nil) then
                indices = {x = i-1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i < 8 and j < 8 and board[i+1][j+1] == nil) then
                indices = {x = i+1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j < 8 and board[i-1][j+1] == nil) then
                indices = {x = i-1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
        end
    end
    if (side == "black" and not piece.isKing) then
        if (i < 7 and j < 7 and board[i+1][j+1] ~= nil and board[i+1][j+1].side == "white" and board[i+2][j+2] == nil) then
            indices = {x = i+2, y = j+2, jmp = {true, i+1, j+1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j < 7 and board[i-1][j+1] ~= nil and board[i-1][j+1].side == "white" and board[i-2][j+2] == nil) then
            indices = {x = i-2, y = j+2, jmp = {true, i-1, j+1}}
            table.insert(jumpmoves, indices)
        end
        if (not jumped) then
            if (i < 8 and j < 8 and board[i+1][j+1] == nil) then
                indices = {x = i+1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j < 8 and board[i-1][j+1] == nil) then
                indices = {x = i-1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
        end
    elseif (side == "black" and piece.isKing) then
        if (i < 7 and j > 2 and board[i+1][j-1] ~= nil and board[i+1][j-1].side == "white" and board[i+2][j-2] == nil) then
            indices = {x = i+2, y = j-2, jmp = {true, i+1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j > 2 and board[i-1][j-1] ~= nil and board[i-1][j-1].side == "white" and board[i-2][j-2] == nil) then
            indices = {x = i-2, y = j-2, jmp = {true, i-1, j-1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i < 7 and j < 7 and board[i+1][j+1] ~= nil and board[i+1][j+1].side == "white" and board[i+2][j+2] == nil) then
            indices = {x = i+2, y = j+2, jmp = {true, i+1, j+1}}
            table.insert(jumpmoves, indices)
            jumped = true
        end
        if (i > 2 and j < 7 and board[i-1][j+1] ~= nil and board[i-1][j+1].side == "white" and board[i-2][j+2] == nil) then
            indices = {x = i-2, y = j+2, jmp = {true, i-1, j+1}}
            table.insert(jumpmoves, indices)
        end
        if (not jumped) then
            if (i < 8 and j > 1 and board[i+1][j-1] == nil) then
                indices = {x = i+1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j > 1 and board[i-1][j-1] == nil) then
                indices = {x = i-1, y = j-1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i < 8 and j < 8 and board[i+1][j+1] == nil) then
                indices = {x = i+1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
            if (i > 1 and j < 8 and board[i-1][j+1] == nil) then
                indices = {x = i-1, y = j+1, jmp = {false}}
                table.insert(moves, indices)
            end
        end
    end
    return moves, jumpmoves
end

local function move(event)
    local p = event.target
    if (event.phase == "began") then
        isDraggedAllowed = true
        display.getCurrentStage():setFocus( event.target, event.id )
        saveX = p.x
        saveY = p.y
        moves, jumpmoves = Board:getValidMoves(p)
    elseif (event.phase == "moved" and isDraggedAllowed) then
        haveDragged = true
        p:toFront()
        setPosition(p, event.x, event.y)
        width = display.contentWidth
        height = display.contentHeight
        if (p.x > width - 1) then
            p.x = width - 1
        end
        if (p.x < 1) then
            p.x = 1
        end
        if (p.y > height - width/2 + 139) then
            p.y = height - width/2 + 139        end
        if (p.y < 0 + width/2 - 179) then
            p.y = 0 + width/2 - 179
        end
    elseif (event.phase == "ended" and haveDragged) then
        if (saveX == nil and saveY == nil) then
            saveX = 0; saveY = 0
        end
        local x, y = positionToCell(p.x, p.y, saveX, saveY)
        local valid, jumped = Board:checkIfValidMove(x, y, saveX, saveY, moves, jumpmoves)
        
        if valid then
            if (jumped) then
                moves, jumpmoves = Board:getValidMoves(p)
                if (#jumpmoves > 0) then
                    turn = p.side
                    Board:nextTurn(turn)
                end
            end
             
            if (p.side == "white") then
                turn = "black"
            else
                turn = "white"
            end

            Board:updateBoard(p, x, y, saveX, saveY, jumped, turn)
            Board:nextTurn(turn)
        else
            local sx, sy = positionToCell(saveX, saveY)
            setPosition(p, sx, sy)
        end
        isDraggedAllowed = false
        haveDragged = false
        display.getCurrentStage():setFocus(event.target, nil)
    end
    return true
end

function Board:usedValidMove(moves, jumpmoves, x, y)
    print("moves: "..#moves)
    valid = false

    if #moves < 1  and #jumpmoves < 1 then
        valid = false
        return valid, false
    end

    local i, j = positionToIndex(x,y)
    print("i:", i, "j:", j)

    if (#jumpmoves > 0) then
        for m = 1, #jumpmoves do
            print("moves: ".. jumpmoves[m].x .. ", " .. jumpmoves[m].y)
            if (i == jumpmoves[m].x and j == jumpmoves[m].y) then
                valid = true
            end
        end
        return valid, jumpmoves[1].jmp
    else
        for k = 1, #moves do
            print("moves: ".. moves[k].x .. ", " .. moves[k].y)
            if (i == moves[k].x and j == moves[k].y) then
                valid = true
            end
        end
        return valid, moves[1].jmp
    end
end

function Board:checkIfValidMove(x, y, sx, sy, moves)
    valid, jumped = Board:usedValidMove(moves, jumpmoves, x, y)
    return Board:checkNewPositionMoved(x, y, sx, sy) and checkDarkCell(x, y) and valid, jumped
end

function Board:updateBoard(piece, x, y, sx, sy, jump, turn)
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
    if (jump[1] == true) then
        print("jump")
        board[jump[2]][jump[3]]:removeSelf()
        board[jump[2]][jump[3]] = nil
        if (turn == "black") then
            whiteScore = whiteScore - 1
        else
            blackScore = blackScore - 1
        end
    end
    if (blackScore == 0) then
        print("black wins")
    elseif (whiteScore == 0) then
        print("white wins")
    end
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
end