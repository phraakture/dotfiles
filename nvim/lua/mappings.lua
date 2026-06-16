require "nvchad.mappings"

local map = vim.keymap.set

-- GENERAL EDITING

-- Command mode
map("n", ";", ":", { desc = "CMD enter command mode" })

-- Quick escape to normal mode
map("i", "jj", "<ESC>")
map("i", "JJ", "<ESC>")
map("i", "kk", "<ESC>")
map("i", "KK", "<ESC>")

-- Quick open file in same directory
map("n", "<leader>o", ':e <C-R>=expand("%:p:h") . "/" <CR>', { desc = "Open file in current dir" })

-- Select all with Ctrl+a
map("n", "<C-a>", "ggVG", { desc = "Select all" })
map("i", "<C-a>", "<Esc>ggVG", { desc = "Select all" })
map("v", "<C-a>", "<Esc>ggVG", { desc = "Select all" })

-- NAVIGATION

-- Always center search results
map("n", "n", "nzz", { silent = true, desc = "Next search result (centered)" })
map("n", "N", "Nzz", { silent = true, desc = "Prev search result (centered)" })
map("n", "*", "*zz", { silent = true, desc = "Search word under cursor (centered)" })
map("n", "#", "#zz", { silent = true, desc = "Search word backward (centered)" })

-- Jump to start and end of line using home row
map("", "H", "^", { desc = "Jump to first non-blank character" })
map("", "L", "$", { desc = "Jump to end of line" })

-- Arrow keys switch buffers
map("n", "<left>", ":bp<CR>", { desc = "Previous buffer" })
map("n", "<right>", ":bn<CR>", { desc = "Next buffer" })

-- Move by visual line when text is wrapped
map("n", "j", "gj", { silent = true })
map("n", "k", "gk", { silent = true })

-- LSP & DIAGNOSTICS

-- Faster diagnostic hover (shows immediately without delay)
map("n", "K", function()
  local winid = vim.api.nvim_get_current_win()
  local bufnr = vim.api.nvim_win_get_buf(winid)
  local row, col = unpack(vim.api.nvim_win_get_cursor(winid))

  -- Show diagnostics if on an error/warning
  local diag = vim.diagnostic.get(bufnr, { lnum = row - 1 })
  if #diag > 0 then
    vim.diagnostic.open_float(nil, { focus = false })
  else
    vim.lsp.buf.hover()
  end
end, { desc = "Hover or show diagnostic" })

-- Toggle inlay hints
map("n", "<Leader>th", function()
  vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
end, { desc = "Toggle inlay hints" })

-- Toggle format on save
map("n", "<Leader>tf", function()
  vim.g.format_on_save = not vim.g.format_on_save
  local status = vim.g.format_on_save and "enabled" or "disabled"
  print("Format on save: " .. status)
end, { desc = "Toggle format on save" })

-- DEBUGGING (DAP)

map("n", "<Leader>dl", "<cmd>lua require'dap'.step_into()<CR>", { desc = "Debugger step into" })
map("n", "<Leader>dj", "<cmd>lua require'dap'.step_over()<CR>", { desc = "Debugger step over" })
map("n", "<Leader>dk", "<cmd>lua require'dap'.step_out()<CR>", { desc = "Debugger step out" })
map("n", "<Leader>dc", "<cmd>lua require'dap'.continue()<CR>", { desc = "Debugger continue" })
map("n", "<Leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<CR>", { desc = "Debugger toggle breakpoint" })
map(
  "n",
  "<Leader>dd",
  "<cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
  { desc = "Debugger set conditional breakpoint" }
)
map("n", "<Leader>de", "<cmd>lua require'dap'.terminate()<CR>", { desc = "Debugger reset" })
map("n", "<Leader>dr", "<cmd>lua require'dap'.run_last()<CR>", { desc = "Debugger run last" })
map("n", "<Leader>dt", "<cmd>lua vim.cmd('RustLsp testables')<CR>", { desc = "Debugger testables" })

