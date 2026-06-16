require "nvchad.options"

-- Basic Options
vim.opt.showcmd = false
vim.opt.relativenumber = true
vim.g.gui_font_ligatures = 0
vim.opt.updatetime = 100
vim.opt.showtabline = 0
vim.opt.scrolloff = 8
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Better diff algorithm
vim.opt.diffopt:append "iwhite"
vim.opt.diffopt:append "algorithm:histogram"
vim.opt.diffopt:append "indent-heuristic"

-- Better command-line completion
vim.opt.wildmode = "list:longest"
vim.opt.wildignore = ".hg,.svn,*~,*.png,*.jpg,*.gif,*.min.js,*.swp,*.o,vendor,dist,_site"

-- Terminal performance optimization
vim.opt.lazyredraw = true
vim.opt.ttyfast = true

-- Diagnostics Configuration
vim.diagnostic.config {
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = "rounded",
    source = "always",
    focusable = false,
    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
  },
}

-- Auto-save when switching buffers/files
vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  callback = function()
    if vim.bo.modified and not vim.bo.readonly and vim.fn.expand "%" ~= "" and vim.bo.buftype == "" then
      vim.api.nvim_command "silent! write"
    end
  end,
})

-- Highlight yanked text briefly
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank { timeout = 200 }
  end,
})

-- Jump to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
  pattern = "*",
  callback = function()
    if vim.fn.line "'\"" > 1 and vim.fn.line "'\"" <= vim.fn.line "$" then
      if not vim.fn.expand("%:p"):find(".git", 1, true) then
        vim.cmd 'exe "normal! g\'\\""'
      end
    end
  end,
})

-- Disable automatic comment continuation
vim.api.nvim_create_autocmd("FileType", {
  pattern = "*",
  callback = function()
    vim.opt_local.formatoptions:remove { "c", "r", "o" }
  end,
})

-- Terminal-specific optimizations
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    -- Disable line numbers in terminal
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false

    -- Disable sign column in terminal
    vim.opt_local.signcolumn = "no"

    -- Disable cursor line highlighting
    vim.opt_local.cursorline = false

    -- Reduce scrollback for performance
    vim.opt_local.scrollback = 1000

    -- CRITICAL: Unmap leader key in terminal to prevent delay
    vim.keymap.set("t", "<Space>", "<Space>", { buffer = true, nowait = true })

    -- Start in insert mode
    vim.cmd "startinsert"
  end,
})

-- Rust specific settings (standard Rust formatting)
vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
  end,
})

-- C++ specific settings
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cpp",
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
    vim.opt_local.expandtab = true
    vim.opt_local.autoindent = true
    vim.opt_local.smartindent = true
  end,
})

-- TypeScript/JavaScript/JSX/TSX specific settings with TREE-SITTER indent
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "typescript", "javascriptreact", "typescriptreact", "json", "jsonc" },
  callback = function()
    vim.opt_local.tabstop = 2
    vim.opt_local.shiftwidth = 2
    vim.opt_local.softtabstop = 2
    vim.opt_local.expandtab = true

    -- Tree-sitter handles indentation automatically via indent.enable = true
    -- Setting indentexpr manually causes conflicts with newer nvim-treesitter
    vim.opt_local.smartindent = false
    vim.opt_local.cindent = false
    vim.opt_local.autoindent = true
    end,
})

-- Competitive Programming: Append template to new C++ files
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.cpp",
  callback = function()
    vim.cmd("0r /home/acegikmo/vimcp/Library/Template.cpp")
    vim.fn.search("void solve() {}")
    vim.cmd("normal! f{lzza")
  end,
})
