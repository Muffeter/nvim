local Comment = require("Comment")
Comment.setup()

local api = require("Comment.api")

local c_style_filetypes = {
	c = true,
	cpp = true,
	cs = true,
	c_sharp = true,
	csharp = true,
	rust = true,
	java = true,
	javascript = true,
	typescript = true,
	javascriptreact = true,
	typescriptreact = true,
	css = true,
	scss = true,
	less = true,
	go = true,
	php = true,
	solidity = true,
	cuda = true,
	dart = true,
	kotlin = true,
	swift = true,
	scala = true,
}

local function is_c_style(ft)
	return c_style_filetypes[ft] or false
end

local function find_enclosing_c_block(buf, line_nr)
	local total = vim.api.nvim_buf_line_count(buf)
	local cur_line = vim.api.nvim_buf_get_lines(buf, line_nr - 1, line_nr, false)[1] or ""

	if cur_line:match("^%s*/%*%s*$") then
		for i = line_nr + 1, math.min(line_nr + 2000, total) do
			local l = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if l:match("^%s*%*/%s*$") then
				return line_nr, i
			end
		end
	end

	if cur_line:match("^%s*%*/%s*$") then
		for i = line_nr - 1, math.max(1, line_nr - 2000), -1 do
			local l = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if l:match("^%s*/%*%s*$") then
				return i, line_nr
			end
		end
	end

	if cur_line:match("^%s*%*%s") or cur_line:match("^%s*%*$") then
		local start_l, end_l = nil, nil
		for i = line_nr - 1, math.max(1, line_nr - 2000), -1 do
			local l = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if l:match("^%s*/%*%s*$") then
				start_l = i
				break
			elseif not (l:match("^%s*%*") or l:match("^%s*$")) then
				break
			end
		end
		for i = line_nr + 1, math.min(line_nr + 2000, total) do
			local l = vim.api.nvim_buf_get_lines(buf, i - 1, i, false)[1]
			if l:match("^%s*%*/%s*$") then
				end_l = i
				break
			elseif not (l:match("^%s*%*") or l:match("^%s*$")) then
				break
			end
		end
		if start_l and end_l then
			return start_l, end_l
		end
	end

	return nil, nil
end

local function toggle_c_multiline(buf, start_line, end_line)
	local total = vim.api.nvim_buf_line_count(buf)
	local lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
	if #lines == 0 then
		return
	end

	-- Check if range itself is already a block comment
	local is_commented = #lines >= 2 and lines[1]:match("^%s*/%*%s*$") and lines[#lines]:match("^%s*%*/%s*$")
	if not is_commented and #lines == 1 and lines[1]:match("^%s*/%*.*%*/%s*$") then
		is_commented = true
	end

	-- Check if selection is inside an enclosing block comment
	if not is_commented then
		local s, e = find_enclosing_c_block(buf, start_line)
		if s and e and s <= start_line and e >= end_line then
			start_line = s
			end_line = e
			lines = vim.api.nvim_buf_get_lines(buf, start_line - 1, end_line, false)
			is_commented = true
		end
	end

	if is_commented then
		if #lines == 1 then
			local indent = lines[1]:match("^(%s*)") or ""
			local content = lines[1]:gsub("^%s*/%*%s?", ""):gsub("%s?%*/%s*$", "")
			vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, { indent .. content })
			return
		end
		local indent = lines[1]:match("^(%s*)") or ""
		table.remove(lines, #lines)
		table.remove(lines, 1)
		for i, l in ipairs(lines) do
			lines[i] = l:gsub("^" .. vim.pesc(indent) .. "%s*%*%s?", indent)
		end
		vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, lines)
	else
		local min_indent = nil
		for _, l in ipairs(lines) do
			if l:match("%S") then
				local ind = l:match("^(%s*)")
				if not min_indent or #ind < #min_indent then
					min_indent = ind
				end
			end
		end
		min_indent = min_indent or (lines[1]:match("^(%s*)") or "")

		local new_lines = { min_indent .. "/*" }
		for _, l in ipairs(lines) do
			if l:match("%S") then
				local stripped = l:gsub("^" .. vim.pesc(min_indent), "")
				table.insert(new_lines, min_indent .. " * " .. stripped)
			else
				table.insert(new_lines, min_indent .. " *")
			end
		end
		table.insert(new_lines, min_indent .. " */")
		vim.api.nvim_buf_set_lines(buf, start_line - 1, end_line, false, new_lines)
	end
end

-- Keymap overrides for gb in visual and normal mode
vim.keymap.set("x", "gb", function()
	local ft = vim.bo.filetype
	if not is_c_style(ft) then
		local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
		vim.api.nvim_feedkeys(esc, "nx", false)
		api.toggle.blockwise(vim.fn.visualmode())
		return
	end

	local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
	vim.api.nvim_feedkeys(esc, "nx", false)
	local s = vim.fn.line("'<")
	local e = vim.fn.line("'>")
	if s > e then
		s, e = e, s
	end
	toggle_c_multiline(0, s, e)
end, { desc = "Toggle multiline block comment (/* * */)" })

vim.keymap.set("n", "gbc", function()
	local ft = vim.bo.filetype
	if not is_c_style(ft) then
		api.toggle.blockwise.current()
		return
	end

	local cur = vim.fn.line(".")
	local s, e = find_enclosing_c_block(0, cur)
	if s and e then
		toggle_c_multiline(0, s, e)
	else
		toggle_c_multiline(0, cur, cur)
	end
end, { desc = "Toggle multiline block comment on current line or block" })
