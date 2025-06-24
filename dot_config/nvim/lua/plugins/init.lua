return {
  -- LSP Support
  { "neovim/nvim-lspconfig" },                         -- Basic LSP setup
  { "williamboman/mason.nvim", build = ":MasonUpdate" }, -- LSP installer

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "hrsh7th/cmp-buffer" },
  { "hrsh7th/cmp-path" },

  -- Syntax Highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- File Explorer
  { "nvim-tree/nvim-tree.lua"},

  -- Git Integration
  { "lewis6991/gitsigns.nvim" },

  -- Fuzzy Finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Which Key
  { "folke/which-key.nvim", event = "VeryLazy" },

  -- Formatting & Linting
  { "stevearc/conform.nvim", event = { "BufReadPre", "BufNewFile" } },
  { "mfussenegger/nvim-lint", event = { "BufReadPre", "BufNewFile" } },

  -- Colorscheme
  {
    "EdenEast/nightfox.nvim",
    config = function()
      vim.cmd.colorscheme("carbonfox")
    end
  },
}
