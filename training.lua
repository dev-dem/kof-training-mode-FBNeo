print("The King of Fighters Training Mode")
print("Version: 0.2.0")
print("Refactored by Dem")
print("Twitter: @Arpeggiate")
print("January, 2021")

player = require 'player'
game = require 'game'
ui = require 'ui'
inputs = require 'inputs'

local writeByte = memory.writebyte
local writeWord = memory.writeword
local writeDWord = memory.writedword
local rb, rbs, rw, rws, rd, fc = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, emu.framecount
local game = game.getData()
local p1 = player.new(1)
local p2 = player.new(2)

player.set(p1, "game", game)
player.set(p2, "game", game)

function updateMemory()
	player.update(p1)
	player.update(p2)
end

function updateGameplay()
	--writeByte(0x10A836,0x60) --infinite time
end

function addUi()
	ui.getOSD(p1)
	ui.getOSD(p2)
end

function updateInputs()
	inputs.update(p1)
	inputs.update(p2)
end

-------------------------------------------------
-- Main Emulation Loop
-------------------------------------------------

while true do
	updateMemory()
	updateGameplay()
	addUi()
	--inputs.drawDpad(10, 90, 3)
	updateInputs()
	emu.frameadvance()
end