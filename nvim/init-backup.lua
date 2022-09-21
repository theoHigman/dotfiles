-- Easier aliases 
o = vim.opt
f = vim.fn
c = vim.cmd
g = vim.g

-- Options
o.smarttab = true
o.smartindent = true
o.autoindent = true
o.clipboard = "unnamedplus"
o.showmatch = true
o.matchtime = 3
o.number = true
--Plugins
Plug = f["plug#"]

f["plug#begin"]()

Plug 'morhetz/gruvbox'
-- Plug 'ackyshake/VimCompletesMe'
Plug 'vim-airline/vim-airline'
Plug 'sheerun/vim-polyglot'
Plug 'preservim/nerdtree'
Plug 'svermeulen/vimpeccable'
Plug 'jiangmiao/auto-pairs'
Plug 'nvim-treesitter/nvim-treesitter' 
Plug 'williamboman/mason.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'uga-rosa/cmp-dictionary'

f["plug#end"]()

-- Colour Scheme
c "colorscheme gruvbox"

-- fixing nasm filetype

-- local fname = f["file"]()

-- if string.find(fname,".*\\.asm") ~= nil then
--  c "set filetype=nasm"
-- end


-- tree sitter
require'nvim-treesitter.configs'.setup {
  -- parser list
  ensure_installed = { "go", "c", "lua", "c_sharp", "cmake", "bash", "r", "python", "yaml", "javascript","typescript", "html", "glsl", "cpp", "json", "regex", "scheme", "commonlisp", "css", "cuda", "latex", "markdown" },
  -- sync installs
  sync_install = false,

  -- Automatically install missing in buffer
  auto_install = true,

  highlight = {
    -- Use treesitter highlighting
    enable = true,

    -- list of language that will be disabled
    -- disable = { "c", "rust" },

    additional_vim_regex_highlighting = false,
  },
}

-- Airline Config, couldn't do this through API
  c([[
    let g:airline#extensions#tabline#enabled = 1
    if !exists('g:airline_symbols')
      let g:airline_symbols = {}
      endif

      let g:airline_symbols.colnr = ' '
      let g:airline_symbols.linenr = ' '
      let g:airline_symbols.maxlinenr = ' '
      ]])
    -- mason setup

    require("mason").setup({
        ui = {
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        },

        github = {
          -- The template URL to use when downloading assets from GitHub.
          -- The placeholders are the following (in order):
          -- 1. The repository (e.g. "rust-lang/rust-analyzer")
          -- 2. The release version (e.g. "v0.3.0")
          -- 3. The asset name (e.g. "rust-analyzer-v0.3.0-x86_64-unknown-linux-gnu.tar.gz")
          download_url_template = "https://github.com/%s/releases/download/%s/%s",
        }
      })


    -- Setup for keybinds
    local vp = require "vimp"
    g.mapleader = "K"

    function niMap(key,map)
      vp.map(key,map)
      vp.imap(key,map .. "i") -- back into insert mode
    end

    niMap("<leader>W","<Esc>:w<Enter>")
    niMap("<leader>J","<Esc>:wq<Enter>")
    niMap("<leader>L","<Esc>gg=G")

    local os = require("os")
    vp.imap("<leader>P","<Esc>:")
    niMap("<leader>O","<Esc>:")
    vp.imap("<leader>K","<Esc>")
    niMap("<F5>","<Esc>:! ./vb.sh<Enter>")
    vp.map("<leader>T","<Esc>:NERDTree<Enter>")
    niMap("<leader>Q","<Esc>:q<Enter>")
    niMap("<leader>q","<Esc>:q!<Enter>")
    vp.noremap("<leader>H",function()
      print([[
        (ni)  KW -- write
        (ni)  KJ -- write quit
        (i)   KK -- quit to normal mode
        (nvi) KT -- nerdtree
        (nvi) Kq -- quit !
        (nvi) KQ -- quit
        (ni)  KL -- indent file
        (nvi) <F5> -- runs "vb.sh from current directory"
        (n)   KH -- show my keybinds
        (i)   KP -- exit to command line
        ]])
    end
    )
  -- vim-cmp setup

  -- Setup nvim-cmp.
  local cmp = require'cmp'

  cmp.setup({
      snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      --    window = {
        --      -- completion = cmp.config.window.bordered(),
        --      -- documentation = cmp.config.window.bordered(),
      --    },
      mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<Tab>'] = cmp.mapping.select_next_item(),
          ['<S-Tab>'] = cmp.mapping.select_prev_item(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
        }),
      --      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'vsnip' },
        }, {
          { name = 'buffer' },
        },
      {
				name = "dictionary",
				keyword_length = 2,
			}
        )
    })

  -- Set configuration for specific filetype.
  --  cmp.setup.filetype('gitcommit', {
      --    sources = cmp.config.sources({
          --      { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
          --    }, {
            --      { name = 'buffer' },
          --    })
      --  })

    -- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline('/', {
          mapping = cmp.mapping.preset.cmdline(),
          sources = {
            { name = 'buffer' }
          }
        })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
        cmp.setup.cmdline(':', {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({
                { name = 'path' }
              }, {
                { name = 'cmdline' }
              })
          })

        -- Setup lspconfig.
        local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())

        -- LSPCONFIG setup
        --[[
        require('lspconfig')['bash-language-server'].setup {
          capabilities = capabilities
        }
        --]]
        lsc = require('lspconfig')

        lsc['gopls'].setup{
          capabilities = capabilities
        }

        --        require'lspconfig'.bashls.setup{}

        lsc['bashls'].setup{
          capabilities = capabilities
        }

        lsc['clangd'].setup{
          capabilities = capabilities
        }

        lsc['sumneko_lua'].setup{
          capabilities = capabilities
        }

        -- cmp-dictionary setup

        require("cmp_dictionary").setup({
            dic = {
              ["nasm"] = {"~/.config/nvim/instructNasm.txt"}
            },
          })
        -- bash-language-server
        vim.notify "No Microsoft, I do not agree to your terms of service."
