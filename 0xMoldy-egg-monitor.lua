local oldGui = game:GetService("CoreGui"):FindFirstChild("EggSpawnMonitoringGUI")
local player = game:GetService("Players").LocalPlayer

local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")
local gui = Instance.new("ScreenGui")

gui.Name = "EggSpawnMonitoringGUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

if oldGui then
    oldGui:Destroy()
end

local window = Instance.new("Frame")
window.Name = "MainWindow"
window.Size = UDim2.new(0, 400, 0, 380)
window.Position = UDim2.new(0.5, -200, 0.5, -200)
window.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
window.BorderSizePixel = 2
window.Parent = gui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = window

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(55, 55, 65)
stroke.Thickness = 1
stroke.Parent = window

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, -20, 0, 30)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Egg Spawn Monitoring"
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window

local subtitle = Instance.new("TextLabel")
subtitle.Name = "Subtitle"
subtitle.Size = UDim2.new(1, -20, 0, 30)
subtitle.Position = UDim2.new(0, 10, 0, 33)
subtitle.BackgroundTransparency = 1
subtitle.Text = "Ride a Pet • Egg Spawn Monitoring"
subtitle.TextSize = 10
subtitle.Font = Enum.Font.Gotham
subtitle.TextColor3 = Color3.fromRGB(145, 145, 155)
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.Parent = window

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 35, 0, 35)
closeButton.Position = UDim2.new(1, -35, 0, 0)
closeButton.BackgroundTransparency = 1
closeButton.Text = "×"
closeButton.TextSize = 20
closeButton.Font = Enum.Font.GothamBold
closeButton.TextColor3 = Color3.fromRGB(255, 100, 100)
closeButton.Parent = window

local openButton = Instance.new("TextButton")
openButton.Name = "OpenButton"
openButton.Size = UDim2.new(0, 45, 0, 45)
openButton.Position = UDim2.new(0.5, -22, 0.5, -22)
openButton.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
openButton.BorderSizePixel = 0
openButton.Text = "◉"
openButton.TextSize = 18
openButton.Font = Enum.Font.GothamBold
openButton.TextColor3 = Color3.fromRGB(255, 255, 255)
openButton.Visible = false
openButton.Parent = gui

local openCorner = Instance.new("UICorner")
openCorner.CornerRadius = UDim.new(1, 0)
openCorner.Parent = openButton

local openStroke = Instance.new("UIStroke")
openStroke.Color = Color3.fromRGB(55, 55, 65)
openStroke.Thickness = 1
openStroke.Parent = openButton

closeButton.MouseButton1Click:Connect(function()
    window.Visible = false
    openButton.Visible = true
end)

openButton.MouseButton1Click:Connect(function()
    window.Visible = true
    openButton.Visible = false
end)

local UserInputService = game:GetService("UserInputService")

local function makeDraggable(object, dragArea)
    local dragging = false
    local dragStart
    local startPosition

    dragArea.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPosition = object.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if not dragging then
            return
        end

        if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then

            local delta = input.Position - dragStart

            object.Position = UDim2.new(
                startPosition.X.Scale,
                startPosition.X.Offset + delta.X,
                startPosition.Y.Scale,
                startPosition.Y.Offset + delta.Y
            )
        end
    end)
end

makeDraggable(openButton, openButton)

local dragArea = Instance.new("Frame")
dragArea.Name = "DragArea"
dragArea.Size = UDim2.new(1, -40, 0, 60)
dragArea.Position = UDim2.new(0, 0, 0, 0)
dragArea.BackgroundTransparency = 1
dragArea.Active = true
dragArea.Parent = window

dragArea.ZIndex = 0
title.ZIndex = 1
subtitle.ZIndex = 1
closeButton.ZIndex = 2

makeDraggable(window, dragArea)

local sidebar = Instance.new("Frame")
sidebar.Name = "Sidebar"
sidebar.Size = UDim2.new(0, 120, 1, -60)
sidebar.Position = UDim2.new(0, 0, 0, 60)
sidebar.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
sidebar.BorderSizePixel = 1
sidebar.Parent = window

local sidebarCorner = Instance.new("UICorner")
sidebarCorner.CornerRadius = UDim.new(0, 8)
sidebarCorner.Parent = sidebar

