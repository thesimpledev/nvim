
local dap = require('dap')

dap.adapters.go = {
  type = 'server',
  port = '${port}',
  executable = { command = 'dlv', args = { 'dap', '-l', '127.0.0.1:${port}' } },
}

dap.configurations.go = {
  { type = 'go', name = 'Debug file', request = 'launch', program = '${file}' },
  { type = 'go', name = 'Debug test (pkg)', request = 'launch', mode = 'test', program = '${fileDirname}' },
  { type = 'go', name = 'Debug package', request = 'launch', program = '${fileDirname}' },
}

dap.adapters['pwa-node'] = {
  type = 'server',
  host = '127.0.0.1',
  port = '${port}',
  executable = {
    command = 'node',
    args = { vim.fn.stdpath('data') .. '/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js', '${port}' },
  },
}

dap.configurations.javascript = {
  { type = 'pwa-node', request = 'launch', name = 'Launch file', program = '${file}', cwd = '${workspaceFolder}' },
}

dap.configurations.typescript = {
  { type = 'pwa-node', request = 'launch', name = 'Launch TS (built)', program = '${file}', cwd = '${workspaceFolder}', outFiles = { '${workspaceFolder}/dist/**/*.js' } },
}

vim.keymap.set('n', '<F5>', dap.continue, { desc = 'Debug Continue' })
vim.keymap.set('n', '<leader>dc', dap.continue,  { desc = 'Debug Continue' })
vim.keymap.set('n', '<leader>do', dap.step_over, { desc = 'Debug Step Over' })
vim.keymap.set('n', '<leader>di', dap.step_into, { desc = 'Debug Step Into' })
vim.keymap.set('n', '<leader>du', dap.step_out,  { desc = 'Debug Step Out' })
vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = 'Toggle Breakpoint' })
vim.keymap.set('n', '<leader>dB', function() dap.set_breakpoint(vim.fn.input('Breakpoint condition: ')) end, { desc = 'Conditional Breakpoint' })
vim.keymap.set('n', '<leader>dr', dap.repl.open, { desc = 'Debug REPL' })
vim.keymap.set('n', '<leader>dl', dap.run_last,  { desc = 'Run Last' })
vim.keymap.set('n', '<leader>dt', dap.terminate, { desc = 'Terminate' })

vim.fn.sign_define('DapBreakpoint', { text = '●', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapBreakpointCondition', { text = '◆', texthl = '', linehl = '', numhl = '' })
vim.fn.sign_define('DapStopped', { text = '▶', texthl = '', linehl = '', numhl = '' })

local dapui = require('dapui')
dapui.setup()
dap.listeners.after.event_initialized['dapui'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui'] = function() dapui.close() end
vim.keymap.set('n', '<leader>dU', function() dapui.toggle() end, { desc = 'DAP UI' })
