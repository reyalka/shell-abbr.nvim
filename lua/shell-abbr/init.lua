local M = {}

local default_config = require("shell-abbr.config")
M.config = default_config


function M.setup(user_config)
	---@type Config
	M.config = vim.tbl_deep_extend('force', {}, M.config, user_config or {})

	if M.config.fish.enabled then
		local fish = require("shell-abbr.plugins.fish")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.fish.filetype,
			callback = function()
				fish.apply_abbr(fish.get_abbr_list())
			end
		})
	end

	if M.config.zsh.plugins["zsh-abbr"].enabled then
		local zsh = require("shell-abbr.plugins.zsh.zsh-abbr");
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.zsh.filetype,
			callback = function()
				zsh.apply_abbr(zsh.get_abbr_list())
			end
		})
	end

	if M.config.zsh.plugins["zsh-abbrev-alias"].enabled then
		local zsh = require("shell-abbr.plugins.zsh.zsh-abbrev-alias");
		vim.api.nvim_create_autocmd("FileType", {
			pattern = M.config.zsh.filetype,
			callback = function()
				zsh.apply_abbr(zsh.get_abbr_list())
			end
		})
	end
end

return M
