local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

math.randomseed(tick())

local lockedCharacter = Players.LocalPlayer.Character
local lockedHRP = lockedCharacter and lockedCharacter:FindFirstChild("HumanoidRootPart")
local lockedCFrame = lockedHRP and lockedHRP.CFrame

local function holdCharacterStill()
	if lockedHRP and lockedCFrame then
		pcall(function()
			lockedHRP.CFrame = lockedCFrame
		end)
	end
end

local MAP = {
	"____________________________",
	"____________________________",
	"____________________________",
	"||||||||||||||||||||||||||||",
	"|............||............|",
	"|.||||.|||||.||.|||||.||||.|",
	"|o||||.|||||.||.|||||.||||o|",
	"|.||||.|||||.||.|||||.||||.|",
	"|..........................|",
	"|.||||.||.||||||||.||.||||.|",
	"|.||||.||.||||||||.||.||||.|",
	"|......||....||....||......|",
	"||||||.||||| || |||||.||||||",
	"_____|.||||| || |||||.|_____",
	"_____|.||          ||.|_____",
	"_____|.|| |||--||| ||.|_____",
	"||||||.|| |______| ||.||||||",
	"      .   |______|   .      ",
	"||||||.|| |______| ||.||||||",
	"_____|.|| |||||||| ||.|_____",
	"_____|.||          ||.|_____",
	"_____|.|| |||||||| ||.|_____",
	"||||||.|| |||||||| ||.||||||",
	"|............||............|",
	"|.||||.|||||.||.|||||.||||.|",
	"|.||||.|||||.||.|||||.||||.|",
	"|o..||.......  .......||..o|",
	"|||.||.||.||||||||.||.||.|||",
	"|||.||.||.||||||||.||.||.|||",
	"|......||....||....||......|",
	"|.||||||||||.||.||||||||||.|",
	"|.||||||||||.||.||||||||||.|",
	"|..........................|",
	"||||||||||||||||||||||||||||",
	"____________________________",
	"____________________________",
}

local COLS, ROWS = 28, 36
local TUNNEL_ROW = 17

local dots = {}
local totalDots, dotsEaten = 0, 0

for y = 0, ROWS - 1 do
	dots[y] = {}
	local row = MAP[y + 1]
	for x = 0, COLS - 1 do
		local c = row:sub(x + 1, x + 1)
		if c == "." or c == "o" then
			dots[y][x] = c
			totalDots = totalDots + 1
		end
	end
end

local function wrapX(x)
	if x < 0 then return COLS - 1 end
	if x >= COLS then return 0 end
	return x
end

local function getChar(x, y)
	if y == TUNNEL_ROW then x = wrapX(x) end
	if x < 0 or x >= COLS or y < 0 or y >= ROWS then return nil end
	return MAP[y + 1]:sub(x + 1, x + 1)
end

local function isWalkable(x, y, forGhost)
	local c = getChar(x, y)
	if c == nil or c == "|" or c == "_" then return false end
	if c == "-" then return forGhost end
	return true
end

local function isTunnelZone(x, y)
	return y == TUNNEL_ROW and (x <= 5 or x >= COLS - 6)
end

local MARGIN_TOP = 50
local cam = workspace.CurrentCamera
local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
local availW, availH = vp.X, vp.Y - MARGIN_TOP
local TILE = math.floor(math.min(availW / COLS, availH / ROWS))
local mazeW, mazeH = COLS * TILE, ROWS * TILE
local originX = math.floor((vp.X - mazeW) / 2)
local originY = math.max(MARGIN_TOP, math.floor((vp.Y - mazeH) / 2))

local function toScreen(tx, ty)
	return Vector2.new(originX + tx * TILE, originY + ty * TILE)
end

local baseUrl = "https://raw.githubusercontent.com/Vile444/xvxvvxvxvxvx/main/images/"
local assets = {}
local assetList = {}
local assetsTotal, assetsLoaded = 0, 0
local assetFailures = {}

local function loadAsset(path)
	table.insert(assetList, path)
end

local function img(path)
	return assets[path]
end

loadAsset("maze.png")
loadAsset("food/dot.png")
loadAsset("food/energizer.png")
for _, dir in ipairs({ "right", "left", "up", "down" }) do
	for f = 0, 2 do
		loadAsset("pacman/pacman_" .. dir .. "_" .. f .. ".png")
	end
end
for i = 0, 11 do
	loadAsset("pacman/pacman_death_" .. i .. ".png")
end
for _, name in ipairs({ "blinky", "pinky", "inky", "clyde" }) do
	for _, dir in ipairs({ "right", "left", "up", "down" }) do
		for f = 0, 1 do
			loadAsset("ghosts/" .. name .. "_" .. dir .. "_" .. f .. ".png")
		end
	end
end
for _, tag in ipairs({ "frightened_blue", "frightened_white" }) do
	for f = 0, 1 do
		loadAsset("ghosts/" .. tag .. "_" .. f .. ".png")
	end
end
for _, dir in ipairs({ "right", "left", "up", "down" }) do
	loadAsset("ghosts/eyes_" .. dir .. ".png")
end
for _, name in ipairs({ "cherry", "strawberry", "orange", "apple", "melon", "galaxian", "bell", "key" }) do
	loadAsset("fruit/" .. name .. ".png")
