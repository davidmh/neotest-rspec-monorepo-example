local M = {}

function M.root(root)
  local f = debug.getinfo(1, 'S').source:sub(2)
  return vim.fn.fnamemodify(f, ':p:h') .. '/' .. (root or '')
end

local function ensure(user, repo)
  local path = M.root('.local/plugin/' .. repo)
  if vim.fn.empty(vim.fn.glob(path)) > 0 then
    vim.notify('Installing ' .. repo .. '...')
    vim.fn.system({
      'git',
      'clone',
      '--filter=blob:none',
      '--single-branch',
      '--depth=1',
      string.format('https://github.com/%s/%s.git', user, repo),
      path,
    })
  end
  vim.opt.rtp:append(path)
end

function M.setup()
  vim.loader.enable()
  vim.cmd([[set runtimepath=$VIMRUNTIME]])
  vim.opt.runtimepath:append(M.root())
  vim.env.XDG_CONFIG_HOME = M.root('.local/config')
  vim.env.XDG_DATA_HOME = M.root('.local/data')
  vim.env.XDG_STATE_HOME = M.root('.local/state')
  vim.env.XDG_CACHE_HOME = M.root('.local/cache')

  ensure('nvim-neotest', 'neotest')
  ensure('olimorris', 'neotest-rspec')
  ensure('nvim-lua', 'plenary.nvim')
  ensure('antoinemadec', 'FixCursorHold.nvim')
  ensure('nvim-treesitter', 'nvim-treesitter')

  local configs = require('nvim-treesitter.configs')
  local neotest = require('neotest')
  local neotest_rspec = require('neotest-rspec')

  configs.setup({ ensure_installed = { 'ruby' } })

  neotest.setup({
    adapters = {
      neotest_rspec({
        rspec_cmd = { 'bundle', 'exec', 'rspec' },
      }),
    },
  })

  vim.api.nvim_create_autocmd('BufEnter', {
    pattern = { '*_spec.rb' },
    command = 'Neotest summary',
  })
end

vim.o.swapfile = false
_G.__TEST = true

M.setup()
