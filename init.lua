-- privacy options {{{

-- Disable swap files
vim.opt.swapfile = false

-- Disable backup files
vim.opt.backup = false
vim.opt.writebackup = false

-- Disable undo files
vim.opt.undofile = false
vim.opt.undoreload = 0

-- Disable command-line history
vim.opt.history = 0

-- Disable session saving
vim.opt.sessionoptions = ""

-- Disable persistent undo
-- vim.opt.undolevels = 0
--

-- Disable modelines (can potentially execute commands from file content)
vim.opt.modeline = false

-- Disable folding (which can create view files)
vim.opt.foldenable = false

-- Disable ShaDa file (Neovim's equivalent of viminfo)
vim.cmd([[
  set shada="NONE"
]])
-- vim.opt.shada = "NONE"
-- Disable viminfo/shada file
vim.opt.viminfo = ""

-- Disable any plugins that might save data
vim.cmd([[
  set runtimepath-=~/.config/nvim
  set runtimepath-=~/.local/share/nvim
  set packpath=
]])

-- Disable file type detection (which can trigger plugins)
-- vim.cmd("filetype off")
vim.cmd("filetype plugin off")
vim.cmd("filetype indent off")

-- Clear registers on exit
vim.api.nvim_create_autocmd("VimLeavePre", {
	callback = function()
		for i = 34, 122 do -- ASCII range from " to z
			vim.fn.setreg(string.char(i), "")
		end
	end,
})

-- Disable any auto-save plugins or features
vim.g.auto_save = 0

-- Ensure no temporary files are created
vim.opt.directory = ""
vim.opt.backupdir = ""
vim.opt.viewdir = ""

--- }}}

--- UX options {{{
-- line breaks
vim.opt.linebreak = true
vim.opt.breakindent = true
-- tabs
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
-- folding
vim.opt.foldmethod = "marker"
vim.opt.foldenable = true
vim.wo.foldlevel = 0

vim.cmd([[
  set filetype=markdown
  colorscheme slate
]])

--- }}}
