local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

local TARGET_NAME = "pet0_1"

-- Hapus UI lama
if PlayerGui:FindFirstChild("MonsterWalkerUI") then
	PlayerGui.MonsterWalkerUI:Destroy()
end

-- ScreenGui
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterWalkerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

-- Tombol Popup
local PopupBtn = Instance.new("TextButton")
PopupBtn.Parent = ScreenGui
PopupBtn.Size = UDim2.new(0,50,0,50)
PopupBtn.Position = UDim2.new(0,10,0.5,-25)
PopupBtn.Text = "📱"
PopupBtn.TextScaled = true
PopupBtn.BackgroundColor3 = Color3.fromRGB(0,170,255)
PopupBtn.TextColor3 = Color3.new(1,1,1)

local PopupCorner = Instance.new("UICorner")
PopupCorner.CornerRadius = UDim.new(1,0)
PopupCorner.Parent = PopupBtn

-- Frame Utama
local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,220,0,140) -- UPDATED
Frame.Position = UDim2.new(0.5,-110,0.5,-60)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,35)

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0,12)
FrameCorner.Parent = Frame

local Stroke = Instance.new("UIStroke")
Stroke.Parent = Frame
Stroke.Color = Color3.fromRGB(0,170,255)
Stroke.Thickness = 2

-- Judul
local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "Monster Walker"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- CREDIT (ADDED)
local Credit = Instance.new("TextLabel")
Credit.Parent = Frame
Credit.Size = UDim2.new(1,0,0,15)
Credit.Position = UDim2.new(0,0,0,22)
Credit.BackgroundTransparency = 1
Credit.Text = "⚡ Script By Benny Setyawan ⚡"
Credit.TextColor3 = Color3.fromRGB(0,255,255)
Credit.Font = Enum.Font.GothamBold
Credit.TextSize = 10

-- Input Nama Monster
local TextBox = Instance.new("TextBox")
TextBox.Parent = Frame
TextBox.Size = UDim2.new(1,-20,0,35)
TextBox.Position = UDim2.new(0,10,0,55) -- UPDATED
TextBox.Text = TARGET_NAME
TextBox.PlaceholderText = "Contoh: pet0_50"
TextBox.BackgroundColor3 = Color3.fromRGB(35,35,50)
TextBox.TextColor3 = Color3.new(1,1,1)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 14

local TextCorner = Instance.new("UICorner")
TextCorner.CornerRadius = UDim.new(0,8)
TextCorner.Parent = TextBox

-- Tombol Set Target
local Button = Instance.new("TextButton")
Button.Parent = Frame
Button.Size = UDim2.new(1,-20,0,30)
Button.Position = UDim2.new(0,10,0,95) -- UPDATED
Button.Text = "Set Target"
Button.BackgroundColor3 = Color3.fromRGB(0,170,255)
Button.TextColor3 = Color3.new(1,1,1)
Button.Font = Enum.Font.GothamBold
Button.TextSize = 14

local BtnCorner = Instance.new("UICorner")
BtnCorner.CornerRadius = UDim.new(0,8)
BtnCorner.Parent = Button

Button.MouseButton1Click:Connect(function()
	TARGET_NAME = TextBox.Text
	Button.Text = "Target: "..TARGET_NAME
	task.wait(1)
	Button.Text = "Set Target"
end)

-- Show / Hide UI
PopupBtn.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible
end)

-- Drag UI
local dragging = false
local dragInput
local dragStart
local startPos

Frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = Frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

Frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement
	or input.UserInputType == Enum.UserInputType.Touch then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		Frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- Auto Walk

local MAX_DISTANCE = 50 -- ubah sesuai kebutuhan

task.spawn(function()
	while task.wait(0.2) do
		local char = plr.Character
		local hum = char and char:FindFirstChild("Humanoid")
		local root = char and char:FindFirstChild("HumanoidRootPart")

		local target = workspace:FindFirstChild(TARGET_NAME, true)

		if hum and root and target then
			local hrp = target:FindFirstChild("HumanoidRootPart")

			if hrp then
				local distance = (root.Position - hrp.Position).Magnitude

				if distance <= MAX_DISTANCE then
					hum:MoveTo(hrp.Position)
				end
			elseif target:IsA("BasePart") then
				local distance = (root.Position - target.Position).Magnitude

				if distance <= MAX_DISTANCE then
					hum:MoveTo(target.Position)
				end
			end
		end
	end
end)
