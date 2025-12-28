-- ═══════════════════════════════════════════════════════════════
-- CBX HUB V3.0 - PROFESSIONAL EDITION
-- Created by Flex | discord.gg/7AfuHpCs
-- ═══════════════════════════════════════════════════════════════

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- ===== WHITELIST SYSTEM =====
local whitelistURL = "https://pastebin.com/raw/UqUYHwQw"
local whitelistedIDs = {}

local function fetchWhitelist()
    local success, response = pcall(function()
        return game:HttpGet(whitelistURL)
    end)
    if success and response then
        for line in response:gmatch("[^\r\n]+") do
            local id = tonumber(line:match("%d+"))
            if id then whitelistedIDs[id] = true end
        end
        return true
    end
    return false
end

if not fetchWhitelist() or not whitelistedIDs[Player.UserId] then
    Player:Kick("❌ Not whitelisted! Join discord.gg/7AfuHpCs")
    return
end

-- ===== FPS & PING COUNTER =====
local fps, ping = 0, 0
local lastFrame = tick()

RunService.RenderStepped:Connect(function()
    local currentTime = tick()
    fps = math.floor(1 / (currentTime - lastFrame))
    lastFrame = currentTime
    ping = math.floor(Player:GetNetworkPing() * 1000)
end)

-- ===== MAIN GUI =====
local GUI = Instance.new("ScreenGui")
GUI.Name = "CBXHub"
GUI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
GUI.ResetOnSpawn = false
GUI.Parent = game.CoreGui

-- ===== BOTTOM STATS BAR =====
local StatsBar = Instance.new("Frame")
StatsBar.Size = UDim2.new(0, 450, 0, 38)
StatsBar.Position = UDim2.new(0.5, -225, 1, -100)
StatsBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
StatsBar.BorderSizePixel = 0
StatsBar.Parent = GUI

local StatsCorner = Instance.new("UICorner")
StatsCorner.CornerRadius = UDim.new(0, 10)
StatsCorner.Parent = StatsBar

local StatsStroke = Instance.new("UIStroke")
StatsStroke.Color = Color3.fromRGB(88, 101, 242)
StatsStroke.Thickness = 2
StatsStroke.Transparency = 0.5
StatsStroke.Parent = StatsBar

local Discord = Instance.new("TextLabel")
Discord.Size = UDim2.new(0, 200, 1, 0)
Discord.Position = UDim2.new(0, 12, 0, 0)
Discord.BackgroundTransparency = 1
Discord.Text = "🌐 discord.gg/7AfuHpCs"
Discord.Font = Enum.Font.GothamBold
Discord.TextSize = 13
Discord.TextColor3 = Color3.fromRGB(88, 101, 242)
Discord.TextXAlignment = Enum.TextXAlignment.Left
Discord.Parent = StatsBar

local ByFlex = Instance.new("TextLabel")
ByFlex.Size = UDim2.new(0, 80, 1, 0)
ByFlex.Position = UDim2.new(0, 220, 0, 0)
ByFlex.BackgroundTransparency = 1
ByFlex.Text = "by Flex"
ByFlex.Font = Enum.Font.Gotham
ByFlex.TextSize = 11
ByFlex.TextColor3 = Color3.fromRGB(140, 140, 150)
ByFlex.TextXAlignment = Enum.TextXAlignment.Left
ByFlex.Parent = StatsBar

local FPSLabel = Instance.new("TextLabel")
FPSLabel.Size = UDim2.new(0, 75, 1, 0)
FPSLabel.Position = UDim2.new(1, -160, 0, 0)
FPSLabel.BackgroundTransparency = 1
FPSLabel.Text = "FPS: 0"
FPSLabel.Font = Enum.Font.GothamBold
FPSLabel.TextSize = 13
FPSLabel.TextColor3 = Color3.fromRGB(0, 255, 127)
FPSLabel.TextXAlignment = Enum.TextXAlignment.Right
FPSLabel.Parent = StatsBar

local PingLabel = Instance.new("TextLabel")
PingLabel.Size = UDim2.new(0, 80, 1, 0)
PingLabel.Position = UDim2.new(1, -80, 0, 0)
PingLabel.BackgroundTransparency = 1
PingLabel.Text = "PING: 0ms"
PingLabel.Font = Enum.Font.GothamBold
PingLabel.TextSize = 13
PingLabel.TextColor3 = Color3.fromRGB(255, 165, 0)
PingLabel.TextXAlignment = Enum.TextXAlignment.Right
PingLabel.Parent = StatsBar

RunService.RenderStepped:Connect(function()
    FPSLabel.Text = "FPS: " .. fps
    PingLabel.Text = "PING: " .. ping .. "ms"
    FPSLabel.TextColor3 = fps >= 50 and Color3.fromRGB(0, 255, 127) or fps >= 30 and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 80, 80)
    PingLabel.TextColor3 = ping <= 80 and Color3.fromRGB(0, 255, 127) or ping <= 150 and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(255, 80, 80)
end)

-- ===== NOTIFICATION SYSTEM =====
local function notify(text, dur, typ)
    local n = Instance.new("Frame")
    n.Size = UDim2.new(0, 360, 0, 75)
    n.Position = UDim2.new(1, 20, 0, 20)
    n.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
    n.BorderSizePixel = 0
    n.Parent = GUI
    
    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 12)
    nCorner.Parent = n
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = typ == "success" and Color3.fromRGB(0, 255, 127) or typ == "error" and Color3.fromRGB(255, 80, 80) or Color3.fromRGB(88, 101, 242)
    stroke.Parent = n
    
    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.new(0, 55, 1, 0)
    icon.BackgroundTransparency = 1
    icon.Text = typ == "success" and "✅" or typ == "error" and "❌" or "ℹ️"
    icon.Font = Enum.Font.GothamBold
    icon.TextSize = 30
    icon.Parent = n
    
    local txt = Instance.new("TextLabel")
    txt.Size = UDim2.new(1, -65, 1, 0)
    txt.Position = UDim2.new(0, 55, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = text
    txt.Font = Enum.Font.GothamMedium
    txt.TextSize = 14
    txt.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt.TextWrapped = true
    txt.TextXAlignment = Enum.TextXAlignment.Left
    txt.Parent = n
    
    TweenService:Create(n, TweenInfo.new(0.5, Enum.EasingStyle.Bounce), {Position = UDim2.new(1, -380, 0, 20)}):Play()
    task.delay(dur or 3, function()
        TweenService:Create(n, TweenInfo.new(0.4), {Position = UDim2.new(1, 20, 0, 20)}):Play()
        task.wait(0.4)
        n:Destroy()
    end)
end

-- ===== MAIN HUB FRAME =====
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 750, 0, 580)
Main.Position = UDim2.new(0.5, -375, 0.5, -290)
Main.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Draggable = true
Main.Visible = false
Main.Parent = GUI

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 18)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(88, 101, 242)
MainStroke.Thickness = 2.5
MainStroke.Transparency = 0.3
MainStroke.Parent = Main

