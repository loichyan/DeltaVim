---@type LazyPluginSpec[]
local Spec = {
  {
    "echasnovski/mini.nvim",
    lazy = false, -- PERF: don't stress the cache.
  },
  {
    import = "deltavim.plugins.mini",
  },
}

return not package.loaded["mini"] and Spec or {}
