local plug = require "pde.utils.plug"

---@type LazySpec
return {
  {
    "stevearc/aerial.nvim",
    event = "User AstroFile",
    opts = plug.opts "aerial",
  },

  {
    "neovim/nvim-lspconfig",
    event = "User AstroFile",
    cmd = { "LspInfo", "LspLog", "LspStart" },
    dependencies = {
      { "folke/neoconf.nvim", lazy = true, opts = {} },
    },
    config = plug.setup "lspconfig",
  },
  { "folke/neodev.nvim", lazy = true, opts = {} },

  {
    "nvimtools/none-ls.nvim",
    main = "null-ls",
    event = "User AstroFile",
    dependencies = {
      { "AstroNvim/astrolsp", optional = true },
      { "nvim-lua/plenary.nvim", lazy = true },
    },
    opts = plug.opts "null-ls",
    config = plug.setup "null-ls",
  },
}
