--[[
    Script Name: PRO7 | Best Script
    UI Library: Rayfield UI (Official)
    Executor Compatibility: Delta (iOS, Android, PC)
]]


 
local __T0 = tick()

-- Progress messages (so you can see where it waits)
local function stage(txt)
    print("[PRO7] " .. txt)
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {Title = "PRO7", Text = txt, Duration = 4})
    end)
end

-- Load Rayfield UI. The 2nd link is used ONLY if the 1st one fails (a dead link must not slow the start).
local Rayfield = nil
local RAYFIELD_URLS = {
    "https://sirius.menu/rayfield",
    "https://raw.githubusercontent.com/sirius-menu/rayfield/main/source.lua",
}
stage("Rayfield download ho raha hai...")
for attempt = 1, 2 do
    for _, url in ipairs(RAYFIELD_URLS) do
        local ok, lib = pcall(function()
            return loadstring(game:HttpGet(url))()
        end)
        if ok and lib then
            Rayfield = lib
            break
        end
    end
    if Rayfield then break end
    task.wait(1)
end

if not Rayfield then
    warn("Rayfield failed to load! Check your internet connection or executor (HttpGet / loadstring).")
    stage("Rayfield load nahi hua - internet check karo ya executor badlo")
    return
end
local __tRay = tick()
stage(string.format("Rayfield ready (%.1fs) - window ban rahi hai...", __tRay - __T0))

-- Purple glow text (loading screen, window title, credits)
-- Fast only while the loading screen is visible, afterwards it is very light.
task.spawn(function()
    local purple = Color3.fromRGB(180, 90, 255)
    local glowColor = Color3.fromRGB(200, 120, 255)
    local function style(obj)
        obj.TextColor3 = purple
        obj.TextStrokeColor3 = glowColor
        obj.TextStrokeTransparency = 0.3 + 0.25 * math.sin(tick() * 4)
    end
    local startT = tick()
    local tickCount = 0
    while true do
        local loadingPhase = (tick() - startT) < 12
        task.wait(loadingPhase and 0.1 or 0.5)
        tickCount = tickCount + 1
        pcall(function()
            local roots = {}
            if gethui then table.insert(roots, gethui()) end
            table.insert(roots, game:GetService("CoreGui"))
            local pg = game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui")
            if pg then table.insert(roots, pg) end
            for _, root in ipairs(roots) do
                local gui = root:FindFirstChild("Rayfield")
                if gui then
                    if loadingPhase then
                        local lf = gui:FindFirstChild("LoadingFrame", true)
                        if lf then
                            for _, obj in ipairs(lf:GetDescendants()) do
                                if obj:IsA("TextLabel") then
                                    if string.find(string.lower(obj.Text), "rayfield") then
                                        obj.Text = ""
                                        obj.Visible = false
                                    elseif obj.Name == "Title" then
                                        obj.Text = "PRO7 | Best Script"
                                        style(obj)
                                    elseif obj.Name == "Subtitle" then
                                        obj.Text = "@ALFAIZPRO51"
                                        style(obj)
                                    end
                                end
                            end
                        end
                    end
                    local top = gui:FindFirstChild("Topbar", true)
                    local title = top and top:FindFirstChild("Title")
                    if title and title:IsA("TextLabel") then style(title) end
                    -- credits label: look for it only now and then
                    if not loadingPhase and tickCount % 6 == 0 then
                        for _, obj in ipairs(gui:GetDescendants()) do
                            if obj:IsA("TextLabel") and obj.Text == "@ALFAIZPRO51" then style(obj) end
                        end
                    end
                end
            end
        end)
    end
end)
 
local Window = Rayfield:CreateWindow({
    Name = "PRO7 | Best Script",
    LoadingTitle = "PRO7 | Best Script",
    LoadingSubtitle = "@ALFAIZPRO51",
    Theme = "Default",
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "OGScriptSquidGame",
        FileName = "Config"
    },
    -- Key system: the script asks for the key every time it loads
    KeySystem = true,
    KeySettings = {
        Title = "PRO7 | Best Script",
        Subtitle = "Key System",
        Note = "Key daalo (made by @ALFAIZPRO51)",
        FileName = "PRO7Key",
        SaveKey = false,
        GrabKeyFromSite = false,
        Key = {"ScriptMadeByALFAIZPRO7"},
    },
})
 
local __tWin = tick()
stage(string.format("Window ready (%.1fs) - options ban rahe hain...", __tWin - __tRay))

-- Services & Variables
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
 
local function getRoot(char)
    if not char then return nil end
    return char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
end
 
-- Toggle colors: RED = OFF, GREEN = ON (safe: only recolors the switch)
local toggleStates = {}
local toggleObjects, toggleCallbacks = {}, {}
local sliderValues, sliderObjects, sliderCallbacks = {}, {}, {}

local function ColorToggle(tab, data)
    local cb = data.Callback
    toggleStates[data.Name] = data.CurrentValue or false
    data.Callback = function(v)
        toggleStates[data.Name] = v
        if cb then cb(v) end
    end
    toggleCallbacks[data.Name] = data.Callback
    local obj = tab:CreateToggle(data)
    toggleObjects[data.Name] = obj
    return obj
end

-- sliders are remembered too (so the Configs tab can save / load them)
local function ColorSlider(tab, data)
    local cb = data.Callback
    sliderValues[data.Name] = data.CurrentValue
    data.Callback = function(v)
        sliderValues[data.Name] = v
        if cb then cb(v) end
    end
    sliderCallbacks[data.Name] = data.Callback
    local obj = tab:CreateSlider(data)
    sliderObjects[data.Name] = obj
    return obj
end
 
task.spawn(function()
    local ON = Color3.fromRGB(0, 210, 70)
    local OFF = Color3.fromRGB(230, 40, 40)
    local cache, lastScan = {}, 0
    while true do
        task.wait(0.25)
        pcall(function()
            -- find the toggle frames now and then (not every tick)
            if tick() - lastScan > ((#cache == 0) and 1.5 or 4) then
                lastScan = tick()
                cache = {}
                local roots = {}
                if gethui then table.insert(roots, gethui()) end
                table.insert(roots, game:GetService("CoreGui"))
                table.insert(roots, LocalPlayer:FindFirstChild("PlayerGui"))
                for _, root in ipairs(roots) do
                    local gui = root and root:FindFirstChild("Rayfield")
                    if gui then
                        for _, obj in ipairs(gui:GetDescendants()) do
                            if obj:IsA("Frame") and toggleStates[obj.Name] ~= nil then
                                table.insert(cache, obj)
                            end
                        end
                    end
                end
            end
            for _, obj in ipairs(cache) do
                local state = toggleStates[obj.Name]
                local sw = obj.Parent and obj:FindFirstChild("Switch")
                local ind = sw and sw:FindFirstChild("Indicator")
                if ind and state ~= nil then
                    local col = state and ON or OFF
                    ind.BackgroundColor3 = col
                    local st = ind:FindFirstChildOfClass("UIStroke")
                    if st then st.Color = col end
                end
            end
        end)
    end
end)
 
-- All Tabs Setup
local MainTab = Window:CreateTab("Red Light / Green Light", 4483362458)
local CombatTab = Window:CreateTab("Combat", 4483362458)
local HideTab = Window:CreateTab("Hide & Seek", 4483362458)
local MarbleTab = Window:CreateTab("Marble", 4483362458)
local TugTab = Window:CreateTab("Tug of War", 4483362458)
local JumpTab = Window:CreateTab("Jump Rope", 4483362458)
local HoneyTab = Window:CreateTab("HoneyComb", 4483362458)
local PentaTab = Window:CreateTab("Pentathlon", 4483362458)
local GlassTab = Window:CreateTab("Glass Bridge", 4483362458)
local DinnerTab = Window:CreateTab("Dinner / Fight", 4483362458)
local SkyTab = Window:CreateTab("Sky Squid", 4483362458)
local UtilTab = Window:CreateTab("Movement", 4483362458)
local CreditsTab = Window:CreateTab("Credits", 4483362458)
local ThemeTab = Window:CreateTab("Theme", 4483362458)
local ConfigTab = Window:CreateTab("Configs", 4483362458)
 
-- If one part of the script fails, only that part is skipped and the error is shown
local __errors = {}
local function reportError(section, err)
    local msg = section .. ": " .. tostring(err)
    table.insert(__errors, msg)
    warn("PRO7 ERROR -> " .. msg)
    pcall(function() if setclipboard then setclipboard(table.concat(__errors, "\n")) end end)
    pcall(function()
        Rayfield:Notify({Title = "Error in " .. section, Content = string.sub(tostring(err), 1, 120), Duration = 12})
    end)
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 1. Red Light / Green Light
--------------------------------------------------
MainTab:CreateSection("Red Light, Green Light")
MainTab:CreateButton({
    Name = "Teleport to Doll / Finish Line",
    Callback = function()
        pcall(function()
            local hrp = getRoot(LocalPlayer.Character)
            if hrp then
                local found = false
                for _, v in ipairs(Workspace:GetDescendants()) do
                    if v:IsA("BasePart") then
                        local n = string.lower(v.Name)
                        if n:find("doll") or n:find("finish") or n:find("end") or n:find("line") or n:find("goal") then
                            hrp.CFrame = v.CFrame + Vector3.new(0, 4, 0)
                            found = true
                            Rayfield:Notify({Title = "Success", Content = "Teleported to Finish/Doll!", Duration = 3})
                            break
                        end
                    end
                end
                if not found then
                    hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 200)
                    Rayfield:Notify({Title = "Notice", Content = "Teleported forward safely!", Duration = 3})
                end
            end
        end)
    end
})
 
end)
if not __ok then reportError("1. Red Light / Green Light", __e) end
end

local findTool, clickScreen, touchTarget, startMultiAura, getAuraRange
do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 2. Combat (God Mode, Hitbox, Punch / Knife / Push Aura)
--------------------------------------------------
CombatTab:CreateSection("Combat Enhancements")

-- Helpers
local function getNearestPlayer(range)
    local hrp = getRoot(LocalPlayer.Character)
    if not hrp then return nil end
    local best, bestDist = nil, nil
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = getRoot(p.Character)
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 then
                local d = (hrp.Position - r.Position).Magnitude
                if d <= range and (not bestDist or d < bestDist) then
                    best, bestDist = p.Character, d
                end
            end
        end
    end
    return best
end

local function getTargetsInRange(range)
    local list = {}
    local hrp = getRoot(LocalPlayer.Character)
    if not hrp then return list end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local r = getRoot(p.Character)
            local h = p.Character:FindFirstChildOfClass("Humanoid")
            if r and h and h.Health > 0 and (hrp.Position - r.Position).Magnitude <= range then
                table.insert(list, p.Character)
            end
        end
    end
    return list
end

local function faceTarget(targetRoot)
    local hrp = getRoot(LocalPlayer.Character)
    if hrp and targetRoot then
        hrp.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(targetRoot.Position.X, hrp.Position.Y, targetRoot.Position.Z))
    end
end

-- Finds (and equips) a tool by keywords. fallbackAny = use any tool if none matches.
function findTool(keywords, fallbackAny)
    local char = LocalPlayer.Character
    if not char then return nil end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local function match(t)
        if not t:IsA("Tool") then return false end
        local n = string.lower(t.Name)
        for _, k in ipairs(keywords) do
            if n:find(k) then return true end
        end
        return false
    end
    local tool = nil
    for _, t in ipairs(char:GetChildren()) do
        if match(t) then tool = t break end
    end
    if not tool then
        for _, t in ipairs(LocalPlayer.Backpack:GetChildren()) do
            if match(t) then
                tool = t
                if hum then hum:EquipTool(t) end
                break
            end
        end
    end
    if not tool and fallbackAny then
        tool = char:FindFirstChildOfClass("Tool")
        if not tool then
            local any = LocalPlayer.Backpack:FindFirstChildOfClass("Tool")
            if any and hum then
                hum:EquipTool(any)
                tool = any
            end
        end
    end
    return tool
end

function clickScreen()
    pcall(function()
        local VU = game:GetService("VirtualUser")
        VU:CaptureController()
        local cam = Workspace.CurrentCamera
        local size = cam and cam.ViewportSize or Vector2.new(400, 400)
        VU:ClickButton1(Vector2.new(size.X / 2, size.Y / 2))
    end)
end

-- Fire touch between a tool handle and a target (works through walls if the game uses Touched)
function touchTarget(handle, targetChar)
    if not (handle and firetouchinterest and targetChar) then return end
    for _, name in ipairs({"HumanoidRootPart", "Head", "UpperTorso", "Torso"}) do
        local part = targetChar:FindFirstChild(name)
        if part then
            pcall(function()
                firetouchinterest(handle, part, 0)
                firetouchinterest(handle, part, 1)
            end)
        end
    end
end

-- Attack one or many targets. Activates the tool every call (spam-safe).
local function hitTargets(tool, targets)
    if tool and tool.Parent == LocalPlayer.Character then
        pcall(function() tool.Enabled = true end)
        pcall(function() tool:Activate() end)
        local handle = tool:FindFirstChild("Handle")
        for _, t in ipairs(targets) do
            touchTarget(handle, t)
        end
    else
        clickScreen()
    end
