local ITEM_TAGS<const> = {
    "resource",
    "simple_material",
    "advanced_material",
    "hitech_material",
    "research",
    "package",
    "other",
}

local VIEW_ITEMS<const> = 1

local ProdMonitorPanel_layout<const> = [[
    <Box bg=popup_pattern padding=4 width=510 min_height=600 max_height=600>
        <VerticalList child_padding=4>
            <TextSearch on_refresh={update} />
            <HorizontalList child_fill=true child_padding=4 hidden=true>
                <Button id=btn_view_items text="Items" on_click={select_items_view} />
            </HorizontalList>
            <ScrollList id=content fill=true child_padding=4 />
        </VerticalList>
    </Box>
]]

local ProdMonitorPanel<const> = {}
UI.Register("ProdMonitorPanel", ProdMonitorPanel_layout, ProdMonitorPanel)

function ProdMonitorPanel:construct()
    self:select_items_view()
end

function ProdMonitorPanel:update(_view, search)
    if search ~= nil then
        self.search = search
    end

    -- Refresh only once per second or when search changed
    if search or Map.GetTick() % TICKS_PER_SECOND == 0 then
        self:render()
    end
end

function ProdMonitorPanel:select_items_view()
    self.selected_view = VIEW_ITEMS
    self.btn_view_items.active = true
end

function ProdMonitorPanel:render()
    if self.selected_view == VIEW_ITEMS then
        self:render_item_stats()
    else
        unreachable()
    end
end

function ProdMonitorPanel:render_item_stats()
    local stats = get_item_stats(Game.GetLocalPlayerFaction(), true)

    self.content:Clear()

    local tags = {}
    for _, tag in ipairs(ITEM_TAGS) do
        tags[tag] = self.content:Add("VerticalList", { child_padding = 4 })
    end

    local get_list = function(item_def)
        return (item_def and item_def.tag and tags[item_def.tag]) or tags["other"]
    end

    local filter_pred = make_item_filter(self.search)

    for item_id, item_stats in pairs(stats) do
        local list = get_list(item_stats.item_def)
        if list and filter_pred(item_stats.item_def) then
            -- TODO Add toggle for per-second instead of per-minute... maybe?
            list:Add("ProdMonitorRow", {
                item_def = item_stats.item_def,

                producers = item_stats.producers,
                production = item_stats.production * 60,
                production_max = item_stats.production_max * 60,

                consumers = item_stats.consumers,
                consumption = item_stats.consumption * 60,
                consumption_max = item_stats.consumption_max * 60,

                ordered = item_stats.ordered,
                carried = item_stats.carried,
            })
        end
    end
end
