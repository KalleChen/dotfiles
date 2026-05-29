local opt = vim.opt

opt.number = true
opt.relativenumber = true
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.cursorline = true
opt.termguicolors = true

-- Use a remote-friendly clipboard provider inside SSH sessions.
if vim.env.SSH_TTY or vim.env.SSH_CONNECTION or vim.env.SSH_CLIENT then
  if vim.env.TMUX and vim.fn.executable("tmux") == 1 then
    local function copy_to_tmux(lines)
      -- Ask tmux to write its buffer to the terminal clipboard.
      vim.fn.system({ "tmux", "load-buffer", "-w", "-" }, table.concat(lines, "\n"))
    end

    vim.g.clipboard = {
      name = "tmux",
      copy = {
        ["+"] = copy_to_tmux,
        ["*"] = copy_to_tmux,
      },
      paste = {
        ["+"] = function()
          return vim.split(vim.fn.system({ "tmux", "save-buffer", "-" }), "\n"), "v"
        end,
        ["*"] = function()
          return vim.split(vim.fn.system({ "tmux", "save-buffer", "-" }), "\n"), "v"
        end,
      },
    }
  else
    vim.g.clipboard = "osc52"
  end
end

opt.clipboard = "unnamedplus"
opt.timeout = true
opt.timeoutlen = 100
opt.guicursor = ""
opt.equalalways = true -- Keep splits evenly sized after any resize event

-- Smart case search: ignore case if all lowercase, respect case if mixed
opt.ignorecase = true
opt.smartcase = true

-- Keep 8 lines above and below cursor
opt.scrolloff = 12

-- Folding settings
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldlevel = 99  -- Start with all folds open
opt.foldlevelstart = 99

-- Split behavior - cursor moves to new pane
opt.splitbelow = true  -- Horizontal splits open below
opt.splitright = true  -- Vertical splits open to the right
