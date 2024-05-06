return function(plugin)
  -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
  -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
  -- no longer trigger the **nvim-treeitter** module to be loaded in time.
  -- Luckily, the only thins that those plugins need are the custom queries, which we make available
  -- during startup.
  -- credit: https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
  require("lazy.core.loader").add_to_rtp(plugin)
  require "nvim-treesitter.query_predicates"
end