-- load defaults i.e lua_lsp
require("nvchad.configs.lspconfig").defaults()

local lspconfig = require "lspconfig"

-- EXAMPLE
local servers = {
  "ts_ls",
  "html",
  "cssls",
  "tailwindcss",
  "lua_ls",
  "emmet_ls",
  "omnisharp",
}

local nvlsp = require "nvchad.configs.lspconfig"
local capabilities = require("cmp_nvim_lsp").default_capabilities()
local which_key = require "which-key"

local function custom_on_attach(client, bufnr)
  nvlsp.on_attach(client, bufnr)
  which_key.add({
    "<leader>ca",
    "<cmd>Lspsaga code_action<CR>",
    mode = "n",
    buffer = bufnr,
    desc = "Code Actions (Saga)",
  }, {
    "<leader>pd",
    "<cmd>Lspsaga peek_definition<CR>",
    mode = "n",
    buffer = bufnr,
    desc = "Peek Definition(Saga)",
  })
end
-- lsps with default config
for _, lsp in ipairs(servers) do
  lspconfig[lsp].setup {
    on_attach = custom_on_attach(),
    on_init = nvlsp.on_init,
    capabilities = nvlsp.capabilities,
  }
end

lspconfig.eslint.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr) -- keep NVChad's on_attach behavior
    client.server_capabilities.documentFormattingProvider = false -- let conform handle formatting
    client.server_capabilities.codeActionProvider = true
  end,
  capabilities = capabilities,
  settings = {
    codeActionsOnSave = {
      enable = true,
    },
    experimental = {
      useFlatConfig = true,
    },
  },
}

-- configuring single server, example: typescript
lspconfig.ts_ls.setup {
  on_attach = custom_on_attach(),
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
}

lspconfig.jsonls.setup {
  on_attach = custom_on_attach(),
  capabilities = capabilities,
  settings = {
    json = {
      schemas = require("schemastore").json.schemas(),
      validate = { enable = true },
    },
  },
}

-- lspconfig.biome.setup {
--   cmd = { "biome", "lsp-proxy" },
--   filetypes = { "json", "jsonc" },
--   root_dir = lspconfig.util.root_pattern("biome.json", ".git"),
--   capabilities = require("cmp_nvim_lsp").default_capabilities(),
-- }
