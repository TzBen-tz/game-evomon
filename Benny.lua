local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local plr = Players.LocalPlayer
local PlayerGui = plr:WaitForChild("PlayerGui")

if PlayerGui:FindFirstChild("MonsterWalkerUI") then
	PlayerGui.MonsterWalkerUI:Destroy()
end

local AutoFarm = false

-- GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MonsterWalkerUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Frame = Instance.new("Frame")
Frame.Parent = ScreenGui
Frame.Size = UDim2.new(0,220,0,120)
Frame.Position = UDim2.new(0.5,-110,0.5,-60)
Frame.BackgroundColor3 = Color3.fromRGB(25,25,35)
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0,12)

local Title = Instance.new("TextLabel")
Title.Parent = Frame
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundTransparency = 1
Title.Text = "EVOMON AUTO FARM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local Toggle = Instance.new("TextButton")
Toggle.Parent = Frame
Toggle.Size = UDim2.new(1,-20,0,40)
Toggle.Position = UDim2.new(0,10,0,45)
Toggle.Text = "AUTO FARM : OFF"
Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
Toggle.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", Toggle).CornerRadius = UDim.new(0,8)

local Status = Instance.new("TextLabel")
Status.Parent = Frame
Status.Size = UDim2.new(1,0,0,20)
Status.Position = UDim2.new(0,0,1,-20)
Status.BackgroundTransparency = 1
Status.Text = "Status: Idle"
Status.TextColor3 = Color3.fromRGB(200,200,200)
Status.Font = Enum.Font.Gotham
Status.TextSize = 10

Toggle.MouseButton1Click:Connect(function()
	AutoFarm = not AutoFarm

	if AutoFarm then
		Toggle.Text = "AUTO FARM : ON"
		Toggle.BackgroundColor3 = Color3.fromRGB(0,170,0)
	else
		Toggle.Text = "AUTO FARM : OFF"
		Toggle.BackgroundColor3 = Color3.fromRGB(60,60,60)
		Status.Text = "Status: Idle"
	end
end)

local function getNearestPet()
	local char = plr.Character
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hrp then return nil end

	local closest
	local dist = math.huge

	for _, obj in pairs(workspace:GetDescendants()) do
		if obj:IsA("Model") and string.find(obj.Name:lower(), "pet0_") then
			local root = obj:FindFirstChild("HumanoidRootPart") or obj.PrimaryPart
			local hum = obj:FindFirstChildOfClass("Humanoid")

			if root and hum and hum.Health > 0 then
				local d = (root.Position - hrp.Position).Magnitude
				if d < dist then
					dist = d
					closest = root
				end
			end
		end
	end

	return closest
end

task.spawn(function()
	while task.wait(0.25) do
		if not AutoFarm then continue end

		local char = plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")

		if hum then
			local target = getNearestPet()

			if target then
				Status.Text = "Status: Farming Pet"
				hum:MoveTo(target.Position)
			else
				Status.Text = "Status: Tidak ada pet"
			end
		end
	end
end)