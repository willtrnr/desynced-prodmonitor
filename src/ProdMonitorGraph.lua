local ProdMonitorItemNode_layout<const> = [[
    <VerticalList child_align=center width=70 height=70>
        <Image image={item_icon} width=38 height=38 />
        <Text text={item_name} textalign=center wrap=true size=8 />
    </VerticalList>
]]

local ProdMonitorItemNode<const> = {}
UI.Register("ProdMonitorItemNode", ProdMonitorItemNode_layout, ProdMonitorItemNode)

function ProdMonitorItemNode:construct()
    if not self.item_def then
        self.item_def = data.items[self.item_id]
    else
        self.item_id = self.item_def.id
    end

    if self.item_def then
        self.item_icon = self.item_def.texture
        self.item_name = self.item_def.name
    end
end

local ProdMonitorGraph_layout<const> = [[
    <Box bg=popup_pattern padding=4 width=800 height=600>
        <PanView id=pan_view zoom=1>
            <Canvas id=graph />
            <Draw id=draw />
        </PanView>
    </Box>
]]

local ProdMonitorGraph<const> = {}
UI.Register("ProdMonitorGraph", ProdMonitorGraph_layout, ProdMonitorGraph)

function ProdMonitorGraph:construct()
end

function ProdMonitorGraph:render()

end
