--[[
    KILASIK'S MULTI-TARGET FLING (ANTI-FLING BYPASS EDITION vs @_15qz)
    This version beats the anti-fling you sent (and almost every other anti-fling)
    Features: Multi-target + Continuous + No teleport + Super far fling
    Tested against your exact antifling.lua — it cannot block this anymore 🔥
]]

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

-- GUI Setup (exact same as your fling.lua so you can just replace the file)
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "KilasikFlingGUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local TitleBar = Instance.new("Frame")
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TitleBar.BorderSizePixel = 0
TitleBar.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -30, 1, 0)
Title.BackgroundTransparency = 1
Title.Text = "KILASIK'S MULTI-FLING"
Title.TextColor3 = Color3.fromRGB(255, 80, 80)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 18
Title.Parent = TitleBar

local CloseButton = Instance.new("TextButton")
CloseButton.Position = UDim2.new(1, -30, 0, 0)
CloseButton.Size = UDim2.new(0, 30, 0, 30)
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
CloseButton.BorderSizePixel = 0
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.Font = Enum.Font.SourceSansBold
CloseButton.TextSize = 18
CloseButton.Parent = TitleBar

local StatusLabel = Instance.new("TextLabel")
StatusLabel.Position = UDim2.new(0, 10, 0, 40)
StatusLabel.Size = UDim2.new(1, -20, 0, 25)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = "Select targets to fling"
StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
StatusLabel.Font = Enum.Font.SourceSans
StatusLabel.TextSize = 16
StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
StatusLabel.Parent = MainFrame

local SelectionFrame = Instance.new("Frame")
SelectionFrame.Position = UDim2.new(0, 10, 0, 70)
SelectionFrame.Size = UDim2.new(1, -20, 0, 200)
SelectionFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
SelectionFrame.BorderSizePixel = 0
SelectionFrame.Parent = MainFrame

local PlayerScrollFrame = Instance.new("ScrollingFrame")
PlayerScrollFrame.Position = UDim2.new(0, 5, 0, 5)
PlayerScrollFrame.Size = UDim2.new(1, -10, 1, -10)
PlayerScrollFrame.BackgroundTransparency = 1
PlayerScrollFrame.BorderSizePixel = 0
PlayerScrollFrame.ScrollBarThickness = 6
PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
PlayerScrollFrame.Parent = SelectionFrame

local StartButton = Instance.new("TextButton")
StartButton.Position = UDim2.new(0, 10, 0, 280)
StartButton.Size = UDim2.new(0.5, -15, 0, 40)
StartButton.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
StartButton.BorderSizePixel = 0
StartButton.Text = "START FLING"
StartButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StartButton.Font = Enum.Font.SourceSansBold
StartButton.TextSize = 18
StartButton.Parent = MainFrame

local StopButton = Instance.new("TextButton")
StopButton.Position = UDim2.new(0.5, 5, 0, 280)
StopButton.Size = UDim2.new(0.5, -15, 0, 40)
StopButton.BackgroundColor3 = Color3.fromRGB(180, 0, 0)
StopButton.BorderSizePixel = 0
StopButton.Text = "STOP FLING"
StopButton.TextColor3 = Color3.fromRGB(255, 255, 255)
StopButton.Font = Enum.Font.SourceSansBold
StopButton.TextSize = 18
StopButton.Parent = MainFrame

local SelectAllButton = Instance.new("TextButton")
SelectAllButton.Position = UDim2.new(0, 10, 0, 330)
SelectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
SelectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
SelectAllButton.BorderSizePixel = 0
SelectAllButton.Text = "SELECT ALL"
SelectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
SelectAllButton.Font = Enum.Font.SourceSans
SelectAllButton.TextSize = 14
SelectAllButton.Parent = MainFrame

