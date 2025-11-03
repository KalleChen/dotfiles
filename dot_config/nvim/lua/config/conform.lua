local conform = require("conform")

-- Function to setup dynamic formatters based on project
local function setup_dynamic_formatters()
  local ft = vim.bo.filetype

  if ft == "python" then
    -- Check for project config files first
    if vim.fn.filereadable("pyproject.toml") == 1 then
      local content = vim.fn.readfile("pyproject.toml")
      local toml_str = table.concat(content, "\n")

      if string.match(toml_str, "%[tool%.ruff") then
        if vim.fn.executable("./venv/bin/ruff") == 1 then
          conform.formatters_by_ft.python = { "ruff_format" }
        elseif vim.fn.executable("ruff") == 1 then
          conform.formatters_by_ft.python = { "ruff_format" }
        end
        return
      elseif string.match(toml_str, "%[tool%.black") then
        if vim.fn.executable("./venv/bin/black") == 1 then
          conform.formatters_by_ft.python = { "black" }
        elseif vim.fn.executable("black") == 1 then
          conform.formatters_by_ft.python = { "black" }
        end
        return
      end
    end

    -- Check environment variable
    local env_formatter = vim.env.PYTHON_FORMATTER
    if env_formatter == "ruff" and vim.fn.executable("ruff") == 1 then
      conform.formatters_by_ft.python = { "ruff_format" }
    elseif env_formatter == "black" and vim.fn.executable("black") == 1 then
      conform.formatters_by_ft.python = { "black" }
    end
  elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
    -- Find project root by looking for package.json or prettier config
    local function find_project_root()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then return nil end
      
      local current_dir = vim.fn.fnamemodify(current_file, ":h")
      
      -- Look for markers going up the directory tree
      local markers = { "package.json", ".prettierrc", ".prettierrc.js", ".prettierrc.json", "prettier.config.js" }
      local root = vim.fs.find(markers, { path = current_dir, upward = true })[1]
      
      if root then
        return vim.fn.fnamemodify(root, ":h")
      end
      return nil
    end
    
    local project_root = find_project_root()
    if project_root then
      local project_prettier = project_root .. "/node_modules/.bin/prettier"
      if vim.fn.executable(project_prettier) == 1 then
        -- Create custom formatter that runs from project root
        conform.formatters.prettier_project = vim.tbl_deep_extend("force", conform.formatters.prettier or {}, {
          command = project_prettier,
          cwd = function() return project_root end,
          args = { "--stdin-filepath", "$FILENAME" },
        })
        conform.formatters_by_ft[ft] = { "prettier_project" }
      else
        conform.formatters_by_ft[ft] = { "prettier" }
      end
    else
      conform.formatters_by_ft[ft] = { "prettier" }
    end
  end
end

conform.setup({
  formatters_by_ft = {
    -- Static defaults, will be updated dynamically
    python = { "black" },
    javascript = { "prettier" },
    typescript = { "prettier" },
    lua = { "stylua" },
    swift = { "swiftformat" },
    json = { "prettier" },
    yaml = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
  },

  -- Format on save disabled (manual formatting only)
  -- format_on_save = {
  --   timeout_ms = 500,
  --   lsp_fallback = true,
  -- },
})

-- Custom keymap for manual formatting
vim.keymap.set({ "n", "v" }, "<leader>cf", function()
  -- Setup dynamic formatters before manual format
  setup_dynamic_formatters()

  conform.format({
    lsp_fallback = true,
    async = false,
    timeout_ms = 1000,
  })
end, { desc = "Format file or range (in visual mode)" })

