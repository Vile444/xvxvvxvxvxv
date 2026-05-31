-- Made with AI 
-- Credit to Code.leak for the mod list

local CoreGui = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera

if _G.ESP_CLEANUP then
    pcall(_G.ESP_CLEANUP)
end

local isRunning = true
_G.ESP_CLEANUP = function()
    isRunning = false
    if _G.RenderConnection then
        _G.RenderConnection:Disconnect()
        _G.RenderConnection = nil
    end
    if _G.OldDrawings then
        for textObj, _ in pairs(_G.OldDrawings) do
            pcall(function() textObj:Remove() end)
        end
    end
    _G.OldDrawings = {}
end

_G.OldDrawings = {}

if type(Drawing) ~= "table" then
    local drawingUI = Instance.new("ScreenGui")
    drawingUI.Name = "MatchaDrawingPolyfill"
    drawingUI.IgnoreGuiInset = true
    
    pcall(function() drawingUI.Parent = CoreGui end)
    if not drawingUI.Parent then
        drawingUI.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    end

    getgenv().Drawing = {
        Fonts = { System = Enum.Font.SourceSansBold },
        new = function(className)
            if className == "Text" then
                local label = Instance.new("TextLabel")
                label.BackgroundTransparency = 1
                label.Visible = false
                label.Parent = drawingUI
                
                local obj = {}
                setmetatable(obj, {
                    __newindex = function(_, k, v)
                        if k == "Visible" then label.Visible = v
                        elseif k == "Text" then label.Text = v
                        elseif k == "Position" then label.Position = UDim2.new(0, v.X, 0, v.Y)
                        elseif k == "Color" then label.TextColor3 = v
                        elseif k == "Size" then label.TextSize = v
                        elseif k == "Center" then label.AnchorPoint = v and Vector2.new(0.5, 0) or Vector2.new(0, 0)
                        elseif k == "Outline" then label.TextStrokeTransparency = v and 0 or 1
                        end
                    end,
                    __index = function(_, k)
                        if k == "Remove" then
                            return function() label:Destroy() end
                        end
                    end
                })
                return obj
            end
        end
    }
end

local WorldToScreen = WorldToScreen or function(position)
	if not Camera then return Vector3.new(0,0,0), false end
	local screenPos, onScreen = Camera:WorldToScreenPoint(position)
	return Vector3.new(screenPos.X, screenPos.Y, screenPos.Z), onScreen
end

local function getUniqueEntityId(instance)
	if typeof(instance) ~= "Instance" then return tostring(instance) end
	
	if type(getaddress) == "function" then
		local success, addr = pcall(function() return tostring(getaddress(instance)) end)
		if success and addr and addr ~= "nil" then return addr end
	end
	
	local successProp, addrProp = pcall(function() return tostring(instance.Address) end)
	if successProp and addrProp and addrProp ~= "nil" then
		return addrProp
	end
	
	local successDebug, debugId = pcall(function() return instance:GetDebugId() end)
	if successDebug and debugId and debugId ~= "" then
		return debugId
	end
	
	local attr = instance:GetAttribute("ESP_PTR")
	if not attr then
		attr = HttpService:GenerateGUID(false)
		pcall(function() instance:SetAttribute("ESP_PTR", attr) end)
	end
	return attr
end

local moderatorNames = {
    ["KittenBagelz"] = "Game Moderator", ["Rikumah"] = "Game Moderator",
    ["DopeIlI"] = "Game Moderator", ["chancerocke"] = "Game Moderator",
    ["Lexi34567812"] = "Game Moderator", ["puferyba"] = "Game Moderator",
    ["gamerofdestroyers"] = "Game Moderator", ["aidenas2011"] = "Game Moderator",
    ["owner12310"] = "Game Moderator", ["Chinyro"] = "Game Moderator",
    ["Fan_hellrider"] = "Game Moderator", ["imghostoma"] = "Game Moderator",
    ["Hakob_8w8"] = "Game Moderator", ["Sotojulio06"] = "Game Moderator",
    ["ilovetowerbattle_9"] = "Game Moderator", ["Hsixienn"] = "Game Moderator",
    ["coolboyofawsome4"] = "Game Moderator", ["redbullgivesu_WINGS4"] = "Game Moderator",
    ["Kitty_1624"] = "Game Moderator", ["GamerMauriiYT"] = "Game Moderator",
    ["Bajoogies_XD"] = "Game Moderator", ["Xion_Light"] = "Game Moderator",
    ["Kaz_Elite"] = "Game Moderator", ["hello_myfriends45"] = "Game Moderator",
    ["chrisatmfan21"] = "Game Moderator", ["joax009617"] = "Game Moderator",
    ["AaronElagant"] = "Game Moderator", ["Prye4"] = "Game Moderator",
    ["Puhgee"] = "Game Moderator", ["roblox_23193"] = "Game Moderator",
    ["fearedbyvamp"] = "Game Moderator", ["3verIast"] = "Game Moderator",
    ["harrib_allsack54321"] = "Game Moderator", ["Matheus06532"] = "Game Moderator",
    ["B_BEAMO"] = "Game Moderator", ["fordjdj12"] = "Game Moderator",
    ["sirfluf"] = "Game Moderator", ["Weerdeeg"] = "Game Moderator",
    ["giovannirv2"] = "Game Moderator", ["Waitwhatb40"] = "Game Moderator",
    ["kerub131"] = "Game Moderator", ["rashhhh2"] = "Game Moderator",
    ["DontTouchZGrass"] = "Game Moderator", ["matheu09173"] = "Game Moderator",
    ["jostjohnyca"] = "Game Moderator", ["krisidisi23"] = "Game Moderator",
    ["MetaSile"] = "Game Moderator", ["1Newy1"] = "Game Moderator",
    ["YTGonzo"] = "Contribution", ["AsianAbrex"] = "Lead Developer",
    ["Warm_Vibes"] = "Lead Developer", ["ChickenBagelz"] = "Co-Founder",
    ["neddleduck"] = "Founder",
}

