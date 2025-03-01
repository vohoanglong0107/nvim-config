local base = require("hlong.languages.base")
local lspconfig = require("lspconfig")

lspconfig.pyright.setup({
	settings = {
		python = {
			analysis = {
				typeCheckingMode = "basic",
			},
		},
	},
	capabilities = base.capabilities,
})

lspconfig.ruff.setup({
	on_attach = function(client, _)
		client.server_capabilities.hoverProvider = false
	end,
	capabilities = base.capabilities,
})
