local package = ...

local function unreachable()
    error("unreachable")
end

local function make_item_filter(search)
    local search = string.lower(search or "")
    return function(item_def)
        return
            not search or (item_def and string.find(string.lower(L(item_def.name or "")), search))
    end
end

local SOCKET_SIZES<const> = {
    Internal = 1,
    Small = 2,
    Medium = 3,
    Large = 4,
}

local function compare_socket_size(socket_a, socket_b)
    local a, b = SOCKET_SIZES[socket_a], SOCKET_SIZES[socket_b]

    if a > b then
        return 1
    end
    if a < b then
        return -1
    end

    return 0
end

local SUFFIXES<const> = {
    "k",
    "M",
    "G",
}

local function numformat(value, precision)
    if value == nil then
        return nil
    end

    if precision == nil then
        return tostring(value)
    else
        local suffix = ""
        for _, s in ipairs(SUFFIXES) do
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
        if m >= p then
            m = m - p
        end

        if m == 0 then
            return string.format("%d%s", i, suffix)
        else
            return string.format("%d.%d%s", i, m, suffix)
        end
    end
end

local function fold(data, fn, zero)
    local res = zero
    for _, item in ipairs(data) do
        res = fn(res, item)
    end
    return res
end

local function sumby(data, fn)
    return fold(
        data, function(a, b)
            return a + fn(b)
        end, 0
    )
end

package.utils = {
    unreachable = unreachable,
    make_item_filter = make_item_filter,
    compare_socket_size = compare_socket_size,
    numformat = numformat,
    fold = fold,
    sumby = sumby,
}
