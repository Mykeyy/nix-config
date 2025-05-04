return {
  { "nvim-telescope/telescope.nvim" },
  { "folke/trouble.nvim" },
  { "lewis6991/gitsigns.nvim" },
  { "folke/which-key.nvim" },
  { "NStefan002/screenkey.nvim",    lazy = false,                                 version = "*" },
  { "akinsho/toggleterm.nvim",      version = "*",                                config = true },
  { "nvim-neo-tree/neo-tree.nvim",  opts = { window = { position = "right", }, }, },
  { "mistricky/codesnap.nvim",      version = "^1",                               build = "make" },
  {
    "laytan/cloak.nvim",
    opts = {
      cloak_length = 8,
      cloak_character = "•",
    }
  },
}
