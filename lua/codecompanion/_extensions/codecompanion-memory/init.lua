-- example of expose resource from extension https://github.com/ravitemer/mcphub.nvim/tree/main/lua/mcphub/extensions/codecompanion

local M = {}

M.options = {
	enabled = true,
	memory_files = { vim.fn.getcwd() .. "/memory-bank" },
}

function M.setup(opts)
	vim.tbl_deep_extend("force", M.options, opts or {})
	return M
end

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

function M.get_info()
	return {
		name = "codecompanion-memory",
		description = "Adds the ability to use project context as a resource in CodeCompanion",
		version = "0.1.0",
	}
end

return M
