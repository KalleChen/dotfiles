-- GitHub Copilot configuration

-- Copilot.vim settings
vim.g.copilot_no_tab_map = true  -- Disable default Tab mapping
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

-- Copilot keymaps
local keymap = vim.keymap.set

-- Accept copilot suggestion
keymap("i", "<C-e>", 'copilot#Accept("<CR>")', { 
  expr = true, 
  replace_keycodes = false,
  desc = "Accept Copilot suggestion"
})

-- Navigate copilot suggestions  
keymap("i", "<M-j>", "<Plug>(copilot-next)", { desc = "Next Copilot suggestion" })
keymap("i", "<M-k>", "<Plug>(copilot-previous)", { desc = "Previous Copilot suggestion" })
keymap("i", "<C-d>", "<Plug>(copilot-dismiss)", { desc = "Dismiss Copilot suggestion" })

-- Manual trigger copilot
keymap("i", "<M-\\>", "<Plug>(copilot-suggest)", { desc = "Trigger Copilot suggestion" })