require("mason-nvim-dap").setup({
  ensure_installed = { "python", "cppdbg" }, -- Add debuggers for your languages
  automatic_installation = true,
})
