local Base16 = {}

---Whether to enable transparent background in the default customization.
Base16.transparent = false

---The default options used to setup mini.base16.
---@type table
Base16.options = {
  use_cterm = false,
  plugins = {
    default = false,
    ["echasnovski/mini.nvim"] = true,
  },
}

---@class meowim.base16.options
---The name to identify this colorscheme.
---@field name string
---THe variant of this colorscheme.
---@field variant? string
---Base16 palette.
---@field palette table<string,string>

---Apply a customized mini.base16 colorscheme.
---@param opts meowim.base16.options
function Base16.setup(opts)
  local suffix = opts.variant and "-" .. opts.variant or ""
  require("meowim.utils").cached_colorscheme({
    name = opts.name .. suffix,
    watch_paths = {
      "/lua/mini/base16.lua", -- upstream
      "/lua/meowim/base16.lua", -- ourself
      "/colors/" .. opts.name .. ".lua", -- palette
    },
    setup = function()
      require("mini.base16").setup(
        vim.tbl_extend("force", Base16.options, { palette = opts.palette })
      )
      local colors = require("mini.colors").get_colorscheme()
      colors = Base16.colors_customizations(opts, colors)
      return colors:apply()
    end,
  })
  vim.g.colors_name = opts.name
end

---Some opinionated customizations on mini.base16.
---@param opts meowim.base16.options
---@param colors table
---@return table
function Base16.colors_customizations(opts, colors)
  if Base16.transparent then colors = colors:add_transparency() end

  local lighten = require("meowim.utils").lighten
  local palette = opts.palette
  local get = function(name)
    return colors.groups[name] --[[@as vim.api.keyset.highlight]]
  end

  -- Use undercurl for diagnostics
  for _, kind in ipairs({ "Ok", "Hint", "Info", "Warn", "Error" }) do
    local hl = get("DiagnosticUnderline" .. kind)
    hl.underline = false
    hl.undercurl = true
  end

  -- Use yellow color for diagnostics.
  get("DiagnosticWarn").fg = palette.base0A
  get("DiagnosticFloatingWarn").fg = palette.base0A
  get("DiagnosticUnderlineWarn").sp = palette.base0A

  -- Transparent highlights
  ---@type string[]
  local transparents = {
    "TabLineFill",
    "StatusLine",
    "StatusLineTerm",
    "StatusLineNC",
    "StatusLineTermNC",

    "CursorLineNr",
    "CursorLineSign",
    "LineNr",
    "LineNrAbove",
    "LineNrBelow",
    "SignColumn",

    "WinSeparator",
    "ErrorMsg",
  }
  for _, name in ipairs(transparents) do
    colors.groups[name].bg = nil
  end

  -- TODO: report inconsistent higroups to mini.base16
  -- Highlight overrides
  -- stylua: ignore
  ---@type table<string,vim.api.keyset.highlight>
  local overrides = {
    ["FloatTitle"]               = { fg = get("Title").fg, bg= palette.base01 },

    ["GitConflictCurrent"]       = { fg = palette.base05, bg = lighten(palette.base0D, -37) },
    ["GitConflictCurrentLabel"]  = { fg = palette.base05, bg = lighten(palette.base0D, -23) },
    ["GitConflictAncestor"]      = { fg = palette.base05, bg = lighten(palette.base0E, -37) },
    ["GitConflictAncestorLabel"] = { fg = palette.base05, bg = lighten(palette.base0E, -23) },
    ["GitConflictIncoming"]      = { fg = palette.base05, bg = lighten(palette.base0B, -37) },
    ["GitConflictIncomingLabel"] = { fg = palette.base05, bg = lighten(palette.base0B, -23) },

    ["MiniDiffOverAdd"]          = { fg = palette.base05, bg = lighten(palette.base0B, -37) },
    ["MiniDiffOverDelete"]       = { fg = palette.base05, bg = lighten(palette.base08, -37) },
    ["MiniDiffOverChange"]       = { fg = palette.base05, bg = lighten(palette.base08, -37) },
    ["MiniDiffOverChangeBuf"]    = { fg = palette.base05, bg = lighten(palette.base0B, -37) },
    ["MiniDiffOverContext"]      = { bg = palette.base01, fg = lighten(palette.base08, -23) },
    ["MiniDiffOverContextBuf"]   = {},

    ["MiniIndentscopeSymbol"]    = { fg = palette.base04 },
    ["MiniIndentscopeSymbolOff"] = { fg = palette.base04 },
  }
  for name, hl in pairs(overrides) do
    colors.groups[name] = hl
  end

  return colors
end

return Base16
