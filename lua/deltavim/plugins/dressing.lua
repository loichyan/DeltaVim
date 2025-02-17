---@module "dressing.nvim"

---@type LazyPluginSpec
local Spec = {
  "stevearc/dressing.nvim",
  lazy = true,
  init = function()
    require("astrocore").load_plugin_with_func("dressing.nvim", vim.ui, { "input", "select" })
  end,
  opts = function()
    return {
      input = { default_prompt = require("astroui").get_icon "Prompt" },
      select = { backend = { "telescope", "builtin" } },
    }
  end,
}

return Spec