end

-- Push remotes (if the game has a Push / Shove remote, fire it on the target)
local pushRemotes, pushScanTime = {}, 0
local function firePushRemotes(targets)
    if tick() - pushScanTime > 5 then
        pushScanTime = tick()
        pushRemotes = {}
        pcall(function()
            for _, o in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if o:IsA("RemoteEvent") then
                    local n = string.lower(o.Name)
                    if n:find("push") or n:find("shove") then
                        table.insert(pushRemotes, o)
                    end
                end
            end
        end)
    end
    for _, r in ipairs(pushRemotes) do
        for _, t in ipairs(targets) do
            pcall(function() r:FireServer(t) end)
            local pl = Players:GetPlayerFromCharacter(t)
            if pl then pcall(function() r:FireServer(pl) end) end
        end
    end
    return #pushRemotes > 0
end

-- Loops: single aura (nearest) and multi aura (everyone in range)
local function startAura(isOn, range, interval, onTarget)
    task.spawn(function()
        while true do
            task.wait(interval)
            if isOn() and LocalPlayer.Character then
                pcall(function()
                    local target = getNearestPlayer(type(range) == "function" and range() or range)
                    if target then
                        faceTarget(getRoot(target))
                        onTarget(target)
                    end
                end)
            end
        end
    end)
end

function startMultiAura(isOn, range, interval, onTargets)
    task.spawn(function()
        while true do
            task.wait(interval)
            if isOn() and LocalPlayer.Character then
                pcall(function()
                    local targets = getTargetsInRange(type(range) == "function" and range() or range)
                    if #targets > 0 then
                        faceTarget(getRoot(targets[1]))
                        onTargets(targets)
                    end
                end)
            end
        end
    end)
end

-- God Mode
local godMode = false
ColorToggle(CombatTab, {
    Name = "God Mode (Infinite Health)",
    CurrentValue = false,
    Callback = function(v)
        godMode = v
        if not v then
            pcall(function()
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.MaxHealth = 100
                    hum.Health = 100
                    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                    hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                end
                local ff = char and char:FindFirstChild("OG_FF")
                if ff then ff:Destroy() end
            end)
        end
    end
})

RunService.Stepped:Connect(function()
    if godMode and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.MaxHealth = math.huge
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                if not LocalPlayer.Character:FindFirstChild("OG_FF") then
                    local ff = Instance.new("ForceField")
                    ff.Name = "OG_FF"
                    ff.Visible = false
                    ff.Parent = LocalPlayer.Character
                end
            end
        end)
    end
end)

-- Hitbox (toggle: OFF restores original size)
local hitboxSize = 6

local hitboxSlider = ColorSlider(CombatTab, {
    Name = "Hitbox Size",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 6,
    Callback = function(v) hitboxSize = v end
})
CombatTab:CreateButton({
    Name = "Hitbox Size: Min (0)",
    Callback = function()
        pcall(function() hitboxSlider:Set(0) end)
        hitboxSize = 0
    end
})
CombatTab:CreateButton({
    Name = "Hitbox Size: Max (1000)",
    Callback = function()
        pcall(function() hitboxSlider:Set(1000) end)
        hitboxSize = 1000
    end
})
CombatTab:CreateButton({
    Name = "Hitbox Size: Default (6)",
    Callback = function()
        pcall(function() hitboxSlider:Set(6) end)
        hitboxSize = 6
    end
})



local hitboxOn = false
local origHitbox = {}
ColorToggle(CombatTab, {
    Name = "Hitbox Extender",
    CurrentValue = false,
    Callback = function(v)
        hitboxOn = v
        if not v then
            for root, d in pairs(origHitbox) do
                pcall(function()
                    root.Size = d.Size
                    root.Transparency = d.Transparency
                    root.CanCollide = d.CanCollide
                end)
            end
            origHitbox = {}
        end
    end
})

task.spawn(function()
    while true do
        task.wait(0.3)
        if hitboxOn then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local root = getRoot(p.Character)
                        if root then
                            if not origHitbox[root] then
                                origHitbox[root] = {Size = root.Size, Transparency = root.Transparency, CanCollide = root.CanCollide}
                            end
                            root.Size = Vector3.new(hitboxSize, hitboxSize, hitboxSize)
                            root.Transparency = 0.5
                            root.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)

-- Aura Range (used by ALL auras)
local auraRange = 40

local aurarangeSlider = ColorSlider(CombatTab, {
    Name = "Aura Range",
    Range = {0, 1000},
    Increment = 1,
    CurrentValue = 40,
    Callback = function(v) auraRange = v end
})
CombatTab:CreateButton({
    Name = "Aura Range: Min (0)",
    Callback = function()
        pcall(function() aurarangeSlider:Set(0) end)
        auraRange = 0
    end
})
CombatTab:CreateButton({
    Name = "Aura Range: Max (1000)",
    Callback = function()
        pcall(function() aurarangeSlider:Set(1000) end)
        auraRange = 1000
    end
})
CombatTab:CreateButton({
    Name = "Aura Range: Default (40)",
    Callback = function()
        pcall(function() aurarangeSlider:Set(40) end)
        auraRange = 40
    end
})


function getAuraRange() return auraRange end

local PUNCH_KW = {"punch", "fist", "combat", "hand"}
local KNIFE_KW = {"knife", "dagger", "blade", "stab", "sword"}
local PUSH_KW = {"push", "shove"}

-- Punch Aura
local punchAuraEnabled = false
ColorToggle(CombatTab, {
    Name = "Punch Aura (Auto Attack)",
    CurrentValue = false,
    Callback = function(v) punchAuraEnabled = v end
})
startAura(function() return punchAuraEnabled end, getAuraRange, 0.1, function(target)
    hitTargets(findTool(PUNCH_KW, true), {target})
end)

-- Knife Aura
local knifeAuraEnabled = false
ColorToggle(CombatTab, {
    Name = "Knife Aura",
    CurrentValue = false,
    Callback = function(v) knifeAuraEnabled = v end
})
startAura(function() return knifeAuraEnabled end, getAuraRange, 0.1, function(target)
    hitTargets(findTool(KNIFE_KW, true), {target})
end)

-- Push Aura (pushes OTHER players using the game's push tool / remote)
local pushAuraEnabled = false
ColorToggle(CombatTab, {
    Name = "Push Aura",
    CurrentValue = false,
    Callback = function(v) pushAuraEnabled = v end
})
startAura(function() return pushAuraEnabled end, getAuraRange, 0.15, function(target)
    firePushRemotes({target})
    hitTargets(findTool(PUSH_KW, false), {target})
end)

-- Multi Punch Aura
local multiPunchEnabled = false
ColorToggle(CombatTab, {
    Name = "Multi Punch Aura",
    CurrentValue = false,
    Callback = function(v) multiPunchEnabled = v end
})
startMultiAura(function() return multiPunchEnabled end, getAuraRange, 0.1, function(targets)
    hitTargets(findTool(PUNCH_KW, true), targets)
end)

-- Multi Knife Aura
local multiKnifeEnabled = false
ColorToggle(CombatTab, {
    Name = "Multi Knife Aura",
    CurrentValue = false,
    Callback = function(v) multiKnifeEnabled = v end
})
startMultiAura(function() return multiKnifeEnabled end, getAuraRange, 0.1, function(targets)
    hitTargets(findTool(KNIFE_KW, true), targets)
end)

-- Multi Push Aura (pushes everyone in range)
local multiPushEnabled = false
ColorToggle(CombatTab, {
    Name = "Multi Push Aura",
    CurrentValue = false,
    Callback = function(v) multiPushEnabled = v end
})
startMultiAura(function() return multiPushEnabled end, getAuraRange, 0.15, function(targets)
    firePushRemotes(targets)
    hitTargets(findTool(PUSH_KW, false), targets)
end)
end)
if not __ok then reportError("2. Combat (God Mode, Hitbox, Punch / Kni", __e) end
end

local getVisibleButtons, pressGuiButton
do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Tug of War
--------------------------------------------------
TugTab:CreateSection("Tug of War")
-- Visible on-screen buttons (Tug of War shows a button you must mash)
function getVisibleButtons()
    local list = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return list end
    for _, o in ipairs(pg:GetDescendants()) do
        if (o:IsA("TextButton") or o:IsA("ImageButton")) and o.Visible and o.AbsoluteSize.X > 0 and not o:FindFirstAncestor("Rayfield") then
            local vis = true
            local a = o.Parent
            while a and a ~= pg do
                if a:IsA("GuiObject") and not a.Visible then vis = false break end
                if a:IsA("ScreenGui") and not a.Enabled then vis = false break end
                a = a.Parent
            end
            if vis then table.insert(list, o) end
        end
    end
    return list
end

local TUG_KW = {"pull", "tug", "tap", "click", "mash", "press", "rope", "spam"}
function pressGuiButton(btn)
    pcall(function()
        if firesignal then
            firesignal(btn.MouseButton1Down)
            firesignal(btn.MouseButton1Click)
            firesignal(btn.Activated)
        end
    end)
    pcall(function()
        local VIM = game:GetService("VirtualInputManager")
        local pos = btn.AbsolutePosition + btn.AbsoluteSize / 2
        local inset = game:GetService("GuiService"):GetGuiInset()
        VIM:SendMouseButtonEvent(pos.X, pos.Y + inset.Y, 0, true, game, 0)
        VIM:SendMouseButtonEvent(pos.X, pos.Y + inset.Y, 0, false, game, 0)
    end)
end

local function findTugButtons()
    local found = {}
    for _, b in ipairs(getVisibleButtons()) do
        local text = b:IsA("TextButton") and b.Text or ""
        local full = string.lower(b.Name .. " " .. text .. " " .. b.Parent.Name)
        for _, k in ipairs(TUG_KW) do
            if full:find(k) then table.insert(found, b) break end
        end
    end
    return found
end

