local Desynced <const> = require("desynced")

local OpenMainWindow <const> = Desynced.OpenMainWindow

local numformat <const> = require("data").utils.numformat

local ProdMonitorCell_layout <const> = [[
   <VerticalList width={width} height={height} child_align={child_align}>
      <Text text={label} size=8 color=light_gray />
      <HorizontalList child_align=bottom>
         <Text text={value_str} size=14 color={value_color} />
         <Text text={unit} size=8 margin=2 color=light_gray />
      </HorizontalList>
   </VerticalList>
]]

local ProdMonitorCell <const> = {}
Desynced.UI.Register("ProdMonitorCell", ProdMonitorCell_layout, ProdMonitorCell)

function ProdMonitorCell:construct()
    self.value_str = numformat(self.value, self.precision)
    self.value_color = self.value_color
end

local ProdMonitorRow_layout <const> = [[
   <Box bg=popup_additional_bg padding=8>
      <HorizontalList child_align=center>
         <VerticalList child_align=center margin_right=6 fill=true on_click={on_item_click}>
            <Image image={item_icon} width=38 height=38 />
            <Text text={item_name} textalign=center wrap=true size=8 />
         </VerticalList>
         <VerticalList child_padding=6 padding=4>
            <HorizontalList>
               <ProdMonitorCell
                  label="Producers"
                  value={producers}
                  value_color=ui_light
                  child_align=right
                  width=65
               />
               <ProdMonitorCell
                  id=prod_cell
                  label="Production rate"
                  value={production}
                  value_color=ui_light
                  unit="/min"
                  precision=1
                  child_align=right
                  width=110
               />
               <ProdMonitorCell
                  id=prod_max_cell
                  label="Theoretical max"
                  value={production_max}
                  value_color=ui_light
                  unit="/min"
                  precision=1
                  child_align=right
                  width=110
               />
               <ProdMonitorCell
                  id=carried_cell
                  label="In transit"
                  value={carried}
                  value_color=ui_light
                  child_align=right
                  width=80
               />
            </HorizontalList>
            <Image height=1 color=dark_gray />
            <HorizontalList>
               <ProdMonitorCell
                  label="Consumers"
                  value={consumers}
                  value_color=ui_light
                  child_align=right
                  width=65
               />
               <ProdMonitorCell
                  id=cons_cell
                  label="Consumption rate"
                  value={consumption}
                  value_color=ui_light
                  unit="/min"
                  precision=1
                  child_align=right
                  width=110
               />
               <ProdMonitorCell
                  id=cons_max_cell
                  label="Theoretical max"
                  value={consumption_max}
                  value_color=ui_light
                  unit="/min"
                  precision=1
                  child_align=right
                  width=110
               />
               <ProdMonitorCell
                  id=ordered_cell
                  label="Ordered"
                  value={ordered}
                  value_color=ui_light
                  child_align=right
                  width=80
               />
            </HorizontalList>
         </VerticalList>
      </HorizontalList>
   </Box>
]]

local ProdMonitorRow <const> = {}
Desynced.UI.Register("ProdMonitorRow", ProdMonitorRow_layout, ProdMonitorRow)

function ProdMonitorRow:construct()
    if not self.item_def then
        self.item_def = Desynced.data.items[self.item_id]
    else
        self.item_id = self.item_def.id
    end

    if self.item_def then
        self.item_icon = self.item_def.texture
        self.item_name = self.item_def.name
    end

    if self.consumption > self.production_max then
        self.cons_cell.value_color = "red"
        self.prod_max_cell.value_color = "red"
    end

    if self.consumption_max > self.production_max then
        self.cons_max_cell.value_color = "yellow"
    end

    if self.ordered > self.carried then
        self.ordered_cell.value_color = "yellow"
    end
end

function ProdMonitorRow:on_item_click()
    OpenMainWindow("Faction", {
        show_item_id = self.item_id,
    })
end

return "ProdMonitorRow"
