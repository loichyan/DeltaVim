local M = {}

---@param name string
---@return function
function M.opts(name)
  local mod = "pde.plugins." .. name .. ".opts"
  return function(_, opts) return require("pde.utils").deep_merge(opts, require(mod)) end
end

---@param name string
---@return function
function M.keys(name)
  local mod = "pde.plugins." .. name .. ".keys"
  return function(_, keys) return require("pde.utils").list_extend(keys, require(mod)) end
end

---@param name string
---@return function
function M.config(name)
  local mod = "pde.plugins." .. name .. ".config"
  return function(...) return require(mod)(...) end
end

---@param name string
---@return function
function M.autocmds(name)
  local mod = "pde.plugins." .. name .. ".autocmds"
  return function(_, opts)
    opts.autocmds = require("pde.utils").merge(opts.autocmds or {}, require(mod))
    return opts
  end
end

return M
