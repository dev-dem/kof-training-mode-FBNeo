print("The King of Fighters Training Mode")
print("Version: 0.4.0")
print("Developed by Dem")
print("Twitter: @Arpeggiate")
print("Youtube: https://www.youtube.com/user/DemKusa")
print("January, 2021")

-------------------------------------------------
-- Options
-------------------------------------------------
local options = {
	replay = false,    -- disables infinite time/health/record-play functionality
	osdDisplay = 3,   -- 0 = disabled 1 = player1  2 = player2  3 = both  
	inputDisplay = 3  -- 0 = disabled 1 = player1  2 = player2  3 = both
}
-------------------------------------------------
-- Global Module Variables
-------------------------------------------------
player = require 'player'
profile = require 'profile'
game = require 'game'
ui = require 'ui'
inputs = require 'inputs'
fn = require 'functions'
-------------------------------------------------
-- Global Variables
-------------------------------------------------
writeByte = memory.writebyte
writeWord = memory.writeword
writeDWord = memory.writedword
readByte = memory.readbyte
readByteSigned = memory.readbytesigned
readWord = memory.readword
readWordSigned = memory.readwordsigned
readDWord = memory.readdword
lShift = bit.lshift
rShift = bit.rshift
band = bit.band
bor = bit.bor
bxor = bit.bxor
frameCount = emu.framecount

-------------------------------------------------
-- Local variables
-------------------------------------------------

-- getting the current rom profile data
local game = game.getData()
-- creating player table objects
local p1 = player.new(1)
local p2 = player.new(2)

-- adding game data to player object
player.set(p1, "game", game)
player.set(p2, "game", game)

-------------------------------------------------
-- Data update functions
-------------------------------------------------

local function updateMemory()
	player.update(p1)
	player.update(p2)
end

local function updateInputs()
	inputs.update(p1)
	inputs.update(p2)
end

local function updatePlaybackInputs()
	inputs.record(p1)
	inputs.playback(p1)
end

-------------------------------------------------
-- OSD Functions
-------------------------------------------------

local function initOSD()
	if options.osdDisplay == 1 then
		ui.getOSD(p1)
	elseif options.osdDisplay == 2 then
		ui.getOSD(p2)
	elseif options.osdDisplay == 3 then
		ui.getOSD(p1)
		ui.getOSD(p2)
	end
end

local function initInputs()
	if options.inputDisplay == 1 then
		ui.getInputs(p1)
	elseif options.inputDisplay == 2 then
		ui.getInputs(p2)
	elseif options.inputDisplay == 3 then
		ui.getInputs(p1)
		ui.getInputs(p2)
	end
end

-------------------------------------------------
-- Hotkey Functions
-------------------------------------------------

local function hotkeyOsdDisplay()
	if options.osdDisplay > 3 then 
		options.osdDisplay = 0 
	end
	options.osdDisplay = options.osdDisplay + 1
end

local function hotkeyInputDisplay()
	if options.inputDisplay > 3 then 
		options.inputDisplay = 0 
	end
	options.inputDisplay = options.inputDisplay + 1
end

local function hotkeyRecording()
	if not p1.inputs.record.enabled and not options.replay then
		p1.inputs.record.memory = {} 
		p1.inputs.record.enabled = true
		p1.inputs.playback.enabled = false
	else 
		p1.inputs.record.enabled = false
	end
end

local function hotkeyPlayback()
	if not p1.inputs.playback.enabled and not options.replay then
		p1.inputs.playback.memory = p1.inputs.record.memory
		p1.inputs.record.enabled = false 
		p1.inputs.playback.enabled = true
	else 
		p1.inputs.playback.enabled = false
	end
end


local function updateGameplay()
	if not options.replay then 
		writeByte(0x10A836,0x60) --infinite time
		player.recoverLife(p1)
		player.recoverLife(p2)
	end
end
-------------------------------------------------
-- Register Hotkey Section
-------------------------------------------------
input.registerhotkey(1, function() -- alt + 1 = OSD Display
	hotkeyOsdDisplay()
	gui.clearuncommitted()
end)

input.registerhotkey(2, function() -- alt + 2 = Inputs Display
	hotkeyInputDisplay()
	gui.clearuncommitted()
end)

input.registerhotkey(3, function() -- alt + 3 = Record Inputs
	hotkeyRecording()
	gui.clearuncommitted()
end)

input.registerhotkey(4, function() -- alt + 4 = Play Inputs
	hotkeyPlayback()
	gui.clearuncommitted()
end)

-------------------------------------------------
-- Main Emulation Loop
-------------------------------------------------

while true do
	updateMemory()
	updateInputs()
	updatePlaybackInputs()
	initOSD()
	initInputs()
	updateGameplay()
	emu.frameadvance()
end