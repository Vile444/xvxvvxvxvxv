local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local mouse = Players.LocalPlayer:GetMouse()

local repo = "Vile444/xvxvvxvxvxv"

local skin = "cat"
if rawr ~= nil and rawr ~= "" then
	skin = rawr
end

local baseUrl = "https://raw.githubusercontent.com/" .. repo .. "/main/images/" .. skin .. "/"
local exts = { ".png", ".gif" }
local size = 36
local speed = 260
local stopDist = 34

print("loading " .. skin .. " please wait - arf arf geekin")

local frames = {}
local loading = {}
local failedAt = {}
local retryDelay = 3

local function getFrame(n)
	if frames[n] then return end
	if loading[n] then return end
	if failedAt[n] and os.clock() - failedAt[n] < retryDelay then return end
	loading[n] = true

	task.spawn(function()
		local gotIt = false
		for i = 1, #exts do
			local url = baseUrl .. n .. exts[i]
			local ok, data = pcall(function()
				return game:HttpGet(url)
			end)
			if ok and data and #data > 8 and (data:sub(1, 4) == "\137PNG" or data:sub(1, 3) == "GIF") then
				frames[n] = data
				gotIt = true
				break
			end
		end
		if not gotIt then
			failedAt[n] = os.clock()
		end
		loading[n] = nil
	end)
end

for i = 1, 32 do
	getFrame(i)
end

local img = Drawing.new("Image")
img.Visible = false
img.ZIndex = 10

local currentFrame
local function show(n)
	if currentFrame == n then return end
	if not frames[n] then
		getFrame(n)
		return
	end
	local worked = pcall(function()
		img.Data = frames[n]
	end)
	if worked then
		currentFrame = n
		img.Visible = true
	end
end

local pos = Vector2.new(mouse.X, mouse.Y)
local state = "sit"
local timer, animTimer, flip = 0, 0, false
local last = os.clock()

RunService.RenderStepped:Connect(function()
	local now = os.clock()
	local dt = now - last
	last = now

	local cam = workspace.CurrentCamera
	local viewport = nil
	if cam then
		viewport = cam.ViewportSize
	end

	local mouseX, mouseY = mouse.X, mouse.Y
	if viewport then
		mouseX = math.clamp(mouseX, size / 2, viewport.X - size / 2)
		mouseY = math.clamp(mouseY, size / 2, viewport.Y - size / 2)
	end

	local dx, dy = mouseX - pos.X, mouseY - pos.Y
	local dist = math.sqrt(dx * dx + dy * dy)
	local moving = dist > stopDist

	timer = timer + dt
	animTimer = animTimer + dt

	if moving then
		if state == "scratch" or state == "yawn" or state == "sleep" then
			state = "wake"
			timer = 0
			animTimer = 0
		elseif state == "sit" then
			state = "walk"
			timer = 0
		end
	elseif state == "walk" or state == "wake" then
		state = "sit"
		timer = 0
		animTimer = 0
	end

	if state == "wake" then
		show(32)
		if timer > 0.25 then
			state = "walk"
			timer = 0
		end
	elseif state == "walk" then
		if dist > 0 then
			local move = math.min(speed * dt, dist - stopDist + 1)
			pos = Vector2.new(pos.X + dx / dist * move, pos.Y + dy / dist * move)
		end

		local angle = math.deg(math.atan2(dx, -dy))
		if angle < 0 then
			angle = angle + 360
		end

		local frameA, frameB
		if angle < 22.5 or angle >= 337.5 then
			frameA, frameB = 1, 2
		elseif angle < 67.5 then
			frameA, frameB = 3, 4
		elseif angle < 112.5 then
			frameA, frameB = 5, 6
		elseif angle < 157.5 then
			frameA, frameB = 7, 8
		elseif angle < 202.5 then
			frameA, frameB = 9, 10
		elseif angle < 247.5 then
			frameA, frameB = 11, 12
		elseif angle < 292.5 then
			frameA, frameB = 13, 14
		else
			frameA, frameB = 15, 16
		end

		if animTimer > 0.15 then
			animTimer = 0
			flip = not flip
		end
		if flip then
			show(frameB)
		else
			show(frameA)
		end
	elseif state == "sit" then
		if animTimer > 0.5 then
			animTimer = 0
			flip = not flip
		end
		if flip then
			show(25)
		else
			show(31)
		end
		if timer > 4 then
			state = "scratch"
			timer = 0
			animTimer = 0
		end
	elseif state == "scratch" then
		if animTimer > 0.2 then
			animTimer = 0
			flip = not flip
		end
		if flip then
			show(28)
		else
			show(27)
		end
		if timer > 1.2 then
			state = "yawn"
			timer = 0
		end
	elseif state == "yawn" then
		show(26)
		if timer > 1 then
			state = "sleep"
			timer = 0
			animTimer = 0
		end
	elseif state == "sleep" then
		if animTimer > 0.6 then
			animTimer = 0
			flip = not flip
		end
		if flip then
			show(30)
		else
			show(29)
		end
	end

	img.Size = Vector2.new(size, size)
	img.Position = Vector2.new(pos.X - size / 2, pos.Y - size / 2)
end)

notify("Oneko. Star the script >:(", "bleh", 6.7)
