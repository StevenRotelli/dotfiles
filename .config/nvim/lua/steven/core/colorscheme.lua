-- local status, _ = pcall(vim.cmd, "colorscheme nightfly")
vim.cmd("colorscheme tokyonight")
-- local status, _ = pcall(vim.cmd, "colorscheme tokyonight")
-- if not status then
-- 	print("Colorscheme not found!")
-- 	return
-- end
local icons = require("nvim-web-devicons")
icons.setup({
	override_by_filename = {},
	override_by_extension = {
		["vbproj"] = {
			icon = "󰪮",
			color = "#00b9fb",
			name = "DevIconVBProject",
		},
		["vb"] = {
			-- icon = "ⱽᴮ",
			icon = "VB",
			color = "#a44cd3",
			name = "DevIconVb",
		},
	},
})