local statusButton = Instance.new("TextButton")
statusButton.Name = "StatusButton"
statusButton.Size = UDim2.new(1, -20, 0, 20)
statusButton.Position = UDim2.new(0, 10, 0, 15)
statusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
statusButton.BorderSizePixel = 0
statusButton.Text = "   ◉   Status"
statusButton.TextSize = 10
statusButton.Font = Enum.Font.GothamMedium
statusButton.TextColor3 = Color3.fromRGB(255, 255, 255)
statusButton.TextXAlignment = Enum.TextXAlignment.Left
statusButton.Parent = sidebar

local statusCorner = Instance.new("UICorner")
statusCorner.CornerRadius = UDim.new(0, 7)
statusCorner.Parent = statusButton

local webhookButton = Instance.new("TextButton")
webhookButton.Name = "WebhookButton"
webhookButton.Size = UDim2.new(1, -20, 0, 20)
webhookButton.Position = UDim2.new(0, 10, 0, 45)
webhookButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
webhookButton.BorderSizePixel = 0
webhookButton.Text = "   🔔   Webhook"
webhookButton.TextSize = 10
webhookButton.Font = Enum.Font.GothamMedium
webhookButton.TextColor3 = Color3.fromRGB(255, 255, 255)
webhookButton.TextXAlignment = Enum.TextXAlignment.Left
webhookButton.Parent = sidebar

local webhookButtonCorner = Instance.new("UICorner")
webhookButtonCorner.CornerRadius = UDim.new(0, 7)
webhookButtonCorner.Parent = webhookButton

local statusPage = Instance.new("ScrollingFrame")
statusPage.Name = "StatusPage"
statusPage.Size = UDim2.new(1, -130, 1, -60)
statusPage.Position = UDim2.new(0, 130, 0, 60)
statusPage.BackgroundTransparency = 1
statusPage.BorderSizePixel = 0
statusPage.ScrollBarThickness = 5
statusPage.CanvasSize = UDim2.new(0, 0, 0, 0)
statusPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
statusPage.Parent = window

local statusLayout = Instance.new("UIListLayout")
statusLayout.Padding = UDim.new(0, 10)
statusLayout.SortOrder = Enum.SortOrder.LayoutOrder
statusLayout.Parent = statusPage

local monitoringEnabled = false

local monitoringCard = Instance.new("Frame")
monitoringCard.Name = "MonitoringCard"
monitoringCard.Size = UDim2.new(1, -20, 0, 65)
monitoringCard.Position = UDim2.new(0, 10, 0, 45)
monitoringCard.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
monitoringCard.BorderSizePixel = 0
monitoringCard.Parent = statusPage

local monitoringCorner = Instance.new("UICorner")
monitoringCorner.CornerRadius = UDim.new(0, 8)
monitoringCorner.Parent = monitoringCard

local monitoringTitle = Instance.new("TextLabel")
monitoringTitle.Name = "Title"
monitoringTitle.Size = UDim2.new(1, -20, 0, 25)
monitoringTitle.Position = UDim2.new(0, 10, 0, 7)
monitoringTitle.BackgroundTransparency = 1
monitoringTitle.Text = "●  Monitoring"
monitoringTitle.TextSize = 11
monitoringTitle.Font = Enum.Font.GothamMedium
monitoringTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
monitoringTitle.TextXAlignment = Enum.TextXAlignment.Left
monitoringTitle.Parent = monitoringCard

local monitoringStatus = Instance.new("TextLabel")
monitoringStatus.Name = "Status"
monitoringStatus.Size = UDim2.new(1, -20, 0, 20)
monitoringStatus.Position = UDim2.new(0, 10, 0, 32)
monitoringStatus.BackgroundTransparency = 1
monitoringStatus.Text = "Stopped"
monitoringStatus.TextSize = 10
monitoringStatus.Font = Enum.Font.Gotham
monitoringStatus.TextColor3 = Color3.fromRGB(180, 180, 190)
monitoringStatus.TextXAlignment = Enum.TextXAlignment.Left
monitoringStatus.Parent = monitoringCard

local monitoringButton = Instance.new("TextButton")
monitoringButton.Name = "MonitoringButton"
monitoringButton.Size = UDim2.new(0, 100, 0, 25)
monitoringButton.Position = UDim2.new(1, -110, 0, 20)
monitoringButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
monitoringButton.BorderSizePixel = 0
monitoringButton.Text = "Start"
monitoringButton.TextSize = 9
monitoringButton.Font = Enum.Font.GothamMedium
monitoringButton.TextColor3 = Color3.fromRGB(255, 255, 255)
monitoringButton.Parent = monitoringCard

local monitoringButtonCorner = Instance.new("UICorner")
monitoringButtonCorner.CornerRadius = UDim.new(0, 6)
monitoringButtonCorner.Parent = monitoringButton

