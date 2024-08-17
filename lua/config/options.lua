local fn, uv = vim.fn, vim.uv

local ini_path = fn.stdpath("config") .. "/options.ini"


local function section_to_value(str)
    local value = getfenv(1)

    for path in str:gmatch("([^%.]+)") do
        value = value[path]
    end

    return value
end

vim.options_keymap = {}

local section_callbacks = {
    handler = function(self, section, key, value)
        if section == nil or key == nil then
            return
        end

	    if section == "keymap" then
	    	vim.options_keymap[key] = value
	    	return
	    end

        local callback = self[section]
	    value = fn.luaeval(value)

        if callback == nil and section:match("%.") then
            section_to_value(section)[key] = value
            return
        end

        callback(key, value)
    end,
    options = function(key, value)
        vim.opt[key] = value
    end,
    global = function(key, value)
        vim.g[key] = value
    end
}

if uv.fs_stat(ini_path) then
	local current_section = "options"
	for _, line in next, fn.readfile(ini_path) do
	    local section = line:match("^%[([%w%.]+)%]")
	    if section then
	        current_section = section:lower()
	        goto continue
	    end

        section_callbacks:handler(current_section, line:match("^([%w<>_-]+)%s?=%s?(.+)"))
	    ::continue::
	end
end

vim.keymap.set("n", vim.options_keymap.quit or "q", function() vim.api.nvim_command("q") end, { noremap = true })
