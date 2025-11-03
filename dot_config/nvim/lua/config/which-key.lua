local wk = require("which-key")

wk.setup({
  -- your configuration comes here
  -- or leave it empty to use the default settings
})

-- Register key mappings using the new API
wk.add({
  { "<leader>f", group = "Find" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Live Grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
  { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Tags" },
  { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent Files" },
  { "<leader>fc", "<cmd>Telescope commands<cr>", desc = "Commands" },
  { "<leader>e", group = "Explorer" },
  { "<leader>ee", "<cmd>NvimTreeToggle<cr>", desc = "Toggle Explorer" },
  { "<leader>ef", "<cmd>NvimTreeFocus<cr>", desc = "Focus Explorer" },
  { "<leader>c", group = "Code" },
  { "<leader>ca", function() vim.lsp.buf.code_action() end, desc = "Code Actions" },
  { "<leader>cr", function() vim.lsp.buf.rename() end, desc = "Rename Symbol" },
  { "<leader>cf", desc = "Format Buffer" },
  { "<leader>l", group = "LSP" },
  { "<leader>ld", function() vim.diagnostic.open_float() end, desc = "Show Diagnostics" },
  { "<leader>lk", function() vim.diagnostic.goto_prev() end, desc = "Previous Diagnostic" },
  { "<leader>lj", function() vim.diagnostic.goto_next() end, desc = "Next Diagnostic" },
  { "<leader>ll", desc = "Trigger Linting" },
  { "<leader>g", group = "Git" },
  { "<leader>gg", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
  { "<leader>gl", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle Git Blame" },
  { "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open Diffview" },
  { "<leader>gc", "<cmd>DiffviewClose<cr>", desc = "Close Diffview" },
  { "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File History" },
  { "<leader>gf", "<cmd>DiffviewFileHistory %<cr>", desc = "Current File History" },
  { "<leader>gm", "<cmd>DiffviewOpen HEAD~1<cr>", desc = "Diff with Previous Commit" },
  { "<leader>w", "<cmd>w<cr>", desc = "Save" },
  { "<leader>q", "<cmd>q<cr>", desc = "Quit" },
  { "<leader>x", "<cmd>bd<cr>", desc = "Close Buffer" },
})
