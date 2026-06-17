local parser_names = {
  "lua",        -- For Neovim config files
  "javascript", -- For JS development
  "typescript", -- For TS development
  "python",     -- For Python development
  "html",       -- For web development
  "css",        -- For styling
  "json",       -- For config files
  "markdown",   -- For documentation
  "markdown_inline",
  "bash",       -- For shell scripts
  "vim",        -- For vim files
  "vimdoc",     -- For vim help files
}

local filetypes = {
  "lua",
  "javascript",
  "typescript",
  "python",
  "html",
  "css",
  "json",
  "markdown",
  "sh",
  "bash",
  "vim",
  "help",
}

local ok, treesitter = pcall(require, "nvim-treesitter")

if ok and type(treesitter.install) == "function" then
  treesitter.setup({
    install_dir = vim.fn.stdpath("data") .. "/site",
  })

  -- The new nvim-treesitter API replaces the old ensure_installed module config.
  -- install() is async and is a no-op for parsers that are already installed.
  treesitter.install(parser_names)

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterStart", { clear = true }),
    pattern = filetypes,
    callback = function()
      pcall(vim.treesitter.start)
    end,
  })

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("UserTreesitterIndent", { clear = true }),
    pattern = filetypes,
    callback = function()
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  return
end

if vim.fn.has("nvim-0.12") == 1 then
  vim.schedule(function()
    vim.notify(
      "nvim-treesitter needs :Lazy sync on branch main for Neovim 0.12",
      vim.log.levels.WARN
    )
  end)
  return
end

local legacy_treesitter = require("nvim-treesitter.configs")

legacy_treesitter.setup({
  ensure_installed = parser_names,
  sync_install = false,
  auto_install = true,
  ignore_install = {},

  highlight = {
    enable = true,
    disable = {},
    additional_vim_regex_highlighting = false,
  },

  indent = {
    enable = true,
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "gnn",
      node_incremental = "grn",
      scope_incremental = "grc",
      node_decremental = "grm",
    },
  },
})