local statusWebhookCard = Instance.new("Frame")
statusWebhookCard.Name = "WebhookCard"
statusWebhookCard.Size = UDim2.new(1, -20, 0, 65)
statusWebhookCard.Position = UDim2.new(0, 10, 0, 10)
statusWebhookCard.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
statusWebhookCard.BorderSizePixel = 0
statusWebhookCard.Parent = statusPage

local statusWebhookCorner = Instance.new("UICorner")
statusWebhookCorner.CornerRadius = UDim.new(0, 8)
statusWebhookCorner.Parent = statusWebhookCard

local statusWebhookTitle = Instance.new("TextLabel")
statusWebhookTitle.Name = "Title"
statusWebhookTitle.Size = UDim2.new(1, -20, 0, 25)
statusWebhookTitle.Position = UDim2.new(0, 10, 0, 7)
statusWebhookTitle.BackgroundTransparency = 1
statusWebhookTitle.Text = "●  Webhook"
statusWebhookTitle.TextSize = 11
statusWebhookTitle.Font = Enum.Font.GothamMedium
statusWebhookTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
statusWebhookTitle.TextXAlignment = Enum.TextXAlignment.Left
statusWebhookTitle.Parent = statusWebhookCard

local statusWebhookStatus = Instance.new("TextLabel")
statusWebhookStatus.Name = "Status"
statusWebhookStatus.Size = UDim2.new(1, -20, 0, 20)
statusWebhookStatus.Position = UDim2.new(0, 10, 0, 32)
statusWebhookStatus.BackgroundTransparency = 1
statusWebhookStatus.Text = "Not Connected"
statusWebhookStatus.TextSize = 10
statusWebhookStatus.Font = Enum.Font.Gotham
statusWebhookStatus.TextColor3 = Color3.fromRGB(180, 180, 190)
statusWebhookStatus.TextXAlignment = Enum.TextXAlignment.Left
statusWebhookStatus.Parent = statusWebhookCard

local weatherCard = Instance.new("Frame")
weatherCard.Name = "WeatherCard"
weatherCard.Size = UDim2.new(1, -20, 0, 65)
weatherCard.Position = UDim2.new(0, 10, 0, 65)
weatherCard.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
weatherCard.BorderSizePixel = 0
weatherCard.Parent = statusPage

local weatherCardCorner = Instance.new("UICorner")
weatherCardCorner.CornerRadius = UDim.new(0, 8)
weatherCardCorner.Parent = weatherCard

local weatherTitle = Instance.new("TextLabel")
weatherTitle.Name = "Title"
weatherTitle.Size = UDim2.new(1, -20, 0, 25)
weatherTitle.Position = UDim2.new(0, 10, 0, 7)
weatherTitle.BackgroundTransparency = 1
weatherTitle.Text = "Current Weather"
weatherTitle.TextSize = 11
weatherTitle.Font = Enum.Font.GothamMedium
weatherTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
weatherTitle.TextXAlignment = Enum.TextXAlignment.Left
weatherTitle.Parent = weatherCard

local weatherStatus = Instance.new("TextLabel")
weatherStatus.Name = "Status"
weatherStatus.Size = UDim2.new(1, -20, 0, 20)
weatherStatus.Position = UDim2.new(0, 10, 0, 32)
weatherStatus.BackgroundTransparency = 1
weatherStatus.Text = "No weather detected"
weatherStatus.TextSize = 10
weatherStatus.Font = Enum.Font.Gotham
weatherStatus.TextColor3 = Color3.fromRGB(180, 180, 190)
weatherStatus.TextXAlignment = Enum.TextXAlignment.Left
weatherStatus.Parent = weatherCard

local etherealCard = Instance.new("Frame")
etherealCard.Name = "EtherealCard"
etherealCard.Size = UDim2.new(1, -20, 0, 125)
etherealCard.Position = UDim2.new(0, 10, 0, 160)
etherealCard.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
etherealCard.BorderSizePixel = 0
etherealCard.Parent = statusPage

local etherealCorner = Instance.new("UICorner")
etherealCorner.CornerRadius = UDim.new(0, 8)
etherealCorner.Parent = etherealCard

local etherealTitle = Instance.new("TextLabel")
etherealTitle.Name = "Title"
etherealTitle.Size = UDim2.new(1, -20, 0, 25)
etherealTitle.Position = UDim2.new(0, 10, 0, 7)
etherealTitle.BackgroundTransparency = 1
etherealTitle.Text = "Ethereal Eggs"
etherealTitle.TextSize = 11
etherealTitle.Font = Enum.Font.GothamBold
etherealTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
etherealTitle.TextXAlignment = Enum.TextXAlignment.Left
etherealTitle.Parent = etherealCard

