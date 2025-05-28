-- Carregar Fluent UI
local Fluent = loadstring(game:HttpGet("https://raw.githubusercontent.com/LooseGames/Fluent/main/source.lua"))()

local Window = Fluent:CreateWindow({
    Title = "Kz Hub | Universal",
    SubTitle = "Script Universal com Fluent UI",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl
})

-- Variáveis
local aimbotEnabled = false
local playerESPEnabled = false
local npcESPEnabled = false
local FOV = 200
local antiAFKEnabled = false

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local npcList = {}

-- Aba Main
local mainTab = Window:AddTab({ Title = "Main", Icon = "🏃" })

mainTab:AddSlider("Dash Length", {
    Default = 10,
    Min = 10,
    Max = 1000,
    Rounding = 0,
    Callback = function(Value)
        LocalPlayer.Character:SetAttribute("DashLength", Value)
    end
})

mainTab:AddSlider("Jump Height", {
    Default = 10,
    Min = 10,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

-- Aba General
local generalTab = Window:AddTab({ Title = "General", Icon = "⚙️" })

generalTab:AddButton("Ativar FPS Boost", function()
    settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
    game.Lighting.Brightness = 0
    game.Lighting.ClockTime = 12
    game.Lighting.Technology = Enum.Technology.Compatibility

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.Plastic
            obj.Reflectance = 0
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end

    for _, effect in ipairs(game.Lighting:GetChildren()) do
        if effect:IsA("PostEffect") then
            effect.Enabled = false
        end
    end
end)

-- Anti AFK
local VirtualUser = game:GetService("VirtualUser")
LocalPlayer.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
    end
end)

generalTab:AddToggle("Anti AFK", false, function(Value)
    antiAFKEnabled = Value
end)

-- Speed
generalTab:AddSlider("Speed", {
    Default = 16,
    Min = 1,
    Max = 500,
    Rounding = 0,
    Callback = function(Value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
})

-- Aimbot
generalTab:AddToggle("Aimbot", false, function(Value)
    aimbotEnabled = Value
end)

local function GetClosestEnemy()
    local closest, shortestDist = nil, FOV

    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = player
                end
            end
        end
    end
    return closest
end

local function AimMouseAtTarget(target)
    if not target or not target.Character or not target.Character:FindFirstChild("Head") then return end
    local head = target.Character.Head
    local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
    if onScreen then
        VirtualInputManager:SendMouseMoveEvent(screenPos.X, screenPos.Y, game, 0)
    end
end

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = GetClosestEnemy()
        if target then
            AimMouseAtTarget(target)
        end
    end
end)

-- Aba Visual
local visualTab = Window:AddTab({ Title = "Visual", Icon = "👁️" })

local function createHighlight(model, color)
    local highlight = Instance.new("Highlight")
    highlight.Name = "AuraESP"
    highlight.FillColor = color
    highlight.OutlineColor = Color3.new(0, 0, 0)
    highlight.FillTransparency = 0.4
    highlight.OutlineTransparency = 0.1
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Adornee = model
    highlight.Parent = model
end

local function removeHighlight(model)
    if model:FindFirstChild("AuraESP") then
        model.AuraESP:Destroy()
    end
end

local function updatePlayerESP()
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            if playerESPEnabled and not plr.Character:FindFirstChild("AuraESP") then
                createHighlight(plr.Character, Color3.fromRGB(255, 0, 0))
            elseif not playerESPEnabled and plr.Character:FindFirstChild("AuraESP") then
                removeHighlight(plr.Character)
            end
        end
    end
end

local function scanNPCs()
    npcList = {}
    for _, model in pairs(workspace:GetDescendants()) do
        if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart")
            and not Players:GetPlayerFromCharacter(model) then
            table.insert(npcList, model)
        end
    end
end

local function updateNPCESP()
    for _, model in pairs(npcList) do
        if npcESPEnabled and not model:FindFirstChild("AuraESP") then
            pcall(function()
                model.PrimaryPart = model:FindFirstChild("HumanoidRootPart")
            end)
            createHighlight(model, Color3.fromRGB(255, 255, 0))
        elseif not npcESPEnabled and model:FindFirstChild("AuraESP") then
            removeHighlight(model)
        end
    end
end

task.spawn(function()
    while true do
        task.wait(10)
        if npcESPEnabled then scanNPCs() end
    end
end)

RunService.Heartbeat:Connect(function()
    if playerESPEnabled then updatePlayerESP() end
    if npcESPEnabled then updateNPCESP() end
end)

visualTab:AddToggle("ESP Players", false, function(Value)
    playerESPEnabled = Value
    if not Value then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr.Character then removeHighlight(plr.Character) end
        end
    end
end)

visualTab:AddToggle("ESP NPCs", false, function(Value)
    npcESPEnabled = Value
    if Value then
        scanNPCs()
    else
        for _, model in pairs(workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("AuraESP") then
                removeHighlight(model)
            end
        end
    end
end)

visualTab:AddSlider("Camera FOV", {
    Default = Camera.FieldOfView,
    Min = 1,
    Max = 550,
    Rounding = 0,
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})