end

assetsTotal = #assetList

task.spawn(function()
	for _, path in ipairs(assetList) do
		local ok, data = pcall(game.HttpGet, game, baseUrl .. path)
		if ok and data and #data > 0 then
			assets[path] = data
		else
			table.insert(assetFailures, path)
		end
		assetsLoaded = assetsLoaded + 1
		task.wait()
	end
end)

local bg = Drawing.new("Square")
bg.Filled = true
bg.Color = Color3.new(0, 0, 0)
bg.Position = Vector2.new(0, 0)
bg.Size = vp
bg.ZIndex = 0
bg.Visible = true

local mazeImage = Drawing.new("Image")
mazeImage.Position = toScreen(0, 0)
mazeImage.Size = Vector2.new(mazeW, mazeH)
mazeImage.ZIndex = 1
mazeImage.Visible = false

local dotDrawings = {}
local DOT_SIZE, ENERGIZER_SIZE = math.max(16, TILE * 1.4), math.max(24, TILE * 1.8)

for y = 0, ROWS - 1 do
	dotDrawings[y] = {}
	for x = 0, COLS - 1 do
		local kind = dots[y][x]
		if kind then
			local c = Drawing.new("Image")
			local size = (kind == "o") and ENERGIZER_SIZE or DOT_SIZE
			c.Size = Vector2.new(size, size)
			c.Position = toScreen(x, y) + Vector2.new((TILE - size) / 2, (TILE - size) / 2)
			c.ZIndex = 10
			c.Visible = true
			dotDrawings[y][x] = c
		end
	end
end

local textShadows = {}

local function makeText(size, color, opts)
	opts = opts or {}
	local t = Drawing.new("Text")
	t.Size = size
	t.Color = color
	t.Visible = true
	t.ZIndex = 10
	pcall(function() t.Font = 2 end)
	if opts.center then t.Center = true end

	local shadow = Drawing.new("Text")
	shadow.Size = size
	shadow.Color = Color3.new(0, 0, 0)
	shadow.Visible = true
	shadow.ZIndex = 9
	pcall(function() shadow.Font = 2 end)
	if opts.center then shadow.Center = true end
	table.insert(textShadows, { main = t, shadow = shadow })

	return t
end

local function syncTextShadows()
	for _, pair in ipairs(textShadows) do
		pair.shadow.Text = pair.main.Text
		pair.shadow.Visible = pair.main.Visible
		pair.shadow.Position = pair.main.Position + Vector2.new(2, 2)
	end
end

local scoreText = makeText(18, Color3.new(1, 1, 1))
scoreText.Position = Vector2.new(originX, originY - 28)

local levelText = makeText(18, Color3.new(1, 1, 1), { center = true })
levelText.Position = Vector2.new(originX + mazeW / 2, originY - 28)

local livesText = makeText(18, Color3.new(1, 1, 1))
livesText.Position = Vector2.new(originX + mazeW - 100, originY - 28)

local msgText = makeText(28, Color3.fromRGB(255, 255, 0), { center = true })
msgText.Position = toScreen(COLS / 2, 20) + Vector2.new(0, TILE / 2)
msgText.Text = ""

local freezeScoreText = makeText(16, Color3.new(1, 1, 1), { center = true })
freezeScoreText.Visible = false

local fruitScoreText = makeText(14, Color3.fromRGB(255, 255, 0), { center = true })
fruitScoreText.Visible = false

local DIRS = { { 0, -1 }, { 0, 1 }, { -1, 0 }, { 1, 0 } }

local PACMAN_SPAWN = { x = 13, y = 26 }
local DOOR_TILE = { x = 13, y = 14 }
local FRUIT_TILE = { x = 13, y = 20 }

local GHOST_SPAWNS = {
	blinky = { x = 13, y = 14, dx = -1, dy = 0 },
	pinky = { x = 13, y = 17, dx = 0, dy = 1 },
	inky = { x = 11, y = 17, dx = 0, dy = -1 },
	clyde = { x = 15, y = 17, dx = 0, dy = -1 },
}

local SCATTER_CORNERS = {
	blinky = { x = 25, y = 0 },
	pinky = { x = 2, y = 0 },
	inky = { x = 27, y = 34 },
	clyde = { x = 0, y = 34 },
}

local NO_UP_TILES = { [12] = { [14] = true, [26] = true }, [15] = { [14] = true, [26] = true } }

local BASE_SPEED = 7.5

local SPEED_TABLE = {
	{ pacman = 1.0, pacmanFright = 1.125, ghost = 0.9375, ghostFright = 0.625, ghostTunnel = 0.5, elroy1 = 1.0, elroy2 = 1.0625 },
	{ pacman = 1.125, pacmanFright = 1.1875, ghost = 1.0625, ghostFright = 0.6875, ghostTunnel = 0.5625, elroy1 = 1.125, elroy2 = 1.1875 },
	{ pacman = 1.25, pacmanFright = 1.25, ghost = 1.1875, ghostFright = 0.75, ghostTunnel = 0.625, elroy1 = 1.25, elroy2 = 1.3125 },
	{ pacman = 1.125, pacmanFright = 0, ghost = 1.1875, ghostFright = 0, ghostTunnel = 0.625, elroy1 = 1.25, elroy2 = 1.3125 },
}
local function speedBracket(lvl)
	if lvl == 1 then return 1
	elseif lvl <= 4 then return 2
	elseif lvl <= 20 then return 3
	else return 4 end
