return {
  {
    "stevearc/conform.nvim",
    event = "BufWritePre", -- uncomment for format on save
    opts = require "configs.conform",
  },
  -- These are some examples, uncomment them if you want to see them work!
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "configs.lspconfig"
    end,
  },
  { "christoomey/vim-tmux-navigator" },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      require("lspsaga").setup {
        ui = {
          code_action = "!",
        },
        code_action_prompt = {
          enable = true,
        },
        code_action = {
          show_server_name = true,
          extend_gitsigns = true,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- optional
      "nvim-tree/nvim-web-devicons", -- for icons
    },
  },
  {
    "nvimtools/none-ls.nvim",
  },
  {
    "b0o/schemastore.nvim",
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = { "typescript" },
      },
      ensure_installed = {
        "vim",
        "lua",
        "vimdoc",
        "html",
        "css",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "json",
        "svelte",
        "markdown",
        "markdown_inline",
        "graphql",
        "gitignore",
        "bash",
        "dockerfile",
        "c_sharp",
        "comment",
        "jsdoc",
      },
    },
  },
  {
    "nvim-tree/nvim-tree.lua",
    config = function()
      require "configs.nvimtree"
    end,
  },
  {
    "mfussenegger/nvim-dap",
    config = function()
      require "configs.dap"
    end,
    dependencies = {
      "williamboman/mason.nvim",
      "rcarriga/nvim-dap-ui",
      "jay-babu/mason-nvim-dap.nvim",
      "nvim-neotest/nvim-nio",
    },
  },
}
