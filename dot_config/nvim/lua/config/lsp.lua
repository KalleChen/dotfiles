local lspconfig = require("lspconfig") -- Load LSP configuration module

-- Configure diagnostic display
vim.diagnostic.config({
  virtual_text = true,          -- Show diagnostics as virtual text at end of line
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = " ",
      [vim.diagnostic.severity.WARN] = " ",
      [vim.diagnostic.severity.HINT] = " ",
      [vim.diagnostic.severity.INFO] = " ",
    },
  },
  underline = true,             -- Underline diagnostic text
  update_in_insert = false,     -- Don't update diagnostics while typing
  severity_sort = true,         -- Sort by severity
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

-- Function that runs when LSP attaches to a buffer
local on_attach = function(client, bufnr)
  local keymap = vim.keymap.set -- Shorthand for setting keymaps
  local opts = { buffer = bufnr, silent = true } -- Keymap options: buffer-local, no command echo

  -- Navigation keymaps
  keymap("n", "gd", vim.lsp.buf.definition, opts)     -- Go to definition
  keymap("n", "gD", vim.lsp.buf.declaration, opts)    -- Go to declaration
  keymap("n", "gi", vim.lsp.buf.implementation, opts) -- Go to implementation
  keymap("n", "gr", vim.lsp.buf.references, opts)     -- Show all references

  -- Information keymaps
  keymap("n", "K", vim.lsp.buf.hover, opts)           -- Show hover documentation
  keymap("n", "<C-k>", vim.lsp.buf.signature_help, opts) -- Show function signature

  -- Action keymaps
  keymap("n", "<leader>rn", vim.lsp.buf.rename, opts)      -- Rename symbol
  keymap("n", "<leader>ca", vim.lsp.buf.code_action, opts) -- Show code actions
  keymap("n", "<leader>f", vim.lsp.buf.format, opts)       -- Format current buffer

  -- Diagnostic keymaps
  keymap("n", "<leader>lk", vim.diagnostic.goto_prev, opts)        -- Go to previous diagnostic
  keymap("n", "<leader>lj", vim.diagnostic.goto_next, opts)        -- Go to next diagnostic
  keymap("n", "<leader>d", vim.diagnostic.open_float, opts) -- Show diagnostic in floating window
end

-- Get completion capabilities from nvim-cmp for LSP
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Configure Lua language server
lspconfig.lua_ls.setup({
  on_attach = on_attach,     -- Use our keymap function
  capabilities = capabilities, -- Enable completion support
  settings = {               -- Language server specific settings
    Lua = {
      diagnostics = {
        globals = { "vim" },  -- Tell Lua LSP that 'vim' is a global (avoid warnings)
      },
    },
  },
})

-- Configure TypeScript/JavaScript language server
lspconfig.ts_ls.setup({
  on_attach = on_attach,     -- Use our keymap function
  capabilities = capabilities, -- Enable completion support
})

-- Configure Python language server
lspconfig.pyright.setup({
  on_attach = on_attach,     -- Use our keymap function
  capabilities = capabilities, -- Enable completion support
})
