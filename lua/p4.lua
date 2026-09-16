local M = {}

local ns = vim.api.nvim_create_namespace("p4_signs")
local base_cache = {}
local hunks_cache = {}

local function setup_highlights()
	vim.api.nvim_set_hl(0, "P4SignsAdd", { fg = "#a6e3a1", default = true })
	vim.api.nvim_set_hl(0, "P4SignsChange", { fg = "#89b4fa", default = true })
	vim.api.nvim_set_hl(0, "P4SignsDelete", { fg = "#f38ba8", default = true })
end

local function get_real_path(bufnr)
	local name = vim.api.nvim_buf_get_name(bufnr or 0)
	if name == "" then
		return nil
	end
	return vim.uv.fs_realpath(name) or name
end

local function update_signs(bufnr)
	if not vim.api.nvim_buf_is_valid(bufnr) then
		return
	end

	local base = base_cache[bufnr]
	if not base then
		vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)
		hunks_cache[bufnr] = {}
		return
	end

	local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
	local cur = table.concat(lines, "\n")
	if #lines > 0 then
		cur = cur .. "\n"
	end

	local diffs = vim.diff(base, cur, { result_type = "indices" })
	vim.api.nvim_buf_clear_namespace(bufnr, ns, 0, -1)

	local hunks = {}
	if not diffs then
		hunks_cache[bufnr] = hunks
		return
	end

	for _, d in ipairs(diffs) do
		local a_start, a_count, b_start, b_count = d[1], d[2], d[3], d[4]
		table.insert(hunks, {
			start = b_start,
			count = b_count,
			a_start = a_start,
			a_count = a_count,
		})

		if a_count == 0 and b_count > 0 then
			for l = b_start, b_start + b_count - 1 do
				if l <= #lines then
					pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, l - 1, 0, {
						sign_text = "▎",
						sign_hl_group = "P4SignsAdd",
						priority = 10,
					})
				end
			end
		elseif a_count > 0 and b_count > 0 then
			for l = b_start, b_start + b_count - 1 do
				if l <= #lines then
					pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, l - 1, 0, {
						sign_text = "▎",
						sign_hl_group = "P4SignsChange",
						priority = 10,
					})
				end
			end
		elseif a_count > 0 and b_count == 0 then
			local l = math.max(1, math.min(b_start, #lines))
			pcall(vim.api.nvim_buf_set_extmark, bufnr, ns, l - 1, 0, {
				sign_text = "▔",
				sign_hl_group = "P4SignsDelete",
				priority = 10,
			})
		end
	end

	hunks_cache[bufnr] = hunks
end

function M.refresh(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	local rp = get_real_path(bufnr)
	if not rp or vim.fn.filereadable(rp) ~= 1 then
		return
	end

	vim.system({ "p4", "print", "-q", rp .. "#have" }, { text = true }, function(proc)
		vim.schedule(function()
			if not vim.api.nvim_buf_is_valid(bufnr) then
				return
			end
			if proc.code == 0 then
				base_cache[bufnr] = proc.stdout
				update_signs(bufnr)
			else
				base_cache[bufnr] = nil
				update_signs(bufnr)
			end
		end)
	end)
end

function M.on_text_changed(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if base_cache[bufnr] then
		update_signs(bufnr)
	end
end

function M.next_hunk()
	local bufnr = vim.api.nvim_get_current_buf()
	local hunks = hunks_cache[bufnr] or {}
	if #hunks == 0 then
		vim.notify("No P4 hunks in current buffer", vim.log.levels.INFO)
		return
	end

	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	for _, h in ipairs(hunks) do
		local target = math.max(1, h.start)
		if target > cur_line then
			vim.api.nvim_win_set_cursor(0, { target, 0 })
			return
		end
	end
	local first_target = math.max(1, hunks[1].start)
	vim.api.nvim_win_set_cursor(0, { first_target, 0 })
end

function M.prev_hunk()
	local bufnr = vim.api.nvim_get_current_buf()
	local hunks = hunks_cache[bufnr] or {}
	if #hunks == 0 then
		vim.notify("No P4 hunks in current buffer", vim.log.levels.INFO)
		return
	end

	local cur_line = vim.api.nvim_win_get_cursor(0)[1]
	for i = #hunks, 1, -1 do
		local target = math.max(1, hunks[i].start)
		if target < cur_line then
			vim.api.nvim_win_set_cursor(0, { target, 0 })
			return
		end
	end
	local last_target = math.max(1, hunks[#hunks].start)
	vim.api.nvim_win_set_cursor(0, { last_target, 0 })
end

function M.preview_diff()
	local bufnr = vim.api.nvim_get_current_buf()
	local rp = get_real_path(bufnr)
	if not rp then
		return
	end

	vim.system({ "p4", "diff", "-du", rp }, { text = true }, function(proc)
		vim.schedule(function()
			if proc.code ~= 0 or not proc.stdout or proc.stdout == "" then
				vim.notify("No P4 diff for " .. vim.fn.fnamemodify(rp, ":t"), vim.log.levels.INFO)
				return
			end

			local lines = vim.split(proc.stdout, "\n", { trimempty = false })
			local buf = vim.api.nvim_create_buf(false, true)
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
			vim.bo[buf].filetype = "diff"
			vim.bo[buf].bufhidden = "wipe"
			vim.bo[buf].modifiable = false

			local width = math.min(120, math.floor(vim.o.columns * 0.85))
			local height = math.min(#lines + 2, math.floor(vim.o.lines * 0.75))
			local row = math.floor((vim.o.lines - height) / 2)
			local col = math.floor((vim.o.columns - width) / 2)

			local win = vim.api.nvim_open_win(buf, true, {
				relative = "editor",
				width = width,
				height = height,
				row = row,
				col = col,
				style = "minimal",
				border = "rounded",
				title = " P4 Diff: " .. vim.fn.fnamemodify(rp, ":t") .. " ",
				title_pos = "center",
			})

			vim.keymap.set("n", "q", function()
				pcall(vim.api.nvim_win_close, win, true)
			end, { buffer = buf, nowait = true })
			vim.keymap.set("n", "<Esc>", function()
				pcall(vim.api.nvim_win_close, win, true)
			end, { buffer = buf, nowait = true })
		end)
	end)
end

function M.opened_files()
	vim.system({ "p4", "-ztag", "opened" }, { text = true }, function(proc)
		vim.schedule(function()
			if proc.code ~= 0 or not proc.stdout or proc.stdout == "" then
				vim.notify("No files opened in P4 workspace", vim.log.levels.INFO)
				return
			end

			local items = {}
			local cur_item = {}
			local depot_files = {}
			for line in proc.stdout:gmatch("[^\r\n]+") do
				local k, v = line:match("^%.%.%.%s*(%w+)%s+(.*)$")
				if k and v then
					cur_item[k] = v
				elseif line == "" and cur_item.depotFile then
					table.insert(items, cur_item)
					table.insert(depot_files, cur_item.depotFile)
					cur_item = {}
				end
			end
			if cur_item.depotFile then
				table.insert(items, cur_item)
				table.insert(depot_files, cur_item.depotFile)
			end

			if #items == 0 then
				vim.notify("No files opened in P4", vim.log.levels.INFO)
				return
			end

			local where_cmd = { "p4", "-ztag", "where" }
			for _, df in ipairs(depot_files) do
				table.insert(where_cmd, df)
			end

			vim.system(where_cmd, { text = true }, function(where_proc)
				vim.schedule(function()
					local local_paths = {}
					if where_proc.code == 0 and where_proc.stdout then
						for p in where_proc.stdout:gmatch("%.%.%.%s*path%s+([^\r\n]+)") do
							table.insert(local_paths, p)
						end
					end

					local cwd = vim.fn.getcwd()
					local real_cwd = vim.uv.fs_realpath(cwd)

					local display_list = {}
					local target_paths = {}

					for i, it in ipairs(items) do
						local raw_path = local_paths[i] or it.clientFile or it.depotFile
						local final_path = raw_path

						if real_cwd and raw_path:sub(1, #real_cwd):lower() == real_cwd:lower() then
							final_path = cwd .. raw_path:sub(#real_cwd + 1)
						end

						local fname = final_path:match("([^/\\]+)$") or final_path
						local fdir = final_path:match("^(.-)[/\\][^/\\]+$") or ""
						local label
						if fdir ~= "" then
							label = string.format("%s  [%s #%s]  (%s)", fname, it.action or "edit", it.change or "default", fdir)
						else
							label = string.format("%s  [%s #%s]", fname, it.action or "edit", it.change or "default")
						end

						table.insert(display_list, label)
						table.insert(target_paths, final_path)
					end

					vim.ui.select(display_list, {
						prompt = "P4 Opened Files:",
					}, function(choice, idx)
						if choice and idx and target_paths[idx] then
							vim.cmd("edit " .. vim.fn.fnameescape(target_paths[idx]))
						end
					end)
				end)
			end)
		end)
	end)
end

function M.edit_file()
	local rp = get_real_path(0)
	if not rp then
		return
	end
	vim.system({ "p4", "edit", rp }, { text = true }, function(proc)
		vim.schedule(function()
			if proc.code == 0 then
				vim.notify("P4 edit success: " .. vim.fn.fnamemodify(rp, ":t"), vim.log.levels.INFO)
				vim.cmd("checktime")
				M.refresh()
			else
				vim.notify("P4 edit failed: " .. (proc.stderr or proc.stdout), vim.log.levels.ERROR)
			end
		end)
	end)
end

function M.setup()
	setup_highlights()

	local grp = vim.api.nvim_create_augroup("P4SignsAuto", { clear = true })
	vim.api.nvim_create_autocmd({ "BufReadPost", "BufWritePost" }, {
		group = grp,
		callback = function(ev)
			M.refresh(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
		group = grp,
		callback = function(ev)
			M.on_text_changed(ev.buf)
		end,
	})

	vim.api.nvim_create_autocmd("ColorScheme", {
		group = grp,
		callback = setup_highlights,
	})

	vim.api.nvim_create_user_command("P4Diff", M.preview_diff, { desc = "Preview P4 Diff" })
	vim.api.nvim_create_user_command("P4Opened", M.opened_files, { desc = "Show P4 Opened Files" })
	vim.api.nvim_create_user_command("P4Edit", M.edit_file, { desc = "Run p4 edit on current file" })
	vim.api.nvim_create_user_command("P4Refresh", function() M.refresh() end, { desc = "Refresh P4 Signs" })
end

return M
