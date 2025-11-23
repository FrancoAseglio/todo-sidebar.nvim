-- lua/todo-sidebar/display.lua
local config = require("todo-sidebar.config")
local todo = require("todo-sidebar.todo")
local api = vim.api
local M = {}

-- State for help display
local showing_help = false
local ns_id = api.nvim_create_namespace("todo_sidebar")

-- Centers text within the sidebar window
--- @param text string Text to center
--- @return string Centered text with padding
local function center(text)
	local win_width = config.get_value("width") or config.defaults.width or 40
	local display_width = vim.fn.strdisplaywidth(text)
	local padding = math.max(math.floor((win_width - display_width) / 2), 0)
	return string.rep(" ", padding) .. text
end

-- Help menu lines
local HELP_LINES = vim.tbl_map(center, {
	"┌────── HELP ──────┐",
	"│ x → Mark Done    │",
	"│ a → Add New ToDo │",
	"│ d → Delete ToDo  │",
	"│ p → Toggle Pin   │",
	"│ e → Edit Text    │",
	"│ q → Quit         │",
	"│ ? → Show Help    │",
	"└──────────────────┘",
})

--- Builds the full list of lines to display in the sidebar, including todos and help/hint
--- @return table, table Display lines and sorted TODO items
function M.get_display_lines()
	local lines = {}
	local sorted = todo.get_sorted()

	for _, item in ipairs(sorted) do
		local checkbox = item.done and "☑" or "☐"
		local pin_icon = item.pinned and " " or ""
		local text = item.text
		assert(item.id, "TODO item missing id")
		local line = string.format("%2d. %s %s%s", item.id, checkbox, pin_icon, text)
		table.insert(lines, line)
	end

	if #sorted == 0 then
		local empty_buff = center(" All clear — enjoy the calm!")
		table.insert(lines, empty_buff)
	end

	if showing_help then
		table.insert(lines, "")
		vim.list_extend(lines, HELP_LINES)
	end

	-- Add padding to help hint
	local win_height = vim.o.lines - 4
	local help_hint = center("? for help menu")

	-- Reserve last line for hint
	while #lines < (win_height - 1) do
		table.insert(lines, "")
	end

	table.insert(lines, help_hint)

	return lines, sorted
end

--- Determines the highlight group to use for a given TODO item based on state
--- @param todo_item table The TODO item to get highlight for
--- @return string|nil Highlight group name or nil
local function get_highlight_group(todo_item)
	if todo_item.done then
		return "Comment"
	end
	if todo_item.pinned then
		return "Special"
	end
	return nil
end

--- Renders the current state of the TODO list in the floating window
--- @param buf number Buffer handle to render to
function M.render(buf)
	if not buf or not api.nvim_buf_is_valid(buf) then
		return
	end

	local lines, sorted_todos = M.get_display_lines()

	-- Make buffer modifiable temporarily
	vim.bo[buf].modifiable = true
	api.nvim_buf_set_lines(buf, 0, -1, false, lines)
	vim.bo[buf].modifiable = false
	api.nvim_buf_clear_namespace(buf, ns_id, 0, -1)

	for i, todo_item in ipairs(sorted_todos) do
		local hl = get_highlight_group(todo_item)

		if hl then
			api.nvim_buf_add_highlight(buf, ns_id, hl, i - 1, 0, -1)
		end
	end

	-- Highlight help hint
	local total_lines = api.nvim_buf_line_count(buf)
	api.nvim_buf_add_highlight(buf, ns_id, "Comment", total_lines - 1, 0, -1)
end

--- Toggle help display
function M.toggle_help()
	showing_help = not showing_help
end

--- Get namespace ID for highlights
--- @return number Namespace ID
function M.get_namespace_id()
	return ns_id
end

return M
