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

require("board")
board = Board:new(topLeftX, topLeftY, scale)

board:nextTurn("white")