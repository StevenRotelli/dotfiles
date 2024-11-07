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
	keymap.set("n", "<F5>", require("dap").continue, dap_opts)
	keymap.set("n", "<F10>", require("dap").step_over, dap_opts)
	keymap.set("n", "<F11>", require("dap").step_into, dap_opts)
	keymap.set("n", "<F12>", require("dap").step_out, dap_opts)
	keymap.set("n", "<leader>b", require("dap").toggle_breakpoint, dap_opts)
	keymap.set("n", "<leader>B", function()
		require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
	end, dap_opts)
	keymap.set("n", "<leader>lp", function()
		require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
	end, dap_opts)
	keymap.set("n", "<leader>dr", require("dap").repl.open, dap_opts)
	keymap.set("n", "<leader>dl", require("dap").run_last, dap_opts)
	return nil
end

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
	local opts = { noremap = true, silent = true, buffer = bufnr }
	keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts) -- got to declaration
	keymap.set("n", "gd", "<cmd>peek_definition<CR>", opts) -- see definition and make edits in window
	keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
	keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts) -- see available code actions
	-- keymap.set("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	keymap.set("n", "<leader>rn", "<cmd>lua require('navigator.rename').rename()<CR>", opts) -- smart rename
	keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
	keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
	keymap.set("n", "[d", "<cmd>lua require('navigator.diagnostics').goto_prev()<CR>", opts) -- previous diagnostic
	keymap.set("n", "]d", "<cmd>lua require('navigator.diagnostics').goto_next()<CR>", opts) -- next diagnostic
	keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
	keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

	-- typescript specific keymaps (e.g. rename file and update imports)
	if client.name == "ts_ls" then
		keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
		keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
		keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
	end
	if client.name == "clangd" then
		vim.lsp.set_log_level("trace")
		dapkeys(opts)
	end
	if client.name == "omnisharp_mono" then
		print("foldmethod changed")
		-- vim.cmd("autocmd FileType csharp setlocal foldmethod=marker")
		vim.opt.foldmethod = "marker"
		vim.opt.foldmarker = "#region,#endregion"

		-- vim.api.nvim_create_autocmd("FileType", {
		-- 	pattern = "cs",
		-- 	callback = function()
		-- 		vim.opt_local.shiftwidth = 2
		-- 		vim.opt_local.tabstop = 2
		-- 		vim.opt_local.expandtab = true
		-- 	end,
		-- })
	end
	if client.name == "lksdafjlsdkjf" then
		-- if client.name == "omnisharp_mono" then
		-- vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
		vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
		keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
		keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
		keymap.set("n", "D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
		keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
		keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
		keymap.set("n", "<space>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
		keymap.set("n", "<space>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
		vim.api.nvim_buf_set_keymap(
			bufnr,
			"n",
			"<space>wl",
			"<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>",
			opts
		)
		keymap.set("n", "<space>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
		keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
		keymap.set("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

		keymap.set("n", "<leader>gi", function()
			local success, _ = pcall(vim.lsp.buf.implementation)
			if not success then
				print("Cannot navigate to disassembled view")
			end
		end, opts)
	else
		keymap.set("n", "<leader>gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	end
	vim.cmd(autocommands)
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

-- configure python flake8 server
lspconfig["jedi_language_server"].setup({
	capabilities = capabilities,
	on_attach = on_attach,
})
-- configure C++ server
lspconfig["clangd"].setup({
	cmd = { "clangd", "--log=verbose" },
	capabilities = capabilities,
	on_attach = on_attach,
})

-- configure omnisharp for VB.Net
-- lspconfig["omnisharp_roslyn"].setup({
-- cmd = {
-- 	"OmniSharp",
-- 	"--languageserver",
-- 	"--hostPID",
-- 	tostring(vim.fn.getpid()),
-- 	"--runtime",
-- 	"/Library/Frameworks/Mono.framework/Versions/Current/Commands/mono",
-- },
-- cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
-- capabilities = capabilities,
-- enable_roslyn_analyzers = true,
-- on_attach = on_attach,
-- filetypes = { "vb" }, -- Assuming C# files have the .cs extension
-- -- settings = {
-- 	OmniSharp = {
-- 		UseGlobalMono = "always",
-- 	},
-- },
-- })

-- configure omnisharp_mono for C#
lspconfig["omnisharp_mono"].setup({
	capabilities = capabilities,
	capabilities.semenaticTokensProvider == {
		full = vim.empty_dict(),
		legend = {
			tokenModifiers = { "static_symbol" },
			tokenTypes = {
				"comment",
				"excluded_code",
				"identifier",
				"keyword",
				"keyword_control",
				"number",
				"operator",
				"operator_overloaded",
				"preprocessor_keyword",
				"string",
				"whitespace",
				"text",
				"static_symbol",
				"preprocessor_text",
				"punctuation",
				"string_verbatim",
				"string_escape_character",
				"class_name",
				"delegate_name",
				"enum_name",
				"interface_name",
				"module_name",
				"struct_name",
				"type_parameter_name",
				"field_name",
				"enum_member_name",
				"constant_name",
				"local_name",
				"parameter_name",
				"method_name",
				"extension_method_name",
				"property_name",
				"event_name",
				"namespace_name",
				"label_name",
				"label_name",
				"xml_doc_comment_attribute_name",
				"xml_doc_comment_attribute_quotes",
				"xml_doc_comment_attribute_value",
				"xml_doc_comment_cdata_section",
				"xml_doc_comment_comment",
				"xml_doc_comment_delimiter",
				"xml_doc_comment_entity_reference",
				"xml_doc_comment_name",
				"xml_doc_comment_processing_instruction",
				"xml_doc_comment_text",
				"xml_literal_attribute_name",
				"xml_literal_attribute_quotes",
				"xml_literal_attribute_value",
				"xml_literal_cdata_section",
				"xml_literal_comment",
				"xml_literal_delimiter",
				"xml_literal_embedded_expression",
				"xml_literal_entity_reference",
				"xml_literal_name",
				"xml_literal_processing_instruction",
				"xml_literal_text",
				"regex_comment",
				"regex_character_class",
				"regex_anchor",
				"regex_quantifier",
				"regex_grouping",
				"regex_alternation",
				"regex_text",
				"regex_self_escaped_character",
				"regex_other_escape",
			},
		},
		range = true,
	},
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	on_attach = on_attach,
	filetypes = { "cs", "vb" },
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
