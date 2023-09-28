local package = ...

ProdMonitor = package

package.includes = {
    "utils.lua",
    "stats.lua",
    "ProdMonitorPanel.lua",
    "ProdMonitorRow.lua",
    "ProdMonitorSideBar.lua",
}

function package:init_ui()
end

function UIMsg.OnSetup()
    UI.AddLayout("ProdMonitorSideBar")
end
