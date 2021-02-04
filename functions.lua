local fn = {}

function fn.isEmptyTable(table)
	if next(table) ~= nil then
		return false
	else
		return true
	end 
end

function fn.existsStr(str, find)
	if string.find(str, find) ~= nil then
		return true
	else
		return false
	end
end 

function fn.replaceStr(str, find, replace)
	return string.gsub(str, find, replace)
end 

function fn.printTable(table)
	for k, v in pairs(table) do
		if not fn.isEmptyTable(v) then
			for kk, vv in pairs(v) do
				print('\t', k, kk, vv)
			end
		else
			print('\t', k, v)
		end
	end
end

function fn.printSimpleTable(table)
	for k, v in pairs(table) do
		print('\t', k, v)
	end
end


return fn