local Autocmd = require("deltavim.core.autocmd")
local Util = require("deltavim.util")

local M = {}

---@type DeltaVim.Autocmds
M.DEFAULT = {
  { "@auto_create_dir", true },
  { "@checktime", true },
  {
    "@close_with_q",
    ft = {
      "checkhealth",
      "git",
      "help",
      "lspinfo",
      "man",
      "neotest-output",
      "neotest-output-panel",
      "neotest-summary",
      "notify",
      "null-ls-info",
      "qf",
      "query",
      "spectre_panel",
      "startuptime",
      "tsplayground",
      "vim",
      "PlenaryTestPopup",
      "TelescopePrompt",
    },
  },
  { "@highlight_yank", true },
  { "@last_loc", exclude = { "gitcommit" } },
  { "@resize_splits", true },
  { "@rulers", ft = { lua = 80 } },
  { "@spell", ft = { "gitcommit", "markdown", "tex" } },
  { "@trim_whitespace", true },
  { "@wrap", ft = { "gitcommit", "markdown", "tex" } },
}

---@type DeltaVim.Autocmd.Collector
local CONFIG

function M.init()
  CONFIG = Autocmd.load(Util.reduce("list", {}, M.DEFAULT, Util.load_config("custom.autocmds") or {}))
end

function M.setup()
  ---@type DeltaVim.Autocmd.Callback
  local function auto_create_dir(ev)
    if ev.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(ev.match) or ev.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end

  ---@class DeltaVim.Autocmds.CloseWithQ
  ---@field ft string[]
  ---@type DeltaVim.Autocmd.Schema
  local close_with_q_args = { ft = "list" }

  ---@type DeltaVim.Autocmd.With
  local function close_with_q(src)
    ---@type DeltaVim.Autocmd.Callback
    local function cb(ev)
      vim.bo[ev.buf].buflisted = false
      Util.keymap("n", "q", "<Cmd>close<CR>", { buffer = ev.buf })
    end
    return { "FileType", cb, pattern = src.args.ft }
  end

  ---@class DeltaVim.Autocmds.LastLoc
  ---@field exclude string[]
  ---@type DeltaVim.Autocmd.Schema
  local last_loc_args = { exclude = "list" }

  ---@type DeltaVim.Autocmd.With
  local function last_loc(src)
    local exclude = src.args.exclude
    return {
      "BufReadPost",
      function()
        local buf = vim.api.nvim_get_current_buf()
        if vim.tbl_contains(exclude, vim.bo[buf].filetype) then
          return
        end
        local mark = vim.api.nvim_buf_get_mark(buf, '"')
        local lcount = vim.api.nvim_buf_line_count(buf)
        if mark[1] > 0 and mark[1] <= lcount then
          pcall(vim.api.nvim_win_set_cursor, 0, mark)
        end
      end,
    }
  end

  local function resize_splits()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. vim.fn.tabpagenr())
  end

  ---@class DeltaVim.Autocmds.Ruler
  ---@field ft table<string,integer|integer[]>
  ---@type DeltaVim.Autocmd.Schema
  local rulers_args = { ft = "map" }

  ---@type DeltaVim.Autocmd.With
  local function rulers(src)
    ---@class DeltaVim.Autocmd[]
    local autocmds = {}
    for ft, offs in pairs(src.args.ft) do
      ---@type string[]
      local cc = {}
      if type(offs) == "table" then
        for _, v in ipairs(offs) do
          table.insert(cc, tostring(v))
        end
      else
        table.insert(cc, tostring(offs))
      end
      table.insert(autocmds, {
        "FileType",
        function()
          vim.opt_local.colorcolumn = cc
        end,
        pattern = ft,
      })
    end
    autocmds.grouped = "DeltaVimRulers"
    return autocmds
  end

  ---@class DeltaVim.Autocmds.Spell
  ---@field ft string[]
  ---@type DeltaVim.Autocmd.Schema
  local spell_args = { ft = "list" }

  ---@type DeltaVim.Autocmd.With
  local function spell(src)
    ---@type DeltaVim.Autocmd.Callback
    local function cb()
      vim.opt_local.spell = true
    end
    return { "FileType", cb, pattern = src.args.ft }
  end

  ---@param ev DeltaVim.Autocmd.Event
  local function trim_whitespace(ev)
    if vim.b[ev.buf]["deltavim.config.autocmds.trim_whitespace"] ~= false then
      vim.cmd([[%s/\s\+$//e]])
    end
  end

  ---@class DeltaVim.Autocmds.Wrap
  ---@field ft string[]
  ---@type DeltaVim.Autocmd.Schema
  local wrap_args = { ft = "list" }

  ---@type DeltaVim.Autocmd.With
  local function wrap(src)
    ---@type DeltaVim.Autocmd.Callback
    local function cb()
      vim.opt_local.wrap = true
    end
    return { "FileType", cb, pattern = src.args.ft }
  end

  CONFIG:map({
    { "@auto_create_dir", "BufWritePre", auto_create_dir },
    { "@checktime", { "FocusGained", "TermClose", "TermLeave" }, "checktime" },
    { "@close_with_q", with = close_with_q, args = close_with_q_args },
    -- stylua: ignore
    { "@highlight_yank", "TextYankPost", function() vim.highlight.on_yank() end },
    { "@last_loc", with = last_loc, args = last_loc_args },
    { "@resize_splits", "VimResized", resize_splits },
    { "@rulers", with = rulers, args = rulers_args },
    { "@spell", with = spell, args = spell_args },
    { "@trim_whitespace", "BufWritePre", trim_whitespace },
    { "@wrap", with = wrap, args = wrap_args },
  }):collect_and_set()
end

return M
