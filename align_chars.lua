-- align_chars.lua

local M = {}

-- Function to align lines by a specified character or sequence within a given range
function M.align_lines_by_char(sequence, start_line, end_line)
    -- Get the current buffer lines within the specified range
    local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)
    local max_index = 0

    -- Find the maximum index of the start of the sequence within the range
    for i, line in ipairs(lines) do
        local index = line:find(sequence, 1, true) -- Use plain search
        if index and index > max_index then
            max_index = index
        end
    end

    -- Add spaces before the sequence in each line within the range
    for i, line in ipairs(lines) do
        local index = line:find(sequence, 1, true) -- Use plain search
        if index then
            local spaces = string.rep(" ", max_index - index)
            lines[i] = line:sub(1, index - 1) .. spaces .. line:sub(index)
        end
    end

    -- Set the modified lines back to the buffer within the range
    vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, lines)
end

-- Setup function to create the AlignByChar command
function M.setup()
    vim.api.nvim_create_user_command(
        'AlignByChar',
        function(opts)
            -- Use the range if provided, or operate on the entire buffer
            local start_line = opts.line1
            local end_line = opts.line2
            M.align_lines_by_char(opts.args, start_line, end_line)
        end,
        {
            nargs = 1,
            range = true,
            desc  = 'Align lines by a specified character or sequence within a range'
        }
    )
end

return M