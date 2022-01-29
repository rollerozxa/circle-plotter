
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
showvis = true

function love.load()
	font = love.graphics.newFont(11)
	bigfont = love.graphics.newFont(24)
end

-- Radius of the circle/Half of the square's size
ra = 300
-- Resolution scale - how many decimals the randomly generated dots will have
resScale = 1

function love.update()

	for i = 1, 1000 do
		local dot = {
			x = math.random((resolution.x / 2 - ra) * resScale , (resolution.x / 2 + ra) * resScale) / resScale,
			y = math.random((resolution.y / 2 - ra) * resScale, (resolution.y / 2 + ra) * resScale) / resScale,
		}

		local distance_from_center = math.sqrt( ( dot.x - center.x ) ^ 2 + ( dot.y - center.y ) ^ 2 )
		local inside_circle = ( distance_from_center < ra )
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

	if love.keyboard.isDown('f') and not oldshowvis then
		if showvis then
			showvis = false
		else
			showvis = true
		end
	end
	oldshowvis = love.keyboard.isDown('f')
end

function love.draw()
	love.graphics.setBackgroundColor(0,0,0)

	if showvis then
		love.graphics.setColor(0,1,0)
		for _,dot in pairs(dots_inside) do
			love.graphics.points(dot.x, dot.y)
		end

		love.graphics.setColor(1,0,0)
		for _,dot in pairs(dots_outside) do
			love.graphics.points(dot.x, dot.y)
		end
	end

	if showguides then
		love.graphics.setColor(1,1,1)
		love.graphics.circle("line", center.x, center.y, ra)
		love.graphics.rectangle("line", center.x - ra, center.y - ra, ra*2, ra*2)
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
