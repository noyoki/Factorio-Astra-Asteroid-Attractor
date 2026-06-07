


local script_run_frequency_ticks = 1000
local balance_multiplier = 1
local spawn_distance_above_platform_highest = 50

script.on_nth_tick(script_run_frequency_ticks, function(event)
    for _, platform in pairs(game.space_platforms) do
        if (platform.valid) then
        --if platform is stationary it has a specific location (otherwise it would have a route)
            if (platform.space_location) then 
                if (platform.surface) then
                    local surface = platform.surface
                    local count = surface.count_entities_filtered{name = "astra-asteroid-attractor"}
                    -- we only care if they have the beacon.
                    -- technicallly.....  we dont care if the beacon is actually powered,
                    -- but if its not, then they won't have power to collect the asteroids.
                    if (count > 0) then
                        local location = platform.space_location
                        local asteroiddefs = location.prototype.asteroid_spawn_definitions
                        local size = Get_platform_size(surface)
                        Fling_asteroids(surface,  asteroiddefs, count, size )
                    end
                end
            end
        end
    end
end)


function Get_platform_size(surface) 
    --this entire thing feels super inefficient....
    --but Im not sure how to otherwise handle platforms that may be massive.
    local tiles = surface.find_tiles_filtered{name="space-platform-foundation"}

    local min
    local max
    local Y

    for _, t in pairs(tiles) do
        local pos = t.position
        if (pos.x < min) then min = pos.x end
        if (pos.x > max) then max = pos.x end
        if (pos.y > Y) then Y = pos.y end
    end
    --return {minX, maxX, minY, maxY}

    --since we're generally just tossing from the north/top side, the length/Y doesnt super matter
    return {min, max, Y}
end


function Fling_asteroids(surface, spawndefs, numbeacons, size)
    local chunks
    local entities
    for _, definition in pairs(spawndefs) do
        --probability is "chance" per tick - so we multiply  that and basically give that many asteroids at once
        local asteroid_probability = definition.probability * script_run_frequency_ticks * balance_multiplier * numbeacons
        local integer = math.floor(asteroid_probability)
        local decimal = asteroid_probability % 1
        local random = math.random()
        -- integer is now the number of asteroids to spawn 
        if (decimal > random) then integer = integer+1 end

        if (integer > 0) then
            
            local asteroid_type = definition.type
            local asteroid_speed = definition.speed
            local asteroid_angle = definition.angle_when_stopped
            local asteroid_entity_name = definition.asteroid.name
            

            if (asteroid_type == "entity") then       
                local rocks = Generate_entities(integer, size, asteroid_speed, asteroid_angle, asteroid_entity_name)
                table.insert(entities, rocks)
                else  
                local rocks = Generate_chunks(integer, size, asteroid_speed, asteroid_angle, asteroid_entity_name)
                table.insert(chunks, rocks)                
            end
        end
    end

    if (next(chunks) ~= nil) then
        surface.create_asteroid_chunks(chunks)
    elseif (next(entities) ~= nil)  then
        surface.create_entities(entities)
    end
end

function Generate_chunks(count,size, speed, angle, name)
    local rocks
    for i = 1, count do
        local location = math.random (size.min, size.max)
        -- a full angle "1" means very wide spawn region, but we're still limiting it to northern side.
        location = location * angle * 1.2
        location = math.floor(location)
        local position = {location,size.Y+spawn_distance_above_platform_highest}
        --vector - going to give half of the speed to X, and allow full negative or positive.   some asteroids might be wasted, I guess?
        local angle = math.random(speed*-.5, speed*.5)
        local vector = {angle, speed*.5}
        
        local rock = {name = name, position = position , vector = vector}
        table.insert(rocks, rock)
    end
    return rocks
end

function Generate_entities(count,size, speed, angle, name)
    local rocks
    for i = 1, count do
        local location = math.random (size.min, size.max)
        -- a full angle "1" means very wide spawn region, but we're still limiting it to northern side.
        location = location * angle * 1.2
        location = math.floor(location)
        local position = {location,size.Y+spawn_distance_above_platform_highest}

        --angle - figure out how far to one side or the other it is, and then ratio it to point more centralll-ish
        local max = size.max
        local min = size.min 
        local range = max-min
        local currX = location-min
        --this is a decimal value of % of total range from 0 to 1
        local ratio = currX / range 
        ratio = ratio / 2.7 
        --final score of .3 to .67 where .5 is straight down  //.25 or .75 would be straight to the side with no chance of grabbing
        local orientation = .3 + ratio 

        local rock = {name = name, position = position , force = "neutral", speed = speed, orientation = orientation }
        table.insert(rocks, rock)
    end
    return rocks
end
