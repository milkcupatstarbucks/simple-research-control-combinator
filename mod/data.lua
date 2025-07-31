-- require("prototypes.entity")
-- require("prototypes.item")
-- require("prototypes.recipe")
-- require("prototypes.technology")
local constants = require("constants")
local research_signals = require("research-signals")

data:extend({{
    type = "item-subgroup",
    name = constants.technology_signals_sub_group,
    group = "signals",
    order = "t"
}})

-- register all technology signals
research_signals.register_all_technology_signals()