-- lua/todo-sidebar/todo.lua
local persistence = require("todo-sidebar.persistence")
local M = {}

-- Internal state
local todos = {}

--- Initialize TODOs from persistence layer
--- Loads all saved TODOs and ensures they have valid IDs
function M.init()
	todos = persistence.load_todos()

	-- Ensure all todos have IDs
	for i, todo_item in ipairs(todos) do
		if not todo_item.id then
			todo_item.id = i
		end
	end
end

--- Get all todos in their original order
--- @return table List of all TODO items
function M.get_all()
	return todos
end

--- Returns TODOs with pinned items first, preserving internal order
--- @return table Sorted list with pinned items at the top
function M.get_sorted()
	local sorted = {}

	-- Add pinned items first
	for _, item in ipairs(todos) do
		if item.pinned then
			table.insert(sorted, item)
		end
	end

	-- Add non-pinned items
	for _, item in ipairs(todos) do
		if not item.pinned then
			table.insert(sorted, item)
		end
	end

	return sorted
end

--- Returns the next available numeric ID to assign to a new TODO item
--- @return number Next available ID
local function get_next_id()
	local max_id = 0

	for _, todo_item in ipairs(todos) do
		if todo_item.id and todo_item.id > max_id then
			max_id = todo_item.id
		end
	end

	return max_id + 1
end

--- Adds a new TODO item with the given text
--- @param text string The text content of the TODO item
function M.add(text)
	if not text or text == "" then
		error("TODO text cannot be empty")
	end

	table.insert(todos, {
		id = get_next_id(),
		text = text,
		done = false,
		pinned = false,
		created = os.time(),
	})
	persistence.save_todos(todos)
end

--- Deletes the TODO item at a given index
--- @param index number The index of the item to delete
function M.delete(index)
	if not index or index < 1 or index > #todos then
		return
	end

	if todos[index] then
		table.remove(todos, index)
		persistence.save_todos(todos)
	end
end

--- Toggles the 'done' state of a TODO item at a given index
--- @param index number The index of the item to toggle
function M.toggle_done(index)
	if not index or index < 1 or index > #todos then
		return
	end

	if todos[index] then
		todos[index].done = not todos[index].done
		persistence.save_todos(todos)
	end
end

--- Toggles the 'pinned' state of a TODO item at a given index
--- @param index number The index of the item to toggle
function M.toggle_pin(index)
	if not index or index < 1 or index > #todos then
		return
	end

	if todos[index] then
		todos[index].pinned = not todos[index].pinned
		persistence.save_todos(todos)
	end
end

--- Updates the text of a TODO item at a given index
--- @param index number The index of the item to update
--- @param text string The new text content
function M.update_text(index, text)
	if not index or index < 1 or index > #todos then
		return
	end

	if not text or text == "" then
		error("TODO text cannot be empty")
	end

	if todos[index] then
		todos[index].text = text
		persistence.save_todos(todos)
	end
end

--- Maps the current cursor line to the corresponding index in the original todos list
--- @param line number The line number in the sorted display
--- @return number|nil The index in the original todos list, or nil if not found
function M.get_index_from_sorted_position(line)
	local sorted = M.get_sorted()
	local selected = sorted[line]

	if not selected then
		return nil
	end

	for i, item in ipairs(todos) do
		if item == selected then
			return i
		end
	end

	return nil
end

return M

