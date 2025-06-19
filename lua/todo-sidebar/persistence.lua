-- lua/todo-sidebar/persistence.lua
local config = require("todo-sidebar.config")
local M = {}

-- Loads TODO items from disk into memory from the configured file
function M.load_todos()
	local todos = {}
	local file = io.open(config.get_value("persist_file"), "r")

	if file then
		local content = file:read("*all")
		file:close()

		local ok, data = pcall(vim.json.decode, content)

		if ok and type(data) == "table" then
			todos = data
		end
	end

	return todos
end

-- Persists the current list of TODOs to disk in JSON format
function M.save_todos(todos)
	local file = io.open(config.get_value("persist_file"), "w")

	if file then
		file:write(vim.json.encode(todos))
		file:close()
		return true
	end

	return false
end

return M

