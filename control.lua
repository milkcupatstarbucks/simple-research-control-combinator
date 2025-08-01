local research_signals = require("research-signals")

function update_research(e)
    entity = storage.research_controllers
    if entity == nil then
        return
    end
    if not entity.valid then
        storage.research_controllers = nil
        script.on_nth_tick(60, nil)
        return
    end
    signals = entity.get_signals(defines.wire_connector_id.circuit_red, defines.wire_connector_id.circuit_green)
    if signals == nil then
        return
    end
    local max = 0
    local max_tech_name = nil
    for _, signal in pairs(signals) do
        if research_signals.signal_name_registry[signal.signal.name] then
            if signal.count > max then
                max = signal.count
                max_tech_name = signal.signal.name
            end
        end
    end
    if max_tech_name then
        if entity.force.current_research and entity.force.current_research.name ~= max_tech_name then
            entity.force.research_queue = nil
        end
        if entity.force.current_research == nil then
            entity.force.add_research(max_tech_name)
            game.print("Set research to " .. max_tech_name)
        end
    end
end

function create_entity(e)
    local entity = e.entity
    if not entity.valid or entity.name ~= "research-controller" then
        return
    end
    if storage.research_controllers == nil then
        storage.research_controllers = entity
        script.on_nth_tick(60, update_research)
    else
        entity.surface.create_entity{
            name = "explosion",
            position = entity.position
        }
        entity.destroy()
    end
end

function destroy_entity(e)
    local entity = e.entity
    if not entity.valid or entity.name ~= "research-controller" then
        return
    end
    if storage.research_controllers == entity.unit_number then
        storage.research_controllers = nil
        script.on_nth_tick(60, nil)
    end
end    

script.on_event(defines.events.on_built_entity, create_entity)
script.on_event(defines.events.on_entity_cloned, create_entity)
script.on_event(defines.events.on_robot_built_entity, create_entity)
script.on_event(defines.events.on_space_platform_built_entity, create_entity)
script.on_event(defines.events.script_raised_built, create_entity)
script.on_event(defines.events.on_entity_died, destroy_entity)
script.on_event(defines.events.on_player_mined_entity, destroy_entity)
script.on_event(defines.events.on_robot_mined_entity, destroy_entity)
script.on_event(defines.events.on_space_platform_mined_entity, destroy_entity)
script.on_event(defines.events.script_raised_destroy, destroy_entity)
script.on_event(defines.events.on_research_finished, update_research)

script.on_init(function()
    research_signals.build_signal_name_registry()
    storage.research_controllers = nil
end)

script.on_load(function()
    research_signals.build_signal_name_registry()
    if storage.research_controllers then
        script.on_nth_tick(60, update_research)
    end
end)
