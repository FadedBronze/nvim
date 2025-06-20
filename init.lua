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
        name = "lazydev",
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

local function is_last_window_netrw()
  local win_count = #vim.api.nvim_list_wins()
  if win_count ~= 1 then
    return false
  end

  local buf = vim.api.nvim_get_current_buf()
  local ft = vim.api.nvim_buf_get_option(buf, "filetype")
  return ft == "netrw"
end

-- open netrw on window close
vim.api.nvim_create_user_command("Q", function()
  vim.defer_fn(function()
    if is_last_window_netrw() then
        vim.cmd("q")
        return;
    end

    if #vim.api.nvim_list_wins() == 1 then
      vim.cmd("enew")
      vim.cmd("Explore")
    else
      vim.cmd("q")
    end
  end, 10)
end, {})

vim.api.nvim_create_user_command("WQ", function()
  vim.cmd("w")
  vim.cmd("Q")
end, {})

vim.cmd("cnoreabbrev <expr> q getcmdtype() == ':' && getcmdline() == 'q' ? 'Q' : 'q'")
vim.cmd("cnoreabbrev <expr> wq getcmdtype() == ':' && getcmdline() == 'wq' ? 'WQ' : 'wq'")

require("render-markdown").setup({});
