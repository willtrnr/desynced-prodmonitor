local modpack <const> = ...

function modpack:init()
    modpack.utils = require("data.utils")
    modpack.stats = require("data.stats")
end

return modpack
