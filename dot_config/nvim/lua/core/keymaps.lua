local keymap = vim.keymap.set
vim.g.mapleader = " "


-- Insert mode escape
keymap("i", "jk", "<ESC>", { noremap = true })

-- Window navigation
keymap("n", "<C-h>", "<C-w>h", { silent = true })
keymap("n", "<C-j>", "<C-w>j", { silent = true })
keymap("n", "<C-k>", "<C-w>k", { silent = true })
keymap("n", "<C-l>", "<C-w>l", { silent = true })

