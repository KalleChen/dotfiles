local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.cursorline = true
opt.termguicolors = true
opt.clipboard = "unnamedplus"
opt.timeout = true
opt.timeoutlen = 100
opt.guicursor = ""

-- Smart case search: ignore case if all lowercase, respect case if mixed
opt.ignorecase = true
opt.smartcase = true

-- Keep 8 lines above and below cursor
opt.scrolloff = 12

-- Folding settings
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99  -- Start with all folds open
opt.foldlevelstart = 99

-- Split behavior - cursor moves to new pane
opt.splitbelow = true  -- Horizontal splits open below
opt.splitright = true  -- Vertical splits open to the right
