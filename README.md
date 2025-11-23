# TODO Sidebar

A lightweight, persistent TODO sidebar for Neovim that helps you manage tasks without leaving your editor.

## ✨ Features

- **Floating Sidebar**: Clean, minimal floating window that doesn't interfere with your workflow
- **Persistent Storage**: TODOs are automatically saved to disk and restored between sessions
- **Task Management**: Check off completed items, pin important tasks, and organize your workflow
- **Intuitive Controls**: Simple keyboard shortcuts for all operations
- **Auto-close**: Sidebar closes automatically when you navigate away
- **Error Handling**: Robust error handling with user-friendly notifications
- **Input Validation**: Protects against invalid inputs and edge cases

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

### Using [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'FrancoAseglio/todo-sidebar.nvim'

lua << EOF
  require("todo-sidebar").setup()
EOF
```

2. Press `<leader>td` to toggle the TODO sidebar
3. Use `?` to see all available commands

## ⚙️ Configuration

The plugin comes with sensible defaults, but you can customize it to fit your preferences:

```lua
require("todo-sidebar").setup({
  width = 40,                -- Width of the floating sidebar (min: 20, max: 200)
  position = "right",        -- Sidebar position: "left" or "right"
  border = "rounded",        -- Border style: "rounded", "single", "double", "solid", "shadow", etc.
  title = " CHECK LIST ",    -- Title displayed at the top of the window
  persist_file = vim.fn.stdpath("data") .. "/todo_sidebar.json", -- Storage file path
})
```

### Configuration Options

| Option | Type | Default | Description |
|--------|------|---------|-------------|
| `width` | `number` | `40` | Width of the sidebar window (20-200) |
| `position` | `string` | `"right"` | Sidebar position: `"left"` or `"right"` |
| `border` | `string` | `"rounded"` | Border style (any valid Neovim border) |
| `title` | `string` | `" CHECK LIST "` | Window title text |
| `persist_file` | `string` | `stdpath("data")/todo_sidebar.json` | Path to the storage file |

### Advanced Configuration Examples

**Minimal look with left-side placement:**
```lua
require("todo-sidebar").setup({
  width = 35,
  position = "left",
  border = "single",
  title = " Tasks ",
})
```

**Wide sidebar with custom storage:**
```lua
require("todo-sidebar").setup({
  width = 60,
  position = "right",
  border = "double",
  persist_file = vim.fn.expand("~/.config/nvim/todos.json"),
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

### TODO Item Features

- **Checkboxes**: Visual indicators (☐/☑) for completed/pending tasks
- **Pinning**: Pin important tasks with 📌 to keep them at the top of your list
- **Unique IDs**: Each TODO gets a unique numeric ID for easy reference
- **Persistence**: All TODOs are automatically saved and restored between sessions
- **Highlighting**: Completed items are dimmed, pinned items are highlighted

## 📁 File Storage

TODOs are stored as JSON in your Neovim data directory. To find the exact location:

```lua
:lua print(vim.fn.stdpath("data") .. "/todo_sidebar.json")
```

The JSON format is simple and human-readable:
```json
[
  {
    "id": 1,
    "text": "Review pull request",
    "done": false,
    "pinned": true,
    "created": 1234567890
  },
  {
    "id": 2,
    "text": "Update documentation",
    "done": true,
    "pinned": false,
    "created": 1234567891
  }
]
```

## 🔧 Troubleshooting

### Plugin doesn't load
- Ensure the plugin is properly installed via your package manager
- Check for errors with `:checkhealth`
- Verify the plugin is in your runtime path: `:lua print(vim.inspect(vim.api.nvim_list_runtime_paths()))`

### TODOs not persisting
- Check that the data directory is writable: `:lua print(vim.fn.stdpath("data"))`
- Verify file permissions on the storage file
- Check for error messages when the plugin saves (`:messages`)

### Window doesn't appear
- Try running `:lua require("todo-sidebar").open()` directly to see error messages
- Check your `<leader>` key is set correctly: `:echo mapleader`
- Verify there are no conflicting keybindings: `:verbose nmap <leader>td`

### Invalid JSON error on startup
If you see an "Invalid JSON in save file" warning:
1. The plugin will automatically start fresh with an empty TODO list
2. Your old file is not deleted, so you can recover it if needed
3. Check the file manually: `:!cat $(lua print(vim.fn.stdpath("data") .. "/todo_sidebar.json"))`

### Character encoding issues
- Ensure your Neovim is compiled with UTF-8 support
- Check encoding: `:set encoding?` (should be `utf-8`)

## 🤝 Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

### Development Setup

1. Fork and clone the repository
2. Make your changes in a feature branch
3. Test thoroughly with your Neovim setup
4. Ensure code follows the existing style (use LuaLS annotations)
5. Submit a pull request with a clear description

### Code Style Guidelines
- Use LuaDoc annotations (`---@param`, `---@return`) for all public functions
- Keep functions small and focused
- Add error handling for user-facing operations
- Maintain the minimal, clean aesthetic

## 📜 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- Inspired by the need for simple task management within Neovim
- Built using Neovim's floating window API
- Thanks to the Neovim community for excellent documentation and examples

## 🐛 Known Issues

None at the moment! If you find a bug, please [report it](https://github.com/FrancoAseglio/fuffa/issues).

## 💡 Tips

- Use pinning (`p`) to keep important tasks at the top of your list
- Completed items are automatically styled differently to reduce visual clutter
- The sidebar auto-closes when you switch buffers, keeping your workflow smooth
- TODO items have a 500 character limit to maintain the clean, minimal look
- Press `?` in the sidebar to quickly review available commands
