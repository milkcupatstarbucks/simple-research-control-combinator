require("prototypes.entity")
require("prototypes.item")
require("prototypes.recipe")
require("prototypes.technology")
local constants = require("constants")

data:extend({{
    type = "item-subgroup",
    name = constants.technology_signals_sub_group,
    group = "signals",
    order = "t"
}})