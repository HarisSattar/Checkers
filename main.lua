-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local width = display.contentWidth
local height = display.contentHeight
local boardImg = display.newImageRect("imgs/board.png", width, width)
boardImg.x = display.contentCenterX
boardImg.y = display.contentCenterY

local backgroundImg = display.newImageRect("imgs/background.png", width, height)
backgroundImg.x = display.contentCenterX
backgroundImg.y = display.contentCenterY
backgroundImg:toBack()


local topLeftX = 90
local topLeftY = boardImg.y / 2 + 10
local scale = 180

Piece = require("piece")

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