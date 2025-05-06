---@type Config
local default_config = {
	fish = {
		enabled = true,
		filetype = "fish"
	},
	zsh = {
		filetype = "zsh",
		plugins = {
			["zsh-abbr"] = {
				enabled = false,
			},
			["zsh-abbrev-alias"] = {
				enabled = true,
			},
		},
	},
}

return default_config
