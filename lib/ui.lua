local ui = {}

local function getConditionalPositionX(value, positionX, playerNumber)
	local x = 0
	if (playerNumber == 1) then 
		if (value >= 0) and (value <= 9) then
			x = positionX + 8
		elseif (value >= 10) and (value <= 99) then
			x = positionX + 4
		elseif (value >= 100) then
			x = positionX
		end
	else
		x = positionX
	end
	return x
end

local function getGuardOrientation(value, positionX, playerNumber)
 	local x = 0
	if (playerNumber == 1) then
		x = positionX - value * 0.5
	else
		x = positionX + value * 0.5 + 1
	end 
	return x
end

local function getInputOrientation(positionX, playerNumber)
	local x = 0
	if (playerNumber == 1) then
		x = positionX - 40
	else
		x = positionX + 12
	end
	return x 	
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

local function drawTextAlignRight(x, y, text, color)
	local t = tostring(text)
	color = color or "white"
	gui.text(x - #t, y, t, color)
end

local function drawDpad(dpadX, dpadY, sideLength)
	gui.box(
		dpadX, 
		dpadY, 
		dpadX + (sideLength * 3), 
		dpadY + sideLength, 
		"black", 
		"white"
	)
	gui.box(
		dpadX + sideLength, 
		dpadY - sideLength, 
		dpadX + (sideLength * 2), 
		dpadY + (sideLength * 2), 
		"black", 
		"white"
	)
	gui.box(
		dpadX + 1, 
		dpadY + 1, 
		dpadX + (sideLength * 3) - 1, 
		dpadY + sideLength - 1, 
		"black"
	)
end

local function drawInput(hex, x, y) -- Draws the dpad and buttons
	local buttonOffset = 0
	if band(hex, 0x10) == 0x10 then --A
		drawText(x + 12, y - 1, "A", "red")
		buttonOffset = buttonOffset + 6
	end
	if band(hex, 0x20) == 0x20 then --B
		drawText(x + 12 + buttonOffset, y - 1, "B", "yellow")
		buttonOffset = buttonOffset + 6
	end
	if band(hex, 0x40) == 0x40 then --C
		drawText(x + 12 + buttonOffset, y - 1, "C", "green")
		buttonOffset = buttonOffset + 6
	end
	if band(hex, 0x80) == 0x80 then --D
		drawText(x + 12 + buttonOffset, y - 1, "D", "blue")
	end
	if band(hex, 0x0F) > 0 then
		drawDpad(x, y, 3)
	end
	if band(hex, 0x01) == 0x01 then --Up
		drawBar(x + 4, y, x + 5, y - 2, "red")
	end
	if band(hex, 0x02) == 0x02 then --Down
		drawBar(x + 4, y + 3, x + 5, y + 5, "red")
	end
	if band(hex, 0x04) == 0x04 then --Left
		drawBar(x + 1, y + 1, x + 3, y + 2, "red")
	end
	if band(hex, 0x08) == 0x08 then --Right
		drawBar(x + 6, y + 1, x + 8, y + 2, "red")
	end 
end

local function drawFrameInputs(player)
	local x = player.game.data.inputs.x(player.number)
	local y = player.game.data.inputs.y

	for i = 1, 10, 1 do
		local hex = player.inputs.history[i]
		if hex ~= -1 then
			local count = band(0xFFFF, hex)
			local input = rShift(hex, 16)
			drawTextAlignRight(x, y + (11 * i), count, "white")
			drawInput(input, getInputOrientation(x, player.number), y + 1 + (11 * i))
		end
	end
end

function ui.getOSD(playerData)
	local playerNumber = player.getNumber(playerData)
	local data = player.getGameData(playerData)

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

function ui.getRecordingText(playerData)
	local data = player.getGameData(playerData)
	drawText(
		data.record.x, 
		data.record.y, 
		"Recording", 
		data.record.color
	)
end

function ui.getPlaybackText(playerData)
	local data = player.getGameData(playerData)
	drawText(
		data.playback.x, 
		data.playback.y, 
		"Playing", 
		data.playback.color
	)
end

return ui