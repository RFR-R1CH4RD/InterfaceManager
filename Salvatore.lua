local httpService = game:GetService("HttpService")

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
    local ScreenGui = ToggleUI 
    local ImageButton = ImageButton 

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

    UserInputService.InputChanged:Connect(function(input)
        if input == DragInput and Dragging then
            local Delta = input.Position - MousePos
            ImageButton.Position = UDim2.new(
                StartPos.X.Scale, StartPos.X.Offset + Delta.X,
                StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y
            )
        end
    end)

    ImageButton.MouseButton1Click:Connect(function()
        Toggle = not Toggle
        if Toggle then
            game:GetService("UserInputService"):SetKeyboardState(Enum.KeyCode.LeftAlt, false)
        else
           game:GetService("UserInputService"):SetKeyboardState(Enum.KeyCode.LeftAlt, false)
        end
    end)

    while Toggle do
        wait()
    end
end





local InterfaceManager = {} do
	InterfaceManager.Folder = "FluentSettings"
    InterfaceManager.Settings = {
        Theme = "Darker",
        Acrylic = false,
        Transparency = false,
        MenuKeybind = "LeftAlt"
    }

    function InterfaceManager:SetFolder(folder)
		self.Folder = folder;
		self:BuildFolderTree()
	end

    function InterfaceManager:SetLibrary(library)
		self.Library = library
	end

    function InterfaceManager:BuildFolderTree()
		local paths = {}

		local parts = self.Folder:split("/")
		for idx = 1, #parts do
			paths[#paths + 1] = table.concat(parts, "/", 1, idx)
		end

		table.insert(paths, self.Folder)
		table.insert(paths, self.Folder .. "/settings")

		for i = 1, #paths do
			local str = paths[i]
			if not isfolder(str) then
				makefolder(str)
			end
		end
	end

    function InterfaceManager:SaveSettings()
        writefile(self.Folder .. "/options.json", httpService:JSONEncode(InterfaceManager.Settings))
    end

    function InterfaceManager:LoadSettings()
        local path = self.Folder .. "/options.json"
        if isfile(path) then
            local data = readfile(path)
            local success, decoded = pcall(httpService.JSONDecode, httpService, data)

            if success then
                for i, v in next, decoded do
                    InterfaceManager.Settings[i] = v
                end
            end
        end
    end

    function InterfaceManager:BuildInterfaceSection(tab)
        assert(self.Library, "Must set InterfaceManager.Library")
		local Library = self.Library
        local Settings = InterfaceManager.Settings

        InterfaceManager:LoadSettings()

		local section = tab:AddSection("Interface")

		local InterfaceTheme = section:AddDropdown("InterfaceTheme", {
			Title = "Theme",
			Description = "You will choose theme.",
			Values = Library.Themes,
			Default = Settings.Theme,
			Callback = function(Value)
				Library:SetTheme(Value)
                Settings.Theme = Value
                InterfaceManager:SaveSettings()
			end
		})

        InterfaceTheme:SetValue(Settings.Theme)
	
		if Library.UseAcrylic then
			section:AddToggle("AcrylicToggle", {
				Title = "Acrylic",
				Description = "You will enable acrylic.(The blurred background requires graphic quality 8+)",
				Default = Settings.Acrylic,
				Callback = function(Value)
					Library:ToggleAcrylic(Value)
                    Settings.Acrylic = Value
                    InterfaceManager:SaveSettings()
				end
			})
		end
	
		section:AddToggle("TransparentToggle", {
			Title = "Transparency",
			Description = "You will enable transparency.",
			Default = Settings.Transparency,
			Callback = function(Value)
				Library:ToggleTransparency(Value)
				Settings.Transparency = Value
                InterfaceManager:SaveSettings()
			end
		})


		section:AddToggle("UIToggleButtonToggle", {
			Title = "UI Toggle Button",
			Description = "You will enable ui toggle button.",
			Callback = function(uitogglebutton)
		          if uitogglebutton == true then
        toggleui()
    else
        for i,v in pairs(game.CoreGui:GetChildren()) do
            if v.Name == "ToggleUI" then
                v:Destroy()
            end
        end
    end
	end
		})






		
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind, Description = "You will set minimize bind.", })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
