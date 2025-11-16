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

-- Setup the plugin with custom config
function M.setup(opts)
	config.setup(opts)
	todo.init()
	-- Set up global keymaps
	keymaps.setup_global_keymaps(function()
		M.toggle()
	end)
end

-- Opens or closes the TODO sidebar window
function M.toggle()
	if window.is_valid() then
		M.close()
	else
		M.open()
	end
end

-- Opens the TODO sidebar
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

	window.create(function(buf)
		keymaps.setup_buffer_keymaps(buf, keymap_actions)
	end, function()
		M.close()
	end)
end

-- Closes the floating sidebar window and cleans up state
function M.close()
	window.close()
end

-- Toggle current line's TODO checkbox
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
		local todos = todo.get_all()
		local status = todos[real_index].done and "completed" or "marked as pending"
		vim.notify("TODO " .. status, vim.log.levels.INFO)
	end
end

-- Add a new TODO via input prompt
function M.add_item()
	vim.ui.input({ prompt = "New TODO: " }, function(input)
		if input and input ~= "" then
			local success = todo.add(input)
			if success then
				window.render()
				vim.notify("TODO added successfully", vim.log.levels.INFO)
			end
		end
	end)
end

-- Delete the selected TODO
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
		vim.notify("TODO deleted", vim.log.levels.INFO)
	end
end

-- Toggles the pinned state of the TODO item under the cursor
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
		local todos = todo.get_all()
		local status = todos[real_index].pinned and "pinned" or "unpinned"
		vim.notify("TODO " .. status, vim.log.levels.INFO)
	end
end

-- Edit selected TODO item
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
					local success = todo.update_text(real_index, input)
					if success then
						window.render()
						vim.notify("TODO updated", vim.log.levels.INFO)
					end
				end
			end)
		end
	end
end

-- Force re-rendering
function M.render()
	window.render()
end

-- Show help popup
function M.show_help()
	display.toggle_help()
	window.render()
end

return M

