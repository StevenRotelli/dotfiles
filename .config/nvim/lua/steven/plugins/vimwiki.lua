local setup, wiki = pcall(require, "vimwiki")
if not setup then
	return
end

wiki.setup({
	init = function()
		-- vim.g.vimwiki_list = { { path = "~/Documents/wiki", syntax = "markdown", ext = ".md" } }
	end,
})
