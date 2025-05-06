--- Execute the appropriate system command
--- @param cmd string[] executable command
local function system(cmd)
	local has_vim_system = vim.fn.has("nvim-0.10") == 1

	if has_vim_system and vim.system then
		local result = vim.system(cmd):wait()
		if result.code == 0 then
			return result.stdout
		else
			error("failed to run command\n" .. result.stderr)
		end
	else
		local result = vim.fn.system(cmd)
		print(result)
	end
end

return system