-- ===== HEADER =====
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Header.BorderSizePixel = 0
Header.Parent = Main

local HeaderCorner = Instance.new("UICorner")
HeaderCorner.CornerRadius = UDim.new(0, 18)
HeaderCorner.Parent = Header

local HeaderFill = Instance.new("Frame")
HeaderFill.Size = UDim2.new(1, 0, 0, 18)
HeaderFill.Position = UDim2.new(0, 0, 1, -18)
HeaderFill.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
HeaderFill.BorderSizePixel = 0
HeaderFill.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 220, 1, 0)
Title.Position = UDim2.new(0, 22, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "⚡ CBX HUB"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 26
Title.TextColor3 = Color3.fromRGB(88, 101, 242)
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local Sub = Instance.new("TextLabel")
Sub.Size = UDim2.new(0, 220, 0, 22)
Sub.Position = UDim2.new(0, 22, 0, 38)
Sub.BackgroundTransparency = 1
Sub.Text = "Professional Edition V3.0"
Sub.Font = Enum.Font.Gotham
Sub.TextSize = 11
Sub.TextColor3 = Color3.fromRGB(140, 140, 150)
Sub.TextXAlignment = Enum.TextXAlignment.Left
Sub.Parent = Header

local User = Instance.new("TextLabel")
User.Size = UDim2.new(0, 280, 1, 0)
User.Position = UDim2.new(0, 260, 0, 0)
User.BackgroundTransparency = 1
User.Text = "👤 " .. Player.Name
User.Font = Enum.Font.GothamMedium
User.TextSize = 14
User.TextColor3 = Color3.fromRGB(200, 200, 210)
User.TextXAlignment = Enum.TextXAlignment.Left
User.Parent = Header

local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 48, 0, 48)
Close.Position = UDim2.new(1, -58, 0, 8.5)
Close.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
Close.BorderSizePixel = 0
Close.Text = "✕"
Close.Font = Enum.Font.GothamBold
Close.TextSize = 22
Close.TextColor3 = Color3.fromRGB(255, 255, 255)
Close.AutoButtonColor = false
Close.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 11)
CloseCorner.Parent = Close

Close.MouseEnter:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(255, 80, 80)}):Play()
end)
Close.MouseLeave:Connect(function()
    TweenService:Create(Close, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 30, 38)}):Play()
end)
Close.MouseButton1Click:Connect(function() Main.Visible = false end)

-- ===== TAB SYSTEM =====
local TabContainer = Instance.new("Frame")
TabContainer.Size = UDim2.new(0, 160, 1, -85)
TabContainer.Position = UDim2.new(0, 18, 0, 75)
TabContainer.BackgroundTransparency = 1
TabContainer.Parent = Main

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 12)
TabList.Parent = TabContainer

local ContentFrame = Instance.new("Frame")
ContentFrame.Size = UDim2.new(1, -198, 1, -85)
ContentFrame.Position = UDim2.new(0, 188, 0, 75)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = Main

-- Tab Variables
local tabs = {}
local currentTab = nil

-- ===== UI HELPER FUNCTIONS =====
local function createTab(name, icon)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 48)
    btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    btn.BorderSizePixel = 0
    btn.Text = icon .. "  " .. name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.TextColor3 = Color3.fromRGB(150, 150, 160)
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = TabContainer
    
    local padding = Instance.new("UIPadding")
    padding.PaddingLeft = UDim.new(0, 16)
    padding.Parent = btn
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 11)
    btnCorner.Parent = btn
    
    local page = Instance.new("ScrollingFrame")
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 6
    page.ScrollBarImageColor3 = Color3.fromRGB(88, 101, 242)
    page.Visible = false
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.AutomaticCanvasSize = Enum.AutomaticSize.Y
    page.Parent = ContentFrame
    
    local pageList = Instance.new("UIListLayout")
    pageList.Padding = UDim.new(0, 14)
    pageList.Parent = page
    
    local pagePadding = Instance.new("UIPadding")
    pagePadding.PaddingTop = UDim.new(0, 6)
    pagePadding.PaddingRight = UDim.new(0, 12)
    pagePadding.Parent = page
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(tabs) do
            t.btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            t.btn.TextColor3 = Color3.fromRGB(150, 150, 160)
            t.page.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        currentTab = name
    end)
    
    tabs[name] = {btn = btn, page = page}
    
    if not currentTab then
        btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        page.Visible = true
        currentTab = name
    end
    
    return page
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 52)
    btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(98, 111, 252)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 52)
    frame.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -75, 1, 0)
    label.Position = UDim2.new(0, 16, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.GothamMedium
    label.TextSize = 14
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 54, 0, 28)
    toggle.Position = UDim2.new(1, -64, 0.5, -14)
    toggle.BackgroundColor3 = default and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(45, 45, 55)
    toggle.BorderSizePixel = 0
    toggle.Text = ""
    toggle.AutoButtonColor = false
    toggle.Parent = frame
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(1, 0)
    toggleCorner.Parent = toggle
    
    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 22, 0, 22)
    indicator.Position = default and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    indicator.BorderSizePixel = 0
    indicator.Parent = toggle
    
    local indicatorCorner = Instance.new("UICorner")
    indicatorCorner.CornerRadius = UDim.new(1, 0)
    indicatorCorner.Parent = indicator
    
    local state = default
    
    toggle.MouseButton1Click:Connect(function()
        state = not state
        TweenService:Create(toggle, TweenInfo.new(0.3), {
            BackgroundColor3 = state and Color3.fromRGB(0, 255, 127) or Color3.fromRGB(45, 45, 55)
        }):Play()
        TweenService:Create(indicator, TweenInfo.new(0.3), {
            Position = state and UDim2.new(1, -25, 0.5, -11) or UDim2.new(0, 3, 0.5, -11)
        }):Play()
        callback(state)
    end)
    
    return frame
end

local function createLabel(parent, text)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 32)
    label.BackgroundTransparency = 1
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 12
    label.TextColor3 = Color3.fromRGB(140, 140, 150)
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent
    return label
end

-- ===== CREATE TABS =====
local TPTab = createTab("Teleport", "🚀")
local StealTab = createTab("Auto Steal", "💎")
local TurretTab = createTab("Auto Turret", "🔫")
local ESPTab = createTab("ESP", "👁️")
local MiscTab = createTab("Misc", "⚙️")

