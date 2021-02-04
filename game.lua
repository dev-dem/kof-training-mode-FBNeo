local game = {}

function game.getData()
	local game = nil
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