return {
  icons = {
    group = vim.g.icons_enabled ~= false and "" or "+",
    separator = "-",
  },
  disable = { filetypes = { "TelescopePrompt" } },
  window = { border = require("deltavim").get_border "popup_border" },
}