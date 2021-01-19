local ui = {}

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

local function getInputOrientation(positionX, playerNumber)
	if (playerNumber == 1) then
		return positionX - 40
	else
		return positionX + 12
	end 	
end

local function drawText(x, y, value, color)
	return gui.text(
		x,
		y,
		value,
		color
	)
end

local function drawBar(x1, y1, x2, y2, fillColor, outlineColor)
	return gui.box(
		x1,
		y1,
		x2,
		y2,
		fillColor,
		outlineColor
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

local function guiTextAlignRight(x, y, text, color)
	local t = tostring(text)
	color = color or "white"
	gui.text(x - #t, y, t, color)
end

local function drawDpad(dpadX, dpadY, sideLength)
	gui.box(dpadX, dpadY, dpadX + (sideLength * 3), dpadY + sideLength, "black", "white")
	gui.box(dpadX + sideLength, dpadY - sideLength, dpadX + (sideLength * 2), dpadY + (sideLength * 2), "black", "white")
	gui.box(dpadX + 1, dpadY + 1, dpadX + (sideLength * 3) - 1, dpadY + sideLength - 1, "black")
end

local function drawInput(hex, x, y) -- Draws the dpad and buttons
	local buttonOffset = 0
	if bit.band(hex, 0x10) == 0x10 then --A
		gui.text(x + 12, y - 1, "A", "red")
		buttonOffset = buttonOffset + 6
	end
	if bit.band(hex, 0x20) == 0x20 then --B
		gui.text(x + 12 + buttonOffset, y - 1, "B", "yellow")
		buttonOffset = buttonOffset + 6
	end
	if bit.band(hex, 0x40) == 0x40 then --C
		gui.text(x + 12 + buttonOffset, y - 1, "C", "green")
		buttonOffset = buttonOffset + 6
	end
	if bit.band(hex, 0x80) == 0x80 then --S
		gui.text(x + 12 + buttonOffset, y - 1, "D", "blue")
	end
	if bit.band(hex, 0x0F) > 0 then
		drawDpad(x, y, 3)
	end
	if bit.band(hex, 0x01) == 0x01 then --Up
		gui.box(x + 4, y, x + 5, y - 2, "red")
	end
	if bit.band(hex, 0x02) == 0x02 then --Down
		gui.box(x + 4, y + 3, x + 5, y + 5, "red")
	end
	if bit.band(hex, 0x04) == 0x04 then --Left
		gui.box(x + 1, y + 1, x + 3, y + 2, "red")
	end
	if bit.band(hex, 0x08) == 0x08 then --Right
		gui.box(x + 6, y + 1, x + 8, y + 2, "red")
	end 
end

local function drawFrameInputs(player)
	x = player.game.data.inputs.x(player.number)
	y = player.game.data.inputs.y

	for i = 1, 10, 1 do
		local hex = player.inputs.history[i]
		if hex ~= -1 then
			local count = bit.band(0xFFFF, hex)
			local input = bit.rshift(hex, 16)
			guiTextAlignRight(x, y + (11 * i), count, "white")
			drawInput(input, getInputOrientation(x, player.number), y + 1 + (11 * i))
		end
	end
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

function ui.getInputs(playerData)
	drawFrameInputs(playerData)
end

return ui