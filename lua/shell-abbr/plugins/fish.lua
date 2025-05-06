local M = {}
local system = require "shell-abbr.utils.system"

--- 引数で与えられた行を {name, expansion} に変換する
---@param line string
---@return table|nil
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

---@param input string
---@return Abbreviation[]
local function parse_abbrs(input)
	local result = {}

	for line in input:gmatch("[^\r\n]+") do
		local abbr = parse_abbr_line(line)
		if abbr then
			table.insert(result, abbr)
		end
	end

	return result
end

function M.get_abbr_list()
	local result = system({ "fish", "-c", "abbr" })
	local abbrs = parse_abbrs(result)
	return abbrs
end

---comment
---@param abbrs Abbreviation[]
function M.apply_abbr(abbrs)
	for _, abbr in ipairs(abbrs) do
		vim.cmd(("iabbr %s %s"):format(abbr.name, abbr.expansion))
	end
end

return M
