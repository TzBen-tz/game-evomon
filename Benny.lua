local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("BENNY_UI_SHOWCASE") then
	PlayerGui.BENNY_UI_SHOWCASE:Destroy()
end

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BENNY_UI_SHOWCASE"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- MAIN FRAME
local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.AnchorPoint = Vector2.new(0,0)
MainFrame.Position = UDim2.new(0.05,0,0.2,0)
MainFrame.Size = UDim2.new(0,0,0,0)
MainFrame.BackgroundColor3 = Color3.fromRGB(55,20,90)
MainFrame.Active = true
MainFrame.Draggable = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0,10)
Corner.Parent = MainFrame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = MainFrame
Stroke.Color = Color3.fromRGB(170,70,255)
Stroke.Thickness = 2

-- ANIMASI MASUK
TweenService:Create(
	MainFrame,
	TweenInfo.new(0.5, Enum.EasingStyle.Back),
	{Size = UDim2.new(0,250,0,180)}
):Play()

-- TITLE
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Size = UDim2.new(1,0,0,30)
Title.Position = UDim2.new(0,0,0,5)
Title.Font = Enum.Font.GothamBold
Title.Text = "★ BENNY UI SHOWCASE ★"
Title.TextColor3 = Color3.fromRGB(255,255,255)
Title.TextSize = 12

-- STATUS
local Status = Instance.new("TextLabel")
Status.Parent = MainFrame
Status.BackgroundTransparency = 1
Status.Position = UDim2.new(0,0,0,115)
Status.Size = UDim2.new(1,0,0,20)
Status.Text = "Status: Ready"
Status.Font = Enum.Font.Gotham
Status.TextColor3 = Color3.fromRGB(220,220,220)
Status.TextSize = 10

-- CREDIT
local Credit = Instance.new("TextLabel")
Credit.Parent = MainFrame
Credit.BackgroundTransparency = 1
Credit.Position = UDim2.new(0,0,0,145)
Credit.Size = UDim2.new(1,0,0,20)
Credit.Text = "Script By Benny Setyawan"
Credit.Font = Enum.Font.GothamBold
Credit.TextColor3 = Color3.fromRGB(190,160,255)
Credit.TextSize = 9

-- SOUND
local ClickSound = Instance.new("Sound")
ClickSound.Parent = SoundService
ClickSound.SoundId = "rbxassetid://9118828560"
ClickSound.Volume = 0.5

-- POPUP
local function Notify(text)
	local Label = Instance.new("TextLabel")
	Label.Parent = ScreenGui
	Label.Size = UDim2.new(0,260,0,40)
	Label.Position = UDim2.new(0.5,-130,-0.15,0)

	Label.BackgroundColor3 = Color3.fromRGB(80,40,150)
	Label.TextColor3 = Color3.new(1,1,1)
	Label.Font = Enum.Font.GothamBold
	Label.TextScaled = true
	Label.Text = text

	Instance.new("UICorner", Label)

	TweenService:Create(
		Label,
		TweenInfo.new(0.4),
		{Position = UDim2.new(0.5,-130,0.05,0)}
	):Play()

	task.wait(2)

	TweenService:Create(
		Label,
		TweenInfo.new(0.4),
		{Position = UDim2.new(0.5,-130,-0.15,0)}
	):Play()

	task.wait(0.5)
	Label:Destroy()
end

-- HUJAN TEKS
local function RainText(text, count)
	for i = 1, count do
		task.spawn(function()
			local Label = Instance.new("TextLabel")
			Label.Parent = ScreenGui
			Label.BackgroundTransparency = 1
			Label.Size = UDim2.new(0,180,0,40)

			local x = math.random(5,95)/100
			Label.Position = UDim2.new(x,0,-0.1,0)

			Label.Text = text
			Label.Font = Enum.Font.GothamBlack
			Label.TextScaled = true
			Label.TextColor3 = Color3.fromRGB(
				math.random(150,255),
				math.random(150,255),
				255
			)

			local tween = TweenService:Create(
				Label,
				TweenInfo.new(math.random(15,25)/10),
				{
					Position = UDim2.new(x,0,1.1,0),
					TextTransparency = 1
				}
			)

			tween:Play()

			tween.Completed:Connect(function()
				Label:Destroy()
			end)
		end)

		task.wait(0.08)
	end
end

-- BUTTON 1

local RunService = game:GetService("RunService")

local AutoWalk = false

local function getNearestMonster()
	local character = plr.Character
	if not character then return nil end

	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if not rootPart then return nil end

	local nearest = nil
	local shortest = math.huge

	for _, obj in ipairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and obj ~= character then
			local hum = obj:FindFirstChildOfClass("Humanoid")
			local hrp = obj:FindFirstChild("HumanoidRootPart")

			if hum and hrp and hum.Health > 0 then
				local dist = (rootPart.Position - hrp.Position).Magnitude

				if dist < shortest then
					shortest = dist
					nearest = obj
				end
			end
		end
	end

	return nearest
