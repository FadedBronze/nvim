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

-- glsl - hack but nessisary rn
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.frag", "*.glsl", "*.vert", "*.geom", "*.comp", "*.tese", "*.tesc" },
  callback = function()
    vim.cmd("set filetype=glsl")
    vim.cmd("TSEnable highlight")
  end,
})

