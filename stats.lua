local TICKS_PER_MINUTE<const> = TICKS_PER_SECOND * 60

function get_logistic_data(faction)
    local res = {}

    local get_item = function(item_id)
        local item = res[item_id]
        if not item then
            local item_def = data.items[item_id]
            if not item_def then return nil end
            item = {
                item_def = item_def,
                producers = {},
                consumers = {},
            }
            res[item_id] = item
        end
        return item
    end

    for _, comp in ipairs(faction:GetComponents()) do
        local comp_def = comp.def
        local reg_def = comp_def and comp.def.registers and comp.def.registers[1]
        if reg_def then
            local reg = comp:GetRegister(1)
            if reg and not reg.is_empty then
                local item = get_item(reg.item_id)
                if item then
                    if reg_def.type == "miner" then
                        table.insert(item.producers, {
                            component = comp,
                            amount = 1,
                            ticks = item.item_def.mining_recipe[comp.id],
                        })
                    elseif reg_def.type == "production" then
                        local ticks = item.item_def.production_recipe.producers[comp.id]
                        table.insert(item.producers, {
                            component = comp,
                            amount = item.item_def.production_recipe.amount,
                            ticks = ticks,
                        })
                        for ingredient_id, amount in pairs(item.item_def.production_recipe.ingredients) do
                            local ingredient = get_item(ingredient_id)
                            if ingredient then
                                table.insert(ingredient.consumers, {
                                    component = comp,
                                    amount = amount,
                                    ticks = ticks,
                                })
                            end
                        end
                    end
                end
            end
        elseif comp_def.extracts then
            local item = get_item(comp_def.extracts)
            if item then
                table.insert(item.producers, {
                    component = comp,
                    amount = 1,
                    ticks = comp_def.extraction_time,
                })
            end
        end
    end

    return res
end

function get_item_stats(faction)
    local logistics = get_logistic_data(faction)

    local window_start = Map.GetTick() - TICKS_PER_MINUTE

    local stats = {}
    for item_id, _ in pairs(faction.all_items) do
        local item = logistics[item_id]
        if item then
            local history = faction:GetItemHistory(item_id, 1, TICKS_PER_MINUTE)
            local history_start = history.tick - TICKS_PER_MINUTE

            local prod_rate = 0
            for i, n in ipairs(history.total_added) do
                if history_start + ((i - 1) * history.step) >= window_start then
                    prod_rate = prod_rate + (n / TICKS_PER_MINUTE)
                end
            end

            local prod_max = 0
            for _, prod in ipairs(item.producers) do
                prod_max = prod_max + (TICKS_PER_SECOND / prod.ticks * prod.amount)
            end

            local cons_rate = 0
            for i, n in ipairs(history.total_removed) do
                if history_start + ((i - 1) * history.step) >= window_start then
                    cons_rate = cons_rate + (n / TICKS_PER_MINUTE)
                end
            end

            local cons_max = 0
            for _, cons in ipairs(item.consumers) do
                cons_max = cons_max + (TICKS_PER_SECOND / cons.ticks * cons.amount)
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
            }
        end
    end
    return stats
end