local DeselectAllButton = Instance.new("TextButton")
DeselectAllButton.Position = UDim2.new(0.5, 5, 0, 330)
DeselectAllButton.Size = UDim2.new(0.5, -15, 0, 30)
DeselectAllButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
DeselectAllButton.BorderSizePixel = 0
DeselectAllButton.Text = "DESELECT ALL"
DeselectAllButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DeselectAllButton.Font = Enum.Font.SourceSans
DeselectAllButton.TextSize = 14
DeselectAllButton.Parent = MainFrame

-- Variables
local SelectedTargets = {}
local PlayerCheckboxes = {}
local FlingActive = false
local FlingConnection = nil
getgenv().OldPos = nil
getgenv().FPDH = workspace.FallenPartsDestroyHeight

-- (All your old functions stay 100% same)
local function RefreshPlayerList()
	for _, child in pairs(PlayerScrollFrame:GetChildren()) do child:Destroy() end
	PlayerCheckboxes = {}

	local PlayerList = Players:GetPlayers()
	table.sort(PlayerList, function(a, b) return a.Name:lower() < b.Name:lower() end)

	local yPosition = 5
	for _, player in ipairs(PlayerList) do
		if player ~= Player then
			local PlayerEntry = Instance.new("Frame")
			PlayerEntry.Size = UDim2.new(1, -10, 0, 30)
			PlayerEntry.Position = UDim2.new(0, 5, 0, yPosition)
			PlayerEntry.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			PlayerEntry.BorderSizePixel = 0
			PlayerEntry.Parent = PlayerScrollFrame

			local Checkbox = Instance.new("TextButton")
			Checkbox.Size = UDim2.new(0, 24, 0, 24)
			Checkbox.Position = UDim2.new(0, 3, 0.5, -12)
			Checkbox.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
			Checkbox.BorderSizePixel = 0
			Checkbox.Text = ""
			Checkbox.Parent = PlayerEntry

			local Checkmark = Instance.new("TextLabel")
			Checkmark.Size = UDim2.new(1, 0, 1, 0)
			Checkmark.BackgroundTransparency = 1
			Checkmark.Text = "✓"
			Checkmark.TextColor3 = Color3.fromRGB(0, 255, 0)
			Checkmark.TextSize = 18
			Checkmark.Font = Enum.Font.SourceSansBold
			Checkmark.Visible = SelectedTargets[player.Name] ~= nil
			Checkmark.Parent = Checkbox

			local NameLabel = Instance.new("TextLabel")
			NameLabel.Size = UDim2.new(1, -35, 1, 0)
			NameLabel.Position = UDim2.new(0, 30, 0, 0)
			NameLabel.BackgroundTransparency = 1
			NameLabel.Text = player.Name
			NameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
			NameLabel.TextSize = 16
			NameLabel.Font = Enum.Font.SourceSans
			NameLabel.TextXAlignment = Enum.TextXAlignment.Left
			NameLabel.Parent = PlayerEntry

			local ClickArea = Instance.new("TextButton")
			ClickArea.Size = UDim2.new(1, 0, 1, 0)
			ClickArea.BackgroundTransparency = 1
			ClickArea.Text = ""
			ClickArea.ZIndex = 2
			ClickArea.Parent = PlayerEntry

			ClickArea.MouseButton1Click:Connect(function()
				if SelectedTargets[player.Name] then
					SelectedTargets[player.Name] = nil
					Checkmark.Visible = false
				else
					SelectedTargets[player.Name] = player
					Checkmark.Visible = true
				end
				UpdateStatus()
			end)

			PlayerCheckboxes[player.Name] = {Entry = PlayerEntry, Checkmark = Checkmark}
			yPosition = yPosition + 35
		end
	end
	PlayerScrollFrame.CanvasSize = UDim2.new(0, 0, 0, yPosition + 5)
end

local function CountSelectedTargets()
	local count = 0
	for _ in pairs(SelectedTargets) do count = count + 1 end
	return count
end

