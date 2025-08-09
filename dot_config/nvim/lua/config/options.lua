-- Enable true color support
vim.opt.termguicolors = true

-- Additional color settings for better theme support
if vim.env.TMUX then
  -- Let tmux handle terminal settings
  vim.env.TERM = "tmux-256color"
end

-- Use smartyank for intelligent clipboard handling
-- (smartyank plugin will be loaded separately)

-- Auto-reload files when changed externally (e.g., by Claude)
vim.opt.autoread = true

-- Set updatetime to 1 second for reasonable auto-reload response
-- (default 4000ms is too slow, 100ms is too aggressive)
vim.opt.updatetime = 1000

-- Trigger autoread when files change on disk
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  pattern = "*",
  command = "if mode() != 'c' | checktime | endif",
})

-- Notification when file changes are reloaded
vim.api.nvim_create_autocmd("FileChangedShellPost", {
  pattern = "*",
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded.", vim.log.levels.INFO)
  end,
})