local treesitter = require("nvim-treesitter.configs")

treesitter.setup({
  -- Ensure these language parsers are installed
  ensure_installed = {
    "lua",        -- For Neovim config files
    "javascript", -- For JS development
    "typescript", -- For TS development  
    "python",     -- For Python development
    "html",       -- For web development
    "css",        -- For styling
    "json",       -- For config files
    "markdown",   -- For documentation
    "bash",       -- For shell scripts
    "vim",        -- For vim files
    "vimdoc",     -- For vim help files
  },

  -- Install parsers synchronously (only applied to `ensure_installed`)
  sync_install = false,

  -- Automatically install missing parsers when entering buffer
  auto_install = true,

  -- List of parsers to ignore installing (for "all")
  ignore_install = {},

  ---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
  -- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

  highlight = {
    enable = true,              -- Enable syntax highlighting

    -- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
    -- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
    -- the name of the parser)
    -- list of language that will be disabled
    disable = {},

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,              -- Enable treesitter-based indentation
  },

  incremental_selection = {
    enable = true,              -- Enable incremental selection
    keymaps = {
      init_selection = "gnn",   -- Start selection
      node_incremental = "grn", -- Increment to the upper named parent
      scope_incremental = "grc", -- Increment to the upper scope
      node_decremental = "grm", -- Decrement to the previous node
    },
  },
})
