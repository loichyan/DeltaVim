---@type LazyPluginSpec
return {
  "nvim-tree/nvim-web-devicons",
  lazy = true,
  enabled = vim.g.icons_enabled ~= false,
  opts = function()
    return {
      override = {
        default_icon = { icon = require("astroui").get_icon "DefaultFile" },
        deb = { icon = "", name = "Deb" },
        lock = { icon = "󰌾", name = "Lock" },
        mp3 = { icon = "󰎆", name = "Mp3" },
        mp4 = { icon = "", name = "Mp4" },
        out = { icon = "", name = "Out" },
        ttf = { icon = "", name = "TrueTypeFont" },
        rpm = { icon = "", name = "Rpm" },
        woff = { icon = "", name = "WebOpenFontFormat" },
        woff2 = { icon = "", name = "WebOpenFontFormat2" },
        xz = { icon = "", name = "Xz" },
        zip = { icon = "", name = "Zip" },
        ["robots.txt"] = { icon = "󰚩", name = "Robots" },
      },
    }
  end,
}
