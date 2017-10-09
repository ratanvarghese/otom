local otom = {}

local function contrary_mt(fmt, rmt, finished_forward)
	fmt = fmt or {}
	rmt = rmt or {}
	fmt.storage = {}
	fmt.__index = fmt.storage
	fmt.__newindex = function(t, k, v)
		local old_v = fmt.storage[k]
		local old_k = rmt.storage[v]
		if old_v ~= nil then
			rmt.storage[old_v] = nil
		end
		if old_k ~= nil then
			fmt.storage[old_k] = nil
		end
		if k ~= nil then
			fmt.storage[k] = v
		end
		if v ~= nil then
			rmt.storage[v] = k
		end
	end
	fmt.__metatable = false
	if not finished_forward then
		contrary_mt(rmt, fmt, true)
	end
	return fmt, rmt
end

local function custom_pairs(mt)
	return function()
		return next, mt.storage, nil
	end
end

function otom.new(initial_table)
	local initial_table = initial_table or {}
	local forward, reverse = {}, {}
	fmt, rmt = contrary_mt()
	setmetatable(forward, fmt)
	setmetatable(reverse, rmt)

	for k,v in pairs(initial_table) do
		if reverse[v] ~= nil then
			error("Initial table is not one-to-one.")
		end
		forward[k] = v
	end
	return forward, reverse, custom_pairs(fmt), custom_pairs(rmt)
end

return otom