TugTab:CreateButton({
    Name = "Copy Visible Buttons (debug)",
    Callback = function()
        local lines = {}
        for _, b in ipairs(getVisibleButtons()) do
            table.insert(lines, b:GetFullName() .. " | " .. (b:IsA("TextButton") and b.Text or ""))
        end
        local txt = table.concat(lines, "\n")
        pcall(function() if setclipboard then setclipboard(txt) end end)
        Rayfield:Notify({Title = "Buttons", Content = #lines .. " buttons copied to clipboard", Duration = 4})
    end
})

-- Squid Game X tug of war pull remote (Workspace.Map.TugOfWar.Remotes.HakerPT)
local function getTugPullRemote()
    local m = Workspace:FindFirstChild("Map")
    local t = m and m:FindFirstChild("TugOfWar")
    local r = t and t:FindFirstChild("Remotes")
    return r and r:FindFirstChild("HakerPT")
end

local tugAutoPlay = false
ColorToggle(TugTab, {
    Name = "Auto Play",
    CurrentValue = false,
    Callback = function(v) tugAutoPlay = v end
})

local tugRemotes, tugScanTime = {}, 0
task.spawn(function()
    while true do
        task.wait(0.03)
        if tugAutoPlay then
            pcall(function()
                local pullRemote = getTugPullRemote()
                if pullRemote and pullRemote:IsA("RemoteEvent") then
                    pullRemote:FireServer()
                end
                -- press the on-screen pull button if it is visible
                local btns = findTugButtons()
                if #btns > 0 then
                    for _, b in ipairs(btns) do pressGuiButton(b) end
                else
                    -- fallback: tap middle of the screen + E key
                    clickScreen()
                    local VIM = game:GetService("VirtualInputManager")
                    VIM:SendKeyEvent(true, Enum.KeyCode.E, false, game)
                    VIM:SendKeyEvent(false, Enum.KeyCode.E, false, game)
                end
                -- fire pull / tug remotes if the game has them
                if tick() - tugScanTime > 5 then
                    tugScanTime = tick()
                    tugRemotes = {}
                    for _, o in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                        if o:IsA("RemoteEvent") then
                            local n = string.lower(o.Name)
                            if n:find("tug") or n:find("pull") or n:find("rope") then
                                table.insert(tugRemotes, o)
                            end
                        end
                    end
                end
                for _, r in ipairs(tugRemotes) do
                    pcall(function() r:FireServer() end)
                end
                -- use any equipped tool (some tug games use a tool)
                local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end)
        end
    end
end)
end)
if not __ok then reportError("Tug of War", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Jump Rope (Remove Rope)
--------------------------------------------------
JumpTab:CreateSection("Jump Rope")

local function isJumpRopePart(o)
    if not o:IsA("BasePart") then return false end
    local hasRope, isTug = false, false
    local a = o
    while a and a ~= Workspace do
        local n = string.lower(a.Name)
        if n:find("rope") then hasRope = true end
        if n:find("tug") then isTug = true end
        if a:IsA("Model") and a:FindFirstChildOfClass("Humanoid") then return false end
        a = a.Parent
    end
    return hasRope and not isTug
end

local removeRopeOn = false
local origRope = {}

local function restoreRope()
    for part, d in pairs(origRope) do
        pcall(function()
            part.CanTouch = d.CanTouch
            part.CanCollide = d.CanCollide
            part.Transparency = d.Transparency
        end)
    end
    origRope = {}
end

ColorToggle(JumpTab, {
    Name = "Remove Rope",
    CurrentValue = false,
    Callback = function(v)
        removeRopeOn = v
        if not v then restoreRope() end
    end
})

task.spawn(function()
    while true do
        task.wait(0.3)
        if removeRopeOn then
            pcall(function()
                for _, o in ipairs(Workspace:GetDescendants()) do
                    if isJumpRopePart(o) then
                        if not origRope[o] then
                            origRope[o] = {CanTouch = o.CanTouch, CanCollide = o.CanCollide, Transparency = o.Transparency}
                        end
                        o.CanTouch = false
                        o.CanCollide = false
                        o.Transparency = 1
                    end
                end
            end)
        end
    end
end)

JumpTab:CreateButton({
    Name = "Copy Rope Info (debug)",
    Callback = function()
        local lines = {}
        for _, o in ipairs(Workspace:GetDescendants()) do
            if #lines >= 40 then break end
            if isJumpRopePart(o) then
                table.insert(lines, o:GetFullName() .. " | " .. o.ClassName .. " | touch=" .. tostring(o.CanTouch)
                    .. " | collide=" .. tostring(o.CanCollide) .. " | T=" .. tostring(o.Transparency))
            end
        end
        pcall(function()
            for _, o in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if (o:IsA("RemoteEvent") or o:IsA("RemoteFunction")) and string.find(string.lower(o.Name), "rope") then
                    table.insert(lines, "REMOTE " .. o:GetFullName())
                end
            end
        end)
        pcall(function() if setclipboard then setclipboard(table.concat(lines, "\n")) end end)
        Rayfield:Notify({Title = "Rope", Content = #lines .. " lines copied to clipboard", Duration = 4})
    end
})
end)
if not __ok then reportError("Jump Rope (Remove Rope)", __e) end
end

local playerInfoParts
do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 3. Hide and Seek
--------------------------------------------------
HideTab:CreateSection("Hide & Seek ESP")
local espOn = false
ColorToggle(HideTab, {
    Name = "Player ESP (Highlight)",
    CurrentValue = false,
    Callback = function(v)
        espOn = v
        if not v then
            pcall(function()
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character then
                        local hl = p.Character:FindFirstChild("OG_ESP_HL")
                        if hl then hl:Destroy() end
                    end
                end
            end)
        end
    end
})
 
RunService.RenderStepped:Connect(function()
    if espOn then
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local hl = p.Character:FindFirstChild("OG_ESP_HL")
                    if not hl then
                        hl = Instance.new("Highlight")
                        hl.Name = "OG_ESP_HL"
                        hl.Parent = p.Character
                        hl.FillColor = Color3.fromRGB(255, 0, 0)
                    end
                    hl.Enabled = true
                end
            end
        end)
    end
end)
 
-- Everything we can read about a player (team, attributes, values, tools...) as lowercase text
function playerInfoParts(p)
    local parts = {}
    pcall(function()
        if p.Team then table.insert(parts, "team:" .. p.Team.Name) end
        table.insert(parts, "teamcolor:" .. p.TeamColor.Name)
        for k, v in pairs(p:GetAttributes()) do table.insert(parts, k .. ":" .. tostring(v)) end
        for _, c in ipairs(p:GetChildren()) do
            if c:IsA("ValueBase") then table.insert(parts, c.Name .. ":" .. tostring(c.Value)) end
            if c:IsA("Backpack") then
                for _, t in ipairs(c:GetChildren()) do table.insert(parts, "tool:" .. t.Name) end
            end
        end
        local ls = p:FindFirstChild("leaderstats")
        if ls then
            for _, c in ipairs(ls:GetChildren()) do
                if c:IsA("ValueBase") then table.insert(parts, c.Name .. ":" .. tostring(c.Value)) end
            end
        end
        local ch = p.Character
        if ch then
            if ch.Parent and ch.Parent ~= Workspace then table.insert(parts, "folder:" .. ch.Parent.Name) end
            for k, v in pairs(ch:GetAttributes()) do table.insert(parts, "c." .. k .. ":" .. tostring(v)) end
            for _, c in ipairs(ch:GetChildren()) do
                if c:IsA("ValueBase") then table.insert(parts, c.Name .. ":" .. tostring(c.Value)) end
                if c:IsA("Tool") then table.insert(parts, "tool:" .. c.Name) end
                if c:IsA("Accessory") then table.insert(parts, "acc:" .. c.Name) end
            end
        end
    end)
    return parts
end

local function teamFromText(txt)
    txt = string.lower(txt)
    local blue = txt:find("%f[%a]blue%f[%A]") or txt:find("blueteam") or txt:find("teamblue")
    local red = txt:find("%f[%a]red%f[%A]") or txt:find("redteam") or txt:find("teamred")
        or txt:find("killer") or txt:find("seeker") or txt:find("hunter")
    if blue and not red then return "blue" end
    if red and not blue then return "red" end
    return nil
end

local function getTeamKind(p)
    local kind = nil
    pcall(function()
        -- 1) Team name, 2) team color, 3) every other clue
        if p.Team then kind = teamFromText(p.Team.Name) end
        if not kind then kind = teamFromText(p.TeamColor.Name) end
        if not kind then
            for _, part in ipairs(playerInfoParts(p)) do
                kind = teamFromText(part)
                if kind then break end
            end
        end
    end)
    return kind
end

local blueEspOn, redEspOn, shamanEspOn = false, false, false

local function clearTeamEsp(hlName)
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Character then
            local hl = p.Character:FindFirstChild(hlName)
            if hl then hl:Destroy() end
        end
    end
end

local function isShamanPlayer(p)
    for _, part in ipairs(playerInfoParts(p)) do
        if string.find(string.lower(part), "shaman", 1, true) then return true end
    end
    return false
end

-- Highlight that is visible through walls
local function setEsp(char, name, color, on)
    local hl = char:FindFirstChild(name)
    if on then
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = name
            hl.Adornee = char
            hl.Parent = char
        end
        hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        hl.FillColor = color
        hl.FillTransparency = 0.35
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.OutlineTransparency = 0
    elseif hl then
        hl:Destroy()
    end
end

ColorToggle(HideTab, {
    Name = "Blue Team ESP",
    CurrentValue = false,
    Callback = function(v)
        blueEspOn = v
        if not v then pcall(clearTeamEsp, "OG_BLUE_ESP") end
    end
})

ColorToggle(HideTab, {
    Name = "Red Team ESP (Killers)",
    CurrentValue = false,
    Callback = function(v)
        redEspOn = v
        if not v then pcall(clearTeamEsp, "OG_RED_ESP") end
    end
})

ColorToggle(HideTab, {
    Name = "Shaman ESP (Yellow)",
    CurrentValue = false,
    Callback = function(v)
        shamanEspOn = v
        if not v then pcall(clearTeamEsp, "OG_SHAMAN_ESP") end
    end
})

task.spawn(function()
    while true do
        task.wait(0.3)
        pcall(function()
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    local ch = p.Character
                    local shaman = shamanEspOn and isShamanPlayer(p)
                    local kind = getTeamKind(p)
                    -- yellow shaman has priority over the team colors
                    setEsp(ch, "OG_SHAMAN_ESP", Color3.fromRGB(255, 230, 0), shaman)
                    setEsp(ch, "OG_BLUE_ESP", Color3.fromRGB(0, 120, 255), blueEspOn and kind == "blue" and not shaman)
                    setEsp(ch, "OG_RED_ESP", Color3.fromRGB(255, 30, 30), redEspOn and kind == "red" and not shaman)
                end
            end
        end)
    end
end)

-- Teleport to player (online players list)
local function getPlayerNames()
    local names = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then table.insert(names, p.Name) end
    end
    table.sort(names)
    if #names == 0 then names = {"(no players)"} end
    return names
end

local function findPlayerByLabel(label)
    if not label then return nil end
    for _, p in ipairs(Players:GetPlayers()) do
        if p.Name == label or p.DisplayName == label then return p end
    end
    return nil
end

local function teleportToPlayer(target)
    local char = LocalPlayer.Character
    local root = target and target.Character and getRoot(target.Character)
    if not char or not root then
        Rayfield:Notify({Title = "Teleport", Content = "Player has no character yet", Duration = 3})
        return
    end
    local ok = pcall(function() char:PivotTo(root.CFrame * CFrame.new(0, 3, 0)) end)
    if not ok then
        local hrp = getRoot(char)
        if hrp then hrp.CFrame = root.CFrame * CFrame.new(0, 3, 0) end
    end
    Rayfield:Notify({Title = "Teleport", Content = "Teleported to " .. target.Name, Duration = 3})
end

local tpDropdown = HideTab:CreateDropdown({
    Name = "Teleport to Player (tap a name)",
    Options = getPlayerNames(),
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(opt)
        local label = type(opt) == "table" and opt[1] or opt
        local target = findPlayerByLabel(label)
        if not target then
            Rayfield:Notify({Title = "Teleport", Content = "Player not found: " .. tostring(label), Duration = 3})
            return
        end
        pcall(teleportToPlayer, target)
    end
})

local function refreshPlayerList()
    pcall(function() tpDropdown:Refresh(getPlayerNames()) end)
end
Players.PlayerAdded:Connect(refreshPlayerList)
Players.PlayerRemoving:Connect(function() task.delay(0.5, refreshPlayerList) end)

HideTab:CreateButton({
    Name = "Refresh Player List",
    Callback = refreshPlayerList
})

-- Teleport to the Shaman (finds the player whose team / role / attributes say "shaman")
HideTab:CreateButton({
    Name = "Teleport Shaman",
    Callback = function()
        local found = nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                for _, part in ipairs(playerInfoParts(p)) do
                    if string.find(string.lower(part), "shaman", 1, true) then found = p break end
                end
            end
            if found then break end
        end
        if found then
            pcall(teleportToPlayer, found)
        else
            Rayfield:Notify({Title = "Shaman", Content = "No shaman found. Use Copy Player Info (debug) and send it to Claude.", Duration = 5})
        end
    end
})