local moderatorIds = {
    [51281722] = "Game Moderator", [7178750309] = "Game Moderator",
    [113179883] = "Game Moderator", [3122439095] = "Game Moderator",
    [991290934] = "Game Moderator", [3968854760] = "Game Moderator",
    [114812725] = "Game Moderator", [81993536] = "Game Moderator",
    [1004214871] = "Game Moderator", [914847610] = "Game Moderator",
    [3034930770] = "Game Moderator", [1622256215] = "Game Moderator",
    [1116486172] = "Game Moderator", [4252853044] = "Game Moderator",
    [2364950171] = "Game Moderator", [1528346843] = "Game Moderator",
    [165053216] = "Game Moderator", [9024231578] = "Game Moderator",
    [1127954045] = "Game Moderator", [3640120679] = "Game Moderator",
    [602009251] = "Game Moderator", [372791101] = "Game Moderator",
    [1378169111] = "Game Moderator", [3020799797] = "Game Moderator",
    [372528624] = "Game Moderator", [2567998467] = "Game Moderator",
    [4243907215] = "Game Moderator", [813030262] = "Game Moderator",
    [353983652] = "Game Moderator", [1406181681] = "Game Moderator",
    [2229169589] = "Game Moderator", [30934698] = "Game Moderator",
    [3004094651] = "Game Moderator", [839333692] = "Game Moderator",
    [979624578] = "Game Moderator", [1478885961] = "Game Moderator",
    [399754916] = "Game Moderator", [1193091081] = "Game Moderator",
    [4553863490] = "Game Moderator", [4225513035] = "Game Moderator",
    [41482597] = "Game Moderator", [2924549627] = "Game Moderator",
    [2732967856] = "Game Moderator", [1937516999] = "Game Moderator",
    [1374319325] = "Game Moderator", [1058831985] = "Game Moderator",
    [9621064456] = "Game Moderator", [584370127] = "Game Moderator",
    [174212818] = "Contribution", [25548179] = "Lead Developer",
    [363101315] = "Lead Developer", [47983795] = "Co-Founder",
    [16681869] = "Founder",
}

local overlayText = Drawing.new("Text")
overlayText.Color = Color3.fromRGB(255, 255, 255)
overlayText.Outline = true
overlayText.Center = false
overlayText.Font = Drawing.Fonts.System
overlayText.Visible = false
_G.OldDrawings[overlayText] = true

local blinkState = true

local plantConfig = {
	["Wool Plant"]      = { toggleKey = "filter_Wool",      colorKey = "col_Wool",      label = "Wool",      r = 215/255, g = 207/255, b = 207/255 },
	["Corn Plant"]      = { toggleKey = "filter_Corn",      colorKey = "col_Corn",      label = "Corn",      r = 255/255, g = 237/255, b = 0/255   },
	["Lemon Plant"]     = { toggleKey = "filter_Lemon",     colorKey = "col_Lemon",     label = "Lemon",     r = 255/255, g = 255/255, b = 0/255   },
	["Tomato Plant"]    = { toggleKey = "filter_Tomato",    colorKey = "col_Tomato",    label = "Tomato",    r = 255/255, g = 0/255,   b = 0/255   },
	["Pumpkin Plant"]   = { toggleKey = "filter_Pumpkin",   colorKey = "col_Pumpkin",   label = "Pumpkin",   r = 255/255, g = 175/255, b = 0/255   },
	["Blueberry Plant"] = { toggleKey = "filter_Blueberry", colorKey = "col_Blueberry", label = "Blueberry", r = 0/255,   g = 100/255, b = 255/255 },
	["Raspberry Plant"] = { toggleKey = "filter_Raspberry", colorKey = "col_Raspberry", label = "Raspberry", r = 255/255, g = 75/255,  b = 100/255 }
}

local nodeConfig = {
	["Stone_Node"]     = { toggleKey = "filter_Stone",  colorKey = "col_Stone",  label = "Stone Node", r = 140/255, g = 140/255, b = 140/255 },
	["Metal_Node"]     = { toggleKey = "filter_Metal",  colorKey = "col_Metal",  label = "Metal Node", r = 185/255, g = 140/255, b = 100/255 },
	["Phosphate_Node"] = { toggleKey = "filter_Phos",   colorKey = "col_Phos",   label = "Phos Node",  r = 200/255, g = 170/255, b = 0/255   }
}

local crateConfig = {
	["Food Crate"]           = { toggleKey = "filter_FoodCrate",          colorKey = "col_FoodCrate",          label = "Food Crate",          r = 255/255, g = 150/255, b = 50/255 },
	["Wooden Crate"]         = { toggleKey = "filter_WoodenCrate",        colorKey = "col_WoodenCrate",        label = "Wooden Crate",        r = 160/255, g = 120/255, b = 90/255  },
	["Locked Wooden Crate"]  = { toggleKey = "filter_LockedWoodenCrate",  colorKey = "col_LockedWoodenCrate",  label = "Locked Wooden Crate", r = 130/255, g = 90/255,  b = 60/255  },
	["Locked Metal Crate"]   = { toggleKey = "filter_LockedMetalCrate",   colorKey = "col_LockedMetalCrate",   label = "Locked Metal Crate",  r = 140/255, g = 150/255, b = 160/255 },
	["Locked Steel Crate"]   = { toggleKey = "filter_LockedSteelCrate",   colorKey = "col_LockedSteelCrate",   label = "Locked Steel Crate",  r = 100/255, g = 180/255, b = 220/255 },
	["Timed Crate"]          = { toggleKey = "filter_TimedCrate",         colorKey = "col_TimedCrate",         label = "Timed Crate",         r = 240/255, g = 70/255,  b = 70/255  },
	["Care Package"]         = { toggleKey = "filter_CarePackage",        colorKey = "col_CarePackage",        label = "Care Package",        r = 230/255, g = 220/255, b = 50/255  },
	["Trash Can"]            = { toggleKey = "filter_TrashCan",           colorKey = "col_TrashCan",           label = "Trash Can",           r = 120/255, g = 120/255, b = 120/255 },
	["Oil Barrel"]           = { toggleKey = "filter_OilBarrel",          colorKey = "col_OilBarrel",          label = "Oil Barrel",          r = 60/255,  g = 60/255,  b = 60/255  }
}

local extraPageConfig = {
	["Sleeper"]              = { toggleKey = "filter_Sleeper",            colorKey = "col_Sleeper",            label = "Sleeper",             r = 210/255, g = 180/255, b = 140/255 },
	["Salvaged Flycopter"]   = { toggleKey = "filter_Flycopter",          colorKey = "col_Flycopter",          label = "Salvaged Flycopter",   r = 50/255,  g = 220/255, b = 220/255 },
	["Wooden Boat"]          = { toggleKey = "filter_WoodenBoat",         colorKey = "col_WoodenBoat",         label = "Wooden Boat",         r = 150/255, g = 110/255, b = 80/255  },
	["Military Boat"]        = { toggleKey = "filter_MilitaryBoat",       colorKey = "col_MilitaryBoat",       label = "Military Boat",       r = 60/255,  g = 120/255, b = 60/255  },
	["Body Bag"]             = { toggleKey = "filter_BodyBag",            colorKey = "col_BodyBag",            label = "Body Bag",            r = 180/255, g = 30/255, b = 30/255 }
}

local animalConfig = {
	["PREFAB_ANIMAL_DEER"]      = { toggleKey = "filter_Deer", colorKey = "col_Deer", label = "Deer", r = 190/255, g = 130/255, b = 80/255  },
	["PREFAB_ANIMAL_WILDBOAR"]  = { toggleKey = "filter_Boar", colorKey = "col_Boar", label = "Boar", r = 130/255, g = 100/255, b = 80/255  },
	["PREFAB_ANIMAL_WOLF"]      = { toggleKey = "filter_Wolf", colorKey = "col_Wolf", label = "Wolf", r = 160/255, g = 160/255, b = 170/255 }
}

