vim.g.mapleader = " "

local keymap = vim.keymap --for concisness

--general keymaps

keymap.set("i", "jk", "<ESC>") --custom escape
keymap.set("n", "<leader>nh", ":nohl<CR>") --clear search results
keymap.set("n", "x", '"_x') --prevents copying into register when deleting

keymap.set("n", "<leader>+", "<C-a>") -- leader plus to increment numbers
keymap.set("n", "<leader>-", "<C-x>") -- leader minus to decrement numbers

keymap.set("n", "<leader>sv", "<C-w>v") --split window vertically
keymap.set("n", "<leader>sh", "<C-w>s") --split window horizontally
keymap.set("n", "<leader>se", "<C-w>=") --make split windows eq width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split window

keymap.set("n", "<leader>to", ":tabnew<CR>") --open new tab
keymap.set("n", "<leader>tx", ":tabclose<CR>") --close current tab
keymap.set("n", "<leader>tn", ":tabn<CR>") --go to next tab
keymap.set("n", "<leader>tp", ":tabp<CR>") --go to previous tab

--plugin keymaps
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>") --vim maximizer
keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>") --NvimTree

-- telescope
keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>") -- find files within current working directory, respects .gitignore
keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>") -- find string in current working directory as you type
keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>") -- find string under cursor in current working directory
keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>") -- list open buffers in current neovim instance
keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<cr>") -- list available help tags

--vim-doge
-- keymap.set("n", "<leader>d", "<Plug>")
--vim-dap

keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>") -- show definition, references
keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>") -- got to declaration
keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>") -- see definition and make edits in window
keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>") -- go to implementation
keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>")
keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>") -- smart rename
keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>") -- show  diagnostics for line
keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>") -- show diagnostics for cursor
keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>") -- jump to previous diagnostic in buffer
keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>") -- jump to next diagnostic in buffer
keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>") -- show documentation for what is under cursor
keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>") -- see outline on right hand side
