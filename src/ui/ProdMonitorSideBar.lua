local Desynced <const> = require("desynced")

local ProdMonitorPanel <const> = require("ui.ProdMonitorPanel")

local ProdMonitorSideBar_layout <const> = [[
    <Canvas>
        <Box padding=2 dock=top-left margin_left=104 margin_top=36>
            <Button id=btn_open_panel width=24 height=24 icon="ProdMonitor/skin/Icons/50x50/ProdMonitor.png" on_click={on_open_click} />
        </Box>
    </Canvas>
]]

local ProdMonitorSideBar <const> = {}
Desynced.UI.Register("ProdMonitorSideBar", ProdMonitorSideBar_layout, ProdMonitorSideBar)

function ProdMonitorSideBar:construct()
    self.btn_open_panel.tooltip = Desynced.L("<header>%S</>", "Production Monitor")
    self.prodmonitor_window = nil
end

local ProdMonitorPopup_layout <const> = [[
    <Canvas>
        <Box bg=popup_box_bg padding=4 blur=true>
            <]] .. ProdMonitorPanel .. [[ />
        </Box>
    </Canvas>
]]

function ProdMonitorSideBar:on_open_click(btn)
    local parent <const> = self

    local layout = nil
    if btn == self.btn_open_panel then
        layout = ProdMonitorPopup_layout
    else
        error("unreachable")
    end

    Desynced.UI.MenuPopup(layout, {
        construct = function()
            if parent then
                parent.prodmonitor_window = self
                if btn:IsValid() then
                    btn.active = true
                end
            end
        end,
        destruct = function()
            if parent then
                parent.prodmonitor_window = nil
                if btn:IsValid() then
                    btn.active = false
                end
            end
        end,
    }, btn, "DOWN", "TOP", -2, 6)
end

return "ProdMonitorSideBar"
