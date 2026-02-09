local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI TEMİZLİK
local pGui = player:WaitForChild("PlayerGui")
if pGui:FindFirstChild("WolfUltimate_Mavi") then pGui.WolfUltimate_Mavi:Destroy() end

local wolfSettings = { 
    triggerbot = false, 
    infAmmo = false,
    noRecoil = false,
    theme = Color3.fromRGB(0, 170, 255) -- İSTEDİĞİN MAVİ TEMA
}

local sg = Instance.new("ScreenGui", pGui)
sg.Name = "WolfUltimate_Mavi"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999999

-- 1. ÖZEL SÜRÜKLENEBİLİR BUTON SİSTEMİ (DELTA İÇİN)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 70, 0, 70)
btn.Position = UDim2.new(1, -100, 0.5, 0)
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.Text = "WOLF"
btn.TextColor3 = wolfSettings.theme
btn.Font = "GothamBold"
btn.TextSize = 16
btn.ZIndex = 10000
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
local bStroke = Instance.new("UIStroke", btn)
bStroke.Color = wolfSettings.theme
bStroke.Width = 3

-- Sürükleme Mantığı
local dragging, dragInput, dragStart, startPos
btn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = btn.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        btn.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- 2. MENÜ PANELİ
local menu = Instance.new("Frame", sg)
menu.Size = UDim2.new(0, 280, 0, 320)
menu.Position = UDim2.new(0.5, -140, 0.5, -160)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.ZIndex = 9000
Instance.new("UICorner", menu)
local mStroke = Instance.new("UIStroke", menu)
mStroke.Color = wolfSettings.theme
mStroke.Width = 2

-- AÇ/KAPAT
btn.MouseButton1Click:Connect(function() menu.Visible = not menu.Visible end)

-- 3. BUTONLAR (TEK TEK SABİTLENDİ - BOŞ KALAMAZ)
local function createFeature(name, yPos, callback)
    local fBtn = Instance.new("TextButton", menu)
    fBtn.Size = UDim2.new(0.9, 0, 0, 50)
    fBtn.Position = UDim2.new(0.05, 0, 0, yPos)
    fBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    fBtn.Text = name
    fBtn.TextColor3 = Color3.new(1, 1, 1)
    fBtn.Font = "GothamBold"
    fBtn.TextSize = 14
    fBtn.ZIndex = 9500
    Instance.new("UICorner", fBtn)
    
    local active = false
    fBtn.MouseButton1Click:Connect(function()
        active = not active
        fBtn.BackgroundColor3 = active and wolfSettings.theme or Color3.fromRGB(25, 25, 25)
        fBtn.TextColor3 = active and Color3.new(0,0,0) or Color3.new(1,1,1)
        callback(active)
    end)
end

-- Butonları Diziyoruz
createFeature("Triggerbot (Oto Ates)", 20, function(v) wolfSettings.triggerbot = v end)
createFeature("Infinite Ammo (Mermi)", 85, function(v) wolfSettings.infAmmo = v end)
createFeature("No Recoil (Sekmeme)", 150, function(v) wolfSettings.noRecoil = v end)
createFeature("Speed Hack (Hizli Koşu)", 215, function(v) 
    player.Character.Humanoid.WalkSpeed = v and 120 or 16 
end)

-- 4. OYUN MOTORU
RunService.Heartbeat:Connect(function()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    
    if tool then
        if wolfSettings.infAmmo then
            for _, v in pairs(tool:GetDescendants()) do
                if (v:IsA("IntValue") or v:IsA("NumberValue")) and (v.Name:lower():find("ammo") or v.Name:lower():find("mag")) then
                    v.Value = 999
                end
            end
        end
        if wolfSettings.noRecoil then
            for _, v in pairs(tool:GetDescendants()) do
                if v.Name == "Recoil" or v.Name == "Spread" or v.Name == "Shake" then v.Value = 0 end
            end
        end
    end

    if wolfSettings.triggerbot and mouse.Target then
        local model = mouse.Target:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChild("Humanoid") and Players:GetPlayerFromCharacter(model) then
            if Players:GetPlayerFromCharacter(model).Team ~= player.Team then
                if tool then tool:Activate() end
            end
        end
    end
end)
