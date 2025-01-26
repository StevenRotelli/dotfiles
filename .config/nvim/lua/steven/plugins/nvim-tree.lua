local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

-- recommended setttings from nvim-tree documentation
vim.g.loaded = 1
vim.g.loaded_netrwPlugin = 1

vim.cmd([[highlight NvimTreeIndentMarker guifg=#D8DEE9]])
--vim.cmd([[ highlight NvimTreeIndentMarker guifg=#3FC5FF ]])

nvimtree.setup({
	renderer = {
		icons = {
			glyphs = {
				folder = {
					arrow_closed = "⮞",
					arrow_open = "⮟",
				},
			},
		},
	},
	actions = {
		-- rename = {
		-- 	enable = true,
		-- 	handler = function(src, dest)
		-- 		local git_root = vim.fn.system("git rev-parse --show-toplevel")
		-- 		if vim.v.shell_error == 0 then
		-- 			-- Use `git mv` for renaming
		-- 			local cmd = string.format("git mv %s %s", vim.fn.shellescape(src), vim.fn.shellescape(dest))
		-- 			os.execute(cmd)
		-- 			print("git mv")
		-- 		else
		-- 			-- Fallback to normal renaming
		-- 			os.rename(src, dest)
		-- 			print("mv")
		-- 		end
		-- 	end,
		-- },
		open_file = {
			window_picker = {
				enable = false,
			},
		},
	},
})