local blackholeLabel = Instance.new("TextLabel")
blackholeLabel.Name = "BlackholeEgg"
blackholeLabel.Size = UDim2.new(1, -30, 0, 20)
blackholeLabel.Position = UDim2.new(0, 15, 0, 35)
blackholeLabel.BackgroundTransparency = 1
blackholeLabel.Text = "Blackhole Egg"
blackholeLabel.TextSize = 10
blackholeLabel.Font = Enum.Font.Gotham
blackholeLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
blackholeLabel.TextXAlignment = Enum.TextXAlignment.Left
blackholeLabel.Parent = etherealCard

local blackholeStock = Instance.new("TextLabel")
blackholeStock.Name = "Stock"
blackholeStock.Size = UDim2.new(0, 30, 0, 20)
blackholeStock.Position = UDim2.new(1, -45, 0, 35)
blackholeStock.BackgroundTransparency = 1
blackholeStock.Text = "0"
blackholeStock.TextSize = 10
blackholeStock.Font = Enum.Font.GothamBold
blackholeStock.TextColor3 = Color3.fromRGB(255, 255, 255)
blackholeStock.TextXAlignment = Enum.TextXAlignment.Right
blackholeStock.Parent = etherealCard

local solarisLabel = Instance.new("TextLabel")
solarisLabel.Name = "SolarisEgg"
solarisLabel.Size = UDim2.new(1, -30, 0, 20)
solarisLabel.Position = UDim2.new(0, 15, 0, 60)
solarisLabel.BackgroundTransparency = 1
solarisLabel.Text = "Solaris Egg"
solarisLabel.TextSize = 10
solarisLabel.Font = Enum.Font.Gotham
solarisLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
solarisLabel.TextXAlignment = Enum.TextXAlignment.Left
solarisLabel.Parent = etherealCard

local solarisStock = Instance.new("TextLabel")
solarisStock.Name = "Stock"
solarisStock.Size = UDim2.new(0, 30, 0, 20)
solarisStock.Position = UDim2.new(1, -45, 0, 60)
solarisStock.BackgroundTransparency = 1
solarisStock.Text = "0"
solarisStock.TextSize = 10
solarisStock.Font = Enum.Font.GothamBold
solarisStock.TextColor3 = Color3.fromRGB(255, 255, 255)
solarisStock.TextXAlignment = Enum.TextXAlignment.Right
solarisStock.Parent = etherealCard

local cherubLabel = Instance.new("TextLabel")
cherubLabel.Name = "CherubEgg"
cherubLabel.Size = UDim2.new(1, -30, 0, 20)
cherubLabel.Position = UDim2.new(0, 15, 0, 85)
cherubLabel.BackgroundTransparency = 1
cherubLabel.Text = "Cherub Egg"
cherubLabel.TextSize = 10
cherubLabel.Font = Enum.Font.Gotham
cherubLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
cherubLabel.TextXAlignment = Enum.TextXAlignment.Left
cherubLabel.Parent = etherealCard

local cherubStock = Instance.new("TextLabel")
cherubStock.Name = "Stock"
cherubStock.Size = UDim2.new(0, 30, 0, 20)
cherubStock.Position = UDim2.new(1, -45, 0, 85)
cherubStock.BackgroundTransparency = 1
cherubStock.Text = "0"
cherubStock.TextSize = 10
cherubStock.Font = Enum.Font.GothamBold
cherubStock.TextColor3 = Color3.fromRGB(255, 255, 255)
cherubStock.TextXAlignment = Enum.TextXAlignment.Right
cherubStock.Parent = etherealCard

local function getEggStock(eggName)
    local playerGui = player:FindFirstChild("PlayerGui")
    if not playerGui then
        return 0
    end

    local main = playerGui:FindFirstChild("Main")
    if not main then
        return 0
    end

    local eggTracker = main:FindFirstChild("EggTracker")
    if not eggTracker then
        return 0
    end

    local eggsHolder = eggTracker:FindFirstChild("EggsHolder")
    if not eggsHolder then
        return 0
    end

    local egg = eggsHolder:FindFirstChild(eggName)
    if not egg then
        return 0
    end

    for _, obj in ipairs(egg:GetDescendants()) do
        if obj:IsA("TextLabel") or obj:IsA("TextButton") then
            local text = obj.Text or ""
            local number = string.match(text, "%d+")

            if number then
                return tonumber(number)
            end
        end
    end

    return 0