local bossConfig = {
	["Bruno"] = { toggleKey = "filter_Boss_Bruno", colorKey = "col_Boss_Bruno", label = "Bruno", r = 255/255, g = 255/255, b = 255/255   },
	["Brutus"] = { toggleKey = "filter_Boss_Brutus", colorKey = "col_Boss_Brutus", label = "Brutus", r = 255/255, g = 255/255,  b = 255/255   },
	["Boris"] = { toggleKey = "filter_Boss_Boris", colorKey = "col_Boss_Boris", label = "Boris", r = 255/255, g = 255/255, b = 255/255   },
	["BTR"] = { toggleKey = "filter_Boss_BTR", colorKey = "col_Boss_BTR", label = "BTR", r = 255/255, g = 255/255,  b = 255/255   }
}

local locationList = {
	"Abandoned Bunker", "Military Airfield", "Military Base", "Military Barracks",
	"Rocket Factory", "Industrial Port", "Cargo Yard", "Labs", "Submarine",
	"ConvoyOne", "ConvoyTwo", "ConvoyThree", "ConvoyFour"
}

if typeof(UI) == "table" and UI.AddTab then
	UI.AddTab("Fallen", function(tab)
		local sec = tab:Section("ESP Configurations", "Left", {"Nodes", "Plants", "Crates", "Drops", "Extra"}, 450)
		
		if sec.page == 0 then
			sec:Toggle("node_enabled", "Enabled")
			sec:Toggle("node_name", "Name ESP")
			sec:Toggle("node_distance", "Distance ESP")
			sec:SliderInt("node_max_count", "Max Nodes", 1, 75, 30)
			sec:SliderInt("node_max_dist", "Max Distance", 0, 500, 250)
			sec:Spacing()
			sec:Text("Nodes Filter:")
			for _, name in ipairs({"Stone_Node", "Metal_Node", "Phosphate_Node"}) do
				local config = nodeConfig[name]
				sec:Toggle(config.toggleKey, config.label, true)
				sec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
			end
			
		elseif sec.page == 1 then
			sec:Toggle("plant_enabled", "Enabled")
			sec:Toggle("plant_name", "Name ESP")
			sec:Toggle("plant_distance", "Distance ESP")
			sec:SliderInt("plant_max_count", "Max Plants", 1, 75, 30)
			sec:SliderInt("plant_max_dist", "Max Distance", 0, 500, 250)
			sec:Spacing()
			sec:Text("Plants Filter:")
			for _, name in ipairs({"Wool Plant", "Corn Plant", "Lemon Plant", "Tomato Plant", "Pumpkin Plant", "Blueberry Plant", "Raspberry Plant"}) do
				local config = plantConfig[name]
				sec:Toggle(config.toggleKey, name, true)
				sec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
			end

		elseif sec.page == 2 then
			sec:Toggle("crate_enabled", "Enabled")
			sec:Toggle("crate_name", "Name ESP")
			sec:Toggle("crate_distance", "Distance ESP")
			sec:SliderInt("crate_max_count", "Max Crates", 1, 75, 30)
			sec:SliderInt("crate_max_dist", "Max Distance", 0, 2500, 250)
			sec:Spacing()
			sec:Text("Crate Filters:")
			for _, name in ipairs({"Food Crate", "Wooden Crate", "Locked Wooden Crate", "Locked Metal Crate", "Locked Steel Crate", "Timed Crate"}) do
				local config = crateConfig[name]
				sec:Toggle(config.toggleKey, name, true)
				sec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
			end
			sec:Spacing()
			sec:Text("Extra")
			for _, name in ipairs({"Care Package", "Trash Can", "Oil Barrel"}) do
				local config = crateConfig[name]
				sec:Toggle(config.toggleKey, name, true)
				sec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
			end

		elseif sec.page == 3 then
			sec:Toggle("drop_enabled", "Enabled")
			sec:ColorPicker("col_Drop", 240/255, 240/255, 240/255, 1)
			sec:Toggle("drop_name", "Name ESP")
			sec:Toggle("drop_distance", "Distance ESP")
			sec:SliderInt("drop_max_count", "Max Drops", 1, 75, 30)
			sec:SliderInt("drop_max_dist", "Max Distance", 1, 500, 250)

		elseif sec.page == 4 then
			sec:Toggle("extra_enabled", "Enabled")
			sec:Toggle("extra_name", "Name ESP")
			sec:Toggle("extra_distance", "Distance ESP")
			sec:SliderInt("extra_max_count", "Max Extra Objects", 1, 75, 30)
			sec:SliderInt("extra_max_dist", "Max Distance", 0, 500, 250)
			sec:Spacing()
			sec:Text("Extra Filters:")
			for _, name in ipairs({"Sleeper", "Salvaged Flycopter", "Wooden Boat", "Military Boat", "Body Bag"}) do
				local config = extraPageConfig[name]
				sec:Toggle(config.toggleKey, name, true)
				sec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
			end
		end

		local animSec = tab:Section("Animals", "Left", nil, 320)
		animSec:Toggle("animal_enabled", "Enabled")
		animSec:Toggle("animal_name", "Name ESP")
		animSec:Toggle("animal_health", "Health ESP")
		animSec:Toggle("animal_distance", "Distance ESP")
		animSec:SliderInt("animal_max_dist", "Max Distance", 1, 500, 250)
		animSec:Spacing()
		animSec:Text("Animals Filter:")
		for _, rawName in ipairs({"PREFAB_ANIMAL_DEER", "PREFAB_ANIMAL_WILDBOAR", "PREFAB_ANIMAL_WOLF"}) do
			local config = animalConfig[rawName]
			animSec:Toggle(config.toggleKey, config.label, true)
			animSec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
		end

		local rightSec = tab:Section("Threat Management", "Right", {"NPCs", "Locations"}, 450)
		
		if rightSec.page == 0 then
			rightSec:Toggle("npc_enabled", "Enabled")
			rightSec:ColorPicker("col_npc_esp", 255/255, 50/255, 50/255, 1)
			rightSec:Toggle("npc_name", "Name")
			rightSec:Toggle("npc_health", "Health")
			rightSec:Toggle("npc_distance", "Distance")
			rightSec:SliderInt("npc_max_dist", "Max Distance", 1, 5000, 500)
			
		elseif rightSec.page == 1 then
			rightSec:Toggle("loc_all", "All", false)
			rightSec:Spacing()
			rightSec:Text("Location Filter:")
			for _, locName in ipairs(locationList) do
				local safeKey = "loc_filter_" .. locName:gsub(" ", "")
				rightSec:Toggle(safeKey, locName, false)
			end
		end

		local eventSec = tab:Section("Events", "Right", nil, 360)
		eventSec:Toggle("event_enabled", "Enabled")
		eventSec:Toggle("event_name", "Name")
		eventSec:Toggle("event_health", "Health")
		eventSec:Toggle("event_distance", "Distance")
		eventSec:SliderInt("event_max_dist", "Max Distance", 1, 5000, 1500)
		eventSec:Spacing()
		eventSec:Text("Event Filter:")
		for _, bName in ipairs({"Bruno", "Brutus", "Boris", "BTR"}) do
			local config = bossConfig[bName]
			eventSec:Toggle(config.toggleKey, bName, true)
			eventSec:ColorPicker(config.colorKey, config.r, config.g, config.b, 1)
		end

		local extraSec = tab:Section("Staff Alerts / Settings", "Right", nil, 420)
		extraSec:Toggle("act_mod_alert", "Active Mod Alert", true)
		extraSec:Text("Credit to code.leak for the mod list")
		extraSec:Spacing()
		
		extraSec:Text("Performance Settings")
		
		extraSec:Text("Target Script FPS: Caps how fast ESP text updates on screen.")
		extraSec:SliderInt("script_fps_target", "Script Fps", 30, 240, 60)
		extraSec:Spacing()
		
		extraSec:Text("Load Speed: How many objects are scanned per tick.")
		extraSec:Text("Turn down if script freezes while walking around or the script crashes.")
		extraSec:SliderInt("esp_load_speed", "ESP Load Speed", 1, 50, 10)
		extraSec:Spacing()
		
		extraSec:Text("Respawn Delay: Seconds to wait after you respawn.")
		extraSec:SliderInt("respawn_delay", "Respawn Delay (Seconds)", 1, 5, 2)
		
		extraSec:Spacing()
		extraSec:SliderInt("script_text_size", "Text Size", 10, 32, 13)
	end)
