local M = {}
local system = require("shell-abbr.utils.system")
local cache = require("shell-abbr.utils.cache")
local shell_utils = require("shell-abbr.utils.shell")

--- Parse a zsh-abbrev-alias line into {name, expansion} format
--- @param line string Line to parse
--- @return table|nil Parsed abbreviation or nil if invalid
local function parse_abbr_line(line)
	-- name='expansion'
	local name, expansion = line:match([[^(.-)='(.-)'$]])
	if name and expansion then
		return {
			name = name,
			expansion = expansion,
		}
	end
	return nil
end

--- Parse zsh-abbrev-alias output into structured data
--- @param input string Raw abbrev-alias command output
--- @return Abbreviation[] Array of parsed abbreviations
local function parse_abbrs(input)
	local result = {}
	
	if not input or input == "" then
		return result
	end

	for line in input:gmatch("[^\r\n]+") do
		local abbr = parse_abbr_line(line)
		if abbr then
			table.insert(result, abbr)
		end
	end

	return result
end

--- Get list of zsh-abbrev-alias abbreviations with caching support
--- @param use_cache boolean|nil Whether to use cache (default: true)
--- @return Abbreviation[] Array of abbreviations
function M.get_abbr_list(use_cache)
	use_cache = use_cache ~= false -- Default to true
	
	-- Check cache first
	if use_cache then
		local cached = cache.get_cached_abbrs("zsh", "zsh-abbrev-alias")
		if cached then
			return cached
		end
	end
	
	-- Validate zsh and plugin availability
	local valid, err = shell_utils.validate_shell_config("zsh", "zsh-abbrev-alias")
	if not valid then
		vim.notify("Zsh-abbrev-alias unavailable: " .. err, vim.log.levels.ERROR)
		return {}
	end
	
	-- Get abbreviations from zsh-abbrev-alias
	local output, error_msg = system({ "zsh", "-i", "-c", "abbrev-alias" })
	if error_msg then
		vim.notify("Failed to get zsh-abbrev-alias abbreviations: " .. error_msg, vim.log.levels.ERROR)
		return {}
	end
	
	local abbrs = parse_abbrs(output)
	
	-- Cache the results
	if use_cache then
		cache.set_cached_abbrs("zsh", "zsh-abbrev-alias", abbrs)
	end
	
	return abbrs
end

--- Apply zsh-abbrev-alias abbreviations to current buffer
--- @param abbrs Abbreviation[] Array of abbreviations to apply
function M.apply_abbr(abbrs)
	if not abbrs or #abbrs == 0 then
		return
	end
	
	local applied_count = 0
	for _, abbr in ipairs(abbrs) do
		if abbr.name and abbr.expansion then
			-- Escape special characters in abbreviation name and expansion
			local safe_name = vim.fn.escape(abbr.name, " \t|\\")
			local safe_expansion = vim.fn.escape(abbr.expansion, " \t|\\")
			
			local success, err = pcall(function()
				vim.cmd(("iabbr %s %s"):format(safe_name, safe_expansion))
			end)
			
			if success then
				applied_count = applied_count + 1
			else
				vim.notify("Failed to apply zsh-abbrev-alias abbreviation '" .. abbr.name .. "': " .. tostring(err), 
					vim.log.levels.WARN)
			end
		end
	end
	
	if applied_count > 0 then
		vim.notify("Applied " .. applied_count .. " zsh-abbrev-alias abbreviations", vim.log.levels.INFO)
	end
end

return M