HideTab:CreateButton({
    Name = "Copy Player Info (debug)",
    Callback = function()
        local lines = {}
        for _, p in ipairs(Players:GetPlayers()) do
            table.insert(lines, p.Name .. " | " .. p.DisplayName .. " | teamkind=" .. tostring(getTeamKind(p))
                .. " | " .. table.concat(playerInfoParts(p), "; "))
        end
        pcall(function() if setclipboard then setclipboard(table.concat(lines, "\n")) end end)
        Rayfield:Notify({Title = "Players", Content = #lines .. " players copied to clipboard", Duration = 4})
    end
})

HideTab:CreateButton({
    Name = "Teleport to Nearest Player",
    Callback = function()
        pcall(function()
            local hrp = getRoot(LocalPlayer.Character)
            if hrp then
                local nearest, shortest = nil, math.huge
                for _, p in ipairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character then
                        local targetRoot = getRoot(p.Character)
                        if targetRoot then
                            local dist = (hrp.Position - targetRoot.Position).Magnitude
                            if dist < shortest then
                                shortest = dist
                                nearest = targetRoot
                            end
                        end
                    end
                end
                if nearest then
                    hrp.CFrame = nearest.CFrame + Vector3.new(0, 3, 0)
                    Rayfield:Notify({Title = "Teleport", Content = "Teleported to nearest player!", Duration = 3})
                end
            end
        end)
    end
})

-- Frontman & Bodyguard: ESP (Frontman = white, Bodyguards = purple) + teleport
HideTab:CreateSection("Frontman & Bodyguards")
do
    local FRONT_KW = {"frontman", "front man", "front_man"}
    local BODY_KW = {"bodyguard", "body guard", "body_guard"}

    local function hasRole(p, kws)
        for _, part in ipairs(playerInfoParts(p)) do
            local l = string.lower(part)
            for _, k in ipairs(kws) do
                if string.find(l, k, 1, true) then return true end
            end
        end
        return false
    end
    local function isFrontman(p) return hasRole(p, FRONT_KW) end
    local function isBodyguard(p) return (not isFrontman(p)) and hasRole(p, BODY_KW) end

    local frontEspOn, bodyEspOn = false, false

    ColorToggle(HideTab, {
        Name = "Frontman ESP (White)",
        CurrentValue = false,
        Callback = function(v)
            frontEspOn = v
            if not v then pcall(clearTeamEsp, "OG_FRONT_ESP") end
        end
    })

    ColorToggle(HideTab, {
        Name = "Bodyguards ESP (Purple)",
        CurrentValue = false,
        Callback = function(v)
            bodyEspOn = v
            if not v then pcall(clearTeamEsp, "OG_BODY_ESP") end
        end
    })

    task.spawn(function()
        while true do
            task.wait(0.3)
            if frontEspOn or bodyEspOn then
                pcall(function()
                    for _, p in ipairs(Players:GetPlayers()) do
                        if p ~= LocalPlayer and p.Character then
                            local ch = p.Character
                            local front = frontEspOn and isFrontman(p)
                            local body = bodyEspOn and isBodyguard(p)
                            setEsp(ch, "OG_FRONT_ESP", Color3.fromRGB(255, 255, 255), front)
                            setEsp(ch, "OG_BODY_ESP", Color3.fromRGB(170, 70, 255), body)
                        end
                    end
                end)
            end
        end
    end)

    HideTab:CreateButton({
        Name = "Teleport to Frontman",
        Callback = function()
            local found = nil
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and isFrontman(p) then found = p break end
            end
            if found then
                pcall(teleportToPlayer, found)
            else
                Rayfield:Notify({Title = "Frontman", Content = "No Frontman found right now", Duration = 4})
            end
        end
    })

    local function getBodyguardNames()
        local names = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isBodyguard(p) then table.insert(names, p.Name) end
        end
        table.sort(names)
        if #names == 0 then names = {"(no players)"} end
        return names
    end

    local bodyDd = HideTab:CreateDropdown({
        Name = "Teleport to Bodyguards (tap a name)",
        Options = getBodyguardNames(),
        CurrentOption = {},
        MultipleOptions = false,
        Callback = function(opt)
            local label = type(opt) == "table" and opt[1] or opt
            if label == "(no players)" then
                Rayfield:Notify({Title = "Bodyguard", Content = "No Bodyguards right now", Duration = 3})
                return
            end
            local target = findPlayerByLabel(label)
            if not target then
                Rayfield:Notify({Title = "Bodyguard", Content = "Player not found: " .. tostring(label), Duration = 3})
                return
            end
            pcall(teleportToPlayer, target)
        end
    })

    local lastBody = table.concat(getBodyguardNames(), ",")
    local function refreshBody(force)
        local names = getBodyguardNames()
        local key = table.concat(names, ",")
        if force or key ~= lastBody then
            lastBody = key
            pcall(function() bodyDd:Refresh(names) end)
        end
    end

    HideTab:CreateButton({
        Name = "Refresh Bodyguard List",
        Callback = function() refreshBody(true) end
    })

    Players.PlayerAdded:Connect(function() task.delay(1, refreshBody) end)
    Players.PlayerRemoving:Connect(function() task.delay(0.5, refreshBody) end)
    task.spawn(function()
        while true do
            task.wait(4)
            refreshBody()
        end
    end)
end

end)
if not __ok then reportError("3. Hide and Seek", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Multi Gun Aura (Combat tab)  |  HoneyComb + Pentathlon tabs
--------------------------------------------------
local GUN_KW = {"gun", "pistol", "rifle", "shotgun", "revolver", "smg", "glock", "uzi", "sniper", "blaster"}
local GUARD_KW = {"guard", "frontman", "front man", "bodyguard", "staff", "soldier", "worker"}

local function isGuardChar(char)
    local p = Players:GetPlayerFromCharacter(char)
    if not p then return false end
    for _, part in ipairs(playerInfoParts(p)) do
        local l = string.lower(part)
        for _, k in ipairs(GUARD_KW) do
            if string.find(l, k, 1, true) then return true end
        end
    end
    return false
end

local gunAuraOn = false
local gunGuardsOnly = false

ColorToggle(CombatTab, {
    Name = "Multi Gun Aura",
    CurrentValue = false,
    Callback = function(v) gunAuraOn = v end
})

ColorToggle(CombatTab, {
    Name = "Gun Aura: Guards Only (Bodyguard / Frontman)",
    CurrentValue = false,
    Callback = function(v) gunGuardsOnly = v end
})

local function shootTargets(gun, targets)
    local cam = Workspace.CurrentCamera
    local handle = gun:FindFirstChild("Handle")
    for i, t in ipairs(targets) do
        if i > 6 then break end
        local head = t:FindFirstChild("Head") or getRoot(t)
        if head then
            if cam then cam.CFrame = CFrame.lookAt(cam.CFrame.Position, head.Position) end
            pcall(function() gun.Enabled = true end)
            pcall(function() gun:Activate() end)
            -- guns that shoot through a remote inside the tool
            for _, r in ipairs(gun:GetDescendants()) do
                if r:IsA("RemoteEvent") then
                    pcall(function() r:FireServer(head.Position) end)
                    pcall(function() r:FireServer(head) end)
                    pcall(function() r:FireServer(t) end)
                end
            end
            touchTarget(handle, t)
        end
    end
end

startMultiAura(function() return gunAuraOn end, getAuraRange, 0.1, function(targets)
    local list = {}
    for _, t in ipairs(targets) do
        if not gunGuardsOnly or isGuardChar(t) then table.insert(list, t) end
    end
    if #list == 0 then return end
    local gun = findTool(GUN_KW, false)
    if gun and gun.Parent == LocalPlayer.Character then
        shootTargets(gun, list)
    end
end)

-- Generic tab for rounds that need button mashing
local function buildModeTab(tab, title, keywords)
    tab:CreateSection(title)
    local on = false
    ColorToggle(tab, {
        Name = title .. " Auto Click",
        CurrentValue = false,
        Callback = function(v) on = v end
    })
    task.spawn(function()
        while true do
            task.wait(0.05)
            if on then
                pcall(function()
                    local pressed = false
                    for _, b in ipairs(getVisibleButtons()) do
                        local full = string.lower(b.Name .. " " .. (b:IsA("TextButton") and b.Text or ""))
                        for _, k in ipairs(keywords) do
                            if string.find(full, k, 1, true) then
                                pressGuiButton(b)
                                pressed = true
                                break
                            end
                        end
                    end
                    if not pressed then clickScreen() end
                end)
            end
        end
    end)
    tab:CreateButton({
        Name = title .. " Info (debug)",
        Callback = function()
            local lines = {}
            for _, b in ipairs(getVisibleButtons()) do
                table.insert(lines, "BUTTON " .. b:GetFullName() .. " | " .. (b:IsA("TextButton") and b.Text or ""))
            end
            pcall(function()
                local map = Workspace:FindFirstChild("Map")
                if map then
                    for _, c in ipairs(map:GetChildren()) do
                        table.insert(lines, "MAP " .. c.ClassName .. ":" .. c.Name)
                    end
                end
            end)
            pcall(function() if setclipboard then setclipboard(table.concat(lines, "\n")) end end)
            Rayfield:Notify({Title = title, Content = #lines .. " lines copied to clipboard", Duration = 4})
        end
    })
end

-- HoneyComb (Dalgona cookie) -------------------------------------------
-- NOTE: no "lick" keyword here: it matches "c-LICK" and pressed the Roblox top bar buttons.
local HONEY_KW = {"honey", "dalgona", "cookie", "carve", "needle", "crack"}
local HONEY_BTN_KW = {"tap", "click", "press", "carve", "mash", "spam", "scratch", "start", "continue"}
local HONEY_FINISH_KW = {"finish", "complete", "done", "win", "reward"}
local CORE_GUI_KW = {"topbar", "rayfield", "chat", "playerlist", "backpack", "emote", "purchaseprompt"}

local function hasAny(str, list)
    for _, k in ipairs(list) do
        if string.find(str, k, 1, true) then return true end
    end
    return false
end

-- Roblox top bar / chat / our own menu must never be touched
local function isCoreGui(o)
    local a = o
    while a do
        if a == game then break end
        if hasAny(string.lower(a.Name), CORE_GUI_KW) then return true end
        a = a.Parent
    end
    return false
end

-- GUI pieces that belong to the Honeycomb round (only while they are really on screen)
local honeyContainers, honeyContTime = {}, 0
local function getHoneyContainers()
    if tick() - honeyContTime < 0.5 then return honeyContainers end
    honeyContTime = tick()
    honeyContainers = {}
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
    if not pg then return honeyContainers end
    for _, o in ipairs(pg:GetDescendants()) do
        if (o:IsA("ScreenGui") or o:IsA("GuiObject")) and hasAny(string.lower(o.Name), HONEY_KW) and not isCoreGui(o) then
            local visible = o:IsA("ScreenGui") and o.Enabled or (o:IsA("GuiObject") and o.Visible)
            if visible then table.insert(honeyContainers, o) end
        end
    end
    return honeyContainers
end

local function honeyDescendants()
    local list = {}
    for _, c in ipairs(getHoneyContainers()) do
        table.insert(list, c)
        for _, d in ipairs(c:GetDescendants()) do table.insert(list, d) end
    end
    return list
end

local function honeyButtons()
    local list = {}
    for _, o in ipairs(honeyDescendants()) do
        if (o:IsA("TextButton") or o:IsA("ImageButton")) and o.Visible and o.AbsoluteSize.X > 0 then
            table.insert(list, o)
        end
    end
    return list
end

local honeyRemotes, honeyScanTime = {}, 0
local function scanHoneyRemotes(force)
    if not force and tick() - honeyScanTime < 5 then return end
    honeyScanTime = tick()
    honeyRemotes = {}
    pcall(function()
        for _, root in ipairs({game:GetService("ReplicatedStorage"), Workspace:FindFirstChild("Map")}) do
            if root then
                for _, o in ipairs(root:GetDescendants()) do
                    if o:IsA("RemoteEvent") and hasAny(string.lower(o:GetFullName()), HONEY_KW) then
                        table.insert(honeyRemotes, o)
                    end
                end
            end
        end
    end)
end

-- the biggest visible picture / frame inside the honeycomb GUI = the cookie
local function findHoneyGui()
    local best, bestArea = nil, 0
    for _, o in ipairs(honeyDescendants()) do
        if o:IsA("GuiObject") and o.Visible and o.AbsoluteSize.X > 80 and o.AbsoluteSize.Y > 80 then
            local area = o.AbsoluteSize.X * o.AbsoluteSize.Y
            if o:IsA("ImageLabel") or o:IsA("ImageButton") then area = area * 2 end
            if area > bestArea then best, bestArea = o, area end
        end
    end
    return best
end

-- drag the mouse in a circle over the cookie (carves along the outline)
local sweepAngle = 0
local function sweepHoney(gui)
    local VIM = game:GetService("VirtualInputManager")
    local inset = game:GetService("GuiService"):GetGuiInset()
    local c = gui.AbsolutePosition + gui.AbsoluteSize / 2
    local r = math.min(gui.AbsoluteSize.X, gui.AbsoluteSize.Y) * 0.35
    local function pt(a)
        return c.X + math.cos(a) * r, c.Y + inset.Y + math.sin(a) * r
    end
    local x, y = pt(sweepAngle)
    VIM:SendMouseButtonEvent(x, y, 0, true, game, 0)
    for _ = 1, 12 do
        sweepAngle = sweepAngle + 0.25
        x, y = pt(sweepAngle)
        VIM:SendMouseMoveEvent(x, y, game)
    end
    VIM:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function buildHoneyTab()
    HoneyTab:CreateSection("HoneyComb")
    local playOn, sweepOn = false, false
    local idleNotified = false

    ColorToggle(HoneyTab, {
        Name = "Auto HoneyComb Play",
        CurrentValue = false,
        Callback = function(v)
            playOn = v
            idleNotified = false
            if v then
                scanHoneyRemotes(true)
                honeyContTime = 0
                Rayfield:Notify({Title = "HoneyComb", Content = #honeyRemotes .. " honey remotes, " .. #getHoneyContainers() .. " honey screens found", Duration = 4})
            end
        end
    })

    ColorToggle(HoneyTab, {
        Name = "Honey Sweep (drag over cookie)",
        CurrentValue = false,
        Callback = function(v)
            sweepOn = v
            idleNotified = false
        end
    })

    local lastFire = 0
    task.spawn(function()
        while true do
            task.wait(0.05)
            if playOn or sweepOn then
                pcall(function()
                    -- nothing on screen = the round has not started: do nothing (no random clicks)
                    if #getHoneyContainers() == 0 then
                        if not idleNotified then
                            idleNotified = true
                            Rayfield:Notify({Title = "HoneyComb", Content = "Honeycomb round not detected yet. Start the round, it begins by itself.", Duration = 5})
                        end
                        return
                    end
                    idleNotified = false
                    local did = false
                    if playOn then
                        -- 1) honey remotes (finish / reward remotes are NOT spammed here)
                        scanHoneyRemotes(false)
                        if tick() - lastFire > 0.25 then
                            lastFire = tick()
                            for _, r in ipairs(honeyRemotes) do
                                if not hasAny(string.lower(r.Name), HONEY_FINISH_KW) then
                                    pcall(function() r:FireServer() end)
                                    did = true
                                end
                            end
                        end
                        -- 2) buttons that are INSIDE the honeycomb screen only
                        for _, b in ipairs(honeyButtons()) do
                            local full = string.lower(b.Name .. " " .. (b:IsA("TextButton") and b.Text or ""))
                            if hasAny(full, HONEY_BTN_KW) then
                                pressGuiButton(b)
                                did = true
                            end
                        end
                    end
                    -- 3) drag over the cookie picture
                    if sweepOn then
                        local gui = findHoneyGui()
                        if gui then
                            sweepHoney(gui)
                            did = true
                        end
                    end
                    -- 4) honeycomb screen is open but nothing else matched: plain tap
                    if playOn and not did then clickScreen() end
                end)
            end
        end
    end)

    HoneyTab:CreateButton({
        Name = "Fire Finish Remotes (once)",
        Callback = function()
            scanHoneyRemotes(true)
            local n = 0
            for _, r in ipairs(honeyRemotes) do
                if hasAny(string.lower(r.Name), HONEY_FINISH_KW) then
                    pcall(function() r:FireServer() end)
                    n = n + 1
                end
            end
            Rayfield:Notify({Title = "HoneyComb", Content = n .. " finish remotes fired", Duration = 4})
        end
    })

    HoneyTab:CreateButton({
        Name = "HoneyComb Info (debug)",
        Callback = function()
            local lines = {}
            honeyContTime = 0
            scanHoneyRemotes(true)
            for _, r in ipairs(honeyRemotes) do table.insert(lines, "HONEY_REMOTE " .. r:GetFullName()) end
            for _, c in ipairs(getHoneyContainers()) do
                table.insert(lines, "HONEY_GUI " .. c:GetFullName() .. " | " .. c.ClassName)
            end
            -- every ScreenGui the game has right now (run this DURING the honeycomb round)
            local pg = LocalPlayer:FindFirstChild("PlayerGui")
            if pg then
                for _, g in ipairs(pg:GetChildren()) do
                    if g:IsA("ScreenGui") then
                        table.insert(lines, "SCREENGUI " .. g.Name .. " enabled=" .. tostring(g.Enabled))
                    end
                end
                -- big visible pieces (not the Roblox top bar / our menu)
                local shown = 0
                for _, o in ipairs(pg:GetDescendants()) do
                    if shown < 40 and o:IsA("GuiObject") and o.Visible and o.AbsoluteSize.X > 120 and o.AbsoluteSize.Y > 120 and not isCoreGui(o) then
                        table.insert(lines, "BIG_GUI " .. o:GetFullName() .. " | " .. o.ClassName
                            .. " | " .. math.floor(o.AbsoluteSize.X) .. "x" .. math.floor(o.AbsoluteSize.Y))
                        shown = shown + 1
                    end
                end
            end
            -- what the Honeycomb map folder contains
            pcall(function()
                local map = Workspace:FindFirstChild("Map")
                local hc = map and map:FindFirstChild("Honeycomb")
                if hc then
                    local n = 0
                    for _, d in ipairs(hc:GetDescendants()) do
                        n = n + 1
                        if n > 80 then table.insert(lines, "MAP_HONEYCOMB ... more") break end
                        table.insert(lines, "MAP_HONEYCOMB " .. d.ClassName .. ":" .. d:GetFullName():gsub("^Workspace%.Map%.Honeycomb%.", ""))
                    end
                end
            end)
            -- every remote the game has (names only), the honey action may have another name
            pcall(function()
                local n = 0
                for _, root in ipairs({game:GetService("ReplicatedStorage"), Workspace:FindFirstChild("Map")}) do
                    if root then
                        for _, o in ipairs(root:GetDescendants()) do
                            if (o:IsA("RemoteEvent") or o:IsA("RemoteFunction") or o:IsA("BindableEvent")) and n < 150 then
                                n = n + 1
                                table.insert(lines, "REMOTE " .. o.ClassName .. " " .. o:GetFullName())
                            end
                        end
                    end
                end
            end)
            pcall(function() if setclipboard then setclipboard(table.concat(lines, "\n")) end end)
            Rayfield:Notify({Title = "HoneyComb", Content = #lines .. " lines copied to clipboard", Duration = 4})
        end
    })
end
buildHoneyTab()
buildModeTab(PentaTab, "Pentathlon", {"tap", "click", "press", "mash", "spam", "run", "jump", "throw"})
end)
if not __ok then reportError("Multi Gun Aura (Combat tab)  |  HoneyCom", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 4. Marble Game
--------------------------------------------------
MarbleTab:CreateSection("Marble Game")
MarbleTab:CreateButton({
    Name = "Teleport to Marble Zone",
    Callback = function()
        pcall(function()
            local hrp = getRoot(LocalPlayer.Character)
            if hrp then
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = string.lower(obj.Name)
                        if n:find("marble") or n:find("zone") or n:find("partner") then
                            hrp.CFrame = obj.CFrame + Vector3.new(0, 3, 0)
                            Rayfield:Notify({Title = "Marble", Content = "Teleported to Marble Zone!", Duration = 3})
                            return
                        end
                    end
                end
                Rayfield:Notify({Title = "Marble", Content = "Zone not found in workspace.", Duration = 3})
            end
        end)
    end
})
 
end)
if not __ok then reportError("4. Marble Game", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 5. Glass Bridge (ULTRA FIXED HACK & SAFE TP)
--------------------------------------------------
GlassTab:CreateSection("Glass Bridge Hack")
 
-- Glass Marker v3: RED = Danger, GREEN = Safe, YELLOW = unknown
-- Learns from broken glass / survivors / deaths and then PREDICTS the other rows.
local GLASS_KW = {"glass", "panel", "pane", "tile"}
local SAFE_KW = {"safe", "real", "correct", "solid", "strong", "true", "good", "tempered", "unbreakable"}
local DANGER_KW = {"unsafe", "fake", "tamper", "break", "wrong", "weak", "danger", "trap", "false", "bad", "fragile", "kill", "normal"}
-- stricter lists for text VALUES / tags (generic words would match too much)
local SAFE_STRICT = {"safe", "temper", "correct"}
local DANGER_STRICT = {"unsafe", "fake", "tamper", "break", "wrong", "weak"}

local function matchAny(str, list)
    for _, k in ipairs(list) do
        if string.find(str, k, 1, true) then return true end
    end
    return false
end

local function isCharacterPart(part)
    local a = part.Parent
    while a and a ~= Workspace do
        if a:IsA("Model") and a:FindFirstChildOfClass("Humanoid") then return true end
        a = a.Parent
    end
    return false
end

local function inGlassContainer(o)
    local a = o.Parent
    while a and a ~= Workspace do
        local n = string.lower(a.Name)
        if string.find(n, "glass", 1, true) or string.find(n, "bridge", 1, true) then return true end
        a = a.Parent
    end
    return false
end

local function isGlassLike(o)
    if not o:IsA("BasePart") then return false end
    -- skip big platforms / walls
    if math.max(o.Size.X, o.Size.Z) > 30 or o.Size.Y > 8 then return false end
    if o.Material == Enum.Material.Glass then return true end
    local n = string.lower(o.Name)
    local pn = o.Parent and string.lower(o.Parent.Name) or ""
    local gn = (o.Parent and o.Parent.Parent) and string.lower(o.Parent.Parent.Name) or ""
    return matchAny(n, GLASS_KW) or matchAny(pn, GLASS_KW) or matchAny(gn, GLASS_KW) or inGlassContainer(o)
end

-- Where to look: Workspace.Map children called glass / bridge (fast). Otherwise the whole Workspace.
local glassRoots, glassRootsTime = {}, 0
local function getGlassRoots()
    if tick() - glassRootsTime < 3 and #glassRoots > 0 then return glassRoots end
    glassRootsTime = tick()
    glassRoots = {}
    local map = Workspace:FindFirstChild("Map")
    if map then
        for _, c in ipairs(map:GetChildren()) do
            local n = string.lower(c.Name)
            if n:find("glass") or n:find("bridge") then table.insert(glassRoots, c) end
        end
    end
    if #glassRoots == 0 then glassRoots = {Workspace} end
    return glassRoots
end

local function collectGlass()
    local parts = {}
    for _, root in ipairs(getGlassRoots()) do
        for _, o in ipairs(root:GetDescendants()) do
            if #parts >= 600 then return parts end
            if isGlassLike(o) and not isCharacterPart(o) then table.insert(parts, o) end
        end
    end
    return parts
end

-- Guess from names / attributes only (returns "safe", "danger" or nil)
local function classifyGlass(part)
    -- 0) the game itself may already highlight glass (Glass Maker sees red on bad glass)
    for _, inst in ipairs({part, part.Parent}) do
        if inst then
            for _, c in ipairs(inst:GetChildren()) do
                if c:IsA("Highlight") or c:IsA("SelectionBox") or c:IsA("BoxHandleAdornment") then
                    if c.Name ~= "OG_GlassESP" then
                        local col = c:IsA("Highlight") and c.FillColor or c.Color3
                        if col.R > 0.7 and col.G < 0.4 and col.B < 0.4 then return "danger" end
                        if col.G > 0.7 and col.R < 0.4 and col.B < 0.4 then return "safe" end
                    end
                end
            end
        end
    end
    for _, inst in ipairs({part, part.Parent}) do
        if inst then
            for k, v in pairs(inst:GetAttributes()) do
                local lk = string.lower(k)
                if type(v) == "boolean" then
                    if matchAny(lk, DANGER_KW) then return v and "danger" or "safe" end
                    if matchAny(lk, SAFE_KW) then return v and "safe" or "danger" end
                end
            end
            for _, c in ipairs(inst:GetChildren()) do
                if c:IsA("BoolValue") then
                    local lk = string.lower(c.Name)
                    if matchAny(lk, DANGER_KW) then return c.Value and "danger" or "safe" end
                    if matchAny(lk, SAFE_KW) then return c.Value and "safe" or "danger" end
                end
            end
        end
    end
    -- string attributes / StringValues / CollectionService tags
    for _, inst in ipairs({part, part.Parent}) do
        if inst then
            for _, v in pairs(inst:GetAttributes()) do
                if type(v) == "string" then
                    local lv = string.lower(v)
                    if matchAny(lv, DANGER_STRICT) then return "danger" end
                    if matchAny(lv, SAFE_STRICT) then return "safe" end
                end
            end
            for _, c in ipairs(inst:GetChildren()) do
                if c:IsA("StringValue") then
                    local lv = string.lower(c.Value)
                    if matchAny(lv, DANGER_STRICT) then return "danger" end
                    if matchAny(lv, SAFE_STRICT) then return "safe" end
                end
            end
            local okTags, tags = pcall(function() return inst:GetTags() end)
            if okTags then
                for _, tg in ipairs(tags) do
                    local lt = string.lower(tg)
                    if matchAny(lt, DANGER_STRICT) then return "danger" end
                    if matchAny(lt, SAFE_STRICT) then return "safe" end
                end
            end
        end
    end
    for _, nm in ipairs({string.lower(part.Name), part.Parent and string.lower(part.Parent.Name) or ""}) do
        if matchAny(nm, DANGER_KW) then return "danger" end
        if matchAny(nm, SAFE_KW) then return "safe" end
    end
    return nil
end

-- The other panel of the same row (left / right pair)
local function getPartner(part)
    local sibs = {}
    if part.Parent then
        for _, c in ipairs(part.Parent:GetChildren()) do
            if isGlassLike(c) then table.insert(sibs, c) end
        end
    end
    if #sibs == 2 then
        return (sibs[1] == part) and sibs[2] or sibs[1]
    end
    return nil
end

-- Pairs panels by position: same row along the bridge = left / right pair.
local function computePairs(parts)
    local pairMap = {}
    if #parts < 2 then return pairMap end
    local minX, maxX, minZ, maxZ = math.huge, -math.huge, math.huge, -math.huge
    for _, p in ipairs(parts) do
        local pos = p.Position
        minX = math.min(minX, pos.X)
        maxX = math.max(maxX, pos.X)
        minZ = math.min(minZ, pos.Z)
        maxZ = math.max(maxZ, pos.Z)
    end
    local alongX = (maxX - minX) > (maxZ - minZ)
    local groups = {}
    for _, p in ipairs(parts) do
        local a = alongX and p.Position.X or p.Position.Z
        local len = math.max(alongX and p.Size.X or p.Size.Z, 1)
        local key = math.floor(a / len + 0.5)
        groups[key] = groups[key] or {}
        table.insert(groups[key], p)
    end
    for _, g in pairs(groups) do
        if #g == 2 then
            local b1 = alongX and g[1].Position.Z or g[1].Position.X
            local b2 = alongX and g[2].Position.Z or g[2].Position.X
            if math.abs(b1 - b2) > 0.5 then
                pairMap[g[1]] = g[2]
                pairMap[g[2]] = g[1]
            end
        end
    end
    return pairMap
end

local GLASS_COLORS = {
    safe = Color3.fromRGB(0, 255, 0),
    danger = Color3.fromRGB(255, 0, 0),
    unknown = Color3.fromRGB(255, 200, 0),
}

-- info = {partner, props, t0, c0, y0, state, source, broken}
local glassInfo = {}
-- votes["Key=Value"] = {safe = n, danger = n}  (what differs between safe and danger glass)
local glassVotes = {}

local function opposite(state) return (state == "safe") and "danger" or "safe" end

-- a fingerprint of the panel BEFORE it breaks (no position / index numbers)
local function panelProps(part)
    local t = {}
    t.Material = tostring(part.Material)
    t.Color = string.format("%.2f,%.2f,%.2f", part.Color.R, part.Color.G, part.Color.B)
    t.Transparency = string.format("%.2f", part.Transparency)
    t.Reflectance = string.format("%.2f", part.Reflectance)
    t.CanTouch = tostring(part.CanTouch)
    t.CanCollide = tostring(part.CanCollide)
    t.Anchored = tostring(part.Anchored)
    t.Size = string.format("%.1f,%.1f,%.1f", part.Size.X, part.Size.Y, part.Size.Z)
    t.Touch = tostring(part:FindFirstChildOfClass("TouchTransmitter") ~= nil)
    local kids = {}
    for _, c in ipairs(part:GetChildren()) do
        if c.Name ~= "OG_GlassESP" and c.Name ~= "OG_GlassLabel" then
            table.insert(kids, c.ClassName .. ":" .. (string.gsub(c.Name, "%d+", "")))
        end
    end
    table.sort(kids)
    t.Kids = table.concat(kids, ",")
    local attrs = {}
    for k, v in pairs(part:GetAttributes()) do table.insert(attrs, k .. "=" .. tostring(v)) end
    table.sort(attrs)
    t.Attrs = table.concat(attrs, ",")
    t.Name = (string.gsub(part.Name, "%d+", ""))
    return t
end

local function diffKeys(a, b)
    local keys = {}
    for k, v in pairs(a) do
        if b[k] ~= v then table.insert(keys, k) end
    end
    return keys
end

local function addVote(key, state)
    local v = glassVotes[key]
    if not v then
        v = {safe = 0, danger = 0}
        glassVotes[key] = v
    end
    v[state] = v[state] + 1
end

-- when we KNOW one panel, remember what is different about it compared with its partner
local function learnFromObservation(part, state)
    local info = glassInfo[part]
    local pinfo = info and info.partner and glassInfo[info.partner]
    if not (info and pinfo and info.props and pinfo.props) then return end
    for _, k in ipairs(diffKeys(info.props, pinfo.props)) do
        addVote(k .. "=" .. info.props[k], state)
        addVote(k .. "=" .. pinfo.props[k], opposite(state))
    end
end

-- guess an unknown panel from what we learned on other rows
local function predictState(part)
    local info = glassInfo[part]
    local pinfo = info and info.partner and glassInfo[info.partner]
    if not (info and pinfo and info.props and pinfo.props) then return nil end
    local score = 0
    for _, k in ipairs(diffKeys(info.props, pinfo.props)) do
        local a = glassVotes[k .. "=" .. info.props[k]]
        local b = glassVotes[k .. "=" .. pinfo.props[k]]
        if a then score = score + a.safe - a.danger end
        if b then score = score + b.danger - b.safe end
    end
    if score >= 2 then return "safe" end
    if score <= -2 then return "danger" end
    return nil
end

-- source: "observed" (real proof), "name" (guess from names), "predicted"
local function setPairState(part, state, source)
    local info = glassInfo[part]
    if not info then return end
    source = source or "observed"
    info.state = state
    info.source = source
    local pinfo = info.partner and glassInfo[info.partner]
    if pinfo and (pinfo.state == nil or pinfo.source == "predicted") then
        pinfo.state = opposite(state)
        pinfo.source = (source == "observed") and "pair" or source
    end
    if source == "observed" then learnFromObservation(part, state) end
end

local function distToMe(part)
    local hrp = getRoot(LocalPlayer.Character)
    if not hrp then return math.huge end
    return (part.Position - hrp.Position).Magnitude
end

local function ensureMarker(part)
    local adorn = part:FindFirstChild("OG_GlassESP")
    if not adorn then
        adorn = Instance.new("BoxHandleAdornment")
        adorn.Name = "OG_GlassESP"
        adorn.Adornee = part
        adorn.AlwaysOnTop = true
        adorn.ZIndex = 5
        adorn.Transparency = 0.4
        adorn.Parent = part
    end
    adorn.Size = part.Size + Vector3.new(0.05, 0.05, 0.05)
    return adorn
end

local function ensureLabel(part)
    local gui = part:FindFirstChild("OG_GlassLabel")
    if not gui then
        gui = Instance.new("BillboardGui")
        gui.Name = "OG_GlassLabel"
        gui.Adornee = part
        gui.AlwaysOnTop = true
        gui.Size = UDim2.fromOffset(70, 22)
        gui.StudsOffset = Vector3.new(0, 2.5, 0)
        local lbl = Instance.new("TextLabel")
        lbl.Name = "T"
        lbl.Size = UDim2.fromScale(1, 1)
        lbl.BackgroundTransparency = 1
        lbl.Font = Enum.Font.GothamBold
        lbl.TextScaled = true
        lbl.TextStrokeTransparency = 0
        lbl.Parent = gui
        gui.Parent = part
    end
    return gui
end

local function applyGlassEsp()
    local parts = collectGlass()
    local pm = computePairs(parts)
    for _, part in ipairs(parts) do
        local info = glassInfo[part]
        if not info then
            info = {partner = getPartner(part) or pm[part], props = panelProps(part), t0 = part.Transparency,
                c0 = part.CanCollide, y0 = part.Position.Y, state = nil, source = nil, broken = false}
            glassInfo[part] = info
            local base = classifyGlass(part)
            if base then setPairState(part, base, "name") end
        elseif not info.partner then
            info.partner = getPartner(part) or pm[part]
        end
    end
    -- predict rows nobody has tested yet
    for part, info in pairs(glassInfo) do
        if info.state == nil and info.partner and not info.broken then
            local guess = predictState(part)
            if guess then
                info.state, info.source = guess, "predicted"
                local pinfo = glassInfo[info.partner]
                if pinfo and pinfo.state == nil then
                    pinfo.state, pinfo.source = opposite(guess), "predicted"
                end
            end
        end
    end
    -- draw
    for _, part in ipairs(parts) do
        local info = glassInfo[part]
        local kind = info.state or "unknown"
        local adorn = ensureMarker(part)
        adorn.Color3 = GLASS_COLORS[kind]
        if distToMe(part) < 120 then
            local gui = ensureLabel(part)
            local lbl = gui:FindFirstChild("T")
            if lbl then
                local txt = (kind == "safe") and "SAFE" or (kind == "danger") and "DANGER" or "?"
                if info.source == "predicted" then txt = "~" .. txt end
                lbl.Text = txt
                lbl.TextColor3 = GLASS_COLORS[kind]
            end
        else
            local gui = part:FindFirstChild("OG_GlassLabel")
            if gui then gui:Destroy() end
        end
    end
    -- forget panels that were removed a while ago (new round)
    for part, info in pairs(glassInfo) do
        if not part:IsDescendantOf(Workspace) then
            info.goneAt = info.goneAt or tick()
            if tick() - info.goneAt > 10 then glassInfo[part] = nil end
        end
    end
end

local function clearGlassEsp()
    for _, o in ipairs(Workspace:GetDescendants()) do
        if o.Name == "OG_GlassESP" or o.Name == "OG_GlassLabel" or o.Name == "GlassHL" then o:Destroy() end
    end
end

local glassEspOn = false
ColorToggle(GlassTab, {
    Name = "Glass Marker (Red=Danger, Green=Safe)",
    CurrentValue = false,
    Callback = function(v)
        glassEspOn = v
        if v then
            pcall(applyGlassEsp)
            pcall(function()
                local total, safeN, dangerN = 0, 0, 0
                for _, info in pairs(glassInfo) do
                    total = total + 1
                    if info.state == "safe" then safeN = safeN + 1 elseif info.state == "danger" then dangerN = dangerN + 1 end
                end
                Rayfield:Notify({Title = "Glass Marker", Content = total .. " glass found (" .. safeN .. " safe, " .. dangerN .. " danger)", Duration = 4})
            end)
        else
            pcall(clearGlassEsp)
            glassInfo = {}
            glassVotes = {}
        end
    end
})

-- Scan every second so new glass shows up when a round starts
task.spawn(function()
    while true do
        task.wait(1)
        if glassEspOn then pcall(applyGlassEsp) end
    end
end)

-- A player who dies right after standing on a panel (that was not confirmed safe) = DANGER
local lastPanel = {}
local function hookDeath(p)
    local function onChar(ch)
        local hum = ch:WaitForChild("Humanoid", 5)
        if hum then
            hum.Died:Connect(function()
                local lp = lastPanel[p.UserId]
                local info = lp and glassInfo[lp.panel]
                if glassEspOn and info and tick() - lp.t < 1.5 and info.state ~= "safe" then
                    setPairState(lp.panel, "danger", "observed")
                end
            end)
        end
    end
    if p.Character then task.spawn(onChar, p.Character) end
    p.CharacterAdded:Connect(function(ch) task.spawn(onChar, ch) end)
end
for _, p in ipairs(Players:GetPlayers()) do hookDeath(p) end
Players.PlayerAdded:Connect(hookDeath)

-- Listens to glass related remotes (the game may send the answer to the client)
local remoteLog = {}
local function summarizeArg(a, depth)
    depth = depth or 0
    local t = typeof(a)
    if t == "Instance" then
        return a:GetFullName()
    elseif t == "table" and depth < 2 then
        local out, n = {}, 0
        for k, v in pairs(a) do
            n = n + 1
            if n > 6 then table.insert(out, "...") break end
            table.insert(out, tostring(k) .. "=" .. summarizeArg(v, depth + 1))
        end
        return "{" .. table.concat(out, ", ") .. "}"
    end
    return tostring(a)
end

local function markInstance(inst, state)
    if glassInfo[inst] then
        setPairState(inst, state, "observed")
    elseif typeof(inst) == "Instance" then
        for _, d in ipairs(inst:GetDescendants()) do
            if glassInfo[d] then setPairState(d, state, "observed") end
        end
    end
end

task.spawn(function() task.wait(4) pcall(function()
    for _, r in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
        if r:IsA("RemoteEvent") then
            local n = string.lower(r.Name)
            if n:find("glass") or n:find("bridge") or n:find("mark") or n:find("safe") or n:find("fake") or n:find("temper") then
                r.OnClientEvent:Connect(function(...)
                    local args = table.pack(...)
                    local out = {}
                    for i = 1, math.min(args.n, 6) do table.insert(out, summarizeArg(args[i])) end
                    table.insert(remoteLog, r.Name .. "(" .. table.concat(out, " | ") .. ")")
                    if #remoteLog > 30 then table.remove(remoteLog, 1) end
                    -- if the remote name says which kind it is, use it
                    local state = nil
                    if matchAny(n, DANGER_STRICT) then state = "danger" elseif matchAny(n, SAFE_STRICT) then state = "safe" end
                    if state and glassEspOn then
                        for i = 1, args.n do
                            local a = args[i]
                            if typeof(a) == "Instance" then
                                markInstance(a, state)
                            elseif typeof(a) == "table" then
                                for _, v in pairs(a) do
                                    if typeof(v) == "Instance" then markInstance(v, state) end
                                end
                            end
                        end
                    end
                end)
            end
        end
    end
end) end)

-- LEARNING: a panel that breaks = DANGER (partner = SAFE).
-- A panel that a player stands on for 1.5s and survives = SAFE (partner = DANGER).
task.spawn(function()
    local current = {}   -- userId -> {panel, since}
    while true do
        task.wait(0.2)
        if glassEspOn then
            pcall(function()
                -- 1) broken panels
                for part, info in pairs(glassInfo) do
                    if not info.broken then
                        local gone = not part:IsDescendantOf(Workspace)
                        local faded = part.Transparency >= info.t0 + 0.4
                        local noCollide = info.c0 and not part.CanCollide
                        local fell = info.y0 and part.Position.Y < info.y0 - 3
                        if gone or faded or noCollide or fell then
                            info.broken = true
                            setPairState(part, "danger", "observed")
                        end
                    end
                end
                -- 2) players standing on panels
                local chars = {}
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character then table.insert(chars, p.Character) end
                end
                local rp = RaycastParams.new()
                rp.FilterType = Enum.RaycastFilterType.Exclude
                rp.FilterDescendantsInstances = chars
                for _, p in ipairs(Players:GetPlayers()) do
                    local ch = p.Character
                    local root = ch and getRoot(ch)
                    local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                    if root and hum and hum.Health > 0 then
                        local hit = Workspace:Raycast(root.Position, Vector3.new(0, -8, 0), rp)
                        local panel = hit and hit.Instance
                        local info = panel and glassInfo[panel]
                        if info and not info.broken then
                            lastPanel[p.UserId] = {panel = panel, t = tick()}
                            local cur = current[p.UserId]
                            if not cur or cur.panel ~= panel then
                                current[p.UserId] = {panel = panel, since = tick()}
                            elseif tick() - cur.since >= 1.5 and not (info.state == "safe" and info.source == "observed") then
                                setPairState(panel, "safe", "observed")
                            end
                        else
                            current[p.UserId] = nil
                        end
                    end
                end
            end)
        end
    end
end)

-- Teleport onto the nearest KNOWN safe glass in front of you
GlassTab:CreateButton({
    Name = "Teleport to Next Safe Glass",
    Callback = function()
        local hrp = getRoot(LocalPlayer.Character)
        if not hrp then return end
        -- "ahead" = towards the middle of the glass that is still standing
        local sum, n = Vector3.new(0, 0, 0), 0
        for part, info in pairs(glassInfo) do
            if not info.broken and part:IsDescendantOf(Workspace) then
                sum = sum + part.Position
                n = n + 1
            end
        end
        local ahead = (n > 0) and (sum / n - hrp.Position) or Vector3.new(0, 0, 0)
        ahead = Vector3.new(ahead.X, 0, ahead.Z)
        local best, bestD = nil, math.huge
        for part, info in pairs(glassInfo) do
            if info.state == "safe" and not info.broken and part:IsDescendantOf(Workspace) then
                local off = part.Position - hrp.Position
                local d = off.Magnitude
                local isAhead = ahead.Magnitude < 1 or (Vector3.new(off.X, 0, off.Z):Dot(ahead) > 0)
                if d > 4 and isAhead and d < bestD then best, bestD = part, d end
            end
        end
        if best then
            hrp.CFrame = best.CFrame + Vector3.new(0, best.Size.Y / 2 + 3, 0)
            Rayfield:Notify({Title = "Glass", Content = "Teleported to a safe glass", Duration = 3})
        else
            Rayfield:Notify({Title = "Glass", Content = "No safe glass known yet - turn Glass Marker ON and wait", Duration = 4})
        end
    end
})

GlassTab:CreateButton({
    Name = "Copy Glass Info (debug)",
    Callback = function()
        local lines = {}
        local myAttrs = {}
        for k, v in pairs(LocalPlayer:GetAttributes()) do table.insert(myAttrs, k .. "=" .. tostring(v)) end
        table.insert(lines, "PLAYER attrs{" .. table.concat(myAttrs, ",") .. "} team=" .. tostring(LocalPlayer.Team))
        pcall(function()
            local map = Workspace:FindFirstChild("Map")
            if map then
                for _, c in ipairs(map:GetChildren()) do
                    local kids = {}
                    for _, cc in ipairs(c:GetChildren()) do
                        if #kids < 12 then table.insert(kids, cc.ClassName .. ":" .. cc.Name) end
                    end
                    table.insert(lines, "MAP " .. c.ClassName .. ":" .. c.Name .. " -> " .. table.concat(kids, ", "))
                end
            end
        end)
        pcall(function()
            local names = {}
            for _, o in ipairs(game:GetService("ReplicatedStorage"):GetDescendants()) do
                if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
                    local n = string.lower(o.Name)
                    if n:find("glass") or n:find("bridge") or n:find("maker") or n:find("marker") then
                        table.insert(names, o:GetFullName())
                    end
                end
            end
            table.insert(lines, "REMOTES " .. table.concat(names, " ; "))
        end)
        for _, entry in ipairs(remoteLog) do table.insert(lines, "REMOTE_FIRED " .. entry) end
        -- what differs inside a pair + what we learned
        local shown = 0
        for part, info in pairs(glassInfo) do
            if info.partner and glassInfo[info.partner] and shown < 12 then
                local pinfo = glassInfo[info.partner]
                local d = {}
                for _, k in ipairs(diffKeys(info.props, pinfo.props)) do
                    table.insert(d, k .. ":" .. info.props[k] .. " / " .. pinfo.props[k])
                end
                table.insert(lines, "PAIR " .. part.Name .. " vs " .. info.partner.Name .. " diff{" .. table.concat(d, " ; ") .. "}")
                shown = shown + 1
            end
        end
        for k, v in pairs(glassVotes) do
            table.insert(lines, "VOTE " .. k .. " safe=" .. v.safe .. " danger=" .. v.danger)
        end
        for i, p in ipairs(collectGlass()) do
            if i > 40 then break end
            local attrs, kids = {}, {}
            for k, v in pairs(p:GetAttributes()) do table.insert(attrs, k .. "=" .. tostring(v)) end
            for _, c in ipairs(p:GetChildren()) do table.insert(kids, c.ClassName .. ":" .. c.Name) end
            local gi = glassInfo[p]
            table.insert(lines, p:GetFullName() .. " | " .. p.ClassName .. " | mat=" .. tostring(p.Material)
                .. " | T=" .. tostring(p.Transparency) .. " | collide=" .. tostring(p.CanCollide)
                .. " | attrs{" .. table.concat(attrs, ",") .. "} | kids{" .. table.concat(kids, ",") .. "}"
                .. " | guess=" .. tostring(classifyGlass(p)) .. " | state=" .. tostring(gi and gi.state)
                .. " (" .. tostring(gi and gi.source) .. ")"
                .. " | partner=" .. tostring(gi and gi.partner and gi.partner.Name)
                .. " | tags{" .. table.concat(p:GetTags(), ",") .. "}")
        end
        pcall(function() if setclipboard then setclipboard(table.concat(lines, "\n")) end end)
        Rayfield:Notify({Title = "Glass", Content = #lines .. " lines copied to clipboard", Duration = 4})
    end
})

GlassTab:CreateButton({
    Name = "Instant Teleport Across Glass Bridge",
    Callback = function()
        pcall(function()
            local hrp = getRoot(LocalPlayer.Character)
            if hrp then
                local teleported = false
 
                -- Attempt 1: Search for bridge end / finish platform
                for _, obj in ipairs(Workspace:GetDescendants()) do
                    if obj:IsA("BasePart") then
                        local n = string.lower(obj.Name)
                        if n:find("bridgeend") or n:find("bridgefinish") or n:find("platformend") or n:find("finishline") or n:find("goal") then
                            hrp.CFrame = obj.CFrame + Vector3.new(0, 5, 0)
                            teleported = true
                            Rayfield:Notify({Title = "Glass Bridge", Content = "Successfully teleported across bridge!", Duration = 3})
                            break
                        end
                    end
                end
 
                -- Attempt 2: Fallback direct forward teleportation across the bridge length
                if not teleported then
                    hrp.CFrame = hrp.CFrame + (hrp.CFrame.LookVector * 300)
                    Rayfield:Notify({Title = "Glass Bridge", Content = "Teleported forward across bridge!", Duration = 3})
                end
            end
        end)
    end
})
 
end)
if not __ok then reportError("5. Glass Bridge (ULTRA FIXED HACK & SAFE", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 6. Dinner / Fight Night
--------------------------------------------------
DinnerTab:CreateSection("Dinner & Fight Night")
DinnerTab:CreateButton({
    Name = "Grab All Tools / Weapons",
    Callback = function()
        pcall(function()
            for _, tool in ipairs(Workspace:GetDescendants()) do
                if tool:IsA("Tool") then
                    tool.Parent = LocalPlayer.Backpack
                end
            end
            Rayfield:Notify({Title = "Weapons", Content = "Weapons collected into inventory!", Duration = 3})
        end)
    end
})
 
end)
if not __ok then reportError("6. Dinner / Fight Night", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 7. Sky Squid
--------------------------------------------------
SkyTab:CreateSection("Sky Squid & Final")
SkyTab:CreateButton({
    Name = "Teleport to Roof / Final Platform",
    Callback = function()
        pcall(function()
            local hrp = getRoot(LocalPlayer.Character)
            if hrp then
                hrp.CFrame = hrp.CFrame + Vector3.new(0, 120, 0)
                Rayfield:Notify({Title = "Sky Squid", Content = "Teleported to roof platform!", Duration = 3})
            end
        end)
    end
})
 
end)
if not __ok then reportError("7. Sky Squid", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 8. Movement & Speed
--------------------------------------------------
UtilTab:CreateSection("Movement Settings")
 
local customWalkSpeed = 16
local speedEnabled = false
 
ColorToggle(UtilTab, {
    Name = "Enable Custom WalkSpeed",
    CurrentValue = false,
    Callback = function(v)
        speedEnabled = v
        if not v then
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum.WalkSpeed = 16 end
            end)
        end
    end
})
 

local walkspeedSlider = ColorSlider(UtilTab, {
    Name = "WalkSpeed Value",
    Range = {0, 255},
    Increment = 1,
    CurrentValue = 16,
    Callback = function(v) customWalkSpeed = v end
})
UtilTab:CreateButton({
    Name = "WalkSpeed Value: Min (0)",
    Callback = function()
        pcall(function() walkspeedSlider:Set(0) end)
        customWalkSpeed = 0
    end
})
UtilTab:CreateButton({
    Name = "WalkSpeed Value: Max (255)",
    Callback = function()
        pcall(function() walkspeedSlider:Set(255) end)
        customWalkSpeed = 255
    end
})
UtilTab:CreateButton({
    Name = "WalkSpeed Value: Default (16)",
    Callback = function()
        pcall(function() walkspeedSlider:Set(16) end)
        customWalkSpeed = 16
    end
})


 
RunService.Heartbeat:Connect(function()
    if speedEnabled then
        pcall(function()
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum and hum.WalkSpeed ~= customWalkSpeed then
                    hum.WalkSpeed = customWalkSpeed
                end
            end
        end)
    end
end)
 
-- Jump Power (slider up to 500)
local customJumpPower = 50
local jumpEnabled = false

ColorToggle(UtilTab, {
    Name = "Enable Custom Jump Power",
    CurrentValue = false,
    Callback = function(v)
        jumpEnabled = v
        if not v then
            pcall(function()
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    hum.UseJumpPower = true
                    hum.JumpPower = 50
                end
            end)
        end
    end
})

local jumppowerSlider = ColorSlider(UtilTab, {
    Name = "Jump Power Value",
    Range = {0, 500},
    Increment = 1,
    CurrentValue = 50,
    Callback = function(v) customJumpPower = v end
})
UtilTab:CreateButton({
    Name = "Jump Power Value: Min (0)",
    Callback = function()
        pcall(function() jumppowerSlider:Set(0) end)
        customJumpPower = 0
    end
})
UtilTab:CreateButton({
    Name = "Jump Power Value: Max (500)",
    Callback = function()
        pcall(function() jumppowerSlider:Set(500) end)
        customJumpPower = 500
    end
})
UtilTab:CreateButton({
    Name = "Jump Power Value: Default (50)",
    Callback = function()
        pcall(function() jumppowerSlider:Set(50) end)
        customJumpPower = 50
    end
})

RunService.Heartbeat:Connect(function()
    if jumpEnabled then
        pcall(function()
            if LocalPlayer.Character then
                local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then
                    if not hum.UseJumpPower then hum.UseJumpPower = true end
                    if hum.JumpPower ~= customJumpPower then hum.JumpPower = customJumpPower end
                end
            end
        end)
    end
end)

local noclip = false
ColorToggle(UtilTab, {
    Name = "Noclip",
    CurrentValue = false,
    Callback = function(v) noclip = v end
})
 
RunService.Stepped:Connect(function()
    if noclip and LocalPlayer.Character then
        pcall(function()
            for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end)
    end
end)
 
local infJump = false
ColorToggle(UtilTab, {
    Name = "Infinite Jump",
    CurrentValue = false,
    Callback = function(v) infJump = v end
})
 
game:GetService("UserInputService").JumpRequest:Connect(function()
    if infJump and LocalPlayer.Character then
        pcall(function()
            local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)
 
end)
if not __ok then reportError("8. Movement & Speed", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Theme (pick a Rayfield theme, or a custom gradient)
--------------------------------------------------
ThemeTab:CreateSection("Appearance")

local function findGui()
    local roots = {}
    if gethui then table.insert(roots, gethui()) end
    table.insert(roots, game:GetService("CoreGui"))
    table.insert(roots, LocalPlayer:FindFirstChild("PlayerGui"))
    for _, root in ipairs(roots) do
        local gui = root and root:FindFirstChild("Rayfield")
        if gui then return gui end
    end
    return nil
end

local function setGradient(frameName, c1, c2, rotation)
    pcall(function()
        local gui = findGui()
        local frame = gui and gui:FindFirstChild(frameName, true)
        if not frame then return end
        local grad = frame:FindFirstChildOfClass("UIGradient")
        if not grad then
            grad = Instance.new("UIGradient")
            grad.Parent = frame
        end
        grad.Color = ColorSequence.new(c1, c2)
        grad.Rotation = rotation or 45
    end)
end

local function clearGradient(frameName)
    pcall(function()
        local gui = findGui()
        local frame = gui and gui:FindFirstChild(frameName, true)
        local grad = frame and frame:FindFirstChildOfClass("UIGradient")
        if grad then grad:Destroy() end
    end)
end

-- Pick one of Rayfield's own built-in themes
local RAYFIELD_THEMES = {"Default", "Ocean", "AmberGlow", "Amethyst", "Bloom", "Green", "Serenity", "Light"}
ThemeTab:CreateDropdown({
    Name = "Rayfield Theme",
    Options = RAYFIELD_THEMES,
    CurrentOption = {"Default"},
    MultipleOptions = false,
    Callback = function(opt)
        local name = type(opt) == "table" and opt[1] or opt
        clearGradient("Background")
        clearGradient("Topbar")
        local ok = pcall(function() Window:ModifyTheme(name) end)
        if ok then
            Rayfield:Notify({Title = "Theme", Content = name .. " theme applied", Duration = 3})
        else
            Rayfield:Notify({Title = "Theme", Content = "This Rayfield version/executor can't switch theme live.", Duration = 6})
        end
    end
})

-- Custom gradients (color changes where supported + an actual gradient overlay either way)
ThemeTab:CreateButton({
    Name = "Purple + Dark Gradient",
    Callback = function()
        pcall(function()
            Window:ModifyTheme({
                Background = Color3.fromRGB(18, 16, 24),
                Topbar = Color3.fromRGB(30, 20, 45),
                ElementBackground = Color3.fromRGB(30, 26, 40),
                TabBackgroundSelected = Color3.fromRGB(150, 80, 230),
                SliderProgress = Color3.fromRGB(160, 90, 255),
                ElementStroke = Color3.fromRGB(120, 70, 190),
                TabStroke = Color3.fromRGB(120, 70, 190),
                SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            })
        end)
        setGradient("Background", Color3.fromRGB(10, 8, 14), Color3.fromRGB(90, 40, 160), 60)
        setGradient("Topbar", Color3.fromRGB(10, 8, 14), Color3.fromRGB(120, 60, 200), 0)
        Rayfield:Notify({Title = "Theme", Content = "Purple + Dark gradient applied", Duration = 3})
    end
})

ThemeTab:CreateButton({
    Name = "Red + Dark Gradient",
    Callback = function()
        pcall(function()
            Window:ModifyTheme({
                Background = Color3.fromRGB(20, 12, 12),
                Topbar = Color3.fromRGB(45, 18, 18),
                ElementBackground = Color3.fromRGB(35, 20, 20),
                TabBackgroundSelected = Color3.fromRGB(210, 50, 50),
                SliderProgress = Color3.fromRGB(230, 60, 60),
                ElementStroke = Color3.fromRGB(170, 50, 50),
                TabStroke = Color3.fromRGB(170, 50, 50),
                SelectedTabTextColor = Color3.fromRGB(255, 255, 255),
            })
        end)
        setGradient("Background", Color3.fromRGB(14, 8, 8), Color3.fromRGB(160, 30, 30), 60)
        setGradient("Topbar", Color3.fromRGB(14, 8, 8), Color3.fromRGB(190, 40, 40), 0)
        Rayfield:Notify({Title = "Theme", Content = "Red + Dark gradient applied", Duration = 3})
    end
})

ThemeTab:CreateButton({
    Name = "Reset to Default",
    Callback = function()
        clearGradient("Background")
        clearGradient("Topbar")
        pcall(function() Window:ModifyTheme("Default") end)
        Rayfield:Notify({Title = "Theme", Content = "Default theme restored", Duration = 3})
    end
})
end)
if not __ok then reportError("Theme", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Sidebar tabs: all tabs in ONE vertical line on the left side
--------------------------------------------------
local sidebarState = nil   -- saved original layout while the sidebar is ON

local function findRayfieldGui()
    local roots = {}
    if gethui then table.insert(roots, gethui()) end
    table.insert(roots, game:GetService("CoreGui"))
    table.insert(roots, LocalPlayer:FindFirstChild("PlayerGui"))
    for _, root in ipairs(roots) do
        local gui = root and root:FindFirstChild("Rayfield")
        if gui then return gui end
    end
    return nil
end

local function applySidebar(on)
    local gui = findRayfieldGui()
    if not gui then return false end
    local tabList = gui:FindFirstChild("TabList", true)
    local elements = gui:FindFirstChild("Elements", true)
    if not (tabList and elements) then return false end
    local main = tabList.Parent
    local layout = tabList:FindFirstChildOfClass("UIListLayout")
    if not (main and layout) then return false end

    if on then
        if sidebarState then return true end
        sidebarState = {
            tabList = tabList, elements = elements, layout = layout,
            tlSize = tabList.Size, tlPos = tabList.Position,
            elSize = elements.Size, elPos = elements.Position,
            fill = layout.FillDirection, halign = layout.HorizontalAlignment,
            canvas = tabList.CanvasSize, autoCanvas = tabList.AutomaticCanvasSize,
            scrollDir = tabList.ScrollingDirection,
            sizes = {},
        }
        local width = 140
        local top = tabList.AbsolutePosition.Y - main.AbsolutePosition.Y
        local totalH = main.AbsoluteSize.Y
        tabList.Position = UDim2.new(0, 6, 0, top)
        tabList.Size = UDim2.new(0, width, 0, totalH - top - 6)
        layout.FillDirection = Enum.FillDirection.Vertical
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
        layout.Padding = UDim.new(0, 4)
        tabList.ScrollingDirection = Enum.ScrollingDirection.Y
        tabList.AutomaticCanvasSize = Enum.AutomaticSize.Y
        tabList.CanvasSize = UDim2.new(0, 0, 0, 0)
        for _, c in ipairs(tabList:GetChildren()) do
            if c:IsA("Frame") and c.Name ~= "Template" then
                sidebarState.sizes[c] = c.Size
                c.Size = UDim2.new(1, -8, 0, 34)
            end
        end
        elements.Position = UDim2.new(0, width + 12, 0, top)
        elements.Size = UDim2.new(1, -(width + 18), 0, totalH - top - 6)

        -- sanity check: if the layout looks broken, undo it
        task.wait(0.3)
        if tabList.AbsoluteSize.X < 50 or elements.AbsoluteSize.X < 150 or elements.AbsoluteSize.Y < 100 then
            applySidebar(false)
            return false
        end
        return true
    else
        local st = sidebarState
        if not st then return true end
        sidebarState = nil
        pcall(function()
            st.tabList.Size = st.tlSize
            st.tabList.Position = st.tlPos
            st.elements.Size = st.elSize
            st.elements.Position = st.elPos
            st.layout.FillDirection = st.fill
            st.layout.HorizontalAlignment = st.halign
            st.tabList.CanvasSize = st.canvas
            st.tabList.AutomaticCanvasSize = st.autoCanvas
            st.tabList.ScrollingDirection = st.scrollDir
            for c, sz in pairs(st.sizes) do
                if c.Parent then c.Size = sz end
            end
        end)
        return true
    end
end

local sidebarToggle = ColorToggle(ThemeTab, {
    Name = "Sidebar Tabs (one line, left side)",
    CurrentValue = false,
    Callback = function(v)
        local ok = applySidebar(v)
        if v and not ok then
            Rayfield:Notify({Title = "Sidebar", Content = "This Rayfield version can't show the sidebar layout. Reverted.", Duration = 5})
        end
    end
})

-- turn it on automatically a moment after the UI is ready
task.spawn(function()
    task.wait(2.5)
    pcall(function()
        if applySidebar(true) then
            pcall(function() sidebarToggle:Set(true) end)
        end
    end)
end)
end)
if not __ok then reportError("Sidebar tabs", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- Configs: create / load / save / delete (up to 25)
--------------------------------------------------
ConfigTab:CreateSection("Configs")

local MAX_CONFIGS = 25
local CONFIG_DIR = "PRO7_Configs"
local HttpService = game:GetService("HttpService")
local hasFS = type(writefile) == "function" and type(readfile) == "function" and type(isfolder) == "function"
    and type(makefolder) == "function" and type(listfiles) == "function" and type(delfile) == "function"
local memConfigs = {}   -- used only if the executor cannot save files

if hasFS then
    pcall(function() if not isfolder(CONFIG_DIR) then makefolder(CONFIG_DIR) end end)
else
    Rayfield:Notify({Title = "Configs", Content = "This executor cannot save files: configs last only until you close the game.", Duration = 6})
end

local function contains(list, value)
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end

local function cleanName(n)
    n = tostring(n or "")
    n = string.gsub(n, "[^%w_%- ]", "")
    n = string.gsub(n, "^%s+", "")
    n = string.gsub(n, "%s+$", "")
    return string.sub(n, 1, 24)
end

local function listConfigs()
    local names = {}
    if hasFS then
        pcall(function()
            for _, path in ipairs(listfiles(CONFIG_DIR)) do
                local n = string.match(path, "([^/\\]+)%.json$")
                if n then table.insert(names, n) end
            end
        end)
    else
        for n in pairs(memConfigs) do table.insert(names, n) end
    end
    table.sort(names)
    return names
end

-- everything that can be saved: every toggle (on/off) and every slider value
local function snapshot()
    local cfg = {toggles = {}, sliders = {}}
    for name, v in pairs(toggleStates) do cfg.toggles[name] = v and true or false end
    for name, v in pairs(sliderValues) do cfg.sliders[name] = v end
    return cfg
end

local function writeConfig(name, cfg)
    if hasFS then
        return (pcall(function()
            writefile(CONFIG_DIR .. "/" .. name .. ".json", HttpService:JSONEncode(cfg))
        end))
    end
    memConfigs[name] = cfg
    return true
end

local function readConfig(name)
    if hasFS then
        local ok, data = pcall(function()
            return HttpService:JSONDecode(readfile(CONFIG_DIR .. "/" .. name .. ".json"))
        end)
        if ok then return data end
        return nil
    end
    return memConfigs[name]
end

local function removeConfig(name)
    if hasFS then
        return (pcall(function() delfile(CONFIG_DIR .. "/" .. name .. ".json") end))
    end
    memConfigs[name] = nil
    return true
end

local function applyConfig(cfg)
    -- sliders first, then toggles
    for name, v in pairs(cfg.sliders or {}) do
        pcall(function() if sliderObjects[name] then sliderObjects[name]:Set(v) end end)
        pcall(function() if sliderCallbacks[name] then sliderCallbacks[name](v) end end)
    end
    for name, v in pairs(cfg.toggles or {}) do
        local on = v and true or false
        pcall(function() if toggleObjects[name] then toggleObjects[name]:Set(on) end end)
        pcall(function() if toggleCallbacks[name] then toggleCallbacks[name](on) end end)
    end
end

local newName = ""
local selected = nil
local dropdown, countLabel

local function refreshUI()
    local names = listConfigs()
    pcall(function() dropdown:Refresh((#names > 0) and names or {"(no configs)"}) end)
    pcall(function() countLabel:Set("Configs: " .. #names .. " / " .. MAX_CONFIGS) end)
    if selected and not contains(names, selected) then selected = nil end
end

countLabel = ConfigTab:CreateLabel("Configs: 0 / " .. MAX_CONFIGS)

ConfigTab:CreateInput({
    Name = "Config name",
    PlaceholderText = "type a name (or leave empty)",
    RemoveTextAfterFocusLost = false,
    Callback = function(text) newName = cleanName(text) end
})

ConfigTab:CreateButton({
    Name = "+ Create Config (saves current settings)",
    Callback = function()
        local names = listConfigs()
        local name = cleanName(newName)
        if name == "" then
            local i = 1
            while contains(names, "Config " .. i) do i = i + 1 end
            name = "Config " .. i
        end
        local exists = contains(names, name)
        if not exists and #names >= MAX_CONFIGS then
            Rayfield:Notify({Title = "Configs", Content = "Limit reached (" .. MAX_CONFIGS .. "). Delete one first.", Duration = 5})
            return
        end
        if writeConfig(name, snapshot()) then
            selected = name
            refreshUI()
            pcall(function() dropdown:Set({name}) end)
            Rayfield:Notify({Title = "Configs", Content = (exists and "Updated: " or "Created: ") .. name, Duration = 4})
        else
            Rayfield:Notify({Title = "Configs", Content = "Could not save the config file.", Duration = 5})
        end
    end
})

dropdown = ConfigTab:CreateDropdown({
    Name = "Select Config",
    Options = {"(no configs)"},
    CurrentOption = {},
    MultipleOptions = false,
    Callback = function(opt)
        local n = (type(opt) == "table") and opt[1] or opt
        if n and n ~= "(no configs)" then selected = n end
    end
})

ConfigTab:CreateButton({
    Name = "Load Selected Config",
    Callback = function()
        if not selected then
            Rayfield:Notify({Title = "Configs", Content = "Select a config first.", Duration = 3})
            return
        end
        local cfg = readConfig(selected)
        if cfg then
            applyConfig(cfg)
            Rayfield:Notify({Title = "Configs", Content = "Loaded: " .. selected, Duration = 4})
        else
            Rayfield:Notify({Title = "Configs", Content = "Could not read: " .. selected, Duration = 4})
        end
    end
})

ConfigTab:CreateButton({
    Name = "Save Current Settings Into Selected",
    Callback = function()
        if not selected then
            Rayfield:Notify({Title = "Configs", Content = "Select a config first.", Duration = 3})
            return
        end
        if writeConfig(selected, snapshot()) then
            Rayfield:Notify({Title = "Configs", Content = "Saved into: " .. selected, Duration = 4})
        else
            Rayfield:Notify({Title = "Configs", Content = "Could not save the config file.", Duration = 5})
        end
    end
})

ConfigTab:CreateButton({
    Name = "Delete Selected Config",
    Callback = function()
        if not selected then
            Rayfield:Notify({Title = "Configs", Content = "Select a config first.", Duration = 3})
            return
        end
        local name = selected
        if removeConfig(name) then
            selected = nil
            refreshUI()
            pcall(function() dropdown:Set({}) end)
            Rayfield:Notify({Title = "Configs", Content = "Deleted: " .. name, Duration = 4})
        else
            Rayfield:Notify({Title = "Configs", Content = "Could not delete: " .. name, Duration = 4})
        end
    end
})

refreshUI()
end)
if not __ok then reportError("Configs", __e) end
end

do
local __ok, __e = pcall(function()
--------------------------------------------------
-- 9. Credits & Channel
--------------------------------------------------
CreditsTab:CreateSection("Credits")
CreditsTab:CreateLabel("@ALFAIZPRO51")
 
Rayfield:Notify({
    Title = "PRO7 | Best Script Loaded Successfully!",
    Content = string.format("@ALFAIZPRO51 | total %.1fs (download %.1fs, window %.1fs, options %.1fs)",
        tick() - __T0, __tRay - __T0, __tWin - __tRay, tick() - __tWin),
    Duration = 8
})
end)
if not __ok then reportError("9. Credits & Channel", __e) end
end

