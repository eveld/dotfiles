return {
  -- Show git changes in the gutter (see what Claude modified)
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "" },
        topdelete = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = true,
      current_line_blame_opts = {
        delay = 100,
      },
    },
  },

  -- Better undo history to track Claude's changes
  {
    "mbbill/undotree",
    keys = {
      { "<leader>u", vim.cmd.UndotreeToggle, desc = "Undo tree" },
    },
  },

  -- Show notifications in a better way
  {
    "rcarriga/nvim-notify",
    opts = {
      timeout = 3000,
      render = "minimal",
      stages = "fade",
    },
  },
}