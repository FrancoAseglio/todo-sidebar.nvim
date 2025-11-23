-- lua/todo-sidebar/persistence.lua
local config = require("todo-sidebar.config")
local M = {}

--- Loads TODO items from disk into memory from the configured file
--- @return table List of TODO items, empty table if file doesn't exist or is invalid
function M.load_todos()
	local todos = {}
	local persist_file = config.get_value("persist_file")
	
	-- Safely attempt to open file
	local file, err = io.open(persist_file, "r")
	if not file then
		-- File doesn't exist yet or can't be opened - this is expected on first run
		if err and not err:match("No such file") then
			vim.notify("TODO Sidebar: Could not open file: " .. err, vim.log.levels.WARN)
		end
		return todos
	end

	-- Read file content
	local ok, content = pcall(file.read, file, "*all")
	file:close()
	
	if not ok then
		vim.notify("TODO Sidebar: Failed to read file: " .. tostring(content), vim.log.levels.ERROR)
		return todos
	end

	-- Only parse if content is not empty
	if content and content ~= "" then
		local decode_ok, data = pcall(vim.json.decode, content)
		
		if decode_ok and type(data) == "table" then
			todos = data
		else
			vim.notify("TODO Sidebar: Invalid JSON in save file, starting fresh", vim.log.levels.WARN)
		end
	end

	return todos
end

--- Persists the current list of TODOs to disk in JSON format
--- @param todos table List of TODO items to save
--- @return boolean True if save was successful, false otherwise
function M.save_todos(todos)
	if type(todos) ~= "table" then
		vim.notify("TODO Sidebar: Invalid data type for save", vim.log.levels.ERROR)
		return false
	end

	local persist_file = config.get_value("persist_file")
	
	-- Ensure directory exists
	local dir = vim.fn.fnamemodify(persist_file, ":h")
	if vim.fn.isdirectory(dir) == 0 then
		local ok = vim.fn.mkdir(dir, "p")
		if ok == 0 then
			vim.notify("TODO Sidebar: Could not create directory: " .. dir, vim.log.levels.ERROR)
			return false
		end
	end

	-- Encode data
	local encode_ok, json_str = pcall(vim.json.encode, todos)
	if not encode_ok then
		vim.notify("TODO Sidebar: Failed to encode data: " .. tostring(json_str), vim.log.levels.ERROR)
		return false
	end

	-- Write to file
	local file, err = io.open(persist_file, "w")
	if not file then
		vim.notify("TODO Sidebar: Could not open file for writing: " .. err, vim.log.levels.ERROR)
		return false
	end

	local write_ok, write_err = pcall(file.write, file, json_str)
	file:close()
	
	if not write_ok then
		vim.notify("TODO Sidebar: Failed to write file: " .. tostring(write_err), vim.log.levels.ERROR)
		return false
	end

	return true
end

return M

