print("The King of Fighters Training Mode")
print("Version: 0.5.0")
print("Developed by Dem")
print("Twitter: @Arpeggiate")
print("Youtube: https://www.youtube.com/user/DemKusa")
print("January, 2021")
print("_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/")
print("SHORTCUTS")
print("alt + 1 to toggle OSD display")
print("alt + 2 to toggle inputs display")
print("alt + 3 to toggle hitboxes")
print("alt + 4 to record inputs")
print("alt + 5 to play inputs")
print("_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/_/")

-------------------------------------------------
-- Options
-------------------------------------------------
local options = {
	replay = false,   -- disables infinite time/health/record-play functionality
	osdDisplay = 3,   -- 0 = disabled  1 = player1  2 = player2  3 = both  
	inputDisplay = 3, -- 0 = disabled  1 = player1  2 = player2  3 = both
	hitboxDisplay = 1 -- 0 = disabled  1 = hurtbox and hitbox  2 = adds pushbox  3 = adds throwable box  
}

-------------------------------------------------
-- Global Module Variables
-------------------------------------------------
player = require 'lib.player'
profile = require 'lib.profile'
game = require 'lib.game'
ui = require 'lib.ui'
inputs = require 'lib.inputs'
fn = require 'lib.functions'
hitboxes = require "lib.hitboxes"

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

-------------------------------------------------
-- Local variables
-------------------------------------------------
-- getting the current rom profile data
local gameData = game.getData()
if not game.isSupported(gameData) then
	do return end
end
-- creating player table objects
local p1 = player.new(1)
local p2 = player.new(2)

-- adding game data to player object
player.set(p1, "game", gameData)
player.set(p2, "game", gameData)

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

local function setHitboxOptions()
	if options.hitboxDisplay == 0 then
		hitboxes.disable()
	elseif options.hitboxDisplay == 1 then
		hitboxes.display()
	elseif options.hitboxDisplay == 2 then
		hitboxes.displayPushboxes()
	elseif options.hitboxDisplay == 3 then
		hitboxes.displayThrowable()
	end
end 

-------------------------------------------------
-- Hotkey Functions
-------------------------------------------------
local function hotkeyOsdDisplay()
	options.osdDisplay = options.osdDisplay + 1
	if options.osdDisplay > 3 then 
		options.osdDisplay = 0 
	end
end

local function hotkeyInputDisplay()
	options.inputDisplay = options.inputDisplay + 1
	if options.inputDisplay > 3 then 
		options.inputDisplay = 0 
	end
end

local function hotkeyHitboxDisplay()
	options.hitboxDisplay = options.hitboxDisplay + 1
	if options.hitboxDisplay > 3 then 
		options.hitboxDisplay = 0 
	end
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

-------------------------------------------------
-- Gameplay cheats
-------------------------------------------------
local function updateGameplay()
	if not options.replay then 
		player.enableCheats(gameData)
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

input.registerhotkey(3, function() -- alt + 3 = hitboxes
	hotkeyHitboxDisplay()
	gui.clearuncommitted()
end)

input.registerhotkey(4, function() -- alt + 4 = Record Inputs
	hotkeyRecording()
	gui.clearuncommitted()
end)

input.registerhotkey(5, function() -- alt + 5 = Play Inputs
	hotkeyPlayback()
	gui.clearuncommitted()
end)

-------------------------------------------------
-- Hooks
-------------------------------------------------
emu.registerafter(function() 
	hitboxes.update() 
end)

gui.register(function()
	setHitboxOptions()
	hitboxes.render() 
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