-- FILE EXPLORER (NvimTree)
map("n", "<leader>e", "<cmd>NvimTreeFocus<CR>", { desc = "Focus NvimTree" })
map("n", "<leader>tF", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in tree" })

-- SEARCH (Telescope)
map("n", "<C-p>", "<cmd>Telescope live_grep<CR>", { desc = "Search project (terminal safe)" })

-- COMPETITIVE PROGRAMMING (C++)
map("n", "<leader>bb", "<cmd>w | !build.sh %:r<CR>", { desc = "Build" })

map("n", "<leader>br", function()
  vim.cmd "w"
  local file_root = vim.fn.expand "%:r"
  vim.fn.system("build.sh " .. file_root)

  local maps = vim.api.nvim_get_keymap("n")
  for _, m in ipairs(maps) do
    if m.lhs == "<M-i>" and m.callback then
      m.callback()
      break
    end
  end

  vim.defer_fn(function()
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
      if vim.bo[buf].buftype == "terminal" and vim.api.nvim_buf_is_loaded(buf) then
        local win = vim.fn.bufwinid(buf)
        if win ~= -1 then
          vim.api.nvim_set_current_win(win)
          vim.cmd "startinsert"
          vim.api.nvim_feedkeys("./" .. file_root .. "\n", "t", false)
        end
        break
      end
    end
  end, 300)
end, { desc = "Build and run (Float)" })

-- TERMINAL MANAGEMENT
-- Toggle or Create a Named Terminal
-- Usage: Press <leader>tt, type 'server', hit enter.
-- To hide/show it again, just repeat the same name.
map({ "n", "t" }, "<leader>tt", function()
  vim.ui.input({ prompt = "Terminal ID (e.g. server, logs, run): " }, function(input)
    if input and input ~= "" then
      require("nvchad.term").toggle {
        pos = "sp",
        id = input,
      }
    end
  end)
end, { desc = "Terminal: Toggle by ID" })

-- The "Management Console" (Fuzzy Finder)
-- This opens Telescope to see all your named terminals in one list.
map("n", "<leader>tm", "<cmd>Telescope terms<CR>", { desc = "Terminal: Management Console" })

-- Terminal Escaping
-- Standard NvChad is <C-x>
map("t", "jj", "<C-\\><C-n>", { desc = "Terminal: Escape to Normal Mode" })

-- Quick Vertical Terminal (Independent of Named ones)
map({ "n", "t" }, "<leader>tv", function()
  require("nvchad.term").toggle { pos = "vsp", id = "vsplit_term" }
end, { desc = "Terminal: Toggle Vertical" })

-- Use Alt+x to kill any terminal instantly
map({ "n", "t" }, "<A-x>", function()
  local bufnr = vim.api.nvim_get_current_buf()
  if vim.bo.buftype == "terminal" then
    vim.cmd "stopinsert"
    vim.api.nvim_buf_delete(bufnr, { force = true })
  end
end, { desc = "Terminal: Quick Kill" })

-- Toggle quickfix list
map("n", "<leader>q", function()
  local qf_open = false
  for _, win in pairs(vim.fn.getwininfo()) do
    if win.quickfix == 1 then
      qf_open = true
      break
    end
  end
  if qf_open then
    vim.cmd "cclose"
  else
    vim.cmd "copen"
  end
end, { desc = "Toggle quickfix list" })

-- terminal debug
map("n", "<leader>td", function()
  local maps = vim.api.nvim_get_keymap("n")
  for _, m in ipairs(maps) do
    if m.lhs:find("\ti") or tostring(m.lhs) == "<M-i>" then
      print(vim.inspect(m))
    end
  end
end, { desc = "debug" })

-- PYTHON / AI DEVELOPMENT
-- Neotest: run tests
map("n", "<leader>tr", function()
  require("neotest").run.run()
end, { desc = "Python: run nearest test" })
map("n", "<leader>tF", function()
  require("neotest").run.run(vim.fn.expand "%")
end, { desc = "Python: run test file" })
map("n", "<leader>ts", function()
  require("neotest").summary.toggle()
end, { desc = "Python: toggle test summary" })
map("n", "<leader>to", function()
  require("neotest").output.open()
end, { desc = "Python: show test output" })
-- Debug test via DAP
map("n", "<leader>tD", function()
  require("neotest").run.run { strategy = "dap" }
end, { desc = "Python: debug nearest test" })