end

local function updateEtherealStock()
    blackholeStock.Text = tostring(getEggStock("Blackhole Egg"))
    solarisStock.Text = tostring(getEggStock("Solaris Egg"))
    cherubStock.Text = tostring(getEggStock("Cherub Egg"))
end

updateEtherealStock()

task.spawn(function()
    while gui.Parent do
        updateEtherealStock()
        task.wait(2)
    end
end)

local webhookPage = Instance.new("Frame")
webhookPage.Name = "WebhookPage"
webhookPage.Size = UDim2.new(1, -130, 1, -60)
webhookPage.Position = UDim2.new(0, 130, 0, 60)
webhookPage.BackgroundTransparency = 1
webhookPage.Visible = false
webhookPage.Parent = window

local webhookSettingsCard = Instance.new("Frame")
webhookSettingsCard.Name = "WebhookSettingsCard"
webhookSettingsCard.Size = UDim2.new(1, -20, 0, 280)
webhookSettingsCard.Position = UDim2.new(0, 10, 0, 10)
webhookSettingsCard.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
webhookSettingsCard.BorderSizePixel = 0
webhookSettingsCard.Parent = webhookPage

local webhookSettingsCorner = Instance.new("UICorner")
webhookSettingsCorner.CornerRadius = UDim.new(0, 8)
webhookSettingsCorner.Parent = webhookSettingsCard

local webhookSettingsTitle = Instance.new("TextLabel")
webhookSettingsTitle.Name = "Title"
webhookSettingsTitle.Size = UDim2.new(1, -20, 0, 25)
webhookSettingsTitle.Position = UDim2.new(0, 10, 0, 7)
webhookSettingsTitle.BackgroundTransparency = 1
webhookSettingsTitle.Text = "Discord Webhooks"
webhookSettingsTitle.TextSize = 11
webhookSettingsTitle.Font = Enum.Font.GothamMedium
webhookSettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
webhookSettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
webhookSettingsTitle.Parent = webhookSettingsCard

local webhookInputs = {}

for i = 1, 3 do
    local input = Instance.new("TextBox")
    input.Name = "WebhookInput" .. i
    input.Size = UDim2.new(1, -20, 0, 35)
    input.Position = UDim2.new(0, 10, 0, 35 + ((i - 1) * 80))
    input.TextWrapped = true
    input.ClearTextOnFocus = false
    input.BackgroundColor3 = Color3.fromRGB(22, 22, 27)
    input.BorderSizePixel = 0
    input.PlaceholderText = "Webhook " .. i .. " URL..."
    input.PlaceholderColor3 = Color3.fromRGB(110, 110, 120)
    input.Text = ""
    input.TextSize = 10
    input.Font = Enum.Font.Gotham
    input.TextColor3 = Color3.fromRGB(255, 255, 255)
    input.TextXAlignment = Enum.TextXAlignment.Left
    input.Parent = webhookSettingsCard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 6)
    corner.Parent = input

    table.insert(webhookInputs, input)
end

local webhookInfo = Instance.new("TextLabel")
webhookInfo.Name = "WebhookInfo"
webhookInfo.Size = UDim2.new(1, -20, 0, 25)
webhookInfo.Position = UDim2.new(0, 10, 0, 275)
webhookInfo.BackgroundTransparency = 1
webhookInfo.Text = "For multiple webhooks, separate each URL with a comma (,)"
webhookInfo.TextSize = 9
webhookInfo.Font = Enum.Font.Gotham
webhookInfo.TextColor3 = Color3.fromRGB(130, 130, 140)
webhookInfo.TextXAlignment = Enum.TextXAlignment.Left
webhookInfo.Parent = webhookSettingsCard

local lastStock = {
    ["Blackhole Egg"] = 0,
    ["Solaris Egg"] = 0,
    ["Cherub Egg"] = 0
}

local lastDetectionTime = {
    ["Blackhole Egg"] = 0,
    ["Solaris Egg"] = 0,
    ["Cherub Egg"] = 0
}

local STOCK_RESET_TIME = 420


local webhookConnected = false

local function getWebhooks(index)
    local webhooks = {}
    local input = webhookInputs[index]

    if not input then
        return webhooks
    end

    for webhook in string.gmatch(input.Text, "([^,]+)") do
        webhook = string.gsub(webhook, "^%s*(.-)%s*$", "%1")

        if string.find(webhook, "^https://discord.com/api/webhooks/") then
            table.insert(webhooks, webhook)
        end
    end

    return webhooks
