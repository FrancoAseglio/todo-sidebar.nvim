# TODO Sidebar

A lightweight, persistent TODO sidebar for Neovim that helps you manage tasks without leaving your editor.

## ✨ Features

- **Floating Sidebar**: Clean, minimal floating window that doesn't interfere with your workflow
- **Persistent Storage**: TODOs are automatically saved to disk and restored between sessions
- **Task Management**: Check off completed items, pin important tasks, and organize your workflow
- **Intuitive Controls**: Simple keyboard shortcuts for all operations
- **Auto-close**: Sidebar closes automatically when you navigate away

## 🚀 Quick Start

1. Install the plugin using your preferred package manager

### Using [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  "FrancoAseglio/todo-sidebar.nvim",
  config = function()
    require("todo-sidebar").setup()
  end,
}
```

### Using [packer.nvim](https://github.com/wbthomason/packer.nvim)

```lua
use {
  "FrancoAseglio/todo-sidebar.nvim",
  config = function()
    require("todo-sidebar").setup()
  end
}
```

2. Press `<leader>td` to toggle the TODO sidebar
3. Use `?` to see all available commands

## ⚙️ Configuration

The plugin comes with sensible defaults, but you can customize it to fit your preferences:

```lua
require("todo-sidebar").setup({
  width = 40,                -- Width of the floating sidebar
  position = "right",        -- Sidebar position: "left" or "right"
  border = "rounded",        -- Border style: "rounded", "single", "double", etc.
  title = " CHECK LIST ",    -- Title displayed at the top of the window
  persist_file = vim.fn.stdpath("data") .. "/todo_sidebar.json", -- Storage file path
})
```

## 🎮 Usage

### Default Keybindings

| Key | Action | Description |
|-----|--------|-------------|
| `<leader>td` | Toggle Sidebar | Opens/closes the TODO sidebar (global mapping) |

### Sidebar Keybindings

Once the sidebar is open, use these keys to manage your TODOs:

| Key | Action | Description |
|-----|--------|-------------|
| `a` | Add TODO | Create a new TODO item |
| `x` | Toggle Check | Mark TODO as done/undone |
| `d` | Delete TODO | Remove the selected TODO item |
| `p` | Toggle Pin | Pin/unpin TODO (pinned items appear at the top) |
| `e` | Edit TODO | Edit the text of the selected TODO |
| `q` | Quit | Close the sidebar |
| `?` | Help Menu | Toggle the help menu display |

**Note:** The plugin provides visual feedback for all operations via notifications.

### TODO Item Features

- **Checkboxes**: Visual indicators for completed/pending tasks
- **Pinning**: Pin important tasks to keep them at the top of your list
- **Unique IDs**: Each TODO gets a unique ID for easy reference
- **Persistence**: All TODOs are automatically saved and restored

## 📁 File Storage

TODOs are stored as JSON in your Neovim data directory. To find the exact location:

```lua
:lua print(vim.fn.stdpath("data") .. "/todo_sidebar.json")
```

The plugin automatically handles:
- Creating the storage file on first use
- Backing up corrupted files with timestamp
- Recovering from parse errors
- Validating TODO data on load

## 🔧 Troubleshooting

### Plugin doesn't load
- Ensure you've called `require("todo-sidebar").setup()` in your config
- Check for errors with `:messages`
- Verify the plugin is installed correctly with your package manager

### TODOs not persisting
- Check file permissions in your data directory: `:lua print(vim.fn.stdpath("data"))`
- Look for error notifications when saving
- Verify the storage file can be written: `:lua require("todo-sidebar.persistence").save_todos({})`

### Sidebar doesn't open
- Check if the keybinding is conflicting: `:map <leader>td`
- Try calling directly: `:lua require("todo-sidebar").open()`
- Ensure your terminal/GUI supports floating windows

### Corrupted TODO file
The plugin automatically creates backups of corrupted files with timestamps (e.g., `todo_sidebar.json.backup.20250116_120000`). You can manually restore from these backups if needed.

### Performance issues
If you have hundreds of TODOs, consider:
- Archiving completed tasks periodically
- Using multiple TODO lists for different projects
- Filtering by status to focus on active tasks

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup

1. Fork and clone the repository
2. Make your changes
3. Test with your Neovim setup
4. Submit a pull request

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for simple task management within Neovim
- Built using Neovim's floating window API
- Thanks to the Neovim community for excellent documentation and examples
