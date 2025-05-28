-- carregar OrionLib
local OrionLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/shlexware/Orion/main/source"))()

local Window = OrionLib:MakeWindow({
    Name = "Kz Hub | Universal",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "KzHub"
})

-- Variáveis de controle
local aimbotEnabled = false
local playerESPEnabled = false
local npcESPEnabled = false
local FOV = 200
local antiAFKEnabled = false

-- Funções auxiliares
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Camera = workspace.CurrentCamera
local npcList = {}

-- Tabs e Seções
local mainTab = Window:MakeTab({Name = "Main", Icon = "rbxassetid://4483345998", PremiumOnly = false})
mainTab:AddSection({Name = "Players"})

mainTab:AddSlider({
    Name = "Dash length",
    Min = 10,
    Max = 1000,
    Default = 10,
    Increment = 1,
    Callback = function(Value)
        LocalPlayer.Character:SetAttribute("DashLength", Value)
    end
})

mainTab:AddSlider({
    Name = "Jump Height",
    Min = 10,
    Max = 500,
    Default = 10,
    Increment = 1,
    Callback = function(Value)
        LocalPlayer.Character.Humanoid.JumpPower = Value
    end
})

local generalTab = Window:MakeTab({Name = "General", Icon = "rbxassetid://4483345998", PremiumOnly = false})
generalTab:AddSection({Name = "Melhorar FPS"})

generalTab:AddButton({
    Name = "Ativar FPS Boost",
    Callback = function()
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

        OrionLib:MakeNotification({Name = "FPS Boost", Content = "Melhor desempenho ativado!", Time = 4})
    end
})

generalTab:AddSection({Name = "Anti AFK"})
local VirtualUser = game:GetService("VirtualUser")

LocalPlayer.Idled:Connect(function()
    if antiAFKEnabled then
        VirtualUser:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
    end
end)

generalTab:AddToggle({
    Name = "Ativar Anti AFK",
    Default = false,
    Callback = function(Value)
        antiAFKEnabled = Value
        OrionLib:MakeNotification({
            Name = "Anti AFK",
            Content = Value and "Protegido contra kick!" or "Kick por inatividade reativado.",
            Time = 4
        })
    end
})

generalTab:AddSection({Name = "Speed"})
generalTab:AddSlider({
    Name = "Speed",
    Min = 1,
    Max = 500,
    Default = 16,
    Increment = 1,
    Callback = function(Value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.WalkSpeed = Value
        end
    end
})

-- Aimbot
generalTab:AddSection({Name = "Aimbot"})

local function GetClosestEnemy()
    local closest = nil
    local shortestDist = FOV

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

generalTab:AddToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(Value)
        aimbotEnabled = Value
    end
})

-- Visual
local visualTab = Window:MakeTab({Name = "Visual", Icon = "rbxassetid://4483345998", PremiumOnly = false})
visualTab:AddSection({Name = "ESP"})

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

visualTab:AddToggle({
    Name = "ESP Players",
    Default = false,
    Callback = function(Value)
        playerESPEnabled = Value
        if not Value then
            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then removeHighlight(plr.Character) end
            end
        end
    end
})

visualTab:AddToggle({
    Name = "ESP NPCs",
    Default = false,
    Callback = function(Value)
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
    end
})

visualTab:AddSection({Name = "Controle FOV"})

visualTab:AddSlider({
    Name = "Camera FOV",
    Min = 1,
    Max = 550,
    Default = Camera.FieldOfView,
    Increment = 1,
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})

OrionLib:Init()
