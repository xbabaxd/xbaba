local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI TEMİZLİK
local pGui = player:WaitForChild("PlayerGui")
if pGui:FindFirstChild("Wolf_Ultimate") then pGui.Wolf_Ultimate:Destroy() end

local wolfSettings = { 
    aimbot = false, 
    triggerbot = false, 
    infAmmo = false,
    noRecoil = false, -- Yeni Özellik
    theme = Color3.fromRGB(255, 85, 0) -- Turuncu FPS teması
}

local sg = Instance.new("ScreenGui", pGui)
sg.Name = "Wolf_Ultimate"
sg.ResetOnSpawn = false
sg.DisplayOrder = 999999

-- SABİT BUTON (SÜRÜKLEME KAPALI - SADECE TIKLAMA)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 70, 0, 70)
btn.Position = UDim2.new(1, -80, 0.5, -35) -- Sağ orta sabit
btn.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
btn.Text = "MENU"
btn.TextColor3 = wolfSettings.theme
btn.Font = "GothamBold"
btn.TextSize = 16
btn.ZIndex = 1000000
Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
Instance.new("UIStroke", btn).Color = wolfSettings.theme

-- MENÜ PANELİ
local menu = Instance.new("Frame", sg)
menu.Size = UDim2.new(0, 350, 0, 320)
menu.Position = UDim2.new(0.5, -175, 0.5, -160)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.ZIndex = 999998
Instance.new("UICorner", menu)
Instance.new("UIStroke", menu).Color = wolfSettings.theme

-- DELTA İÇİN EN GARANTİ TIKLAMA KODU
btn.Activated:Connect(function()
    menu.Visible = not menu.Visible
end)

-- ÖZELLİKLER LİSTESİ
local list = Instance.new("ScrollingFrame", menu)
list.Size = UDim2.new(1, -20, 1, -20)
list.Position = UDim2.new(0, 10, 0, 10)
list.BackgroundTransparency = 1
Instance.new("UIListLayout", list).Padding = UDim.new(0, 8)

local function addToggle(txt, callback)
    local t = Instance.new("TextButton", list)
    t.Size = UDim2.new(1, 0, 0, 45)
    t.Text = txt
    t.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    t.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    t.Font = "Gotham"
    Instance.new("UICorner", t)
    local s = false
    t.MouseButton1Click:Connect(function()
        s = not s
        t.TextColor3 = s and wolfSettings.theme or Color3.new(0.8, 0.8, 0.8)
        callback(s)
    end)
end

addToggle("Triggerbot", function(v) wolfSettings.triggerbot = v end)
addToggle("Infinite Ammo", function(v) wolfSettings.infAmmo = v end)
addToggle("No Recoil (Sekmeme)", function(v) wolfSettings.noRecoil = v end)

-- ANA DÖNGÜ
RunService.RenderStepped:Connect(function()
    local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
    
    if tool then
        -- 1. SINIRSIZ MERMİ
        if wolfSettings.infAmmo then
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    if v.Name:lower():find("ammo") or v.Name:lower():find("mag") then v.Value = 999 end
                end
            end
        end

        -- 2. SEKMEME (NO RECOIL)
        if wolfSettings.noRecoil then
            for _, v in pairs(tool:GetDescendants()) do
                if v.Name == "Recoil" or v.Name == "Spread" or v.Name == "Shake" then
                    if v:IsA("NumberValue") or v:IsA("IntValue") then v.Value = 0 end
                end
            end
        end
    end

    -- 3. TRIGGERBOT
    if wolfSettings.triggerbot and mouse.Target then
        local model = mouse.Target:FindFirstAncestorOfClass("Model")
        if model and model:FindFirstChild("Humanoid") then
            local tP = Players:GetPlayerFromCharacter(model)
            if tP and tP.Team ~= player.Team then
                if tool then tool:Activate() end
            end
        end
    end
end)
