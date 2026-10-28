-- ==========================================================================
--  Neovim config for VS Code / Zed users
--  Drop this file at: ~/.config/nvim/init.lua
-- ==========================================================================

-- ---------------------------------------------------------------------------
--  1. Bootstrap lazy.nvim (plugin manager – installs itself automatically)
-- ---------------------------------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ---------------------------------------------------------------------------
--  2. Leader key  (set BEFORE plugins load)
-- ---------------------------------------------------------------------------
vim.g.mapleader = " "       -- Spacebar as leader, like VS Code's command palette trigger
vim.g.maplocalleader = " "

-- ---------------------------------------------------------------------------
--  3. Plugins
-- ---------------------------------------------------------------------------
require("lazy").setup({

  -- Theme ----------------------------------------------------------------
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      vim.cmd.colorscheme("catppuccin-mocha")
    end,
  },

  -- Fuzzy finder (Ctrl-P style) ------------------------------------------
  {
    "nvim-telescope/telescope.nvim",
    branch = "master",
    dependencies = { "nvim-lua/plenary.nvim" },
    keys = {
      { "<C-p>",      "<cmd>Telescope find_files<cr>",  desc = "Find files" },
      { "<C-S-f>",    "<cmd>Telescope live_grep<cr>",   desc = "Search in project" },
      { "<leader>fb", "<cmd>Telescope buffers<cr>",     desc = "Open buffers" },
      { "<leader>fr", "<cmd>Telescope oldfiles<cr>",    desc = "Recent files" },
    },
  },

  -- File tree (sidebar) ---------------------------------------------------
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-b>", "<cmd>NvimTreeToggle<cr>", desc = "Toggle file tree" },
    },
    config = function()
      -- disable netrw (vim's built-in file browser)
      vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
      require("nvim-tree").setup({
        view = { width = 35 },
      })
    end,
  },

  -- Statusline ------------------------------------------------------------
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({ options = { theme = "catppuccin" } })
    end,
  },

  -- Syntax highlighting (treesitter) --------------------------------------
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Modern treesitter: highlight & indent are enabled via vim options
      vim.treesitter.language.register("bash", "sh")
      -- Auto-install parsers when opening a file
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
    end,
    -- Pre-install common parsers
    opts = {
      ensure_installed = {
        "lua", "javascript", "typescript", "python", "rust", "go",
        "html", "css", "json", "yaml", "toml", "bash", "markdown",
      },
    },
  },

  -- Git gutter signs ------------------------------------------------------
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup()
    end,
  },

  -- Auto-pairs for brackets / quotes -------------------------------------
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- Comment toggling (gcc / gc in visual) ---------------------------------
  { "numToStr/Comment.nvim", config = true },

  -- Indent guides ---------------------------------------------------------
  { "lukas-reineke/indent-blankline.nvim", main = "ibl", config = true },

  -- Which-key (shows available keybindings as you type) -------------------
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = true,
  },

})

-- ---------------------------------------------------------------------------
--  4. Editor options  (make it feel modern)
-- ---------------------------------------------------------------------------
local o = vim.opt

-- Appearance
o.number         = true        -- line numbers
o.relativenumber = true        -- relative numbers (great for jumping)
o.cursorline     = true        -- highlight current line
o.termguicolors  = true        -- 24-bit color
o.signcolumn     = "yes"       -- always show sign column (no layout shift)
o.showmode       = false       -- lualine already shows the mode
o.scrolloff      = 8           -- keep 8 lines visible above/below cursor

-- Tabs & indentation (2-space like most modern editors)
o.tabstop     = 2
o.shiftwidth  = 2
o.expandtab   = true
o.smartindent = true

-- Search
o.ignorecase = true
o.smartcase  = true            -- case-sensitive if you type uppercase

-- UX
o.mouse       = "a"            -- full mouse support
o.clipboard   = "unnamedplus"  -- use system clipboard (y/p = Cmd-C/Cmd-V)
o.undofile    = true           -- persistent undo across sessions
o.splitright  = true           -- new vertical splits open to the right
o.splitbelow  = true           -- new horizontal splits open below
o.updatetime  = 250            -- faster CursorHold events
o.wrap        = false          -- no line wrapping

-- ---------------------------------------------------------------------------
--  5. Keymaps  (familiar shortcuts)
-- ---------------------------------------------------------------------------
local map = vim.keymap.set

-- Save / Quit
map("n", "<C-s>", "<cmd>w<cr>",  { desc = "Save" })
map("i", "<C-s>", "<Esc><cmd>w<cr>", { desc = "Save (insert mode)" })
map("n", "<C-q>", "<cmd>q<cr>",  { desc = "Quit" })

-- Undo / Redo  (Ctrl-Z / Ctrl-Shift-Z)
map("n", "<C-z>", "u",     { desc = "Undo" })
map("n", "<C-y>", "<C-r>", { desc = "Redo" })

-- Move lines up/down (Alt + j/k) like VS Code Alt+↑/↓
map("n", "<A-j>", "<cmd>m .+1<cr>==",         { desc = "Move line down" })
map("n", "<A-k>", "<cmd>m .-2<cr>==",         { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<cr>gv=gv",        { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<cr>gv=gv",        { desc = "Move selection up" })

-- Stay centered when scrolling
map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
map("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Buffer navigation (like tabs in VS Code)
map("n", "<S-l>", "<cmd>bnext<cr>",     { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
map("n", "<leader>x", "<cmd>bdelete<cr>", { desc = "Close buffer" })

-- Clear search highlighting
map("n", "<Esc>", "<cmd>nohlsearch<cr>")

-- Select all
map("n", "<C-a>", "ggVG", { desc = "Select all" })

-- ---------------------------------------------------------------------------
--  6. Quick-reference cheat sheet (shown with :Cheatsheet)
-- ---------------------------------------------------------------------------
vim.api.nvim_create_user_command("CS", function()
  local lines = {
    "",
    "  NEOVIM CHEATSHEET",
    "  -----------------",
    "",
    "  Ctrl-P ............. Find files (like VS Code)",
    "  Ctrl-Shift-F ....... Search in project",
    "  Ctrl-B ............. Toggle file tree",
    "  Ctrl-S ............. Save",
    "  Ctrl-Q ............. Quit",
    "  Ctrl-Z / Ctrl-Y ... Undo / Redo",
    "  Alt-J / Alt-K ...... Move line(s) up/down",
    "  Shift-H / L ........ Prev / Next buffer (tab)",
    "  Space x ............ Close buffer",
    "  gcc ................ Toggle comment (line)",
    "  gc ................. Toggle comment (visual)",
    "  Space (hold) ....... Shows all keybindings",
    "",
    "  ESSENTIAL VIM",
    "  -----------------",
    "",
    "  i / Esc ............ Enter / Exit insert mode",
    "  :w  :q  :wq ........ Save / Quit / Both",
    "  dd / yy / p ........ Delete / Copy / Paste line",
    "  /pattern ........... Search (n = next, N = prev)",
    "  u / Ctrl-R ......... Undo / Redo (vim-native)",
    "",
  }
  vim.api.nvim_echo(
    vim.tbl_map(function(l) return { l .. "\n", "Normal" } end, lines),
    true, {}
  )
end, {})

-- Print a welcome hint on startup
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    if vim.fn.argc() == 0 then
      vim.defer_fn(function()
        vim.notify("💡 Type :CS for key bindings  |  Ctrl-P to find files  |  Space to see commands", vim.log.levels.INFO)
      end, 100)
    end
  end,
})