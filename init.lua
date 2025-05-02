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
vim.opt.tabstop = 2;
vim.opt.softtabstop = 2;
vim.opt.shiftwidth = 2;
vim.opt.expandtab = true;
vim.opt.autoindent = true;
vim.opt.smartindent = true;

-- leader key
vim.g.mapleader = " ";

-- copy paste
vim.keymap.set('n', '<leader>y', ':let @+ = @"<CR>', { noremap = true });

-- lsp
require("mason").setup();
require("mason-lspconfig").setup();

local lsp_config = require("lspconfig");
lsp_config.lua_ls.setup{};
lsp_config.zls.setup{};
lsp_config.glsl_analyzer.setup{};

-- lua
---@diagnostic disable-next-line: missing-fields
require("lazydev").setup{
  ft = "lua",
  opts = {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    }
  },
};

-- glsl - hack but nessisary rn
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.frag", "*.glsl", "*.vert", "*.geom", "*.comp", "*.tese", "*.tesc" },
  callback = function()
    vim.cmd("set filetype=glsl")
    vim.cmd("TSEnable highlight")
  end,
})

-- cmp
require("blink.cmp").setup{
  sources = {
    default = { "lazydev", "lsp", "path", "snippets", "buffer" },
    providers = {
      lazydev = {
        name = "LazyDev",
        module = "lazydev.integrations.blink",
        score_offset = 100,
      },
    },
  }
}

-- telescope
require('telescope').setup{};

local builtin = require 'telescope.builtin'

vim.keymap.set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>ss', builtin.git_status, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sb', builtin.git_branches, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>sc', builtin.git_commits, { desc = '[ ] Find existing buffers' })

