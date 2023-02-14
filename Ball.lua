math = require("math")

Ball = Class{}


function Ball:init(x, y, size, vel, angle, omega)
    self.x = x
    self.y = y
    self.velocity = vel
    self.size = size
    self.omega = omega
    self.angle = angle
    self.collided = true

    self.path = {}

    rad_angle = math.rad(angle)
    self.dy = vel * math.sin(rad_angle)
    self.dx = vel * math.cos(rad_angle)
end

--[[
    Places the ball in the middle of the screen, with an initial random velocity
    on both axes.
]]
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
    self.velocity = self.velocity - 0.005
    if self.velocity < 1 then
        self.velocity = 1
    end
    self.angle = self.angle + self.omega * dt
    self.weight = 14
    self.dx = self.velocity * math.cos(math.rad(self.angle))
    self.dy = self.velocity * math.sin(math.rad(self.angle))
    table.insert(self.path, {x = self.x, y = self.y})
end

function Ball:render()
    love.graphics.setColor(1, 0, 0, 0.5)
    for k, point in pairs(self.path) do
        if k % 15 == 0 then
            love.graphics.circle('fill', point.x, point.y, 1)
        end
    end

    love.graphics.setColor(11/255, 159/255, 31/255, 1)
    love.graphics.circle('fill', self.x, self.y, self.size)
    love.graphics.setColor(1, 1, 1, 1)
end