end

local SCATTER_CHASE_TABLES = {
	{ { "scatter", 7 }, { "chase", 20 }, { "scatter", 7 }, { "chase", 20 }, { "scatter", 5 }, { "chase", 20 }, { "scatter", 5 }, { "chase", math.huge } },
	{ { "scatter", 7 }, { "chase", 20 }, { "scatter", 7 }, { "chase", 20 }, { "scatter", 5 }, { "chase", math.huge } },
	{ { "scatter", 5 }, { "chase", 20 }, { "scatter", 5 }, { "chase", 20 }, { "scatter", 5 }, { "chase", math.huge } },
}
local function scatterChaseBracket(lvl)
	if lvl == 1 then return 1
	elseif lvl <= 4 then return 2
	else return 3 end
end

local FRIGHT_SECONDS = { 6, 5, 4, 3, 2, 5, 2, 2, 1, 5, 2, 1, 1, 3, 1, 1, 0, 1 }
local FRIGHT_FLASHES = { 5, 5, 5, 5, 5, 5, 5, 5, 3, 5, 5, 3, 3, 5, 3, 3, 0, 3 }
local function frightDuration(lvl)
	if lvl > 18 then return 0 end
	return FRIGHT_SECONDS[lvl]
end
local function frightFlashes(lvl)
	if lvl > 18 then return 0 end
	return FRIGHT_FLASHES[lvl]
end

local ELROY1_DOTS_LEFT = { 20, 30, 40, 40, 40, 50, 50, 50, 60, 60, 60, 70, 70, 70, 100, 100, 100, 100, 120, 120, 120 }
local ELROY2_DOTS_LEFT = { 10, 15, 20, 20, 20, 25, 25, 25, 30, 30, 30, 40, 40, 40, 50, 50, 50, 50, 60, 60, 60 }
local function elroyThreshold(stage, lvl)
	local i = math.min(lvl, 21)
	local tbl = (stage == 1) and ELROY1_DOTS_LEFT or ELROY2_DOTS_LEFT
	return totalDots - tbl[i]
end

local RELEASE_ORDER = { "pinky", "inky", "clyde" }
local GLOBAL_DOT_LIMIT = { pinky = 7, inky = 17, clyde = 32 }
local function personalDotLimit(name, lvl)
	if name == "pinky" then return 0 end
	if name == "inky" then return (lvl == 1) and 30 or 0 end
	if name == "clyde" then
		if lvl == 1 then return 60 end
		if lvl == 2 then return 50 end
		return 0
	end
end
local function releaseTimeoutLimit(lvl)
	return (lvl < 5) and 4 or 3
end

local FRUITS = {
	{ name = "cherry", points = 100, color = Color3.fromRGB(255, 0, 0) },
	{ name = "strawberry", points = 300, color = Color3.fromRGB(255, 105, 180) },
	{ name = "orange", points = 500, color = Color3.fromRGB(255, 140, 0) },
	{ name = "apple", points = 700, color = Color3.fromRGB(0, 200, 0) },
	{ name = "melon", points = 1000, color = Color3.fromRGB(0, 150, 80) },
	{ name = "galaxian", points = 2000, color = Color3.fromRGB(50, 100, 255) },
	{ name = "bell", points = 3000, color = Color3.fromRGB(255, 220, 0) },
	{ name = "key", points = 5000, color = Color3.fromRGB(0, 255, 255) },
}
local FRUIT_ORDER = { 1, 2, 3, 3, 4, 4, 5, 5, 6, 6, 7, 7, 8 }
local function currentFruit(lvl)
	return FRUITS[FRUIT_ORDER[math.min(lvl, 13)]]
end

local function dirName(dx, dy)
	if dx == 1 then return "right"
	elseif dx == -1 then return "left"
	elseif dy == -1 then return "up"
	elseif dy == 1 then return "down"
	end
	return nil
end

local SPRITE_SIZE = TILE * 1.6

local pacman = {
	tx = PACMAN_SPAWN.x, ty = PACMAN_SPAWN.y,
	renderX = PACMAN_SPAWN.x, renderY = PACMAN_SPAWN.y,
	dx = 0, dy = 0,
	qx = 0, qy = 0,
	t = 0,
	score = 0,
	lives = 3,
	lastDir = "right",
	animTimer = 0,
	animDirCache = nil,
	frame0 = Drawing.new("Image"),
	frame1 = Drawing.new("Image"),
	frame2 = Drawing.new("Image"),
	deathImage = Drawing.new("Image"),
}
for _, obj in ipairs({ pacman.frame0, pacman.frame1, pacman.frame2, pacman.deathImage }) do
	obj.Size = Vector2.new(SPRITE_SIZE, SPRITE_SIZE)
	obj.ZIndex = 25
	obj.Visible = false
end
pacman.frame0.Visible = true

local extraLifeAwarded = false
local function addScore(points)
	pacman.score = pacman.score + points
	if not extraLifeAwarded and pacman.score >= 10000 then
		extraLifeAwarded = true
		pacman.lives = pacman.lives + 1
	end
