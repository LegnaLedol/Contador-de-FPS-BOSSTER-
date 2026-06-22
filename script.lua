-- 😈 LEGNA FPS HUD PRO MOVIBLE

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

------------------------------------------------
-- ⚡ ESTADO
------------------------------------------------
local ultraLow = false
local lastClick = 0

------------------------------------------------
-- 🌍 ULTRA LOW
------------------------------------------------
local function UltraLowON()

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1

	for _,v in pairs(game:GetDescendants()) do
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		elseif v:IsA("PostEffect") then
			v.Enabled = false
		end
	end
end

------------------------------------------------
-- 🎯 HUD
------------------------------------------------
local gui = Instance.new("ScreenGui", game.CoreGui)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 130, 0, 22)
frame.Position = UDim2.new(0, 10, 0, 70)
frame.BackgroundColor3 = Color3.fromRGB(10,10,10)
frame.BackgroundTransparency = 0.25
frame.BorderSizePixel = 0
frame.Active = true
frame.Selectable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)

local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 1
stroke.Color = Color3.fromRGB(60,60,60)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,-6,1,0)
text.Position = UDim2.new(0,6,0,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamSemibold
text.TextScaled = true
text.TextXAlignment = Enum.TextXAlignment.Left

------------------------------------------------
-- 📊 FPS
------------------------------------------------
local fps = 0
local frames = 0
local last = tick()
local hue = 0

RunService.RenderStepped:Connect(function()

	frames += 1

	if tick() - last >= 1 then
		fps = frames
		frames = 0
		last = tick()
	end

	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

	local pingColor = Color3.fromRGB(0,255,120)
	if ping > 180 then
		pingColor = Color3.fromRGB(255,60,60)
	elseif ping > 100 then
		pingColor = Color3.fromRGB(255,170,60)
	end

	hue = (hue + 0.01) % 1
	local rgb = Color3.fromHSV(hue,1,1)

	text.RichText = true
	text.Text =
		"<font color='rgb("..
		math.floor(rgb.R*255)..","..
		math.floor(rgb.G*255)..","..
		math.floor(rgb.B*255)..")'>L</font> "..
		"<font color='rgb(255,255,255)'>"..fps.." FPS</font> | "..
		"<font color='rgb("..
		math.floor(pingColor.R*255)..","..
		math.floor(pingColor.G*255)..","..
		math.floor(pingColor.B*255)..")'>"..
		ping.." MS</font>"
end)

------------------------------------------------
-- 🖱️ DRAG LIBRE + SNAP
------------------------------------------------
local dragging = false
local dragStart
local startPos

local snapEnabled = true
local snapDistance = 30

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		local now = tick()

		-- 🧠 doble click = ULTRA LOW
		if now - lastClick < 0.3 then
			ultraLow = not ultraLow
			if ultraLow then
				UltraLowON()
				print("😈 ULTRA LOW ACTIVADO")
			end
		end

		lastClick = now

		-- 🖱️ drag start
		dragging = true
		dragStart = input.Position
		startPos = frame.Position
	end
end)

frame.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
	or input.UserInputType == Enum.UserInputType.Touch then

		dragging = false

		-- 📌 SNAP A BORDES (opcional pro)
		if snapEnabled then
			local pos = frame.Position

			local x = pos.X.Offset
			local y = pos.Y.Offset

			local screen = workspace.CurrentCamera.ViewportSize

			-- snap izquierda / derecha
			if x < snapDistance then
				x = 10
			elseif x > screen.X - 150 then
				x = screen.X - 150
			end

			-- snap arriba / abajo
			if y < snapDistance then
				y = 10
			elseif y > screen.Y - 50 then
				y = screen.Y - 50
			end

			frame.Position = UDim2.new(0, x, 0, y)
		end
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then

		local delta = input.Position - dragStart

		frame.Position = UDim2.new(
			startPos.X.Scale,
			startPos.X.Offset + delta.X,
			startPos.Y.Scale,
			startPos.Y.Offset + delta.Y
		)
	end
end)

print("😈 HUD PRO LISTO (drag + snap + ultra low)")
