local package = ...

package.includes = {
    "ProdMonitorPanel.lua",
    "ProdMonitorRow.lua",
    "ProdMonitorSideBar.lua",
}

package.data = Game.GetModPackage("ProdMonitor/Data")

function package:init_ui()
end

function UIMsg.OnSetup()
    UI.AddLayout("ProdMonitorSideBar")
end