end

local function newGhost(name)
	local spawn = GHOST_SPAWNS[name]
	local corner = SCATTER_CORNERS[name]
	local g = {
		name = name,
		scatterX = corner.x, scatterY = corner.y,
		tx = spawn.x, ty = spawn.y,
		renderX = spawn.x, renderY = spawn.y,
		dx = spawn.dx, dy = spawn.dy,
		lastDir = "up",
		animDirCache = nil,
		eyesDirCache = nil,
		t = 0,
		state = "house",
		elroy = 0,
		frame0 = Drawing.new("Image"),
		frame1 = Drawing.new("Image"),
		eyesImage = Drawing.new("Image"),
		frightBlue = Drawing.new("Image"),
		frightWhite = Drawing.new("Image"),
	}
	for _, obj in ipairs({ g.frame0, g.frame1, g.eyesImage, g.frightBlue, g.frightWhite }) do
		obj.Size = Vector2.new(SPRITE_SIZE, SPRITE_SIZE)
		obj.ZIndex = 20
		obj.Visible = false
	end
	g.frame0.Visible = true
	return g
end

local ghosts = {
	blinky = newGhost("blinky"),
	pinky = newGhost("pinky"),
	inky = newGhost("inky"),
	clyde = newGhost("clyde"),
}

local fruitDrawing = Drawing.new("Image")
fruitDrawing.Size = Vector2.new(TILE, TILE)
fruitDrawing.ZIndex = 12
fruitDrawing.Visible = false
local fruitActive = false
local fruitTimer = 0
local fruitScoreTimer = 0

local level = 0
local gameState = "loading"
local readyTimer, dyingTimer, levelClearTimer = 4, 0, 0

local baseMode, scPhaseIndex, scPhaseTimer = "scatter", 1, 7
local frightTimer, comboMult = 0, 1
local freezeTimer = 0

local releaseMode, globalDotCount, sinceLastDot = "personal", 0, 0
local personalCounts = { pinky = 0, inky = 0, clyde = 0 }
local waitForClyde = false

local function resetScatterChase()
	scPhaseIndex = 1
	local phase = SCATTER_CHASE_TABLES[scatterChaseBracket(level)][1]
	baseMode = phase[1]
	scPhaseTimer = phase[2]
end

local function updateModeTimer(dt)
	if frightTimer > 0 then
		frightTimer = frightTimer - dt
		if frightTimer <= 0 then
			frightTimer = 0
			for _, g in pairs(ghosts) do
				if g.state == "frightened" then g.state = baseMode end
			end
		end
		return
	end
	local phases = SCATTER_CHASE_TABLES[scatterChaseBracket(level)]
	if scPhaseIndex >= #phases then return end
	scPhaseTimer = scPhaseTimer - dt
	if scPhaseTimer <= 0 then
		scPhaseIndex = scPhaseIndex + 1
		local phase = phases[scPhaseIndex]
		baseMode = phase[1]
		scPhaseTimer = phase[2]
		for _, g in pairs(ghosts) do
			if g.state == "scatter" or g.state == "chase" then
				g.state = baseMode
				g.dx, g.dy = -g.dx, -g.dy
			end
		end
	end
end

local function updateElroy(dt)
	if waitForClyde then
		if ghosts.clyde.state ~= "house" then waitForClyde = false end
	end
	if waitForClyde then
		ghosts.blinky.elroy = 0
	elseif dotsEaten >= elroyThreshold(2, level) then
		ghosts.blinky.elroy = 2
	elseif dotsEaten >= elroyThreshold(1, level) then
		ghosts.blinky.elroy = 1
	else
		ghosts.blinky.elroy = 0
	end
end

local function releaseGhost(g)
	g.state = "leaving"
	g.t = 0
	if g.tx ~= DOOR_TILE.x then
		g.dx, g.dy = (DOOR_TILE.x > g.tx) and 1 or -1, 0
	else
		g.dx, g.dy = 0, -1
	end
end

local function updateGhostReleaser(dt)
	sinceLastDot = sinceLastDot + dt
	if releaseMode == "personal" then
		for _, name in ipairs(RELEASE_ORDER) do
			local g = ghosts[name]
			if g.state == "house" then
				if personalCounts[name] >= personalDotLimit(name, level) then
					releaseGhost(g)
				end
				break
			end
		end
	else
		if globalDotCount == GLOBAL_DOT_LIMIT.pinky and ghosts.pinky.state == "house" then
			releaseGhost(ghosts.pinky)
		elseif globalDotCount == GLOBAL_DOT_LIMIT.inky and ghosts.inky.state == "house" then
			releaseGhost(ghosts.inky)
		elseif globalDotCount == GLOBAL_DOT_LIMIT.clyde and ghosts.clyde.state == "house" then
			globalDotCount = 0
			releaseMode = "personal"
			releaseGhost(ghosts.clyde)
		end
	end
	if sinceLastDot > releaseTimeoutLimit(level) then
		sinceLastDot = 0
		for _, name in ipairs(RELEASE_ORDER) do
			local g = ghosts[name]
			if g.state == "house" then
				releaseGhost(g)
				break
			end
		end
	end
