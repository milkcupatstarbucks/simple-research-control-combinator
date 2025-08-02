local constants = require("constants")
local research_signals = require("research-signals")

research_signals.register_all_technology_signals()

data:extend({{
  type = "item-subgroup",
  name = constants.technology_signals_sub_group,
  group = "signals",
  order = "t"
}})

local research_controller = table.deepcopy(data.raw["container"]["steel-chest"])
research_controller.name = "research-controller"
research_controller.minable.result = "research-controller"
research_controller.inventory_size = 0
research_controller.dying_explosion = "constant-combinator-explosion"
research_controller.corpse = "constant-combinator-remnants"
research_controller.icon = "__Simple_Research_Control_Combinator__/entity-research-controller.png"
research_controller.circuit_connector.points = table.deepcopy(data.raw["constant-combinator"]["constant-combinator"].circuit_wire_connection_points[1])
research_controller.circuit_connector.sprites = nil
research_controller.picture = {
  layers = {
    {
      scale = 0.5,
      filename = "__Simple_Research_Control_Combinator__/entity-research-controller.png",
      width = 114,
      height = 102,
      shift = util.by_pixel(0, 5)
    },
    {
      scale = 0.5,
      filename = "__base__/graphics/entity/combinator/constant-combinator-shadow.png",
      width = 98,
      height = 66,
      shift = util.by_pixel(8.5, 5.5),
      draw_as_shadow = true
    }
  }
}


data:extend({research_controller})

data:extend({{
  type = "item",
  name = "research-controller",
  icon = "__Simple_Research_Control_Combinator__/icon-research-controller.png",
  icon_size = 64,
  subgroup = "circuit-network",
  place_result = "research-controller",
  stack_size = 1,
  weight = 1000000
}})

data:extend({{
  type = "recipe",
  name = "research-controller",
  enabled = true,
  energy_required = 120,
  ingredients = {
    {type = "item", name = "quantum-processor", amount = 420},
    {type = "item", name = "raw-fish", amount = 69},
    {type = "item", name = "biolab", amount = 10}
  },
  results = {{type = "item", name = "research-controller", amount = 1}}
}})
