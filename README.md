# AI Memory Extension

## Configuration

```lua
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
						resource_name = 'memory_bank' -- default: memory_bank (variable name)
						memory_files = { -- default: cwd .. './memory-bank/'
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
#{memory_bank} What are you see in memory_bank?
```

```
#{memory_bank:frontend} you have to write new awesome component 
```
