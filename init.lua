-- colorscheme
require("catppuccin").setup({
  flavour = "mocha",
  transparent_background = true,
  integrations = {
      treesitter = true,
  },
});

vim.cmd.colorscheme "catppuccin";

-- disable netrw banner
vim.cmd.let "g:netrw_banner = 0";

-- tabs
vim.opt.tabstop = 2
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.smartindent = true

-- leader key
vim.g.mapleader = " "

-- copy paste
vim.keymap.set('n', '<leader>y', ':let @+ = @"<CR>', { noremap = true });
