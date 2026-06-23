if not game:IsLoaded() then
	game.Loaded:Wait()
end

local player = game.Players.LocalPlayer

------------------------------------------------
-- 📊 FPS COUNTER SIMPLE
------------------------------------------------
local gui = Instance.new("ScreenGui")
gui.Parent = player:WaitForChild("PlayerGui")

local label = Instance.new("TextLabel")
label.Size = UDim2.new(0, 180, 0, 40)
label.Position = UDim2.new(0, 10, 0, 10)
label.BackgroundColor3 = Color3.fromRGB(25,25,25)
label.TextColor3 = Color3.fromRGB(255,255,255)
label.Text = "FPS: ..."
label.Parent = gui

local RunService = game:GetService("RunService")
local frames = 0
local last = tick()

RunService.RenderStepped:Connect(function()
	frames += 1
	if tick() - last >= 1 then
		label.Text = "FPS: " .. frames
		frames = 0
		last = tick()
	end
end)

------------------------------------------------
-- 🔥 ULTRA LOW (LIGHT MASSIVE VERSION)
------------------------------------------------
local function UltraLow()

	for _,v in pairs(workspace:GetDescendants()) do

		-- ❌ partículas y efectos
		if v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = false
		end

		-- ❌ luces
		if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
			v.Enabled = false
		end

		-- ⚠️ SOLO optimiza partes (NO elimina players)
		if v:IsA("BasePart") then
			v.CastShadow = false
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		end

		-- ❌ solo “limpia” accesorios (NO borra players)
		if v:IsA("Accessory") then
			local handle = v:FindFirstChild("Handle")
			if handle then
				handle.CastShadow = false
				handle.Material = Enum.Material.Plastic
			end
		end
	end

	local lighting = game:GetService("Lighting")

	local sky = lighting:FindFirstChildOfClass("Sky")
	if sky then sky:Destroy() end

	lighting.GlobalShadows = false
	lighting.FogEnd = 1e9
	lighting.OutdoorAmbient = Color3.fromRGB(130,130,130)
	lighting.Brightness = 1

	print("🔥 ULTRA LOW LIGHT ACTIVATED")
end

------------------------------------------------
-- 📱 DOBLE TAP PARA ACTIVAR
------------------------------------------------
local lastTap = 0

label.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.Touch then

		local now = tick()

		if now - lastTap <= 0.3 then
			UltraLow()
		end

		lastTap = now
	end
end)
