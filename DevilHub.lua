local httpService = game:GetService("HttpService")






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
                         if v.Name == "R3THTOGGLEBUTTON" then
                         v:Destroy()
                       end
                  end
              end
         end)
		})




local function toggleui()
    wait()
    local Toggle = false
    
    local R3THTOGGLEBUTTON = Instance.new("ScreenGui")
    local Button = Instance.new("TextButton")
    local UICorner = Instance.new("UICorner")
    local UICorner_2 = Instance.new("UICorner")

    R3THTOGGLEBUTTON.Name = "R3THTOGGLEBUTTON"
    R3THTOGGLEBUTTON.Parent = game.CoreGui

    Button.Name = "Button"
    Button.Parent = R3THTOGGLEBUTTON
    UICorner.CornerRadius = UDim.new(0, 7)
    UICorner_2.CornerRadius = UDim.new(0, 7)
    Button.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- CHANGES BUTTON COLOR
    Button.BorderColor3 = Color3.fromRGB(24, 24, 24)
    Button.BorderSizePixel = 0
    Button.Position = UDim2.new(0.942588627, 0, 0.223685458, 0)
    Button.Size = UDim2.new(0.0358672254, 0, 0.0771396905, 0)
    Button.AutoButtonColor = false -- Disable automatic button color change
    Button.Font = Enum.Font.SourceSans -- Set font to default
    Button.Text = "" -- Remove text

    -- Load the image
    local ImageLabel = Instance.new("ImageLabel")
    ImageLabel.Parent = Button
    ImageLabel.BackgroundTransparency = 1 -- Set transparency to 1 for full transparency
    ImageLabel.Size = UDim2.new(1, 0, 1, 0)
    ImageLabel.Image = "rbxassetid://16882312013" -- Set the image asset ID

    Button.MouseEnter:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(28, 28, 28) -- Change button color when hovered
    end)

    Button.MouseLeave:Connect(function()
        Button.BackgroundColor3 = Color3.fromRGB(24, 24, 24) -- Revert button color when not hovered
    end)

    -- Animation
    local TweenService = game:GetService("TweenService")
    local Info = TweenInfo.new(
        0.3, -- Duration
        Enum.EasingStyle.Quad, -- Easing style
        Enum.EasingDirection.Out, -- Easing direction
        -1, -- Number of times to repeat (-1 means infinite)
        true, -- Reverses if true
        0 -- Delay
    )

    local HoverTween = TweenService:Create(Button, Info, {BackgroundColor3 = Color3.fromRGB(28, 28, 28)})
    local LeaveTween = TweenService:Create(Button, Info, {BackgroundColor3 = Color3.fromRGB(24, 24, 24)})

    Button.MouseEnter:Connect(function()
        HoverTween:Play()
    end)

    Button.MouseLeave:Connect(function()
        LeaveTween:Play()
    end)

    -- Animation for button press
    local PressTween = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.037, 0, 0.078, 0)}) -- Change size on press
    local ReleaseTween = TweenService:Create(Button, TweenInfo.new(0.1), {Size = UDim2.new(0.0358672254, 0, 0.0771396905, 0)}) -- Revert size on release

    Button.MouseButton1Down:Connect(function()
        PressTween:Play()
    end)

    Button.MouseButton1Up:Connect(function()
        ReleaseTween:Play()
    end)

    Button.Draggable = true
    
    UICorner.Parent = Button
    
    UICorner_2.Parent = Button
    
    Button.MouseButton1Click:Connect(function()
        Toggle = not Toggle
        if Toggle then
            game:GetService('VirtualInputManager'):SendKeyEvent(true, 'LeftAlt', false, uwu)

        else
            game:GetService('VirtualInputManager'):SendKeyEvent(true, 'LeftAlt', false, uwu)

        end
    end)
    
    while Toggle do
        wait()
        -- Update UI if needed
    end
end



		
	
		local MenuKeybind = section:AddKeybind("MenuKeybind", { Title = "Minimize Bind", Default = Settings.MenuKeybind, Description = "You will set minimize bind.", })
		MenuKeybind:OnChanged(function()
			Settings.MenuKeybind = MenuKeybind.Value
            InterfaceManager:SaveSettings()
		end)
		Library.MinimizeKeybind = MenuKeybind
    end
end

return InterfaceManager
