---@type Config
local default_config = {
	-- for fish users
	fish = {
	  -- if using fish built-in abbr
	  enabled = false,
	  -- custom filetype to enable the abbr feature
	  filetype = "fish",
	},
	-- for zsh users
	zsh = {
	  -- custom filetype to enable the abbr feature
	  filetype = "zsh",
	  plugins = {
		-- if using zsh-abbr
		["zsh-abbr"] = {
		  enabled = false,
		},
		-- if using zsh-abbrev-alias
		["zsh-abbrev-alias"] = {
		  enabled = false,
		},
	  },
	},
  }
  
  return default_config
  