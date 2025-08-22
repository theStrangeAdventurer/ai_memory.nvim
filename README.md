# AI Memory Extension

### What can this plugin do?
He looks at the directory (by default, cwd/memory-bank or whatever will be transferred through the configuration) and literally scans it.
> It is expected that this directory (or directories) contains a set of md files with a context 
After that, we have a set of variables that we can put into context. 
Variables are automatically created for all nested directories (for example, for the /memory-bank/fronted directory), the variable #{memory_bank:./frontend} will be created

![AI Memory Demo](static/ai_memory_demo.gif)

> This extension currently only works with 'olimorris/codecompanion.nvim' and adds the ability to use a resource ([variable](https://codecompanion.olimorris.dev/usage/chat-buffer/variables.html#using-variables)) in the chat window with LLM.

## Minimal Configuration

```lua
{
-- codecompanion plugin configuration file
   'olimorris/codecompanion.nvim',
	dependencies = {
        -- ... other dependencies
		{ "theStrangeAdventurer/ai_memory.nvim" } -- add new dependency
	},
	config = function()
        require("codecompanion").setup({
            -- ...rest config fields
			extensions = {
                -- ...other extensions
				ai_memory = {
					callback = "ai_memory.extensions.codecompanion",
				}
			},
        })
    end
}
```

## Extended Configuration

```lua
-- codecompanion plugin configuration file
{
   'olimorris/codecompanion.nvim',
	dependencies = {
        -- ... other dependencies
		{ "theStrangeAdventurer/ai_memory.nvim" } -- add new dependency
	},
	config = function()
        require("codecompanion").setup({
            -- ...rest config fields
			extensions = {
                -- ...other extensions
				ai_memory = {
					callback = "ai_memory.extensions.codecompanion",
					opts = {
						resource_name = 'memory_bank' -- default: memory_bank (variable name in a chat window) 
						memory_files = { -- default: './memory-bank/' (or env.AI_MEMORY_DEFAULT_MEMORY_FILES_PATH)
                            "./memory-bank", -- will be available in #{memory_bank:./memory-bank} variable
                            "../some-parent-dir", -- will be available in codecompanion chat window as #{memory_bank:../some-parent-dir}
                            { dir = "/absolute/path/to/dir", name = "awesome" }, -- will be available as #{memory_bank:awesome} variable
                            { dir = "./memory-bank/frontend", name = "frontend" }, -- will be available as #{memory_bank:frontend} variable
                        }, 
					}
				}
			},
        })
    end
}
```
## Usage

In codecompanion chat you can easely use #{memory_bank} variable and also #{}

```
#{memory_bank:all} What are you see in memory_bank?
```

```
#{memory_bank:frontend} you have to write new awesome component 
```
### Edit

```
You should describe your decision short (thesis) in #{memory_bank:frontend} for future reference using @{files} 
```
