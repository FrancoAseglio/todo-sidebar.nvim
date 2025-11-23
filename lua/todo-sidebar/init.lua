-- lua/todo-sidebar/init.lua
local config = require("todo-sidebar.config")
local todo = require("todo-sidebar.todo")
local window = require("todo-sidebar.window")
local keymaps = require("todo-sidebar.keymaps")
local display = require("todo-sidebar.display")

local M = {}

-- ==========================
-- Public Module Functions
-- ==========================

--- Setup the plugin with custom configuration
--- @param opts table|nil Optional configuration table
function M.setup(opts)
	-- Validate and setup configuration
	local setup_ok, err = pcall(config.setup, opts)
	if not setup_ok then
		vim.notify("TODO Sidebar: Configuration error: " .. tostring(err), vim.log.levels.ERROR)
		return
	end
	
	-- Initialize TODO storage
	local init_ok, init_err = pcall(todo.init)
	if not init_ok then
		vim.notify("TODO Sidebar: Initialization error: " .. tostring(init_err), vim.log.levels.ERROR)
		return
	end
	
	-- Set up global keymaps
	keymaps.setup_global_keymaps(function()
		M.toggle()
	end)
end

--- Opens or closes the TODO sidebar window
function M.toggle()
	if window.is_valid() then
		M.close()
	else
		M.open()
	end
end

--- Opens the TODO sidebar
function M.open()
	local keymap_actions = {
		close = function()
			M.close()
		end,
		toggle_check = function()
			M.toggle_check()
		end,
		add_item = function()
			M.add_item()
		end,
		delete_item = function()
			M.delete_item()
		end,
		toggle_pin = function()
			M.toggle_pin()
		end,
		edit_item = function()
			M.edit_item()
		end,
		show_help = function()
			M.show_help()
		end,
	}

	-- Create window with error handling
	local ok, err = pcall(window.create, function(buf)
		keymaps.setup_buffer_keymaps(buf, keymap_actions)
	end, function()
		M.close()
	end)
	
	if not ok then
		vim.notify("TODO Sidebar: Failed to open window: " .. tostring(err), vim.log.levels.ERROR)
	end
end

--- Closes the floating sidebar window and cleans up state
function M.close()
	window.close()
end

--- Toggle current line's TODO checkbox
function M.toggle_check()
	if not window.is_valid() then
		return
	end

	local line = window.get_cursor_line()
	if not line then
		return
	end

	local real_index = todo.get_index_from_sorted_position(line)

	if real_index then
		todo.toggle_done(real_index)
		window.render()
	end
end

--- Add a new TODO via input prompt
function M.add_item()
	vim.ui.input({ prompt = "New TODO: " }, function(input)
		if input and input ~= "" then
			-- Validate input length
			if #input > 500 then
				vim.notify("TODO Sidebar: TODO text is too long (max 500 characters)", vim.log.levels.WARN)
				return
			end
			
			-- Trim whitespace
			input = input:match("^%s*(.-)%s*$")
			
			if input ~= "" then
				local ok, err = pcall(todo.add, input)
				if ok then
					window.render()
				else
					vim.notify("TODO Sidebar: Failed to add item: " .. tostring(err), vim.log.levels.ERROR)
				end
			end
		end
	end)
end

--- Delete the selected TODO
function M.delete_item()
	if not window.is_valid() then
		return
	end

	local line = window.get_cursor_line()
	if not line then
		return
	end

	local real_index = todo.get_index_from_sorted_position(line)

	if real_index then
		todo.delete(real_index)
		window.render()
	end
end

--- Toggles the pinned state of the TODO item under the cursor
function M.toggle_pin()
	if not window.is_valid() then
		return
	end

	local line = window.get_cursor_line()
	if not line then
		return
	end

	local real_index = todo.get_index_from_sorted_position(line)

	if real_index then
		todo.toggle_pin(real_index)
		window.render()
	end
end

--- Edit selected TODO item
function M.edit_item()
	if not window.is_valid() then
		return
	end

	local line = window.get_cursor_line()
	if not line then
		return
	end

	local real_index = todo.get_index_from_sorted_position(line)

	if real_index then
		local todos = todo.get_all()
		if todos[real_index] then
			vim.ui.input({
				prompt = "Edit TODO: ",
				default = todos[real_index].text,
			}, function(input)
				if input and input ~= "" then
					-- Validate input length
					if #input > 500 then
						vim.notify("TODO Sidebar: TODO text is too long (max 500 characters)", vim.log.levels.WARN)
						return
					end
					
					-- Trim whitespace
					input = input:match("^%s*(.-)%s*$")
					
					if input ~= "" then
						local ok, err = pcall(todo.update_text, real_index, input)
						if ok then
							window.render()
						else
							vim.notify("TODO Sidebar: Failed to update item: " .. tostring(err), vim.log.levels.ERROR)
						end
					end
				end
			end)
		end
	end
end

--- Force re-rendering of the sidebar
function M.render()
	window.render()
end

--- Show or hide the help popup
function M.show_help()
	display.toggle_help()
	window.render()
end

return M

