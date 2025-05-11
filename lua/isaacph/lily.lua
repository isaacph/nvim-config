local buffer_number = -1
local file_name = ""

local function log(_, data)
    if data then
        local new_data = {}
        for _, line in ipairs(data) do
            local new_line = string.gsub(line, "\r", "")
            if string.len(new_line) > 0 then
                table.insert(new_data, new_line)
            end
        end
        data = new_data

        -- Make it temporarily writable so we don't have warnings.
        vim.api.nvim_buf_set_option(buffer_number, "readonly", false)

        -- Append the data.
        vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)

        -- Make readonly again.
        vim.api.nvim_buf_set_option(buffer_number, "readonly", true)

        -- Mark as not modified, otherwise you'll get an error when
        -- attempting to exit vim.
        vim.api.nvim_buf_set_option(buffer_number, "modified", false)

        -- -- Get the window the buffer is in and set the cursor position to the bottom.
        -- local buffer_window = vim.api.nvim_call_function("bufwinid", { buffer_number })
        -- local buffer_line_count = vim.api.nvim_buf_line_count(buffer_number)
        -- vim.api.nvim_win_set_cursor(buffer_window, { buffer_line_count, 0 })
    end
end

local function on_exit(_, exit_code)
    if exit_code ~= 0 then
        -- Get the window the buffer is in and set the cursor position to the bottom.
        local buffer_window = vim.api.nvim_call_function("bufwinid", { buffer_number })
        if buffer_window == -1 then
            vim.api.nvim_command("botright vsplit AUTOTEST_OUTPUT")
            buffer_number = vim.api.nvim_get_current_buf()
            vim.opt_local.readonly = true
        end

        -- Focus and scroll
        local buffer_line_count = vim.api.nvim_buf_line_count(buffer_number)
        vim.api.nvim_win_set_cursor(buffer_window, { buffer_line_count, 0 })
        vim.api.nvim_command("wincmd " .. buffer_window .. " w")
    else
        print("Compilation succeeded")
        local to_pdf_ext = file_name
        local i, _ = string.find(to_pdf_ext, "%.ly")
        to_pdf_ext = string.sub(to_pdf_ext, 1, i) .. "pdf"
        vim.fn.system("texworks " .. to_pdf_ext)
    end
end

local function open_buffer()
    -- Get a boolean that tells us if the buffer number is visible anymore.
    --
    -- :help bufwinnr
    local buffer_visible = vim.api.nvim_call_function("bufwinnr", { buffer_number }) ~= -1

    if buffer_number == -1 or not buffer_visible then
        -- Create a new buffer with the name "AUTOTEST_OUTPUT".
        -- Same name will reuse the current buffer.
        vim.api.nvim_command("botright vsplit AUTOTEST_OUTPUT")

        -- Collect the buffer's number.
        buffer_number = vim.api.nvim_get_current_buf()

        -- Mark the buffer as readonly.
        vim.opt_local.readonly = true
    end
end

vim.api.nvim_create_autocmd("BufWritePost", {
    pattern = "*.ly",
    callback = function(ev)
        -- Open our buffer, if we need to.
        open_buffer()

        -- Clear the buffer's contents incase it has been used.
        vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, {})

        -- Run the command.
        vim.fn.jobstart({"lilypond", ev.file}, {
            stdout_buffered = true,
            on_stdout = log,
            on_stderr = log,
            on_exit = on_exit,
        })
        file_name = ev.match

        -- Close it
        local buffer_window = vim.api.nvim_call_function("bufwinid", { buffer_number })
        vim.api.nvim_command("wincmd " .. buffer_window .. " q")
    end
})

vim.api.nvim_command("filetype off")
vim.api.nvim_command("set runtimepath+=C:\\workplace\\lilypond\\share\\lilypond\\2.24.3\\vim")
vim.api.nvim_command("filetype on")
vim.api.nvim_command("syntax on")

