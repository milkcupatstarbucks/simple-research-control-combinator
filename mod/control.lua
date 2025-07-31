-- Debug flag: set to true to enable debug logging
local constants = require("constants")
local research_signals = require("research-signals")

local function log_debug(message)
    if constants.debug then
        game.print("[DEBUG] " .. message)
    end
end

local function control()
    -- print all research signals in registry
    log_debug("Registered research signals:")

    for signal_name in pairs(research_signals.signal_name_registry) do
        log_debug(signal_name)
    end
end

local function initialize()
    research_signals.build_signal_name_registry()
    script.on_nth_tick(300, control)
end


script.on_init(initialize)
script.on_load(initialize)