# Contributing to TODO Sidebar

Thank you for your interest in contributing to todo-sidebar.nvim! This document provides guidelines and information for contributors.

## 🚀 Getting Started

### Prerequisites
- Neovim 0.8.0 or later
- Git
- Basic knowledge of Lua and Neovim plugin development

### Setting Up Development Environment

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/todo-sidebar.nvim.git
   cd todo-sidebar.nvim
   ```

3. Create a development branch:
   ```bash
   git checkout -b feature/your-feature-name
   ```

4. Test your changes in Neovim by adding the local plugin to your config:
   ```lua
   -- For lazy.nvim
   {
     dir = "/path/to/your/todo-sidebar.nvim",
     config = function()
       require("todo-sidebar").setup()
     end,
   }
   ```

## 📋 Code Style

### Lua Style Guide
- Use tabs for indentation (width 2)
- Maximum line length: 100 characters
- Use double quotes for strings when possible
- Add spaces around operators
- Use descriptive variable names

### Formatting
We use [stylua](https://github.com/JohnnyMorganz/StyLua) for code formatting:

```bash
# Install stylua
cargo install stylua

# Format all Lua files
stylua lua/
```

Configuration is in `.stylua.toml`.

### Linting
We use [luacheck](https://github.com/lunarmodules/luacheck) for linting:

```bash
# Install luacheck
luarocks install luacheck

# Run linting
luacheck lua/
```

Configuration is in `.luacheckrc`.

## 🏗️ Architecture

### Module Structure
```
lua/todo-sidebar/
├── init.lua         # Main entry point and public API
├── config.lua       # Configuration management
├── todo.lua         # TODO item logic and data management
├── window.lua       # Floating window creation and management
├── display.lua      # Rendering and visual presentation
├── persistence.lua  # File I/O and data persistence
└── keymaps.lua      # Keybinding setup and management
```

### Design Principles
1. **Separation of Concerns**: Each module has a single, well-defined responsibility
2. **Minimal Dependencies**: Only use Neovim built-in APIs
3. **Error Handling**: Always handle errors gracefully with user feedback
4. **Testability**: Write code that can be easily tested
5. **Performance**: Keep the plugin lightweight and fast

## ✅ Testing

### Manual Testing
1. Test basic operations:
   - Add, edit, delete TODOs
   - Toggle done/undone state
   - Pin/unpin TODOs
   - Verify persistence across sessions

2. Test error conditions:
   - Empty input
   - Very long text (>500 characters)
   - Invalid file permissions
   - Corrupted JSON file

3. Test edge cases:
   - Empty TODO list
   - Large number of TODOs (100+)
   - Special characters in TODO text
   - Window resizing

### Automated Testing (Future)
We plan to add automated testing using [plenary.nvim](https://github.com/nvim-lua/plenary.nvim). Contributions to test infrastructure are welcome!

## 📝 Commit Messages

Follow the [Conventional Commits](https://www.conventionalcommits.org/) specification:

```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `perf`: Performance improvements
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

### Examples
```
feat(display): add search functionality
fix(persistence): handle corrupted JSON files gracefully
docs(readme): add troubleshooting section
refactor(todo): simplify sorting logic
```

## 🔄 Pull Request Process

1. **Create an Issue First**: For major changes, create an issue to discuss the proposed changes

2. **Keep PRs Focused**: One feature or fix per PR

3. **Update Documentation**: Update README.md and other docs as needed

4. **Test Thoroughly**: Ensure your changes work as expected

5. **Write Clear Descriptions**: Explain what changes you made and why

6. **Request Review**: Wait for maintainer feedback

### PR Checklist
- [ ] Code follows the style guide
- [ ] Code has been formatted with stylua
- [ ] Code passes luacheck linting
- [ ] Changes are documented in README or other docs
- [ ] Manual testing completed
- [ ] Commit messages follow conventions
- [ ] PR description clearly explains the changes

## 🎯 Good First Issues

Looking for a place to start? Check issues labeled with:
- `good first issue`: Suitable for new contributors
- `help wanted`: We need community help on these
- `documentation`: Improve or add documentation

## 💡 Feature Requests

We welcome feature requests! Please:
1. Check if the feature was already requested
2. Create an issue describing:
   - The problem you're trying to solve
   - Your proposed solution
   - Any alternatives you've considered
3. Be open to feedback and discussion

## 🐛 Bug Reports

When reporting bugs, please include:
1. Neovim version (`:version`)
2. Plugin version (commit hash)
3. Minimal config to reproduce
4. Steps to reproduce
5. Expected vs actual behavior
6. Error messages (check `:messages`)

## 📚 Documentation

All documentation contributions are welcome:
- README improvements
- Code comments
- Usage examples
- Architecture documentation
- Tutorials and guides

## 🤝 Community

- Be respectful and inclusive
- Help others when you can
- Share your use cases and feedback
- Suggest improvements

## 📄 License

By contributing to this project, you agree that your contributions will be licensed under the MIT License.

## ❓ Questions?

If you have questions about contributing, feel free to:
- Open an issue with the `question` label
- Check existing issues and discussions
- Reach out to the maintainers

---

Thank you for contributing to todo-sidebar.nvim! 🎉
