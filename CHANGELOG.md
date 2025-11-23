# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive docstrings for all functions using LuaDoc annotations
- Robust error handling for file I/O operations with user-friendly notifications
- Input validation for TODO text (max 500 characters, automatic trimming)
- Configuration validation with warnings for invalid values
- Automatic directory creation for persistence file if it doesn't exist
- Buffer modifiable state management during rendering
- Support for vim-plug package manager in README
- Detailed troubleshooting section in README
- Advanced configuration examples in README
- Tips section for better user experience
- Configuration options table in README
- JSON format example in README

### Changed
- Updated from deprecated `nvim_buf_set_option` to `vim.bo[buffer]` API
- Updated from deprecated `nvim_win_set_option` to `vim.wo[window]` API
- Improved error messages throughout the plugin
- Enhanced README with more comprehensive documentation
- Better handling of empty or invalid JSON files

### Fixed
- Potential crash when persistence file is corrupted
- Missing error handling in persistence layer
- Buffer not being modifiable during rendering
- Edge cases with missing directories for storage file

## [1.0.0] - Initial Release

### Added
- Floating sidebar window for TODO management
- Persistent storage in JSON format
- Add, edit, delete, and toggle TODO items
- Pin important items to keep them at the top
- Auto-close behavior when navigating away
- Keyboard shortcuts for all operations
- Help menu with command reference
- Visual indicators for completed and pinned items
- Configurable window width, position, border, and title
- MIT License
