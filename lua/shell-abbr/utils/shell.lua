--- Shell availability and validation utilities
local system = require("shell-abbr.utils.system")

local M = {}

--- Check if a shell command is available on the system
--- @param shell_name string Name of the shell to check
--- @return boolean true if shell is available, false otherwise
function M.is_shell_available(shell_name)
	if not shell_name or shell_name == "" then
		return false
	end
	
	local output, err = system({ "which", shell_name })
	return err == nil and output ~= ""
end

--- Check if a specific zsh plugin command is available
--- @param plugin_cmd string The plugin command to check
--- @return boolean true if plugin command is available, false otherwise
function M.is_zsh_plugin_available(plugin_cmd)
	if not plugin_cmd or plugin_cmd == "" then
		return false
	end
	
	-- Try to run the plugin command with zsh to see if it exists
	local output, err = system({ "zsh", "-i", "-c", "command -v " .. plugin_cmd })
	return err == nil and output ~= ""
end

--- Validate shell configuration before attempting to use it
--- @param shell_type string Type of shell ("fish" or "zsh")
--- @param plugin_name string|nil Name of zsh plugin if applicable
--- @return boolean, string true and empty string if valid, false and error message if invalid
function M.validate_shell_config(shell_type, plugin_name)
	if shell_type == "fish" then
		if not M.is_shell_available("fish") then
			return false, "Fish shell is not available on this system"
		end
		return true, ""
	elseif shell_type == "zsh" then
		if not M.is_shell_available("zsh") then
			return false, "Zsh shell is not available on this system"
		end
		
		if plugin_name then
			local plugin_cmd_map = {
				["zsh-abbr"] = "abbr",
				["zsh-abbrev-alias"] = "abbrev-alias"
			}
			
			local cmd = plugin_cmd_map[plugin_name]
			if cmd and not M.is_zsh_plugin_available(cmd) then
				return false, "Zsh plugin '" .. plugin_name .. "' is not available or properly configured"
			end
		end
		return true, ""
	else
		return false, "Unsupported shell type: " .. tostring(shell_type)
	end
end

return M