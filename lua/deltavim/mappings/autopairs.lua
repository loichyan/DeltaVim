return {
  { cond = "autopairs.nvim" },

  toggle_global = {
    function() require("astrocore.toggles").autopairs() end,
    desc = "Toggle autopairs (global)",
  },
}