end

local drawings = {}

local function createText()
	local text = Drawing.new("Text")
	text.Size = (typeof(UI) == "table" and UI.GetValue("script_text_size")) or 16
	text.Center = true
	text.Outline = true
	text.Color = Color3.fromRGB(255, 255, 255)
	text.Font = Drawing.Fonts.System
	text.Visible = false
	_G.OldDrawings[text] = true
	return text
end

local function getLiveColor(colorKey, defaultR, defaultG, defaultB)
    if typeof(UI) == "table" then
        local r, g, b = UI.GetValue(colorKey)
        if r and g and b then
            return Color3.fromRGB(math.floor(r * 255), math.floor(g * 255), math.floor(b * 255))
        end
    end
	return Color3.fromRGB(math.floor(defaultR * 255), math.floor(defaultG * 255), math.floor(defaultB * 255))
end

local function wipeResourceClass(targetClass)
	for key, data in pairs(drawings) do
		if data.resourceClass == targetClass then
			pcall(function() 
                if data.text then
                    data.text:Remove() 
                    _G.OldDrawings[data.text] = nil
                end
            end)
			drawings[key] = nil
		end
	end
end

local function wipeAllDrawings()
    for key, data in pairs(drawings) do
        pcall(function() 
            if data.text then
                data.text.Visible = false
                data.text:Remove()
                _G.OldDrawings[data.text] = nil
            end
        end)
    end
    table.clear(drawings)
end

local function isLocationActive(locName)
    if typeof(UI) ~= "table" then return false end
	if UI.GetValue("loc_all") then return true end
	local safeKey = "loc_filter_" .. locName:gsub(" ", "")
	return UI.GetValue(safeKey) or false
end

local function safeGetValue(valName, fallback)
    if typeof(UI) == "table" and UI.GetValue then
        local val = UI.GetValue(valName)
        if val ~= nil then return val end
    end
    return fallback
end

