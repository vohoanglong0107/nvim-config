local M = {}

--- @class keymap
--- @field modes string[]
--- @field lhs string left hand side
--- @field rhs string|function right hand side
--- @field desc string
--- @field opts table?

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

--- @type keymap[]
local global_keymaps = {
	-- Resize with arrows
	{
		modes = { "n" },
		lhs = "<C-Up>",
		rhs = ":resize -2<CR>",
		desc = "Decrease current window height",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<C-Down>",
		rhs = ":resize +2<CR>",
		desc = "Increase current window height",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<C-Left>",
		rhs = ":vertical resize -2<CR>",
		desc = "Decrease current window width",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<C-Right>",
		rhs = ":vertical resize +2<CR>",
		desc = "Increase current window window",
		opts = { silent = true },
	},
	-- Navigate window
	{ modes = { "n" }, lhs = "<C-w>b", rhs = "<C-w>s", desc = "Split window horizontally", opts = { noremap = true } },
	-- Move text up and down
	{ modes = { "n", "v" }, lhs = "<A-j>", rhs = ":m .+1<CR>==", desc = "Move lines down", opts = { silent = true } },
	{ modes = { "n", "v" }, lhs = "<A-k>", rhs = ":m .-2<CR>==", desc = "Move lines up", opts = { silent = true } },
	-- Undo
	{ modes = { "n" }, lhs = "U", rhs = "<C-r>", desc = "Undo", opts = { noremap = true } },
	-- Clear highlights
	{
		modes = { "n" },
		lhs = "<leader>h",
		rhs = "<cmd>nohlsearch<CR>",
		desc = "Clear highlights",
		opts = { silent = true },
	},
	-- Consistent search direction
	{
		modes = { "n" },
		lhs = "n",
		rhs = function()
			return vim.v.searchforward == 1 and "n" or "N"
		end,
		desc = "Search next",
		-- expr is used to evaluate "n" or "N" to the underlying mapping
		opts = { expr = true },
	},
	{
		modes = { "n" },
		lhs = "N",
		rhs = function()
			return vim.v.searchforward == 1 and "N" or "n"
		end,
		desc = "Search previous",
		opts = { expr = true },
	},
	-- System clipboard yank
	{ modes = { "v" }, lhs = "<leader>y", rhs = '"+y', desc = "Yank to system clipboard", opts = { noremap = true } },
	{
		modes = { "v", "n" },
		lhs = "<leader>p",
		rhs = '"+p',
		desc = "Paste from system clipboard",
		opts = { noremap = true },
	},
	-- stay in visual mode when indenting
	{ modes = { "v" }, lhs = "<", rhs = "<gv", desc = "Indent left", opts = { noremap = true } },
	{ modes = { "v" }, lhs = ">", rhs = ">gv", desc = "Indent right", opts = { noremap = true } },
	-- moving between files
	{ modes = { "n" }, lhs = "ga", rhs = "<C-6>", desc = "Switch to last accessed buffer", opts = { noremap = true } },
	{
		modes = { "n" },
		lhs = "<leader>ff",
		rhs = "<cmd>Telescope find_files<CR>",
		desc = "Find files",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>fs",
		rhs = "<cmd>Telescope live_grep<CR>",
		desc = "Find string in all files",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>fb",
		rhs = "<cmd>Telescope buffers<CR>",
		desc = "Find buffers",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>fo",
		rhs = "<cmd>Telescope lsp_document_symbols<CR>",
		desc = "Find symbols/object in current buffer",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>hc",
		rhs = "<cmd>Telescope command_history<CR>",
		desc = "Find recently used commands",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>fh",
		rhs = function()
			require("telescope.builtin").oldfiles()
		end,
		desc = "Find recently accessed files",
		opts = { silent = true },
	},
	-- Commenting
	{
		modes = { "n", "v" },
		lhs = "<leader>/",
		rhs = function()
			require("Comment.api").toggle.linewise.current()
		end,
		desc = "Toggle comment",
	},
	{
		modes = { "x" },
		lhs = "<leader>/",
		rhs = function()
			-- :h comment.api
			local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
			vim.api.nvim_feedkeys(esc, "nx", false)
			require("Comment.api").toggle.linewise(vim.fn.visualmode())
		end,
		desc = "Toggle comment in visual block mode",
	},
	-- leap
	{
		modes = { "n", "x", "o" },
		lhs = "s",
		rhs = function()
			require("flash").jump()
		end,
		desc = "Leap/Flash",
	},
	-- toggle file explorer
	{
		modes = { "n" },
		lhs = "<leader>e",
		rhs = "<cmd>Oil<CR>",
		desc = "Open file explorer",
	},
	-- Run tests
	{
		modes = { "n" },
		lhs = "<leader>tr",
		rhs = function()
			require("neotest").run.run()
		end,
		desc = "Run closest test",
	},
	{
		modes = { "n" },
		lhs = "<leader>tf",
		rhs = function()
			require("neotest").run.run(vim.fn.expand("%"))
		end,
		desc = "Run all tests in current buffer",
	},
	{
		modes = { "n" },
		lhs = "<leader>ta",
		rhs = function()
			require("neotest").run.run({ suite = true })
		end,
		desc = "Run all tests",
	},
	{
		modes = { "n" },
		lhs = "<leader>to",
		rhs = function()
			require("neotest").output.open({ enter = true })
		end,
		desc = "Open test output",
	},
	{
		modes = { "n" },
		lhs = "<leader>ts",
		rhs = function()
			require("neotest").summary.open()
		end,
		desc = "Open tests summary",
	},
	{
		modes = { "n" },
		lhs = "<leader>td",
		rhs = function()
			require("neotest").run.run({ strategy = "dap" })
		end,
		desc = "Run closest test with debugger",
	},
	{
		modes = { "n" },
		lhs = "[t",
		rhs = function()
			require("neotest").jump.prev({ status = "failed" })
		end,
		desc = "Jump to previous failed test",
	},
	{
		modes = { "n" },
		lhs = "]t",
		rhs = function()
			require("neotest").jump.next({ status = "failed" })
		end,
		desc = "Jump to next failed test",
	},
	-- Debugging
	{
		modes = { "n" },
		lhs = "<leader>dc",
		rhs = function()
			require("dap").continue()
		end,
		desc = "Start/Continue debugging",
	},
	{
		modes = { "n" },
		lhs = "<leader>ds",
		rhs = function()
			require("dap").step_over()
		end,
		desc = "Step over",
	},
	{
		modes = { "n" },
		lhs = "<leader>di",
		rhs = function()
			require("dap").step_into()
		end,
		desc = "Step in",
	},
	{
		modes = { "n" },
		lhs = "<leader>do",
		rhs = function()
			require("dap").step_out()
		end,
		desc = "Step out",
	},
	{
		modes = { "n" },
		lhs = "<leader>db",
		rhs = function()
			require("dap").toggle_breakpoint()
		end,
		desc = "Toggle Breakpoint",
	},
	{
		modes = { "n" },
		lhs = "<leader>dt",
		rhs = function()
			local dap = require("dap")

			-- Session might have been closed when the executable throws or rans to complete
			if dap.session() ~= nil then
				dap.terminate()
			end

			require("dapui").close()
		end,
		desc = "Exit debugging. The session might have been terminated, either by running to complete or throw",
	},
	{
		modes = { "n" },
		lhs = "<leader>dh",
		rhs = function()
			require("dap.ui.widgets").hover()
		end,
		desc = "View variable",
	},
	-- Obsidian
	{
		modes = { "n" },
		lhs = "<leader>ot",
		rhs = function()
			local inside_obsidian_vault = vim.fn.isdirectory(".obsidian")
			if not inside_obsidian_vault then
				vim.notify("Not inside an Obsidian vault", vim.log.levels.WARN)
				return
			end
			local client = require("obsidian").get_client()
			local note = client:today()
			client:open_note(note)
		end,
		desc = "Open today notes",
	},
	-- Global search and replace
	{
		modes = { "n" },
		lhs = "<leader>S",
		rhs = function()
			require("spectre").toggle()
		end,
		desc = "Global search and replace",
	},
	-- Close buffer
	{
		modes = { "n" },
		lhs = "<leader>q",
		rhs = "<cmd>Bdelete<CR>",
		desc = "Close buffer",
		opts = { silent = true },
	},
	{
		modes = { "i" },
		lhs = "<S-Right>",
		rhs = 'copilot#Accept("\\<CR>")',
		desc = "Accept copilot suggestion",
		opts = { expr = true, replace_keycodes = false, silent = true },
	},
	-- Git
	{
		modes = { "n" },
		lhs = "<leader>gl",
		rhs = "<cmd>LazyGit<CR>",
		desc = "Open lazygit",
		opts = { silent = true },
	},
	{
		modes = { "n" },
		lhs = "<leader>gb",
		rhs = "<cmd>Gitsigns blame<CR>",
		desc = "Open git blame",
		opts = { silent = true },
	},
}

