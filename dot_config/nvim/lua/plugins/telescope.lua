return {
  "nvim-telescope/telescope.nvim",
  opts = {
    pickers = {
      find_files = {
        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
      },
      live_grep = {
        additional_args = function()
          return { "--hidden", "--glob", "!.git/*" }
        end,
      },
    },
  },
  keys = {
    { "<leader>sf", "<cmd>Telescope find_files cwd=.<cr>", desc = "Find Files (cwd)" },
    { "<leader>sg", "<cmd>Telescope live_grep cwd=.<cr>", desc = "Grep (cwd)" },
  },
}