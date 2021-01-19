local inputs = {}

local colors = {
	menuBackground = 0x36393FFF,
	menuTitle = 0xB1B3B6FF,
	menuSelectedMin = { 43, 156, 255 }, --0x2B9CFFFF,
	menuSelectedMax = { 37, 134, 219 }, --0x2586DBFF,
	menuUnselected = "white",
	menuBorder = 0x202225FF,
	dpadBack = "black", --0x55CDFCFF,
	dpadBorder = "white", --0xFFFFFFFF,
	dpadActive = "red", --0xF7A8B8FF,
	orangebox = 0xFF800000,
	wakeupIndicator = 0xFBA400FF,
	wakeupBorder = 0xFFFFFF00
}

function inputs.getButtons(playerNumber)
	side = "P" .. playerNumber .." "
	return {
		start = side .. "Start",
		coin = side .. "Coin",
		up = side .. "Up",
		down = side .. "Down",
		left = side .. "Left",
		right = side .. "Right",
		a = side .. "Button A",
		b = side .. "Button B",
		c = side .. "Button C",
		d = side .. "Button D"
	}
end

local function inputDictionary(player)
	return {
		[0x01] = player.buttons.up,
		[0x02] = player.buttons.down,
		[0x04] = player.buttons.left,
		[0x08] = player.buttons.right,
		[0x10] = player.buttons.a,
		[0x20] = player.buttons.b,
		[0x40] = player.buttons.c,
		[0x80] = player.buttons.d
	}
end


local function getPlayerInputHex(player)
	local hex = 0
	for k, v in pairs(inputDictionary(player)) do
		if joypad.read()[v] then
			hex = bit.bor(hex, k)
		end
	end
	return hex
end

local function clearInputHistory(player)
	for i = 1, 10, 1 do 
		player.inputs.history[i] = -1
	end
end

local function updateFrameHistory(player)
	if player.inputs.current ~= player.inputs.previous then
		if bit.band(player.inputs.history[1], 0xFFFF) > 100 then
			clearInputHistory(player)
		else
			for i = 10, 2, - 1 do
				player.inputs.history[i] = player.inputs.history[i - 1]
			end
		end
		player.inputs.history[1] = bit.lshift(player.inputs.current, 16) + 1
	else
		if bit.band(player.inputs.history[1], 0xFFFF) > 100 then
			player.inputs.history[1] = 1
		end
		player.inputs.history[1] = player.inputs.history[1] + 1
	end
end

function inputs.getAll()
	return joypad.read()
end

function inputs.getPressed()
	return joypad.getdown()
end

function inputs.update(player)
	player.inputs.previous = player.inputs.current
	player.inputs.current = getPlayerInputHex(player)
	updateFrameHistory(player)
	ui.getInputs(player)
end

return inputs