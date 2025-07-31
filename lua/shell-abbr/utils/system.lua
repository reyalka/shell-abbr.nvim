--- Execute the appropriate system command with improved error handling
--- @param cmd string[] executable command
--- @return string|nil stdout output on success, nil on failure
--- @return string|nil error message on failure
local function system(cmd)
	if not cmd or #cmd == 0 then
		return nil, "Invalid command: empty or nil"
	end

	local has_vim_system = vim.fn.has("nvim-0.10") == 1

	if has_vim_system and vim.system then
		local ok, result = pcall(function()
			return vim.system(cmd, { timeout = 5000 }):wait()
		end)
		
		if not ok then
			return nil, "Failed to execute command: " .. tostring(result)
		end
		
		if result.code == 0 then
			return result.stdout or "", nil
		else
			return nil, "Command failed (exit code " .. result.code .. "): " .. (result.stderr or "")
		end
	else
		-- Fallback for older Neovim versions
		local command_str = table.concat(cmd, " ")
		local ok, result = pcall(vim.fn.system, command_str)
		
		if not ok then
			return nil, "Failed to execute command: " .. tostring(result)
		end
		
		local exit_code = vim.v.shell_error
		if exit_code == 0 then
			return result or "", nil
		else
			return nil, "Command failed (exit code " .. exit_code .. "): " .. (result or "")
		end
	end
end

return system
