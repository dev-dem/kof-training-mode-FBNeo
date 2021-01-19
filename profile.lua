local profile = {}
local rb, rbs, rw, rws, rd, fc = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, emu.framecount

local c = { --colors
	bg            = {fill   = 0x00000040, outline  = 0x000000FF},
	stun_level    = {normal = 0xFF0000FF, overflow = 0xFFAAAAFF},
	stun_timeout  = {normal = 0xFFFF00FF, overflow = 0xFFA000FF},
	stun_duration = {normal = 0x00C0FFFF, overflow = 0xA0FFFFFF},
	stun_grace    = {normal = 0x00FF00FF, overflow = 0xFFFFFFFF},
	white  = 0xFFFFFFFF,
	green  = 0x00FF00FF,
	yellow = 0xFFFF00FF,
	pink   = 0xFFB0FFFF,
	gray   = 0xCCCCFFFF,
	cyan   = 0x00FFFFFF,
}

local function getPositionX(playerNumber, p1PositionX, p2PositionX)
	return function(playerNumber)
		if (playerNumber == 1) then
			return p1PositionX
		else
			return p2PositionX
		end
	end
end

local function getByteValue(base, offset)
	return function(base) 
		return rb(base + offset) 
	end
end

local function getWordValue(base, offset)
	return function(base) 
		return rw(base + offset) 
	end
end

function profile.get() 
	return {
		{	
			name = {"kof96"},
			address = {
				player = 0x108100,
				space = 0x200,
				phase = 0x10B08E
			},
			hitboxes_types = {
				v,v,v,v,v,v,v,v,g,g,v,a,a,a,a,a,
				a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,a,
				a,a,a,a,a,a,a,a,a,a,a,a,g,g,p,p,
				p,p,p,p
			}, 
			data = {
				health = {
					value = getWordValue(base, 0x138), 
					max = 103, 
					x = getPositionX(playerNumber, 124, 169), 
					y = 21, 
					color = c.white
				},
				damage = {
					x = getPositionX(playerNumber, 105, 168),
					y = 49,
					color = c.white
				},
				guard = {
					value = getWordValue(base, 0x146), 
					max = 103, 
					x = getPositionX(playerNumber, 63, 222), 
					y = 41,
					color = c.white,
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
					color = c.white,
					timeout = {
						value = getByteValue(base, 0x0EA), 
						max = 64, 
						x = getPositionX(playerNumber, 50, 218), 
						y = 193, 
						color = c.white
					}
				},
				stun = {
					x = getPositionX(playerNumber, 105, 168), 
					y = 57, 
					value = getWordValue(base, 0x13E),
					color = c.white
				},
				inputs = {
					x = getPositionX(playerNumber, 49, 249),
					y = 72
				}
			},
			cheats = {
				time = {
					address = 0x10A836,
					value = 0x60
				}
			}
		},
		{
			games = {"kof97"},
		}
	}
end


return profile