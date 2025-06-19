local mason = require("mason")
local mason_lspconfig = require("mason-lspconfig")

-- Mason setup
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  }
})

-- Mason-lspconfig setup
mason_lspconfig.setup({
  ensure_installed = {
    "lua_ls",      -- Lua
    "ts_ls",       -- TypeScript/JavaScript
    "pyright",     -- Python
  },
  automatic_installation = true,
})