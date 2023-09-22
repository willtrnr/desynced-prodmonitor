local package = ...

package.includes = {
    "ProdMonitor.lua",
    "ProdMonitorPanel.lua",
    "ProdMonitorRow.lua",
    "stats.lua",
    "utils.lua",
}

function UIMsg.OnSetup()
    UI.AddLayout("ProdMonitor")
end

function package:init_ui()
end
