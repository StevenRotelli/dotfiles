local function log(msg)
  --vim.cmd("echom '[DEBUG] " ..msg.. "'")
end
local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
    vim.cmd([[packadd packer.nvim]])
    return true
  end
  log("packer already installed.")
  return false
end

local packer_bootstrap = ensure_packer()

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

local status, packer = pcall(require, "packer")
if not status then
  log("Error loading packer!")
  return
end

log("Initiating packer startup")

return packer.startup(function(use)
  -- use("stevenrotelli/nvim-grooper")
  -- use("lunarmodules/luasql")
  use("wbthomason/packer.nvim")
  use("folke/tokyonight.nvim")         --preferred colors
  use("christoomey/vim-tmux-navigator") -- allows ctrl+h|j|K|l to navigate between splits
  use("szw/vim-maximizer")             --maximizes and resoures current window
  --TODO:READ ABOUT THESE 2
  use("tpope/vim-surround")
  use("vim-scripts/ReplaceWithRegister")

  use("numToStr/Comment.nvim") -- requires lua file, settings are located in ./plugins/comment.lua
  --USAGE
  --single line gcc, gcc to undo
  --comment multi gc#direction
  --example gc9j

  use("nvim-tree/nvim-tree.lua")     --requires lua file, file are located in ./plugins/nvim-tree.lua
  use("kyazdani42/nvim-web-devicons") --vscode style icons for nvim-tree
  use("nvim-lualine/lualine.nvim")   --statusline

  -- fuzzy finding w/ telescope
  use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" }) -- dependency for better sorting performance
  use({ "nvim-telescope/telescope.nvim" })                         -- fuzzy finder

  -- autocompletion
  use("hrsh7th/nvim-cmp")  -- completion plugin
  use("hrsh7th/cmp-buffer") -- source for text in buffer
  use("hrsh7th/cmp-path")  -- source for file system paths

  -- snippets
  use({ "L3MON4D3/LuaSnip", run = "make install_jsregexp" }) -- snippet engine
  use("saadparwaiz1/cmp_luasnip")                           -- for autocompletion
  use("rafamadriz/friendly-snippets")                       -- useful snippets

  -- managing & installing lsp servers, linters & formatters
  use("williamboman/mason.nvim")          -- in charge of managing lsp servers, linters & formatters
  use("williamboman/mason-lspconfig.nvim") -- bridges gap b/w mason & lspconfig

  use("ThePrimeagen/git-worktree.nvim")
  -- configuring lsp servers
  use("neovim/nvim-lspconfig") -- easily configure language servers
  use("hrsh7th/cmp-nvim-lsp") -- for autocompletion
  use({
    "ray-x/navigator.lua",
    requires = {
      { "ray-x/guihua.lua",     run = "cd lua/fzy && make" },
      { "neovim/nvim-lspconfig" },
    },
  })
  use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
  use("onsails/lspkind.nvim")              -- vs-code like icons for autocompletion

  -- formatting & linting
  use("nvim-lua/plenary.nvim")
  use({
    "jose-elias-alvarez/null-ls.nvim",
    requires = { "nvim-lua/plenary.nvim" },
  })                                -- configure formatters & linters

  use("jayp0521/mason-null-ls.nvim") -- bridges gap b/w mason & null-ls

  --DAP
  use({
    "rcarriga/nvim-dap-ui",
    requires = { "mfussenegger/nvim-dap" },
  })
  -- treesitter configuration
  use({
    "nvim-treesitter/nvim-treesitter",
    run = function()
      local ts_update = require("nvim-treesitter.install").update({ with_sync = true })
      ts_update()
    end,
  })

  use({
    "vimwiki/vimwiki",
    init = function() --replace 'config' with 'init'
      vim.g.vimwiki_list = { { path = "~/Documents/wiki", syntax = "markdown", ext = ".md" } }
    end,
  })

  -- auto closing
  use("windwp/nvim-autopairs")                                -- autoclose parens, brackets, quotes, etc...
  use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

  -- git integration
  use("lewis6991/gitsigns.nvim") -- show line modifications on left hand side

  --documentation plugin, primarily for c_sharp
  use({ "kkoomen/vim-doge", run = ":call doge#install()" })

  if packer_bootstrap then
    log("Runnign packer sync due to bootstrap")
    require("packer").sync()
  else
    log("Packer bootsrap not detected.")
  end
end)
