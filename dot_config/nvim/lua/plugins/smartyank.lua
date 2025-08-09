return {
  "ibhagwan/smartyank.nvim",
  event = "VeryLazy",
  config = function()
    require('smartyank').setup({
      highlight = {
        enabled = true,
        higroup = "IncSearch",
        timeout = 2000,
      },
      clipboard = {
        enabled = true
      },
      tmux = {
        enabled = true,
      },
      osc52 = {
        enabled = true,
        ssh_only = false,  -- try enabling for all sessions
        silent = true,
        echo_hl = "Directory",
      },
    })
  end
}