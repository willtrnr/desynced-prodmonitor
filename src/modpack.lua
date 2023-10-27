local modname<const>, _ = ...

local Desynced<const> = require("desynced")

local pack<const>, path<const> = string.match(modname, "^([^%.]+)(%.?.*)$")
if pack == nil or path == nil then
   return nil
end

local mod = Desynced.Game.GetModPackage("ProdMonitor/" .. string.upper(string.sub(pack, 1, 1)) .. string.sub(pack, 2))
for k in string.gmatch(path, "%.([^%.]+)") do
   mod = mod[k]
   if mod == nil then
      return nil
   end
end

return mod
