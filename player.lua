local player = {}

function player.new(number)
	return  {
		number = number,
		side = 0,
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
			history = {-1},
			record = {
				enabled = false,
				memory = {},
				index = 1,
				side = 0,
				current = {}
			},
			playback = {
				enabled = false,
				memory = {},
				index = 1
			},
		},
		memory = {},
		memory2 = {}
	}
end

local function getBase(playerNumber, game)
	return game.address.player + (playerNumber - 1) * game.address.space
end

local function getDamage(player)
	local current = player.health.current
	local previous = player.health.previous
	local damage = player.damage.hit
	if (previous > current) then
		damage = math.abs(previous - current)
	end
	return damage
end

local function checkMaxValue(value, max)
	if value > max then
		value = 0
	end
	return value
end

function player.recoverLife(player)
	local data = player.game.data
	local base = getBase(player.number, player.game)
	local address = player.game.cheats.health.address
	local value = player.game.cheats.health.value
	local current = player.health.current 

	if current <= 20 then
		writeWord(base + address, value)
	end
end

function player.set(player, key, value)
	player[key] = value
end 

function player.getNumber(player)
	return player.number
end 

function player.getGameData(player)
	return player.game.data
end 

function player.update(player)
	local data = player.game.data
	local base = getBase(player.number, player.game)

	player.side = data.side(base)

	player.health.previous = player.health.current
	player.health.current = checkMaxValue(data.health.value(base), data.health.max)
	
	player.damage.hit = checkMaxValue(getDamage(player), data.damage.max)

	player.guard.previous = player.guard.current
	player.guard.current = data.guard.value(base)
	
	player.stun.previous = player.stun.current
	player.stun.current = checkMaxValue(data.stun.value(base), data.stun.max)

	player.super.value = data.super.value(base)
	player.super.timeout = data.super.timeout.value(base)
end

return player