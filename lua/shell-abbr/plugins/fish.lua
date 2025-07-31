local M = {}
local system = require("shell-abbr.utils.system")
local cache = require("shell-abbr.utils.cache")
local shell_utils = require("shell-abbr.utils.shell")

--- Parse a fish abbreviation line into {name, expansion} format
--- @param line string Line to parse
--- @return table|nil Parsed abbreviation or nil if invalid
local function parse_abbr_line(line)
	-- abbr -a -- name expansion...
	local name, expansion = line:match("^abbr %-a +%-%- +(%S+)%s+(.+)$")
	if name and expansion then
		return {
			name = name,
			expansion = expansion,
		}
	end
	return nil
end

--- Parse fish abbreviations output into structured data
--- @param input string Raw fish abbr command output
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

--- Get list of fish abbreviations with caching support
--- @param use_cache boolean|nil Whether to use cache (default: true)
--- @return Abbreviation[] Array of abbreviations
function M.get_abbr_list(use_cache)
	use_cache = use_cache ~= false -- Default to true
	
	-- Check cache first
	if use_cache then
		local cached = cache.get_cached_abbrs("fish", nil)
		if cached then
			return cached
		end
	end
	
	-- Validate fish availability
	local valid, err = shell_utils.validate_shell_config("fish")
	if not valid then
		vim.notify("Fish abbreviations unavailable: " .. err, vim.log.levels.ERROR)
		return {}
	end
	
	-- Get abbreviations from fish
	local output, error_msg = system({ "fish", "-c", "abbr" })
	if error_msg then
		vim.notify("Failed to get fish abbreviations: " .. error_msg, vim.log.levels.ERROR)
		return {}
	end
	
	local abbrs = parse_abbrs(output)
	
	-- Cache the results
	if use_cache then
		cache.set_cached_abbrs("fish", nil, abbrs)
	end
	
	return abbrs
end

--- Apply fish abbreviations to current buffer
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
				vim.notify("Failed to apply fish abbreviation '" .. abbr.name .. "': " .. tostring(err), 
					vim.log.levels.WARN)
			end
		end
	end
	
	if applied_count > 0 then
		vim.notify("Applied " .. applied_count .. " fish abbreviations", vim.log.levels.INFO)
	end
end

return M
