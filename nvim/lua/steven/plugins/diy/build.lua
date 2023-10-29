local M = {}

M.build_project = function()
	local cmd = 'msbuild /p:Configuration=Release /p:Platform="Any CPU" YourProject.csproj'
	vim.cmd("!" .. cmd)
end

vim.api.nvim_command("command! BuildProject :lua require('steven.build').build_project()")
return M
