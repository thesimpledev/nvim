local M = {}

-- State to track running jobs
local test_jobs = {}

-- Parse go test output and extract failures
local function parse_test_output(output)
    local diagnostics = {}
    local current_test = nil
    
    for _, line in ipairs(output) do
        -- Match test failure lines: "--- FAIL: TestName"
        local test_name = line:match("^%-%-%- FAIL: (%S+)")
        if test_name then
            current_test = test_name
        end
        
        -- Match file:line references in test output and build errors
        -- Format: file.go:line:col: message OR file.go:line: message
        local file, line_num, col_num, msg = line:match("^([^:]+):(%d+):(%d+): (.+)$")
        if not file then
            file, line_num, msg = line:match("^([^:]+):(%d+): (.+)$")
            col_num = "0"
        end
        
        if file and line_num then
            -- Only process if it's a .go file (ignore package lines)
            if file:match("%.go$") then
                table.insert(diagnostics, {
                    file = file,
                    lnum = tonumber(line_num) - 1, -- 0-indexed
                    col = tonumber(col_num) or 0,
                    message = (current_test and "[" .. current_test .. "] " or "") .. msg,
                    severity = vim.diagnostic.severity.ERROR,
                    source = "go test",
                })
            end
        end
    end
    
    return diagnostics
end

-- Run tests for the current file
function M.run_tests_for_file()
    local file = vim.fn.expand("%:p")
    
    -- Only run for Go files
    if not file:match("%.go$") then
        return
    end
    
    local dir = vim.fn.expand("%:p:h")
    
    -- Cancel any existing job for this file
    if test_jobs[file] then
        vim.fn.jobstop(test_jobs[file])
    end
    
    -- Clear existing diagnostics
    local namespace = vim.api.nvim_create_namespace("go_test")
    vim.diagnostic.reset(namespace)
    
    local output = {}
    -- Test the entire package directory instead of individual files
    local test_cmd = {"go", "test", "-v", "."}
    
    -- Start the test job
    test_jobs[file] = vim.fn.jobstart(test_cmd, {
        cwd = dir,
        stdout_buffered = true,
        stderr_buffered = true,
        
        on_stdout = function(_, data)
            if data then
                vim.list_extend(output, data)
            end
        end,
        
        on_stderr = function(_, data)
            if data then
                vim.list_extend(output, data)
            end
        end,
        
        on_exit = function(_, exit_code)
            test_jobs[file] = nil
            
            if exit_code == 0 then
                -- Tests passed
                vim.notify("✓ Tests passed", vim.log.levels.INFO)
            else
                -- Tests failed or build failed - parse and show diagnostics
                local diagnostics = parse_test_output(output)
                
                if #diagnostics > 0 then
                    -- Apply diagnostics to the relevant files
                    local by_file = {}
                    for _, diag in ipairs(diagnostics) do
                        -- Resolve to absolute path
                        local fname = diag.file
                        if not fname:match("^/") then
                            fname = dir .. "/" .. fname
                        end
                        
                        if not by_file[fname] then
                            by_file[fname] = {}
                        end
                        table.insert(by_file[fname], diag)
                    end
                    
                    for fname, diags in pairs(by_file) do
                        local bufnr = vim.fn.bufnr(fname, false)
                        if bufnr == -1 then
                            -- Buffer not loaded, try to find it by name
                            bufnr = vim.fn.bufnr(vim.fn.fnamemodify(fname, ":t"), false)
                        end
                        if bufnr ~= -1 then
                            vim.diagnostic.set(namespace, bufnr, diags, {})
                        end
                    end
                    
                    -- Check if it's a build failure
                    local full_output = table.concat(output, "\n")
                    if full_output:match("build failed") then
                        vim.notify(
                            string.format("✗ Build failed (%d error%s)", 
                                #diagnostics, 
                                #diagnostics > 1 and "s" or ""),
                            vim.log.levels.ERROR
                        )
                    else
                        vim.notify(
                            string.format("✗ Tests failed (%d error%s)", 
                                #diagnostics, 
                                #diagnostics > 1 and "s" or ""),
                            vim.log.levels.ERROR
                        )
                    end
                else
                    -- Failed but couldn't parse - show raw output summary
                    local full_output = table.concat(output, "\n")
                    if full_output:match("%[no test files%]") then
                        vim.notify("⚠ No test files in package", vim.log.levels.WARN)
                    else
                        local summary = full_output:match("FAIL%s+[^\n]+") or "Tests failed"
                        vim.notify("✗ " .. summary, vim.log.levels.ERROR)
                    end
                end
            end
        end,
    })
end

return M
