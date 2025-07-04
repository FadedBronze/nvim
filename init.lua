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

vim.opt.number = true;
vim.opt.relativenumber = true;

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

vim.api.nvim_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", { noremap = true, silent = true })

-- glsl - hack but nessisary rn
vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  pattern = { "*.frag", "*.glsl", "*.vert", "*.geom", "*.comp", "*.tese", "*.tesc" },
  callback = function()
    vim.cmd("set filetype=glsl")
    vim.cmd("TSEnable highlight")
  end,
})

local blink = require("blink.cmp");

-- cmp
blink.setup{
  fuzzy = {
    implementation = 'prefer_rust',
    prebuilt_binaries = {
      download = true,
    },
  },
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

-- markdown
require("render-markdown").setup({});

function get_real_buffers()
  local real_bufs = {}
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf)
      and vim.bo[buf].buftype == ""
      and vim.fn.bufname(buf) ~= "" then
      table.insert(real_bufs, buf)
    end
  end
  return real_bufs
end

function SelectRealBuffer(n)
  local bufs = get_real_buffers()
  n = tonumber(n)
  if bufs[n] then
    vim.api.nvim_set_current_buf(bufs[n])
  else
    print("no buffer at index " .. n)
  end
end

vim.keymap.set('n', '<Leader>1', function () SelectRealBuffer(1) end);
vim.keymap.set('n', '<Leader>2', function () SelectRealBuffer(2) end);
vim.keymap.set('n', '<Leader>3', function () SelectRealBuffer(3) end);
vim.keymap.set('n', '<Leader>4', function () SelectRealBuffer(4) end);
vim.keymap.set('n', '<Leader>5', function () SelectRealBuffer(5) end);
vim.keymap.set('n', '<Leader>x', ":w<CR>:bd<CR>");

vim.keymap.set('n', '<Leader>mav', function () require("supermaven-nvim").setup({}) end);

local neoscroll = require("neoscroll")

neoscroll.setup({
  mappings = { "<C-u>", "<C-d>", "zz" },
  easing_function = "quartic",
});

vim.keymap.set('n', 'L', "L:lua require('neoscroll').zz({ half_win_duration = 250 })<CR>");
vim.keymap.set('n', 'H', "H:lua require('neoscroll').zz({ half_win_duration = 250 })<CR>");

vim.o.statusline = "%f:%{FugitiveHead()} %m %= %l:%c"
