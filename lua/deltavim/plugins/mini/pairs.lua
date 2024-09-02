---@type LazyPluginSpec
return {
  "mini.pairs",
  dev = true,
  event = "User AstroFile",
  opts = {
    modes = { insert = true, command = false, terminal = false },
    -- skip autopair when the cursor is inside these treesitter nodes
    skip_ts = { "string" },
    -- skip autopair when next character is closing pair
    -- and there are more closing pairs than opening pairs
    skip_unbalanced = true,
    mappings = { ["'"] = false },
  },
  config = function(_, opts)
    local npairs, astro = require "mini.pairs", require "astrocore"
    npairs.setup(opts)
    if not astro.config.features.autopairs then vim.g.minipairs_disable = true end

    -- Adapted from: https://github.com/LazyVim/LazyVim/blob/940d7df59aac/lua/lazyvim/util/mini.lua#L135-L167
    local open = npairs.open
    ---@diagnostic disable-next-line: duplicate-set-field
    npairs.open = function(pair, neigh_pattern)
      if vim.fn.getcmdline() ~= "" then return open(pair, neigh_pattern) end

      local l, r = pair:sub(1, 1), pair:sub(2, 2)
      local line, cur = vim.api.nvim_get_current_line(), vim.api.nvim_win_get_cursor(0)

      if opts.skip_ts and #opts.skip_ts > 0 then
        local ok, captures =
          pcall(vim.treesitter.get_captures_at_pos, 0, cur[1] - 1, math.max(cur[2] - 1, 0))
        for _, capture in ipairs(ok and captures or {}) do
          if vim.tbl_contains(opts.skip_ts, capture.capture) then return l end
        end
      end

      if opts.skip_unbalanced and line:sub(cur[2] + 1, cur[2] + 1) == r and r ~= l then
        local _, count_open = line:gsub(vim.pesc(pair:sub(1, 1)), "")
        local _, count_close = line:gsub(vim.pesc(pair:sub(2, 2)), "")
        if count_close > count_open then return l end
      end

      return open(pair, neigh_pattern)
    end
  end,
}
