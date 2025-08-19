-- Добавляем текущую директорию в путь поиска Lua
local project_root = vim.fn.getcwd()

package.path = project_root .. "/?.lua;" .. package.path
package.path = project_root .. "/?/init.lua;" .. package.path

local ext = require('lua.codecompanion._extensions.codecompanion-memory')
ext.setup {}
print(vim.inspect(ext.read_memory_files()))
