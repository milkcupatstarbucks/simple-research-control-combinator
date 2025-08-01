local research_signals = require("research-signals")

function update_research(e)
    if storage.research_controllers == nil then
        return
    end
    for id, entity in pairs(storage.research_controllers) do
        if entity == nil then
            goto continue
        end
        if not entity.valid then
            goto continue
        end
        local behavior = entity.get_or_create_control_behavior()
        if behavior == nil then
            goto continue
        end
        local signals_red = behavior.get_circuit_network(defines.wire_connector_id.circuit_red)
        local signals_green = behavior.get_circuit_network(defines.wire_connector_id.circuit_green)
        local max = 0
        local max_tech_name = nil
        for tech, _ in pairs(research_signals.signal_name_registry) do
            local sig = 0
            if signals_red then
                sig = sig + signals_red.get_signal({type="virtual", name=tech})
            end
            if signals_green then
                sig = sig + signals_green.get_signal({type="virtual", name=tech})
            end
            if sig > max then
                max = sig
                max_tech_name = tech
            end
        end
        if max_tech_name then
            local did_something = false
            while entity.force.current_research and entity.force.current_research.name ~= max_tech_name do
                entity.force.cancel_current_research()
                did_something = true
            end
            if entity.force.current_research == nil then
                entity.force.add_research(max_tech_name)
                did_something = true
            end
            if did_something then
                game.print("Set research to " .. max_tech_name)
            end
        end
        ::continue::
    end
end

function create_entity(e)
    local entity = e.entity
    if not entity.valid or entity.name ~= "research-controller" then
        return
    end
    if storage.research_controllers == nil then
        storage.research_controllers = {[entity.unit_number] = entity}
    else
        storage.research_controllers[entity.unit_number] = entity
    end
    script.on_nth_tick(60, update_research)
end

function destroy_entity(e)
    local entity = e.entity
    if not entity.valid or entity.name ~= "research-controller" then
        return
    end
    storage.research_controllers[entity.unit_number] = nil
    if table_size(storage.research_controllers) == 0 then
        storage.research_controllers = nil
        script.on_nth_tick(60, nil)
    end
    local checker = entity.surface.find_entity("research-controller", entity.position)
    if checker then
        checker.destroy({raise_destroy = true})
    end
end    

script.on_event(defines.events.on_built_entity, create_entity)
script.on_event(defines.events.on_entity_cloned, create_entity)
script.on_event(defines.events.on_robot_built_entity, create_entity)
script.on_event(defines.events.on_space_platform_built_entity, create_entity)
script.on_event(defines.events.on_entity_died, destroy_entity)
script.on_event(defines.events.on_player_mined_entity, destroy_entity)
script.on_event(defines.events.on_robot_mined_entity, destroy_entity)
script.on_event(defines.events.on_space_platform_mined_entity, destroy_entity)
script.on_event(defines.events.on_research_finished, update_research)

script.on_init(function()
    research_signals.build_signal_name_registry()
end)

script.on_load(function()
    research_signals.build_signal_name_registry()
    if storage.research_controllers then
        script.on_nth_tick(60, update_research)
    end
end)
