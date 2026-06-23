-- 😈 LEGNA MODE DIABLO

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")

local plr = Players.LocalPlayer

------------------------------------------------
-- 📊 CONTADOR FPS
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "FPS_COUNTER"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,170,0,30)
frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBold
text.TextSize = 14
text.RichText = true
text.TextXAlignment = Enum.TextXAlignment.Left

------------------------------------------------
-- 🎨 FPS + PING
------------------------------------------------
local hue = 0

RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.4) % 1
	local fps = math.floor(1/dt)

	local ping = 0
	pcall(function()
		ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	end)

	local rgb = Color3.fromHSV(hue,1,1)
	local r,g,b = math.floor(rgb.R*255), math.floor(rgb.G*255), math.floor(rgb.B*255)

	local pingColor = "🟢"
	if ping > 150 then pingColor = "🔴"
	elseif ping > 80 then pingColor = "🟠" end

	text.Text = string.format(
		"<font color='rgb(%d,%d,%d)'>FPS</font> <font color='rgb(255,255,255)'>%d</font>   %s %d MS",
		r,g,b,fps,pingColor,ping
	)
end)

------------------------------------------------
-- 🖱️ DRAG
------------------------------------------------
local dragging, dragInput, startPos, startFramePos = false

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		startPos = input.Position
		startFramePos = frame.Position
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UIS.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		local delta = input.Position - startPos
		frame.Position = UDim2.new(
			startFramePos.X.Scale,
			startFramePos.X.Offset + delta.X,
			startFramePos.Y.Scale,
			startFramePos.Y.Offset + delta.Y
		)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

------------------------------------------------
-- 😈 ULTRA LOW DIABLO
------------------------------------------------
local activo = false

local function UltraLow()
	if activo then return end
	activo = true

	-- cielo gris plano
	Lighting.Brightness = 0.5
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Ambient = Color3.fromRGB(120,120,120)
	Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

	-- optimizar mundo
	for _,v in ipairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.CastShadow = false
		end

		if v:IsA("MeshPart") then
			v.TextureID = ""
		end

		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end

	-- jugadores tipo maniquí
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character then
			for _,v in ipairs(p.Character:GetDescendants()) do
				if v:IsA("Accessory") then
					v:Destroy()
				end
				if v:IsA("Shirt") or v:IsA("Pants") then
					v:Destroy()
				end
			end
		end
	end

	print("😈 MODO DIABLO ACTIVADO")
end

------------------------------------------------
-- 🖱️ DOBLE CLICK CONTADOR
------------------------------------------------
local lastClick = 0

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local now = tick()
		if now - lastClick <= 0.3 then
			UltraLow()
		end
		lastClick = now
	end
end)

print("😈 LEGNA MODO DIABLO READY")
