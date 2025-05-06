local M = {}
local system = require "shell-abbr.utils.system"

---convert the given line into format {name, expansion}
---@param line string
---@return table|nil
local function parse_abbr_line(line)
	-- "name"="expansion"
	local name, expansion = line:match([[^"(.-)"="(.-)"$]])
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
	local result = system({ "zsh", "-i", "-c", "abbr" })
	local abbrs = parse_abbrs(result)
	return abbrs
end

---@param abbrs Abbreviation[]
function M.apply_abbr(abbrs)
	for _, abbr in ipairs(abbrs) do
		vim.cmd(("iabbr %s %s"):format(abbr.name, abbr.expansion))
	end
end

return M
