local M = {}

local default_config = require("shell-abbr.config")
M.config = default_config


function M.setup(user_config)
	---@type Config
	M.config = vim.tbl_deep_extend('force', {}, M.config, user_config or {})

	if M.config.fish.enabled then
		local fish = require("shell-abbr.plugins.fish")
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "fish",
			callback = function()
				fish.apply_abbr(fish.get_abbr_list())
			end
		})
	end
end

return M
