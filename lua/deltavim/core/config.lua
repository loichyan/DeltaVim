local Autocmds = require("deltavim.config.autocmds")
local Keymaps = require("deltavim.config.keymaps")
local Options = require("deltavim.config.options")
local Util = require("deltavim.util")

local M = {}

local did_init = false
function M.init()
  if did_init then return end
  did_init = true

  -- Initialize configs.
  Autocmds.init()
  Keymaps.init()
  Options.init()

  -- Load options before installing plugins.
  Options.setup()
end

function M.setup()
  if vim.fn.argc(-1) == 0 then
    Util.on_very_lazy(function()
      Autocmds.setup()
      Keymaps.setup()
    end)
  else
    Autocmds.setup()
    Keymaps.setup()
  end
end

return M
