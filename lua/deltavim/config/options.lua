local Util = require("deltavim.util")

local M = {}

---Modified: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
---@class DeltaVim.Options
M.DEFAULT = {
  ---DeltaVim configurations
  ---@type DeltaVim.Config
  config = {},
  ---vim.g
  g = {
    mapleader = " ",
    maplocalleader = " ",
    markdown_recommended_style = 0, -- Fix markdown indentation settings
  },
  ---vim.o
  o = {
    autowrite = true, -- Enable auto write
    clipboard = "unnamedplus", -- Sync with system clipboard
    completeopt = "menu,menuone,noselect",
    conceallevel = 3, -- Hide * markup for bold and italic
    confirm = true, -- Confirm to save changes before exiting modified buffer
    cursorline = true, -- Enable highlighting of the current line
    expandtab = true, -- Use spaces instead of tabs
    formatoptions = "jcroqlnt", -- tcqj
    grepformat = "%f:%l:%c:%m",
    grepprg = "rg ,--vimgrep",
    ignorecase = true, -- Ignore case
    inccommand = "nosplit", -- preview incremental substitute
    laststatus = 0,
    list = true, -- Show some invisible characters (tabs...
    mouse = "a", -- Enable mouse mode
    number = true, -- Print line number
    pumblend = 10, -- Popup blend
    pumheight = 10, -- Maximum number of entries in a popup
    relativenumber = true, -- Relative line numbers
    scrolloff = 4, -- Lines of context
    sessionoptions = { "buffers", "curdir", "tabpages", "winsize" },
    shiftround = true, -- Round indent
    shiftwidth = 2, -- Size of an indent
    showmode = false, -- Dont show mode since we have a statusline
    sidescrolloff = 8, -- Columns of context
    signcolumn = "yes", -- Always show the signcolumn, otherwise it would shift the text each time
    smartcase = true, -- Don't ignore case with capitals
    smartindent = true, -- Insert indents automatically
    spelllang = { "en" },
    splitbelow = true, -- Put new windows below current
    splitright = true, -- Put new windows right of current
    tabstop = 2, -- Number of spaces tabs count for
    termguicolors = true, -- True color support
    timeoutlen = 300,
    undofile = true,
    undolevels = 10000,
    updatetime = 200, -- Save swap file and trigger CursorHold
    wildmode = "longest:full,full", -- Command-line completion mode
    winminwidth = 5, -- Minimum window width
    wrap = false, -- Disable line wrap
  },
}

---@type DeltaVim.Options
local CONFIG

function M.init()
  -- Other options.
  vim.opt.shortmess:append({ W = true, I = true, c = true })
  if vim.fn.has("nvim-0.9.0") == 1 then
    vim.opt.splitkeep = "screen"
    vim.opt.shortmess:append({ C = true })
  end

  local cfg = Util.load_config("config.options")
  if cfg == false then
    CONFIG = {}
  else
    CONFIG = Util.reduce("table", {}, M.DEFAULT, cfg or {})
  end
end

function M.setup()
  require("deltavim.config").update(CONFIG.config)
  for k, v in pairs(CONFIG.g) do
    vim.g[k] = v
  end
  for k, v in pairs(CONFIG.o) do
    vim.opt[k] = v
  end
end

return M
