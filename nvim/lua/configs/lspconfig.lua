require("nvchad.configs.lspconfig").defaults()
local lspconfig = require "lspconfig"
local nvlsp = require "nvchad.configs.lspconfig"

-- Suppress deprecation warning
vim.deprecate = function() end

-- Initialize format_on_save as enabled by default
vim.g.format_on_save = false

-- C++ LSP with clangd + CONDITIONAL format on save
lspconfig.clangd.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)

    vim.diagnostic.config { virtual_text = false }

    -- Format on save (conditional)
    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.g.format_on_save then
          vim.lsp.buf.format {
            bufnr = bufnr,
            timeout_ms = 1000,
          }
        end
      end,
    })
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  cmd = { "clangd" },
  filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
  root_dir = lspconfig.util.root_pattern(
    ".clangd",
    ".clang-tidy",
    ".clang-format",
    "compile_commands.json",
    "compile_flags.txt",
    "configure.ac",
    ".git"
  ),
}

-- TypeScript/JavaScript LSP + CONDITIONAL format on save
lspconfig.ts_ls.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)

    -- Force hide virtual text after TS LSP attaches
    vim.diagnostic.config { virtual_text = false }

    -- Format on save (conditional)
    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   callback = function()
    --     if vim.g.format_on_save then
    --       vim.lsp.buf.format({
    --         bufnr = bufnr,
    --         timeout_ms = 1000,
    --       })
    --     end
    --   end,
    -- })
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = {
    "typescript",
    "javascript",
    "javascriptreact",
    "typescriptreact",
  },
  root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
}

-- HTML LSP with auto-closing tags
lspconfig.html.setup {
  on_attach = nvlsp.on_attach,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "html", "htmldjango", "templ" },
}

-- Python LSP (basedpyright) for AI/RAG development
lspconfig.basedpyright.setup {
  on_attach = function(client, bufnr)
    nvlsp.on_attach(client, bufnr)

    vim.diagnostic.config { virtual_text = false }

    vim.api.nvim_create_autocmd("BufWritePre", {
      buffer = bufnr,
      callback = function()
        if vim.g.format_on_save then
          vim.lsp.buf.format {
            bufnr = bufnr,
            timeout_ms = 1000,
          }
        end
      end,
    })
  end,
  on_init = nvlsp.on_init,
  capabilities = nvlsp.capabilities,
  filetypes = { "python" },
  root_dir = lspconfig.util.root_pattern("pyproject.toml", "setup.py", "setup.cfg", "requirements.txt", ".git"),
  settings = {
    basedpyright = {
      analysis = {
        typeCheckingMode = "basic",
        autoImportCompletions = true,
        diagnosticMode = "workspace",
        useLibraryCodeForTypes = true,
      },
    },
  },
}
