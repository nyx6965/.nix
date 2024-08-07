local formatter = require("formatter")
local util = require("formatter.util")

local prettierConfig = function()
	return {
		exe = "prettierd",
		args = { vim.api.nvim_buf_get_name(0) },
		stdin = true,
	}
end

local ClangConfig = function()
	return {
		exe = "clang-format",
		args = {
			"--assume-filename",
			util.escape_path(util.get_current_buffer_file_name()),
			'--style="{BasedOnStyle: LLVM, AllowShortFunctionsOnASingleLine : All, IndentWidth: 4, TabWidth: 4, }"',
		},
		stdin = true,
		try_node_modules = true,
	}
end

local formatterConfig = {
	lua = {
		function()
			return {
				exe = "stylua",
				args = { "-" },
				stdin = true,
			}
		end,
	},
	nix = {
		function()
			return {
				exe = "alejandra",
				args = { "" },
				stdin = true,
			}
		end,
	},
	sh = {
		function()
			return {
				exe = "beautysh",
				args = { "-t" },
			}
		end,
	},
	rust = {
		-- -- Rustfmt
		-- function()
		--   return {
		--     exe = "rustfmt",
		--     args = {"--emit=stdout"},
		--     stdin = true
		--   }
		-- end
	},
	["*"] = {
		require("formatter.filetypes.any").lsp_format,
		-- require('formatter.filetypes.any').remove_trailing_whitespace
	},
}
local commonFT = {
	"html",
	"javascript",
	"typescript",
	"markdown",
	"markdown.mdx",
	"json",
	"yaml",
	"xml",
	"svg",
}

local C_type = {
	"c",
	"cpp",
}
for _, ft in ipairs(commonFT) do
	formatterConfig[ft] = { prettierConfig }
end

for _, ft in ipairs(C_type) do
	formatterConfig[ft] = { ClangConfig }
end
-- Setup functions
formatter.setup({
	logging = true,
	filetype = formatterConfig,
	log_level = 2,
})
