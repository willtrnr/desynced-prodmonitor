local modname<const>, _ = ...

return require("desynced").Game.GetModPackage(
   "ProdMonitor/" .. string.upper(string.sub(modname, 1, 1)) .. string.sub(modname, 2)
)
