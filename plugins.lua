local cmp = require "cmp"

local plugins = {
    "iamcco/markdown-preview.nvim",
    "nvim-lua/plenary.nvim",
    "simrat39/rust-tools.nvim",
    {
        "rcarriga/nvim-dap-ui",
        event = "VeryLazy",
        dependencies = "mfussenegger/nvim-dap",
        config = function ()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function ()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function ()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function ()
                dapui.close()
            end
        end
    },
    {
        "jay-babu/mason-nvim-dap.nvim",
        event = "VeryLazy",
        dependencies = {
            "williamboman/mason.nvim",
            "mfussenegger/nvim-dap",
        },
        opts = {
            handlers = {},
        }
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
    },
    {
        "jose-elias-alvarez/null-ls.nvim",
        event = "VeryLazy",
        opts = function()
            return require "custom.configs.null-ls"
        end,
    },
    {
        "williamboman/mason.nvim",
        opts = {
          ensure_installed = {
            "clangd",
            "clang-format",
            "codelldb",
            "rust-analyzer",
          },
        },
    },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },
  {
    "simrat39/rust-tools.nvim",
    ft = "rust",
    dependencies = "neovim/nvim-lspconfig",
    opts = function ()
      return require "custom.configs.rust-tools"
    end,
    config = function(_, opts)
      require('rust-tools').setup(opts)
    end
  },
  {
    "mfussenegger/nvim-dap",
    init = function(_, _)
      require("core.utils").load_mappings("dap")
    end
  },
  {
    'saecki/crates.nvim',
    ft = {"toml"},
    config = function(_, opts)
      local crates  = require('crates')
      crates.setup(opts)
      require('cmp').setup.buffer({
        sources = { { name = "crates" }}
      })
      crates.show()
      require("core.utils").load_mappings("crates")
    end,
  },
  {
    "rust-lang/rust.vim",
    ft = "rust",
    init = function ()
      vim.g.rustfmt_autosave = 1
    end
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    lazy = false,
    config = function(_, opts)
      require("nvim-dap-virtual-text").setup()
    end
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local M = require "plugins.configs.cmp"
      M.completion.completeopt = "menu,menuone,noselect"
      M.mapping["<CR>"] = cmp.mapping.confirm {
        behavior = cmp.ConfirmBehavior.Insert,
        select = false,
      }
      table.insert(M.sources, {name = "crates"})
      return M
    end,
  }
}
return plugins
