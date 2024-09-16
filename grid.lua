d = 15
coordinates = {}

local taken = function(x, y)
    for i = 1, #coordinates do
        local a, b = table.unpack(coordinates[i])
        if a == x and b == y then
            return true
        end
    end
    return false
end

local in_bounds = function(x, y)
    return x <= d and x > 0 and y <= d and y > 0
end

local too_central = function(x, y)
    return math.abs(x - (d + 1 - x)) < 3 and math.abs(y - (d + 1 - y)) < 3
end

local unavailable = function (x, y)
    return  taken(x, y) or not in_bounds(x, y)
end

local forbidden = function(x, y)
    local east = {unavailable(x + 1, y), unavailable(x + 2, y), unavailable(x + 3, y)}
    local north = {unavailable(x, y + 1), unavailable(x, y + 2), unavailable(x, y + 3)}
    local west = {unavailable(x - 1, y), unavailable(x - 2, y), unavailable(x - 3, y)}
    local south = {unavailable(x, y - 1), unavailable(x, y - 2), unavailable(x, y - 3)}

    if (east[1] or east[2] or east[3]) and (west[1] or west[2] or west[3]) then
        return true
    end
    if (north[1] or north[2] or north[3]) and (south[1] or south[2] or south[3]) then
        return true
    end

    if not east[1] and (east[2] or east[3]) then
        return true
    end
    if not north[1] and (north[2] or north[3]) then
        return true
    end
    if not west[1] and (west[2] or west[3]) then
        return true
    end
    if not south[1] and (south[2] or south[3]) then
        return true
    end

    return false
end

function black_coordinates(dimension)
    d = dimension

    for i = 1, d * d / 12 do
        local x, y = math.random(d),  math.random(d)
        while taken(x, y) or forbidden(x, y) or forbidden(d + 1 - x, d + 1 - y) or too_central(x, y) do
            x, y = math.random(d), math.random(d)
        end
        table.insert(coordinates, {x, y})
        table.insert(coordinates, {d + 1 - x, d + 1 - y})
    end

    local str_coordinates = ""
    for i = 1, #coordinates do
        local x, y = table.unpack(coordinates[i])
        str_coordinates = str_coordinates .. x .. "/" .. y .. ", "
    end
    str_coordinates = string.sub(str_coordinates, 1, -3)

    tex.sprint(str_coordinates)
end
