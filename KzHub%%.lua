local a = game.Players.LocalPlayer
local b = game:GetService("UserInputService")
local c = game:GetService("TweenService")
local d = game:GetService("RunService")
local e = game:GetService("Workspace")
local f = 1

-- LOADING
do
    local g = Instance.new("ScreenGui", a.PlayerGui)
    g.Name = "KzHubLoading"
    g.IgnoreGuiInset = true
    g.ResetOnSpawn = false
    
    local h = Instance.new("Frame", g)
    h.Size = UDim2.new(1, 0, 1, 0)
    h.BackgroundColor3 = Color3.new(0, 0, 0)
    h.BorderSizePixel = 0
    
    local i = Instance.new("ImageLabel", h)
    i.Size = UDim2.new(0, 96, 0, 96)
    i.Position = UDim2.new(0.5, -48, 0.25, 0) -- Movido para cima (era 0.32)
    i.BackgroundTransparency = 1
    i.ImageTransparency = 1
    i.Image = "rbxassetid://71567579053009"
    
    -- Adicionar corner para tornar a imagem redonda
    local imageCorner = Instance.new("UICorner", i)
    imageCorner.CornerRadius = UDim.new(0.5, 0) -- 50% para círculo perfeito
    
    local j = Instance.new("TextLabel", h)
    j.Size = UDim2.new(1, 0, 0, 70)
    j.Position = UDim2.new(0, 0, 0.42, 0) -- Ajustado para acompanhar a imagem
    j.BackgroundTransparency = 1
    j.Text = "Kz Hub X Steal a Brainrot"
    j.Font = Enum.Font.GothamBlack
    j.TextSize = 42
    j.TextColor3 = Color3.new(1, 1, 1)
    j.TextStrokeTransparency = 0.2
    j.TextXAlignment = Enum.TextXAlignment.Center
    j.TextYAlignment = Enum.TextYAlignment.Center
    j.TextTransparency = 1
    
    local k = Instance.new("TextLabel", h)
    k.Size = UDim2.new(1, 0, 0, 30)
    k.Position = UDim2.new(0, 0, 0.56, 0) -- Ajustado para acompanhar
    k.BackgroundTransparency = 1
    k.Text = "Made By Team KzHub"
    k.Font = Enum.Font.GothamBold
    k.TextSize = 22
    k.TextColor3 = Color3.new(1, 1, 1)
    k.TextStrokeTransparency = 0.25
    k.TextXAlignment = Enum.TextXAlignment.Center
    k.TextYAlignment = Enum.TextYAlignment.Center
    k.TextTransparency = 1
    
    local l = Instance.new("TextLabel", h)
    l.Size = UDim2.new(1, 0, 0, 26)
    l.Position = UDim2.new(0, 0, 0.62, 0) -- Ajustado para acompanhar
    l.BackgroundTransparency = 1
    l.Text = "Youtube-KzScripts"
    l.Font = Enum.Font.Gotham
    l.TextSize = 19
    l.TextColor3 = Color3.new(1, 1, 1)
    l.TextStrokeTransparency = 0.35
    l.TextXAlignment = Enum.TextXAlignment.Center
    l.TextYAlignment = Enum.TextYAlignment.Center
    l.TextTransparency = 1
    
    local function m(n, o, p, q)
        local r = c:Create(n, TweenInfo.new(q, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {[o] = p})
        r:Play()
        return r
    end
    
    m(i, "ImageTransparency", 0, 0.7)
    wait(0.3)
    m(j, "TextTransparency", 0, 0.7)
    wait(0.1)
    m(k, "TextTransparency", 0, 0.6)
    wait(0.05)
    m(l, "TextTransparency", 0, 0.6)
    wait(2.1)
    wait(1.2)
    m(i, "ImageTransparency", 1, 0.6)
    m(j, "TextTransparency", 1, 0.6)
    m(k, "TextTransparency", 1, 0.6)
    m(l, "TextTransparency", 1, 0.6)
    wait(0.65)
    g:Destroy()
end


-- Serviços
local Players = game:GetService("Players")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

-- Aguardar o player carregar completamente
local player = Players.LocalPlayer
if not player then
    repeat 
        wait(0.1) 
        player = Players.LocalPlayer 
    until player
end

-- Aguardar PlayerGui carregar
local playerGui = player:WaitForChild("PlayerGui", 10)
if not playerGui then
    warn("PlayerGui não carregou!")
    return
end

-- Verificar se já existe uma UI ativa
if playerGui:FindFirstChild("KeySystemUI") then
    playerGui.KeySystemUI:Destroy()
    wait(0.1)
end

-- Criar interface principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "KeySystemUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Frame principal
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 360, 0, 200)
frame.Position = UDim2.new(0.5, -180, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.ZIndex = 1
frame.Parent = screenGui

-- Cantos arredondados do frame
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 8)
uiCorner.Parent = frame

-- Título
local title = Instance.new("TextLabel")
title.Text = "Kz Scripts Key"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundTransparency = 1
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(200, 200, 255)
title.TextXAlignment = Enum.TextXAlignment.Center
title.TextYAlignment = Enum.TextYAlignment.Center
title.ZIndex = 2
title.Parent = frame

