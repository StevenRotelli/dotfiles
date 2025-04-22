require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set
-- "<cmd> lua vim.lsp.buf.code_action()<CR>",

map("n", "x", '"_x') --prevents copying into register when deleting
map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
-- map("n", "<Leader>bp", function() require("dap").toggle_breakpoint() end)
map("n", "<leader>sv", "<C-w>v") --split window vertically
-- map("n", "<leader>sh", "<C-w>s") --split window horizontally
map("n", "<leader>se", "<C-w>=") --make split windows eq width
map("n", "<leader>sx", ":close<CR>") -- close current split window
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