end

local function spawnFruit()
	fruitActive = true
	fruitTimer = 9
	local f = currentFruit(level)
	fruitDrawing.Data = img("fruit/" .. f.name .. ".png")
	fruitDrawing.Position = toScreen(FRUIT_TILE.x, FRUIT_TILE.y) + Vector2.new(TILE / 2, 0)
	fruitDrawing.Visible = true
end

local function eatAt(tx, ty)
	local row = dots[ty]
	local kind = row and row[tx]
	if not kind then return end
	row[tx] = nil
	dotsEaten = dotsEaten + 1
	local d = dotDrawings[ty] and dotDrawings[ty][tx]
	if d then d.Visible = false end
	addScore(kind == "o" and 50 or 10)

	sinceLastDot = 0
	if releaseMode == "global" then
		globalDotCount = globalDotCount + 1
	else
		for _, name in ipairs(RELEASE_ORDER) do
			if ghosts[name].state == "house" then
				personalCounts[name] = personalCounts[name] + 1
				break
			end
		end
	end

	if not fruitActive and (dotsEaten == 70 or dotsEaten == 170) then
		spawnFruit()
	end

	if kind == "o" and frightDuration(level) > 0 then
		frightTimer = frightDuration(level)
		comboMult = 1
		for _, g in pairs(ghosts) do
			if g.state == "scatter" or g.state == "chase" then
				g.state = "frightened"
				g.dx, g.dy = -g.dx, -g.dy
			end
		end
	end
end

local function updateFruit(dt)
	if fruitActive then
		fruitTimer = fruitTimer - dt
		if fruitTimer <= 0 then
			fruitActive = false
			fruitDrawing.Visible = false
		end
	end
	if fruitScoreTimer > 0 then
		fruitScoreTimer = fruitScoreTimer - dt
		if fruitScoreTimer <= 0 then fruitScoreText.Visible = false end
	end
end

local function checkFruitCollision()
	if not fruitActive then return end
	if math.abs(pacman.renderX - (FRUIT_TILE.x + 0.5)) < 0.6 and math.abs(pacman.renderY - FRUIT_TILE.y) < 0.6 then
		local f = currentFruit(level)
		addScore(f.points)
		fruitActive = false
		fruitDrawing.Visible = false
		fruitScoreTimer = 2
		fruitScoreText.Text = tostring(f.points)
		fruitScoreText.Position = fruitDrawing.Position + Vector2.new(TILE / 2, TILE / 2)
		fruitScoreText.Visible = true
	end
end

local function getPacmanSpeed()
	local speeds = SPEED_TABLE[speedBracket(level)]
	return BASE_SPEED * ((frightTimer > 0) and speeds.pacmanFright or speeds.pacman)
end

local function updatePacman(dt)
	local p = pacman
	p.t = p.t + getPacmanSpeed() * dt
	while p.t >= 1 do
		p.t = p.t - 1
		p.tx, p.ty = p.tx + p.dx, p.ty + p.dy
		if p.ty == TUNNEL_ROW then p.tx = wrapX(p.tx) end
		eatAt(p.tx, p.ty)
		if (p.qx ~= 0 or p.qy ~= 0) and isWalkable(p.tx + p.qx, p.ty + p.qy, false) then
			p.dx, p.dy = p.qx, p.qy
		end
		if not isWalkable(p.tx + p.dx, p.ty + p.dy, false) then
			p.dx, p.dy = 0, 0
			p.t = 0
			break
		end
	end
	p.renderX = p.tx + p.dx * p.t
	p.renderY = p.ty + p.dy * p.t
end

local function ghostTarget(g)
	if g.state == "eaten" then
		return DOOR_TILE.x, DOOR_TILE.y
	end
	local elroyActive = (g.name == "blinky") and g.elroy and g.elroy > 0
	if g.state == "scatter" and not elroyActive then
		return g.scatterX, g.scatterY
	end
	if g.name == "blinky" then
		return pacman.tx, pacman.ty
	elseif g.name == "pinky" then
		local px, py = pacman.tx + pacman.dx * 4, pacman.ty + pacman.dy * 4
		if pacman.dx == 0 and pacman.dy == -1 then px = px - 4 end
		return px, py
	elseif g.name == "inky" then
		local ax, ay = pacman.tx + pacman.dx * 2, pacman.ty + pacman.dy * 2
		if pacman.dx == 0 and pacman.dy == -1 then ax = ax - 2 end
		local blinky = ghosts.blinky
		return blinky.tx + 2 * (ax - blinky.tx), blinky.ty + 2 * (ay - blinky.ty)
	elseif g.name == "clyde" then
		local px, py = g.tx + g.dx, g.ty + g.dy
		local dx, dy = pacman.tx - px, pacman.ty - py
		if dx * dx + dy * dy >= 64 then
			return pacman.tx, pacman.ty
		end
		return g.scatterX, g.scatterY
	end
	return pacman.tx, pacman.ty
end