-- Caixa de texto da key
local textBox = Instance.new("TextBox")
textBox.PlaceholderText = "SUA-KEY-AKI"
textBox.Text = ""
textBox.Size = UDim2.new(0.9, 0, 0, 40)
textBox.Position = UDim2.new(0.05, 0, 0.25, 0)
textBox.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
textBox.TextColor3 = Color3.fromRGB(230, 230, 230)
textBox.Font = Enum.Font.Gotham
textBox.TextSize = 16
textBox.ClearTextOnFocus = false
textBox.TextXAlignment = Enum.TextXAlignment.Center
textBox.ZIndex = 2
textBox.Parent = frame

local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 6)
textBoxCorner.Parent = textBox

-- Função para criar botões
local function createButton(name, text, color, position)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = text
    btn.Size = UDim2.new(0.42, 0, 0, 36)
    btn.Position = position
    btn.BackgroundColor3 = color
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 16
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.ZIndex = 2
    btn.Parent = frame
    
    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = btn
    
    -- Animação de hover
    btn.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)
        })
        hoverTween:Play()
    end)
    
    btn.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = color
        })
        leaveTween:Play()
    end)
    
    return btn
end

-- Botões
local getBtn = createButton("GetBtn", "Get Key", Color3.fromRGB(50, 100, 200), UDim2.new(0.05, 0, 0.55, 0))
local verifyBtn = createButton("VerifyBtn", "Check Key", Color3.fromRGB(60, 180, 130), UDim2.new(0.53, 0, 0.55, 0))

-- Mensagem de status
local msg = Instance.new("TextLabel")
msg.Text = "Digite sua key e clique em Check Key"
msg.Size = UDim2.new(1, 0, 0, 24)
msg.Position = UDim2.new(0, 0, 0.85, 0)
msg.BackgroundTransparency = 1
msg.Font = Enum.Font.Gotham
msg.TextSize = 14
msg.TextColor3 = Color3.fromRGB(150, 150, 150)
msg.TextXAlignment = Enum.TextXAlignment.Center
msg.ZIndex = 2
msg.Parent = frame

-- Função para mostrar mensagem temporária
local function showMessage(text, color, duration)
    msg.Text = text
    msg.TextColor3 = color or Color3.fromRGB(200, 100, 100)
    
    if duration and duration > 0 then
        task.delay(duration, function()
            if msg and msg.Parent then
                msg.Text = "Digite sua key e clique em Check Key"
                msg.TextColor3 = Color3.fromRGB(150, 150, 150)
            end
        end)
    end
end

-- Função do botão Get Key
getBtn.MouseButton1Click:Connect(function()
    local success, error = pcall(function()
        setclipboard("https://lootdest.org/s?dohYZ9Ql")
    end)
    
    if success then
        showMessage("Link copiado para área de transferência!", Color3.fromRGB(100, 200, 100), 3)
    else
        showMessage("Erro ao copiar link", Color3.fromRGB(200, 100, 100), 3)
    end
end)

-- Função do botão Check Key
verifyBtn.MouseButton1Click:Connect(function()
    local key = textBox.Text
    
    if key == "" or key == " " then
        showMessage("Digite uma key primeiro!", Color3.fromRGB(200, 100, 100), 3)
        return
    end
    
    -- Limpar e formatar key
    key = key:upper():gsub("%s+", "")
    
    -- Verificar formato da key (KZ-FREE-KEY-XXXX-XXXX) - aceita qualquer combinação
    if key:match("^KZ%-FREE%-KEY%-.+%-.+$") then
        showMessage("Key válida! Carregando script...", Color3.fromRGB(100, 200, 100), 2)
        
        -- Animação de fechamento
        local closeTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0)
        })
        
        closeTween:Play()
        closeTween.Completed:Wait()
        
        -- Destruir UI e carregar script
        screenGui:Destroy()
        
        -- Tentar carregar o script principal
        local success, error = pcall(function()
            loadstring(game:HttpGet("https://raw.githubusercontent.com/KzScripts/KzHubUniversal/refs/heads/main/20%25Kz.lua"))()
        end)
        
        if not success then
            warn("Erro ao carregar o script principal: " .. tostring(error))
        end
        
    else
        showMessage("Key inválida! ", Color3.fromRGB(200, 100, 100), 5)
    end
end)

-- Permitir Enter para verificar key
textBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        verifyBtn.MouseButton1Click:Fire()
    end
end)

-- Animação de entrada
frame.Size = UDim2.new(0, 0, 0, 0)
local openTween = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 360, 0, 200)
})
openTween:Play()

-- Notificação de carregamento
local success, error = pcall(function()
    StarterGui:SetCore("SendNotification", {
        Title = "KzHub Key System",
        Text = "Sistema carregado! Click em Get Key ",
        Duration = 5,
    })
end)

if not success then
    print("Sistema de Key carregado com sucesso!")
    print("Use o formato: KZ-FREE-KEY-XXXX-XXXX")
end

print("✅ Key System totalmente carregado e funcional!")

