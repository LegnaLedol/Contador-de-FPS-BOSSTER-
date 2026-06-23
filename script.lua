-- LEGNA PREMIUM HUD 😈✨

local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")
local Lighting = game:GetService("Lighting")
local UIS = game:GetService("UserInputService")
local SoundService = game:GetService("SoundService")

-- 🔥 BOOST BASE
Lighting.GlobalShadows = false
Lighting.FogEnd = 9e9
Lighting.Brightness = 0
settings().Rendering.QualityLevel = "Level01"

-- 🚀 BOOST ULTRA + SONIDO
local function BoostUltra()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("Part") or v:IsA("MeshPart") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v:Destroy()
        elseif v:IsA("Fire") or v:IsA("Smoke") then
            v:Destroy()
        end
    end

    -- 🔊 SONIDO TURBO
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://911342077"
    sound.Volume = 1.5
    sound.PlaybackSpeed = 1.05
    sound.Parent = SoundService
    sound:Play()

    task.delay(3, function()
        sound:Destroy()
    end)
end

-- 🎯 GUI
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

-- TEXTO
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

-- 📱 DRAG SOLO EN FRAME (FIX BUG)
local dragging = false
local dragInput, dragStart, startPos

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

-- 🌈 RGB + FPS
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

print("😈 LEGNA PREMIUM ACTIVADO")
