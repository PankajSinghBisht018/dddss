-- JJ Sploit ERP Sex Positions Script (2026 working)
-- Execute in JJSploit

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local lp = Players.LocalPlayer

local positions = {
    ["Missionary"] = {
        attacker = "rbxassetid://PASTE_YOUR_MISSIONARY_ATTACKER_ID_HERE",
        receiver = "rbxassetid://PASTE_YOUR_MISSIONARY_RECEIVER_ID_HERE",
        offset = CFrame.new(0, 0.2, 1.2) * CFrame.Angles(0, 0, 0)
    },
    ["Doggy"] = {
        attacker = "rbxassetid://PASTE_YOUR_DOGGY_ATTACKER_ID_HERE",
        receiver = "rbxassetid://PASTE_YOUR_DOGGY_RECEIVER_ID_HERE",
        offset = CFrame.new(0, -0.8, -1.8) * CFrame.Angles(math.rad(90), 0, 0)
    },
    ["Cowgirl"] = {
        attacker = "rbxassetid://PASTE_YOUR_COWGIRL_ATTACKER_ID_HERE",
        receiver = "rbxassetid://PASTE_YOUR_COWGIRL_RECEIVER_ID_HERE",
        offset = CFrame.new(0, 0.5, 0) * CFrame.Angles(0, 0, 0)
    },
    ["Standing"] = {
        attacker = "rbxassetid://PASTE_YOUR_STANDING_ATTACKER_ID_HERE",
        receiver = "rbxassetid://PASTE_YOUR_STANDING_RECEIVER_ID_HERE",
        offset = CFrame.new(0, 0, -1.5) * CFrame.Angles(0, math.rad(180), 0)
    }
}

local currentTracks = {attacker = nil, receiver = nil}
local lockConnection = nil
local targetPlayer = nil

-- Simple GUI
local screen = Instance.new("ScreenGui")
screen.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 400)
frame.Position = UDim2.new(0.5, -150, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Parent = screen

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
title.Text = "JJ Sploit SEX POSITIONS"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.Parent = frame

local targetBox = Instance.new("TextBox")
targetBox.Size = UDim2.new(1, -20, 0, 40)
targetBox.Position = UDim2.new(0, 10, 0, 60)
targetBox.PlaceholderText = "Target Player Name"
targetBox.Text = ""
targetBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
targetBox.TextColor3 = Color3.new(1,1,1)
targetBox.Parent = frame

-- Position buttons
local y = 110
for posName, _ in pairs(positions) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = posName
    btn.TextColor3 = Color3.new(1,1,1)
    btn.TextScaled = true
    btn.Parent = frame
    
    btn.MouseButton1Click:Connect(function()
        targetPlayer = Players:FindFirstChild(targetBox.Text)
        if not targetPlayer or not targetPlayer.Character then
            print("❌ Target not found!")
            return
        end
        startPosition(posName)
    end)
    y = y + 50
end

local stopBtn = Instance.new("TextButton")
stopBtn.Size = UDim2.new(1, -20, 0, 50)
stopBtn.Position = UDim2.new(0, 10, 1, -60)
stopBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
stopBtn.Text = "STOP ALL"
stopBtn.TextColor3 = Color3.new(1,1,1)
stopBtn.TextScaled = true
stopBtn.Parent = frame

function stopAll()
    if currentTracks.attacker then currentTracks.attacker:Stop() end
    if currentTracks.receiver then currentTracks.receiver:Stop() end
    if lockConnection then lockConnection:Disconnect() end
    currentTracks = {attacker = nil, receiver = nil}
    lockConnection = nil
    print("✅ Stopped")
end

stopBtn.MouseButton1Click:Connect(stopAll)

function startPosition(posName)
    stopAll()
    
    local data = positions[posName]
    local targetChar = targetPlayer.Character
    local myChar = lp.Character
    
    if not targetChar or not myChar then return end
    
    local myHum = myChar:FindFirstChild("Humanoid")
    local tHum = targetChar:FindFirstChild("Humanoid")
    
    -- Attacker anim (you)
    local aAnim = Instance.new("Animation")
    aAnim.AnimationId = data.attacker
    currentTracks.attacker = myHum:LoadAnimation(aAnim)
    currentTracks.attacker:Play()
    
    -- Receiver anim (target)
    local rAnim = Instance.new("Animation")
    rAnim.AnimationId = data.receiver
    currentTracks.receiver = tHum:LoadAnimation(rAnim)
    currentTracks.receiver:Play()
    
    -- Auto position lock
    lockConnection = RunService.RenderStepped:Connect(function()
        if myChar and targetChar and myChar:FindFirstChild("HumanoidRootPart") and targetChar:FindFirstChild("HumanoidRootPart") then
            targetChar.HumanoidRootPart.CFrame = myChar.HumanoidRootPart.CFrame * data.offset
        end
    end)
    
    print("✅ " .. posName .. " started on " .. targetPlayer.Name)
end

print("🎉 JJ Sploit Sex Script Loaded! GUI opened.")
