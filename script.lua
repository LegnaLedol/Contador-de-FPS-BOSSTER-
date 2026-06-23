-- 😈 LEGNA FPS+ RAW VERSION (AUTO EXEC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local plr = Players.LocalPlayer

------------------------------------------------
-- 📊 CREAR GUI
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Name = "LEGNA_FPS"
gui.ResetOnSpawn = false
pcall(function()
	gui.Parent = plr:WaitForChild("PlayerGui")
end)

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,170,0,32)
frame.Position = UDim2.new(0.02,0,0.2,0)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.BorderSizePixel = 0

local text = Instance.new("TextLabel", frame)
text.Size = UDim2.new(1,0,1,0)
text.BackgroundTransparency = 1
text.Font = Enum.Font.GothamBold
text.TextSize = 14
text.RichText = true
text.TextColor3 = Color3.new(1,1,1)
text.TextXAlignment = Enum.TextXAlignment.Left

------------------------------------------------
-- 🎨 FPS + RGB + PING
------------------------------------------------
local hue = 0

RunService.RenderStepped:Connect(function(dt)
	hue = (hue + dt * 0.4) % 1

	local fps = math.floor(1/dt)
	local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

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
		"<font color='rgb(%d,%d,%d)'>FPS</font> %d   %s %d MS",
		r,g,b,
		fps,
		pingColor,
		ping
	)
end)

------------------------------------------------
-- 🖱️ DRAG REAL
------------------------------------------------
local dragging = false
local dragInput, startPos, startFramePos

frame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		startPos = input.Position
		startFramePos = frame.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

frame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
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

------------------------------------------------
-- 🔥 ULTRA LOW 9/10
------------------------------------------------
local activo = false

local function UltraLow()
	if activo then return end
	activo = true

	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e9
	Lighting.Brightness = 0.5

	for _,v in ipairs(workspace:GetDescendants()) do

		if plr.Character and v:IsDescendantOf(plr.Character) then
			continue
		end

		if v:IsA("Model") then
			local name = string.lower(v.Name)
			if name:find("tree") or name:find("grass") or name:find("bush") or name:find("rock") then
				v:Destroy()
			end
		end

		if v:IsA("MeshPart") then
			v.TextureID = ""
			v.Material = Enum.Material.Plastic
		end

		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.CastShadow = false
			v.Reflectance = 0
		end

		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end

		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			v.Enabled = false
		end

		if v:IsA("Decal") or v:IsA("Texture") then
			v:Destroy()
		end
	end

	-- jugadores optimizados
	for _,p in ipairs(Players:GetPlayers()) do
		if p.Character then
			for _,v in ipairs(p.Character:GetDescendants()) do
				if v:IsA("Accessory") then
					v:Destroy()
				end
				if v:IsA("MeshPart") then
					v.TextureID = ""
				end
			end
		end
	end

	print("😈 ULTRA LOW 9/10 ACTIVADO")
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

print("😈 LEGNA FPS+ RAW LOADED")
