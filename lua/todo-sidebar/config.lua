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

-- Setup configuration with user options
function M.setup(opts)
	M.current = vim.tbl_deep_extend("force", M.defaults, opts or {})
	return M.current
end

-- Get current configuration
function M.get()
	return M.current
end

-- Get specific config value
function M.get_value(key)
	return M.current[key] or M.defaults[key]
end

return M
