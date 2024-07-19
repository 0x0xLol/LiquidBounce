repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character

local PlayerService = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local lplr = PlayerService.LocalPlayer

local LiquidBounceLoaded = false

if getgenv == nil then
	getgenv = function() return {} end
end

local GuiScale = 0.82

local makefolder = getgenv().makefolder or function() warn("MAKEFOLDER NOT SUPPORTED!") end
local writefile = getgenv().writefile or function() warn("WRITEFILE NOT SUPPORTED!") end
local isfile = getgenv().isfile or function() warn("ISFILE NOT SUPPORTED!") end
local readfile = getgenv().readfile or function() warn("READFILE NOT SUPPORTED!") end
local delfile = getgenv().delfile or function() warn("DELFILE NOT SUPPORTED!") end
local loadfile = getgenv().loadfile or function() warn("LOADFILE NOT SUPPORTED!") end
local debugTest = debug.getupvalue ~= nil and debug.getupvalue or function() warn("DEBUG.GETUPVALUE NOT SUPPORTED!") end
local require = getgenv().require or function() warn("REQUIRE NOT SUPPORTED!") end

local hasDebugUpValue = function()
	return debug.getupvalue
end

local config = { -- LiquidConfig V1
	Buttons = {},
	Toggles = {},
	Dropdowns = {},
	Keybinds = {}
}

if not isfile("Liquidbounce") then
	makefolder("Liquidbounce")
end

if not isfile("Liquidbounce/Configs") then
	makefolder("Liquidbounce/Configs")
end

local isConfigAvailable = function()
	return isfile("Liquidbounce/Configs/"..game.PlaceId..".json")
end

local saveConfig = function()

	if isConfigAvailable() then
		delfile("Liquidbounce/Configs/"..game.PlaceId..".json")
	end

	writefile("Liquidbounce/Configs/"..game.PlaceId..".json",HttpService:JSONEncode(config))
end

local loadConfig = function()
	local data = readfile("Liquidbounce/Configs/"..game.PlaceId..".json")
	if data then
		config = HttpService:JSONDecode(data)
	end
end

if not isConfigAvailable() then
	saveConfig()
else
	loadConfig()
	task.wait(0.5)
end

local Gui = {
	GetInstance = function(instance,data)
		local inst = Instance.new(instance)

		for i,v in pairs(data) do
			inst[i] = v
		end

		return inst
	end,
}

local ScreenGui = Gui.GetInstance("ScreenGui",{
	Parent = lplr.PlayerGui,
	ResetOnSpawn = false,
	IgnoreGuiInset = true
})

local isInEditingMode = false

local Watermark = Gui.GetInstance("TextLabel",{
	Parent = ScreenGui,
	Size = UDim2.fromScale(0.13,0.04),
	Position = UDim2.fromScale(0.05,0.07),
	BackgroundTransparency = 1,
	Text = "Liquidbounce",
	TextSize = 24,
	TextColor3 = Color3.fromRGB(2, 93, 230),
	Active = true,
	Draggable = false,
	BorderSizePixel = 0,
})

--[[if isfile("Liquidbounce/Configs/Positions.json") then
	--Watermark.Position = HttpService:JSONDecode(readfile("Liquidbounce/Configs/Positions.json"))
end

local funny = Instance.new("TextLabel")

funny.Changed:Connect(function()
	if not isfile("Liquidbounce/Configs/Positions.json") then
		writefile("Liquidbounce/Configs/Positions.json", HttpService:JSONEncode(Watermark.Position))
	end
end)]]

local ArrayListFrame = Gui.GetInstance("Frame",{
	Parent = ScreenGui,
	Size = UDim2.fromScale(0.3,1),
	Position = UDim2.fromScale(0.68,0.05),
	BackgroundTransparency = 1,
})
local arrayItems = {}

local shadowAsset = "http://www.roblox.com/asset/?id=6288018083"

