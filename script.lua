-- 😈 LEGNA PREMIUM HUD ULTRA (FPS + BOOSTER + ALERTA)

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer

-- 🔥 BOOST BASE
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 0

pcall(function()
	settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
end)

-- =========================
-- ⚡ ALERTA PRO
-- =========================
local function showAlert(msg, color)
	local gui = Instance.new("ScreenGui")
	gui.IgnoreGuiInset = true
	gui.ResetOnSpawn = false
	gui.Parent = player:WaitForChild("PlayerGui")

	local frame = Instance.new("Frame", gui)
	frame.Size = UDim2.new(0, 260, 0, 42)
	frame.Position = UDim2.new(1, 300, 0, 20)
	frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
	frame.BackgroundTransparency = 0.15
	frame.BorderSizePixel = 0

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

	local stroke = Instance.new("UIStroke", frame)
	stroke.Thickness = 2
	stroke.Color = color

	local txt = Instance.new("TextLabel", frame)
	txt.Size = UDim2.new(1,-12,1,0)
	txt.Position = UDim2.new(0,10,0,0)
	txt.BackgroundTransparency = 1
	txt.Font = Enum.Font.GothamBold
	txt.TextScaled = true
	txt.TextXAlignment = Enum.TextXAlignment.Left
	txt.TextColor3 = color
	txt.Text = msg

	local enter = TweenService:Create(frame, TweenInfo.new(0.4), {
		Position = UDim2.new(1, -270, 0, 20)
	})

	local exit = TweenService:Create(frame, TweenInfo.new(0.4), {
		Position = UDim2.new(1, 300, 0, 20)
	})

	enter:Play()

	task.delay(5, function()
		exit:Play()
		exit.Completed:Wait()
		gui:Destroy()
	end)
end

-- =========================
-- 🚀 BOOST ULTRA
-- =========================
local function BoostUltra()

	showAlert("⚡ BOOSTER ACTIVADO", Color3.fromRGB(0,255,120))

	for _, v in ipairs(game:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Fire") or v:IsA("Smoke") then
			v.Enabled = false
		end
	end

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Brightness = 1
end

-- =========================
-- 🎯 GUI ORIGINAL (MISMO DISEÑO)
-- =========================

local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "LEGNA_PREMIUM"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 125, 0, 20)
frame.Position = UDim2.new(0, 8, 0, 70)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke", frame)
stroke.Color = Color3.fromRGB(40,40,40)
stroke.Thickness = 1
stroke.Transparency = 0.6

-- TEXTO (IDÉNTICO)
local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(0.82,0,1,0)
text.Position = UDim2.new(0,6,0,0)
text.BackgroundTransparency = 1
text.TextScaled = true
text.Font = Enum.Font.GothamSemibold
text.TextXAlignment = Enum.TextXAlignment.Left

-- BOTÓN
local toggle = Instance.new("TextButton", frame)
toggle.Size = UDim2.new(0.18,0,1,0)
toggle.Position = UDim2.new(0.82,0,0,0)
toggle.BackgroundTransparency = 1
toggle.Text = ""

local enabled = true

toggle.MouseButton1Click:Connect(function()
	enabled = not enabled
	text.Visible = enabled

	if enabled then
		BoostUltra()
	end
end)

-- DRAG (igual)
local dragging, dragInput, dragStart, startPos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
		dragInput = input
	end
end)

frame.InputEnded:Connect(function(input)
	if input == dragInput then
		dragging = false
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - dragStart
		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

-- =========================
-- 📊 FPS (IDÉNTICO AL TUYO)
-- =========================

local hue = 0
local fps = 0
local frames = 0
local lastTime = tick()

RunService.RenderStepped:Connect(function()
	frames += 1

	if tick() - lastTime >= 1 then
		fps = frames
		frames = 0
		lastTime = tick()
	end

	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

	local msColor = Color3.fromRGB(0,255,120)
	if ping > 180 then
		msColor = Color3.fromRGB(255,60,60)
	elseif ping > 100 then
		msColor = Color3.fromRGB(255,170,60)
	end

	hue = (hue + 0.008) % 1
	local rgb = Color3.fromHSV(hue,1,1)

	text.RichText = true
	text.Text =
		"<font color='rgb("..
		math.floor(rgb.R*255)..","..
		math.floor(rgb.G*255)..","..
		math.floor(rgb.B*255)..")'>L</font> "
		.."<font color='rgb(255,255,255)'>"..fps.." FPS</font> | "
		.."<font color='rgb("..
		math.floor(msColor.R*255)..","..
		math.floor(msColor.G*255)..","..
		math.floor(msColor.B*255)..")'>"
		..ping.." MS</font>"
end)

print("😈 LEGNA ULTRA COMPLETO")