task.spawn(function()
	local lp = Players.LocalPlayer
    local wasDead = false
	
    while isRunning do
		task.wait(4.0)

		local batchSize = math.max(1, safeGetValue("esp_load_speed", 10))

		local character = lp.Character
		local locHum = character and character:FindFirstChildWhichIsA("Humanoid")
		
        if not character or not locHum or locHum.Health <= 0 then
            if not wasDead then
                wasDead = true
                wipeAllDrawings()
            end
			task.wait(1.0)
			continue
		end
        
        if wasDead then
            local delayTime = safeGetValue("respawn_delay", 3)
            task.wait(delayTime)
            wasDead = false
        end
		
		local nMaster = safeGetValue("node_enabled", false)
		local pMaster = safeGetValue("plant_enabled", false)
		local cMaster = safeGetValue("crate_enabled", false)
		local dMaster = safeGetValue("drop_enabled", false)
		local eMaster = safeGetValue("extra_enabled", false)
		local aMaster = safeGetValue("animal_enabled", false)
		local npcMaster = safeGetValue("npc_enabled", false)
		local eventMaster = safeGetValue("event_enabled", false)
		
		if not nMaster then wipeResourceClass("Node") end
		if not pMaster then wipeResourceClass("Plant") end
		if not cMaster then wipeResourceClass("Crate") end
		if not dMaster then wipeResourceClass("Drop") end
		if not eMaster then wipeResourceClass("Extra") end
		if not aMaster then wipeResourceClass("Animal") end
		if not npcMaster then wipeResourceClass("NPC") end
		if not eventMaster then wipeResourceClass("Event") end
		
		local nodesFolder   = workspace:FindFirstChild("Nodes")
		local plantsFolder  = workspace:FindFirstChild("Plants")
		local dropsFolder   = workspace:FindFirstChild("Drops")
		local animalsFolder = workspace:FindFirstChild("Animals")
		local miltaryFolder = workspace:FindFirstChild("Military")
		local eventsFolder  = workspace:FindFirstChild("Events")
		local basesFolder   = workspace:FindFirstChild("Bases")
		local lonersFolder  = basesFolder and basesFolder:FindFirstChild("Loners")

        local hrpPos = nil
        if character and character:FindFirstChild("HumanoidRootPart") then
            hrpPos = character.HumanoidRootPart.Position
        end

		for key, data in pairs(drawings) do
			local isAlive = false
			pcall(function()
				if data.modelInstance and data.modelInstance.Parent ~= nil then
					isAlive = true
				elseif data.mainPart and data.mainPart.Parent ~= nil then
					isAlive = true
				elseif not data.modelInstance and not data.mainPart and data.optionalPivotPos then
					isAlive = true
				end

                if isAlive and data.config and data.config.toggleKey then
                    if safeGetValue(data.config.toggleKey, true) == false then
                        isAlive = false
                    end
                end

                if isAlive and hrpPos then
                    local hPos = data.mainPart and data.mainPart.Position or data.optionalPivotPos
                    if hPos then
                        local dist = (hPos - hrpPos).Magnitude * 0.28
                        local maxDist = 5000

                        if data.resourceClass == "Node" then maxDist = safeGetValue("node_max_dist", 300)
                        elseif data.resourceClass == "Plant" then maxDist = safeGetValue("plant_max_dist", 300)
                        elseif data.resourceClass == "Crate" then maxDist = safeGetValue("crate_max_dist", 300)
                        elseif data.resourceClass == "Drop" then maxDist = safeGetValue("drop_max_dist", 250)
                        elseif data.resourceClass == "Extra" then maxDist = safeGetValue("extra_max_dist", 300)
                        elseif data.resourceClass == "Animal" then maxDist = safeGetValue("animal_max_dist", 250)
                        elseif data.resourceClass == "NPC" then maxDist = safeGetValue("npc_max_dist", 1500)
                        elseif data.resourceClass == "Event" then maxDist = safeGetValue("event_max_dist", 2500)
                        end

                        if dist > (maxDist + 25) then
                            isAlive = false
                        end
                    end
                end
			end)

			if not isAlive then
				if data.text then 
					data.text.Visible = false
					data.text:Remove() 
                    _G.OldDrawings[data.text] = nil
				end
				drawings[key] = nil
			end
		end
		
		task.wait(0.07)
		
		if nMaster and nodesFolder then
			pcall(function()
				local children = nodesFolder:GetChildren()
				for i, child in ipairs(children) do
					if i % batchSize == 0 then task.wait() end
					local config = nodeConfig[child.Name]
					if config and safeGetValue(config.toggleKey, true) ~= false then
						local mainPart = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart")
						if mainPart then
							local addressKey = getUniqueEntityId(child)
							if addressKey and not drawings[addressKey] then 
								drawings[addressKey] = { mainPart = mainPart, modelInstance = child, text = createText(), typeName = child.Name, resourceClass = "Node", config = config }
							end
						end
					end
				end
			end)
		end
		
		task.wait(0.07)
		
		if pMaster and plantsFolder then
			pcall(function()
				local children = plantsFolder:GetChildren()
				for i, child in ipairs(children) do
					if i % batchSize == 0 then task.wait() end
					local config = plantConfig[child.Name]
					if config and safeGetValue(config.toggleKey, true) ~= false then
						local mainPart = child:FindFirstChild("Main")
						if mainPart and mainPart:IsA("MeshPart") then
							local addressKey = getUniqueEntityId(child)
							if addressKey and not drawings[addressKey] then
								drawings[addressKey] = { mainPart = mainPart, modelInstance = child, text = createText(), typeName = child.Name, resourceClass = "Plant", config = config }
							end
						end
					end
				end
			end)
		end

		task.wait(0.07)

		if lonersFolder then
			pcall(function()
				local children = lonersFolder:GetChildren()
				for i, child in ipairs(children) do
					if i % batchSize == 0 then task.wait() end
					local name = child.Name
					local isCrateTracked = crateConfig[name] and safeGetValue(crateConfig[name].toggleKey, true) ~= false
					local isExtraTracked = extraPageConfig[name] and safeGetValue(extraPageConfig[name].toggleKey, true) ~= false
					
					if isCrateTracked or isExtraTracked then
						if child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart") then
							local desc = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart")
							local cType = isCrateTracked and "Crate" or "Extra"
							local conf = isCrateTracked and crateConfig[name] or extraPageConfig[name]
							
							local addressKey = getUniqueEntityId(child)
							if addressKey and not drawings[addressKey] then
								drawings[addressKey] = { mainPart = desc, modelInstance = child, text = createText(), typeName = name, resourceClass = cType, config = conf }
							end
						else
							for _, actualItem in ipairs(child:GetChildren()) do
								local desc = actualItem:FindFirstChild("Main") or actualItem:FindFirstChildWhichIsA("BasePart", true)
								local pivotFallbackPos = nil
								
								if not desc and actualItem:IsA("Model") then
									local success, pivot = pcall(function() return actualItem:GetPivot() end)
									if success and pivot then pivotFallbackPos = pivot.Position end
								end
								
								if desc or pivotFallbackPos then
									local cType = isCrateTracked and "Crate" or "Extra"
									local conf = isCrateTracked and crateConfig[name] or extraPageConfig[name]
									
									local addressKey = getUniqueEntityId(actualItem)
									if addressKey and not drawings[addressKey] then
										drawings[addressKey] = { 
											mainPart = desc, 
											modelInstance = actualItem,
											text = createText(), 
											typeName = name, 
											resourceClass = cType, 
											config = conf,
											optionalPivotPos = pivotFallbackPos 
										}
									end
								end
							end
						end
					end
				end
			end)
		end

		task.wait(0.07)

		if dMaster and dropsFolder then
			pcall(function()
				local children = dropsFolder:GetChildren()
				for i, child in ipairs(children) do
					if i % batchSize == 0 then task.wait() end
					local targetPart = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart") or (child:IsA("BasePart") and child)
					local pivotFallbackPos = nil
					if not targetPart and child:IsA("Model") then
						local success, pivot = pcall(function() return child:GetPivot() end)
						if success and pivot then pivotFallbackPos = pivot.Position end
					end
					
					if targetPart or pivotFallbackPos then
						local addressKey = getUniqueEntityId(child)
						if addressKey and not drawings[addressKey] then
							drawings[addressKey] = { mainPart = targetPart, modelInstance = child, text = createText(), typeName = child.Name, resourceClass = "Drop", optionalPivotPos = pivotFallbackPos }
						end
					end
				end
			end)
		end

		task.wait(0.07)

		if aMaster and animalsFolder then
			pcall(function()
				local children = animalsFolder:GetChildren()
				for i, child in ipairs(children) do
					if i % batchSize == 0 then task.wait() end
					local config = animalConfig[child.Name]
					if config and safeGetValue(config.toggleKey, true) ~= false then
						local detail = child:FindFirstChild("Detail")
						local rootPart = detail and detail:FindFirstChild("RootPart")
						local humanoid = child:FindFirstChildWhichIsA("Humanoid") or (detail and detail:FindFirstChildWhichIsA("Humanoid"))
						
						if rootPart and rootPart:IsA("BasePart") then
							local addressKey = getUniqueEntityId(child)
							if addressKey and not drawings[addressKey] then
								drawings[addressKey] = { mainPart = rootPart, modelInstance = child, text = createText(), typeName = child.Name, resourceClass = "Animal", humanoid = humanoid, config = config }
							end
						end
					end
				end
			end)
		end

		task.wait(0.07)

		if npcMaster and miltaryFolder then
			pcall(function()
				for _, locName in ipairs(locationList) do
					if isLocationActive(locName) then
						local locObj = miltaryFolder:FindFirstChild(locName)
						if locObj then
							local children = locObj:GetChildren()
							for i, object in ipairs(children) do
								if i % batchSize == 0 then task.wait() end
								if object.Name == "Soldier" then
									local headPart = object:FindFirstChild("Head") or object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart")
									local humanoid = object:FindFirstChildWhichIsA("Humanoid")
									
									if headPart then
										local addressKey = getUniqueEntityId(object)
										if addressKey and not drawings[addressKey] then
											drawings[addressKey] = { 
												mainPart = headPart, 
												modelInstance = object,
												text = createText(), 
												typeName = "Soldier", 
												resourceClass = "NPC", 
												humanoid = humanoid, 
												location = locName 
											}
										end
									end
								end
							end
						end
					end
				end
			end)
		end

		task.wait(0.07)

		if eventMaster then
			pcall(function()
				if safeGetValue(bossConfig["Bruno"].toggleKey, true) ~= false and miltaryFolder then
					local rfFolder = miltaryFolder:FindFirstChild("Rocket Factory")
					local barracksFolder = miltaryFolder:FindFirstChild("Military Barracks")
					local brunoObj = (rfFolder and rfFolder:FindFirstChild("Bruno")) or (barracksFolder and barracksFolder:FindFirstChild("Bruno"))
					if brunoObj then
						local headPart = brunoObj:FindFirstChild("Head") or brunoObj:FindFirstChildWhichIsA("BasePart")
						local humanoid = brunoObj:FindFirstChildWhichIsA("Humanoid")
						local addressKey = getUniqueEntityId(brunoObj)
						if headPart and addressKey and not drawings[addressKey] then
							drawings[addressKey] = { mainPart = headPart, modelInstance = brunoObj, text = createText(), typeName = "Bruno", resourceClass = "Event", humanoid = humanoid, config = bossConfig["Bruno"] }
						end
					end
				end

				if safeGetValue(bossConfig["Brutus"].toggleKey, true) ~= false and miltaryFolder then
					local ipFolder = miltaryFolder:FindFirstChild("Industrial Port")
					local brutusObj = ipFolder and ipFolder:FindFirstChild("Brutus")
					if brutusObj then
						local headPart = brutusObj:FindFirstChild("Head") or brutusObj:FindFirstChildWhichIsA("BasePart")
						local humanoid = brutusObj:FindFirstChildWhichIsA("Humanoid")
						local addressKey = getUniqueEntityId(brutusObj)
						if headPart and addressKey and not drawings[addressKey] then
							drawings[addressKey] = { mainPart = headPart, modelInstance = brutusObj, text = createText(), typeName = "Brutus", resourceClass = "Event", humanoid = humanoid, config = bossConfig["Brutus"] }
						end
					end
				end

				if safeGetValue(bossConfig["Boris"].toggleKey, true) ~= false and miltaryFolder then
					local labsFolder = miltaryFolder:FindFirstChild("Labs")
					local borisObj = labsFolder and labsFolder:FindFirstChild("Boris")
					if borisObj then
						local headPart = borisObj:FindFirstChild("Head") or borisObj:FindFirstChildWhichIsA("BasePart")
						local humanoid = borisObj:FindFirstChildWhichIsA("Humanoid")
						local addressKey = getUniqueEntityId(borisObj)
						if headPart and addressKey and not drawings[addressKey] then
							drawings[addressKey] = { mainPart = headPart, modelInstance = borisObj, text = createText(), typeName = "Boris", resourceClass = "Event", humanoid = humanoid, config = bossConfig["Boris"] }
						end
					end
				end

				if safeGetValue(bossConfig["BTR"].toggleKey, true) ~= false and eventsFolder then
					local btrObj = eventsFolder:FindFirstChild("BTR")
					if btrObj then
						local hrpPart = btrObj:FindFirstChild("HumanoidRootPart") or btrObj:FindFirstChildWhichIsA("BasePart")
						local humanoid = btrObj:FindFirstChildWhichIsA("Humanoid") or btrObj:FindFirstChild("Humanoid")
						local addressKey = getUniqueEntityId(btrObj)
						if hrpPart and addressKey and not drawings[addressKey] then
							drawings[addressKey] = { mainPart = hrpPart, modelInstance = btrObj, text = createText(), typeName = "BTR", resourceClass = "Event", humanoid = humanoid, config = bossConfig["BTR"] }
						end
					end
				end
			end)
		end
	end
end)

