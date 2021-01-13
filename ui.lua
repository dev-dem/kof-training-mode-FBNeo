local ui = {}

player = require 'player'

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

local function drawText(x, y, value, color)
	gui.text(
		x,
		y,
		value,
		color
	)
end

local function drawBar(x1, y1, x2, y2, fillColor, outlineColor)
	gui.box(
		x1,
		y1,
		x2,
		y2,
		fillColor,
		outlineColor
	)
end

local function getHealthText(health, game, playerNumber)
	return drawText(
		getConditionalPositionX(
			health.current, 
			game.health.x(playerNumber), 
			playerNumber
		),
		game.health.y, 
		health.current,
		game.health.color
	)
end

local function getGuardBar(game, playerNumber)
	return drawBar(
		game.guard.bar.x(playerNumber), 
		game.guard.bar.y, 
		game.guard.bar.x(playerNumber) + game.guard.bar.length, 
		game.guard.bar.y + game.guard.bar.height, 
		game.guard.bar.fillColor,
		game.guard.bar.outlineColor
	)
end

local function getGuardFillData(guard, game, playerNumber)
	return drawBar(
		game.guard.bar2.x(playerNumber), 
		game.guard.bar2.y, 
		getGuardOrientation(
			guard.current, 
			game.guard.bar2.x(playerNumber), 
			playerNumber
		), 
		game.guard.bar2.y + game.guard.bar.height, 
		game.guard.bar2.fillColor,
		game.guard.bar2.outlineColor
	)
end

local function getSuperText(super, game, playerNumber)
	if (super.value ~= game.super.max) then
		return drawText(
			getConditionalPositionX(
				super.value, 
				game.super.x(playerNumber), 
				playerNumber
			),
			game.super.y, 
			super.value,
			game.super.color
		)
	end
end

local function getSuperTimeoutText(super, game, playerNumber)
	if (super.value == game.super.max) and (super.timeout ~= 0)  then
		return drawText(
			getConditionalPositionX(
				super.timeout, 
				game.super.timeout.x(playerNumber), 
				playerNumber
			),
			game.super.timeout.y, 
			super.timeout,
			game.super.timeout.color
		)
	end
end

local function getCustomText(text, data, playerNumber)
	return drawText(
		data.x(playerNumber),
		data.y, 
		text,
		data.color
	)
end

function ui.getOSD(playerData)
	playerNumber = player.getNumber(playerData)
	data = player.getGameData(playerData)

	getHealthText(playerData.health, data, playerNumber)
	getGuardBar(data, playerNumber)
	getGuardFillData(playerData.guard, data, playerNumber)
	getCustomText("Guard", data.guard, playerNumber)
	getSuperText(playerData.super, data, playerNumber)
	getSuperTimeoutText(playerData.super, data, playerNumber)
	getCustomText("Stun:" .. playerData.stun.current, data.stun, playerNumber)
	getCustomText("Damage:" .. playerData.damage.hit, data.damage, playerNumber)
end

return ui