local ui = {}


local function screenWidth()
	return emu.screenwidth()
end

local function screenHeight()
	return emu.screenheight()
end

local function getConditionalPositionX(value, positionX, playerNumber)
	if (playerNumber == 1) then 
		if (value >= 0) and (value <= 9) then
			return positionX + 8
		elseif (value >= 10) and (value <= 99) then
			return positionX + 4
		elseif (value >= 100) then
			return positionX
		end
	else
		return positionX
	end
end

local function getGuardOrientation(value, positionX, playerNumber)
	if (playerNumber == 1) then
		return positionX - value * 0.5
	else
		return positionX + value * 0.5 + 1
	end 
end

function ui.get(player)
	data = player.game.data
	playerNumber = player.number
	gui.text(
		getConditionalPositionX(player.health.current, data.health.pos_X(playerNumber), playerNumber),
		data.health.pos_Y, 
		player.health.current,
		data.health.color
	)
	gui.box(
		data.guard.bar.pos_X(playerNumber), 
		data.guard.bar.pos_Y, 
		data.guard.bar.pos_X(playerNumber) + data.guard.bar.length, 
		data.guard.bar.pos_Y + data.guard.bar.height, 
		0x00000040,
		0x000000FF
	)
	gui.box(
		data.guard.bar2.pos_X(playerNumber), 
		data.guard.bar2.pos_Y, 
		getGuardOrientation(player.guard.current, data.guard.bar2.pos_X(playerNumber), playerNumber), 
		data.guard.bar2.pos_Y + data.guard.bar.height, 
		0x2961DEEE,
		0
	)
	gui.text(
		data.guard.pos_X(playerNumber),
		data.guard.pos_Y, 
		"Guard"
	)
	if (player.super.value ~= data.super.max) then
		gui.text(
			getConditionalPositionX(player.super.value, data.super.pos_X(playerNumber), playerNumber),
			data.super.pos_Y, 
			player.super.value,
			data.super.color
		)
	end
	if (player.super.value == data.super.max) and (player.super.timeout ~= 0)  then
		gui.text(
			getConditionalPositionX(player.super.timeout, data.super.timeout.pos_X(playerNumber), playerNumber),
			data.super.timeout.pos_Y, 
			player.super.timeout,
			data.super.timeout.color
		)
	end
	gui.text(
		data.stun.pos_X(playerNumber),
		data.stun.pos_Y, 
		"Stun:"..player.stun.current
	)
	gui.text(
		data.damage.pos_X(playerNumber),
		data.damage.pos_Y, 
	    "Damage:"..player.damage.hit
	)
end

return ui