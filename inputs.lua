local inputs = {}

local function getButtons(playerNumber)
	local side = "P" .. playerNumber .." "
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

local function inputDictionary(playerNumber)
	return {
		[0x01] = getButtons(playerNumber).up,
		[0x02] = getButtons(playerNumber).down,
		[0x04] = getButtons(playerNumber).left,
		[0x08] = getButtons(playerNumber).right,
		[0x10] = getButtons(playerNumber).a,
		[0x20] = getButtons(playerNumber).b,
		[0x40] = getButtons(playerNumber).c,
		[0x80] = getButtons(playerNumber).d
	}
end

local function getPlayerInputHex(playerNumber)
	local hex = 0
	for k, v in pairs(inputDictionary(playerNumber)) do
		if joypad.getdown()[v] then
			hex = bor(hex, k)
		end
	end
	return hex
end

local function getSecondPlayerInputRaw(playerNumber)
	local inputs = {}
	for k, v in pairs(inputDictionary(playerNumber)) do
		if joypad.getdown()[v] then
			inputs[inputDictionary(2)[k]] = true
		end
	end
	return inputs
end

function switchInput(inputs)
	local input = {}
	local key
	for k, v in pairs(inputs) do
		if fn.existsStr(k, "Left") then
			key = fn.replaceStr(k, "Left", "Right")
			input[key] = true
		elseif fn.existsStr(k, "Right") then
			key = fn.replaceStr(k, "Right", "Left")
			input[key] = true
		else
			input[k] = true
		end
	end
	return input
end

local function clearInputHistory(player)
	for i = 1, 10, 1 do 
		player.inputs.history[i] = -1
	end
end

local function getFrameInputsHistory(player)
	local current = player.inputs.current
	local previous = player.inputs.previous
	local history = player.inputs.history
	local frameCount = band(history[1], 0xFFFF)

	if current ~= previous then
		if frameCount > 100 then
			clearInputHistory(player)
		else
			for i = 10, 2, - 1 do
				history[i] = history[i - 1]
			end
		end
		history[1] = lShift(current, 16) + 1
	else
		if frameCount > 200 then
			history[1] = 1
		end
		history[1] = history[1] + 1
	end
	return history
end

local function getRecordInputs(player)
	local enabled = player.inputs.record.enabled
	local current = player.inputs.record.current
	local pNumber = player.number
	local recording = player.inputs.record.memory

	if enabled then
		ui.getRecordingText(player)
		player.inputs.record.side = player.side
		current = getSecondPlayerInputRaw(pNumber)
		if fn.isEmptyTable(current) then
			table.insert(recording, {-1})
		elseif not fn.isEmptyTable(current) then
			table.insert(recording, current)
		end
	end
	return recording
end

local function getPlaybackInputs(player)
	local playback = player.inputs.record.memory
	local enabled = player.inputs.playback.enabled
	local max = table.getn(playback)
	local index = player.inputs.record.index
	local side = player.inputs.record.side
	local inputs = {}

	if not fn.isEmptyTable(playback) then
		if enabled then
			ui.getPlaybackText(player)		
			if index == max then 
				player.inputs.record.index = 1
			elseif index <= max then
				if playback[index] ~= {-1} then
					if player.side == side then 
						inputs = switchInput(playback[index])
					else
						inputs = playback[index]
					end
				end
				player.inputs.record.index = index + 1
			end
		end
	end
	return inputs
end

function inputs.update(player)
	player.inputs.previous = player.inputs.current
	player.inputs.current = getPlayerInputHex(player.number)
	player.inputs.history = getFrameInputsHistory(player)
end

function inputs.record(player)
	player.inputs.record.memory = getRecordInputs(player)
end

function inputs.playback(player)
	joypad.set(getPlaybackInputs(player))
end

return inputs