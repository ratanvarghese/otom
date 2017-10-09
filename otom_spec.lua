--Using "busted" framework

expose("require otom", function()
	otom = require("otom")
	it("package.loaded", function()
		assert.truthy(package.loaded.otom)
	end)
	it("package is a table", function()
		assert.are.equals(type(otom), "table")
	end)
	it("otom.new is a function", function()
		assert.are.equals(type(otom.new), "function")
	end)
end)

describe("new with initial values", function()
	describe("valid", function()
		local ik = "initial key"
		local iv = "initial value"
		local ft, rt = otom.new{[ik]=iv}
		it("forward", function()
			assert.are.equals(ft[ik], iv)
		end)
		it("reverse", function()
			assert.are.equals(rt[iv], ik)
		end)
	end)

	describe("invalid", function()
		local ik_1 = "initial key"
		local ik_2 = "another key"
		local iv = "initial value"
		local init_table = {
			[ik_1] = iv,
			[ik_2] = iv
		}
		it("forward", function()
			assert.has_error(function()
				otom.new(init_table)
			end, "Initial table is not one-to-one.")
		end)
	end)
end)

describe("newindex", function()
	local ft, rt = otom.new()
	it("forward", function()
		local fk = "Forward key"
		local fv = "Forward value"
		ft[fk] = fv
		assert.are.equals(ft[fk], fv)
		assert.are.equals(rt[fv], fk)
	end)
	it("reverse", function()
		local rk = "Reverse key"
		local rv = "Reverse value"
		rt[rk] = rv
		assert.are.equals(rt[rk], rv)
		assert.are.equals(ft[rv], rk)
	end)
end)

describe("overwrite key", function()
	local ft, rt = otom.new()
	describe("forward", function()
		local fk = "Forward key"
		local fv_1 = "Forward value"
		local fv_2 = "Another forward value"
		ft[fk] = fv_1
		ft[fk] = fv_2
		it("transferred value", function()
			assert.are.equals(ft[fk], fv_2)
			assert.are.equals(rt[fv_2], fk)
		end)
		it("eliminated old value", function()
			assert.is_nil(rt[fv_1])
		end)
	end)
	describe("reverse", function()
		local rk = "Reverse key"
		local rv_1 = "Reverse value"
		local rv_2 = "Another reverse value"
		rt[rk] = rv_1
		rt[rk] = rv_2
		it("transferred value", function()
			assert.are.equals(rt[rk], rv_2)
			assert.are.equals(ft[rv_2], rk)
		end)
		it("eliminated old value", function()
			assert.is_nil(ft[rv_1])
		end)
	end)
end)

describe("overwrite value", function()
	local ft, rt = otom.new()
	describe("forward", function()
		local fk_1 = "Forward key"
		local fk_2 = "Another forward key"
		local fv = "Forward value"
		ft[fk_1] = fv
		ft[fk_2] = fv
		it("transferred value", function()
			assert.are.equals(ft[fk_2], fv)
			assert.are.equals(rt[fv], fk_2)
		end)
		it("eliminated old value", function()
			assert.is_nil(ft[fk_1])
		end)
	end)
	describe("reverse", function()
		local rk_1 = "Reverse key"
		local rk_2 = "Another reverse key"
		local rv = "Reverse value"
		rt[rk_1] = rv
		rt[rk_2] = rv
		it("transferred value", function()
			assert.are.equals(rt[rk_2], rv)
			assert.are.equals(ft[rv], rk_2)
		end)
		it("eliminated old value", function()
			assert.is_nil(rt[rk_1])
		end)
	end)
end)
