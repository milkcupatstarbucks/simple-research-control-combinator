-- Debug flag: set to true to enable debug logging
local constants = require("constants")
local research_signals = require("research-signals")

research_signals.register_all_technology_signals()

local function log_debug(message)
    if constants.debug then
        game.print("[DEBUG] " .. message)
    end
end

local function initialize()
    -- script.on_nth_tick(constants.process_tick_rate, do_something_cool)
end


script.on_init(initialize)
script.on_load(initialize)