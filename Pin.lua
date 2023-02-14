Pin = Class{}

function Pin:init(x, y)
    self.x = x
    self.y = y
    self.dx = 0
    self.dy = 0
    self.size = 2
    self.weight = 3
    self.collided = false
end

function Pin:render()
    if self.collided then
        love.graphics.setColor(0.5, 0.5, 0.5, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end
    if self.x < 430 and self.y < 200 and self.y > 50 then
        love.graphics.circle('fill', self.x, self.y, self.size)
    end
end

function Pin:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

function Pin:collides(ball)
    -- Calculate the distance between the center of the ball and the center of the pin
    local distX = ball.x - self.x
    local distY = ball.y - self.y

    -- If the distance is less than the sum of the radii of the ball and the pin, they are colliding
    if math.sqrt(distX^2 + distY^2) < self.size + ball.size then
        self.collided = true
        ball.collided = true
        -- Calculate the normal and tangent components of the velocity of each object
        local normalX = distX / (self.size + ball.size)
        local normalY = distY / (self.size + ball.size)
        local tangentX = -normalY
        local tangentY = normalX
        local ballNormalVelocity = ball.dx * normalX + ball.dy * normalY
        local pinNormalVelocity = self.dx * normalX + self.dy * normalY

        -- Calculate the new normal velocities of each object
        local ballNewNormalVelocity = (ballNormalVelocity * (ball.weight - self.weight) + 2 * self.weight * pinNormalVelocity) / (ball.weight + self.weight)
        local pinNewNormalVelocity = (pinNormalVelocity * (self.weight - ball.weight) + 2 * ball.weight * ballNormalVelocity) / (ball.weight + self.weight)

        -- Update the velocities of each object
        ball.dx = tangentX * (ball.dx * tangentX + ball.dy * tangentY) + normalX * ballNewNormalVelocity
        ball.dy = tangentY * (ball.dx * tangentX + ball.dy * tangentY) + normalY * ballNewNormalVelocity
        self.dx = 1.5 * tangentX * (self.dx * tangentX + self.dy * tangentY) + normalX * pinNewNormalVelocity
        self.dy = 1.5 *tangentY * (self.dx * tangentX + self.dy * tangentY) + normalY * pinNewNormalVelocity

        return true
    else
        return false
    end
end
