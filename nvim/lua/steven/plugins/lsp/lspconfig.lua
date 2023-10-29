-- import lspconfig plugin safely
local lspconfig_status, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status then
	return
end

-- import cmp-nvim-lsp plugin safely
local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not cmp_nvim_lsp_status then
	return
end

-- import typescript plugin safely
local typescript_setup, typescript = pcall(require, "typescript")
if not typescript_setup then
	return
end

local keymap = vim.keymap -- for conciseness

local function dapkeys(dap_opts)
	vim.keymap.set("n", "<F5>", require("dap").continue, dap_opts)
	vim.keymap.set("n", "<F10>", require("dap").step_over, dap_opts)
	vim.keymap.set("n", "<F11>", require("dap").step_into, dap_opts)
	vim.keymap.set("n", "<F12>", require("dap").step_out, dap_opts)
	vim.keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, dap_opts)
	vim.keymap.set("n", "<leader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, dap_opts)
	vim.keymap.set("n", "<leader>lp", function()
		require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, dap_opts)
	vim.keymap.set("n", "<leader>dr", require("dap").repl.open, dap_opts)
	vim.keymap.set("n", "<leader>dl", require("dap").run_last, dap_opts)
	return nil
end

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	-- keybind options
	local opts = { noremap = true, silent = true, buffer = bufnr }

	-- set keybinds
	keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
	keymap.set("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
	keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
	keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "tsserver" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
	if client.name == "clangd" then
		print("clangd detected")
		vim.lsp.set_log_level("trace")
		dapkeys(opts)
	end
	-- if client.name == "omnisharp_mono" then
	-- 	print("omnisharp_mono detected!")
	-- 	vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
	-- 	keymap.set("n", "<leader>gi", function()
	-- 		local success, _ = pcall(vim.lsp.buf.implementation)
	-- 		if not success then
	-- 			print("Cannot navigate to disassembled view")
	-- 		end
	-- 	end, opts)
	-- else
	-- 	keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	-- end
end

-- used to enable autocompletion (assign to every lsp server config)
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
	local hl = "DiagnosticSign" .. type
	vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- configure html server
lspconfig["html"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
	server = {
		capabilities = capabilities,
		on_attach = on_attach,
	},
})

-- configure css server
lspconfig["cssls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["tailwindcss"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})

lspconfig["clangd"].setup({
	cmd = { "clangd", "--log=verbose" },
	capabilities = capabilities,
	on_attach = on_attach,
})
-- configure omnisharp for C#
-- lspconfig["omnisharp"].setup({
-- 	cmd = {
-- 		"OmniSharp",
-- 		"--languageserver",
-- 		"--hostPID",
-- 		tostring(vim.fn.getpid()),
-- 		"--runtime",
-- 		"/Library/Frameworks/Mono.framework/Versions/Current/Commands/mono",
-- 	},
-- 	-- cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
-- 	capabilities = capabilities,
-- 	on_attach = on_attach,
-- 	filetypes = { "cs" }, -- Assuming C# files have the .cs extension
-- 	settings = {
-- 		OmniSharp = {
-- 			UseGlobalMono = "always",
-- 		},
-- 	},
-- })
--
-- configure omnisharp_mono for C#
lspconfig["omnisharp_mono"].setup({
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	on_attach = on_attach,
	filetypes = { "cs", "vb" },
	-- cmd = {
	-- 	"OmniSharp",
	-- 	"--languageserver",
	-- 	"--hostPID",
	-- 	tostring(vim.fn.getpid()),
	-- 	"--runtime",
	-- 	"/Library/Frameworks/Mono.framework/Versions/Current/Commands/mono",
	-- },
	-- -- cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
	-- capabilities = capabilities,
	-- on_attach = on_attach,
	-- filetypes = { "cs" }, -- Assuming C# files have the .cs extension
	-- settings = {
	-- 	OmniSharp = {
	-- 		UseGlobalMono = "always",
	-- 	},
	-- },
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	filetypes = { "html", "typescriptreact", "javascriptreact", "css", "sass", "scss", "less", "svelte" },
})

-- configure lua server (with special settings)
lspconfig["lua_ls"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
	settings = { -- custom settings for lua
		Lua = {
			-- make the language server recognize "vim" global
			diagnostics = {
				globals = { "vim" },
			},
			workspace = {
				-- make language server aware of runtime files
				library = {
					[vim.fn.expand("$VIMRUNTIME/lua")] = true,
					[vim.fn.stdpath("config") .. "/lua"] = true,
				},
			},
		},
	},
})