-- ===== TELEPORT SYSTEM =====
local function equipFlyingCarpet()
    local backpack = Player:WaitForChild("Backpack")
    local character = Player.Character
    
    if character then
        local tool = backpack:FindFirstChild("Flying Carpet") or character:FindFirstChild("Flying Carpet")
        if tool then
            if tool.Parent == backpack then
                character.Humanoid:EquipTool(tool)
            end
            return true
        else
            notify("Flying Carpet not found", 3, "error")
            return false
        end
    end
    return false
end

local function autoBlockPlayer()
    local targetPlayer = nil
    for _, otherPlayer in pairs(Players:GetPlayers()) do
        if otherPlayer ~= Player then
            targetPlayer = otherPlayer
            break
        end
    end
    
    if not targetPlayer then return end
    
    pcall(function()
        game:GetService("StarterGui"):SetCore("PromptBlockPlayer", targetPlayer)
        task.wait(0.3)
        local playerGui = Player:WaitForChild("PlayerGui")
        
        for _, gui in pairs(playerGui:GetDescendants()) do
            if gui:IsA("TextButton") and (gui.Text:lower():find("block") or gui.Name:lower():find("confirm")) then
                for _, connection in pairs(getconnections(gui.MouseButton1Click)) do
                    connection:Fire()
                end
                task.wait(0.1)
            end
        end
    end)
end

local function teleportSequence1()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        notify("Character not found", 3, "error")
        return
    end
    
    local hrp = character.HumanoidRootPart
    if not equipFlyingCarpet() then return end
    
    notify("Teleporting to Base A...", 2, "info")
    
    task.wait(0.05)
    hrp.CFrame = CFrame.new(-362, -8, 20)
    task.wait(0.15)
    hrp.CFrame = CFrame.new(-331, -5, 18)
    task.wait(0.2)
    
    autoBlockPlayer()
    notify("Base A TP completed!", 2, "success")
end

local function teleportSequence2()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        notify("Character not found", 3, "error")
        return
    end
    
    local hrp = character.HumanoidRootPart
    if not equipFlyingCarpet() then return end
    
    notify("Teleporting to Base B...", 2, "info")
    
    task.wait(0.05)
    hrp.CFrame = CFrame.new(-367, -8, 96)
    task.wait(0.15)
    hrp.CFrame = CFrame.new(-332, -5, 101)
    task.wait(0.2)
    
    autoBlockPlayer()
    notify("Base B TP completed!", 2, "success")
end

-- TP TAB UI
createButton(TPTab, "🅰️ Teleport to Base A", teleportSequence1)
createLabel(TPTab, "Keybind: F")
createButton(TPTab, "🅱️ Teleport to Base B", teleportSequence2)
createLabel(TPTab, "Keybind: Y")

-- ===== AUTO STEAL SYSTEM =====
local AutoStealEnabled = false
local StealMode = "Highest"
local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
local Shared = ReplicatedStorage:WaitForChild("Shared", 10)
local Utils = ReplicatedStorage:WaitForChild("Utils", 10)

local Synchronizer, AnimalsData, AnimalsShared, NumberUtils

if Packages and Datas and Shared and Utils then
    Synchronizer = require(Packages:WaitForChild("Synchronizer", 5))
    AnimalsData = require(Datas:WaitForChild("Animals", 5))
    AnimalsShared = require(Shared:WaitForChild("Animals", 5))
    NumberUtils = require(Utils:WaitForChild("NumberUtils", 5))
end

local allAnimalsCache = {}
local InternalStealCache = {}
local PromptMemoryCache = {}
local plotChannels = {}
local lastAnimalData = {}
local stealConnection = nil

local function isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot then return false end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    
    if Synchronizer then
        local channel = Synchronizer:Get(plot.Name)
        if channel then
            local owner = channel:Get("Owner")
            if owner then
                if typeof(owner) == "Instance" and owner:IsA("Player") then
                    return owner.UserId == Player.UserId
                elseif typeof(owner) == "table" and owner.UserId then
                    return owner.UserId == Player.UserId
                elseif typeof(owner) == "Instance" then
                    return owner == Player
                end
            end
        end
    end
    
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") then
            return yourBase.Enabled == true
        end
    end
    
    return false
end

-- Fonction pour scanner tous les podiums
local function getAllPetPodiums()
    local podiums = {}
    local plots = workspace:FindFirstChild("Plots")
    
    if not plots then return podiums end
    
    for _, plot in ipairs(plots:GetChildren()) do
        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
        if animalPodiums then
            for _, podium in ipairs(animalPodiums:GetChildren()) do
                if podium:IsA("Model") or podium:IsA("Part") then
                    table.insert(podiums, podium)
                end
            end
        end
    end
    
    return podiums
end

local function findProximityPromptForAnimal(animalData)
    if not animalData then return nil end
    
    local cachedPrompt = PromptMemoryCache[animalData.uid]
    if cachedPrompt and cachedPrompt.Parent then
        return cachedPrompt
    end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    
    return nil
end

local function buildStealCallbacks(prompt)
    if InternalStealCache[prompt] then return end
    
    local data = {
        holdCallbacks = {},
        triggerCallbacks = {},
        ready = true,
    }
    
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        InternalStealCache[prompt] = data
    end
end

local function runCallbackList(list)
    for _, fn in ipairs(list) do
        task.spawn(fn)
    end
end

local function executeInternalStealAsync(prompt)
    local data = InternalStealCache[prompt]
    if not data or not data.ready then return false end
    
    data.ready = false
    
    task.spawn(function()
        if #data.holdCallbacks > 0 then
            runCallbackList(data.holdCallbacks)
        end
        
        task.wait(1.42)
        
        if #data.triggerCallbacks > 0 then
            runCallbackList(data.triggerCallbacks)
        end
        
        task.wait()
        data.ready = true
    end)
    
    return true
end

local function attemptSteal(prompt)
    if not prompt or not prompt.Parent then return false end
    buildStealCallbacks(prompt)
    if not InternalStealCache[prompt] then return false end
    return executeInternalStealAsync(prompt)
end

local function getAnimalHash(animalList)
    if not animalList then return "" end
    local hash = ""
    for slot, data in pairs(animalList) do
        if type(data) == "table" then
            hash = hash .. tostring(slot) .. tostring(data.Index) .. tostring(data.Mutation)
        end
    end
    return hash
end

