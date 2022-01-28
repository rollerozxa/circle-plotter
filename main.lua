
resolution = {
	x = 1280,
	y = 720
}

love.window.setMode(resolution.x, resolution.y)

step = 0

center = {
	x = resolution.x / 2,
	y = resolution.y / 2,
}

dots_inside = {}

dots_outside = {}

showguides = false

function love.load()
	font = love.graphics.newFont(11)
	bigfont = love.graphics.newFont(24)
end

function love.update()
	for i = 1, 1000 do
		local dot = {
			x = math.random(resolution.x / 2 - 300, resolution.x / 2 + 300),
			y = math.random(resolution.y / 2 - 300, resolution.y / 2 + 300),
		}

		local distance_from_center = math.sqrt( ( dot.x - center.x ) ^ 2 + ( dot.y - center.y ) ^ 2 )
		local inside_circle = ( distance_from_center < 300 )
		if inside_circle then
			table.insert(dots_inside, dot)
		else
			table.insert(dots_outside, dot)
		end
	end

	if love.keyboard.isDown('g') and not oldshowguides then
		if showguides then
			showguides = false
		else
			showguides = true
		end
	end
	oldshowguides = love.keyboard.isDown('g')
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)

	if showguides then
		love.graphics.setColor(1,1,1)
		love.graphics.circle("line", center.x, center.y, 300)
		love.graphics.rectangle("line", center.x - 300, center.y - 300, 600, 600)
	end

	love.graphics.setColor(0,1,0)
	for _,dot in pairs(dots_inside) do
		love.graphics.points(dot.x, dot.y)
	end

	love.graphics.setColor(1,0,0)
	for _,dot in pairs(dots_outside) do
		love.graphics.points(dot.x, dot.y)
	end

	love.graphics.setColor(1,1,1)
	love.graphics.setFont(font)
	love.graphics.print("FPS: "..love.timer.getFPS(), 10, resolution.y-30)
	love.graphics.setFont(bigfont)
	love.graphics.print("Dots inside: "..#dots_inside, 10, 10)
	love.graphics.print("Dots outside: "..#dots_outside, 10, 40)
	love.graphics.print("Ratio: "..string.format("%.3f", (#dots_inside/#dots_outside)), 10, 70)

	step = step + 1
end
