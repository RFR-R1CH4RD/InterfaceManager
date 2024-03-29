local function toggleui()
    wait()
    local Toggle = false
    local ToggleUI = Instance.new("ScreenGui")
    local ImageButton = Instance.new("ImageButton")
    local UICorner = Instance.new("UICorner")
    local UIAspectRatioConstraint = Instance.new("UIAspectRatioConstraint")
    local UIAspectRatioConstraint_2 = Instance.new("UIAspectRatioConstraint")

    ToggleUI.Name = "ToggleUI"
    ToggleUI.Parent = game.CoreGui
    ToggleUI.ResetOnSpawn = false

    ImageButton.Parent = ToggleUI
    ImageButton.BackgroundColor3 = Color3.fromRGB(24, 24, 24)
    ImageButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
    ImageButton.BorderSizePixel = 0
    ImageButton.Position = UDim2.new(0.864814222, 0, 0.395481884, 0)
    ImageButton.Size = UDim2.new(0.0787679404, 0, 0.148388118, 0)
    ImageButton.AutoButtonColor = false
    ImageButton.Image = "rbxassetid://16882312013"

    UICorner.CornerRadius = UDim.new(0, 7)
    UICorner.Parent = ImageButton

    UIAspectRatioConstraint.Parent = ImageButton
    UIAspectRatioConstraint.AspectRatio = 1.028

    UIAspectRatioConstraint_2.Parent = ToggleUI
    UIAspectRatioConstraint_2.AspectRatio = 1.615

    local TweenService = game:GetService("TweenService")
    local DefaultSize = UDim2.new(0.079, 0, 0.148, 0)
    local UserInputService = game:GetService("UserInputService")

    local Dragging, DragInput, MousePos, StartPos = false

    local Info = TweenInfo.new(
        1,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out,
        -1,
        true,
        0
    )

    local HoverTween = TweenService:Create(ImageButton, Info, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
    local LeaveTween = TweenService:Create(ImageButton, Info, {BackgroundColor3 = Color3.fromRGB(24, 24, 24)})

    ImageButton.MouseEnter:Connect(function()
        HoverTween:Play()
    end)

    ImageButton.MouseLeave:Connect(function()
        LeaveTween:Play()
    end)

    local PressTween = TweenService:Create(ImageButton, TweenInfo.new(0.1), {Size = UDim2.new(0.079 * 1.2, 0, 0.148 * 1.2, 0)})
    local ReleaseTween = TweenService:Create(ImageButton, TweenInfo.new(0.1), {Size = DefaultSize})

    ImageButton.MouseButton1Down:Connect(function()
        PressTween:Play()
    end)

    ImageButton.MouseButton1Up:Connect(function()
        ReleaseTween:Play()
    end)

    local function StartDrag(input)
        Dragging = true
        MousePos = input.Position
        StartPos = ImageButton.Position
    end

    local function EndDrag()
        Dragging = false
    end

    ImageButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            StartDrag(input)
        end
    end)

    ImageButton.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    ImageButton.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            EndDrag()
        end
    end)

    ImageButton.MouseButton1Click:Connect(function()
        Toggle = not Toggle
        -- Perform action based on toggle state
        if Toggle then
            -- Handle toggle ON (e.g., enable Minimize function)
            print("Minimize enabled")
            -- Call MinimizeKeybind function here
            if InterfaceManager.Settings.MenuKeybind then
                InterfaceManager.Settings.MenuKeybind() -- Call the function
            end
        else
            -- Handle toggle OFF (e.g., disable Minimize function)
            print("Minimize disabled")
        end
    end)

    while Toggle do
        wait()
        -- Your code here for Minimize functionality when Toggle is true
    end
end

local InterfaceManager = {}
do
    InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Darker",
        Acrylic = false,
        Transparency = false,
        MenuKeybind = nil -- Define or remove reference to MinimizeKeybind2
    }
end