local function scanSinglePlot(plot)
    if not Synchronizer or not AnimalsData or not AnimalsShared or not NumberUtils then return end
    
    pcall(function()        
        local plotUID = plot.Name
        local channel = Synchronizer:Get(plotUID)
        if not channel then return end
        
        local animalList = channel:Get("AnimalList")
        local currentHash = getAnimalHash(animalList)
        if lastAnimalData[plotUID] == currentHash then return end
        lastAnimalData[plotUID] = currentHash
        
        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then
                table.remove(allAnimalsCache, i)
            end
        end
        
        local owner = channel:Get("Owner")
        if not owner or not Players:FindFirstChild(owner.Name) then return end
        
        local ownerName = owner and owner.Name or "Unknown"
        if not animalList then return end
        
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = AnimalsData[animalName]
                if not animalInfo then continue end
                
                local mutation = animalData.Mutation or "None"
                local genValue = AnimalsShared:GetGeneration(animalName, animalData.Mutation, animalData.Traits, nil)
                local genText = "$" .. NumberUtils:ToString(genValue) .. "/s"
                
                table.insert(allAnimalsCache, {
                    name = animalInfo.DisplayName or animalName,
                    genText = genText,
                    genValue = genValue,
                    mutation = mutation,
                    owner = ownerName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
        
        table.sort(allAnimalsCache, function(a, b)
            return a.genValue > b.genValue
        end)
    end)
end

local function setupPlotListener(plot)
    if plotChannels[plot.Name] or not Synchronizer then return end
    
    local channel
    local retries = 0
    local maxRetries = 10
    
    while not channel and retries < maxRetries do
        local success, result = pcall(function()
            return Synchronizer:Get(plot.Name)
        end)
        if success and result then
            channel = result
            break
        else
            retries = retries + 1
            if retries < maxRetries then
                task.wait(0.5)
            end
        end
    end
    
    if not channel then return end
    plotChannels[plot.Name] = true
    
    scanSinglePlot(plot)
    
    task.spawn(function()
        while plot.Parent and plotChannels[plot.Name] do
            task.wait(5)
            scanSinglePlot(plot)
        end
    end)
end

local function initializePlotScanner()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    
    for _, plot in ipairs(plots:GetChildren()) do
        setupPlotListener(plot)
    end
    
    plots.ChildAdded:Connect(function(plot)
        task.wait(0.5)
        setupPlotListener(plot)
    end)
    
    plots.ChildRemoved:Connect(function(plot)
        plotChannels[plot.Name] = nil
        lastAnimalData[plot.Name] = nil
        
        for i = #allAnimalsCache, 1, -1 do
            if allAnimalsCache[i].plot == plot.Name then
                table.remove(allAnimalsCache, i)
            end
        end
    end)
end

local function getNearestAnimal()
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then return nil end
    
    local playerPos = character.HumanoidRootPart.Position
    local nearestAnimal = nil
    local nearestDistance = math.huge
    
    for _, animalData in ipairs(allAnimalsCache) do
        if not isMyBaseAnimal(animalData) then
            local plots = workspace:FindFirstChild("Plots")
            if plots then
                local plot = plots:FindFirstChild(animalData.plot)
                if plot then
                    local podiums = plot:FindFirstChild("AnimalPodiums")
                    if podiums then
                        local podium = podiums:FindFirstChild(animalData.slot)
                        if podium and podium:IsA("BasePart") then
                            local distance = (playerPos - podium.Position).Magnitude
                            if distance < nearestDistance then
                                nearestDistance = distance
                                nearestAnimal = animalData
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nearestAnimal
end

local function getHighestValueAnimal()
    for _, animalData in ipairs(allAnimalsCache) do
        if not isMyBaseAnimal(animalData) then
            return animalData
        end
    end
    return nil
end

-- FONCTION POUR TROUVER LE MEILLEUR PET
local function getBestPet()
    if not allAnimalsCache or #allAnimalsCache == 0 then
        return nil
    end
    
    local bestPet = nil
    local highestValue = 0
    
    for _, animalData in ipairs(allAnimalsCache) do
        if not isMyBaseAnimal(animalData) then
            if animalData.genValue and animalData.genValue > highestValue then
                highestValue = animalData.genValue
                bestPet = animalData
            end
        end
    end
    
    return bestPet
end

local function autoStealLoop()
    if stealConnection then
        stealConnection:Disconnect()
    end
    
    stealConnection = RunService.Heartbeat:Connect(function()
        if not AutoStealEnabled then return end
        
        local targetAnimal = nil
        
        if StealMode == "Highest" then
            targetAnimal = getHighestValueAnimal()
        elseif StealMode == "Nearest" then
            targetAnimal = getNearestAnimal()
        end
        
        if not targetAnimal then return end
        
        local prompt = PromptMemoryCache[targetAnimal.uid]
        if not prompt or not prompt.Parent then
            prompt = findProximityPromptForAnimal(targetAnimal)
        end
        
        if prompt then
            local success = attemptSteal(prompt)
            if success then
                task.wait(2)
            end
        end
    end)
end

task.spawn(function()
    task.wait(3)
    initializePlotScanner()
    autoStealLoop()
end)

-- STEAL TAB UI
local function createStealButton(parent, text, mode)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 52)
    btn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 15
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.AutoButtonColor = false
    btn.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = btn
    
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(98, 111, 252)}):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        if StealMode == mode then
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
        end
    end)
    
    btn.MouseButton1Click:Connect(function()
        StealMode = mode
        notify("Steal mode: " .. mode, 2, "info")
        
        for _, child in ipairs(StealTab:GetChildren()) do
            if child:IsA("TextButton") then
                if child.Text:find(mode) then
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(0, 200, 100)}):Play()
                else
                    TweenService:Create(child, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(88, 101, 242)}):Play()
                end
            end
        end
    end)
    
    if StealMode == mode then
        btn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    end
    
    return btn
end

createStealButton(StealTab, "🔼 Steal Highest", "Highest")
createStealButton(StealTab, "📍 Steal Nearest", "Nearest")

createToggle(StealTab, "Auto Steal", false, function(state)
    AutoStealEnabled = state
    if state then
        notify("Auto Steal Enabled - Mode: " .. StealMode, 2, "success")
        
        local count = 0
        for _, animalData in ipairs(allAnimalsCache) do
            if not isMyBaseAnimal(animalData) then
                count = count + 1
            end
        end
        
        if count > 0 then
            notify("Found " .. count .. " pets to steal", 3, "info")
        else
            notify("No pets found yet, scanning...", 3, "info")
        end
    else
        notify("Auto Steal Disabled", 2, "error")
    end
end)

-- ===== AUTO TURRET SYSTEM =====
local AutoDestroyEnabled = false
local DestroyConnection = nil
local BAT_NAME = "Bat"
local SENTRY_PREFIX = "Sentry_"

local function findSentry()
    local sentries = workspace:GetDescendants()
    for i = 1, #sentries do
        local obj = sentries[i]
        if (obj:IsA("Model") or obj:IsA("Part")) and obj.Name:find(SENTRY_PREFIX) then
            return obj
        end
    end
    return nil
