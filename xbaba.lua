local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- UI TEMİZLİK
local pGui = player:WaitForChild("PlayerGui")
if pGui:FindFirstChild("WolfFix") then pGui.WolfFix:Destroy() end

local wolfSettings = { 
    triggerbot = false, 
    infAmmo = false,
    noRecoil = false,
    theme = Color3.fromRGB(255, 0, 0) -- Hata belli olsun diye KIRMIZI tema
}

local sg = Instance.new("ScreenGui", pGui)
sg.Name = "WolfFix"
sg.ResetOnSpawn = false
sg.DisplayOrder = 99999

-- SABİT BUTON (SADECE TIKLAMA)
local btn = Instance.new("TextButton", sg)
btn.Size = UDim2.new(0, 70, 0, 70)
btn.Position = UDim2.new(1, -80, 0.5, -35)
btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
btn.Text = "WOLF"
btn.TextColor3 = wolfSettings.theme
btn.Font = "GothamBold"
btn.TextSize = 16
btn.ZIndex = 1000
Instance.new("UICorner", btn)

-- MENÜ PANELİ (BOŞ KALMASIN DİYE DİREKT FRAME)
local menu = Instance.new("Frame", sg)
menu.Size = UDim2.new(0, 250, 0, 300)
menu.Position = UDim2.new(0.5, -125, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.ZIndex = 900
Instance.new("UICorner", menu)
local stroke = Instance.new("UIStroke", menu)
stroke.Color = wolfSettings.theme
stroke.Width = 2

-- TIKLAMA KONTROLÜ
btn.MouseButton1Click:Connect(function()
    menu.Visible = not menu.Visible
end)

-- BUTONLARI DİREKT MENÜYE EKLE (SCROLLINGFRAME YOK!)
local function addBtn(txt, posy, callback)
    local t = Instance.new("TextButton", menu)
    t.Size = UDim2.new(0.9, 0, 0, 50)
    t.Position = UDim2.new(0.05, 0, 0, posy)
    t.Text = txt
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.ZIndex = 950
    Instance.new("UICorner", t)
    
    local s = false
    t.MouseButton1Click:Connect(function()
        s = not s
        t.BackgroundColor3 = s and wolfSettings.theme or Color3.fromRGB(30, 30, 30)
        callback(s)
    end)
end

-- BUTONLARI SIRALA (POSY DEĞERLERİNE DİKKAT)
addBtn("Triggerbot", 20, function(v) wolfSettings.triggerbot = v end)
addBtn("Inf Ammo", 80, function(v) wolfSettings.infAmmo = v end)
addBtn("No Recoil", 140, function(v) wolfSettings.noRecoil = v end)
addBtn("Speed (Hiz)", 200, function(v) 
    player.Character.Humanoid.WalkSpeed = v and 100 or 16 
end)

-- ANA DÖNGÜ (DURMADAN ÇALIŞIR)
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
                if v.Name == "Recoil" or v.Name == "Spread" then v.Value = 0 end
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
