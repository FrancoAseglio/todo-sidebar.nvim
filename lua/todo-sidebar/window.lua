-- lua/todo-sidebar/window.lua
local config = require("todo-sidebar.config")
local display = require("todo-sidebar.display")
local api = vim.api
local M = {}

-- Window state
local buf, win

-- Returns true if the sidebar window is currently open and valid
function M.is_valid()
	return win and api.nvim_win_is_valid(win)
end

-- Get current buffer and window handles
function M.get_handles()
	return buf, win
end

-- Constructs and returns the floating window configuration based on the sidebar position
local function get_window_config()
	local cfg = config.get()
	local width = cfg.width
	local height = (vim.o.lines - 4)
	local col = cfg.position == "right" and vim.o.columns - width - 2 or 0

	return {
		relative = "editor",
		width = width,
		height = height,
		row = 1,
		col = col,
		style = "minimal",
		border = cfg.border,
		title = cfg.title,
		title_pos = "center",
	}
end

-- Creates the buffer with appropriate settings
local function create_buffer()
	local buffer = api.nvim_create_buf(false, true)

	-- Set buffer options
	api.nvim_buf_set_option(buffer, "buftype", "nofile")
	api.nvim_buf_set_option(buffer, "swapfile", false)
	api.nvim_buf_set_option(buffer, "filetype", "todo-sidebar")

	return buffer
end

-- Sets up auto-close behavior
local function setup_auto_close(buffer, close_callback)
	api.nvim_create_autocmd("BufLeave", {
		buffer = buffer,
		callback = function()
			vim.defer_fn(function()
				if win and api.nvim_win_is_valid(win) then
					local current_win = api.nvim_get_current_win()

					if current_win ~= win then
						close_callback()
					end
				end
			end, 50)
		end,
	})
end

-- Creates and opens the floating sidebar window
function M.create(keymap_callback, close_callback)
	buf = create_buffer()

	-- Open the floating window
	win = api.nvim_open_win(buf, true, get_window_config())

	-- Set window options
	api.nvim_win_set_option(win, "cursorline", true)

	-- Set up keybindings
	if keymap_callback then
		keymap_callback(buf)
	end

	-- Set up auto-close behavior
	setup_auto_close(buf, close_callback)

	-- Initial render
	display.render(buf)

	return buf, win
end

-- Closes the floating sidebar window and cleans up state
function M.close()
	if win and api.nvim_win_is_valid(win) then
		api.nvim_win_close(win, true)
		win = nil
		buf = nil
	end
end

-- Get current cursor position in the window
function M.get_cursor_line()
	if not M.is_valid() then
		return nil
	end
	return api.nvim_win_get_cursor(win)[1]
end

-- Force re-render
function M.render()
	display.render(buf)
end

return M