end

webhookInput:GetPropertyChangedSignal("Text"):Connect(function()
    local webhooks = getWebhooks()

    if #webhooks > 0 then
        webhookConnected = true
        statusWebhookStatus.Text = "Configured"
        statusWebhookStatus.TextColor3 = Color3.fromRGB(100, 220, 130)
    else
        webhookConnected = false
        statusWebhookStatus.Text = "Not Connected"
        statusWebhookStatus.TextColor3 = Color3.fromRGB(180, 180, 190)
    end
end)

local filterTitle = Instance.new("TextLabel")
filterTitle.Name = "FilterTitle"
filterTitle.Size = UDim2.new(1, -20, 0, 25)
filterTitle.Position = UDim2.new(0, 10, 0, 170)
filterTitle.BackgroundTransparency = 1
filterTitle.Text = "Egg Filter"
filterTitle.TextSize = 11
filterTitle.Font = Enum.Font.GothamMedium
filterTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
filterTitle.TextXAlignment = Enum.TextXAlignment.Left
filterTitle.Parent = webhookPage

local eggDropdown = Instance.new("TextButton")
eggDropdown.Name = "EggDropdown"
eggDropdown.Size = UDim2.new(1, -20, 0, 35)
eggDropdown.Position = UDim2.new(0, 10, 0, 195)
eggDropdown.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
eggDropdown.BorderSizePixel = 0
eggDropdown.Text = "  Select Eggs"
eggDropdown.TextSize = 10
eggDropdown.Font = Enum.Font.Gotham
eggDropdown.TextColor3 = Color3.fromRGB(180, 180, 190)
eggDropdown.TextXAlignment = Enum.TextXAlignment.Left
eggDropdown.Parent = webhookPage

local eggDropdownCorner = Instance.new("UICorner")
eggDropdownCorner.CornerRadius = UDim.new(0, 7)
eggDropdownCorner.Parent = eggDropdown

local eggList = Instance.new("Frame")
eggList.Name = "EggList"
eggList.Size = UDim2.new(1, -20, 0, 105)
eggList.Position = UDim2.new(0, 10, 0, 235)
eggList.BackgroundColor3 = Color3.fromRGB(30, 30, 36)
eggList.BorderSizePixel = 0
eggList.Visible = false
eggList.Parent = webhookPage

local eggListCorner = Instance.new("UICorner")
eggListCorner.CornerRadius = UDim.new(0, 7)
eggListCorner.Parent = eggList

local blackholeOption = Instance.new("TextButton")
blackholeOption.Name = "BlackholeOption"
blackholeOption.Size = UDim2.new(1, -10, 0, 25)
blackholeOption.Position = UDim2.new(0, 5, 0, 5)
blackholeOption.BackgroundTransparency = 1
blackholeOption.Text = "□  Blackhole Egg"
blackholeOption.TextSize = 10
blackholeOption.Font = Enum.Font.Gotham
blackholeOption.TextColor3 = Color3.fromRGB(180, 180, 190)
blackholeOption.TextXAlignment = Enum.TextXAlignment.Left
blackholeOption.Parent = eggList

local solarisOption = Instance.new("TextButton")
solarisOption.Name = "SolarisOption"
solarisOption.Size = UDim2.new(1, -10, 0, 25)
solarisOption.Position = UDim2.new(0, 5, 0, 40)
solarisOption.BackgroundTransparency = 1
solarisOption.Text = "□  Solaris Egg"
solarisOption.TextSize = 10
solarisOption.Font = Enum.Font.Gotham
solarisOption.TextColor3 = Color3.fromRGB(180, 180, 190)
solarisOption.TextXAlignment = Enum.TextXAlignment.Left
solarisOption.Parent = eggList

local cherubOption = Instance.new("TextButton")
cherubOption.Name = "CherubOption"
cherubOption.Size = UDim2.new(1, -10, 0, 25)
cherubOption.Position = UDim2.new(0, 5, 0, 75)
cherubOption.BackgroundTransparency = 1
cherubOption.Text = "□  Cherub Egg"
cherubOption.TextSize = 10
cherubOption.Font = Enum.Font.Gotham
cherubOption.TextColor3 = Color3.fromRGB(180, 180, 190)
cherubOption.TextXAlignment = Enum.TextXAlignment.Left
cherubOption.Parent = eggList

