local M = {}

local default_config = require("shell-abbr.config")
local validation = require("shell-abbr.utils.validation")
local cache = require("shell-abbr.utils.cache")

M.config = default_config

--- Setup shell abbreviations plugin with user configuration
--- @param user_config Config|nil User configuration to override defaults
function M.setup(user_config)
	-- Validate and normalize configuration
	local valid, err = validation.validate_config(user_config or {})
	if not valid then
		vim.notify("Shell-abbr configuration error: " .. err, vim.log.levels.ERROR)
		return
	end
	
	---@type Config
	M.config = validation.normalize_config(user_config, default_config)

	local group = vim.api.nvim_create_augroup("shell-abbr", { clear = true })

	-- Setup fish abbreviations
	if M.config.fish.enabled then
		local fish = require("shell-abbr.plugins.fish")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.fish.filetype,
			group = group,
			callback = function()
				local abbrs = fish.get_abbr_list()
				fish.apply_abbr(abbrs)
			end,
			desc = "Apply fish abbreviations"
		})
	end

	-- Setup zsh-abbr plugin
	if M.config.zsh.plugins["zsh-abbr"].enabled then
		local zsh_abbr = require("shell-abbr.plugins.zsh.zsh-abbr")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.zsh.filetype,
			group = group,
			callback = function()
				local abbrs = zsh_abbr.get_abbr_list()
				zsh_abbr.apply_abbr(abbrs)
			end,
			desc = "Apply zsh-abbr abbreviations"
		})
	end

	-- Setup zsh-abbrev-alias plugin
	if M.config.zsh.plugins["zsh-abbrev-alias"].enabled then
		local zsh_abbrev_alias = require("shell-abbr.plugins.zsh.zsh-abbrev-alias")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.zsh.filetype,
			group = group,
			callback = function()
				local abbrs = zsh_abbrev_alias.get_abbr_list()
				zsh_abbrev_alias.apply_abbr(abbrs)
			end,
			desc = "Apply zsh-abbrev-alias abbreviations"
		})
	end
end

--- Clear cached abbreviations (useful for debugging or refresh)
function M.clear_cache()
	cache.clear_cache()
	vim.notify("Shell abbreviation cache cleared", vim.log.levels.INFO)
end

--- Get cache statistics for debugging
--- @return table cache statistics
function M.get_cache_stats()
	return cache.get_cache_stats()
end

return M
