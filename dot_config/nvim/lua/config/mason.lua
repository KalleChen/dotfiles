local mason = require("mason")

-- Mason setup with auto-install
mason.setup({
  ui = {
    border = "rounded",
    icons = {
      package_installed = "✓",
      package_pending = "➜",
      package_uninstalled = "✗"
    }
  },
  automatic_installation = true,
})

-- Auto-install missing tools on startup
local ensure_installed_tools = {
  -- Language Servers
  "lua-language-server",
  "typescript-language-server", 
  "pyright",
  "yaml-language-server",
  "bash-language-server",
  -- Note: sourcekit-lsp comes with Xcode, no need to install via Mason
  
  -- Formatters
  "black",
  "prettier", 
  "stylua",
  
  -- Linters
  "ruff",
  "eslint_d",
  "shellcheck",
  "yamllint",
  "jsonlint",
  "luacheck",
  "hadolint",
  "swiftlint",
}

local registry = require("mason-registry")
local function ensure_installed()
  for _, tool in ipairs(ensure_installed_tools) do
    local p = registry.get_package(tool)
    if not p:is_installed() then
      p:install()
    end
  end
end

if registry.refresh then
  registry.refresh(ensure_installed)
else
  ensure_installed()
end