end

local function equipBat()
    local character = Player.Character
    if not character then return false end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return false end
    
    local backpack = Player:WaitForChild("Backpack")
    local bat = backpack:FindFirstChild(BAT_NAME)
    
    if bat then
        humanoid:EquipTool(bat)
        return true
    end
    
    return false
end

local function unequipBat()
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    if not humanoid then return end
    
    local currentTool = character:FindFirstChildOfClass("Tool")
    
    if currentTool and currentTool.Name == BAT_NAME then
        humanoid:UnequipTools()
    end
end

local function attackSentry(sentry)
    if not sentry or not sentry.Parent then
        return false
    end
    
    if not equipBat() then
        return false
    end
    
    task.wait(0.2)
    
    local character = Player.Character
    if not character then return false end
    
    local bat = character:FindFirstChild(BAT_NAME)
    if bat then
        bat:Activate()
        task.wait(0.5)
        unequipBat()
        return true
    end
    
    return false
end

local function startAutoDestroy()
    if DestroyConnection then
        DestroyConnection:Disconnect()
        DestroyConnection = nil
    end
    
    AutoDestroyEnabled = true
    
    DestroyConnection = RunService.Heartbeat:Connect(function()
        if not AutoDestroyEnabled then
            if DestroyConnection then
                DestroyConnection:Disconnect()
                DestroyConnection = nil
            end
            return
        end
        
        local sentry = findSentry()
        
        if sentry then
            attackSentry(sentry)
            task.wait(3)
        else
            task.wait(1)
        end
    end)
end

local function stopAutoDestroy()
    AutoDestroyEnabled = false
    if DestroyConnection then
        DestroyConnection:Disconnect()
        DestroyConnection = nil
    end
end

-- TURRET TAB UI
createToggle(TurretTab, "Auto Destroy Turret", false, function(state)
    if state then
        startAutoDestroy()
        notify("Auto Destroy Turret Enabled", 2, "success")
    else
        stopAutoDestroy()
        notify("Auto Destroy Turret Disabled", 2, "error")
    end
end)

-- ===== ESP SYSTEM AVEC CHAMS =====
local ESPEnabled = false
local SkeletonEnabled = false
local BoxEnabled = false
local UsernameEnabled = false
local PetChamsEnabled = false -- CHAMS pour les pets
local PlayerChamsEnabled = false -- CHAMS pour les joueurs
local ESPColor = Color3.fromRGB(255, 0, 0)
-- COULEUR FIXE POUR LES CHAMS DES PETS - BLEU
local PetChamsColor = Color3.fromRGB(0, 150, 255) -- Bleu fixe
local PlayerChamsColor = Color3.fromRGB(255, 0, 0) -- Rouge pour les joueurs
local ESPObjects = {}
local ChamsObjects = {}

-- FONCTION POUR TROUVER LE PODIUM DU PET
local function findPetPodium(animalData)
    if not animalData then 
        return nil 
    end
    
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        return nil 
    end
    
    local plot = plots:FindFirstChild(animalData.plot)
    if not plot then 
        return nil 
    end
    
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then 
        return nil 
    end
    
    -- Chercher par slot d'abord
    local podium = podiums:FindFirstChild(animalData.slot)
    if podium then
        return podium
    end
    
    -- Si pas trouvé, chercher dans tous les enfants
    for _, child in ipairs(podiums:GetChildren()) do
        if child:IsA("Model") or child:IsA("Part") then
            return child
        end
    end
    
    return nil
end

-- FONCTION POUR CRÉER LES CHAMS DES PETS
local function createPetChams(animalData)
    if not animalData then return end
    
    -- Nettoyer les anciens chams
    if ChamsObjects[animalData.uid] then 
        local oldChams = ChamsObjects[animalData.uid]
        if oldChams.box then oldChams.box:Remove() end
        if oldChams.tracer then oldChams.tracer:Remove() end
        if oldChams.name then oldChams.name:Remove() end
        if oldChams.value then oldChams.value:Remove() end
        if oldChams.connection then oldChams.connection:Disconnect() end
    end
    
    -- Trouver le podium
    local podium = findPetPodium(animalData)
    if not podium then 
        print("[CHAMS] Podium not found for:", animalData.name)
        return 
    end
    
    -- Créer les dessins pour les chams
    local chams = {
        box = Drawing.new("Square"),
        tracer = Drawing.new("Line"),
        name = Drawing.new("Text"),
        value = Drawing.new("Text"),
        podium = podium
    }
    
    -- BOX CHAMS (BLEU TRANSPARENT POUR VOIR À TRAVERS LES MURS)
    chams.box.Thickness = 3
    chams.box.Color = PetChamsColor
    chams.box.Filled = true
    chams.box.Transparency = 0.3 -- TRANSPARENT POUR VOIR À TRAVERS
    chams.box.Visible = false
    chams.box.ZIndex = 1
    
    -- TRACER CHAMS (LIGNE QUI POINTE VERS LE PET)
    chams.tracer.Thickness = 2
    chams.tracer.Color = PetChamsColor
    chams.tracer.Transparency = 0.5
    chams.tracer.Visible = false
    chams.tracer.ZIndex = 1
    
    -- NOM DU PET
    chams.name.Text = "💎 " .. animalData.name .. " (" .. animalData.mutation .. ")"
    chams.name.Size = 16
    chams.name.Center = true
    chams.name.Outline = true
    chams.name.Color = PetChamsColor
    chams.name.Visible = false
    chams.name.ZIndex = 2
    
    -- VALEUR DU PET
    chams.value.Text = animalData.genText
    chams.value.Size = 14
    chams.value.Center = true
    chams.value.Outline = true
    chams.value.Color = Color3.fromRGB(255, 215, 0) -- Or
    chams.value.Visible = false
    chams.value.ZIndex = 2
    
    ChamsObjects[animalData.uid] = chams
    
    -- Connection pour mettre à jour les chams
    local updateConnection = RunService.RenderStepped:Connect(function()
        if not PetChamsEnabled then
            chams.box.Visible = false
            chams.tracer.Visible = false
            chams.name.Visible = false
            chams.value.Visible = false
            return
        end
        
        if not podium or not podium.Parent then
            if ChamsObjects[animalData.uid] then
                chams.box:Remove()
                chams.tracer:Remove()
                chams.name:Remove()
                chams.value:Remove()
                ChamsObjects[animalData.uid] = nil
            end
            return
        end
        
        -- Toujours afficher les chams, même à travers les murs
        local podiumPos = podium.Position
        local screenPos, onScreen = Camera:WorldToViewportPoint(podiumPos)
        
        -- Calculer la distance
        local distance = 50
        if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
            distance = (Player.Character.HumanoidRootPart.Position - podiumPos).Magnitude
        end
        
        -- TAILLE DE LA BOX (plus grande pour mieux voir)
        local size = math.clamp(1000 / distance, 30, 100)
        
        if onScreen then
            -- AFFICHER SUR L'ÉCRAN
            chams.box.Size = Vector2.new(size, size)
            chams.box.Position = Vector2.new(screenPos.X - size/2, screenPos.Y - size/2)
            chams.box.Visible = true
            
            chams.name.Position = Vector2.new(screenPos.X, screenPos.Y - size/2 - 25)
            chams.name.Visible = true
            
            chams.value.Position = Vector2.new(screenPos.X, screenPos.Y + size/2 + 15)
            chams.value.Visible = true
            
            chams.tracer.Visible = false
        else
            -- AFFICHER HORS ÉCRAN (TRACER)
            local viewportSize = Camera.ViewportSize
            local screenCenter = Vector2.new(viewportSize.X / 2, viewportSize.Y / 2)
            
            -- Calculer la direction vers le pet
            local direction = (podiumPos - Camera.CFrame.Position).Unit
            local screenDirection = Vector2.new(direction.X, direction.Y) * 100
            
            -- Position finale du tracer
            local tracerEnd = screenCenter + screenDirection
            
            chams.tracer.From = screenCenter
            chams.tracer.To = tracerEnd
            chams.tracer.Visible = true
            
            -- Afficher le nom et la valeur au bout du tracer
            chams.name.Position = tracerEnd
            chams.name.Visible = true
            chams.name.Text = "💎 " .. animalData.name .. " (" .. math.floor(distance) .. " studs)"
            
            chams.value.Position = Vector2.new(tracerEnd.X, tracerEnd.Y + 20)
            chams.value.Visible = true
            
            chams.box.Visible = false
        end
        
        -- Changer l'intensité de la couleur en fonction de la distance
        local colorIntensity = math.clamp(255 - distance / 10, 100, 255)
        chams.box.Color = Color3.fromRGB(0, colorIntensity, 255)
        chams.tracer.Color = Color3.fromRGB(0, colorIntensity, 255)
        chams.name.Color = Color3.fromRGB(0, colorIntensity, 255)
    end)
    
    chams.connection = updateConnection
    
    notify("Chams tracking: " .. animalData.name .. " - " .. animalData.genText, 2, "success")
