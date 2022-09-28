function Cal_var()
    WIDTH_OF_WINDOW = love.graphics.getWidth()
    HEIGHT_OF_WINDOW = love.graphics.getHeight()

    TOP_SPEED = HEIGHT_OF_WINDOW * 1.5
    LOWEST_SPEED = HEIGHT_OF_WINDOW * 0.7
    NUM_OF_RAIN_DROPS = (WIDTH_OF_WINDOW + HEIGHT_OF_WINDOW) * 1.5
end

function love.load()

    RAIN_WIDTH = 3
    RAIN_HEIGHT = 16

    Cal_var()

    RAIN_DROPS = {}
    Rain = {
        x = 0,
        y = 0,
        width = 0,
        height = 0,
        opacity = 0,
        speed = 0
    }

    function Rain:new(o, x, speed, opacity)
        o = o or {}
        setmetatable(o, self)
        self.__index = self
        self.x = x or 1
        self.y = 1

        self.width = RAIN_WIDTH
        self.height = RAIN_HEIGHT

        self.opacity = opacity or 1
        self.speed = speed or 100

        return o
    end

    for _ = 1, NUM_OF_RAIN_DROPS do
        local r = Rain:new { x = math.random(WIDTH_OF_WINDOW), speed = math.random(LOWEST_SPEED, TOP_SPEED),
            opacity = math.random() }
        table.insert(RAIN_DROPS, r)
    end
    SOUND = love.audio.newSource("rain-07.wav", "stream") -- the "stream" tells LÖVE to stream the file from disk, good for longer music tracks
    SOUND:play()
    love.graphics.setBackgroundColor(230, 230, 250)
    R = {}
end

function love.resize()
    Cal_var()
end

function love.keypressed(key)
    if key == 'q' then
        love.event.quit(0)
    end
end

function love.update(dt)
    for i = 1, #RAIN_DROPS do
        local r = RAIN_DROPS[i]
        if r == nil then love.event.quit(0) else
            if r.y < HEIGHT_OF_WINDOW then
                r.y = r.y + (r.speed * dt)
            else
                r.y = 0
                r.x = math.random(WIDTH_OF_WINDOW)
                r.opacity = math.random()
                r.speed = math.random(LOWEST_SPEED, TOP_SPEED) * r.opacity
                r.width = RAIN_WIDTH * r.opacity
                r.heigth = RAIN_HEIGHT * r.opacity
            end
        end
    end
    if not SOUND:isPlaying() then
        SOUND:play()
    end
end

function love.draw()
    --love.graphics.rectangle('fill', 40, 0, 2, 15)
    for i = 1, NUM_OF_RAIN_DROPS do
        R = RAIN_DROPS[i]
        if R ~= nil then
            love.graphics.setColor(128 / 255, 43 / 255, 226 / 255, R.opacity)
            love.graphics.rectangle('fill', R.x, R.y, R.width, R.height)
        end
    end
end
