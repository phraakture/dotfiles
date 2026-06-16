local options = {
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "ruff_format" },
    json = { "prettier" },
    css = { "prettier" },
    html = { "prettier" },
    markdown = { "prettier" },
  },
  format_on_save = function()
    -- Check the global flag
    if vim.g.format_on_save then
      return {
        timeout_ms = 2000,
        lsp_fallback = true,
      }
    end
    -- Return nil to skip formatting
    return nil
  end,
}
return options
