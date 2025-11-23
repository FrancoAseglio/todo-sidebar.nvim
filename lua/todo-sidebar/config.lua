-- lua/todo-sidebar/config.lua
local M = {}

-- Default configuration
M.defaults = {
	width = 40, -- Width of the floating sidebar
	position = "right", -- Sidebar position: "left" or "right"
	border = "rounded", -- Border style of the floating window
	title = " CHECK LIST ", -- Title displayed at the top of the window
	persist_file = vim.fn.stdpath("data") .. "/todo_sidebar.json", -- File to store todos persistently
}

-- Merged with user options
M.current = M.defaults

--- Setup configuration with user options
--- @param opts table|nil User configuration options
--- @return table The merged configuration
function M.setup(opts)
	if opts and type(opts) ~= "table" then
		error("Configuration must be a table")
	end

	M.current = vim.tbl_deep_extend("force", M.defaults, opts or {})
	
	-- Validate configuration
	if M.current.width and (type(M.current.width) ~= "number" or M.current.width < 20 or M.current.width > 200) then
		vim.notify("TODO Sidebar: Invalid width, using default", vim.log.levels.WARN)
		M.current.width = M.defaults.width
	end
	
	if M.current.position and M.current.position ~= "left" and M.current.position ~= "right" then
		vim.notify("TODO Sidebar: Invalid position, using default", vim.log.levels.WARN)
		M.current.position = M.defaults.position
	end
	
	return M.current
end

--- Get current configuration
--- @return table The current configuration
function M.get()
	return M.current
end

--- Get specific config value
--- @param key string The configuration key to retrieve
--- @return any The configuration value
function M.get_value(key)
	return M.current[key] or M.defaults[key]
end

return M
