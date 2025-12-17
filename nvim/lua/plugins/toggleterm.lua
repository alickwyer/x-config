return {
  {
    "akinsho/toggleterm.nvim",
    config = true,
    -- enabled = false,
    cmd = "ToggleTerm",
    keys = { { "<C-t>", "<cmd>ToggleTerm<cr>", desc = "Toggle floatting terminal" } },
    opts = {
      shell = "pwsh -NoLogo -NoProfile -NoExit -File " .. os.getenv("INIT_PS1_"),
      open_mapping = [[<c-t>]],
      direction = "float",
      shade_terminals = false,
      -- shade_filetypes = {},
      hide_numbers = true,
      insert_mappings = true,
      terminal_mappings = true,
      start_in_insert = true,
      close_on_exit = true,
    },
  },
}
