local package = ...

local utils = package.data.utils

local ProdMonitorSideBar_layout<const> = [[
    <Canvas>
        <Box padding=4 x=4 y=100 dock=top-left>
            <VerticalList child_padding=4>
                <Button
                    id=btn_open_panel
                    width=32
                    height=32
                    icon="ProdMonitor/skin/Icons/50x50/ProdMonitor.png"
                    on_click={on_open_click}
                />
            </VerticalList>
        </Box>
    </Canvas>
]]

local ProdMonitorSideBar<const> = {}
UI.Register("ProdMonitorSideBar", ProdMonitorSideBar_layout, ProdMonitorSideBar)

function ProdMonitorSideBar:construct()
    self.btn_open_panel.tooltip = L("<header>%S</>", "Production Monitor")
    self.prodmonitor_window = nil
end

function ProdMonitorSideBar:on_open_click(btn)
    local parent = self
    local btn = btn

    local layout
    if btn == self.btn_open_panel then
        layout = [[
            <Canvas>
                <Box bg=popup_box_bg padding=4 blur=true>
                    <ProdMonitorPanel />
                </Box>
            </Canvas>
        ]]
    else
        utils.unreachable()
    end

    UI.MenuPopup(
        layout, {
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
        }, btn, "RIGHT", "TOP", 8, -4
    )
end
