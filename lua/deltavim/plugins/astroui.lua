---@type LazyPluginSpec
return {
  "AstroNvim/astroui",
  lazy = true,
  ---@param opts AstroUIOpts
  opts = function(_, opts)
    require("deltavim.utils").merge(opts, {
      colorscheme = "astrodark",
      text_icons = {
        ActiveLSP = "LSP:",
        ArrowLeft = "<",
        ArrowRight = ">",
        BufferClose = "x",
        DapBreakpoint = "B",
        DapBreakpointCondition = "C",
        DapBreakpointRejected = "R",
        DapLogPoint = "L",
        DapStopped = ">",
        DefaultFile = "[F]",
        DiagnosticError = "E",
        DiagnosticHint = "?",
        DiagnosticInfo = "i",
        DiagnosticWarn = "W",
        Ellipsis = "...",
        Environment = "Env:",
        Exit = "[Q]",
        FileModified = "*",
        FileReadOnly = "[lock]",
        FoldClosed = "+",
        FoldOpened = "-",
        FoldSeparator = " ",
        FolderClosed = "[D]",
        FolderEmpty = "[E]",
        FolderOpen = "[O]",
        GitAdd = "+",
        GitChange = "~",
        GitConflict = "!",
        GitDelete = "-",
        GitIgnored = "*",
        GitRenamed = "R",
        GitSign = "|",
        GitStaged = "S",
        GitUnstaged = "U",
        GitUntracked = "?",
        MacroRecording = "Recording:",
        Paste = "[PASTE]",
        Search = "?",
        Selected = "*",
        Spellcheck = "[SPELL]",
        TabClose = "X",
      },
    })
  end,
}