local function chooseGhostDir(g)
	local candidates = {}
	for _, d in ipairs(DIRS) do
		local nx, ny = g.tx + d[1], g.ty + d[2]
		local isReverse = (d[1] == -g.dx and d[2] == -g.dy) and not (g.dx == 0 and g.dy == 0)
		local blockedUp = (d[1] == 0 and d[2] == -1) and NO_UP_TILES[nx] and NO_UP_TILES[nx][ny]
		if not isReverse and not blockedUp and isWalkable(nx, ny, true) then
			table.insert(candidates, d)
		end
	end
	if #candidates == 0 then
		if isWalkable(g.tx - g.dx, g.ty - g.dy, true) then
			return -g.dx, -g.dy
		end
		return 0, 0
	end
	if g.state == "frightened" then
		local pick = candidates[math.random(1, #candidates)]
		return pick[1], pick[2]
	end
	local tx, ty = ghostTarget(g)
	local best, bestDist = candidates[1], math.huge
	for _, d in ipairs(candidates) do
		local nx, ny = g.tx + d[1], g.ty + d[2]
		local dist = (nx - tx) ^ 2 + (ny - ty) ^ 2
		if dist < bestDist then
			bestDist, best = dist, d
		end
	end
	return best[1], best[2]
end

local function getGhostSpeed(g)
	if g.state == "eaten" then return BASE_SPEED * 2 end
	local speeds = SPEED_TABLE[speedBracket(level)]
	if g.state == "frightened" then return BASE_SPEED * speeds.ghostFright end
	if isTunnelZone(g.tx, g.ty) then return BASE_SPEED * speeds.ghostTunnel end
	if g.name == "blinky" and g.elroy == 2 then return BASE_SPEED * speeds.elroy2 end
	if g.name == "blinky" and g.elroy == 1 then return BASE_SPEED * speeds.elroy1 end
	return BASE_SPEED * speeds.ghost
end

local HOUSE_SPEED = BASE_SPEED * SPEED_TABLE[1].ghostTunnel

local function updateGhost(g, dt)
	if g.state == "house" then return end

	if g.state == "leaving" then
		g.t = g.t + HOUSE_SPEED * dt
		while g.t >= 1 do
			g.t = g.t - 1
			g.tx, g.ty = g.tx + g.dx, g.ty + g.dy
			if g.tx == DOOR_TILE.x and g.ty == DOOR_TILE.y then
				g.state = (frightTimer > 0) and "frightened" or baseMode
				g.dx, g.dy = 0, -1
				g.t = 0
				break
			elseif g.tx ~= DOOR_TILE.x then
				g.dx, g.dy = (DOOR_TILE.x > g.tx) and 1 or -1, 0
			else
				g.dx, g.dy = 0, -1
			end
		end
		g.renderX = g.tx + g.dx * g.t
		g.renderY = g.ty + g.dy * g.t
		return
	end

	g.t = g.t + getGhostSpeed(g) * dt
	while g.t >= 1 do
		g.t = g.t - 1
		g.tx, g.ty = g.tx + g.dx, g.ty + g.dy
		if g.ty == TUNNEL_ROW then g.tx = wrapX(g.tx) end
		if g.state == "eaten" and g.tx == DOOR_TILE.x and g.ty == DOOR_TILE.y then
			g.state = baseMode
		end
		local ndx, ndy = chooseGhostDir(g)
		g.dx, g.dy = ndx, ndy
		if ndx == 0 and ndy == 0 then g.t = 0 end
	end
	g.renderX = g.tx + g.dx * g.t
	g.renderY = g.ty + g.dy * g.t
end

local function checkCollisions()
	for _, g in pairs(ghosts) do
		if g.state ~= "house" and g.state ~= "eaten" then
			local dist = math.sqrt((g.renderX - pacman.renderX) ^ 2 + (g.renderY - pacman.renderY) ^ 2)
			if dist < 0.6 then
				if g.state == "frightened" then
					local pts = 200 * comboMult
					addScore(pts)
					comboMult = comboMult * 2
					g.state = "eaten"
					freezeTimer = 1
					freezeScoreText.Text = tostring(pts)
					freezeScoreText.Position = toScreen(g.renderX, g.renderY) + Vector2.new(TILE / 2, TILE / 2)
					freezeScoreText.Visible = true
				else
					pacman.lives = pacman.lives - 1
					gameState = "dying"
					dyingTimer = 4
					return
				end
			end
		end
	end
end

local function updatePacmanSprite(dt)
	if pacman.dx ~= 0 or pacman.dy ~= 0 then
		pacman.lastDir = dirName(pacman.dx, pacman.dy) or pacman.lastDir
		pacman.animTimer = pacman.animTimer + getPacmanSpeed() * dt * 0.7
	end

	local pos = toScreen(pacman.renderX, pacman.renderY) + Vector2.new((TILE - SPRITE_SIZE) / 2, (TILE - SPRITE_SIZE) / 2)

	if gameState == "dying" then
		pacman.frame0.Visible, pacman.frame1.Visible, pacman.frame2.Visible = false, false, false
		local idx = math.floor((1 - math.max(dyingTimer, 0) / 4) * 12)
		if idx > 11 then idx = 11 end
		if idx < 0 then idx = 0 end
		local key = "pacman/pacman_death_" .. idx .. ".png"
		if key ~= pacman.imageKey then
			pacman.imageKey = key
			pacman.deathImage.Data = img(key)
		end
		pacman.deathImage.Position = pos
		pacman.deathImage.Visible = true
		return
	end
	pacman.deathImage.Visible = false

	if pacman.lastDir ~= pacman.animDirCache then
		pacman.animDirCache = pacman.lastDir
		pacman.frame0.Data = img("pacman/pacman_" .. pacman.lastDir .. "_0.png")
		pacman.frame1.Data = img("pacman/pacman_" .. pacman.lastDir .. "_1.png")
		pacman.frame2.Data = img("pacman/pacman_" .. pacman.lastDir .. "_2.png")
	end

	local frame = math.floor(pacman.animTimer) % 4
	if frame == 3 then frame = 1 end

	pacman.frame0.Position, pacman.frame1.Position, pacman.frame2.Position = pos, pos, pos
	pacman.frame0.Visible = (frame == 0)
	pacman.frame1.Visible = (frame == 1)
	pacman.frame2.Visible = (frame == 2)
end

local function renderAll()
	if gameState == "gameover" then
		pacman.frame0.Visible, pacman.frame1.Visible, pacman.frame2.Visible, pacman.deathImage.Visible = false, false, false, false
	end

	local ghostsVisible = (gameState ~= "dying" and gameState ~= "levelclear")
	local flashOn = (frightTimer > 0 and frightTimer < 2 * frightFlashes(level) * (14 / 60))
		and (math.floor(frightTimer * 5) % 2 == 0)
	local showFrame1 = (math.floor(os.clock() * 5) % 2 == 1)

	for _, g in pairs(ghosts) do
		if g.state == "house" then
			g.renderX = g.tx
			g.renderY = g.ty + math.sin(os.clock() * 3 + (g.name == "clyde" and 4 or g.name == "inky" and 2 or 0)) * 0.3
		end
		if g.dx ~= 0 or g.dy ~= 0 then
			g.lastDir = dirName(g.dx, g.dy) or g.lastDir
		end

		local pos = toScreen(g.renderX, g.renderY) + Vector2.new((TILE - SPRITE_SIZE) / 2, (TILE - SPRITE_SIZE) / 2)

		if g.state == "frightened" then
			g.frame0.Visible, g.frame1.Visible, g.eyesImage.Visible = false, false, false
			g.frightBlue.Position, g.frightWhite.Position = pos, pos
			g.frightBlue.Visible = ghostsVisible and not flashOn
			g.frightWhite.Visible = ghostsVisible and flashOn
		elseif g.state == "eaten" then
			g.frame0.Visible, g.frame1.Visible = false, false
			g.frightBlue.Visible, g.frightWhite.Visible = false, false
			if g.lastDir ~= g.eyesDirCache then
				g.eyesDirCache = g.lastDir
				g.eyesImage.Data = img("ghosts/eyes_" .. g.lastDir .. ".png")
			end
			g.eyesImage.Position = pos
			g.eyesImage.Visible = ghostsVisible
		else
			g.eyesImage.Visible = false
			g.frightBlue.Visible, g.frightWhite.Visible = false, false
			if g.lastDir ~= g.animDirCache then
				g.animDirCache = g.lastDir
				g.frame0.Data = img("ghosts/" .. g.name .. "_" .. g.lastDir .. "_0.png")
				g.frame1.Data = img("ghosts/" .. g.name .. "_" .. g.lastDir .. "_1.png")
			end
			g.frame0.Position, g.frame1.Position = pos, pos
			g.frame0.Visible = ghostsVisible and not showFrame1
			g.frame1.Visible = ghostsVisible and showFrame1
		end
	end

	scoreText.Text = "SCORE: " .. pacman.score
	levelText.Text = "LV " .. math.max(level, 1)
	livesText.Text = "LIVES: " .. pacman.lives

	syncTextShadows()
end

local function resetPositions()
	pacman.tx, pacman.ty = PACMAN_SPAWN.x, PACMAN_SPAWN.y
	pacman.dx, pacman.dy = 0, 0
	pacman.qx, pacman.qy = 0, 0
	pacman.t = 0
	pacman.renderX, pacman.renderY = pacman.tx, pacman.ty
	pacman.lastDir = "right"

	for name, g in pairs(ghosts) do
		local s = GHOST_SPAWNS[name]
		g.tx, g.ty = s.x, s.y
		g.renderX, g.renderY = s.x, s.y
		g.dx, g.dy = s.dx, s.dy
		g.lastDir = dirName(s.dx, s.dy) or "up"
		g.t = 0
		g.state = (name == "blinky") and baseMode or "house"
	end
	ghosts.blinky.elroy = 0

	frightTimer = 0
	comboMult = 1
	freezeTimer = 0
	freezeScoreText.Visible = false
	fruitActive = false
	fruitDrawing.Visible = false
	fruitScoreTimer = 0
	fruitScoreText.Visible = false
end

local function startNewLevel()
	level = level + 1
	for y = 0, ROWS - 1 do
		local row = MAP[y + 1]
		for x = 0, COLS - 1 do
			local c = row:sub(x + 1, x + 1)
			if c == "." or c == "o" then
				dots[y][x] = c
				if dotDrawings[y][x] then dotDrawings[y][x].Visible = true end
			end
		end
	end
	dotsEaten = 0
	releaseMode = "personal"
	personalCounts = { pinky = 0, inky = 0, clyde = 0 }
	globalDotCount = 0
	sinceLastDot = 0
	waitForClyde = false
	resetScatterChase()
	resetPositions()
	gameState = "ready"
	readyTimer = 4
	msgText.Text = "READY!"
end

local function restartAfterDeath()
	releaseMode = "global"
	globalDotCount = 0
	sinceLastDot = 0
	waitForClyde = true
	resetScatterChase()
	resetPositions()
	gameState = "ready"
	readyTimer = 4
	msgText.Text = "READY!"
end

local function startNewGame()
	level = 0
	pacman.lives = 3
	pacman.score = 0
	extraLifeAwarded = false
	startNewLevel()
end

local renderConn, inputConn

local function cleanup()
	if renderConn then renderConn:Disconnect() end
	if inputConn then inputConn:Disconnect() end
	mazeImage:Remove()
	for y = 0, ROWS - 1 do
		for x = 0, COLS - 1 do
			if dotDrawings[y][x] then dotDrawings[y][x]:Remove() end
		end
	end
	bg:Remove()
	for _, pair in ipairs(textShadows) do
		pair.main:Remove()
		pair.shadow:Remove()
	end
	fruitDrawing:Remove()
	pacman.frame0:Remove()
	pacman.frame1:Remove()
	pacman.frame2:Remove()
	pacman.deathImage:Remove()
	for _, g in pairs(ghosts) do
		g.frame0:Remove()
		g.frame1:Remove()
		g.eyesImage:Remove()
		g.frightBlue:Remove()
		g.frightWhite:Remove()
	end
end

inputConn = UIS.InputBegan:Connect(function(input, gpe)
	if gpe then return end
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Up or kc == Enum.KeyCode.W then
		pacman.qx, pacman.qy = 0, -1
	elseif kc == Enum.KeyCode.Down or kc == Enum.KeyCode.S then
		pacman.qx, pacman.qy = 0, 1
	elseif kc == Enum.KeyCode.Left or kc == Enum.KeyCode.A then
		pacman.qx, pacman.qy = -1, 0
	elseif kc == Enum.KeyCode.Right or kc == Enum.KeyCode.D then
		pacman.qx, pacman.qy = 1, 0
	elseif kc == Enum.KeyCode.R and gameState == "gameover" then
		startNewGame()
	elseif kc == Enum.KeyCode.Backspace then
		cleanup()
	end
end)

local function applyLoadedAssets()
	mazeImage.Data = img("maze.png")
	mazeImage.Visible = true
	for y = 0, ROWS - 1 do
		for x = 0, COLS - 1 do
			local d = dotDrawings[y][x]
			if d then
				d.Data = img(dots[y][x] == "o" and "food/energizer.png" or "food/dot.png")
			end
		end
	end
	for _, g in pairs(ghosts) do
		g.frightBlue.Data = img("ghosts/frightened_blue_0.png")
		g.frightWhite.Data = img("ghosts/frightened_white_0.png")
	end
end

local lastClock = os.clock()

renderConn = RunService.RenderStepped:Connect(function()
	local now = os.clock()
	local dt = math.min(now - lastClock, 0.05)
	lastClock = now

	holdCharacterStill()

	if gameState == "loading" then
		msgText.Text = "Loading images, please wait... (" .. assetsLoaded .. "/" .. assetsTotal .. ")"
		syncTextShadows()
		if assetsLoaded >= assetsTotal then
			applyLoadedAssets()
			if #assetFailures > 0 then
				notify("Packman", #assetFailures .. " image(s) failed to load, see console", 6)
				for _, path in ipairs(assetFailures) do
					warn("Packman: failed to load " .. path)
				end
			end
			startNewGame()
		end
		return
	end

	if gameState == "ready" then
		readyTimer = readyTimer - dt
		msgText.Text = "READY!"
		if readyTimer <= 0 then
			gameState = "playing"
			msgText.Text = ""
		end
	elseif gameState == "playing" then
		if freezeTimer > 0 then
			freezeTimer = freezeTimer - dt
			if freezeTimer <= 0 then freezeScoreText.Visible = false end
		else
			updatePacman(dt)
			updateElroy(dt)
			updateGhostReleaser(dt)
			updateModeTimer(dt)
			for _, g in pairs(ghosts) do
				updateGhost(g, dt)
			end
			updateFruit(dt)
			checkCollisions()
			checkFruitCollision()
			if dotsEaten >= totalDots then
				gameState = "levelclear"
				levelClearTimer = 3
			end
		end
	elseif gameState == "dying" then
		dyingTimer = dyingTimer - dt
		if dyingTimer <= 0 then
			if pacman.lives <= 0 then
				gameState = "gameover"
				msgText.Text = "GAME OVER (Press R)"
			else
				restartAfterDeath()
			end
		end
	elseif gameState == "levelclear" then
		levelClearTimer = levelClearTimer - dt
		mazeImage.Visible = math.floor(levelClearTimer * 5) % 2 == 0
		if levelClearTimer <= 0 then
			mazeImage.Visible = true
			startNewLevel()
		end
	end

	updatePacmanSprite(dt)
	renderAll()
end)

notify("Packman", "Meow!", 5)
