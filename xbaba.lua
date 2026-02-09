local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- UI TEMİZLİK
local function Cleanup()
    local pGui = player:FindFirstChild("PlayerGui")
    if pGui then
        for _, v in pairs(pGui:GetChildren()) do
            if v.Name:find("Wolf") or v.Name:find("Delta") then
                v:Destroy()
            end
        end
    end
end
Cleanup()

local wolfSettings = { 
    aimbot = false, 
    triggerbot = false, 
    infAmmo = false, -- Yeni Ayar
    theme = Color3.fromRGB(0, 190, 255) 
}

-- ANA GUI
local sg = Instance.new("ScreenGui")
sg.Name = "WolfX_" .. math.random(100, 999)
sg.Parent = player:WaitForChild("PlayerGui")
sg.ResetOnSpawn = false
sg.DisplayOrder = 999999

-- BUTON
local btn = Instance.new("TextButton")
btn.Name = "Main"
btn.Parent = sg
btn.Size = UDim2.new(0, 70, 0, 70)
btn.Position = UDim2.new(1, -100, 0.5, -35)
btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
btn.Text = "WOLF"
btn.TextColor3 = wolfSettings.theme
btn.Font = "GothamBold"
btn.TextSize = 18
btn.ZIndex = 1000000
btn.Draggable = true

Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 15)
local bStroke = Instance.new("UIStroke", btn)
bStroke.Color = wolfSettings.theme
bStroke.Width = 3

-- MENÜ PANELİ
local menu = Instance.new("Frame")
menu.Name = "Menu"
menu.Parent = sg
menu.Size = UDim2.new(0, 350, 0, 300) -- Biraz büyüttüm
menu.Position = UDim2.new(0.5, -175, 0.5, -150)
menu.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
menu.Visible = false
menu.ZIndex = 999999
Instance.new("UICorner", menu)
Instance.new("UIStroke", menu).Color = wolfSettings.theme

-- AÇ/KAPAT
local function toggle() menu.Visible = not menu.Visible end
btn.MouseButton1Click:Connect(toggle)
btn.TouchTap:Connect(toggle)

-- ÖZELLİKLER LİSTESİ
local container = Instance.new("ScrollingFrame", menu)
container.Size = UDim2.new(1, -20, 1, -20)
container.Position = UDim2.new(0, 10, 0, 10)
container.BackgroundTransparency = 1
local layout = Instance.new("UIListLayout", container); layout.Padding = UDim.new(0, 10)

local function addToggle(txt, callback)
    local t = Instance.new("TextButton", container)
    t.Size = UDim2.new(1, 0, 0, 45)
    t.Text = txt
    t.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    t.TextColor3 = Color3.new(1, 1, 1)
    t.Font = "Gotham"
    Instance.new("UICorner", t)
    local s = false
    t.MouseButton1Click:Connect(function()
        s = not s
        t.TextColor3 = s and wolfSettings.theme or Color3.new(1, 1, 1)
        callback(s)
    end)
end

addToggle("Aimbot Master", function(v) wolfSettings.aimbot = v end)
addToggle("Triggerbot Fix", function(v) wolfSettings.triggerbot = v end)
addToggle("Sınırsız Mermi (Inf Ammo)", function(v) wolfSettings.infAmmo = v end)

-- BİLDİRİM
local notify = Instance.new("TextLabel", sg)
notify.Size = UDim2.new(0, 200, 0, 50)
notify.Position = UDim2.new(0.5, -100, 0.1, 0)
notify.Text = "Wolf V105 Yüklendi!"
notify.TextColor3 = wolfSettings.theme
notify.BackgroundColor3 = Color3.new(0,0,0)
Instance.new("UICorner", notify)
task.delay(3, function() notify:Destroy() end)

-- ANA MOTOR (TRIGGER & AMMO)
RunService.RenderStepped:Connect(function()
    -- TRIGGERBOT
    if wolfSettings.triggerbot then
        local mouse = player:GetMouse()
        if mouse.Target then
            local model = mouse.Target:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChild("Humanoid") then
                local tP = Players:GetPlayerFromCharacter(model)
                if tP and tP ~= player and tP.Team ~= player.Team then
                    local tool = player.Character:FindFirstChildOfClass("Tool")
                    if tool then tool:Activate() end
                end
            end
        end
    end

    -- SINIRSIZ MERMİ (INF AMMO)
    if wolfSettings.infAmmo then
        local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
        if tool then
            -- Silahın içindeki tüm değerleri tarar (Ammo, Mag, Clip vb.)
            for _, v in pairs(tool:GetDescendants()) do
                if v:IsA("IntValue") or v:IsA("NumberValue") then
                    local name = v.Name:lower()
                    if name:find("ammo") or name:find("clip") or name:find("mag") or name:find("current") then
                        v.Value = 999
                    end
                end
            end
        end
    end
end)
