local M = {}

---Merges one or more tables into `dst`.
---@param dst table
---@param ... table
---@return table
function M.merge(dst, ...)
  for _, tbl in ipairs { ... } do
    for k, v in pairs(tbl) do
      dst[k] = v
    end
  end
  return dst
end

M.deep_merge = require("lazy.core.util").merge

---Concats one or more arrays into `dst`.
---@generic T
---@param dst T[]
---@param ... T[]
---@return T[]
function M.concat(dst, ...)
  for _, list in ipairs { ... } do
    for _, elem in ipairs(list) do
      dst[#dst + 1] = elem
    end
  end
  return dst
end

---Checks if a plugin is defined and not disabled (both `enabled` and `cond` is true).
---@param plugin string the plugin name
function M.is_available(plugin)
  local lazy_ok, lazy = pcall(require, "lazy.core.config")
  local plug = lazy_ok and lazy.spec.plugins[plugin] or nil
  if not plug then return false end

  local enabled, cond = plug.enabled, plug.cond
  return not (
    cond == false
    or enabled == false
    or type(cond) == "function" and cond() == false
    or type(enabled) == "function" and enabled() == false
  )
end

---@type table<string,table|false> cache for loaded mapping presets
local loaded_mappings = {}

---A handy function to bind mapping presets.
---@param dst table the table to be set
---@param mappings table<string,table<string,string|table>>
---@return table # return `dst`
function M.make_mappings(dst, mappings)
  local unknowns = {}
  for mode, maps in pairs(mappings) do
    local dst_maps = dst[mode]
    for lhs, rhs in pairs(maps) do
      if type(rhs) == "string" then
        local key = rhs
        if loaded_mappings[key] == nil then -- lazy load mapping presets
          local module = vim.split(key, ".", { plain = true })[1]
          local existed, preset = pcall(require, "deltavim.mappings." .. module)
          if existed then
            local cond = preset[1] and preset[1].cond
            if
              cond == false
              or type(cond) == "string" and not M.is_available(cond) -- if plugin not is disabled
              or type(cond) == "function" and cond() == false -- if it returns false
            then
              for k, _ in pairs(preset) do -- disable all presets
                loaded_mappings[module .. "." .. k] = false
              end
            else
              for k, preset_rhs in pairs(preset) do -- insert all presets
                loaded_mappings[module .. "." .. k] = preset_rhs
              end
            end
          end
        end
        rhs = loaded_mappings[key]
        if rhs == nil then table.insert(unknowns, key) end
      end

      if rhs then dst_maps[lhs] = rhs end
    end
  end

  if #unknowns > 0 then -- report unknown presets
    vim.notify("unknown mapping presets:\n" .. table.concat(unknowns, "\n"), vim.log.levels.ERROR)
  end
  return dst
end

---Lists diagnostics in quickfix.
---@param bufnr integer? buffer to get diagnostics from, 0 for the current or nil for all buffers
---@param opts? vim.diagnostic.GetOpts options passed to `vim.diagnostics.get`
function M.list_diagnostics(bufnr, opts)
  local diags = vim.diagnostic.get(bufnr, opts)
  local qflist = vim.diagnostic.toqflist(diags)
  vim.fn.setqflist(qflist, " ")
  vim.cmd "botright copen"
end

---Opens Telescope to search for files in the given directory, using `git_files`
---if available, or falling back to `find_files`.
---@param cwd? string the directory to search
function M.telescope_find_files(cwd)
  cwd = cwd or vim.fn.getcwd()
  if vim.fn.executable "git" == 1 and vim.uv.fs_stat(cwd .. "/.git") then
    require("telescope.builtin").git_files { cwd = cwd, show_untracked = true }
  else
    require("telescope.builtin").find_files { cwd = cwd }
  end
end

---Resolves all available linters for a specific buffer. This function is a
---drop-in replacement for `require("lint)._resolve_linter_by_ft`.
---@param filetype string? filetype to resolve, default is the current buffer's
function M.resolve_linters_by_ft(filetype)
  local lint = require "lint"
  local by_ft = lint.linters_by_ft
  filetype = filetype or vim.bo.filetype

  -- find all available linters
  local linters = by_ft[filetype]
  if not linters then
    linters = {}
    for _, ft in pairs(vim.split(filetype, ".", { plain = true })) do
      M.concat(linters, by_ft[ft] or {})
    end
  end

  if #linters == 0 then linters = by_ft["_"] or {} end -- use fallback linters
  M.concat(linters, by_ft["*"] or {}) -- append global linters

  -- dedup and validate configured linters
  local dedup_linters = {}
  for _, name in ipairs(linters) do
    if
      not dedup_linters[name]
      and lint.linters[name]
      and vim.fn.executable(lint.linters[name].cmd) == 1
    then
      dedup_linters[name] = true
    end
  end
  return vim.tbl_keys(dedup_linters)
end

---Debounces a function callback, i.e. ensure the function is not invoked until
---`ms` milliseconds have elapsed since the last call.
---@param ms integer minimal milliseconds during two calls
---@param fn function function to be invoked
function M.debounce(ms, fn)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local argv = { ... }
    timer:start(ms, 0, function()
      timer:stop()
      vim.schedule_wrap(fn)(unpack(argv))
    end)
  end
end

return M
