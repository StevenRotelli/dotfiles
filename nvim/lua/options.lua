require "nvchad.options"

-- add yours here!

local o = vim.o
-- "<cmd> lua vim.lsp.buf.code_action()<CR>",
o.relativenumber = true
vim.opt.iskeyword:append "-"
o.cursorlineopt = "both" -- to enable cursorline!

-- code folding
o.foldmethod = "expr"
o.foldexpr = "nvim_treesitter#foldexpr()"
o.foldlevel = 99
