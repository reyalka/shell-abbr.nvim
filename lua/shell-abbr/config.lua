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
				enabled = true,
			},
			["zsh-abbrev-alias"] = {
				enabled = false,
			},
		},
	},
}

return default_config
