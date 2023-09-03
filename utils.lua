function make_item_filter(search)
    local search = string.lower(search or "")
    return function(item_def)
        return not search or (item_def and string.find(string.lower(L(item_def.name or "")), search))
    end
end

local suffixes = {"k", "M", "G"}

function numformat(value, precision)
    if value == nil then return nil end

    if precision == nil then
        return tostring(value)
    else
        local suffix = ""
        for _, s in ipairs(suffixes) do
            if value >= 1000 then
                suffix = s
                value = value / 1000
            else
                break
            end
        end

        local p = 10 ^ precision

        local i = math.floor(value)
        local m = math.floor(((value % 1) * p) + 0.5)

        -- float precision error compensation
        if m >= p then m = m - p end

        if m == 0 then
            return string.format("%d%s", i, suffix)
        else
            return string.format("%d.%d%s", i, m, suffix)
        end
    end
end
