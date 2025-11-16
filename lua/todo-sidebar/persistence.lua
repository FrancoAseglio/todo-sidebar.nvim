-- lua/todo-sidebar/persistence.lua
local config = require("todo-sidebar.config")
local M = {}

-- Loads TODO items from disk into memory from the configured file
function M.load_todos()
	local todos = {}
	local file_path = config.get_value("persist_file")
	local file, err = io.open(file_path, "r")

	if not file then
		if err and err:match("No such file") then
			-- First time use - create empty file
			M.save_todos({})
			return {}
		else
			vim.notify(
				"TODO Sidebar: Failed to open file: " .. (err or "unknown error"),
				vim.log.levels.WARN
			)
			return {}
		end
	end

	local content = file:read("*all")
	file:close()

	if not content or content == "" then
		return {}
	end

	local ok, data = pcall(vim.json.decode, content)

	if not ok then
		vim.notify(
			"TODO Sidebar: Failed to parse file. Creating backup and starting fresh.",
			vim.log.levels.WARN
		)
		-- Create backup
		local backup_path = file_path .. ".backup." .. os.date("%Y%m%d_%H%M%S")
		os.rename(file_path, backup_path)
		M.save_todos({})
		return {}
	end

	if type(data) ~= "table" then
		vim.notify("TODO Sidebar: Invalid file format. Expected table.", vim.log.levels.ERROR)
		return {}
	end

	return data
end

-- Persists the current list of TODOs to disk in JSON format
function M.save_todos(todos)
	local file_path = config.get_value("persist_file")
	local file, err = io.open(file_path, "w")

	if not file then
		vim.notify(
			"TODO Sidebar: Failed to save TODOs: " .. (err or "unknown error"),
			vim.log.levels.ERROR
		)
		return false
	end

	local ok, json_str = pcall(vim.json.encode, todos)
	if not ok then
		vim.notify("TODO Sidebar: Failed to encode TODOs to JSON", vim.log.levels.ERROR)
		file:close()
		return false
	end

	local write_ok, write_err = file:write(json_str)
	file:close()

	if not write_ok then
		vim.notify(
			"TODO Sidebar: Failed to write to file: " .. (write_err or "unknown error"),
			vim.log.levels.ERROR
		)
		return false
	end

	return true
end

return M

