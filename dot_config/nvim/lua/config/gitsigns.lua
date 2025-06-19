local gitsigns = require("gitsigns")

gitsigns.setup({
  signs = {
    add          = { text = '┃' }, -- Added lines indicator
    change       = { text = '┃' }, -- Modified lines indicator  
    delete       = { text = '_' }, -- Deleted lines indicator
    topdelete    = { text = '‾' }, -- Deleted lines at top
    changedelete = { text = '~' }, -- Changed and deleted lines
    untracked    = { text = '┆' }, -- Untracked files indicator
  },
  
  signs_staged = {
    add          = { text = '┃' }, -- Staged additions
    change       = { text = '┃' }, -- Staged changes
    delete       = { text = '_' }, -- Staged deletions
    topdelete    = { text = '‾' }, -- Staged deletions at top
    changedelete = { text = '~' }, -- Staged changed+deleted
    untracked    = { text = '┆' }, -- Staged untracked
  },

  signs_staged_enable = true,         -- Show staged changes separately
  signcolumn = true,                  -- Toggle with `:Gitsigns toggle_signs`
  numhl = false,                      -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false,                     -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false,                  -- Toggle with `:Gitsigns toggle_word_diff`
  
  watch_gitdir = {
    follow_files = true,              -- Watch for git directory changes
  },

  auto_attach = true,                 -- Automatically attach to git buffers
  attach_to_untracked = false,        -- Don't attach to untracked files

  current_line_blame = true,          -- Auto-show git blame virtual text
  current_line_blame_opts = {
    virt_text = true,                 -- Show blame as virtual text
    virt_text_pos = 'eol',           -- Position: 'eol' | 'overlay' | 'right_align'
    delay = 0,                        -- Instant blame display
    ignore_whitespace = false,        -- Ignore whitespace changes
    virt_text_priority = 100,         -- Priority of virtual text
  },
  
  current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
  
  sign_priority = 6,                  -- Priority of gitsigns (higher = more important)
  update_debounce = 100,             -- Debounce time for updates (ms)
  status_formatter = nil,             -- Use default status formatter
  max_file_length = 40000,           -- Disable for files longer than this
  preview_config = {
    -- Options passed to nvim_open_win for preview window
    border = 'single',                -- Border style
    style = 'minimal',                -- Window style
    relative = 'cursor',              -- Position relative to cursor
    row = 0,                          -- Row offset
    col = 1                           -- Column offset
  },

  on_attach = function(bufnr)
    local gs = package.loaded.gitsigns
    local keymap = vim.keymap.set
    local opts = { buffer = bufnr, silent = true }

    -- Navigation keymaps - jump between git hunks
    keymap('n', ']c', function()
      if vim.wo.diff then return ']c' end  -- If in diff mode, use default
      vim.schedule(function() gs.next_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Next git hunk" })

    keymap('n', '[c', function()
      if vim.wo.diff then return '[c' end  -- If in diff mode, use default  
      vim.schedule(function() gs.prev_hunk() end)
      return '<Ignore>'
    end, { expr = true, buffer = bufnr, desc = "Previous git hunk" })

    -- Actions keymaps - git operations
    keymap('n', '<leader>hs', gs.stage_hunk, { buffer = bufnr, desc = "Stage hunk" })
    keymap('n', '<leader>hr', gs.reset_hunk, { buffer = bufnr, desc = "Reset hunk" })
    keymap('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { buffer = bufnr, desc = "Stage selected lines" })
    keymap('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, { buffer = bufnr, desc = "Reset selected lines" })
    keymap('n', '<leader>hS', gs.stage_buffer, { buffer = bufnr, desc = "Stage entire buffer" })
    keymap('n', '<leader>hu', gs.undo_stage_hunk, { buffer = bufnr, desc = "Undo stage hunk" })
    keymap('n', '<leader>hR', gs.reset_buffer, { buffer = bufnr, desc = "Reset entire buffer" })
    keymap('n', '<leader>hp', gs.preview_hunk, { buffer = bufnr, desc = "Preview hunk" })
    keymap('n', '<leader>hb', function() gs.blame_line{full=true} end, { buffer = bufnr, desc = "Blame line (full)" })
    keymap('n', '<leader>tb', gs.toggle_current_line_blame, { buffer = bufnr, desc = "Toggle line blame" })
    keymap('n', '<leader>hd', gs.diffthis, { buffer = bufnr, desc = "Diff this file" })
    keymap('n', '<leader>hD', function() gs.diffthis('~') end, { buffer = bufnr, desc = "Diff this file (cached)" })
    keymap('n', '<leader>td', gs.toggle_deleted, { buffer = bufnr, desc = "Toggle deleted lines" })

    -- Text object for git hunks
    keymap({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { buffer = bufnr, desc = "Select hunk text object" })
  end
})