local Arraylist = {
	Create = function(name, subtext)
		task.spawn(function()
			repeat task.wait() until LiquidBounceLoaded
			local item =  Gui.GetInstance("TextLabel",{
				Parent = ArrayListFrame,
				BackgroundTransparency = 1,
				TextSize = 12,
				TextColor3 = Color3.fromRGB(2, 93, 230),
				Text = name .. " <font color=\"rgb(135,135,135)\">["..subtext.."]</font>",
				Size = UDim2.fromScale(1,0.03),
				TextXAlignment = Enum.TextXAlignment.Right,
				ZIndex = 2,
				Name = name
			})

			if subtext ~= "" then
				item.RichText = true
				item.Text = name .. " <font color=\"rgb(135,135,135)\">["..subtext.."]</font>"
			else
				item.Text = name
			end

			--[[if ArrayListShadow.Enabled then
				local shadowType = ArrayListShadowType.Option

				if shadowType == "Normal" then
					local shadow =  Gui.GetInstance("TextLabel",{
						Parent = item,
						BackgroundTransparency = 1,
						TextSize = 12,
						TextColor3 = Color3.fromRGB(36, 36, 36),
						Text = name,
						Size = UDim2.fromScale(1,0.03),
						Position = UDim2.fromScale(0.005,0.5),
						TextXAlignment = Enum.TextXAlignment.Right,
						ZIndex = -99,
					})
				elseif shadowType == "Modern" then
					local shadow = Gui.GetInstance("ImageLabel",{
						Parent = item,
						BackgroundTransparency = 1,
						ImageColor3 = Color3.fromRGB(0,0,0),
						ImageTransparency = 0.75,
						Image = shadowAsset,
						Size = UDim2.fromScale(0.65 + name:len()/125,4),
						ZIndex = -99,
						Position = UDim2.fromScale(0.7 - name:len()/125,-1)
					})
				end
			end]]

			table.insert(arrayItems,item)
			table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
			for i,v in ipairs(arrayItems) do
				v.LayoutOrder = i
			end

		end)

	end,
	Remove = function(name)
		table.sort(arrayItems,function(a,b) return game.TextService:GetTextSize(a.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X > game.TextService:GetTextSize(b.Text.."  ",30,Enum.Font.SourceSans,Vector2.new(0,0)).X end)
		for i,v in pairs(arrayItems) do
			if v.Name == name then
				v:Remove()
				table.remove(arrayItems,i)
			end
		end
	end,
}

local SortArrayList = Gui.GetInstance("UIListLayout",{
	Parent = ArrayListFrame,
	SortOrder = Enum.SortOrder.LayoutOrder
})

local EditHudButton = Gui.GetInstance("ImageButton",{
	Parent = ScreenGui,
	Position = UDim2.fromScale(0.01,0.92),
	Size = UDim2.fromScale(0.03,0.045),
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(54, 71, 96),
	Image = "rbxassetid://11432847075",
})

local RoundEditHudButton = Gui.GetInstance("UICorner",{
	Parent = EditHudButton
})

local WindowInstances = {}
local ClickguiVisible = false

local toggleEditMode = function()
	isInEditingMode = not isInEditingMode
	EditHudButton.Visible = not isInEditingMode
	if isInEditingMode then
		for i,v in pairs(WindowInstances) do
			if ClickguiVisible then
				v.Visible = false
			end
		end
		Watermark.BackgroundTransparency = 0.5
		Watermark.Draggable = true
	else
		Watermark.BackgroundTransparency = 1
		Watermark.Draggable = false
	end
end

EditHudButton.MouseButton1Down:Connect(toggleEditMode)
EditHudButton.Visible = false

local Terminal = Gui.GetInstance("TextLabel", {
	Parent = ScreenGui,
	Position = UDim2.fromScale(0.7, 0.75),
	Size = UDim2.fromScale(0.2, 0.03),
	BorderColor3 = Color3.fromRGB(100, 100, 100),
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(0,0,0),
	TextColor3 = Color3.fromRGB(255,255,255),
	Text = "   Command Prompt",
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Left,
	Active = true,
	Draggable = true,
	Visible = false
})

local TerminalFrame = Gui.GetInstance("Frame", {
	Parent = Terminal,
	Position = UDim2.fromScale(0, 1),
	Size = UDim2.fromScale(1, 4.5),
	BorderSizePixel = 0,
	BackgroundColor3 = Color3.fromRGB(25,25,25),
})
local sortTerminal = Gui.GetInstance("UIListLayout", {Parent = TerminalFrame})

local enterTerminalCode = Gui.GetInstance("TextBox", {
	Parent = TerminalFrame,
	BackgroundTransparency = 1,
	Text = "  Enter command . . .",
	TextXAlignment = Enum.TextXAlignment.Left,
	TextColor3 = Color3.fromRGB(255,255,255),
	TextSize = 8,
	Size = UDim2.fromScale(1, 0.2),
	Name = "enterTerminalCode"
})

local AddToTerminal = function(stuff)
	local NewTextBox = Gui.GetInstance("TextLabel", {
		Parent = TerminalFrame,
		Size = UDim2.fromScale(1, 0.2),
		Position = UDim2.fromScale(0,0),
		BackgroundTransparency = 1,
		TextColor3 = Color3.fromRGB(255,255,255),
		TextSize = 8,
		Text = "  "..stuff,
		TextXAlignment = Enum.TextXAlignment.Left
	})
end

local keybinds = {

}

local getRemote = function(name)
	local remote
	for i,v in pairs(game:GetDescendants()) do
		if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
			if v.Name == name then
				remote = v
			end
		end
	end

	if remote == nil then
		return Instance.new("RemoteEvent")
	end

	return remote
end

enterTerminalCode.FocusLost:Connect(function()
	if enterTerminalCode.Text:lower():find("del all") or enterTerminalCode.Text:lower():find("delete all") then
		for i,v in pairs(TerminalFrame:GetChildren()) do
			if v.Name == "enterTerminalCode" then continue end
			v:Remove()
		end
	end

	local args = enterTerminalCode.Text:lower():split(" ")


	if args[1] == "bind" then
		if args[2] ~= nil and args[3] ~= nil then
			local module = args[2]
			local key = args[3]

			if keybinds[module] ~= nil then
				keybinds[module] = Enum.KeyCode[key:upper()]
				AddToTerminal("Succesfully bound "..module.. " to ".. key)
				config.Keybinds[module:lower()] = key:upper()
			end

			task.delay(0.2,function()
				saveConfig()
			end)
		end

	end

	enterTerminalCode.Text = "  Enter command . . ."
end)

AddToTerminal("LiquidBounce Roblox [Version 0.0.1]")

local isTogglingSounds = false

local WindowCount = 0
local GuiLibrary = {
	CreateWindow = function(name)
		local top = Gui.GetInstance("TextLabel",{
			Text = name,
			TextSize = 9,
			Size = UDim2.fromScale(0.1 * GuiScale,0.0395 * GuiScale),
			Position = UDim2.fromScale(0.1 + (0.11 * WindowCount),0.12),
			AnchorPoint = Vector2.new(0.5, 0.5),
			BackgroundColor3 = Color3.fromRGB(42,57,79),
			TextColor3 = Color3.fromRGB(255,255,255),
			Active = true,
			Draggable = true,
			Parent = ScreenGui,
			Visible = false,
			BorderSizePixel = 0
		})

		table.insert(WindowInstances,top)

		local dragging = false
		local draggingConnection

		top.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				draggingConnection = RunService.Heartbeat:Connect(function(delta)
					local MouseLocation = UserInputService:GetMouseLocation()
					top.Position = UDim2.fromOffset(MouseLocation.X, MouseLocation.Y)
				end)
			end
		end)

		top.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = false
				draggingConnection:Disconnect()
			end
		end)

		local hold = Gui.GetInstance("Frame", {
			Parent = top,
			Position = UDim2.fromScale(0, 1),
			Size = UDim2.fromScale(1, 10),
			BackgroundTransparency = 1,
		})

		local sort = Gui.GetInstance("UIListLayout", {
			Parent = hold
		})

		UserInputService.InputBegan:Connect(function(Key, GPE)
			if GPE then return end
			if Key.KeyCode == Enum.KeyCode.RightShift then
				top.Visible = not ClickguiVisible

				if name == "Combat" then
					Terminal.Visible = not Terminal.Visible
					ClickguiVisible = not ClickguiVisible

					if ClickguiVisible ~= EditHudButton.Visible then
						EditHudButton.Visible = ClickguiVisible
					end

					if isInEditingMode and not EditHudButton.Visible then
						toggleEditMode()
					end
				end
			end
		end)

		WindowCount += 1
		return {
			CreateButton = function(Table)
				local returnthing = {}

				local ShouldEnabled = false

				if config.Buttons[Table.Name] ~= nil then
					ShouldEnabled = config.Buttons[Table.Name].Enabled
				else
					config.Buttons[Table.Name] = {
						Enabled = false,
					}
				end

				local Button = Gui.GetInstance("TextButton", {
					Parent = hold,
					Size = UDim2.fromScale(1, 0.1),
					Position = UDim2.fromScale(0,0),
					BorderSizePixel = 0,
					Name = Table.Name,
					Text = "  " .. Table.Name,
					TextColor3 = Color3.fromRGB(255,255,255),
					BackgroundColor3 = Color3.fromRGB(54, 71, 96), -- 7,152,252 (ENABLED)
					TextXAlignment = Enum.TextXAlignment.Left,
					AutoButtonColor = false,
				})
				keybinds[Table.Name:lower()] = Enum.KeyCode.Unknown

				if config.Keybinds[Table.Name:lower()] ~= nil then
					keybinds[Table.Name:lower()] = Enum.KeyCode[config.Keybinds[Table.Name:lower()]]
				end

				local arrow = Gui.GetInstance("ImageButton", {
					Image = "rbxassetid://11419703997",
					BackgroundTransparency = 1,
					Parent = Button,
					Position = UDim2.fromScale(0.85, 0.3),
					Size = UDim2.fromScale(0.1, 0.4),
					Visible = false,
				})

				local dropdown = Gui.GetInstance("Frame", {
					Parent = Button,
					Size = UDim2.fromScale(1, 5),
					Position = UDim2.fromScale(1.02, 0),
					BackgroundTransparency = 1,
					Visible = false
				})

				local sortDropdown = Gui.GetInstance("UIListLayout", {
					Parent = dropdown
				})
				
				returnthing.SubText = ""
				returnthing.Enabled = false
				returnthing.ToggleButton = function()
					if isTogglingSounds then
						local clicksound = Instance.new("Sound")
						clicksound.SoundId = "rbxassetid://535716488" -- 535716488
						clicksound.Parent = workspace
						clicksound:Play()

						clicksound.Ended:Connect(function()
							clicksound:Remove()
						end)
					end

					returnthing.Enabled = not returnthing.Enabled
					Button.BackgroundColor3 = (returnthing.Enabled and Color3.fromRGB(7,152,252) or Color3.fromRGB(54, 71, 96))
					task.delay(0.1, function()
						task.spawn(function()
							repeat task.wait() until LiquidBounceLoaded
							Table.Function(returnthing.Enabled)
						end)
					end)

					config.Buttons[Table.Name].Enabled = returnthing.Enabled

					if returnthing.Enabled then
						if returnthing.SubText ~= "" then
							task.delay(0.1, function()
								Arraylist.Create(Table.Name, returnthing.SubText)
							end)
						else
							Arraylist.Create(Table.Name, "")
						end
					else
						Arraylist.Remove(Table.Name)
					end

					task.delay(0.1,function()
						saveConfig()
					end)
				end

				UserInputService.InputBegan:Connect(function(key, GPE)
					if GPE then return end

					if key.KeyCode == keybinds[Table.Name:lower()] and keybinds[Table.Name:lower()] ~= Enum.KeyCode.Unknown then
						returnthing.ToggleButton()
					end
				end)

				returnthing.ToggleDropdown = function()
					dropdown.Visible = not dropdown.Visible
				end

				Button.MouseButton1Down:Connect(function()
					returnthing.ToggleButton()
				end)

				if ShouldEnabled then
					returnthing.ToggleButton()
				end

				Button.MouseButton2Down:Connect(function()
					returnthing.ToggleDropdown()
				end)

				arrow.MouseButton1Down:Connect(function()
					returnthing.ToggleDropdown()
				end)

				returnthing.CreateToggle = function(Table2)
					arrow.Visible = true
					local ShouldEnabled2 = false

					local found = pcall(function()
						ShouldEnabled2 = config.Toggles[Table.Name.."_"..Table2.Name].Enabled
					end)
					if not found then
						config.Toggles[Table.Name.."_"..Table2.Name] = {
							Enabled = false,
						}
					end

					local newButton = Gui.GetInstance("TextButton", {
						Parent = dropdown,
						Size = UDim2.fromScale(0.8, 0.1),
						BackgroundColor3 = Color3.fromRGB(54, 71, 96),
						Text = "  " .. Table2.Name,
						Name = Table2.Name,
						BorderSizePixel = 0,
						TextColor3 = Color3.fromRGB(107, 107, 107),
						AutoButtonColor = false,
						TextStrokeTransparency = 0.85,
						TextXAlignment = Enum.TextXAlignment.Left
					})
					local funny = {}
					funny.Enabled = false

					funny.ToggleButton = function()
						funny.Enabled = not funny.Enabled

						config.Toggles[Table.Name.."_"..Table2.Name].Enabled = funny.Enabled

						newButton.TextColor3 = (funny.Enabled and Color3.fromRGB(255,255,255) or Color3.fromRGB(107, 107, 107))
						task.spawn(function()
							if Table2.Function then
								Table2.Function(funny.Enabled)
							end
						end)

						task.delay(0.2,function()
							saveConfig()
						end)
					end

					if ShouldEnabled then
						funny.ToggleButton()
					end

					newButton.MouseButton1Down:Connect(function()
						funny.ToggleButton()
					end)

					return funny
				end

				returnthing.CreateDropdown = function(Table2)
					arrow.Visible = true
					local Mode = Table2.Options[1]

					local found = pcall(function()
						Mode = config.Dropdowns[Table.Name.."_"..Table2.Name].Mode
					end)
					if not found then
						config.Dropdowns[Table.Name.."_"..Table2.Name] = {
							Mode = Table2.Options[1],
						}
					end

					local newButton = Gui.GetInstance("TextButton", {
						Parent = dropdown,
						Size = UDim2.fromScale(0.8, 0.1),
						BackgroundColor3 = Color3.fromRGB(54, 71, 96),
						Text = "  " .. Table2.Name .. "               +",
						Name = Table2.Name,
						BorderSizePixel = 0,
						TextColor3 = Color3.fromRGB(255,255,255),
						AutoButtonColor = false,
						TextStrokeTransparency = 0.95,
						TextXAlignment = Enum.TextXAlignment.Left
					})

					local numbOfOptions = 0
					for i,v in pairs(Table2.Options) do numbOfOptions += 1 end

					if numbOfOptions < 2 then
						numbOfOptions = 2
					end

					local funnyFrame = Gui.GetInstance("Frame", {
						Parent = newButton,
						Size = UDim2.fromScale(1, numbOfOptions),
						Position = UDim2.fromScale(0, 1),
						Transparency = 1,
						Visible = false,
					})

					local sortDropdown = Gui.GetInstance("UIListLayout", {
						Parent = funnyFrame
					})

					local funny = {}
					funny.Option = Table2.Options[1]

					funny.ShowDropdown = function()
						for i,v in pairs(dropdown:GetChildren()) do
							if v:IsA("UIListLayout") then continue end
							if v.Name == Table2.Name then continue end
							v.Visible = not v.Visible
						end
						newButton.Text = (funnyFrame.Visible == false and "  " .. Table2.Name .. "               -" or "  " .. Table2.Name .. "               +")
						funnyFrame.Visible = not funnyFrame.Visible
					end

					local options = {}

					for i,v in pairs(Table2.Options) do
						local newthing = Gui.GetInstance("TextButton", {
							Name = v,
							Text = "  " .. v,
							Size = UDim2.fromScale(1, 0.5),
							Position = UDim2.fromScale(0,0),
							BackgroundColor3 = Color3.fromRGB(54, 71, 96),
							Parent = funnyFrame,
							TextColor3 = Color3.fromRGB(107, 107, 107),
							TextXAlignment = Enum.TextXAlignment.Left,
							BorderSizePixel = 0,
							AutoButtonColor = false,
						})

						table.insert(options,newthing)

						newthing.MouseButton1Down:Connect(function()
							for i,v in pairs(funnyFrame:GetChildren()) do
								if v:IsA("UIListLayout") then
									continue
								end
								v.TextColor3 = Color3.fromRGB(107, 107, 107)
							end
							newthing.TextColor3 = Color3.fromRGB(255,255,255)
							funny.Option = v

							config.Dropdowns[Table.Name.."_"..Table2.Name] = {
								Mode = v,
							}

							task.delay(0.2,function()
								saveConfig()
							end)
						end)

					end

					if found then
						for i,v in pairs(funnyFrame:GetChildren()) do
							if v:IsA("UIListLayout") then
								continue
							end
							v.TextColor3 = Color3.fromRGB(107, 107, 107)

							if v.Name == Mode then
								v.TextColor3 = Color3.fromRGB(255,255,255)
							end
						end

						funny.Option = Mode
					end

					newButton.MouseButton1Down:Connect(function()
						funny.ShowDropdown()
					end)

					return funny
				end

				return returnthing
			end,
		}
	end,
}

return GuiLibrary
