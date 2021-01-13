local game = {}
profile = require 'profile'

function game.getData()
	game = nil
	for _, module in ipairs(profile.get()) do
		for _, shortname in ipairs(module.name) do
			if emu.romname() == shortname or emu.parentname() == shortname then
				print("Game: " .. emu.gamename())
				game = module
				return game 
			end
		end
	end
end

return game