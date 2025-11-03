local comment = require('Comment')

comment.setup({
  -- Add a space b/w comment and the line
  padding = true,
  -- Whether the cursor should stay at its position
  sticky = true,
  -- Lines to be ignored while (un)comment
  ignore = nil,
  -- LHS mappings in NORMAL mode
  toggler = {
    line = '<leader>/',  -- Line-comment toggle keymap
    block = '<leader>?', -- Block-comment toggle keymap
  },
  -- LHS mappings in VISUAL/SELECT mode
  opleader = {
    line = '<leader>/',  -- Line-comment keymap
    block = '<leader>?', -- Block-comment keymap
  },
  -- LHS mappings in NORMAL + VISUAL mode
  extra = {
    above = '<leader>cO', -- Add comment on the line above
    below = '<leader>co', -- Add comment on the line below
    eol = '<leader>cA',   -- Add comment at the end of line
  },
  -- Enable keybindings
  mappings = {
    basic = true,
    extra = true,
  },
  -- Function to call before (un)comment
  pre_hook = nil,
  -- Function to call after (un)comment
  post_hook = nil,
})