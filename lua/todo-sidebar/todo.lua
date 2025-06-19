-- lua/todo-sidebar/todo.lua
local persistence = require("todo-sidebar.persistence")
local M = {}

-- Internal state
local todos = {}

-- Initialize TODOs from persistence
function M.init()
	todos = persistence.load_todos()

	-- Ensure all todos have IDs
	for i, todo in ipairs(todos) do
		if not todo.id then
			todo.id = i
		end
	end
end

-- Get all todos
function M.get_all()
	return todos
end

-- Returns TODOs with pinned items first, preserving internal order
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

-- Returns the next available numeric ID to assign to a new TODO item
local function get_next_id()
	local max_id = 0

	for _, todo in ipairs(todos) do
		if todo.id and todo.id > max_id then
			max_id = todo.id
		end
	end

	return max_id + 1
end

-- Adds a new TODO item with the given text
function M.add(text)
	table.insert(todos, {
		id = get_next_id(),
		text = text,
		done = false,
		pinned = false,
		created = os.time(),
	})
	persistence.save_todos(todos)
end

-- Deletes the TODO item at a given index
function M.delete(index)
	if todos[index] then
		table.remove(todos, index)
		persistence.save_todos(todos)
	end
end

-- Toggles the 'done' state of a TODO item at a given index
function M.toggle_done(index)
	if todos[index] then
		todos[index].done = not todos[index].done
		persistence.save_todos(todos)
	end
end

-- Toggles the 'pinned' state of a TODO item at a given index
function M.toggle_pin(index)
	if todos[index] then
		todos[index].pinned = not todos[index].pinned
		persistence.save_todos(todos)
	end
end

-- Updates the text of a TODO item at a given index
function M.update_text(index, text)
	if todos[index] and text and text ~= "" then
		todos[index].text = text
		persistence.save_todos(todos)
	end
end

-- Maps the current cursor line to the corresponding index in the original todos list
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

