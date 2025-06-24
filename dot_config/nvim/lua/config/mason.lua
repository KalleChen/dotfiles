local mason = require("mason")

-- Mason setup (only for package management)
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

-- Disable mason-lspconfig completely to prevent auto-setup
-- Only use Mason for package management, manual LSP config in lsp.lua