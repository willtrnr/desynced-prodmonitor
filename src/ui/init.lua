local modpack <const> = ...

local Desynced <const> = require("desynced")

function modpack:init_ui()
    modpack.ProdMonitorSideBar = require("ui.ProdMonitorSideBar")
end

function Desynced.UIMsg.OnSetup()
    Desynced.UI.AddLayout(modpack.ProdMonitorSideBar)
end

return modpack
