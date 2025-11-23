-- lua/todo-sidebar/keymaps.lua
local M = {}

--- Set up buffer-local keymaps for the sidebar
--- @param buf number Buffer handle
--- @param actions table Table of action functions
function M.setup_buffer_keymaps(buf, actions)
	local opts = { buffer = buf, silent = true }

	vim.keymap.set("n", "q", actions.close, opts)
	vim.keymap.set("n", "x", actions.toggle_check, opts)
	vim.keymap.set("n", "a", actions.add_item, opts)
	vim.keymap.set("n", "d", actions.delete_item, opts)
	vim.keymap.set("n", "p", actions.toggle_pin, opts)
	vim.keymap.set("n", "e", actions.edit_item, opts)
	vim.keymap.set("n", "?", actions.show_help, opts)
end

--- Set up global keymaps for the plugin
--- @param toggle_callback function Callback to execute when toggling the sidebar
function M.setup_global_keymaps(toggle_callback)
	vim.keymap.set("n", "<leader>td", toggle_callback, {
		desc = "Toggle TODO Sidebar",
	})
end

return M

