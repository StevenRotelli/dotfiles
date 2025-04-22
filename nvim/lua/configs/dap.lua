-- lua/configs/dap.lua
local dap = require("dap")
local dapui = require("dapui")

require("dapui").setup()

require("mason-nvim-dap").setup({
  ensure_installed = { "python", "js-debug-adapter" },  -- node2 is dead
  automatic_setup = true,
})

require("mason-nvim-dap.setup_handlers")()

-- DAP UI auto-open/close
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

dap.adapters["pwa-node"] = {
  type = "server",
  host = "localhost",
  port = 9229,
  executable = {
    command = "js-debug-adapter",
    args = { "--port", "9229" },
  },
}

dap.configurations.javascript = {
  {
    name = "Attach to Next.js",
    type = "pwa-node",
    request = "attach",
    port = 9229,
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = "inspector",
    skipFiles = { "<node_internals>/**" },
  },
}

dap.configurations.typescript = dap.configurations.javascript

vim.keymap.set("n", "<F5>", function() dap.continue() end)
vim.keymap.set("n", "<F10>", function() dap.step_over() end)
vim.keymap.set("n", "<F11>", function() dap.step_into() end)
vim.keymap.set("n", "<F12>", function() dap.step_out() end)
vim.keymap.set("n", "<Leader>bp", function() dap.toggle_breakpoint() end)

vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint" })
vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition" })
vim.fn.sign_define("DapLogPoint", { text = "▶", texthl = "DapLogPoint" })
