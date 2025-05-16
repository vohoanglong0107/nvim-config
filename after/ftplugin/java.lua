local jdtls = require("jdtls")

local root_files = {
	".git",
	"mvnw",
	"gradlew",
	"pom.xml",
	"build.gradle",
	"build.sbt",
}

local root_dir = vim.fs.root(0, root_files)
local workspace_dir = vim.fn.stdpath("cache") .. "/nvim-jdtls"
local path_to_jdtls = vim.fn.expand("$MASON/packages/jdtls")
local path_to_lombok = path_to_jdtls .. "/lombok.jar"

local java_bundles = {}

local path_to_java_debug = vim.fn.expand("$MASON/packages/java-debug-adapter")
local paths_to_java_debug_bundles =
	vim.fn.glob(path_to_java_debug .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", true, true)
vim.list_extend(java_bundles, paths_to_java_debug_bundles)

local path_to_java_test = vim.fn.expand("$MASON/packages/java-test")
local paths_to_java_test_bundles = vim.fn.glob(path_to_java_test .. "/extension/server/*.jar", true, true)
vim.list_extend(java_bundles, paths_to_java_test_bundles)

local function jdtls_on_attach(_, bufnr)
	-- Override run closest test keymap
	vim.keymap.set("n", "<leader>tr", function()
		require("jdtls").test_nearest_method()
	end, { buffer = bufnr, desc = "Run closest test" })

	-- Override run tests in current buffer, since in java one file only contains
	-- one class, run all test current buffer should be equivalent to run all
	-- tests in a class
	vim.keymap.set("n", "<leader>tf", function()
		require("jdtls").test_class()
	end, { buffer = bufnr, desc = "Run all tests in current buffer" })
end

local extendedClientCapabilities = jdtls.extendedClientCapabilities
extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

local config = {
	cmd = {
		"jdtls", -- need to be on your PATH
		"--jvm-arg=-javaagent:" .. path_to_lombok,
		"-data",
		workspace_dir,
	},
	root_dir = root_dir,
	on_attach = jdtls_on_attach,
	init_options = {
		bundles = java_bundles,
		extendedClientCapabilities = extendedClientCapabilities,
	},
}

jdtls.start_or_attach(config)
