-- 😈 LEGNA FPS DELTA FIX FULL

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local plr = Players.LocalPlayer

------------------------------------------------
-- 🧍 FIX PERSONAJE (NO CAERSE)
------------------------------------------------
plr.CharacterAdded:Connect(function(char)
	task.wait(1)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
		hum.PlatformStand = false
		hum:ChangeState(Enum.HumanoidStateType.Running)
	end
end)

------------------------------------------------
-- 📊 GUI CONTADOR
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "LEGNA_FPS"
gui.ResetOnSpawn = false
gui.Parent = plr:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,170,0,30)
frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(15,15,15)
frame.BorderSizePixel = 0

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBold
text.TextSize = 14
text.RichText = true
text.TextXAlignment = Enum.TextXAlignment.Left

------------------------------------------------
-- 🎨 FPS REAL + RGB + PING
------------------------------------------------
local hue = 0

RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.5) % 1

	local fps = math.floor(1/dt)

	local ping = 0
	pcall(function()
		ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
	end)

	local rgb = Color3.fromHSV(hue,1,1)
	local r = math.floor(rgb.R*255)
	local g = math.floor(rgb.G*255)
	local b = math.floor(rgb.B*255)

	local pingColor = "🟢"
	if ping > 150 then
		pingColor = "🔴"
	elseif ping > 80 then
		pingColor = "🟠"
	end

	text.Text = string.format(
		"<font color='rgb(%d,%d,%d)'>FPS</font> <font color='rgb(255,255,255)'>%d</font>   %s %d MS",
		r,g,b,
		fps,
		pingColor,
		ping
	)
end)

------------------------------------------------
-- 🖱️ MOVER (DRAG)
------------------------------------------------
local dragging = false
local dragInput, startPos, startFramePos

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
-- 🔥 ULTRA LOW (SEGURO)
------------------------------------------------
local activo = false

local function UltraLow()
	if activo then return end
	activo = true

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Brightness = 0.5

	for _,v in ipairs(workspace:GetDescendants()) do
		if plr.Character and v:IsDescendantOf(plr.Character) then continue end

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

	print("😈 ULTRA LOW ACTIVADO")
end

------------------------------------------------
-- 🖱️ DOBLE CLICK
------------------------------------------------
local lastClick = 0

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local now = tick()
		if now - lastClick < 0.3 then
			UltraLow()
		end
		lastClick = now
	end
end)

print("😈 LEGNA DELTA READY")