end

-- FONCTION POUR METTRE À JOUR LES CHAMS DU MEILLEUR PET
local function updatePetChams()
    -- Nettoyer les anciens chams
    for uid, chams in pairs(ChamsObjects) do
        if chams.box then chams.box:Remove() end
        if chams.tracer then chams.tracer:Remove() end
        if chams.name then chams.name:Remove() end
        if chams.value then chams.value:Remove() end
        if chams.connection then chams.connection:Disconnect() end
    end
    ChamsObjects = {}
    
    if not PetChamsEnabled then return end
    
    -- Trouver le meilleur pet
    local bestPet = getBestPet()
    if bestPet then
        createPetChams(bestPet)
    else
        notify("No pets found for Chams", 2, "error")
    end
end

-- CHAMS POUR LES JOUEURS
local function createPlayerChams(player)
    if player == Player then return end
    
    if ChamsObjects[player] then
        local oldChams = ChamsObjects[player]
        if oldChams.box then oldChams.box:Remove() end
        if oldChams.name then oldChams.name:Remove() end
        if oldChams.connection then oldChams.connection:Disconnect() end
    end
    
    local chams = {
        box = Drawing.new("Square"),
        name = Drawing.new("Text")
    }
    
    -- BOX CHAMS POUR JOUEURS
    chams.box.Thickness = 2
    chams.box.Color = PlayerChamsColor
    chams.box.Filled = true
    chams.box.Transparency = 0.2 -- TRANSPARENT
    chams.box.Visible = false
    
    -- NOM DU JOUEUR
    chams.name.Text = player.Name
    chams.name.Size = 14
    chams.name.Center = true
    chams.name.Outline = true
    chams.name.Color = PlayerChamsColor
    chams.name.Visible = false
    
    ChamsObjects[player] = chams
    
    local updateConnection = RunService.RenderStepped:Connect(function()
        if not PlayerChamsEnabled then
            chams.box.Visible = false
            chams.name.Visible = false
            return
        end
        
        if not player or not player.Parent or not player.Character then
            chams.box.Visible = false
            chams.name.Visible = false
            return
        end
        
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        
        if not hrp or not head then
            chams.box.Visible = false
            chams.name.Visible = false
            return
        end
        
        local headPos, onScreen = Camera:WorldToViewportPoint(head.Position)
        
        if onScreen then
            local hrpPos = Camera:WorldToViewportPoint(hrp.Position)
            local height = math.abs(headPos.Y - hrpPos.Y) * 2
            local width = height / 2
            
            chams.box.Size = Vector2.new(width, height)
            chams.box.Position = Vector2.new(headPos.X - width/2, headPos.Y - height/2)
            chams.box.Visible = true
            
            chams.name.Position = Vector2.new(headPos.X, headPos.Y - height/2 - 20)
            chams.name.Visible = true
        else
            chams.box.Visible = false
            chams.name.Visible = false
        end
    end)
    
    chams.connection = updateConnection
end

local function removePlayerChams(player)
    if ChamsObjects[player] then
        if ChamsObjects[player].box then ChamsObjects[player].box:Remove() end
        if ChamsObjects[player].name then ChamsObjects[player].name:Remove() end
        if ChamsObjects[player].connection then ChamsObjects[player].connection:Disconnect() end
        ChamsObjects[player] = nil
    end
end

local function refreshPlayerChams()
    for player, chams in pairs(ChamsObjects) do
        if typeof(player) == "userdata" and player:IsA("Player") then
            removePlayerChams(player)
        end
    end
    
    if PlayerChamsEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Player then
                createPlayerChams(player)
            end
        end
    end
end

