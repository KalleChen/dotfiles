local autocmd = vim.api.nvim_create_autocmd

autocmd('VimResized', {
  callback = function()
    vim.cmd('wincmd =') -- Rebalance splits whenever tmux changes the terminal size
  end,
})
