return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        init = function()
          vim.o.timeout = true
          vim.o.timeoutlen = 300
        end,
        opt = {},
        config = function()
            local wk = require("which-key")

            local keymap = vim.options_keymap

            wk.add({
                { "<leader>" .. keymap.debug, function() require("dapui").toggle() end, desc = "Toggle debug" },
                { "<leader>" .. keymap.tree, "<cmd>NvimTreeToggle<cr>", desc = "Tree" },
                { "<leader>" .. keymap.find, group = "Find" },
                { "<leader>" .. keymap.find .. keymap.find_files, "<cmd>Telescope find_files<cr>", desc = "Find files" },
                { "<leader>" .. keymap.find .. keymap.live_grep, "<cmd>Telescope live_grep<cr>", desc = "Search for keyword" },
                { "<leader>" .. keymap.find .. keymap.todo, "<cmd>TodoTelescope<cr>", desc = "Search for TODOs" },
                { "<leader>" .. keymap.git, group = "Git" },
                { "<leader>" .. keymap.git .. keymap.branch, "<cmd>Neogit branch<cr>", desc = "Branch" },
                { "<leader>" .. keymap.git .. keymap.commit, "<cmd>Neogit commit<cr>" end, desc = "Commit" },
                { "<leader>" .. keymap.git .. keymap.diff, "<cmd>Neogit diff<cr>", desc = "Different View" },
                { "<leader>" .. keymap.git .. keymap.push, "<cmd>Neogit push<cr>", desc = "Push" },
                { "<leader>" .. keymap.git .. keymap.merge, "<cmd>Neogit merge<cr>", desc = "Merge" },
                { "<leader>" .. keymap.git .. keymap.pull, "<cmd>Neogit pull<cr>", desc = "Pull" },
                { "<leader>" .. keymap.git .. keymap.rebase, "<cmd>Neogit rebase<cr>", desc = "Rebase" },
                { "<leader>" .. keymap.lazy, "<cmd>Lazy<cr>", desc = "Lazy" },
                { "<leader>" .. keymap.mason, "<cmd>Mason<cr>", desc = "Mason" },
                { "<leader>" .. keymap.theme, "<cmd>Themery<cr>", desc = "Themery" },
                { "<leader>" .. keymap.projects, "<cmd>SelectProject<cr>", desc="Projects" }
            })
        end
    },
    {
        'ch0nker/dashboard-nvim',
        event = 'VimEnter',
        opts = {
            theme = "hyper",
            config = {
                image = vim.g.header_image_path,
            }
        },
        dependencies = { {"image.nvim"}, {'nvim-tree/nvim-web-devicons'}}
    },
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        opts = {
            view = {
                width = 25
            },
            renderer = {
                group_empty = true
            }
        },
    },
    {
        'stevearc/dressing.nvim', opts = {},
    },
    {
        "NeogitOrg/neogit",
        dependencies = {
          "nvim-lua/plenary.nvim",         -- required
          "sindrets/diffview.nvim",        -- optional - Diff integration
          "nvim-telescope/telescope.nvim", -- optional
        },
        opts = {}
    },

    {
        "utilyre/barbecue.nvim",
        name = "barbecue",
        version = "*",
        dependencies = {
          "SmiteshP/nvim-navic",
          "nvim-tree/nvim-web-devicons", -- optional dependency
        },
        opts = {
          -- configurations go here
        },
    },
    {
        'jbyuki/one-small-step-for-vimkind',
        dependencies = {'mfussenegger/nvim-dap'}
    },
    { "rcarriga/nvim-dap-ui", config=function()
        local dap = require("dap")

        dap.adapters.python = {
            type = "executable",
            command = "python",
            args = { "-m", "debugpy.adapter" }
        }

        dap.configurations.python = {
               {
                type = "python",
                request = "launch",
                name = "Run script",
                program = "${file}",
                pythonPath = function() return "/usr/bin/python" end
               }
         }

        dap.adapters.nlua = function(callback, config)
           callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
        end

        dap.configurations.lua = {
               {
                   type = "nlua",
                   request = "launch",
                   name = "Run script",
                   program = "${file}"
            }
        }

        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "~/.local/share/nvim/ms-vscode.cpptools-1.21.0@linux-x64/extension/debugAdapters/bin/OpenDebugAD7"
        }

        dap.configurations.cpp = {
          {
            name = "Launch file",
            type = "cppdbg",
            request = "launch",
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopAtEntry = true,
          },
          {
            name = 'Attach to gdbserver :1234',
            type = 'cppdbg',
            request = 'launch',
            MIMode = 'gdb',
            miDebuggerServerAddress = 'localhost:1234',
            miDebuggerPath = '/usr/bin/gdb',
            cwd = '${workspaceFolder}',
            program = function()
              return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
            end,
          },
        }

        dap.configurations.c = dap.configurations.cpp
        dap.configurations.rust = dap.configurations.cpp

        require("dapui").setup()
    end, dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"} },
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = {
            "nvim-tree/nvim-web-devicons"
        },
        opts = {}
    },
    {
        "williamboman/mason.nvim",
        opts={
            ui = {
                icons = {
                    package_installed = "✓",
                    package_pending = "➜",
                    package_uninstalled = "✗"
                }
            }
        }
    },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "utilyre/barbecue.nvim", "mason.nvim", "nvim-cmp" },
        config = function()
            require("mason-lspconfig").setup()
            require("mason-lspconfig").setup_handlers({
                function(server_name)
                    local capabilities = require("cmp_nvim_lsp").default_capabilities()

                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            if client.server_capabilities["documentSymbolProvider"] then
                                require("nvim-navic").attach(client, bufnr)
                            end
                        end
                    })
                end
            })
        end
    },
    {
        "3rd/image.nvim",
        opts = {}
    },
    {
        "vhyrro/luarocks.nvim",
        priority = 1001,
        opts = { 
	        rocks = { "magick" },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                "lazy.nvim",
            }
        }
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
  -- { "folke/neodev.nvim", enabled = false }, -- make sure to uninstall or disable neodev.nvim
    {
        "hrsh7th/nvim-cmp",
	    dependencies = {
            "hrsh7th/cmp-nvim-lsp",
		    "hrsh7th/cmp-nvim-lua",
		    "hrsh7th/cmp-buffer",
		    "hrsh7th/cmp-path",
		    "hrsh7th/cmp-cmdline",
		    "saadparwaiz1/cmp_luasnip",
		    "L3MON4D3/LuaSnip"
        },
        config = function()
            local cmp = require("cmp")

	        vim.opt.completeopt = { "menu", "menuone", "noselect" }

            cmp.setup({
		        snippet = {
			        expand = function(args)
				        require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
			        end,
		        },
		        mapping = cmp.mapping.preset.insert({
                    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-f>'] = cmp.mapping.scroll_docs(4),
                    ['<C-Space>'] = cmp.mapping.complete(),
                    ['<C-e>'] = cmp.mapping.abort(),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
                }),
		        sources = cmp.config.sources({
			        { name = "nvim_lsp" },
			        { name = "nvim_lua" },
			        { name = "luasnip" },
                    { name = "lazydev", group_index = 0}-- For luasnip users.
			        -- { name = "orgmode" },
		        }, {
			        { name = "buffer" },
			        { name = "path" },
		        }),
	        })
        end
	},
    {
        "lewis6991/gitsigns.nvim",
        opts = {}
    },
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        opts = {}
    }, 
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        opts = {}
    },
    {
        "folke/todo-comments.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = {}
    },
    {
        "karb94/neoscroll.nvim",
        opts = {}
    },
    {
      "folke/noice.nvim",
      event = "VeryLazy",
      opts = {
        lsp = {
          -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            --["cmp.entry.get_documentation"] = true, -- requires hrsh7th/nvim-cmp
          },
        },
        -- you can enable a preset for easier configuration
        presets = {
          bottom_search = true, -- use a classic bottom cmdline for search
          command_palette = true, -- position the cmdline and popupmenu together
          long_message_to_split = true, -- long messages will be sent to a split
          inc_rename = false, -- enables an input dialog for inc-rename.nvim
          lsp_doc_border = false, -- add a border to hover docs and signature help
        },
      },
      dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
        }
    }
}
