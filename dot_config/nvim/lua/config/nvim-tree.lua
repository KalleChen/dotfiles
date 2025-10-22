local nvim_tree = require("nvim-tree")

nvim_tree.setup({
  sort_by = "case_sensitive",
  sync_root_with_cwd = true, -- Keep nvim cwd aligned with tree root
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,  -- Show dotfiles
  },
  update_focused_file = {
    enable = true, -- Reveal current buffer in the tree
    update_root = true, -- Shift tree root to match focused file
  },
})
