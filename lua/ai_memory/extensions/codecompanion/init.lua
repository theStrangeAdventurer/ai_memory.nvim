-- example of expose resource from extension https://github.com/ravitemer/mcphub.nvim/tree/main/lua/mcphub/extensions/codecompanion

local M = {}

M.options = {
	--- @type string
	resource_name = "memory_bank",
	---@type (string | { dir: string, name: string })[]
	memory_files = { "./memory-bank" },
}

function M.read_memory_files()
	--- @link https://github.com/nvim-lua/plenary.nvim/blob/master/lua/plenary/scandir.lua#L151
	local scan = require 'plenary.scandir'

	--- @alias FileContent { content: string, path: string }
	--- @alias Contents { all: FileContent[], [string]: FileContent[] }
	--- @type Contents
	local contents = { all = {} }

	for _, dir in ipairs(M.options.memory_files) do
		local _dir = { dir = dir, name = dir }
		if type(dir) == "table" then
			_dir = dir
		end

		contents[_dir.name] = contents[_dir.name] or {}
		local is_absolute_path = _dir.dir:sub(1, 1) == "/" or _dir.dir:sub(1, 1) == "~"

		---@type string
		local path
		if _dir.dir:sub(1, 1) == "~" then
			path = vim.fn.expand(_dir.dir)
		elseif is_absolute_path then
			path = _dir.dir
		else
			path = vim.fn.getcwd() .. "/" .. _dir.dir
		end


		---@type string[]
		local data = scan.scan_dir(path, { hidden = false, depth = 5 })

		for _, file_path in ipairs(data) do
			-- Skip directories, only process files
			if vim.fn.isdirectory(file_path) == 0 then
				local file = io.open(file_path, "r")
				if file then
					local content = file:read("*all")
					file:close()

					table.insert(contents.all, {
						path = file_path,
						content = content
					})

					table.insert(contents[_dir.name], {
						path = file_path,
						content = content
					})
				end
			end
		end
	end
	return contents
end

function M.register(params)
	M.options.resource_name = params.resource_name or M.options.resource_name
	M.options.memory_files = params.memory_files or M.options.memory_files

	local ok, config = pcall(require, "codecompanion.config")
	if not ok then
		return
	end

	local files = M.read_memory_files()
	print(vim.inspect({ files = files }))

	for key, value in pairs(files) do
		if not value or (type(value) == "table" and not next(value)) then
			goto continue
		end

		if key == "all" then
			key = M.options.resource_name
		else
			key = M.options.resource_name .. ":" .. key
		end

		config.strategies.chat.variables[key] = {
			callback = function()
				local content = ""

				if type(value) == "table" then
					for _, file in ipairs(value) do
						content = content ..
							"--- " ..
							tostring(file.path) ..
							" ---\n" .. tostring(file.content) .. "\n ------ \n\n"
					end
				end

				if content ~= "" then
					content = "Resource memory_bank: \n\n" .. content .. ""
				else
					content = "Resource memory_bank: empty"
				end

				return content
			end,
			description = "Returns important project information",
			id = "memory_bank",
		}
		::continue::
	end
	return M
end

function M.setup(params)
	M.register(params or {})
	return M
end

function M.get_info()
	return {
		name = "ai_memory",
		description =
		"Adds the ability to use project context as a resource in AI extensions (now only in CodeCompanion)",
		version = "0.1.0",
	}
end

return M
