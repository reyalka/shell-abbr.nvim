# shell-abbr.nvim

Neovim plugin to use abbr for fish/zsh users

## Config

### lazy.nvim

```lua
{
    "reyalka/shell-abbr.nvim",
    opts = {}
}
```

## Option

### default config

```lua
require("shell-abbr").setup({
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
})
```

### fish user

```lua
require("shell-abbr").setup({
  fish = {
    enabled = true,
  }
})
```

### zsh user

```lua
require("shell-abbr").setup({
  zsh = {
    plugins = {
      -- if using zsh-abbr
      ["zsh-abbr"] = {
        enabled = true,
      },
      -- if using zsh-abbrev-alias
      ["zsh-abbrev-alias"] = {
        enabled = true,
      },
    },
  },
})
```
