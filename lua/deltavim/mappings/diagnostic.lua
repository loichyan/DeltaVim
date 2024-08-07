return {
  hover_diagnostics = {
    function() vim.diagnostic.open_float() end,
    desc = "Show symbol diagnostics",
  },

  next_diagnostic = {
    function() vim.diagnostic.goto_next() end,
    desc = "Next diagnostic",
  },

  prev_diagnostic = {
    function() vim.diagnostic.goto_prev() end,
    desc = "Previous diagnostic",
  },

  next_error = {
    function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.E } end,
    desc = "Next error",
  },

  prev_error = {
    function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.E } end,
    desc = "Previous error",
  },

  next_warning = {
    function() vim.diagnostic.goto_next { severity = vim.diagnostic.severity.W } end,
    desc = "Next warning",
  },

  prev_warning = {
    function() vim.diagnostic.goto_prev { severity = vim.diagnostic.severity.W } end,
    desc = "Previous warning",
  },

  list_document_diagnostics = {
    function() require("deltavim.utils").list_diagnostics(0) end,
    desc = "List document diagnostics",
  },

  list_workspace_diagnostics = {
    function() require("deltavim.utils").list_diagnostics() end,
    desc = "List workspace diagnostics",
  },

  list_workspace_errors = {
    function()
      require("deltavim.utils").list_diagnostics(nil, {
        severity = vim.diagnostic.severity.E,
      })
    end,
    desc = "List workspace errors",
  },

  list_document_errors = {
    function()
      require("deltavim.utils").list_diagnostics(0, {
        severity = vim.diagnostic.severity.E,
      })
    end,
    desc = "List document errors",
  },

  list_document_warnings = {
    function()
      require("deltavim.utils").list_diagnostics(0, {
        severity = vim.diagnostic.severity.W,
      })
    end,
    desc = "List document warnings",
  },

  list_workspace_warnings = {
    function()
      require("deltavim.utils").list_diagnostics(nil, {
        severity = vim.diagnostic.severity.W,
      })
    end,
    desc = "List workspace warnings",
  },
}
