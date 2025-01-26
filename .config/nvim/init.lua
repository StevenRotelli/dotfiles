-- require("steven.plugins.setup_luarocks")
require("steven.plugins")
require("steven.core.options")
require("steven.core.keymaps")
require("steven.autocommands")
require("steven.core.colorscheme")
require("steven.plugins.comment")
require("steven.plugins.nvim-tree")
require("steven.plugins.lualine")
require("steven.plugins.telescope")
require("steven.plugins.nvim-cmp")
require("steven.plugins.lsp.mason")
require("steven.plugins.lsp.lspconfig")
require("steven.plugins.lsp.null-ls")
require("steven.plugins.autopairs")
require("steven.plugins.treesitter")
require("steven.plugins.git-worktree")
require("steven.plugins.gitsigns")
-- require("steven.plugins.dap")
require("steven.plugins.lsp.navigator")
require("steven.plugins.vimwiki")
require("steven.plugins.remote")
-- require("luasql.odbc")
vim.cmd("autocmd BufRead,BufNewFile *.mustache set filetype=handlebars")