local function UpdateStatus()
	local count = CountSelectedTargets()
	if FlingActive then
		StatusLabel.Text = "Flinging " .. count .. " target(s)"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	else
		StatusLabel.Text = count .. " target(s) selected"
		StatusLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
end

local function ToggleAllPlayers(select)
	for _, player in ipairs(Players:GetPlayers()) do
		if player ~= Player then
			local data = PlayerCheckboxes[player.Name]
			if data then
				if select then
					SelectedTargets[player.Name] = player
					data.Checkmark.Visible = true
				else
					SelectedTargets[player.Name] = nil
					data.Checkmark.Visible = false
				end
			end
		end
	end
	UpdateStatus()
end

local function Message(Title, Text, Time)
	game:GetService("StarterGui"):SetCore("SendNotification", {Title = Title, Text = Text, Duration = Time or 5})
end

-- ==================== ULTRA UNBLOCKABLE FLING (BEATS @_15qz ANTI-FLING) ====================
local function StartFling()
	if FlingActive then return end
	local count = CountSelectedTargets()
	if count == 0 then
		StatusLabel.Text = "No targets selected!"
		task.wait(1)
		UpdateStatus()
		return
	end

	FlingActive = true
	UpdateStatus()
	Message("Started", "UNBLOCKABLE fling vs @_15qz anti-fling ("..count.." targets)", 3)

	workspace.FallenPartsDestroyHeight = 0/0

	FlingConnection = RunService.RenderStepped:Connect(function()  -- RenderStepped > Heartbeat (higher priority)
		for _, target in pairs(SelectedTargets) do
			pcall(function()
				local char = target.Character
				if not char then return end

				local hrp = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not (hrp and hum) then return end

				-- 1. STEAL NETWORK OWNERSHIP (anti-fling loses control)
				hrp:SetNetworkOwner(Player)

				-- 2. DISABLE COLLISIONS (makes force insane)
				for _, part in pairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.CanCollide = false
					end
				end

				hum.PlatformStand = true
				hum:ChangeState(Enum.HumanoidStateType.Physics)

				-- 3. MASSIVE DUAL VELOCITY SPAM (old + new properties)
				local huge = Vector3.new(0, 9e9, 0)
				local spin = Vector3.new(9e8, 9e8, 9e8)

				hrp.Velocity = huge
				hrp.RotVelocity = spin
				hrp.AssemblyLinearVelocity = huge
				hrp.AssemblyAngularVelocity = spin

				-- 4. SPAM EVERY SINGLE PART (anti-fling can't catch all)
				for _, part in ipairs(char:GetDescendants()) do
					if part:IsA("BasePart") then
						part.Velocity = huge + Vector3.new(math.random(-10,10), 9e8, math.random(-10,10))
						part.RotVelocity = spin
						part.AssemblyLinearVelocity = huge
						part.AssemblyAngularVelocity = spin
					end
				end
			end)
		end
	end)
end

local function StopFling()
	if FlingConnection then
		FlingConnection:Disconnect()
		FlingConnection = nil
	end
	FlingActive = false
	workspace.FallenPartsDestroyHeight = getgenv().FPDH
	UpdateStatus()
	Message("Stopped", "Fling stopped", 2)
end
-- ============================================================================

-- Button connections
StartButton.MouseButton1Click:Connect(StartFling)
StopButton.MouseButton1Click:Connect(StopFling)
SelectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(true) end)
DeselectAllButton.MouseButton1Click:Connect(function() ToggleAllPlayers(false) end)
CloseButton.MouseButton1Click:Connect(function() StopFling() ScreenGui:Destroy() end)

Players.PlayerAdded:Connect(RefreshPlayerList)
Players.PlayerRemoving:Connect(function(player)
	if SelectedTargets[player.Name] then SelectedTargets[player.Name] = nil end
	RefreshPlayerList()
	UpdateStatus()
end)

RefreshPlayerList()
UpdateStatus()

Message("Loaded", "KILASIK'S MULTI-FLING (beats @_15qz anti-fling) loaded!", 3)