--- @param buffer number
--- @return keymap[]
local function lsp_keymaps(buffer)
	return {
		{
			modes = { "n" },
			lhs = "gD",
			rhs = function()
				require("trouble").open({ mode = "lsp_declarations" })
			end,
			desc = "Go to declaration",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "gd",
			rhs = function()
				require("trouble").open({ mode = "lsp_definitions" })
			end,
			desc = "Go to definition",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "K",
			rhs = vim.lsp.buf.hover,
			desc = "Show information about the hovered symbol",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "gi",
			rhs = function()
				require("trouble").open({ mode = "lsp_implementations" })
			end,
			desc = "Go to implementations",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "gr",
			rhs = function()
				require("trouble").open({ mode = "lsp_references", focus = true, auto_refresh = false })
			end,
			desc = "Go to references",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "<leader>ll",
			rhs = vim.diagnostic.open_float,
			desc = "Open diagnostic float window",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "<leader>lf",
			rhs = function()
				vim.lsp.buf.format({ async = true })
			end,
			desc = "Format buffer",
			opts = { buffer = buffer },
		},
		{
			modes = { "n", "v" },
			lhs = "<leader>la",
			rhs = vim.lsp.buf.code_action,
			desc = "Show code actions",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "]d",
			rhs = vim.diagnostic.goto_next,
			desc = "Go to next diagnostic",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "[d",
			rhs = vim.diagnostic.goto_prev,
			desc = "Go to previous diagnostic",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "<leader>lr",
			rhs = vim.lsp.buf.rename,
			desc = "Rename symbol",
			opts = { buffer = buffer },
		},
		{
			modes = { "n" },
			lhs = "<leader>ls",
			rhs = vim.lsp.buf.signature_help,
			desc = "Show signature help",
			opts = { buffer = buffer },
		},
		-- Diagnostic
		{
			modes = { "n" },
			lhs = "<leader>ld",
			rhs = function()
				require("trouble").toggle({
					mode = "diagnostics",
					filter = { buf = 0 },
				})
			end,
			desc = "Open Buffer Diagnostic",
			opts = { silent = true },
		},
		{
			modes = { "n" },
			lhs = "<leader>lD",
			rhs = function()
				require("trouble").toggle({ mode = "diagnostics" })
			end,
			desc = "Open Workspace Diagnostic",
			opts = { silent = true },
		},
		{
			modes = { "n" },
			lhs = "<leader>lo",
			rhs = "<cmd>Trouble symbols toggle focus=false<cr>",
			desc = "Open Symbols outline",
			opts = { silent = true },
		},
	}
end

--- @param keymaps keymap[]
local function set_keymaps(keymaps)
	for _, keymap in ipairs(keymaps) do
		local opts = keymap.opts or {}
		opts.desc = keymap.desc
		vim.keymap.set(keymap.modes, keymap.lhs, keymap.rhs, opts)
	end
end

--- use right key for githlub copilot
set_keymaps(global_keymaps)

M.lsp = lsp_keymaps
M.set = set_keymaps

return M
