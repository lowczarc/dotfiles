vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.colorcolumn = "80"

-- This keep persistant undos but also keep me from opening the same file in 2 instances.
vim.opt.undofile = true

-- Do some anti-rage aliases
vim.cmd 'command W w'
vim.cmd 'command Q q'
vim.cmd 'command WQ wq'
vim.cmd 'command Wq wq'

-- Force myself to use the hjkl keys by deactivating arrows in normal mode
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")

vim.keymap.set("n", ";", ":normal! @a<CR>")

-- Setup plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Install plugins
require("lazy").setup({
 "mhartington/formatter.nvim",
 "williamboman/mason-lspconfig.nvim",
 "williamboman/mason.nvim",
 "neovim/nvim-lspconfig",
 {
    "fatih/molokai",
    priority = 1000,
    init = function()
      vim.opt.termguicolors = true
      vim.cmd.colorscheme 'molokai'
    end,
 }
})

-- Setup LSP/Formatter manager
require("mason").setup()
require("mason-lspconfig").setup()

-- Setup LSPs
require("lspconfig").golangci_lint_ls.setup {}

-- Setup Formatters
require("formatter").setup {
  logging = true,
  log_level = vim.log.levels.WARN,
  filetype = {
    go = {
      require("formatter.filetypes.go").gofumpt
    },
    javascript = {
      require("formatter.filetypes.javascript").prettier
    },
    typescript = {
      require("formatter.filetypes.javascript").prettier
	},
  }
}

-- Format on save
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

-- Highlight line number on LSP warning
for _, diag in ipairs({ "Error", "Warn", "Info", "Hint" }) do
    vim.fn.sign_define("DiagnosticSign" .. diag, {
        text = "",
        texthl = "DiagnosticSign" .. diag,
        linehl = "",
        numhl = "DiagnosticSign" .. diag,
    })
end
