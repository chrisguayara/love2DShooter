local love = require "love"

local W, H = 320, 240
local scale = 4
local canvas

local player = {}
local crosshair = {}
local weapons = {}
local currWeapon
local projectiles = {}
local enemies = {}
local currEnemies = {}
local currLevel = "level1"



function love.load()
    love.window.setMode(W * scale, H * scale, {fullscreen = false, resizable = false, vsync = true})
    canvas = love.graphics.newCanvas(W, H)
    canvas:setFilter("nearest", "nearest")
    love.graphics.setDefaultFilter("nearest", "nearest")

    player.x, player.y = W / 2, H / 2
    player.speed = 70
    player.sprite = love.graphics.newImage('grim.png')
    player.facing = 1
    player.angle = 0

    crosshair.sprite = love.graphics.newImage('basecrosshair.png')

    weapons.crossbow = {
        cooldown = 0,
        fireRate = 0.3,
        speed = 200,
        sprite = love.graphics.newImage("crossbowBullet.png"),
        gunSprite = love.graphics.newImage("crossb.png")
    }
    weapons.crossbow.sprite:setFilter("nearest", "nearest")
    weapons.crossbow.gunSprite:setFilter("nearest", "nearest")

    currWeapon = "crossbow"

end


local function clamp(val, min, max)
    return math.max(min, math.min(max, val))
end

local function normalize(dx, dy)
    local len = math.sqrt(dx * dx + dy * dy)
    if len == 0 then return 0, 0 end
    return dx / len, dy / len
end

local function spawnProjectile(x, y, dx, dy, weapon)
    local angle = math.atan2(dy, dx) + math.rad(90)
    table.insert(projectiles, {
        x = x, y = y,
        dx = dx, dy = dy,
        speed = weapon.speed,
        sprite = weapon.sprite,
        angle = angle
    })
end

function love.mousepressed(x, y, button)
    if button == 1 then
        local weapon = weapons[currWeapon]
        if weapon.cooldown <= 0 then
            local arrx, arry = x / scale, y / scale
            local dx, dy = normalize(arrx - player.x, arry - player.y)
            if dx ~= 0 or dy ~= 0 then
                spawnProjectile(player.x, player.y, dx, dy, weapon)
                weapon.cooldown = weapon.fireRate
            end
        end
    end
end

function love.update(dt)
    local dirX, dirY = 0, 0
    if love.keyboard.isDown("a") then dirX = dirX - 1 end
    if love.keyboard.isDown("d") then dirX = dirX + 1 end
    if love.keyboard.isDown("w") then dirY = dirY - 1 end
    if love.keyboard.isDown("s") then dirY = dirY + 1 end
    dirX, dirY = normalize(dirX, dirY)
    if dirX > 0 then player.facing = 1
    elseif dirX < 0 then player.facing = -1 end

    player.x = clamp(player.x + dirX * player.speed * dt, player.sprite:getWidth()/2, W - player.sprite:getWidth()/2)
    player.y = clamp(player.y + dirY * player.speed * dt, player.sprite:getHeight()/2, H - player.sprite:getHeight()/2)

    local weapon = weapons[currWeapon]
    if weapon.cooldown > 0 then
        weapon.cooldown = weapon.cooldown - dt
    end

    for i = #projectiles, 1, -1 do
        local p = projectiles[i]
        p.x = p.x + p.dx * p.speed * dt
        p.y = p.y + p.dy * p.speed * dt
        if p.x < 0 or p.y < 0 or p.x > W or p.y > H then
            table.remove(projectiles, i)
        end
    end

    for i = #currEnemies
end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()

    love.graphics.draw(player.sprite, player.x, player.y, 0, player.facing, 1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)

    local mx, my = love.mouse.getPosition()
    local mx_canvas = mx / scale
    local my_canvas = my / scale

    local aim_dx = mx_canvas - player.x
    local aim_dy = my_canvas - player.y
    local aim_angle = math.atan2(aim_dy, aim_dx)

    player.angle = aim_angle

    local offsetX = 4 * player.facing
    local offsetY = 3
    local gun_angle = math.atan2(aim_dy, aim_dx) 
    local gun_scale_y = aim_dy <  0 and 1 or -1

    love.graphics.draw(
        weapons[currWeapon].gunSprite,
        player.x + offsetX,
        player.y + offsetY,
        gun_angle,
        1, gun_scale_y,
        weapons[currWeapon].gunSprite:getWidth() / 2,
        weapons[currWeapon].gunSprite:getHeight() / 2
    )

    for _, p in ipairs(projectiles) do
        love.graphics.draw(p.sprite, p.x, p.y, p.angle, 1, 1, p.sprite:getWidth()/2, p.sprite:getHeight()/2)
    end

    love.graphics.setCanvas()
    love.graphics.draw(canvas, 0, 0, 0, scale, scale)

    love.graphics.draw(
        crosshair.sprite,
        math.floor(mx + 0.5),
        math.floor(my + 0.5),
        0, 1, 1,
        crosshair.sprite:getWidth()/2,
        crosshair.sprite:getHeight()/2
    )

    love.mouse.setVisible(false)
end

function enemySpawner(currLevel)
    local count = 0  
    local levelCounter = 0
    if currLevel == "level1" then
        levelCounter = 20
        while counter < levelCounter do
            
        end

        table.insert(enemies, {

        })
    end
end

