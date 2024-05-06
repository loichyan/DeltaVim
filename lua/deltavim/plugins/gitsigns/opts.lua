local icon = require("astroui").get_icon

return {
  signs = {
    add = { text = icon "GitSign" },
    change = { text = icon "GitSign" },
    delete = { text = icon "GitSign" },
    todeltavimlete = { text = icon "GitSign" },
    changedelete = { text = icon "GitSign" },
    untracked = { text = icon "GitSign" },
  },
  current_line_blame = true,
  preview_config = { border = require("deltavim").get_border "popup_border" },
  worktrees = require("astrocore").config.git_worktrees,
}