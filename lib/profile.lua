local profile = {}

local function getPositionX(playerNumber, p1PositionX, p2PositionX)
	return function(playerNumber)
		local x = 0
		if (playerNumber == 1) then
			x = p1PositionX
		else
			x = p2PositionX
		end
		return x
	end
end

local function getByteValue(base, offset)
	return function(base) 
		return readByte(base + offset) 
	end
end

local function getWordValue(base, offset)
	return function(base) 
		return readWord(base + offset) 
	end
end

function profile.get() 
	return {
		{	
			name = {"kof96"},
			address = {
				player = 0x108100,
				space = 0x200
			},
			data = {
				side = getByteValue(base, 0x31),
				health = {
					value = getWordValue(base, 0x138), 
					max = 103, 
					x = getPositionX(playerNumber, 124, 169), 
					y = 21, 
					color = "white"
				},
				damage = {
					x = getPositionX(playerNumber, 105, 168),
					y = 49,
					color = "white",
					max = 500
				},
				guard = {
					value = getWordValue(base, 0x146), 
					max = 103, 
					x = getPositionX(playerNumber, 63, 222), 
					y = 41,
					color = "white",
					bar = {
						x = getPositionX(playerNumber, 84, 167), 
						y = 41,
						length = 52, 
						height = 6,
						fillColor = 0x00000040,
						outlineColor = 0x000000FF
					},
					bar2 = {
						x = getPositionX(playerNumber, 136, 167), 
						y = 41,
						fillColor = 0x2961DEEE,
						outlineColor = 0
					}
				},
				super = {
					value = getByteValue(base, 0x0E8), 
					max = 128, 
					x = getPositionX(playerNumber, 75, 218), 
					y = 205, 
					color = "white",
					timeout = {
						value = getByteValue(base, 0x0EA), 
						max = 64, 
						x = getPositionX(playerNumber, 75, 218), 
						y = 193, 
						color = "white"
					}
				},
				stun = {
					x = getPositionX(playerNumber, 105, 168), 
					y = 57, 
					value = getWordValue(base, 0x13E),
					color = "white",
					max = 103
				},
				inputs = {
					x = getPositionX(playerNumber, 49, 249),
					y = 72
				},
				record = {
					x = 134,
					y = 65,
					color = "red"
				},
				playback = {
					x = 138,
					y = 65,
					color = "green"
				}
			},
			cheats = {
				boss = {
					enabled = true,
					description = "Unlock Bosses",
					address = 0x10E752,
					value = 0x01
				},
				time = {
					enabled = true,
					description = "Infinite Time",
					address = 0x10A836,
					value = 0x60
				},
				health = {
					enabled = true,
					mode = "refill", -- Modes: "refill", "fixed"
					description = "Infinite Health",
					address = 0x138,
					value = 20,
					max = 103
				}
			}
		},
		{
			name = {"kof97"},
			address = {
				player = 0x108100,
				space = 0x200
			},
			data = {
				side = getByteValue(base, 0x31),
				health = {
					value = getWordValue(base, 0x138), 
					max = 103, 
					x = getPositionX(playerNumber, 124, 169), 
					y = 16, 
					color = "white"
				},
				damage = {
					x = getPositionX(playerNumber, 105, 168),
					y = 40,
					color = "white",
					max = 500
				},
				guard = {
					value = getWordValue(base, 0x146), 
					max = 103, 
					x = getPositionX(playerNumber, 63, 222), 
					y = 32,
					color = "white",
					bar = {
						x = getPositionX(playerNumber, 84, 167), 
						y = 32,
						length = 52, 
						height = 6,
						fillColor = 0x00000040,
						outlineColor = 0x000000FF
					},
					bar2 = {
						x = getPositionX(playerNumber, 136, 167), 
						y = 32,
						fillColor = 0x2961DEEE,
						outlineColor = 0
					}
				},
				super = {
					value = getByteValue(base, 0x0E8), 
					max = 128, 
					x = getPositionX(playerNumber, 84, 209), 
					y = 205, 
					color = "white",
					timeout = {
						value = getByteValue(base, 0x0EA), 
						max = 64, 
						x = getPositionX(playerNumber, 84, 209), 
						y = 199, 
						color = "white"
					}
				},
				stun = {
					x = getPositionX(playerNumber, 105, 168), 
					y = 48, 
					value = getWordValue(base, 0x13E),
					color = "white",
					max = 103
				},
				inputs = {
					x = getPositionX(playerNumber, 49, 249),
					y = 72
				},
				record = {
					x = 134,
					y = 56,
					color = "red"
				},
				playback = {
					x = 138,
					y = 56,
					color = "green"
				}
			},
			cheats = {
				time = {
					enabled = true,
					description = "Infinite Time",
					address = 0x10A83A,
					value = 0x60
				},
				health = {
					enabled = true,
					mode = "refill", -- Modes: "refill", "fixed"
					description = "Infinite Health",
					address = 0x138,
					value = 20,
					max = 103
				}
			}
		},
	}
end


return profile