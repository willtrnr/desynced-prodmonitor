local package = ...

package.includes = {
    "ProdMonitorPanel.lua",
    "ProdMonitorRow.lua",
    "ProdMonitorSideBar.lua",
}

package.data = Game.GetModPackage(package.mod_id .. "/Data")

function package:init_ui()
end

function UIMsg.OnSetup()
    UI.AddLayout("ProdMonitorSideBar")
end
