-- example of expose resource from extension https://github.com/ravitemer/mcphub.nvim/tree/main/lua/mcphub/extensions/codecompanion

local M = {}

M.options = {
	enabled = true,
	memory_files = { vim.fn.getcwd() .. "/memory-bank" },
}

function M.read_memory_files()
	local scan = require 'plenary.scandir'
	--- @class FileContent
	--- @field path string The path to the file
	--- @field content string The content of the file

	--- @type FileContent[] Array of file contents
	local contents = {}

	for _, dir in ipairs(M.options.memory_files) do
		-- https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/scandir.lua#L151
		--- `data` is an array of strings containing file/directory paths
		---@type string[]
		local data = scan.scan_dir(dir, { hidden = false, depth = 5 })

		for _, file_path in ipairs(data) do
			-- Skip directories, only process files
			if vim.fn.isdirectory(file_path) == 0 then
				local file = io.open(file_path, "r")
				if file then
					local content = file:read("*all")
					file:close()

					table.insert(contents, {
						path = file_path,
						content = content
					})
				end
			end
		end
	end
	return contents
end

function M.register(opts)
	vim.schedule(function()
		vim.tbl_deep_extend("force", opts.config.config.strategies.chat.variables, {
			memory_bank = {
				callback = function(params)
					local files = M.read_memory_files()
					local content = ""

					if type(files) == "table" then
						for _, file in ipairs(files) do
							content = content ..
								"\n\n--- " ..
								tostring(file.path) ..
								" start: ---\n\n" .. tostring(file.content) .. "\n\n --- end --- \n\n"
						end
					else
						content = "\n\n--- unknown start: ---\n\n" .. tostring(files) .. "\n\n --- end --- \n\n"
					end
					return "Resource memory_bank: \n\n--- this is important project context ---\n\n" .. content .. ""
				end,
				description = "Return very important information for project",
				id = "memory_bank",
			},
		})
	end)
	return M
end

function M.setup(opts)
	vim.tbl_deep_extend("force", M.options, opts or {})

	print(vim.inspect({ testCall = true, pluginOptions = M.options }))

	local ok, cc_config = pcall(require, "codecompanion.config")
	if not ok then
		return
	end

	M.register({ config = cc_config }) -- FIXME: add options

	return M
end

function M.get_info()
	return {
		name = "codecompanion-memory",
		description = "Adds the ability to use project context as a resource in CodeCompanion",
		version = "0.1.0",
	}
end

return M