-- ESP NORMAL POUR LES JOUEURS
local function CreateESP(player)
    if player == Player then return end
    
    local esp = {Drawings = {}, Connections = {}}
    ESPObjects[player] = esp
    
    -- Lignes du squelette
    for i = 1, 5 do
        local line = Drawing.new("Line")
        line.Thickness = 2
        line.Color = ESPColor
        line.Transparency = 1
        line.Visible = false
        table.insert(esp.Drawings, line)
    end
    
    -- Box
    local box = Drawing.new("Square")
    box.Thickness = 2
    box.Color = ESPColor
    box.Transparency = 1
    box.Filled = false
    box.Visible = false
    table.insert(esp.Drawings, box)
    
    -- Nom
    local username = Drawing.new("Text")
    username.Text = player.Name
    username.Size = 16
    username.Center = true
    username.Outline = true
    username.Color = ESPColor
    username.Visible = false
    table.insert(esp.Drawings, username)
    
    local updateConnection = RunService.RenderStepped:Connect(function()
        if not player or not player.Parent or not player.Character then
            for _, drawing in pairs(esp.Drawings) do
                drawing.Visible = false
            end
            return
        end
        
        local char = player.Character
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local head = char:FindFirstChild("Head")
        local hum = char:FindFirstChild("Humanoid")
        
        if not hrp or not head or not hum or hum.Health <= 0 then
            for _, drawing in pairs(esp.Drawings) do
                drawing.Visible = false
            end
            return
        end
        
        local hrpPos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
        
        if not onScreen then
            for _, drawing in pairs(esp.Drawings) do
                drawing.Visible = false
            end
            return
        end
        
        for _, drawing in pairs(esp.Drawings) do
            if drawing.Color then
                drawing.Color = ESPColor
            end
        end
        
        -- SQUELETTE ESP
        if ESPEnabled and SkeletonEnabled then
            pcall(function()
                local headPos = Camera:WorldToViewportPoint(head.Position)
                local hrpPos = Camera:WorldToViewportPoint(hrp.Position)
                
                local leftArm = char:FindFirstChild("LeftUpperArm") or char:FindFirstChild("Left Arm")
                local rightArm = char:FindFirstChild("RightUpperArm") or char:FindFirstChild("Right Arm")
                local leftLeg = char:FindFirstChild("LeftUpperLeg") or char:FindFirstChild("Left Leg")
                local rightLeg = char:FindFirstChild("RightUpperLeg") or char:FindFirstChild("Right Leg")
                
                if leftArm and rightArm and leftLeg and rightLeg then
                    local laPos = Camera:WorldToViewportPoint(leftArm.Position)
                    local raPos = Camera:WorldToViewportPoint(rightArm.Position)
                    local llPos = Camera:WorldToViewportPoint(leftLeg.Position)
                    local rlPos = Camera:WorldToViewportPoint(rightLeg.Position)
                    
                    esp.Drawings[1].From = Vector2.new(headPos.X, headPos.Y)
                    esp.Drawings[1].To = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Drawings[1].Visible = true
                    
                    esp.Drawings[2].From = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Drawings[2].To = Vector2.new(laPos.X, laPos.Y)
                    esp.Drawings[2].Visible = true
                    
                    esp.Drawings[3].From = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Drawings[3].To = Vector2.new(raPos.X, raPos.Y)
                    esp.Drawings[3].Visible = true
                    
                    esp.Drawings[4].From = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Drawings[4].To = Vector2.new(llPos.X, llPos.Y)
                    esp.Drawings[4].Visible = true
                    
                    esp.Drawings[5].From = Vector2.new(hrpPos.X, hrpPos.Y)
                    esp.Drawings[5].To = Vector2.new(rlPos.X, rlPos.Y)
                    esp.Drawings[5].Visible = true
                else
                    for i = 1, 5 do
                        esp.Drawings[i].Visible = false
                    end
                end
            end)
        else
            for i = 1, 5 do
                esp.Drawings[i].Visible = false
            end
        end
        
        -- BOX ESP
        if ESPEnabled and BoxEnabled then
            pcall(function()
                local box = esp.Drawings[6]
                local topPos = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, 3, 0)).Position)
                local bottomPos = Camera:WorldToViewportPoint((hrp.CFrame * CFrame.new(0, -3, 0)).Position)
                
                local height = math.abs(topPos.Y - bottomPos.Y)
                local width = height / 2
                
                box.Size = Vector2.new(width, height)
                box.Position = Vector2.new(hrpPos.X - width/2, topPos.Y)
                box.Visible = true
            end)
        else
            esp.Drawings[6].Visible = false
        end
        
        -- USERNAME ESP
        if ESPEnabled and UsernameEnabled then
            pcall(function()
                local username = esp.Drawings[7]
                local headPos = Camera:WorldToViewportPoint((head.CFrame * CFrame.new(0, head.Size.Y/2 + 0.5, 0)).Position)
                username.Position = Vector2.new(headPos.X, headPos.Y)
                username.Text = player.Name
                username.Visible = true
            end)
        else
            esp.Drawings[7].Visible = false
        end
    end)
    
    table.insert(esp.Connections, updateConnection)
    
    local removeConnection = player.CharacterRemoving:Connect(function()
        for _, drawing in pairs(esp.Drawings) do
            drawing.Visible = false
        end
    end)
    
    table.insert(esp.Connections, removeConnection)
end

local function RemoveESP(player)
    if ESPObjects[player] then
        for _, connection in pairs(ESPObjects[player].Connections) do
            connection:Disconnect()
        end
        for _, drawing in pairs(ESPObjects[player].Drawings) do
            drawing:Remove()
        end
        ESPObjects[player] = nil
    end
end

local function RefreshESP()
    for player, _ in pairs(ESPObjects) do
        RemoveESP(player)
    end
    
    if ESPEnabled then
        for _, player in pairs(Players:GetPlayers()) do
            CreateESP(player)
        end
    end
end

-- ESP TAB UI - AVEC OPTIONS CHAMS
createToggle(ESPTab, "Enable Player ESP", false, function(state)
    ESPEnabled = state
    RefreshESP()
    notify(state and "Player ESP Enabled" or "Player ESP Disabled", 2, state and "success" or "error")
end)

createToggle(ESPTab, "Skeleton ESP", false, function(state)
    SkeletonEnabled = state
end)

createToggle(ESPTab, "Box ESP", false, function(state)
    BoxEnabled = state
end)

createToggle(ESPTab, "Username ESP", false, function(state)
    UsernameEnabled = state
end)

createToggle(ESPTab, "Player Chams", false, function(state)
    PlayerChamsEnabled = state
    refreshPlayerChams()
    notify(state and "Player Chams Enabled" or "Player Chams Disabled", 2, state and "success" or "error")
end)

-- CHAMS POUR LE MEILLEUR PET
createToggle(ESPTab, "💎 Pet Chams", false, function(state)
    PetChamsEnabled = state
    if state then
        updatePetChams()
        notify("Pet Chams Enabled (Blue - See through walls)", 2, "success")
    else
        -- Nettoyer les chams des pets
        for uid, chams in pairs(ChamsObjects) do
            if type(uid) == "string" and uid:find("_") then -- C'est un UID de pet
                if chams.box then chams.box:Remove() end
                if chams.tracer then chams.tracer:Remove() end
                if chams.name then chams.name:Remove() end
                if chams.value then chams.value:Remove() end
                if chams.connection then chams.connection:Disconnect() end
            end
        end
        notify("Pet Chams Disabled", 2, "error")
    end
end)