local blackholeSelected = false
local solarisSelected = false
local cherubSelected = false

local function updateEggDropdownText()
    local selectedCount = 0

    if blackholeSelected then
        selectedCount = selectedCount + 1
    end

    if solarisSelected then
        selectedCount = selectedCount + 1
    end

    if cherubSelected then
        selectedCount = selectedCount + 1
    end

    if selectedCount == 0 then
        eggDropdown.Text = "  Select Eggs"
    elseif selectedCount == 1 then
        eggDropdown.Text = "  1 Egg Selected"
    else
        eggDropdown.Text = "  " .. selectedCount .. " Eggs Selected"
    end
end

eggDropdown.MouseButton1Click:Connect(function()
    eggList.Visible = not eggList.Visible
end)

blackholeOption.MouseButton1Click:Connect(function()
    blackholeSelected = not blackholeSelected

    if blackholeSelected then
        blackholeOption.Text = "✓  Blackhole Egg"
        blackholeOption.TextColor3 = Color3.fromRGB(100, 220, 130)
    else
        blackholeOption.Text = "□  Blackhole Egg"
        blackholeOption.TextColor3 = Color3.fromRGB(180, 180, 190)
    end

    updateEggDropdownText()
end)

solarisOption.MouseButton1Click:Connect(function()
    solarisSelected = not solarisSelected

    if solarisSelected then
        solarisOption.Text = "✓  Solaris Egg"
        solarisOption.TextColor3 = Color3.fromRGB(100, 220, 130)
    else
        solarisOption.Text = "□  Solaris Egg"
        solarisOption.TextColor3 = Color3.fromRGB(180, 180, 190)
    end

    updateEggDropdownText()
end)

cherubOption.MouseButton1Click:Connect(function()
    cherubSelected = not cherubSelected

    if cherubSelected then
        cherubOption.Text = "✓  Cherub Egg"
        cherubOption.TextColor3 = Color3.fromRGB(100, 220, 130)
    else
        cherubOption.Text = "□  Cherub Egg"
        cherubOption.TextColor3 = Color3.fromRGB(180, 180, 190)
    end

    updateEggDropdownText()
end)

local function isEggSelected(eggName)
    if not blackholeSelected
    and not solarisSelected
    and not cherubSelected then
        return true
    end

    if eggName == "Blackhole Egg" then
        return blackholeSelected
    end

    if eggName == "Solaris Egg" then
        return solarisSelected
    end

    if eggName == "Cherub Egg" then
        return cherubSelected
    end

    return false
end

local function sendWebhook(index, message)
    local webhooks = getWebhooks(index)
    if #webhooks == 0 then
        return false
    end
    local requestFunction =
        (syn and syn.request)
        or (http and http.request)
        or http_request
        or request
    if not requestFunction then
        return false
    end
    local success = true
    for _, webhook in ipairs(webhooks) do
        local sent = pcall(function()
            requestFunction({
                Url = webhook,
                Method = "POST",
                Headers = {
                    ["Content-Type"] = "application/json"
                },
                Body = HttpService:JSONEncode({
                    content = message
                })
            })
        end)
        if not sent then
            success = false
        end
    end
    return success
end

local function getSelectedInStockEggs()
    local parts = {}

    local blackhole = getEggStock("Blackhole Egg")
    local solaris = getEggStock("Solaris Egg")
    local cherub = getEggStock("Cherub Egg")

    if isEggSelected("Blackhole Egg") and blackhole > 0 then
        table.insert(
            parts,
            "🌌 Blackhole Egg: **" .. tostring(blackhole) .. "**"
        )
    end

    if isEggSelected("Solaris Egg") and solaris > 0 then
        table.insert(
            parts,
            "☀️ Solaris Egg: **" .. tostring(solaris) .. "**"
        )
    end

    if isEggSelected("Cherub Egg") and cherub > 0 then
        table.insert(
            parts,
            "🪽 Cherub Egg: **" .. tostring(cherub) .. "**"
        )
    end

    return parts
end

local testWebhookButton = Instance.new("TextButton")
testWebhookButton.Name = "TestWebhookButton"
testWebhookButton.Size = UDim2.new(1, -20, 0, 35)
testWebhookButton.Position = UDim2.new(0, 10, 0, 135)
testWebhookButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
testWebhookButton.BorderSizePixel = 0
testWebhookButton.Text = "Test Webhook"
testWebhookButton.TextSize = 10
testWebhookButton.Font = Enum.Font.GothamMedium
testWebhookButton.TextColor3 = Color3.fromRGB(255, 255, 255)
testWebhookButton.Parent = webhookPage