task.spawn(function()
	while isRunning do
		task.wait(1.0)
        local batchSize = math.max(1, safeGetValue("esp_load_speed", 10))
		
		if safeGetValue("act_mod_alert", true) == true then
			local namesFound = {}
			local seen = {}
			
			pcall(function()
				for _, p in ipairs(Players:GetPlayers()) do
					local matched = false
					local pId = tonumber(p.UserId) or 0
					
					if moderatorIds[pId] or moderatorNames[p.Name] or (p.DisplayName and moderatorNames[p.DisplayName]) then
						matched = true
					else
						local lowerName = (p.Name or ""):lower()
						local lowerDisplay = (p.DisplayName or ""):lower()
						if lowerName:find("mod") or lowerName:find("admin") or lowerName:find("staff") or lowerDisplay:find("mod") or lowerDisplay:find("admin") or lowerDisplay:find("staff") then
							matched = true
						end
					end
					
					if matched and not seen[p.Name] then
						seen[p.Name] = true
						table.insert(namesFound, p.Name)
					end
				end
			end)

			pcall(function()
				local wsChildren = workspace:GetChildren()
				for i, obj in ipairs(wsChildren) do
					if i % batchSize == 0 then task.wait() end
					if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
						if moderatorNames[obj.Name] and not seen[obj.Name] then
							seen[obj.Name] = true
							table.insert(namesFound, obj.Name .. " (Ghost)")
						end
					end
				end
			end)
			
			if #namesFound > 0 then
				blinkState = not blinkState
				
				if blinkState then
					local fullText = "ACTIVE MOD: " .. table.concat(namesFound, ", ")
					overlayText.Text = fullText
					
					local currentSize = safeGetValue("script_text_size", 13)
					overlayText.Size = currentSize + 2
					
					local viewportSize = Camera and Camera.ViewportSize or Vector2.new(800,600)
					local textBoundsWidth = #fullText * (currentSize * 0.5)
					
					overlayText.Position = Vector2.new(viewportSize.X - textBoundsWidth - 25, 45)
					overlayText.Visible = true
				else
					overlayText.Visible = false
				end
			else
				overlayText.Visible = false
			end
		else
			overlayText.Visible = false
		end
	end
end)

local lastRenderTime = 0

local nodeRenderList   = {}
local plantRenderList  = {}
local crateRenderList  = {}
local dropRenderList   = {}
local extraRenderList  = {}