end

local WalkBtn = Instance.new("TextButton")
WalkBtn.Parent = MainFrame
WalkBtn.Position = UDim2.new(0,15,0,40)
WalkBtn.Size = UDim2.new(1,-30,0,30)
WalkBtn.Text = "AUTO WALK : OFF"
WalkBtn.Font = Enum.Font.GothamBold
WalkBtn.TextColor3 = Color3.new(1,1,1)
WalkBtn.BackgroundColor3 = Color3.fromRGB(110,50,180)

Instance.new("UICorner", WalkBtn)

WalkBtn.MouseButton1Click:Connect(function()
	ClickSound:Play()

	AutoWalk = not AutoWalk

	if AutoWalk then
		WalkBtn.Text = "AUTO WALK : ON"
		Status.Text = "Status: Auto Walk Active"
		Notify("🎯 AUTO WALK ON")
	else
		WalkBtn.Text = "AUTO WALK : OFF"
		Status.Text = "Status: Auto Walk Disabled"
		Notify("❌ AUTO WALK OFF")
	end
end)

RunService.Heartbeat:Connect(function()
	if not AutoWalk then return end

	local character = plr.Character
	if not character then return end

	local humanoid = character:FindFirstChild("Humanoid")
	local rootPart = character:FindFirstChild("HumanoidRootPart")

	if not humanoid or not rootPart then return end

	local target = getNearestMonster()

	if target and target:FindFirstChild("HumanoidRootPart") then
		humanoid:MoveTo(target.HumanoidRootPart.Position)
	end
end)


-- BUTTON 2

-- BUTTON 2 ANTI AFK
local VirtualUser = game:GetService("VirtualUser")

local AntiAFK = false

local AfkBtn = Instance.new("TextButton")
AfkBtn.Parent = MainFrame
AfkBtn.Position = UDim2.new(0,15,0,78)
AfkBtn.Size = UDim2.new(1,-30,0,30)
AfkBtn.Text = "ANTI AFK : OFF"
AfkBtn.Font = Enum.Font.GothamBold
AfkBtn.TextColor3 = Color3.new(1,1,1)
AfkBtn.BackgroundColor3 = Color3.fromRGB(110,50,180)

Instance.new("UICorner", AfkBtn)

AfkBtn.MouseButton1Click:Connect(function()
	ClickSound:Play()

	AntiAFK = not AntiAFK

	if AntiAFK then
		AfkBtn.Text = "ANTI AFK : ON"
		Status.Text = "Status: Anti AFK Active"
		Notify("🛡️ ANTI AFK ON")
	else
		AfkBtn.Text = "ANTI AFK : OFF"
		Status.Text = "Status: Anti AFK Disabled"
		Notify("❌ ANTI AFK OFF")
	end
end)

plr.Idled:Connect(function()
	if AntiAFK then
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end
end)

-- HIDE BUTTON
-- POPUP BUTTON
local PopupBtn = Instance.new("TextButton")
PopupBtn.Parent = ScreenGui
PopupBtn.Size = UDim2.new(0,50,0,50)
PopupBtn.Position = UDim2.new(0.01,0,0.2,0)
PopupBtn.Text = "★"
PopupBtn.Font = Enum.Font.GothamBold
PopupBtn.TextScaled = true
PopupBtn.TextColor3 = Color3.new(1,1,1)
PopupBtn.BackgroundColor3 = Color3.fromRGB(140,80,220)
PopupBtn.Visible = false

Instance.new("UICorner", PopupBtn)

local Opened = true

local HideBtn = Instance.new("TextButton")
HideBtn.Parent = MainFrame
HideBtn.Size = UDim2.new(0,25,0,25)
HideBtn.Position = UDim2.new(1,-30,0,5)
HideBtn.Text = "X"
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.BackgroundColor3 = Color3.fromRGB(200,80,80)

Instance.new("UICorner", HideBtn)

HideBtn.MouseButton1Click:Connect(function()
	ClickSound:Play()

	Opened = false

	TweenService:Create(
		MainFrame,
		TweenInfo.new(0.3),
		{
			Size = UDim2.new(0,0,0,0)
		}
	):Play()

	task.wait(0.3)

	MainFrame.Visible = false
	PopupBtn.Visible = true

	Notify("📦 UI Disembunyikan")
end)

PopupBtn.MouseButton1Click:Connect(function()
	ClickSound:Play()

	MainFrame.Visible = true

	TweenService:Create(
		MainFrame,
		TweenInfo.new(0.3, Enum.EasingStyle.Back),
		{
			Size = UDim2.new(0,250,0,180)
		}
	):Play()

	PopupBtn.Visible = false
	Opened = true

	Notify("✨ UI Dibuka")
end)

Notify("✨ Welcome Benny Setyawan ✨")