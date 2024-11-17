local fn = vim.fn
local config_path = fn.stdpath("config") .. "/lua/config"
local config_scripts = vim.split(vim.fn.glob(config_path .. "/*"), '\n', {trimempty=true})

for _, script in next, config_scripts do
    local script_name = string.match(script, "/([%w]+)%.lua$")
    if not script_name then
        goto continue
    end

    require("config." .. script_name) 

    ::continue:: 
end
