-- Добавляем текущую директорию в путь поиска Lua
local project_root = vim.fn.getcwd()

local FAKE_MEMORY_BANK_FILES_QTY = 2

package.path = project_root .. "/?.lua;" .. package.path
package.path = project_root .. "/?/init.lua;" .. package.path

local ext = require('lua.ai_memory.extensions.codecompanion')

local test_files = ext.read_memory_files()

local function should_have_keys_for_dirs()
	if not test_files.all then return false, "Do not have all key in memory" end
	if not test_files["./memory-bank"] then return false, "Do not have ./memory-bank key in memory" end

	return true, "OK"
end

assert(#test_files.all == FAKE_MEMORY_BANK_FILES_QTY, "should_read_files_and_nested_dir")

local keys_ok, message = should_have_keys_for_dirs()

assert(keys_ok, message)

-- TODO: add tests for keys in cc_config, memory_bank content and so on

print("tests OK")
