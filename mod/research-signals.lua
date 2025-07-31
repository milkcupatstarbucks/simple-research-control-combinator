local constants = require("constants")

---@type table<string, boolean>
local signal_name_registry = {}


local function build_signal_name_registry()
    for name, signals in pairs(prototypes.virtual_signal) do
        if signals.subgroup.name == constants.technology_signals_sub_group then
            signal_name_registry[name] = true
        end
    end
end

-- Finds all infinite research technologies in the game
-- should support modded infinite researches
local function retrieve_infinite_researches()
    local researches = {}
    for _, research in pairs(data.raw.technology) do
        if (research.max_level == "infinite") then
            researches[research.name] = research
        end
    end
    return researches
end

---@param technology data.TechnologyPrototype
local function extract_icon_from_technology(technology)
    if technology.icon ~= nil then
        return {
            icon = technology.icon,
            icon_size = technology.icon_size or 64
        }
    end

    if technology.icons ~= nil then
        return {
            icon = technology.icons[1].icon,
            icon_size = technology.icons[1].icon_size or 64
        }
    end

    return {
        icon = "__base__/graphics/icons/signal/signal-science-pack.png",
        icon_size = 64
    }
end

---@param technology data.TechnologyPrototype
local function register_technology_signal(technology)
    local technology_icon = extract_icon_from_technology(technology)
    data:extend({
        {
            type = "virtual-signal",
            name = technology.name,
            icon = technology_icon.icon,
            icon_size = technology_icon.icon_size,
            localised_name = technology.localised_name or technology.name,
            subgroup = constants.technology_signals_sub_group,
            order = "a"
        }
    })
end

local function register_all_technology_signals()
    local infinite_researches = retrieve_infinite_researches()
    for _, technology in pairs(infinite_researches) do
        register_technology_signal(technology)
    end
end

return {
    register_all_technology_signals = register_all_technology_signals,
    signal_name_registry = signal_name_registry,
    build_signal_name_registry = build_signal_name_registry,
}