local testWebhookCorner = Instance.new("UICorner")
testWebhookCorner.CornerRadius = UDim.new(0, 7)
testWebhookCorner.Parent = testWebhookButton

testWebhookButton.MouseButton1Click:Connect(function()
    if #getWebhooks() == 0 then
        testWebhookButton.Text = "No Webhook"
        task.wait(1.5)
        testWebhookButton.Text = "Test Webhook"
        return
    end

    local message =
        "**\n ⚠️TEST — ETHEREAL EGGS⚠️**\n\n"
    local success = sendWebhook(message)

    if success then
        testWebhookButton.Text = "Sent!"
    else
        testWebhookButton.Text = "Failed"
    end

    task.wait(1.5)
    testWebhookButton.Text = "Test Webhook"
end)

local function sendEggNotification(eggName, stock)
    local emoji = "🥚"
    if eggName == "Blackhole Egg" then
        emoji = "🌌"
    elseif eggName == "Solaris Egg" then
        emoji = "☀️"
    elseif eggName == "Cherub Egg" then
        emoji = "🪽"
    end
    local webhookIndex = 1
    if eggName == "Solaris Egg" then
        webhookIndex = 2
    elseif eggName == "Cherub Egg" then
        webhookIndex = 3
    end
    sendWebhook(
        webhookIndex,
        emoji .. " **" .. eggName .. " DETECTED!**\n" ..
        "Stock: **" .. tostring(stock) .. "**"
    )
end

local function scanEgg(eggName)
    local stock = getEggStock(eggName)

    if not isEggSelected(eggName) then
        lastStock[eggName] = stock
        lastDetectionTime[eggName] = 0
        return
    end

    local now = os.time()

    if stock > 0 then
        if lastDetectionTime[eggName] == 0 then
            if lastStock[eggName] <= 0 then
                sendEggNotification(eggName, stock)
                lastDetectionTime[eggName] = now
            end
        elseif now - lastDetectionTime[eggName] >= STOCK_RESET_TIME then
            sendEggNotification(eggName, stock)
            lastDetectionTime[eggName] = now
        end
    else
        lastStock[eggName] = 0
    end

    lastStock[eggName] = stock
end

task.spawn(function()
    while gui.Parent do
        if monitoringEnabled then
            scanEgg("Blackhole Egg")
            scanEgg("Solaris Egg")
            scanEgg("Cherub Egg")
        end

        task.wait(2)
    end
end)

monitoringButton.MouseButton1Click:Connect(function()
    if #getWebhooks() == 0 then
        monitoringEnabled = false
        monitoringStatus.Text = "Webhook Required"
        monitoringStatus.TextColor3 = Color3.fromRGB(255, 170, 80)
        monitoringButton.Text = "Start"
        return
    end

    monitoringEnabled = not monitoringEnabled

    if monitoringEnabled then
        lastStock["Blackhole Egg"] = getEggStock("Blackhole Egg")
        lastStock["Solaris Egg"] = getEggStock("Solaris Egg")
        lastStock["Cherub Egg"] = getEggStock("Cherub Egg")

        lastDetectionTime["Blackhole Egg"] = 0
        lastDetectionTime["Solaris Egg"] = 0
        lastDetectionTime["Cherub Egg"] = 0

        monitoringStatus.Text = "Running"
        monitoringStatus.TextColor3 = Color3.fromRGB(100, 220, 130)
        monitoringButton.Text = "Stop"
    else
        lastStock["Blackhole Egg"] = 0
        lastStock["Solaris Egg"] = 0
        lastStock["Cherub Egg"] = 0

        lastDetectionTime["Blackhole Egg"] = 0
        lastDetectionTime["Solaris Egg"] = 0
        lastDetectionTime["Cherub Egg"] = 0

        monitoringStatus.Text = "Stopped"
        monitoringStatus.TextColor3 = Color3.fromRGB(180, 180, 190)
        monitoringButton.Text = "Start"
    end
end)

statusButton.MouseButton1Click:Connect(function()
    statusPage.Visible = true
    webhookPage.Visible = false

    statusButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
    webhookButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
end)

webhookButton.MouseButton1Click:Connect(function()
    statusPage.Visible = false
    webhookPage.Visible = true

    statusButton.BackgroundColor3 = Color3.fromRGB(45, 45, 55)
    webhookButton.BackgroundColor3 = Color3.fromRGB(55, 55, 65)
end)
