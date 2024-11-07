-- dap.lua
local dap_status, dap = pcall(require, "dap")
if not dap_status then
	return
end

-- Setting up DAP for C++
dap.adapters.lldb = {
	type = "executable",
	command = "lldb-vscode", -- Update this if your path is different
	name = "lldb",
}

dap.configurations.cpp = {
	{
		name = "Launch",
		type = "lldb",
		request = "launch",
		program = function()
			return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
		end,
		cwd = "${workspaceFolder}",
		stopOnEntry = false,
		args = {},
	},
}

-- dap-ui configuration
local dap_ui_status, dapui = pcall(require, "dapui")
if dap_ui_status then
	dapui.setup()
end

-- You can also place key mappings related to dap here if you prefer
-- ...
