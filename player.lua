local player = {}
local rb, rbs, rw, rws, rd, fc = memory.readbyte, memory.readbytesigned, memory.readword, memory.readwordsigned, memory.readdword, emu.framecount

function player.new(number)
	return  {
		number = number,
		health = { 
			current = 0,
			previous = 0 
		},
		guard = {
			current = 0,
			previous = 0
		},
		stun = {
			current = 0,
			previous = 0
		},
		super = {
			value = 0,
			timeout = 0
		},
		damage = { 
			hit = 0,
			combo = 0
		},
		inputs = {
			current = {},
			previous = {},
			history = {}
		},
		buttons = {},
		memory = {},
		memory2 = {}
	}
end

function player.set(player, key, value)
	player[key] = value
end

function player.get(player, key)
	return player[key]
end 

function player.getNumber(player)
	return player.number
end 

function player.getGameData(player)
	return player.game.data
end 

local function getBase(playerNumber, game)
	return game.address.player + (playerNumber - 1) * game.address.space
end

function player.update(player)
	data = player.game.data
	base = getBase(player.number, player.game)

	player.health.previous = player.health.current
	player.health.current = data.health.value(base)
	
	if (player.health.previous > player.health.current) then
		player.damage.hit = math.abs(player.health.previous - player.health.current)
	end

	player.guard.previous = player.guard.current
	player.guard.current = data.guard.value(base)
	
	player.stun.previous = player.stun.current
	player.stun.current = data.stun.value(base)

	player.super.value = data.super.value(base)
	player.super.timeout = data.super.timeout.value(base)
end

return player