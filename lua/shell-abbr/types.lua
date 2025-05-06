---@class ShellPluginConfig
---@field enabled boolean

---@class FishConfig
---@field enabled boolean
---@field filetype string

---@class ZshPluginsConfig
---@field ["zsh-abbr"] ShellPluginConfig
---@field ["zsh-abbrev-alias"] ShellPluginConfig

---@class ZshConfig
---@field filetype string
---@field plugins ZshPluginsConfig

---@class Config
---@field fish FishConfig
---@field zsh ZshConfig

---@class Abbreviation
---@field name string
---@field expansion string
