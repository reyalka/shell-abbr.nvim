# shell-abbr.nvim

A robust Neovim plugin that brings shell abbreviations from fish and zsh into your editor, providing seamless auto-completion for your favorite shell shortcuts.

## Features

- 🐠 **Fish shell** built-in abbreviation support
- 🚀 **Zsh-abbr** plugin integration
- ⚡ **Zsh-abbrev-alias** plugin support
- 🚀 **Performance optimized** with intelligent caching
- 🛡️ **Error resilient** with comprehensive validation
- 🔧 **Highly configurable** with sensible defaults

## Installation

### lazy.nvim

```lua
{
    "reyalka/shell-abbr.nvim",
    opts = {}
}
```

### packer.nvim

```lua
use {
    "reyalka/shell-abbr.nvim",
    config = function()
        require("shell-abbr").setup()
    end
}
```

## Configuration

### Default Configuration

```lua
require("shell-abbr").setup({
  -- Fish shell configuration
  fish = {
    -- Enable fish built-in abbreviations
    enabled = false,
    -- File type to activate abbreviations
    filetype = "fish",
  },
  -- Zsh shell configuration
  zsh = {
    -- File type to activate abbreviations
    filetype = "zsh",
    plugins = {
      -- zsh-abbr plugin support
      ["zsh-abbr"] = {
        enabled = false,
      },
      -- zsh-abbrev-alias plugin support
      ["zsh-abbrev-alias"] = {
        enabled = false,
      },
    },
  },
})
```

## Usage Examples

### Fish Users

Enable fish abbreviations:

```lua
require("shell-abbr").setup({
  fish = {
    enabled = true,
  }
})
```

### Zsh Users with zsh-abbr

```lua
require("shell-abbr").setup({
  zsh = {
    plugins = {
      ["zsh-abbr"] = {
        enabled = true,
      },
    },
  },
})
```

### Zsh Users with zsh-abbrev-alias

```lua
require("shell-abbr").setup({
  zsh = {
    plugins = {
      ["zsh-abbrev-alias"] = {
        enabled = true,
      },
    },
  },
})
```

### Advanced Configuration

```lua
require("shell-abbr").setup({
  fish = {
    enabled = true,
    filetype = "fish", -- or custom filetype
  },
  zsh = {
    filetype = "zsh", -- or custom filetype like "sh"
    plugins = {
      ["zsh-abbr"] = {
        enabled = true,
      },
      ["zsh-abbrev-alias"] = {
        enabled = true,
      },
    },
  },
})
```

## API

### Available Functions

```lua
local shell_abbr = require("shell-abbr")

-- Clear abbreviation cache (useful for refreshing)
shell_abbr.clear_cache()

-- Get cache statistics for debugging
local stats = shell_abbr.get_cache_stats()
print(vim.inspect(stats))
```

## Performance

The plugin includes intelligent caching to minimize shell command execution:

- **Cache TTL**: 5 minutes by default
- **Automatic invalidation**: Cache is automatically refreshed when expired
- **Per-shell caching**: Separate cache for each shell type and plugin

## Error Handling

The plugin gracefully handles various error conditions:

- **Missing shells**: Warns when required shells are not installed
- **Plugin unavailability**: Detects and reports missing zsh plugins
- **Command failures**: Provides detailed error messages for troubleshooting
- **Configuration errors**: Validates configuration and provides helpful feedback

## Troubleshooting

### Common Issues

1. **Shell not found**: Ensure the required shell (fish/zsh) is installed and in your PATH
2. **Plugin not working**: Verify that zsh plugins (zsh-abbr/zsh-abbrev-alias) are properly installed
3. **Abbreviations not appearing**: Check that the correct filetype is configured
4. **Performance issues**: Use `:lua print(vim.inspect(require("shell-abbr").get_cache_stats()))` to check cache status

### Debug Information

To get debug information about cache and configuration:

```lua
:lua print(vim.inspect(require("shell-abbr").get_cache_stats()))
```

## Requirements

- Neovim 0.8+ (0.10+ recommended for better performance)
- For fish support: fish shell installed
- For zsh support: zsh shell installed
- For zsh plugins: respective plugins (zsh-abbr, zsh-abbrev-alias) properly configured

## Contributing

Contributions are welcome! Please feel free to submit issues and pull requests.

## License

MIT License - see LICENSE file for details.
