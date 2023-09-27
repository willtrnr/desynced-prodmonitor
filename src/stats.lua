local function get_total_speed_factor(comp)
    local owner = comp.owner
    if not owner then return 1 end

    -- Set by efficiency modules
    local total_boost = owner.component_boost or 100

    if comp.socket_index and comp.def and comp.def.attachment_size and owner.visual_def then
        -- Components installed in larger sockets than they need get a 50% boost
        local comp_socket = owner.visual_def.sockets and owner.visual_def.sockets[comp.socket_index]
        if comp_socket and compare_socket_size(comp.def.attachment_size, comp_socket[2]) < 0 then
            total_boost = total_boost + 50
        end
    end

    return 100 / total_boost
end

function get_logistic_graph(faction, with_orders)
    local res = {}

    local get_item = function(item_id)
        local item = res[item_id]
        if not item then
            local item_def = data.items[item_id]
            if not item_def then
                return nil
            end
            item = {
                item_def = item_def,
                producers = {},
                consumers = {},
                orders = {},
            }
            res[item_id] = item
        end
        return item
    end

    local add_component = function(comp)
        local comp_def = comp.def
        if not comp_def then return end

        local speed_factor = get_total_speed_factor(comp)

        local reg_def = comp_def.registers and comp_def.registers[1]
        if reg_def then
            local reg = comp:GetRegister(1)
            if not reg or reg.is_empty then return end

            if comp_def.id == "c_uplink" then
                -- Special case for Uplink component, there's no special register type for
                -- research apparently.
                local tech_def = data.techs[reg.tech_id]
                if tech_def  then
                    for item_id, amount in pairs(tech_def.uplink_recipe.ingredients) do
                        local item = get_item(item_id)
                        if item then
                            table.insert(item.consumers, {
                                component = comp,
                                amount = amount,
                                ticks = math.ceil(tech_def.uplink_recipe.ticks * speed_factor),
                            })
                        end
                    end
                end
            elseif reg.item_id or reg.raw_entity then
                -- Regular item production
                local item = get_item(reg.item_id or GetResourceHarvestItemId(reg.raw_entity))
                if not item then return end

                -- WARN: It's possible to set an invalid recipe through signals and links,
                -- coherence must be double checked

                if reg_def.type == "miner" and item.item_def.mining_recipe then
                    local ticks = item.item_def.mining_recipe[comp.id]
                    if ticks == nil then return end

                    table.insert(item.producers, {
                        component = comp,
                        amount = 1,
                        ticks = math.ceil(ticks * speed_factor),
                    })
                elseif reg_def.type == "production" and item.item_def.production_recipe then
                    local ticks = item.item_def.production_recipe.producers[comp.id]
                    if ticks == nil then return end

                    ticks = math.ceil(ticks * speed_factor)

                    table.insert(item.producers, {
                        component = comp,
                        amount = item.item_def.production_recipe.amount,
                        ticks = ticks,
                    })

                    for ing_id, amount in pairs(item.item_def.production_recipe.ingredients) do
                        local ing = get_item(ing_id)
                        if ing then
                            table.insert(ing.consumers, {
                                component = comp,
                                amount = amount,
                                product = item.item_def,
                                ticks = ticks,
                            })
                        end
                    end
                end
            end
        elseif comp_def.extracts then
            -- "Passive" extractors don't use registers for production
            local item = get_item(comp_def.extracts)
            if not item then return end

            local ticks = comp_def.extraction_time
            if ticks == nil then return end

            table.insert(item.producers, {
                component = comp,
                amount = 1,
                ticks = math.ceil(ticks * speed_factor),
            })
        end
    end

    for _, comp in ipairs(faction:GetComponents()) do
        add_component(comp)
    end

    if with_orders then
        for _, order in ipairs(faction:GetActiveOrders()) do
            local item = get_item(order.item_id)
            if item then
                table.insert(item.orders, order)
            end
        end
    end

    return res
end

-- Calculate item history increase rate per second
local function calc_history_rate(data, start, step, window_start)
    local ax, ay, bx, by = nil, 0, nil, 0
    for x, y in ipairs(data) do
        local t = start + (x - 1) * step
        if t >= window_start and y > 0 then
            if ax == nil then
                -- Keep the first non-zero data point
                ax = t
                ay = y
            end
            -- Rolling sum for ending point
            bx = t
            by = by + y
        end
    end

    if ax == bx then
        -- No data or only one point
        return 0
    else
        return (by - ay) / (bx - ax) * TICKS_PER_SECOND
    end
end

local WINDOW_LENGTH_SECS<const> = 60
local WINDOW_LENGTH_TICKS<const> = WINDOW_LENGTH_SECS * TICKS_PER_SECOND

function get_item_stats(faction, with_orders)
    local window_start = Map.GetTick() - WINDOW_LENGTH_TICKS

    local graph = get_logistic_graph(faction, with_orders)

    local stats = {}
    for item_id, item in pairs(graph) do
        local history = faction:GetItemHistory(item_id, 1, WINDOW_LENGTH_TICKS)
        local history_start = history.tick - WINDOW_LENGTH_TICKS

        local prod_rate = calc_history_rate(
            history.total_added,
            history_start,
            history.step,
            window_start
        )

        local prod_max = sumby(
            item.producers,
            function(prod)
                return TICKS_PER_SECOND / prod.ticks * prod.amount
            end
        )

        local cons_rate = calc_history_rate(
            history.total_removed,
            history_start,
            history.step,
            window_start
        )

        local cons_max = sumby(
            item.consumers,
            function(cons)
                return TICKS_PER_SECOND / cons.ticks * cons.amount
            end
        )

        local ordered, carried = 0, 0
        for _, order in ipairs(item.orders) do
            ordered = ordered + order.amount
            if order.carry_entity then
                carried = carried + order.amount
            end
        end

        stats[item_id] = {
            item_def = item.item_def,

            window_start = window_start,

            producers = #item.producers,
            production = prod_rate,
            production_max = prod_max,

            consumers = #item.consumers,
            consumption = cons_rate,
            consumption_max = cons_max,

            ordered = ordered,
            carried = carried,
        }
    end
    return stats
end
