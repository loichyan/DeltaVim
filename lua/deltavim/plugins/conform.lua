---@module "conform"

---@type LazyPluginSpec
local Spec = {
  "stevearc/conform.nvim",
  event = "User AstroFile",
  cmd = { "Format", "ConformInfo" },
  specs = {
    {
      "astrocore",
      opts = {
        options = { opt = { formatexpr = "v:lua.require'conform'.formatexpr()" } },
        commands = {
          Format = {
            function(args)
              local range = nil
              if args.count ~= -1 then
                local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
                range = { ["start"] = { args.line1, 0 }, ["end"] = { args.line2, end_line:len() } }
              end
              require("conform").format { async = true, lsp_fallback = true, range = range }
            end,
            desc = "Format buffer",
            range = true,
          },
        },
      },
    },
  },
  opts = {
    format_on_save = function(bufnr)
      local autoformat = vim.b[bufnr].autoformat
      if autoformat == nil then autoformat = vim.g.autoformat end
      if autoformat ~= false then return { lsp_fallback = true } end
    end,
    formatters_by_ft = {
      lua = { "stylua" },
    },
  },
}

return Spec
