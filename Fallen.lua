-- Made with AI
-- New mod list (Credit to code.leak for the old one)

local CoreGui    = game:GetService("CoreGui")
local RunService = game:GetService("RunService")
local Players    = game:GetService("Players")
local Camera     = workspace.CurrentCamera

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
        for textObj in pairs(_G.OldDrawings) do
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
    _G.Drawing = {
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
                        if k == "Visible"  then label.Visible = v
                        elseif k == "Text"     then label.Text = v
                        elseif k == "Position" then label.Position = UDim2.new(0, v.X, 0, v.Y)
                        elseif k == "Color"    then label.TextColor3 = v
                        elseif k == "Size"     then label.TextSize = v
                        elseif k == "Center"   then label.AnchorPoint = v and Vector2.new(0.5,0) or Vector2.new(0,0)
                        elseif k == "Outline"  then label.TextStrokeTransparency = v and 0 or 1
                        end
                    end,
                    __index = function(_, k)
                        if k == "Remove" then return function() label:Destroy() end end
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

local function safeGetValue(valName, fallback)
    if typeof(UI) == "table" and UI.GetValue then
        local val = UI.GetValue(valName)
        if val ~= nil then return val end
    end
    return fallback
end

local instanceIdCache = {}

local function getId(instance)
    local addr = instance.Address
    if safeGetValue("use_id_cache", true) then
        local cached = instanceIdCache[addr]
        if cached then return cached end
        local id = tostring(addr)
        instanceIdCache[addr] = id
        return id
    else
        return tostring(addr)
    end
end

local moderatorNames = {
    ["KittenBagelz"]="Game Moderator", ["Rikumah"]="Game Moderator",
    ["DopeIlI"]="Game Moderator", ["chancerocke"]="Game Moderator",
    ["Lexi34567812"]="Game Moderator", ["puferyba"]="Game Moderator",
    ["gamerofdestroyers"]="Game Moderator", ["aidenas2011"]="Game Moderator",
    ["owner12310"]="Game Moderator", ["Chinyro"]="Game Moderator",
    ["Fan_hellrider"]="Game Moderator", ["imghostoma"]="Game Moderator",
    ["Hakob_8w8"]="Game Moderator", ["Sotojulio06"]="Game Moderator",
    ["ilovetowerbattle_9"]="Game Moderator", ["Hsixienn"]="Game Moderator",
    ["coolboyofawsome4"]="Game Moderator", ["redbullgivesu_WINGS4"]="Game Moderator",
    ["Kitty_1624"]="Game Moderator", ["GamerMauriiYT"]="Game Moderator",
    ["Bajoogies_XD"]="Game Moderator", ["Xion_Light"]="Game Moderator",
    ["Kaz_Elite"]="Game Moderator", ["hello_myfriends45"]="Game Moderator",
    ["chrisatmfan21"]="Game Moderator", ["joax009617"]="Game Moderator",
    ["AaronElagant"]="Game Moderator", ["Prye4"]="Game Moderator",
    ["Puhgee"]="Game Moderator", ["roblox_23193"]="Game Moderator",
    ["fearedbyvamp"]="Game Moderator", ["3verIast"]="Game Moderator",
    ["harrib_allsack54321"]="Game Moderator", ["Matheus06532"]="Game Moderator",
    ["B_BEAMO"]="Game Moderator", ["fordjdj12"]="Game Moderator",
    ["sirfluf"]="Game Moderator", ["Weerdeeg"]="Game Moderator",
    ["giovannirv2"]="Game Moderator", ["Waitwhatb40"]="Game Moderator",
    ["kerub131"]="Game Moderator", ["rashhhh2"]="Game Moderator",
    ["DontTouchZGrass"]="Game Moderator", ["matheu09173"]="Game Moderator",
    ["jostjohnyca"]="Game Moderator", ["krisidisi23"]="Game Moderator",
    ["MetaSile"]="Game Moderator", ["1Newy1"]="Game Moderator",
    ["YTGonzo"]="Contribution", ["AsianAbrex"]="Lead Developer",
    ["Warm_Vibes"]="Lead Developer", ["ChickenBagelz"]="Co-Founder",
    ["neddleduck"]="Founder",
}
local moderatorIds = {
    [51281722]="Game Moderator", [7178750309]="Game Moderator",
    [113179883]="Game Moderator", [3122439095]="Game Moderator",
    [991290934]="Game Moderator", [3968854760]="Game Moderator",
    [114812725]="Game Moderator", [81993536]="Game Moderator",
    [1004214871]="Game Moderator", [914847610]="Game Moderator",
    [3034930770]="Game Moderator", [1622256215]="Game Moderator",
    [1116486172]="Game Moderator", [4252853044]="Game Moderator",
    [2364950171]="Game Moderator", [1528346843]="Game Moderator",
    [165053216]="Game Moderator", [9024231578]="Game Moderator",
    [1127954045]="Game Moderator", [3640120679]="Game Moderator",
    [602009251]="Game Moderator", [372791101]="Game Moderator",
    [1378169111]="Game Moderator", [3020799797]="Game Moderator",
    [372528624]="Game Moderator", [2567998467]="Game Moderator",
    [4243907215]="Game Moderator", [813030262]="Game Moderator",
    [353983652]="Game Moderator", [1406181681]="Game Moderator",
    [2229169589]="Game Moderator", [30934698]="Game Moderator",
    [3004094651]="Game Moderator", [839333692]="Game Moderator",
    [979624578]="Game Moderator", [1478885961]="Game Moderator",
    [399754916]="Game Moderator", [1193091081]="Game Moderator",
    [4553863490]="Game Moderator", [4225513035]="Game Moderator",
    [41482597]="Game Moderator", [2924549627]="Game Moderator",
    [2732967856]="Game Moderator", [1937516999]="Game Moderator",
    [1374319325]="Game Moderator", [1058831985]="Game Moderator",
    [9621064456]="Game Moderator", [584370127]="Game Moderator",
    [174212818]="Contribution", [25548179]="Lead Developer",
    [363101315]="Lead Developer", [47983795]="Co-Founder",
    [16681869]="Founder",
}

local overlayText = Drawing.new("Text")
overlayText.Color   = Color3.fromRGB(255, 255, 255)
overlayText.Outline = true
overlayText.Center  = false
overlayText.Font    = Drawing.Fonts.System
overlayText.Visible = false
_G.OldDrawings[overlayText] = true

local COLOR_WHITE = Color3.fromRGB(255, 255, 255)
local COLOR_DROP  = Color3.fromRGB(240, 240, 240)
local COLOR_NPC   = Color3.fromRGB(255, 51,  51)

local blinkState      = true
local hasNotifiedMod  = false
local ghostCheckTimer = 0

local plantConfig = {
    ["Wool Plant"]      ={toggleKey="filter_Wool",     colorKey="col_Wool",     label="Wool",      r=215/255,g=207/255,b=207/255},
    ["Corn Plant"]      ={toggleKey="filter_Corn",     colorKey="col_Corn",     label="Corn",      r=255/255,g=237/255,b=0/255  },
    ["Lemon Plant"]     ={toggleKey="filter_Lemon",    colorKey="col_Lemon",    label="Lemon",     r=255/255,g=255/255,b=0/255  },
    ["Tomato Plant"]    ={toggleKey="filter_Tomato",   colorKey="col_Tomato",   label="Tomato",    r=255/255,g=0/255,  b=0/255  },
    ["Pumpkin Plant"]   ={toggleKey="filter_Pumpkin",  colorKey="col_Pumpkin",  label="Pumpkin",   r=255/255,g=175/255,b=0/255  },
    ["Blueberry Plant"] ={toggleKey="filter_Blueberry",colorKey="col_Blueberry",label="Blueberry", r=0/255,  g=100/255,b=255/255},
    ["Raspberry Plant"] ={toggleKey="filter_Raspberry",colorKey="col_Raspberry",label="Raspberry", r=255/255,g=75/255, b=100/255},
}
local nodeConfig = {
    ["Stone_Node"]     ={toggleKey="filter_Stone",colorKey="col_Stone",label="Stone Node",r=140/255,g=140/255,b=140/255},
    ["Metal_Node"]     ={toggleKey="filter_Metal",colorKey="col_Metal",label="Metal Node",r=185/255,g=140/255,b=100/255},
    ["Phosphate_Node"] ={toggleKey="filter_Phos", colorKey="col_Phos", label="Phos Node", r=200/255,g=170/255,b=0/255  },
}
local crateConfig = {
    ["Food Crate"]          ={toggleKey="filter_FoodCrate",        colorKey="col_FoodCrate",        label="Food Crate",         r=255/255,g=150/255,b=50/255 },
    ["Wooden Crate"]        ={toggleKey="filter_WoodenCrate",      colorKey="col_WoodenCrate",      label="Wooden Crate",       r=160/255,g=120/255,b=90/255 },
    ["Locked Wooden Crate"] ={toggleKey="filter_LockedWoodenCrate",colorKey="col_LockedWoodenCrate",label="Locked Wooden Crate",r=130/255,g=90/255, b=60/255 },
    ["Locked Metal Crate"]  ={toggleKey="filter_LockedMetalCrate", colorKey="col_LockedMetalCrate", label="Locked Metal Crate", r=140/255,g=150/255,b=160/255},
    ["Locked Steel Crate"]  ={toggleKey="filter_LockedSteelCrate", colorKey="col_LockedSteelCrate", label="Locked Steel Crate", r=100/255,g=180/255,b=220/255},
    ["Timed Crate"]         ={toggleKey="filter_TimedCrate",       colorKey="col_TimedCrate",       label="Timed Crate",        r=240/255,g=70/255, b=70/255 },
    ["Care Package"]        ={toggleKey="filter_CarePackage",      colorKey="col_CarePackage",      label="Care Package",       r=230/255,g=220/255,b=50/255 },
    ["Trash Can"]           ={toggleKey="filter_TrashCan",         colorKey="col_TrashCan",         label="Trash Can",          r=120/255,g=120/255,b=120/255},
    ["Oil Barrel"]          ={toggleKey="filter_OilBarrel",        colorKey="col_OilBarrel",        label="Oil Barrel",         r=60/255, g=60/255, b=60/255 },
}
local extraPageConfig = {
    ["Sleeper"]           ={toggleKey="filter_Sleeper",    colorKey="col_Sleeper",    label="Sleeper",           r=210/255,g=180/255,b=140/255},
    ["Salvaged Flycopter"]={toggleKey="filter_Flycopter",  colorKey="col_Flycopter",  label="Salvaged Flycopter",r=50/255, g=220/255,b=220/255},
    ["Wooden Boat"]       ={toggleKey="filter_WoodenBoat", colorKey="col_WoodenBoat", label="Wooden Boat",       r=150/255,g=110/255,b=80/255 },
    ["Military Boat"]     ={toggleKey="filter_MilitaryBoat",colorKey="col_MilitaryBoat",label="Military Boat",   r=60/255, g=120/255,b=60/255 },
    ["Body Bag"]          ={toggleKey="filter_BodyBag",    colorKey="col_BodyBag",    label="Body Bag",          r=180/255,g=30/255, b=30/255 },
}
local animalConfig = {
    ["PREFAB_ANIMAL_DEER"]    ={toggleKey="filter_Deer",colorKey="col_Deer",label="Deer",r=190/255,g=130/255,b=80/255 },
    ["PREFAB_ANIMAL_WILDBOAR"]={toggleKey="filter_Boar",colorKey="col_Boar",label="Boar",r=130/255,g=100/255,b=80/255 },
    ["PREFAB_ANIMAL_WOLF"]    ={toggleKey="filter_Wolf",colorKey="col_Wolf",label="Wolf",r=160/255,g=160/255,b=170/255},
}
local bossConfig = {
    ["Bruno"] ={toggleKey="filter_Boss_Bruno", colorKey="col_Boss_Bruno", label="Bruno", r=1,g=1,b=1},
    ["Brutus"]={toggleKey="filter_Boss_Brutus",colorKey="col_Boss_Brutus",label="Brutus",r=1,g=1,b=1},
    ["Boris"] ={toggleKey="filter_Boss_Boris", colorKey="col_Boss_Boris", label="Boris", r=1,g=1,b=1},
    ["BTR"]   ={toggleKey="filter_Boss_BTR",   colorKey="col_Boss_BTR",   label="BTR",   r=1,g=1,b=1},
}
local locationList = {
    "Abandoned Bunker","Military Airfield","Military Base","Military Barracks",
    "Rocket Factory","Industrial Port","Cargo Yard","Labs","Submarine",
    "ConvoyOne","ConvoyTwo","ConvoyThree","ConvoyFour",
}

if typeof(UI) == "table" and UI.AddTab then
    UI.AddTab("Fallen", function(tab)
        local sec = tab:Section("ESP Configurations","Left",{"Nodes","Plants","Crates","Drops","Extra"},450)

        if sec.page == 0 then
            sec:Toggle("node_enabled","Enabled")
            sec:Toggle("node_name","Name ESP")
            sec:Toggle("node_distance","Distance ESP")
            sec:SliderInt("node_max_count","Max Nodes",1,75,30)
            sec:SliderInt("node_max_dist","Max Distance",0,500,250)
            sec:Spacing()
            sec:Text("Nodes Filter:")
            for _,name in ipairs({"Stone_Node","Metal_Node","Phosphate_Node"}) do
                local c=nodeConfig[name]; sec:Toggle(c.toggleKey,c.label,true); sec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
            end
        elseif sec.page == 1 then
            sec:Toggle("plant_enabled","Enabled")
            sec:Toggle("plant_name","Name ESP")
            sec:Toggle("plant_distance","Distance ESP")
            sec:SliderInt("plant_max_count","Max Plants",1,75,30)
            sec:SliderInt("plant_max_dist","Max Distance",0,500,250)
            sec:Spacing()
            sec:Text("Plants Filter:")
            for _,name in ipairs({"Wool Plant","Corn Plant","Lemon Plant","Tomato Plant","Pumpkin Plant","Blueberry Plant","Raspberry Plant"}) do
                local c=plantConfig[name]; sec:Toggle(c.toggleKey,name,true); sec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
            end
        elseif sec.page == 2 then
            sec:Toggle("crate_enabled","Enabled")
            sec:Toggle("crate_name","Name ESP")
            sec:Toggle("crate_distance","Distance ESP")
            sec:SliderInt("crate_max_count","Max Crates",1,75,30)
            sec:SliderInt("crate_max_dist","Max Distance",0,2500,250)
            sec:Spacing()
            sec:Text("Crate Filters:")
            for _,name in ipairs({"Food Crate","Wooden Crate","Locked Wooden Crate","Locked Metal Crate","Locked Steel Crate","Timed Crate"}) do
                local c=crateConfig[name]; sec:Toggle(c.toggleKey,name,true); sec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
            end
            sec:Spacing(); sec:Text("Extra")
            for _,name in ipairs({"Care Package","Trash Can","Oil Barrel"}) do
                local c=crateConfig[name]; sec:Toggle(c.toggleKey,name,true); sec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
            end
        elseif sec.page == 3 then
            sec:Toggle("drop_enabled","Enabled")
            sec:ColorPicker("col_Drop",240/255,240/255,240/255,1)
            sec:Toggle("drop_name","Name ESP")
            sec:Toggle("drop_distance","Distance ESP")
            sec:SliderInt("drop_max_count","Max Drops",1,75,30)
            sec:SliderInt("drop_max_dist","Max Distance",1,500,250)
        elseif sec.page == 4 then
            sec:Toggle("extra_enabled","Enabled")
            sec:Toggle("extra_name","Name ESP")
            sec:Toggle("extra_distance","Distance ESP")
            sec:SliderInt("extra_max_count","Max Extra Objects",1,75,30)
            sec:SliderInt("extra_max_dist","Max Distance",0,500,250)
            sec:Spacing(); sec:Text("Extra Filters:")
            for _,name in ipairs({"Sleeper","Salvaged Flycopter","Wooden Boat","Military Boat","Body Bag"}) do
                local c=extraPageConfig[name]; sec:Toggle(c.toggleKey,name,true); sec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
            end
        end

        local animSec = tab:Section("Animals","Left",nil,320)
        animSec:Toggle("animal_enabled","Enabled")
        animSec:Toggle("animal_name","Name ESP")
        animSec:Toggle("animal_health","Health ESP")
        animSec:Toggle("animal_distance","Distance ESP")
        animSec:SliderInt("animal_max_dist","Max Distance",1,500,250)
        animSec:Spacing(); animSec:Text("Animals Filter:")
        for _,rn in ipairs({"PREFAB_ANIMAL_DEER","PREFAB_ANIMAL_WILDBOAR","PREFAB_ANIMAL_WOLF"}) do
            local c=animalConfig[rn]; animSec:Toggle(c.toggleKey,c.label,true); animSec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
        end

        local cacheSec = tab:Section("ID Caching","Left",nil,280)
        cacheSec:Toggle("use_id_cache","Cache Object IDs (Better FPS)",true)
        cacheSec:Spacing()
        cacheSec:Text("ON - Slightly Better FPS (For me atleast)")
        cacheSec:Text("Object IDs are remembered so the script doesnt")
        cacheSec:Text("look them up every scan. Very rarely an object that")
        cacheSec:Text("respawns may show the wrong label (e.g. a tree")
        cacheSec:Text("showing as Salvaged Flycopter). Toggle OFF to fix.")
        cacheSec:Spacing()
        cacheSec:Text("OFF - Accurate labels always (Maybe)")
        cacheSec:Text("IDs looked up fresh every scan so recycled memory")
        cacheSec:Text("addresses should never cause wrong labels.")

        local modAlertSec = tab:Section("Staff Alerts","Left",nil,120)
        modAlertSec:Toggle("act_mod_alert","Active Mod Alert",true)
        modAlertSec:Text("Credit to code.leak for the mod list")

        local rightSec = tab:Section("Threat Management","Right",{"NPCs","Locations"},450)
        if rightSec.page == 0 then
            rightSec:Toggle("npc_enabled","Enabled")
            rightSec:ColorPicker("col_npc_esp",255/255,50/255,50/255,1)
            rightSec:Toggle("npc_name","Name")
            rightSec:Toggle("npc_health","Health")
            rightSec:Toggle("npc_distance","Distance")
            rightSec:SliderInt("npc_max_dist","Max Distance",1,5000,500)
        elseif rightSec.page == 1 then
            rightSec:Toggle("loc_all","All",false)
            rightSec:Spacing(); rightSec:Text("Location Filter:")
            for _,locName in ipairs(locationList) do
                rightSec:Toggle("loc_filter_"..locName:gsub(" ",""),locName,false)
            end
        end

        local eventSec = tab:Section("Events","Right",nil,360)
        eventSec:Toggle("event_enabled","Enabled")
        eventSec:Toggle("event_name","Name")
        eventSec:Toggle("event_health","Health")
        eventSec:Toggle("event_distance","Distance")
        eventSec:SliderInt("event_max_dist","Max Distance",1,5000,1500)
        eventSec:Spacing(); eventSec:Text("Event Filter:")
        for _,bName in ipairs({"Bruno","Brutus","Boris","BTR"}) do
            local c=bossConfig[bName]; eventSec:Toggle(c.toggleKey,bName,true); eventSec:ColorPicker(c.colorKey,c.r,c.g,c.b,1)
        end

        local settingsSec = tab:Section("Settings","Right",nil,480)
        settingsSec:Text("Font Style")
        settingsSec:Combo("esp_font","ESP Font",{"Noto San","System Bold","Minecraft","Pixel","Proggy Clean","Jetbrains","Sentinel","Tahoma"},0)
        settingsSec:Spacing()
        settingsSec:SliderInt("script_text_size","Text Size",10,32,13)
        settingsSec:Spacing()
        settingsSec:Text("Load Speed: Objects scanned per tick.")
        settingsSec:Text("Turn down if script freezes or crashes.")
        settingsSec:SliderInt("esp_load_speed","ESP Load Speed",1,50,10)
        settingsSec:Spacing()
        settingsSec:Text("Respawn Delay: Seconds to wait after you respawn.")
        settingsSec:SliderInt("respawn_delay","Respawn Delay (Seconds)",1,5,2)
        settingsSec:Spacing()
        settingsSec:Text("Script FPS: Caps how fast ESP text updates on screen.")
        settingsSec:SliderInt("script_fps_target","Script Fps",30,240,60)

    end)
end

local drawings = {}

local function createText()
    local text = Drawing.new("Text")
    text.Size    = safeGetValue("script_text_size", 16)
    text.Center  = true
    text.Outline = true
    text.Color   = COLOR_WHITE
    text.Font    = Drawing.Fonts.System
    text.Visible = false
    _G.OldDrawings[text] = true
    return text
end

local function getLiveColor(colorKey, defaultR, defaultG, defaultB, colorCache)
    local cached = colorCache[colorKey]
    if cached then return cached end
    local r, g, b
    if typeof(UI) == "table" then
        r, g, b = UI.GetValue(colorKey)
    end
    r = r or defaultR; g = g or defaultG; b = b or defaultB
    local result = Color3.fromRGB(math.floor(r*255), math.floor(g*255), math.floor(b*255))
    colorCache[colorKey] = result
    return result
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
    for _, data in pairs(drawings) do
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
    return UI.GetValue("loc_filter_"..locName:gsub(" ","")) or false
end

task.spawn(function()
    local lp      = Players.LocalPlayer
    local wasDead = false

    while isRunning do
        task.wait(4.0)

        local batchSize = math.max(1, safeGetValue("esp_load_speed", 10))

        if not safeGetValue("use_id_cache", true) then
            table.clear(instanceIdCache)
        end
        local character = lp.Character
        local locHum    = character and character:FindFirstChildWhichIsA("Humanoid")

        if not character or not locHum or locHum.Health <= 0 then
            if not wasDead then wasDead = true; wipeAllDrawings() end
            task.wait(1.0)
            continue
        end

        if wasDead then
            task.wait(safeGetValue("respawn_delay", 3))
            wasDead = false
        end

        local nMaster     = safeGetValue("node_enabled",   false)
        local pMaster     = safeGetValue("plant_enabled",  false)
        local cMaster     = safeGetValue("crate_enabled",  false)
        local dMaster     = safeGetValue("drop_enabled",   false)
        local eMaster     = safeGetValue("extra_enabled",  false)
        local aMaster     = safeGetValue("animal_enabled", false)
        local npcMaster   = safeGetValue("npc_enabled",    false)
        local eventMaster = safeGetValue("event_enabled",  false)

        if not nMaster     then wipeResourceClass("Node")   end
        if not pMaster     then wipeResourceClass("Plant")  end
        if not cMaster     then wipeResourceClass("Crate")  end
        if not dMaster     then wipeResourceClass("Drop")   end
        if not eMaster     then wipeResourceClass("Extra")  end
        if not aMaster     then wipeResourceClass("Animal") end
        if not npcMaster   then wipeResourceClass("NPC")    end
        if not eventMaster then wipeResourceClass("Event")  end

        local activeNodes,activePlants,activeCrates,activeExtras,activeAnimals,activeEvents = {},{},{},{},{},{}
        if nMaster     then for n,c in pairs(nodeConfig)      do if safeGetValue(c.toggleKey,true)~=false then activeNodes[n]=c   end end end
        if pMaster     then for n,c in pairs(plantConfig)     do if safeGetValue(c.toggleKey,true)~=false then activePlants[n]=c  end end end
        if cMaster     then for n,c in pairs(crateConfig)     do if safeGetValue(c.toggleKey,true)~=false then activeCrates[n]=c  end end end
        if eMaster     then for n,c in pairs(extraPageConfig) do if safeGetValue(c.toggleKey,true)~=false then activeExtras[n]=c  end end end
        if aMaster     then for n,c in pairs(animalConfig)    do if safeGetValue(c.toggleKey,true)~=false then activeAnimals[n]=c end end end
        if eventMaster then for n,c in pairs(bossConfig)      do if safeGetValue(c.toggleKey,true)~=false then activeEvents[n]=c  end end end

        local nodesFolder   = workspace:FindFirstChild("Nodes")
        local plantsFolder  = workspace:FindFirstChild("Plants")
        local dropsFolder   = workspace:FindFirstChild("Drops")
        local animalsFolder = workspace:FindFirstChild("Animals")
        local miltaryFolder = workspace:FindFirstChild("Military")
        local eventsFolder  = workspace:FindFirstChild("Events")
        local basesFolder   = workspace:FindFirstChild("Bases")
        local lonersFolder  = basesFolder and basesFolder:FindFirstChild("Loners")

        local hrpPos = nil
        local hrp    = character:FindFirstChild("HumanoidRootPart")
        if hrp then hrpPos = hrp.Position end

        local nMaxD   = safeGetValue("node_max_dist",   300)
        local pMaxD   = safeGetValue("plant_max_dist",  300)
        local cMaxD   = safeGetValue("crate_max_dist",  300)
        local dMaxD   = safeGetValue("drop_max_dist",   250)
        local eMaxD   = safeGetValue("extra_max_dist",  300)
        local aMaxD   = safeGetValue("animal_max_dist", 250)
        local npcMaxD = safeGetValue("npc_max_dist",    1500)
        local evMaxD  = safeGetValue("event_max_dist",  2500)

        for key, data in pairs(drawings) do
            local isAlive = true

            local parentOk, parentAlive = pcall(function()
                if data.modelInstance then return data.modelInstance.Parent ~= nil end
                if data.mainPart then return data.mainPart.Parent ~= nil end
                if data.optionalPivotPos then return true end
                return false
            end)
            if not parentOk or not parentAlive then isAlive = false end

            if isAlive and data.humanoid then
                local humOk, hp = pcall(function()
                    return data.humanoid.Parent and data.humanoid.Health
                end)
                if not humOk or not hp or hp <= 0 then isAlive = false end
            end

            if isAlive and data.config and data.config.toggleKey then
                if safeGetValue(data.config.toggleKey, true) == false then isAlive = false end
            end

            if isAlive and hrpPos then
                local posOk, hPos = pcall(function()
                    return data.mainPart and data.mainPart.Position or data.optionalPivotPos
                end)
                if posOk and hPos then
                    local dist = (hPos - hrpPos).Magnitude * 0.28
                    local md = 5000
                    local c  = data.resourceClass
                    if     c=="Node"   then md=nMaxD
                    elseif c=="Plant"  then md=pMaxD
                    elseif c=="Crate"  then md=cMaxD
                    elseif c=="Drop"   then md=dMaxD
                    elseif c=="Extra"  then md=eMaxD
                    elseif c=="Animal" then md=aMaxD
                    elseif c=="NPC"    then md=npcMaxD
                    elseif c=="Event"  then md=evMaxD
                    end
                    if dist > md + 25 then isAlive = false end
                end
            end

            if not isAlive then
                pcall(function()
                    if data.text then
                        data.text.Visible = false
                        data.text:Remove()
                        _G.OldDrawings[data.text] = nil
                    end
                end)
                drawings[key] = nil
            end
        end

        task.wait(0.07)

        local function classCount(className)
            local n = 0
            for _, d in pairs(drawings) do
                if d.resourceClass == className then n = n + 1 end
            end
            return n
        end

        local function buildCandidates(children, configTable, getPartFn)
            if not hrpPos then return {} end
            local candidates = {}
            for _, child in ipairs(children) do
                local cfg = configTable and configTable[child.Name]
                if configTable and not cfg then continue end
                local part, extra = getPartFn(child)
                if part or extra then
                    local id = getId(child)
                    if not drawings[id] then
                        local pos = part and part.Position or (extra and extra.pos)
                        if pos then
                            table.insert(candidates, {child=child, id=id, part=part, extra=extra, cfg=cfg, dist=(pos - hrpPos).Magnitude * 0.28})
                        end
                    end
                end
            end
            table.sort(candidates, function(a,b) return a.dist < b.dist end)
            return candidates
        end

        if nMaster and nodesFolder then
            pcall(function()
                local cap       = safeGetValue("node_max_count", 30)
                local current   = classCount("Node")
                local children  = nodesFolder:GetChildren()
                local candidates = buildCandidates(children, activeNodes, function(child)
                    local part = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart")
                    return part, nil
                end)
                for i, cand in ipairs(candidates) do
                    if not isRunning then return end
                    if current >= cap then break end
                    if i % batchSize == 0 then task.wait() end
                    drawings[cand.id] = {mainPart=cand.part, modelInstance=cand.child, text=createText(), typeName=cand.child.Name, resourceClass="Node", config=cand.cfg}
                    current = current + 1
                end
            end)
        end

        task.wait(0.07)

        if pMaster and plantsFolder then
            pcall(function()
                local cap        = safeGetValue("plant_max_count", 30)
                local current    = classCount("Plant")
                local children   = plantsFolder:GetChildren()
                local candidates = buildCandidates(children, activePlants, function(child)
                    local part = child:FindFirstChild("Main")
                    if part and part:IsA("MeshPart") then return part, nil end
                    return nil, nil
                end)
                for i, cand in ipairs(candidates) do
                    if not isRunning then return end
                    if current >= cap then break end
                    if i % batchSize == 0 then task.wait() end
                    drawings[cand.id] = {mainPart=cand.part, modelInstance=cand.child, text=createText(), typeName=cand.child.Name, resourceClass="Plant", config=cand.cfg}
                    current = current + 1
                end
            end)
        end

        task.wait(0.07)

        if lonersFolder and (cMaster or eMaster) then
            pcall(function()
                local crateCapR = safeGetValue("crate_max_count", 30)
                local extraCapR = safeGetValue("extra_max_count", 30)
                local crateCount = classCount("Crate")
                local extraCount = classCount("Extra")
                local children   = lonersFolder:GetChildren()
                for i, child in ipairs(children) do
                    if not isRunning then return end
                    local name      = child.Name
                    local crateConf = activeCrates[name]
                    local extraConf = activeExtras[name]
                    if not crateConf and not extraConf then continue end
                    local cType = crateConf and "Crate" or "Extra"
                    local conf  = crateConf or extraConf
                    if cType == "Crate" and crateCount >= crateCapR then continue end
                    if cType == "Extra" and extraCount >= extraCapR then continue end
                    if i % batchSize == 0 then task.wait() end
                    local desc = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart")
                    if desc then
                        local id = getId(child)
                        if not drawings[id] then
                            drawings[id] = {mainPart=desc, modelInstance=child, text=createText(), typeName=name, resourceClass=cType, config=conf}
                            if cType=="Crate" then crateCount=crateCount+1 else extraCount=extraCount+1 end
                        end
                    else
                        for _, actualItem in ipairs(child:GetChildren()) do
                            local d = actualItem:FindFirstChild("Main") or actualItem:FindFirstChildWhichIsA("BasePart", true)
                            local pivotPos = nil
                            if not d and actualItem:IsA("Model") then
                                local ok, pv = pcall(function() return actualItem:GetPivot() end)
                                if ok and pv then pivotPos = pv.Position end
                            end
                            if d or pivotPos then
                                local id = getId(actualItem)
                                if not drawings[id] then
                                    drawings[id] = {mainPart=d, modelInstance=actualItem, text=createText(), typeName=name, resourceClass=cType, config=conf, optionalPivotPos=pivotPos}
                                    if cType=="Crate" then crateCount=crateCount+1 else extraCount=extraCount+1 end
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
                local cap      = safeGetValue("drop_max_count", 30)
                local current  = classCount("Drop")
                local children = dropsFolder:GetChildren()
                local candidates = buildCandidates(children, nil, function(child)
                    local part = child:FindFirstChild("Main") or child:FindFirstChildWhichIsA("BasePart") or (child:IsA("BasePart") and child)
                    if part then return part, nil end
                    if child:IsA("Model") then
                        local ok, pv = pcall(function() return child:GetPivot() end)
                        if ok and pv then return nil, {pos=pv.Position} end
                    end
                    return nil, nil
                end)
                for i, cand in ipairs(candidates) do
                    if not isRunning then return end
                    if current >= cap then break end
                    if i % batchSize == 0 then task.wait() end
                    local pivotPos = cand.extra and cand.extra.pos or nil
                    drawings[cand.id] = {mainPart=cand.part, modelInstance=cand.child, text=createText(), typeName=cand.child.Name, resourceClass="Drop", optionalPivotPos=pivotPos}
                    current = current + 1
                end
            end)
        end

        task.wait(0.07)

        if aMaster and animalsFolder then
            pcall(function()
                local children   = animalsFolder:GetChildren()
                local candidates = buildCandidates(children, activeAnimals, function(child)
                    local detail   = child:FindFirstChild("Detail")
                    local rootPart = detail and detail:FindFirstChild("RootPart")
                    if rootPart and rootPart:IsA("BasePart") then return rootPart, nil end
                    return nil, nil
                end)
                for i, cand in ipairs(candidates) do
                    if not isRunning then return end
                    if i % batchSize == 0 then task.wait() end
                    local detail   = cand.child:FindFirstChild("Detail")
                    local humanoid = cand.child:FindFirstChildWhichIsA("Humanoid") or (detail and detail:FindFirstChildWhichIsA("Humanoid"))
                    drawings[cand.id] = {mainPart=cand.part, modelInstance=cand.child, text=createText(), typeName=cand.child.Name, resourceClass="Animal", humanoid=humanoid, config=cand.cfg}
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
                                if not isRunning then return end
                                if object.Name ~= "Soldier" then continue end
                                if i % batchSize == 0 then task.wait() end
                                local id = getId(object)
                                if not drawings[id] then
                                    local headPart = object:FindFirstChild("Head") or object:FindFirstChild("HumanoidRootPart") or object:FindFirstChildWhichIsA("BasePart")
                                    local humanoid = object:FindFirstChildWhichIsA("Humanoid")
                                    if headPart then
                                        drawings[id] = {mainPart=headPart, modelInstance=object, text=createText(), typeName="Soldier", resourceClass="NPC", humanoid=humanoid, location=locName}
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
                local function tryRegister(obj, typeName, cfg)
                    if not obj then return end
                    local id = getId(obj)
                    if drawings[id] then return end
                    local head = obj:FindFirstChild("Head") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("BasePart")
                    local hum  = obj:FindFirstChildWhichIsA("Humanoid") or obj:FindFirstChild("Humanoid")
                    if head then
                        drawings[id] = {mainPart=head, modelInstance=obj, text=createText(), typeName=typeName, resourceClass="Event", humanoid=hum, config=cfg}
                    end
                end

                if activeEvents["Bruno"] and miltaryFolder then
                    local rf  = miltaryFolder:FindFirstChild("Rocket Factory")
                    local ba  = miltaryFolder:FindFirstChild("Military Barracks")
                    tryRegister((rf and rf:FindFirstChild("Bruno")) or (ba and ba:FindFirstChild("Bruno")), "Bruno", bossConfig["Bruno"])
                end
                if activeEvents["Brutus"] and miltaryFolder then
                    local f = miltaryFolder:FindFirstChild("Industrial Port")
                    tryRegister(f and f:FindFirstChild("Brutus"), "Brutus", bossConfig["Brutus"])
                end
                if activeEvents["Boris"] and miltaryFolder then
                    local f = miltaryFolder:FindFirstChild("Labs")
                    tryRegister(f and f:FindFirstChild("Boris"), "Boris", bossConfig["Boris"])
                end
                if activeEvents["BTR"] and eventsFolder then
                    tryRegister(eventsFolder:FindFirstChild("BTR"), "BTR", bossConfig["BTR"])
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
            local seen       = {}

            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    local matched = false
                    local pId     = tonumber(p.UserId) or 0
                    if moderatorIds[pId] or moderatorNames[p.Name] or (p.DisplayName and moderatorNames[p.DisplayName]) then
                        matched = true
                    else
                        local ln = (p.Name or ""):lower()
                        local ld = (p.DisplayName or ""):lower()
                        if ln:match("^mod_") or ln:match("^admin_") or ln:match("^staff_")
                        or ld:match("^mod_") or ld:match("^admin_") or ld:match("^staff_") then
                            matched = true
                        end
                    end
                    if matched and not seen[p.Name] then
                        seen[p.Name] = true
                        table.insert(namesFound, p.Name)
                    end
                end
            end)

            ghostCheckTimer = ghostCheckTimer + 1
            if ghostCheckTimer >= 5 then
                ghostCheckTimer = 0
                pcall(function()
                    local wsChildren = workspace:GetChildren()
                    for i, obj in ipairs(wsChildren) do
                        if not isRunning then return end
                        if i % batchSize == 0 then task.wait() end
                        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and not Players:GetPlayerFromCharacter(obj) then
                            if moderatorNames[obj.Name] and not seen[obj.Name] then
                                seen[obj.Name] = true
                                table.insert(namesFound, obj.Name.." (Ghost)")
                            end
                        end
                    end
                end)
            end

            if #namesFound > 0 then
                if not hasNotifiedMod and typeof(notify) == "function" then
                    notify("A mod is in the server!", table.concat(namesFound, ", "), 8)
                    hasNotifiedMod = true
                end
                blinkState = not blinkState
                if blinkState then
                    local fullText = "ACTIVE MOD: "..table.concat(namesFound, ", ")
                    local sz       = safeGetValue("script_text_size", 13)
                    local vp       = Camera and Camera.ViewportSize or Vector2.new(800, 600)
                    overlayText.Text     = fullText
                    overlayText.Size     = sz + 2
                    overlayText.Position = Vector2.new(vp.X - (#fullText * sz * 0.5) - 25, 45)
                    overlayText.Visible  = true
                else
                    overlayText.Visible = false
                end
            else
                hasNotifiedMod      = false
                overlayText.Visible = false
            end
        else
            overlayText.Visible = false
        end
    end
end)

local lastRenderTime  = 0
local colorCache      = {}
local nodeRenderList  = {}
local plantRenderList = {}
local crateRenderList = {}
local dropRenderList  = {}
local extraRenderList = {}

_G.RenderConnection = RunService.RenderStepped:Connect(function()
    if not isRunning then return end

    local mainSuccess = pcall(function()
        local targetFPS   = safeGetValue("script_fps_target", 60)
        local currentTime = os.clock()
        if (currentTime - lastRenderTime) < (1 / targetFPS) then return end
        lastRenderTime = currentTime

        local lp            = Players.LocalPlayer
        local character     = lp and lp.Character
        local localHumanoid = character and character:FindFirstChildWhichIsA("Humanoid")
        local hrp           = character and character:FindFirstChild("HumanoidRootPart")
        if not hrp or not localHumanoid or localHumanoid.Health <= 0 then return end

        local hrpPos         = hrp.Position
        local globalTextSize = safeGetValue("script_text_size", 13)

        local fontIndex = safeGetValue("esp_font", 0)
        local fontMap   = {[0]=1, [1]=2, [2]=3, [3]=5, [4]=0, [5]=4, [6]=6, [7]=6}
        local globalFont = fontMap[fontIndex] or Drawing.Fonts.System


        local nMaster = safeGetValue("node_enabled",   false)
        local nName   = safeGetValue("node_name",      false)
        local nDist   = safeGetValue("node_distance",  false)
        local nMaxC   = safeGetValue("node_max_count", 30)
        local nMaxD   = safeGetValue("node_max_dist",  250)

        local pMaster = safeGetValue("plant_enabled",   false)
        local pName   = safeGetValue("plant_name",      false)
        local pDist   = safeGetValue("plant_distance",  false)
        local pMaxC   = safeGetValue("plant_max_count", 30)
        local pMaxD   = safeGetValue("plant_max_dist",  250)

        local cMaster = safeGetValue("crate_enabled",   false)
        local cName   = safeGetValue("crate_name",      false)
        local cDist   = safeGetValue("crate_distance",  false)
        local cMaxC   = safeGetValue("crate_max_count", 30)
        local cMaxD   = safeGetValue("crate_max_dist",  250)

        local dMaster = safeGetValue("drop_enabled",   false)
        local dName   = safeGetValue("drop_name",      false)
        local dDist   = safeGetValue("drop_distance",  false)
        local dMaxC   = safeGetValue("drop_max_count", 30)
        local dMaxD   = safeGetValue("drop_max_dist",  250)

        local eMaster = safeGetValue("extra_enabled",   false)
        local eName   = safeGetValue("extra_name",      false)
        local eDist   = safeGetValue("extra_distance",  false)
        local eMaxC   = safeGetValue("extra_max_count", 30)
        local eMaxD   = safeGetValue("extra_max_dist",  250)

        local aMaster  = safeGetValue("animal_enabled",  false)
        local aName    = safeGetValue("animal_name",     false)
        local aHealth  = safeGetValue("animal_health",   false)
        local aDist    = safeGetValue("animal_distance", false)
        local aMaxD    = safeGetValue("animal_max_dist", 250)

        local npcMaster  = safeGetValue("npc_enabled",   false)
        local npcName    = safeGetValue("npc_name",      false)
        local npcHealth  = safeGetValue("npc_health",    false)
        local npcDist    = safeGetValue("npc_distance",  false)
        local npcMaxD    = safeGetValue("npc_max_dist",  500)

        local eventMaster  = safeGetValue("event_enabled",   false)
        local eventName    = safeGetValue("event_name",      false)
        local eventHealth  = safeGetValue("event_health",    false)
        local eventDist    = safeGetValue("event_distance",  false)
        local eventMaxD    = safeGetValue("event_max_dist",  1500)

        table.clear(colorCache)

        table.clear(nodeRenderList)
        table.clear(plantRenderList)
        table.clear(crateRenderList)
        table.clear(dropRenderList)
        table.clear(extraRenderList)

        for _, data in pairs(drawings) do
            if not data.text then continue end
            data.text.Size = globalTextSize
            data.text.Font = globalFont

            local c = data.resourceClass
            if c=="Node"   and not nMaster   then data.text.Visible=false; continue end
            if c=="Plant"  and not pMaster   then data.text.Visible=false; continue end
            if c=="Crate"  and not cMaster   then data.text.Visible=false; continue end
            if c=="Drop"   and not dMaster   then data.text.Visible=false; continue end
            if c=="Extra"  and not eMaster   then data.text.Visible=false; continue end
            if c=="Animal" and not aMaster   then data.text.Visible=false; continue end
            if c=="NPC"    and not npcMaster then data.text.Visible=false; continue end
            if c=="Event"  and not eventMaster then data.text.Visible=false; continue end

            if c=="NPC" and not isLocationActive(data.location) then
                data.text.Visible=false; continue
            end

            if data.modelInstance and not data.modelInstance.Parent then data.text.Visible=false; continue end
            if data.mainPart      and not data.mainPart.Parent      then data.text.Visible=false; continue end
            if not data.mainPart  and not data.modelInstance and not data.optionalPivotPos then data.text.Visible=false; continue end

            local hPos = data.mainPart and data.mainPart.Position or data.optionalPivotPos
            if not hPos then data.text.Visible=false; continue end

            local realMeters = (hPos - hrpPos).Magnitude * 0.28

            if c=="Node" then
                if data.config and safeGetValue(data.config.toggleKey,true)~=false and realMeters<=nMaxD then
                    table.insert(nodeRenderList, {data=data,distance=realMeters,position=hPos,nameOpt=nName,distOpt=nDist})
                else data.text.Visible=false end

            elseif c=="Plant" then
                if data.config and safeGetValue(data.config.toggleKey,true)~=false and realMeters<=pMaxD then
                    table.insert(plantRenderList, {data=data,distance=realMeters,position=hPos,nameOpt=pName,distOpt=pDist})
                else data.text.Visible=false end

            elseif c=="Crate" then
                if data.config and safeGetValue(data.config.toggleKey,true)~=false and realMeters<=cMaxD then
                    table.insert(crateRenderList, {data=data,distance=realMeters,position=hPos,nameOpt=cName,distOpt=cDist})
                else data.text.Visible=false end

            elseif c=="Drop" then
                if realMeters<=dMaxD then
                    table.insert(dropRenderList, {data=data,distance=realMeters,position=hPos,nameOpt=dName,distOpt=dDist})
                else data.text.Visible=false end

            elseif c=="Extra" then
                if data.config and safeGetValue(data.config.toggleKey,true)~=false and realMeters<=eMaxD then
                    table.insert(extraRenderList, {data=data,distance=realMeters,position=hPos,nameOpt=eName,distOpt=eDist})
                else data.text.Visible=false end

            elseif c=="Animal" then
                if data.config and safeGetValue(data.config.toggleKey,true)~=false and realMeters<=aMaxD then
                    local pos, onScreen = WorldToScreen(hPos + Vector3.new(0,4,0))
                    if onScreen and pos then
                        local str = ""
                        if aName   then str = data.config.label end
                        if aHealth then
                            local ok, hp = pcall(function() return data.humanoid and data.humanoid.Parent and data.humanoid.Health end)
                            str = str..(str~="" and " " or "")..string.format("(%d HP)", math.floor((ok and hp) or 100))
                        end
                        if aDist then str = (str~="" and str.." [" or "[")..math.floor(realMeters).."m]" end
                        if str=="" then data.text.Visible=false
                        else
                            data.text.Text=str
                            data.text.Color=getLiveColor(data.config.colorKey,data.config.r,data.config.g,data.config.b,colorCache)
                            data.text.Position=Vector2.new(pos.X,pos.Y-10)
                            data.text.Visible=true
                        end
                    else data.text.Visible=false end
                else data.text.Visible=false end

            elseif c=="NPC" then
                if realMeters<=npcMaxD then
                    local pos, onScreen = WorldToScreen(hPos + Vector3.new(0,1.5,0))
                    if onScreen and pos then
                        local str = ""
                        if npcName   then str = "Soldier" end
                        if npcHealth then
                            local ok, hp = pcall(function() return data.humanoid and data.humanoid.Parent and data.humanoid.Health end)
                            str = str..(str~="" and " " or "")..string.format("(%d HP)", math.floor((ok and hp) or 100))
                        end
                        if npcDist then str = (str~="" and str.." [" or "[")..math.floor(realMeters).."m]" end
                        if str=="" then data.text.Visible=false
                        else
                            data.text.Text=str
                            data.text.Color=COLOR_NPC
                            data.text.Position=Vector2.new(pos.X,pos.Y)
                            data.text.Visible=true
                        end
                    else data.text.Visible=false end
                else data.text.Visible=false end

            elseif c=="Event" then
                if realMeters<=eventMaxD and data.config and safeGetValue(data.config.toggleKey,true)~=false then
                    local heightOffset = (data.typeName=="BTR") and Vector3.new(0,5,0) or Vector3.new(0,1.5,0)
                    local pos, onScreen = WorldToScreen(hPos + heightOffset)
                    if onScreen and pos then
                        local str = ""
                        if eventName   then str = data.typeName end
                        if eventHealth then
                            local ok, hp = pcall(function() return data.humanoid and data.humanoid.Parent and data.humanoid.Health end)
                            str = str..(str~="" and " " or "")..string.format("(%d HP)", math.floor((ok and hp) or 100))
                        end
                        if eventDist then str = (str~="" and str.." [" or "[")..math.floor(realMeters).."m]" end
                        if str=="" then data.text.Visible=false
                        else
                            data.text.Text=str
                            data.text.Color=getLiveColor(data.config.colorKey,data.config.r,data.config.g,data.config.b,colorCache)
                            data.text.Position=Vector2.new(pos.X,pos.Y)
                            data.text.Visible=true
                        end
                    else data.text.Visible=false end
                else data.text.Visible=false end
            end
        end

        if #nodeRenderList  > 1 then table.sort(nodeRenderList,  function(a,b) return a.distance<b.distance end) end
        if #plantRenderList > 1 then table.sort(plantRenderList, function(a,b) return a.distance<b.distance end) end
        if #crateRenderList > 1 then table.sort(crateRenderList, function(a,b) return a.distance<b.distance end) end
        if #dropRenderList  > 1 then table.sort(dropRenderList,  function(a,b) return a.distance<b.distance end) end
        if #extraRenderList > 1 then table.sort(extraRenderList, function(a,b) return a.distance<b.distance end) end

        for i, item in ipairs(nodeRenderList) do
            if i <= nMaxC then
                local pos, onScreen = WorldToScreen(item.position + Vector3.new(0,5,0))
                if onScreen and pos then
                    local str = ""
                    if item.nameOpt then str = item.data.config.label end
                    if item.distOpt then str = (str~="" and str.." [" or "[")..math.floor(item.distance).."m]" end
                    item.data.text.Text=str
                    item.data.text.Color=getLiveColor(item.data.config.colorKey,item.data.config.r,item.data.config.g,item.data.config.b,colorCache)
                    item.data.text.Position=Vector2.new(pos.X,pos.Y-10)
                    item.data.text.Visible=(str~="")
                else item.data.text.Visible=false end
            else item.data.text.Visible=false end
        end

        for i, item in ipairs(plantRenderList) do
            if i <= pMaxC then
                local pos, onScreen = WorldToScreen(item.position + Vector3.new(0,5,0))
                if onScreen and pos then
                    local str = ""
                    if item.nameOpt then str = item.data.config.label end
                    if item.distOpt then str = (str~="" and str.." [" or "[")..math.floor(item.distance).."m]" end
                    item.data.text.Text=str
                    item.data.text.Color=getLiveColor(item.data.config.colorKey,item.data.config.r,item.data.config.g,item.data.config.b,colorCache)
                    item.data.text.Position=Vector2.new(pos.X,pos.Y-10)
                    item.data.text.Visible=(str~="")
                else item.data.text.Visible=false end
            else item.data.text.Visible=false end
        end

        for i, item in ipairs(crateRenderList) do
            if i <= cMaxC then
                local pos, onScreen = WorldToScreen(item.position + Vector3.new(0,3,0))
                if onScreen and pos then
                    local str = ""
                    if item.nameOpt then str = item.data.config.label end
                    if item.distOpt then str = (str~="" and str.." [" or "[")..math.floor(item.distance).."m]" end
                    item.data.text.Text=str
                    item.data.text.Color=getLiveColor(item.data.config.colorKey,item.data.config.r,item.data.config.g,item.data.config.b,colorCache)
                    item.data.text.Position=Vector2.new(pos.X,pos.Y-10)
                    item.data.text.Visible=(str~="")
                else item.data.text.Visible=false end
            else item.data.text.Visible=false end
        end

        for i, item in ipairs(dropRenderList) do
            if i <= dMaxC then
                local pos, onScreen = WorldToScreen(item.position + Vector3.new(0,1,0))
                if onScreen and pos then
                    local str = ""
                    if item.nameOpt then str = item.data.typeName end
                    if item.distOpt then str = (str~="" and str.." [" or "[")..math.floor(item.distance).."m]" end
                    item.data.text.Text=str
                    item.data.text.Color=COLOR_DROP
                    item.data.text.Position=Vector2.new(pos.X,pos.Y-10)
                    item.data.text.Visible=(str~="")
                else item.data.text.Visible=false end
            else item.data.text.Visible=false end
        end

        for i, item in ipairs(extraRenderList) do
            if i <= eMaxC then
                local pos, onScreen = WorldToScreen(item.position + Vector3.new(0,3,0))
                if onScreen and pos then
                    local str = ""
                    if item.nameOpt then str = item.data.config.label end
                    if item.distOpt then str = (str~="" and str.." [" or "[")..math.floor(item.distance).."m]" end
                    item.data.text.Text=str
                    item.data.text.Color=getLiveColor(item.data.config.colorKey,item.data.config.r,item.data.config.g,item.data.config.b,colorCache)
                    item.data.text.Position=Vector2.new(pos.X,pos.Y-10)
                    item.data.text.Visible=(str~="")
                else item.data.text.Visible=false end
            else item.data.text.Visible=false end
        end
    end)
end)

wait(0.5)
notify("Fallen.lua - version 1.03", "enjoy!", 5)
wait(1)
notify("Esp might take a second to load.", "!", 5)
