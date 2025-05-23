-- Carregar a UI library local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Criar a janela principal local Window = redzlib:MakeWindow({ Title = "KzHub", SubTitle = "", SaveFolder = "testando | redz lib v5.lua" })

-- Ícone de minimizar Window:AddMinimizeButton({ Button = { Image = "rbxassetid://136291516470826", BackgroundTransparency = 0 }, Corner = { CornerRadius = UDim.new(0, 6) }, })

-- Aba Discord local Tab1 = Window:MakeTab({ Title = "Discord", Icon = "rbxassetid://136291516470826" }) Tab1:AddDiscordInvite({ Name = "Kz Comunity", Description = "Servidor Oficial KzScripts", Logo = "rbxassetid://120342556899878", Invite = "https://discord.gg/c6VkQdt4vd" })

-- Aba de Funções local Funcoes = Window:MakeTab({ Title = "Main", Icon = "rbxassetid://106319096400681" })

local aimbotEnabled = false local RunService = game:GetService("RunService") local Players = game:GetService("Players") local LocalPlayer = Players.LocalPlayer

local function getClosestPlayer() local closestPlayer = nil local shortestDistance = math.huge for _, player in pairs(Players:GetPlayers()) do if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then local pos = workspace.CurrentCamera:WorldToViewportPoint(player.Character.Head.Position) local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).magnitude if magnitude < shortestDistance then closestPlayer = player shortestDistance = magnitude end end end return closestPlayer end

RunService.RenderStepped:Connect(function() if aimbotEnabled then local target = getClosestPlayer() if target and target.Character and target.Character:FindFirstChild("Head") then workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position, target.Character.Head.Position) end end end)

Funcoes:AddToggle({ Title = "Aimbot", Default = false, Callback = function(state) aimbotEnabled = state end })

