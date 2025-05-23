-- Language specific plugins
return {
	-- Java
	{
		"mfussenegger/nvim-jdtls",
		lazy = true,
		dependencies = { "mfussenegger/nvim-dap" },
	},
	-- Rust
	{
		"mrcjkb/rustaceanvim",
		version = "^6",
		lazy = false, -- This plugin is already lazy
	},
	{ "towolf/vim-helm" },
}
