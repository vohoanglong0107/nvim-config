vim.lsp.config("pyright", {
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
			},
		},
	},
})
vim.lsp.config("ruff", {
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
})

vim.lsp.enable("pyright")
vim.lsp.enable("ruff")
