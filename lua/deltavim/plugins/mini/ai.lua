return {
  "mini.ai",
  dev = true,
  event = "User AstroFile",
  dependencies = { "nvim-treesitter-textobjects" },
  opts = function()
    local treesitter = require("mini.ai").gen_spec.treesitter
    return {
      custom_textobjects = {
        a = treesitter { a = "@parameter.outer", i = "@parameter.inner" },
        c = treesitter { a = "@class.outer", i = "@class.inner" },
        f = treesitter { a = "@function.outer", i = "@function.inner" },
        o = treesitter {
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        },
      },
      search_method = "cover_or_next",
    }
  end,
  config = function(_, opts)
    require("mini.ai").setup(opts)

    -- add descriptions
    if require("deltavim.utils").is_available "which-key.nvim" then
      local whichkey_ok, whichkey = pcall(require, "which-key")
      if not whichkey_ok then return end
      whichkey.add {
        mode = { "o", "x" },
        { "aa", desc = "around parameter" },
        { "ia", desc = "inside parameter" },
        { "ac", desc = "around class" },
        { "ic", desc = "inside class" },
        { "af", desc = "around function" },
        { "if", desc = "inside function" },
        { "ak", desc = "around block/conditional/loop" },
        { "ik", desc = "inside block/conditional/loop" },

        { "al", desc = "around last textobject" },
        { "il", desc = "inside last textobject" },
        { "an", desc = "around next textobject" },
        { "in", desc = "inside next textobject" },
      }
    end
  end,
}
