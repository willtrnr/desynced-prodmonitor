local item_tags<const> = {
    "resource",
    "simple_material",
    "advanced_material",
    "hitech_material",
    "research",
    "package",
    "other",
}

local ProdMonitorPanel_layout<const> = [[
    <Box bg=popup_pattern padding=4 width=435 min_height=600 max_height=600>
        <VerticalList child_padding=4>
            <TextSearch on_refresh={update} />
            <ScrollList id=item_list fill=true child_padding=3 />
        </VerticalList>
    </Box>
]]

local ProdMonitorPanel<const> = {}
UI.Register("ProdMonitorPanel", ProdMonitorPanel_layout, ProdMonitorPanel)

function ProdMonitorPanel:construct()
    self.tag_lists = {}
    for _, tag in ipairs(item_tags) do
        self.tag_lists[tag] = self.item_list:Add("VerticalList", { child_padding = 3 })
    end

    self:refresh()
end

function ProdMonitorPanel:update(_view, search)
    if search ~= nil then
        self.search = search
    end

    -- Refresh only once per second or when search changed
    if search or Map.GetTick() % TICKS_PER_SECOND == 0 then
        self:refresh()
    end
end

function ProdMonitorPanel:refresh()
    local stats = get_item_stats(Game.GetLocalPlayerFaction())

    local item_filter = make_item_filter(self.search)

    for _, tag in ipairs(item_tags) do
        self.tag_lists[tag]:Clear()
    end

    local get_list = function(item_def)
        return (item_def and item_def.tag and self.tag_lists[item_def.tag]) or self.tag_lists["other"]
    end

    for _, item_stats in pairs(stats) do
        local list = get_list(item_stats.item_def)
        if list and item_filter(item_stats.item_def) then
            -- TODO Add toggle for per-second instead of per-minute... maybe
            list:Add("ProdMonitorRow", {
                item_def = item_stats.item_def,

                producers = item_stats.producers,
                production = item_stats.production * 60,
                production_max = item_stats.production_max * 60,

                consumers = item_stats.consumers,
                consumption = item_stats.consumption * 60,
                consumption_max = item_stats.consumption_max * 60,
            })
        end
    end
end
