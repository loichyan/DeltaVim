local Config = require("deltavim.config")
local Keymap = require("deltavim.core.keymap")
local Util = require("deltavim.util")

local M = {}

---@param buffer integer
function M.format(buffer)
  local ft = vim.bo[buffer].filetype
  local methods = require("null-ls.methods").internal
  -- stylua: ignore
  local use_nls = #require("null-ls.sources").get_available(ft, methods.FORMATTING) > 0
  vim.lsp.buf.format(Util.deep_merge({
    bufnr = buffer,
    filter = function(client)
      if use_nls then return client.name == "null-ls" end
      return client.name ~= "null-ls"
    end,
  }, Config.lsp.format or {}))
end

---@param client any
---@param buffer integer
function M.autoformat(client, buffer)
  -- Don't format if client disabled it
  if
    client.config
    and client.config.capabilities
    and client.config.capabilities["documentFormattingProvider"] == false
  then
    return
  end

  if client.server_capabilities["documentFormattingProvider"] then
    Util.autocmd("BufWritePre", function()
      if Config.lsp.autoformat then M.format(buffer) end
    end, { buffer = buffer })
  end
end

---@param client any
---@param buffer integer
function M.keymaps(client, buffer)
  ---@param cmd string
  ---@param has string
  local function lsp(cmd, has) return { vim.lsp[cmd], has } end

  ---@param next boolean
  ---@param level? string
  local function goto_diagnostic(next, level)
    local f = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    local severity = level and vim.diagnostic.severity[level] or nil
    return { function() f({ severity = severity }) end, "diagnostic" }
  end

  -- stylua: ignore
  ---@type DeltaVim.Keymap.Presets
  local presets = {
    -- lsp
    { "@lsp.hover", lsp("hover", "hover"), "Hover" },
    { "@lsp.signature_help",  lsp("signature_help", "signatureHelp") , "Signature help" },
    { "@lsp.declaration", lsp("declaration", "declaration"), "Declaration" },
    { "@lsp.definitions", lsp("definition", "definition"), "Definitions" },
    { "@lsp.references", lsp("references", "references"), "References" },
    { "@lsp.implementations", lsp("implementation", "implementation"), "Implementations" },
    { "@lsp.type_definitions", lsp("type_definition", "typeDefinition"), "Type definitions" },
    { "@lsp.rename", lsp("rename", "rename"), "Rename" },
    { "@lsp.code_action", lsp("code_action", "codeAction"), "Code action", mode = { "n", "x" } },
    { "@lsp.format", { M.format, "documentFormatting" }, "Format document", mode = "n" },
    { "@lsp.format", { M.format, "documentRangeFormatting" }, "Format range", mode = "x" },
    { "@lsp.line_diagnostics", { vim.diagnostic.open_float, "diagnostic" }, "Line diagnostics" },
    -- goto
    { "@goto.next_diagnostic", goto_diagnostic(true), "Next diagnostic" },
    { "@goto.prev_diagnostic", goto_diagnostic(false), "Prev diagnostic" },
    { "@goto.next_error", goto_diagnostic(true, "ERROR"), "Next error" },
    { "@goto.prev_error", goto_diagnostic(false, "ERROR"), "Prev error" },
    { "@goto.next_warning", goto_diagnostic(true, "WARN"), "Next warning" },
    { "@goto.prev_warning", goto_diagnostic(false, "WARN"), "Prev warning" },
    buffer = buffer,
  }
  local keymaps = Keymap.Collector():map(presets):collect()

  for _, m in ipairs(keymaps) do
    local has = m[2][2]
    if not has or client.server_capabilities[has .. "Provider"] then
      Util.keymap(m.mode, m[1], m[2][1], m.opts)
    end
  end
end

return M