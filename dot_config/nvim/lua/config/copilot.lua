-- GitHub Copilot configuration

-- Copilot.vim settings
vim.g.copilot_no_tab_map = true  -- Disable default Tab mapping
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""

if not vim.g.copilot_deprecation_filter_installed then
  local original_deprecate = vim.deprecate

  vim.deprecate = function(name, alternative, version, plugin, backtrace)
    -- copilot.vim intentionally still uses start_client() to avoid a restart
    -- regression with vim.lsp.start(); keep unrelated deprecation warnings visible.
    if name == "vim.lsp.start_client()" then
      local trace = debug.traceback("", 2)
      if trace:find("copilot.vim/lua/_copilot.lua", 1, true) then
        return nil
      end
    end

    return original_deprecate(name, alternative, version, plugin, backtrace)
  end

  vim.g.copilot_deprecation_filter_installed = true
end

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
