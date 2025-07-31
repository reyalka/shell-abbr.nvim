--- Caching utility for shell abbreviations to improve performance
local M = {}

--- Cache storage for abbreviations by shell type and plugin
local cache = {}

--- Default cache TTL in seconds (5 minutes)
local DEFAULT_CACHE_TTL = 300

--- Get current time in seconds
--- @return number current time in seconds
local function get_current_time()
	return os.time()
end

--- Generate cache key for abbreviations
--- @param shell_type string Type of shell ("fish", "zsh")
--- @param plugin_name string|nil Name of plugin for zsh
--- @return string cache key
local function get_cache_key(shell_type, plugin_name)
	if plugin_name then
		return shell_type .. ":" .. plugin_name
	end
	return shell_type
end

--- Check if cached data is still valid
--- @param cache_entry table Cache entry with data and timestamp
--- @param ttl number|nil Time to live in seconds (default: 300)
--- @return boolean true if cache is valid, false if expired
local function is_cache_valid(cache_entry, ttl)
	if not cache_entry or not cache_entry.timestamp then
		return false
	end
	
	local cache_ttl = ttl or DEFAULT_CACHE_TTL
	local current_time = get_current_time()
	return (current_time - cache_entry.timestamp) < cache_ttl
end

--- Get abbreviations from cache if available and valid
--- @param shell_type string Type of shell
--- @param plugin_name string|nil Name of plugin for zsh
--- @param ttl number|nil Custom TTL in seconds
--- @return Abbreviation[]|nil cached abbreviations or nil if not found/expired
function M.get_cached_abbrs(shell_type, plugin_name, ttl)
	local key = get_cache_key(shell_type, plugin_name)
	local cache_entry = cache[key]
	
	if is_cache_valid(cache_entry, ttl) then
		return cache_entry.data
	end
	
	return nil
end

--- Store abbreviations in cache
--- @param shell_type string Type of shell
--- @param plugin_name string|nil Name of plugin for zsh
--- @param abbrs Abbreviation[] Abbreviations to cache
function M.set_cached_abbrs(shell_type, plugin_name, abbrs)
	if not abbrs then
		return
	end
	
	local key = get_cache_key(shell_type, plugin_name)
	cache[key] = {
		data = abbrs,
		timestamp = get_current_time()
	}
end

--- Clear all cached abbreviations
function M.clear_cache()
	cache = {}
end

--- Clear cached abbreviations for specific shell/plugin
--- @param shell_type string Type of shell
--- @param plugin_name string|nil Name of plugin for zsh
function M.clear_shell_cache(shell_type, plugin_name)
	local key = get_cache_key(shell_type, plugin_name)
	cache[key] = nil
end

--- Get cache statistics for debugging
--- @return table cache statistics
function M.get_cache_stats()
	local stats = {
		total_entries = 0,
		valid_entries = 0,
		expired_entries = 0
	}
	
	local current_time = get_current_time()
	for _, entry in pairs(cache) do
		stats.total_entries = stats.total_entries + 1
		if is_cache_valid(entry) then
			stats.valid_entries = stats.valid_entries + 1
		else
			stats.expired_entries = stats.expired_entries + 1
		end
	end
	
	return stats
end

return M