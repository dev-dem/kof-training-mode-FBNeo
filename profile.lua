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
					pos_X = getPositionX(playerNumber, 124, 169), 
					pos_Y = 21, 
					color = c.white
				},
				damage = {
					pos_X = getPositionX(playerNumber, 105, 168),
					pos_Y = 49
				},
				guard = {
					value = getWordValue(base, 0x146), 
					max = 103, 
					pos_X = getPositionX(playerNumber, 63, 222), 
					pos_Y = 41,
					bar = {
						pos_X = getPositionX(playerNumber, 84, 167), 
						pos_Y = 41,
						length = 52, 
						height = 6
					},
					bar2 = {
						pos_X = getPositionX(playerNumber, 136, 167), 
						pos_Y = 41
					},
					color = c.cyan
				},
				super = {
					value = getByteValue(base, 0x0E8), 
					max = 128, 
					pos_X = getPositionX(playerNumber, 75, 218), 
					pos_Y = 205, 
					color = c.white,
					timeout = {
						value = getByteValue(base, 0x0EA), 
						max = 64, 
						pos_X = getPositionX(playerNumber, 75, 218), 
						pos_Y = 193, 
						color = c.white
					}
				},
				stun = {
					pos_X = getPositionX(playerNumber, 105, 168), 
					pos_Y = 57, 
					value = getWordValue(base, 0x13E)
				},
			},
		},
		{
			games = {"kof97"},
		}
	}
end


return profile