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

local function positionToCell(x, y, sx, sy)
    local x = math.floor(x / (display.contentWidth / 8))
    local y = math.floor(y / (display.contentWidth / 8))
    if (y < 3 or x < 0 or x > 7 or y > 10) then
        return positionToCell(sx, sy, 0, 0)
    end
    x = x * display.contentWidth / 8 + 90
    y = y * display.contentWidth / 8 + 110
    return x, y
end

local function setPosition(p, x, y)
    p.x = x
    p.y = y
end

local function checkNewPositionMoved(x, y, sx, sy)
    local x, y = positionToCell(x, y)
    local sx, sy = positionToCell(sx, sy)
    if (sx == x and sy == y) then
        return false
    end
    return true
end

local turn

local function move(event)
    p = event.target
    if (event.phase == "began") then
        saveX = event.x
        saveY = event.y
    end
    if ( event.phase == "moved") then
        p:toFront()
        setPosition(p, event.x, event.y)
    end
    if (event.phase == "ended") then
        local x, y = positionToCell(event.x, event.y, saveX, saveY)
        setPosition(p, x, y)
        if checkNewPositionMoved(x, y, saveX, saveY) then
            Board:makeMove(turn)
        end
    end
    return true
end

function Board:makeMove(side)
    print("ran makeMove")
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