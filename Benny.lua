local plr = game.Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui", 5) or plr.PlayerGui

-- Membersihkan UI lama jika script di-execute ulang
if PlayerGui:FindFirstChild("STARGOD_AUTO_WALK") then
    PlayerGui["STARGOD_AUTO_WALK"]:Destroy()
end

-- ==========================================
-- UI INTERFACE MINIMALIS
-- ==========================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "STARGOD_AUTO_WALK"
ScreenGui.Parent = PlayerGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.Size = UDim2.new(0, 200, 0, 110)
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 0, 0, 8); Title.Size = UDim2.new(1, 0, 0, 20)
Title.Font = Enum.Font.GothamBold; Title.Text = "★ AUTO WALK MONSTER ★"; Title.TextColor3 = Color3.fromRGB(255, 255, 255); Title.TextSize = 10

local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame; ToggleBtn.Position = UDim2.new(0, 15, 0, 40); ToggleBtn.Size = UDim2.new(1, -30, 0, 35)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 58); ToggleBtn.Font = Enum.Font.GothamSemibold; ToggleBtn.Text = "AUTO FIGHT : OFF"; ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200); ToggleBtn.TextSize = 10
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 5)

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Parent = MainFrame; StatusLabel.BackgroundTransparency = 1; StatusLabel.Position = UDim2.new(0, 0, 0, 80); StatusLabel.Size = UDim2.new(1, 0, 0, 20)
StatusLabel.Font = Enum.Font.Gotham; StatusLabel.Text = "Status: Idle"; StatusLabel.TextColor3 = Color3.fromRGB(160, 160, 175); StatusLabel.TextSize = 9

-- ==========================================
-- ENGINE LOGIC
-- ==========================================
local isAutoWalkOn = false

ToggleBtn.MouseButton1Click:Connect(function()
    isAutoWalkOn = not isAutoWalkOn
    if isAutoWalkOn then
        ToggleBtn.Text = "AUTO FIGHT : ON"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        StatusLabel.Text = "Status: Mencari Target..."
    else
        ToggleBtn.Text = "AUTO FIGHT : OFF"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 42, 58)
        ToggleBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
        StatusLabel.Text = "Status: Idle"
        
        -- Hentikan pergerakan karakter saat dimatikan
        local char = plr.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid:MoveTo(char.HumanoidRootPart.Position)
        end
    end
end)

local function getNearestMonster()
    local char = plr.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end

    local closestMonster = nil
    local shortestDistance = 500 -- Radius jangkauan mata mencari monster

    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj ~= char and not game.Players:GetPlayerFromCharacter(obj) then
            local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
            local hum = obj:FindFirstChildOfClass("Humanoid")
            
            if root and hum and hum.Health > 0 then
                local dist = (root.Position - hrp.Position).Magnitude
                if dist < shortestDistance then
                    shortestDistance = dist
                    closestMonster = root
                end
            end
        end
    end
    return closestMonster
end

-- ==========================================
-- BACKGROUND WORKER (PURE WALK TRACKING)
-- ==========================================
task.spawn(function()
    while true do
        task.wait(0.2) -- Update arah jalan setiap 0.2 detik agar bisa nge-track monster yang gerak
        if isAutoWalkOn then
            pcall(function()
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local humanoid = char and char:FindFirstChildOfClass("Humanoid")
                
                if hrp and humanoid then
                    -- Cek apakah karakter sedang tidak di-freeze (berarti sedang di map biasa)
                    if not hrp.Anchored then
                        local target = getNearestMonster()
                        
                        if target then
                            StatusLabel.Text = "Status: Mengejar " .. target.Parent.Name .. "..."
                            
                            -- Murni jalan kaki mengejar target (tanpa teleport)
                            humanoid:MoveTo(target.Position)
                        else
                            StatusLabel.Text = "Status: Menunggu Monster Spawn..."
                        end
                    else
                        -- Jika karakter di-freeze, berarti pertarungan sedang berlangsung
                        StatusLabel.Text = "Status: Dalam Pertarungan..."
                    end
                end
            end)
        end
    end
end)