createButton(ESPTab, "🔄 Refresh All ESP", function()
    RefreshESP()
    refreshPlayerChams()
    if PetChamsEnabled then
        updatePetChams()
    end
    notify("All ESP refreshed", 2, "info")
end)

-- Gestion des joueurs
Players.PlayerAdded:Connect(function(player)
    if ESPEnabled then
        task.wait(1)
        CreateESP(player)
    end
    if PlayerChamsEnabled then
        task.wait(1)
        createPlayerChams(player)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    RemoveESP(player)
    removePlayerChams(player)
end)

-- Mettre à jour les Chams du pet périodiquement
task.spawn(function()
    while true do
        task.wait(5)
        if PetChamsEnabled then
            updatePetChams()
        end
    end
end)

-- ===== MISC FEATURES =====
local AimbotEnabled = false
local HitboxSize = 30
local OriginalSizes = {}

local function SetHitbox(character, size)
    if not character or character == Player.Character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not OriginalSizes[character] then
        OriginalSizes[character] = hrp.Size
    end
    hrp.Size = Vector3.new(size, size, size)
    hrp.Transparency = 0.5
    hrp.BrickColor = BrickColor.new("Really red")
    hrp.CanCollide = false
end

local function ResetHitbox(character)
    if not character or character == Player.Character then return end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if hrp and OriginalSizes[character] then
        hrp.Size = OriginalSizes[character]
        hrp.Transparency = 1
        hrp.CanCollide = true
        OriginalSizes[character] = nil
    end
end

local function EnableAimbot()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            SetHitbox(player.Character, HitboxSize)
        end
    end
    notify("Aimbot Enabled - Size: " .. HitboxSize, 2, "success")
end

local function DisableAimbot()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= Player and player.Character then
            ResetHitbox(player.Character)
        end
    end
    notify("Aimbot Disabled", 2, "error")
end

Players.PlayerAdded:Connect(function(player)
    if player == Player then return end
    player.CharacterAdded:Connect(function(character)
        if AimbotEnabled then
            task.wait(0.5)
            SetHitbox(character, HitboxSize)
        end
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= Player then
        player.CharacterAdded:Connect(function(character)
            if AimbotEnabled then
                task.wait(0.5)
                SetHitbox(character, HitboxSize)
            end
        end)
    end
end

-- FRIEND PANEL SYSTEM
local proximityPrompt = nil
local mainPanel = nil

local function findFriendPanel()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    
    local candidates = {}
    
    for _, plot in pairs(plots:GetChildren()) do
        local friendPanel = plot:FindFirstChild("FriendPanel")
        if friendPanel then
            local foundMain = friendPanel:FindFirstChild("Main")
            if foundMain then
                local foundPrompt = foundMain:FindFirstChild("ProximityPrompt")
                if foundPrompt then
                    local character = Player.Character
                    local distance = 999999
                    
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        distance = (character.HumanoidRootPart.Position - foundMain.Position).Magnitude
                    end
                    
                    table.insert(candidates, {
                        main = foundMain,
                        prompt = foundPrompt,
                        distance = distance
                    })
                end
            end
        end
    end
    
    if #candidates == 0 then return false end
    
    table.sort(candidates, function(a, b) return a.distance < b.distance end)
    
    local selected = candidates[1]
    mainPanel = selected.main
    proximityPrompt = selected.prompt
    
    return true
end

local function activateFriendPanel()
    if not proximityPrompt or not mainPanel then
        notify("Panel not found! Searching...", 2, "error")
        if findFriendPanel() then
            notify("Panel found! Activating...", 1, "info")
        else
            notify("No FriendPanel found!", 3, "error")
            return
        end
    end
    
    if fireproximityprompt then
        local success = pcall(function()
            fireproximityprompt(proximityPrompt)
        end)
        if success then
            notify("FriendPanel Activated!", 2, "success")
            return
        end
    end
    
    local character = Player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        notify("Character not found!", 3, "error")
        return
    end
    
    local hrp = character.HumanoidRootPart
    local originalPos = hrp.CFrame
    
    local success = pcall(function()
        hrp.CFrame = mainPanel.CFrame * CFrame.new(0, 0, -3)
        wait(0.2)
        
        if proximityPrompt.Enabled then
            proximityPrompt:InputHoldBegin()
            wait(proximityPrompt.HoldDuration or 0.5)
            proximityPrompt:InputHoldEnd()
        end
        
        wait(0.3)
        hrp.CFrame = originalPos
    end)
    
    if success then
        notify("FriendPanel Activated!", 2, "success")
    else
        notify("Activation failed!", 3, "error")
    end
end

-- MISC TAB UI
createToggle(MiscTab, "Aimbot (Hitbox Expander)", false, function(state)
    AimbotEnabled = state
    if state then
        EnableAimbot()
    else
        DisableAimbot()
    end
end)

createButton(MiscTab, "▶️ Activate FriendPanel", activateFriendPanel)
createLabel(MiscTab, "Keybind: H")

createButton(MiscTab, "🌐 Load Nameless HUB", function()
    notify("Loading Nameless HUB...", 2, "info")
    loadstring(game:HttpGet("https://raw.githubusercontent.com/ily123950/Vulkan/refs/heads/main/Tr"))()
end)

-- ===== KEYBINDS =====
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.F then
        teleportSequence1()
    elseif input.KeyCode == Enum.KeyCode.Y then
        teleportSequence2()
    elseif input.KeyCode == Enum.KeyCode.H then
        activateFriendPanel()
    elseif input.KeyCode == Enum.KeyCode.LeftControl then
        Main.Visible = not Main.Visible
        if Main.Visible then
            notify("Interface opened", 1, "info")
        end
    elseif input.KeyCode == Enum.KeyCode.R then
        if PetChamsEnabled then
            updatePetChams()
            notify("Pet Chams refreshed", 1, "info")
        end
    end
end)

-- Initial setup
task.spawn(function()
    wait(2)
    if findFriendPanel() then
        notify("FriendPanel detected!", 2, "success")
    else
        notify("FriendPanel not found - Press H to retry", 3, "info")
    end
end)

-- Initial notification
task.spawn(function()
    wait(1)
    notify("CBX HUB V3.0 loaded successfully!", 3, "success")
    notify("Whitelisted User: " .. Player.Name, 3, "info")
    notify("Press CTRL to open/close interface", 3, "info")
end)

-- Initialiser le scanner de plots
task.spawn(function()
    task.wait(3)
    initializePlotScanner()
    autoStealLoop()
end)