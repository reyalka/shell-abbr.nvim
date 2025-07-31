--- Configuration validation utility
local M = {}

--- Validate fish configuration
--- @param fish_config FishConfig
--- @return boolean, string true if valid, false and error message if invalid
local function validate_fish_config(fish_config)
	if type(fish_config) ~= "table" then
		return false, "fish config must be a table"
	end
	
	if fish_config.enabled ~= nil and type(fish_config.enabled) ~= "boolean" then
		return false, "fish.enabled must be a boolean"
	end
	
	if fish_config.filetype ~= nil and type(fish_config.filetype) ~= "string" then
		return false, "fish.filetype must be a string"
	end
	
	if fish_config.filetype and fish_config.filetype == "" then
		return false, "fish.filetype cannot be empty"
	end
	
	return true, ""
end

--- Validate zsh plugin configuration
--- @param plugin_config ShellPluginConfig
--- @param plugin_name string
--- @return boolean, string true if valid, false and error message if invalid
local function validate_zsh_plugin_config(plugin_config, plugin_name)
	if type(plugin_config) ~= "table" then
		return false, "zsh plugin '" .. plugin_name .. "' config must be a table"
	end
	
	if plugin_config.enabled ~= nil and type(plugin_config.enabled) ~= "boolean" then
		return false, "zsh plugin '" .. plugin_name .. "'.enabled must be a boolean"
	end
	
	return true, ""
end

--- Validate zsh configuration
--- @param zsh_config ZshConfig
--- @return boolean, string true if valid, false and error message if invalid
local function validate_zsh_config(zsh_config)
	if type(zsh_config) ~= "table" then
		return false, "zsh config must be a table"
	end
	
	if zsh_config.filetype ~= nil and type(zsh_config.filetype) ~= "string" then
		return false, "zsh.filetype must be a string"
	end
	
	if zsh_config.filetype and zsh_config.filetype == "" then
		return false, "zsh.filetype cannot be empty"
	end
	
	if zsh_config.plugins then
		if type(zsh_config.plugins) ~= "table" then
			return false, "zsh.plugins must be a table"
		end
		
		-- Validate known plugins
		local known_plugins = { "zsh-abbr", "zsh-abbrev-alias" }
		for _, plugin_name in ipairs(known_plugins) do
			if zsh_config.plugins[plugin_name] then
				local valid, err = validate_zsh_plugin_config(zsh_config.plugins[plugin_name], plugin_name)
				if not valid then
					return false, err
				end
			end
		end
		
		-- Warn about unknown plugins
		for plugin_name, _ in pairs(zsh_config.plugins) do
			local is_known = false
			for _, known in ipairs(known_plugins) do
				if plugin_name == known then
					is_known = true
					break
				end
			end
			if not is_known then
				vim.notify("Warning: Unknown zsh plugin '" .. plugin_name .. "'", vim.log.levels.WARN)
			end
		end
	end
	
	return true, ""
end

--- Validate complete configuration
--- @param config Config User configuration to validate
--- @return boolean, string true if valid, false and error message if invalid
function M.validate_config(config)
	if type(config) ~= "table" then
		return false, "Configuration must be a table"
	end
	
	-- Validate fish config if present
	if config.fish then
		local valid, err = validate_fish_config(config.fish)
		if not valid then
			return false, "Fish configuration error: " .. err
		end
	end
	
	-- Validate zsh config if present
	if config.zsh then
		local valid, err = validate_zsh_config(config.zsh)
		if not valid then
			return false, "Zsh configuration error: " .. err
		end
	end
	
	return true, ""
end

--- Normalize configuration by filling in missing required fields
--- @param config Config User configuration
--- @param default_config Config Default configuration
--- @return Config normalized configuration
function M.normalize_config(config, default_config)
	local normalized = vim.tbl_deep_extend('force', {}, default_config, config or {})
	
	-- Ensure required nested structures exist
	if not normalized.fish then
		normalized.fish = vim.deepcopy(default_config.fish)
	end
	
	if not normalized.zsh then
		normalized.zsh = vim.deepcopy(default_config.zsh)
	end
	
	if not normalized.zsh.plugins then
		normalized.zsh.plugins = vim.deepcopy(default_config.zsh.plugins)
	end
	
	return normalized
end

return M