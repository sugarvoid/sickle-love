--Sickle.lua

Sickle = {}
Sickle.__index = Sickle

function Sickle:new(_x, _y, _moving_dir, _speed)
    local instance = setmetatable({}, Sickle)
    instance.image = love.graphics.newImage("asset/image/ice_sickle.png")
    instance.x = 0
    instance.y = 0
    instance.moving_dir = _moving_dir
    instance.rotation = 0
    instance.life_timer = 200
    instance.speed = _speed
    instance.max_speed = 200
    instance.acceleration = 4000
    instance.friction = 3500
    instance.w = instance.image:getWidth()
    instance.h = instance.image:getHeight()
    instance.hitbox = { x = instance.x, y = instance.y, w = instance.w - 12, h = instance.h - 3 }
    instance.body = world:newRectangleCollider(instance.x, instance.y, instance.hitbox.w, instance.hitbox.h)
    instance.body:setType("kinematic")
    instance.body:setCollisionClass("Sickle")
    instance.body:setObject(self)
    instance.body:setFixedRotation(true)
    instance.body:setPosition(_x, _y)
    instance:set_rotation()

    return instance
end

function Sickle:update(dt)
    self.body:setLinearVelocity(self.speed * self.moving_dir[1], self.speed * self.moving_dir[2])
    self.x = self.body:getX()
    self.y = self.body:getY()
    self.life_timer = self.life_timer - 1
    if self.body:enter("Ground") then 
        --todo: Play break animation 
        self.life_timer=0
    end
end

function Sickle:on_hit()
    print("I hit the player")
end

function Sickle:draw()
    love.graphics.draw(self.image, self.x, self.y, math.rad(self.rotation), 1, 1, self.w / 2, self.h / 2)
end

function Sickle:set_rotation()
    if do_tables_match(self.moving_dir, { 1, 0 }) then
        self.body:setAngle(math.rad(90))
        self.rotation = 0
    elseif do_tables_match(self.moving_dir, { -1, 0 }) then
        self.body:setAngle(math.rad(90))
        self.rotation = 180
    elseif do_tables_match(self.moving_dir, { 0, 1 }) then
        self.rotation = 90
    end
end

function Sickle:reset()
end