love = require "love"

width = 320
height = 240
local scale = 3
local canvas

function love.load()
    love.window.setMode(320 * scale, 240 * scale, {
        fullscreen = false,
        resizable = false, 
        vsync = true
    })

    canvas = love.graphics.newCanvas(320, 240)
    canvas:setFilter("nearest", "nearest") 

    love.graphics.setDefaultFilter("nearest", "nearest") 
    loadplayer()
    loadcrosshair()

end

function love.draw()
    love.graphics.setCanvas(canvas)
    love.graphics.clear()
    

    love.graphics.draw(player.sprite, player.x, player.y, 0, 1,1, player.sprite:getWidth()/2, player.sprite:getHeight()/2)ssssss
    love.graphics.setCanvas()

    love.graphics.draw(canvas, 0, 0 ,0, scale, scale)
    local x,y = love.mouse.getPosition()
    x = x/scale
    y = y /scale
    love.graphics.draw(crosshair.sprite,x, y, 0, 1, 1, crosshair.sprite:getWidth()/2,  crosshair.sprite:getHeight()/2)
    love.mouse.setVisible(false) 
    for _, arrow in ipairs(allarrows) do
        
        love.graphics.draw(arrow.sprite,arrow.x, arrow.y ,0, 1 , 1, arrow.sprite:getWidth()/2, arrow.sprite:getHeight()/2 )
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        onButtonPressed()
        print("left mouse pressed", x, y)
    end
end
crossbowBullet = {}
crossbowBullet.sprite = love.graphics.newImage("crossbowBullet.png")
allarrows = {}

function onButtonPressed()
    local arrx, arry = love.mouse.getPosition()
    arrx = arrx/scale
    arry = arry /scale

    local dx = arrx - player.x
    local dy = arry - player.y
    local len = math.sqrt(dx * dx + dy * dy)

    if len == 0 then return end
    dx , dy = dx/len, dy/len
    local speed = 150

    local arrow = {x = player.x,y = player.y, dx= dx, dy = dy, speed = speed, sprite = crossbowBullet.sprite}
    
    table.insert(allarrows, arrow)
    
    

end




function love.update(dt)
    -- player logic
    local dirX, dirY = 0, 0

    if love.keyboard.isDown("a") then dirX = dirX - 1 end
    if love.keyboard.isDown("d") then dirX = dirX + 1 end
    if love.keyboard.isDown("w") then dirY = dirY - 1 end
    if love.keyboard.isDown("s") then dirY = dirY + 1 end

    local len = math.sqrt(dirX * dirX + dirY * dirY)
    if len > 0 then
        dirX = dirX / len
        dirY = dirY / len
    end

    player.x = player.x + dirX * player.speed * dt
    player.y = player.y + dirY * player.speed * dt
    for i = #allarrows, 1, -1 do
    local arrow = allarrows[i]
    arrow.x = arrow.x + arrow.dx * arrow.speed * dt
    arrow.y = arrow.y + arrow.dy * arrow.speed * dt

    if arrow.x < 0 or arrow.y < 0 or arrow.x > width or arrow.y > height then
        table.remove(allarrows, i)
    end
end
    

end

function loadplayer()
    player = {}
    
    player.x = width/2
    player.y = height/2
    player.speed = 65
    player.sprite = love.graphics.newImage('grim.png')
end

function loadcrosshair()
    crosshair = {}
    crosshair.sprite = love.graphics.newImage('basecrosshair.png')
end





-- number = 30 
-- number = number * 2 