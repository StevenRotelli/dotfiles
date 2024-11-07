-- local luacpath = "~/.luarocks/lib/lua/5.1/?.so;~/.luarocks/lib/luarocks/rocks-5.1/?.so"
-- local luapath = "~/.luarocks/share/lua/5.1/?.lua"
-- package.path = package.path .. ";" .. luapath
-- package.cpath = package.cpath .. ";" .. luacpath

-- ~/.config/nvim/lua/setup_rocks.lua

local home = os.getenv("HOME")

if home == nil then
	return
end

local path = table.concat({
	"/usr/share/lua/5.1/?.lua",
	"/usr/share/lua/5.1/?/init.lua",
	"/usr/lib/lua/5.1/?.lua",
	"/usr/lib/lua/5.1/?/init.lua",
	"./?.lua",
	"./?/init.lua",
	home .. "/.luarocks/share/lua/5.1/?.lua",
	home .. "/.luarocks/share/lua/5.1/?/init.lua",
}, ";")

local cpath = table.concat({
	"/usr/lib/lua/5.1/?.so",
	"/usr/lib/lua/5.1/loadall.so",
	"./?.so",
	home .. "/.luarocks/lib/lua/5.1/?.so",
}, ";")
package.path = package.path .. ";" .. path
package.cpath = package.cpath .. ";" .. cpath
