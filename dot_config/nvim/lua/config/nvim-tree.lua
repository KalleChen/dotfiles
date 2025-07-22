local nvim_tree = require("nvim-tree")

nvim_tree.setup({
  sort_by = "case_sensitive",
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,  -- Show dotfiles
  },
})