local keymap = vim.keymap.set
vim.g.mapleader = " "

keymap("n", "<leader>w", ":w<CR>")
keymap("n", "<leader>q", ":q<CR>")
keymap("n", "<leader>e", ":Ex<CR>")
keymap("i", "jk", "<ESC>", { noremap = true, silent = true })
