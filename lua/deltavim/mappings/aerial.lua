return {
  { cond = "aerial.nvim" },

  toggle = {
    function() require("aerial").toggle { direction = "right" } end,
    desc = "Symbols outline",
  },
}
