-- This file needs to have same structure as nvconfig.lua
-- https://github.com/NvChad/ui/blob/v2.5/lua/nvconfig.lua

-- load custom LSP silence module
pcall(require, "custom.lsp_silence")

---@type ChadrcConfig
local M = {}

M.base46 = {
  theme = "gruvbox",

  hl_override = {
    Comment = { italic = false },
    ["@comment"] = { italic = false },
    Normal = { fg = "#ebdbb2" }, -- brighter foreground
    NormalFloat = { fg = "#ebdbb2" },
  },

  -- Try this for more contrast
  transparency = false,
}

M.ui = {
  tabufline = {
    enabled = false, -- Disable the top buffer line
  },
}

return M
