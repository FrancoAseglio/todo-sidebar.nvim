-- Luacheck configuration for todo-sidebar.nvim
std = "luajit"
globals = {
    "vim",
}
read_globals = {
    "vim",
}
ignore = {
    "211", -- Unused local variable
    "212", -- Unused argument
    "213", -- Unused loop variable
}
exclude_files = {
    ".git",
    "tests",
}
max_line_length = 120
