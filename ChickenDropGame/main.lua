
function love.load()
    chickenFace = love.graphics.newImage("Squirrel.png")
    backgroundImage = love.graphics.newImage("ForestBG.JPG")
    powerupImage = love.graphics.newImage("SlowFallPower.png")

    math.randomseed(os.time())

    animalScale = 0.3
    powerupScale = 0.25

    startx = {}
    starty = {}

    for i = 1, 5 do
        startx[i] = math.random(0, love.graphics.getWidth() - 100)
        starty[i] = -math.random(100, 300)
    end

    -- powerup position
    powerupX = math.random(0, love.graphics.getWidth() - 100)
    powerupY = -200

    slowTimer = 0
end

-------------------------------------------------
-- MOUSE PRESS
-------------------------------------------------
function love.mousepressed(x, y, button)
    if button == 1 then

        -- CLICK ANIMALS
        for i = 1, #startx do
            local w = chickenFace:getWidth() * animalScale
            local h = chickenFace:getHeight() * animalScale

            if x >= startx[i] and x <= startx[i] + w and
               y >= starty[i] and y <= starty[i] + h then

                starty[i] = -math.random(100, 300)
                startx[i] = math.random(0, love.graphics.getWidth() - w)
            end
        end

        -- CLICK POWERUP
        local pw = powerupImage:getWidth() * powerupScale
        local ph = powerupImage:getHeight() * powerupScale

        if x >= powerupX and x <= powerupX + pw and
           y >= powerupY and y <= powerupY + ph then

            slowTimer = 5 -- seconds of slow motion

            -- reset powerup
            powerupY = -math.random(200, 400)
            powerupX = math.random(0, love.graphics.getWidth() - pw)
        end
    end
end

-------------------------------------------------
-- UPDATE
-------------------------------------------------
function love.update(dt)

    -- NORMAL SPEED
    local speed = 80

    -- SLOW EFFECT ACTIVE
    if slowTimer > 0 then
        speed = 40
        slowTimer = slowTimer - dt
    end

    -- MOVE ANIMALS
    for i = 1, #starty do
        local h = chickenFace:getHeight() * animalScale

        if starty[i] + h >= love.graphics.getHeight() then
            love.event.quit()
        end

        starty[i] = starty[i] + speed * dt
    end

    -- MOVE POWERUP
    powerupY = powerupY + 60 * dt

    if powerupY > love.graphics.getHeight() then
        powerupY = -math.random(200, 400)
        powerupX = math.random(0, love.graphics.getWidth() - 100)
    end
end

-------------------------------------------------
-- DRAW
-------------------------------------------------
function love.draw()

    -- BACKGROUND SCALE
    local screenW = love.graphics.getWidth()
    local screenH = love.graphics.getHeight()

    local bgW = backgroundImage:getWidth()
    local bgH = backgroundImage:getHeight()

    local scaleX = screenW / bgW
    local scaleY = screenH / bgH

    love.graphics.draw(backgroundImage, 0, 0, 0, scaleX, scaleY)

    -- DRAW ANIMALS
    for i = 1, #startx do
        love.graphics.draw(chickenFace, startx[i], starty[i], 0, animalScale, animalScale)
    end

    -- DRAW POWERUP
    love.graphics.draw(powerupImage, powerupX, powerupY, 0, powerupScale, powerupScale)

    -- SHOW STATUS
    if slowTimer > 0 then
        love.graphics.print("SLOW MODE!", 10, 40)
    end
end