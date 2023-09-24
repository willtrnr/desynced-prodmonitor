local ProdMonitor_layout<const> = [[
    <Canvas>
        <Box padding=4 x=4 y=80 dock=top-left>
            <VerticalList child_padding=4>
                <Button
                    id=btn_open
                    width=32
                    height=32
                    icon="ProdMonitor/skin/icon.png"
                    on_click={on_open_click}
                />
            </VerticalList>
        </Box>
    </Canvas>
]]

local ProdMonitor<const> = {}
UI.Register("ProdMonitor", ProdMonitor_layout, ProdMonitor)

function ProdMonitor:construct()
    self.btn_open.tooltip = L("<header>%S</>", "Production Monitor")
    self.prodmonitor_window = nil
end

function ProdMonitor:on_open_click()
    local parent = self

    UI.MenuPopup(
        [[
            <Canvas>
                <Box bg=popup_box_bg padding=4 blur=true>
                    <ProdMonitorPanel />
                </Box>
            </Canvas>
        ]],
        {
            construct = function()
                if parent then
                    parent.prodmonitor_window = self
                    if parent.btn_open:IsValid() then
                        parent.btn_open.active = true
                    end
                end
            end,
            destruct = function()
                if parent then
                    parent.prodmonitor_window = nil
                    if parent.btn_open:IsValid() then
                        parent.btn_open.active = false
                    end
                end
            end
        },
        self.btn_open, "RIGHT", "TOP", 8, -4
    )
end
