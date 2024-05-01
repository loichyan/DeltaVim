return {
  lsp_codelens_refresh = {
    cond = "textDocument/codeLens",
    {
      event = { "InsertLeave", "BufEnter" },
      desc = "Refresh codelens (buffer)",
      callback = function(args)
        if require("astrolsp").config.features.codelens then
          vim.lsp.codelens.refresh { bufnr = args.buf }
        end
      end,
    },
  },

  lsp_autoformat = {
    cond = require("pde.utils").formatting_enabled,
    {
      event = "BufWritePre",
      desc = "autoformat on save",
      callback = function(_, _, bufnr)
        local astrolsp = require "astrolsp"
        local config = assert(astrolsp.config.formatting.format_on_save)
        local buf_enabled = vim.b[bufnr].autoformat
        if buf_enabled == nil then buf_enabled = config.enabled end
        if buf_enabled and ((not config.filter) or config.filter(bufnr)) then
          vim.lsp.buf.format(vim.tbl_deep_extend("force", astrolsp.format_opts, { bufnr = bufnr }))
        end
      end,
    },
  },
}