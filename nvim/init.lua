vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.colorcolumn = "80"

-- This keep persistant undos but also keep me from opening the same file in 2 instances.
vim.opt.undofile = true

-- Do some anti-rage aliases
vim.cmd("command W w")
vim.cmd("command Q q")
vim.cmd("command WQ wq")
vim.cmd("command Wq wq")

-- Force myself to use the hjkl keys by deactivating arrows in normal mode
vim.keymap.set("n", "<Left>", "<nop>")
vim.keymap.set("n", "<Right>", "<nop>")
vim.keymap.set("n", "<Up>", "<nop>")
vim.keymap.set("n", "<Down>", "<nop>")

vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

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
	"williamboman/mason.nvim",
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
		},
	},
	"mhartington/formatter.nvim",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.6",
		dependencies = { "nvim-lua/plenary.nvim" },
	},
	{
		"fatih/molokai",
		priority = 1000,
		init = function()
			vim.opt.termguicolors = true
			vim.cmd.colorscheme("molokai")
		end,
	},
	{
		"hrsh7th/nvim-cmp",
		event = "InsertEnter",
		dependencies = {
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-path",
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")
			luasnip.config.setup({})

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},
				completion = { completeopt = "menu,menuone,noinsert" },

				mapping = cmp.mapping.preset.insert({
					["<C-n>"] = cmp.mapping.select_next_item(),
					["<C-p>"] = cmp.mapping.select_prev_item(),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete({}),
				}),
				sources = {
					{ name = "nvim_lsp" },
					{ name = "path" },
				},
			})
		end,
	},
})

-- Setup LSP/Formatter manager
require("mason").setup()
require("mason-lspconfig").setup()

-- Setup LSPs
require("lspconfig").golangci_lint_ls.setup({})
require("lspconfig").gopls.setup({})
require("lspconfig").lua_ls.setup({
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			diagnostics = {
				globals = {
					"vim",
				},
			},
			-- This makes the Lua LSP aware of the nvim runtime but it also slows
			-- down the LSP loading and spike the CPU. For now I'll deactivate it
			-- but let's keep this in mind if I ever develop a nvim plugin.
			-- workspace = {
			-- 	library = vim.api.nvim_get_runtime_file("", true),
			-- },
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Setup Formatters
require("formatter").setup({
	logging = true,
	log_level = vim.log.levels.WARN,
	filetype = {
		go = {
			require("formatter.filetypes.go").gofumpt,
		},
		javascript = {
			require("formatter.filetypes.javascript").prettier,
		},
		typescript = {
			require("formatter.filetypes.javascript").prettier,
		},
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
	},
})

-- Format on save
vim.api.nvim_create_autocmd("BufWritePost", {
	group = vim.api.nvim_create_augroup("__formatter__", { clear = true }),
	command = ":FormatWrite",
})

-- Setup LSP shortcuts
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("__lspShortcuts__", { clear = true }),
	callback = function(event)
		local map = function(keys, func, desc)
			vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
		end

		map("K", vim.lsp.buf.hover, "Hover Documentation")

		map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
		map("'r", vim.lsp.buf.rename, "[R]ename")
	end,
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

-- Setup shortcuts
vim.keymap.set("n", ";", ":normal! @a<CR>") -- Execute macro 'a'
vim.keymap.set("n", "\\", require("telescope.builtin").find_files) -- Open telescope file finder
vim.keymap.set("n", "|", require("telescope.builtin").buffers) -- Open telescope buffer list
vim.keymap.set("n", "gr", require("telescope.builtin").live_grep) -- Grep in all directory
vim.keymap.set("n", "gu", "<C-t>") -- Go back to the previous buffer
