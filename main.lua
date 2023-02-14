math = require 'math'
push = require 'push'
Class = require 'class'

require 'Ball'
require 'Pin'

WINDOW_WIDTH = 754.33 + 100 + 100 -- bowling alley length + buffer on each side
WINDOW_HEIGHT = 41.86 + 100 + 100 -- bowling alley width + buffer on each side
VIRTUAL_WIDTH = math.floor(WINDOW_WIDTH / 2)
VIRTUAL_HEIGHT = math.floor(WINDOW_HEIGHT / 2)

local background = love.graphics.newImage('bg.png')

function pin_collisions(i, bpin)
    for k, apin in pairs(pins) do
        if i ~= k then
            bpin:collides(apin)
        end
    end
end

angle = 0
vel = 0
omega = -10
results = {}

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Bowling Simulator')

    smallFont = love.graphics.newFont('font.ttf', 8)
    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)
    love.graphics.setFont(smallFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true,
        vsync = true
    })

    ball = Ball(39, VIRTUAL_HEIGHT / 2 - 1, 3, vel, angle, omega)

    pins = {}
    for i = 1, 10 do
        if i == 1 then
            local pin = Pin(VIRTUAL_WIDTH - 47, VIRTUAL_HEIGHT / 2 - 7)
            table.insert(pins, pin)
        end
        if i == 2 then
            local pin = Pin(VIRTUAL_WIDTH - 47, VIRTUAL_HEIGHT / 2 - 2)
            table.insert(pins, pin)
        end
        if i == 3 then
            local pin = Pin(VIRTUAL_WIDTH - 47, VIRTUAL_HEIGHT / 2 + 4)
            table.insert(pins, pin)
        end
        if i == 4 then
            local pin = Pin(VIRTUAL_WIDTH - 47, VIRTUAL_HEIGHT / 2 + 9)
            table.insert(pins, pin)
        end
        if i == 5 then
            local pin = Pin(VIRTUAL_WIDTH - 52, VIRTUAL_HEIGHT / 2 - 4)
            table.insert(pins, pin)
        end
        if i == 6 then
            local pin = Pin(VIRTUAL_WIDTH - 52, VIRTUAL_HEIGHT / 2 + 1)
            table.insert(pins, pin)
        end
        if i == 7 then 
            local pin = Pin(VIRTUAL_WIDTH - 52, VIRTUAL_HEIGHT / 2 + 6)
            table.insert(pins, pin)
        end
        if i == 8 then
            local pin = Pin(VIRTUAL_WIDTH - 57, VIRTUAL_HEIGHT / 2 - 2)
            table.insert(pins, pin)
        end
        if i == 9 then
            local pin = Pin(VIRTUAL_WIDTH - 57, VIRTUAL_HEIGHT / 2 + 4)
            table.insert(pins, pin)
        end
        if i == 10 then
            local pin = Pin(VIRTUAL_WIDTH - 62, VIRTUAL_HEIGHT / 2 + 1)
            table.insert(pins, pin)
        end
    end

    gameState = 'start'
end

function love.resize(w, h)
    push:resize(w, h)
end

function love.update(dt)
    if gameState == 'simulate' then
        ball:update(dt)
        for k, pin in pairs(pins) do
            pin:collides(ball)
            if pin.collided then
                pin_collisions(k, pin)
            end
            for k, pin in pairs(pins) do
                pin:update(dt)
            end
        end
        if ball.x > VIRTUAL_WIDTH - 10 then
            ball.x = 40
            ball.y = VIRTUAL_HEIGHT / 2
            
            gameState = 'start'
        end
        if ball.y > VIRTUAL_HEIGHT / 2 + 15 or ball.y < VIRTUAL_HEIGHT / 2 - 15 then
            ball.dy = 0
            ball.angle = 0
            ball.dx = ball.velocity
        end
    end

end

function love.keypressed(key)
    if key == 'escape' then
        love.event.quit()
    elseif key == 'enter' or key == 'return' then
        if gameState == 'start' then
            gameState = 'simulate'
        end
    end
end

function love.draw()
    push:apply('start')

    love.graphics.draw(background)
    love.graphics.setFont(smallFont)

    if gameState == 'start' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Press Enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')
    elseif gameState == 'simulate' then
        love.graphics.setFont(smallFont)
        love.graphics.printf('Omega: ' .. ball.omega, 0, 5, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Angle: ' .. math.floor(ball.angle * 10 + 0.5) / 10, 0, 25, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Velocity: ' .. math.floor(ball.velocity * 10 + 0.5) / 10, 0, 15, VIRTUAL_WIDTH, 'center')
    end

    for k, pin in pairs(pins) do
        pin:render()
    end
    
    if ball.x < VIRTUAL_WIDTH - 48 then
        ball:render()
    end

    push:apply('end')
end