_G.RenderConnection = RunService.RenderStepped:Connect(function()
    if not isRunning then return end

	local mainSuccess = pcall(function()
		local targetFPS = safeGetValue("script_fps_target", 60)
		local frameBudget = 1 / targetFPS
		local currentTime = os.clock()
		
		if (currentTime - lastRenderTime) < frameBudget then
			return
		end
		lastRenderTime = currentTime

		local lp = Players.LocalPlayer
		local character = lp and lp.Character
		local localHumanoid = character and character:FindFirstChildWhichIsA("Humanoid")
		local hrp = character and character:FindFirstChild("HumanoidRootPart")

		if not hrp or not localHumanoid or localHumanoid.Health <= 0 then 
			return 
		end
		
		local hrpPos = hrp.Position
		local globalTextSize = safeGetValue("script_text_size", 13)

		local nMaster = safeGetValue("node_enabled", false)
		local nName   = safeGetValue("node_name", false)
		local nDist   = safeGetValue("node_distance", false)
		local nMaxC   = safeGetValue("node_max_count", 30)
		local nMaxD   = safeGetValue("node_max_dist", 250)
		
		local pMaster = safeGetValue("plant_enabled", false)
		local pName   = safeGetValue("plant_name", false)
		local pDist   = safeGetValue("plant_distance", false)
		local pMaxC   = safeGetValue("plant_max_count", 30)
		local pMaxD   = safeGetValue("plant_max_dist", 250)

		local cMaster = safeGetValue("crate_enabled", false)
		local cName   = safeGetValue("crate_name", false)
		local cDist   = safeGetValue("crate_distance", false)
		local cMaxC   = safeGetValue("crate_max_count", 30)
		local cMaxD   = safeGetValue("crate_max_dist", 250)

		local dMaster = safeGetValue("drop_enabled", false)
		local dName   = safeGetValue("drop_name", false)
		local dDist   = safeGetValue("drop_distance", false)
		local dMaxC   = safeGetValue("drop_max_count", 30)
		local dMaxD   = safeGetValue("drop_max_dist", 250)

		local eMaster = safeGetValue("extra_enabled", false)
		local eName   = safeGetValue("extra_name", false)
		local eDist   = safeGetValue("extra_distance", false)
		local eMaxC   = safeGetValue("extra_max_count", 30)
		local eMaxD   = safeGetValue("extra_max_dist", 250)

		local aMaster = safeGetValue("animal_enabled", false)
		local aName   = safeGetValue("animal_name", false)
		local aHealth = safeGetValue("animal_health", false)
		local aDist   = safeGetValue("animal_distance", false)
		local aMaxD   = safeGetValue("animal_max_dist", 250)

		local npcMaster = safeGetValue("npc_enabled", false)
		local npcName   = safeGetValue("npc_name", false)
		local npcHealth = safeGetValue("npc_health", false)
		local npcDist   = safeGetValue("npc_distance", false)
		local npcMaxD   = safeGetValue("npc_max_dist", 500)

		local eventMaster = safeGetValue("event_enabled", false)
		local eventName   = safeGetValue("event_name", false)
		local eventHealth = safeGetValue("event_health", false)
		local eventDist   = safeGetValue("event_distance", false)
		local eventMaxD   = safeGetValue("event_max_dist", 1500)

        table.clear(nodeRenderList)
        table.clear(plantRenderList)
        table.clear(crateRenderList)
        table.clear(dropRenderList)
        table.clear(extraRenderList)
		
		for key, data in pairs(drawings) do
			if not data.text then continue end
			data.text.Size = globalTextSize
			
			if data.resourceClass == "Node" and not nMaster then data.text.Visible = false continue end
			if data.resourceClass == "Plant" and not pMaster then data.text.Visible = false continue end
			if data.resourceClass == "Crate" and not cMaster then data.text.Visible = false continue end
			if data.resourceClass == "Drop" and not dMaster then data.text.Visible = false continue end
			if data.resourceClass == "Extra" and not eMaster then data.text.Visible = false continue end
			if data.resourceClass == "Animal" and not aMaster then data.text.Visible = false continue end
			if data.resourceClass == "NPC" and not npcMaster then data.text.Visible = false continue end
			if data.resourceClass == "Event" and not eventMaster then data.text.Visible = false continue end
			
			if data.resourceClass == "NPC" then
				if not isLocationActive(data.location) then
					data.text.Visible = false
					continue
				end
			end

			if data.modelInstance and not data.modelInstance.Parent then 
				data.text.Visible = false 
				continue 
			elseif data.mainPart and not data.mainPart.Parent then 
				data.text.Visible = false 
				continue 
			elseif not data.mainPart and not data.modelInstance and not data.optionalPivotPos then
				data.text.Visible = false
				continue
			end

			local hPos = data.mainPart and data.mainPart.Position or data.optionalPivotPos
			
			if hPos then
				local studsDist = (hPos - hrpPos).Magnitude
				local realMeters = studsDist * 0.28
				
				if data.resourceClass == "Node" then
					if data.config and safeGetValue(data.config.toggleKey, true) ~= false and realMeters <= nMaxD then
						table.insert(nodeRenderList, { data = data, distance = realMeters, position = hPos, nameOpt = nName, distOpt = nDist })
					else data.text.Visible = false end
					
				elseif data.resourceClass == "Plant" then
					if data.config and safeGetValue(data.config.toggleKey, true) ~= false and realMeters <= pMaxD then
						table.insert(plantRenderList, { data = data, distance = realMeters, position = hPos, nameOpt = pName, distOpt = pDist })
					else data.text.Visible = false end

				elseif data.resourceClass == "Crate" then
					if data.config and safeGetValue(data.config.toggleKey, true) ~= false and realMeters <= cMaxD then
						table.insert(crateRenderList, { data = data, distance = realMeters, position = hPos, nameOpt = cName, distOpt = cDist })
					else data.text.Visible = false end

				elseif data.resourceClass == "Drop" then
					if realMeters <= dMaxD then
						table.insert(dropRenderList, { data = data, distance = realMeters, position = hPos, nameOpt = dName, distOpt = dDist })
					else data.text.Visible = false end

				elseif data.resourceClass == "Extra" then
					if data.config and safeGetValue(data.config.toggleKey, true) ~= false and realMeters <= eMaxD then
						table.insert(extraRenderList, { data = data, distance = realMeters, position = hPos, nameOpt = eName, distOpt = eDist })
					else data.text.Visible = false end

				elseif data.resourceClass == "Animal" then
					if data.config and safeGetValue(data.config.toggleKey, true) ~= false and realMeters <= aMaxD then
						local pos, onScreen = WorldToScreen(hPos + Vector3.new(0, 4, 0))
						
						if onScreen and pos then
							local elements = {}
							if aName then table.insert(elements, data.config.label) end
							if aHealth then table.insert(elements, string.format("(%d HP)", math.floor((data.humanoid and data.humanoid.Parent) and data.humanoid.Health or 100))) end
							if aDist then table.insert(elements, string.format("[%dm]", math.floor(realMeters))) end
							
							local str = table.concat(elements, " ")
							if str == "" then data.text.Visible = false else
								data.text.Text = str
								data.text.Color = getLiveColor(data.config.colorKey, data.config.r, data.config.g, data.config.b)
								data.text.Position = Vector2.new(pos.X, pos.Y - 10)
								data.text.Visible = true
							end
						else data.text.Visible = false end
					else data.text.Visible = false end

				elseif data.resourceClass == "NPC" then
					if realMeters <= npcMaxD then
						local pos, onScreen = WorldToScreen(hPos + Vector3.new(0, 1.5, 0))
						
						if onScreen and pos then
							local elements = {}
							if npcName then table.insert(elements, "Soldier") end
							if npcHealth then table.insert(elements, string.format("(%d HP)", math.floor((data.humanoid and data.humanoid.Parent) and data.humanoid.Health or 100))) end
							if npcDist then table.insert(elements, string.format("[%dm]", math.floor(realMeters))) end
							
							local str = table.concat(elements, " ")
							if str == "" then data.text.Visible = false else
								data.text.Text = str
								data.text.Color = getLiveColor("col_npc_esp", 1, 0.2, 0.2)
								data.text.Position = Vector2.new(pos.X, pos.Y)
								data.text.Visible = true
							end
						else data.text.Visible = false end
					else data.text.Visible = false end

				elseif data.resourceClass == "Event" then
					if realMeters <= eventMaxD and data.config and safeGetValue(data.config.toggleKey, true) ~= false then
						local heightOffset = (data.typeName == "BTR") and Vector3.new(0, 5, 0) or Vector3.new(0, 1.5, 0)
						local pos, onScreen = WorldToScreen(hPos + heightOffset)
						
						if onScreen and pos then
							local elements = {}
							if eventName then table.insert(elements, data.typeName) end
							if eventHealth then table.insert(elements, string.format("(%d HP)", math.floor((data.humanoid and data.humanoid.Parent) and data.humanoid.Health or 100))) end
							if eventDist then table.insert(elements, string.format("[%dm]", math.floor(realMeters))) end
							
							local str = table.concat(elements, " ")
							if str == "" then data.text.Visible = false else
								data.text.Text = str
								data.text.Color = getLiveColor(data.config.colorKey, data.config.r, data.config.g, data.config.b)
								data.text.Position = Vector2.new(pos.X, pos.Y)
								data.text.Visible = true
							end
						else data.text.Visible = false end
					else data.text.Visible = false end
				end
			else 
				data.text.Visible = false 
			end
		end
		
		if #nodeRenderList > 1 then table.sort(nodeRenderList, function(a, b) return a.distance < b.distance end) end
		if #plantRenderList > 1 then table.sort(plantRenderList, function(a, b) return a.distance < b.distance end) end
		if #crateRenderList > 1 then table.sort(crateRenderList, function(a, b) return a.distance < b.distance end) end
		if #dropRenderList > 1 then table.sort(dropRenderList, function(a, b) return a.distance < b.distance end) end
		if #extraRenderList > 1 then table.sort(extraRenderList, function(a, b) return a.distance < b.distance end) end
		
		for i, item in ipairs(nodeRenderList) do
			if i <= nMaxC then
				local pos, onScreen = WorldToScreen(item.position + Vector3.new(0, 5, 0))
				if onScreen and pos then
					local str = ""
					if item.nameOpt then str = item.data.config.label end
					if item.distOpt then str = (str ~= "" and str .. " [" or "[") .. math.floor(item.distance) .. "m" .. (item.nameOpt and "]" or "]") end
					item.data.text.Text = str
					item.data.text.Color = getLiveColor(item.data.config.colorKey, item.data.config.r, item.data.config.g, item.data.config.b)
					item.data.text.Position = Vector2.new(pos.X, pos.Y - 10)
					item.data.text.Visible = (str ~= "")
				else item.data.text.Visible = false end
			else item.data.text.Visible = false end
		end
		
		for i, item in ipairs(plantRenderList) do
			if i <= pMaxC then
				local pos, onScreen = WorldToScreen(item.position + Vector3.new(0, 5, 0))
				if onScreen and pos then
					local str = ""
					if item.nameOpt then str = item.data.config.label end
					if item.distOpt then str = (str ~= "" and str .. " [" or "[") .. math.floor(item.distance) .. "m" .. (item.nameOpt and "]" or "]") end
					item.data.text.Text = str
					item.data.text.Color = getLiveColor(item.data.config.colorKey, item.data.config.r, item.data.config.g, item.data.config.b)
					item.data.text.Position = Vector2.new(pos.X, pos.Y - 10)
					item.data.text.Visible = (str ~= "")
				else item.data.text.Visible = false end
			else item.data.text.Visible = false end
		end

		for i, item in ipairs(crateRenderList) do
			if i <= cMaxC then
				local pos, onScreen = WorldToScreen(item.position + Vector3.new(0, 3, 0))
				if onScreen and pos then
					local str = ""
					if item.nameOpt then str = item.data.config.label end
					if item.distOpt then str = (str ~= "" and str .. " [" or "[") .. math.floor(item.distance) .. "m" .. (item.nameOpt and "]" or "]") end
					item.data.text.Text = str
					item.data.text.Color = getLiveColor(item.data.config.colorKey, item.data.config.r, item.data.config.g, item.data.config.b)
					item.data.text.Position = Vector2.new(pos.X, pos.Y - 10)
					item.data.text.Visible = (str ~= "")
				else item.data.text.Visible = false end
			else item.data.text.Visible = false end
		end

		for i, item in ipairs(dropRenderList) do
			if i <= dMaxC then
				local pos, onScreen = WorldToScreen(item.position + Vector3.new(0, 1, 0))
				if onScreen and pos then
					local str = ""
					if item.nameOpt then str = item.data.typeName end
					if item.distOpt then str = (str ~= "" and str .. " [" or "[") .. math.floor(item.distance) .. "m" .. (item.nameOpt and "]" or "]") end
					item.data.text.Text = str
					item.data.text.Color = getLiveColor("col_Drop", 240/255, 240/255, 240/255)
					item.data.text.Position = Vector2.new(pos.X, pos.Y - 10)
					item.data.text.Visible = (str ~= "")
				else item.data.text.Visible = false end
			else item.data.text.Visible = false end
		end

		for i, item in ipairs(extraRenderList) do
			if i <= eMaxC then
				local pos, onScreen = WorldToScreen(item.position + Vector3.new(0, 3, 0))
				if onScreen and pos then
					local str = ""
					if item.nameOpt then str = item.data.config.label end
					if item.distOpt then str = (str ~= "" and str .. " [" or "[") .. math.floor(item.distance) .. "m" .. (item.nameOpt and "]" or "]") end
					item.data.text.Text = str
					item.data.text.Color = getLiveColor(item.data.config.colorKey, item.data.config.r, item.data.config.g, item.data.config.b)
					item.data.text.Position = Vector2.new(pos.X, pos.Y - 10)
					item.data.text.Visible = (str ~= "")
				else item.data.text.Visible = false end
			else item.data.text.Visible = false end
		end
	end)
end)
wait(1)
notify("Fallen.lua - version 1.02", "enjoy!", 5)
wait(2)
notify("This is version is being tested you may encounter bugs.", "", 5)
