pcall(function()

	-- 🔥 CARGAR CONTADOR (PROTEGIDO)
	local success, err = pcall(function()
		loadstring(game:HttpGet("https://raw.githubusercontent.com/LegnaLedol/Contador-de-FPS-BOSSTER-/refs/heads/main/script.lua"))()
	end)

	if not success then
		warn("❌ Error cargando RAW:", err)
	end

	-- ⏳ ESPERAR A QUE TODO CARGUE BIEN
	repeat task.wait() until game:IsLoaded()
	task.wait(3)

	local player = game.Players.LocalPlayer
	local gui = player:WaitForChild("PlayerGui")

	------------------------------------------------
	-- 🔎 DETECTAR CONTADOR (MEJORADO)
	------------------------------------------------
	local contador = nil

	for _,v in pairs(gui:GetDescendants()) do
		if v:IsA("TextLabel") or v:IsA("TextButton") then
			if v.Text and string.find(string.lower(v.Text), "fps") then
				contador = v
				break
			end
		end
	end

	if not contador then
		warn("❌ No se encontró el contador (tu RAW usa otro tipo)")
		return
	end

	print("✅ Contador detectado:", contador:GetFullName())

	------------------------------------------------
	-- 🔥 ULTRA LOW
	------------------------------------------------
	local function UltraLow()
		for _,v in pairs(workspace:GetDescendants()) do

			if v:IsA("ParticleEmitter") or v:IsA("Trail") then
				v.Enabled = false
			end

			if v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
				v.Enabled = false
			end

			if v:IsA("BasePart") then
				v.CastShadow = false
				v.Material = Enum.Material.Plastic
			end
		end

		local sky = game.Lighting:FindFirstChildOfClass("Sky")
		if sky then sky:Destroy() end

		game.Lighting.GlobalShadows = false
		game.Lighting.OutdoorAmbient = Color3.fromRGB(120,120,120)

		print("🔥 ULTRA LOW ON")
	end

	------------------------------------------------
	-- 🖱️ DOBLE CLICK
	------------------------------------------------
	local lastClick = 0

	contador.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			local now = tick()

			if now - lastClick <= 0.3 then
				UltraLow()
			end

			lastClick = now
		end
	end)

	------------------------------------------------
	-- 🖱️ DRAG (ARREGLADO)
	------------------------------------------------
	local UIS = game:GetService("UserInputService")

	local dragging = false
	local dragStart, startPos

	contador.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			dragStart = input.Position
			startPos = contador.Position
		end
	end)

	UIS.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)

	UIS.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			local delta = input.Position - dragStart

			contador.Position = UDim2.new(
				startPos.X.Scale,
				startPos.X.Offset + delta.X,
				startPos.Y.Scale,
				startPos.Y.Offset + delta.Y
			)
		end
	end)

end)
