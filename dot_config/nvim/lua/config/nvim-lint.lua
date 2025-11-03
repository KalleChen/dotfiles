local lint = require('lint')

-- Helper function to check linter availability with priority fallback
local function get_linter(tool_configs)
  for _, config in ipairs(tool_configs) do
    if config.check_cmd and vim.fn.executable(config.check_cmd) == 1 then
      return config.linter
    end
  end
  -- Return last as default
  return tool_configs[#tool_configs].linter
end

-- Configure linters by filetype with static assignment
lint.linters_by_ft = {
  -- Python: Default to ruff, will be dynamically updated
  python = { "ruff" },

  -- JavaScript/TypeScript: Default to eslint
  javascript = { "eslint" },
  typescript = { "eslint" },
  javascriptreact = { "eslint" },
  typescriptreact = { "eslint" },

  -- Lua: Use luacheck (disabled by default, enable after installing)
  -- lua = { "luacheck" },

  -- Shell scripts
  sh = { "shellcheck" },
  bash = { "shellcheck" },

  -- JSON (disabled until jsonlint is installed)
  -- json = { "jsonlint" },

  -- YAML
  yaml = { "yamllint" },

  -- Docker
  dockerfile = { "hadolint" },

  -- Swift
  swift = { "swiftlint" },
}

-- Function to dynamically set linters based on project
local function setup_dynamic_linters()
  local ft = vim.bo.filetype

  if ft == "python" then
    -- Check for project config files first
    if vim.fn.filereadable("pyproject.toml") == 1 then
      local content = vim.fn.readfile("pyproject.toml")
      local toml_str = table.concat(content, "\n")

      if string.match(toml_str, "%[tool%.ruff") then
        if vim.fn.executable("./venv/bin/ruff") == 1 then
          lint.linters_by_ft.python = { "ruff" }
        elseif vim.fn.executable("ruff") == 1 then
          lint.linters_by_ft.python = { "ruff" }
        end
      elseif string.match(toml_str, "%[tool%.flake8") then
        if vim.fn.executable("./venv/bin/flake8") == 1 then
          lint.linters_by_ft.python = { "flake8" }
        elseif vim.fn.executable("flake8") == 1 then
          lint.linters_by_ft.python = { "flake8" }
        end
      end
    end

    -- Check environment variable
    local env_linter = vim.env.PYTHON_LINTER
    if env_linter == "ruff" and vim.fn.executable("ruff") == 1 then
      lint.linters_by_ft.python = { "ruff" }
    elseif env_linter == "flake8" and vim.fn.executable("flake8") == 1 then
      lint.linters_by_ft.python = { "flake8" }
    end
  elseif ft == "javascript" or ft == "typescript" or ft == "javascriptreact" or ft == "typescriptreact" then
    -- Find project root by looking for package.json or .eslintrc.js
    local function find_project_root()
      local current_file = vim.api.nvim_buf_get_name(0)
      if current_file == "" then return nil end
      
      local current_dir = vim.fn.fnamemodify(current_file, ":h")
      
      -- Look for markers going up the directory tree
      local markers = { "package.json", ".eslintrc.js", ".eslintrc.json", "eslint.config.js" }
      local root = vim.fs.find(markers, { path = current_dir, upward = true })[1]
      
      if root then
        return vim.fn.fnamemodify(root, ":h")
      end
      return nil
    end
    
    local project_root = find_project_root()
    if project_root then
      local project_eslint = project_root .. "/node_modules/.bin/eslint"
      if vim.fn.executable(project_eslint) == 1 then
        -- Create custom linter that runs from project root
        lint.linters.eslint_project = vim.tbl_deep_extend("force", lint.linters.eslint, {
          cmd = project_eslint,
          cwd = project_root,
        })
        lint.linters_by_ft[ft] = { "eslint_project" }
      else
        lint.linters_by_ft[ft] = { "eslint" }
      end
    else
      lint.linters_by_ft[ft] = { "eslint" }
    end
  end
end

-- Create autocommand to trigger linting
local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
  group = lint_augroup,
  callback = function()
    -- Only lint if file is not too large (> 100KB)
    local max_filesize = 100 * 1024 -- 100 KB
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(0))
    if ok and stats and stats.size > max_filesize then
      return
    end

    -- Setup dynamic linters based on project
    setup_dynamic_linters()

    lint.try_lint()
  end,
})

-- Manual lint trigger keymap
vim.keymap.set("n", "<leader>ll", function()
  lint.try_lint()
end, { desc = "Trigger linting for current file" })

