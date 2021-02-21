local game = {}

function game.isSupported(game)
	local supported = true
	if fn.isEmptyTable(game) then
		supported = false
		print("Game not supported")
	end
	return supported 
end

function game.getData()
	local game = {}
	for _, module in ipairs(profile.get()) do
		for _, shortname in ipairs(module.name) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("Game: " .. emu.gamename())
				game = module 
			end
		end
	end
	return game
end

return game