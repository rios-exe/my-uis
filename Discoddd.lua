-- Discord UI Library (Modern Discord 2024 Style)
-- Обновлённая версия с современным дизайном Discord

local DiscordLib = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local LocalPlayer = game:GetService("Players").LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local HttpService = game:GetService("HttpService")
local pfp
local user
local tag
local userinfo = {}

-- ============================================================
-- СОВРЕМЕННАЯ ПАЛИТРА DISCORD (2024)
-- ============================================================
local Colors = {
	Background       = Color3.fromRGB(49, 51, 56),    -- #313338
	BackgroundAlt    = Color3.fromRGB(43, 45, 49),    -- #2B2D31
	BackgroundDark   = Color3.fromRGB(30, 31, 34),    -- #1E1F22
	BackgroundHover  = Color3.fromRGB(53, 55, 60),    -- #35373C
	BackgroundActive = Color3.fromRGB(64, 66, 71),    -- #404247
	ChannelBar       = Color3.fromRGB(43, 45, 49),    -- #2B2D31
	Blurple          = Color3.fromRGB(88, 101, 242),  -- #5865F2
	BlurpleHover     = Color3.fromRGB(71, 82, 196),   -- #4752C4
	BlurpleActive    = Color3.fromRGB(59, 68, 165),   -- #3B44A5
	Green            = Color3.fromRGB(35, 165, 90),   -- #23A55A
	Red              = Color3.fromRGB(218, 55, 60),   -- #DA373C
	Yellow           = Color3.fromRGB(240, 178, 50),  -- #F0B232
	TextNormal       = Color3.fromRGB(242, 243, 245), -- #F2F3F5
	TextMuted        = Color3.fromRGB(148, 155, 164), -- #949BA4
	TextLink         = Color3.fromRGB(0, 168, 252),   -- #00A8FC
	ChannelDefault   = Color3.fromRGB(128, 132, 142), -- #80848E
	ChannelHover     = Color3.fromRGB(219, 222, 225), -- #DBDEE1
	Divider          = Color3.fromRGB(63, 65, 71),    -- #3F4147
	InputBackground  = Color3.fromRGB(30, 31, 34),    -- #1E1F22
}
DiscordLib.Colors = Colors

pcall(function()
	userinfo = HttpService:JSONDecode(readfile("discordlibinfo.txt"))
end)

pfp = userinfo["pfp"] or "https://www.roblox.com/headshot-thumbnail/image?userId=" .. game.Players.LocalPlayer.UserId .. "&width=420&height=420&format=png"
user = userinfo["user"] or game.Players.LocalPlayer.Name
tag = userinfo["tag"] or tostring(math.random(1000, 9999))

local function SaveInfo()
	userinfo["pfp"] = pfp
	userinfo["user"] = user
	userinfo["tag"] = tag
	writefile("discordlibinfo.txt", HttpService:JSONEncode(userinfo))
end

-- ============================================================
-- DRAGGABLE
-- ============================================================
local function MakeDraggable(topbarobject, object)
	local Dragging = nil
	local DragInput = nil
	local DragStart = nil
	local StartPosition = nil

	local function Update(input)
		local Delta = input.Position - DragStart
		local pos = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
		object.Position = pos
	end

	topbarobject.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			Dragging = true
			DragStart = input.Position
			StartPosition = object.Position

			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					Dragging = false
				end
			end)
		end
	end)

	topbarobject.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			DragInput = input
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input == DragInput and Dragging then
			Update(input)
		end
	end)
end

-- ============================================================
-- SCREENGUI
-- ============================================================
local Discord = Instance.new("ScreenGui")
Discord.Name = "Discord"
Discord.Parent = game.CoreGui
Discord.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Discord.ResetOnSpawn = false

function DiscordLib:Window(text)
	local currentservertoggled = ""
	local minimized = false
	local fs = false
	local settingsopened = false

	local MainFrame = Instance.new("Frame")
	local MainFrameCorner = Instance.new("UICorner")
	local MainFrameShadow = Instance.new("ImageLabel")
	local TopFrame = Instance.new("Frame")
	local Title = Instance.new("TextLabel")
	local CloseBtn = Instance.new("TextButton")
	local CloseIcon = Instance.new("ImageLabel")
	local MinimizeBtn = Instance.new("TextButton")
	local MinimizeIcon = Instance.new("ImageLabel")
	local ServersHolder = Instance.new("Folder")
	local Userpad = Instance.new("Frame")
	local UserpadCorner = Instance.new("UICorner")
	local UserIcon = Instance.new("Frame")
	local UserIconCorner = Instance.new("UICorner")
	local UserImage = Instance.new("ImageLabel")
	local UserCircleImage = Instance.new("ImageLabel")
	local StatusDot = Instance.new("Frame")
	local StatusDotCorner = Instance.new("UICorner")
	local StatusDotOutline = Instance.new("Frame")
	local StatusDotOutlineCorner = Instance.new("UICorner")
	local UserName = Instance.new("TextLabel")
	local UserTag = Instance.new("TextLabel")
	local ServersHoldFrame = Instance.new("Frame")
	local ServersHold = Instance.new("ScrollingFrame")
	local ServersHoldLayout = Instance.new("UIListLayout")
	local ServersHoldPadding = Instance.new("UIPadding")
	local TopFrameHolder = Instance.new("Frame")

	MainFrame.Name = "MainFrame"
	MainFrame.Parent = Discord
	MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrame.BackgroundColor3 = Colors.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrame.Size = UDim2.new(0, 780, 0, 500)

	MainFrameCorner.CornerRadius = UDim.new(0, 10)
	MainFrameCorner.Parent = MainFrame

	MainFrameShadow.Name = "Shadow"
	MainFrameShadow.Parent = MainFrame
	MainFrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
	MainFrameShadow.BackgroundTransparency = 1
	MainFrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
	MainFrameShadow.Size = UDim2.new(1, 60, 1, 60)
	MainFrameShadow.ZIndex = -1
	MainFrameShadow.Image = "rbxassetid://5554236805"
	MainFrameShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
	MainFrameShadow.ImageTransparency = 0.4
	MainFrameShadow.ScaleType = Enum.ScaleType.Slice
	MainFrameShadow.SliceCenter = Rect.new(23, 23, 277, 277)

	TopFrame.Name = "TopFrame"
	TopFrame.Parent = MainFrame
	TopFrame.BackgroundColor3 = Colors.Background
	TopFrame.BackgroundTransparency = 1
	TopFrame.BorderSizePixel = 0
	TopFrame.Position = UDim2.new(0, 0, 0, 0)
	TopFrame.Size = UDim2.new(0, 780, 0, 26)

	TopFrameHolder.Name = "TopFrameHolder"
	TopFrameHolder.Parent = TopFrame
	TopFrameHolder.BackgroundColor3 = Colors.Background
	TopFrameHolder.BackgroundTransparency = 1
	TopFrameHolder.BorderSizePixel = 0
	TopFrameHolder.Position = UDim2.new(0, 0, 0, 0)
	TopFrameHolder.Size = UDim2.new(0, 780, 0, 26)

	Title.Name = "Title"
	Title.Parent = TopFrame
	Title.BackgroundTransparency = 1
	Title.Position = UDim2.new(0.012, 0, 0, 0)
	Title.Size = UDim2.new(0, 300, 0, 26)
	Title.Font = Enum.Font.GothamMedium
	Title.Text = text
	Title.TextColor3 = Colors.TextMuted
	Title.TextSize = 13
	Title.TextXAlignment = Enum.TextXAlignment.Left

	-- Кнопка закрытия (современный вид, круглый hover)
	CloseBtn.Name = "CloseBtn"
	CloseBtn.Parent = TopFrame
	CloseBtn.BackgroundColor3 = Colors.Background
	CloseBtn.BackgroundTransparency = 0
	CloseBtn.Position = UDim2.new(0.965, 0, 0, 0)
	CloseBtn.Size = UDim2.new(0, 26, 0, 26)
	CloseBtn.Font = Enum.Font.Gotham
	CloseBtn.Text = ""
	CloseBtn.BorderSizePixel = 0
	CloseBtn.AutoButtonColor = false

	local CloseBtnCorner = Instance.new("UICorner")
	CloseBtnCorner.CornerRadius = UDim.new(0, 6)
	CloseBtnCorner.Parent = CloseBtn

	CloseIcon.Name = "CloseIcon"
	CloseIcon.Parent = CloseBtn
	CloseIcon.BackgroundTransparency = 1
	CloseIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseIcon.Size = UDim2.new(0, 16, 0, 16)
	CloseIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
	CloseIcon.ImageColor3 = Colors.TextMuted

	-- Кнопка минимизации
	MinimizeBtn.Name = "MinimizeBtn"
	MinimizeBtn.Parent = TopFrame
	MinimizeBtn.BackgroundColor3 = Colors.Background
	MinimizeBtn.BackgroundTransparency = 0
	MinimizeBtn.Position = UDim2.new(0.931, 0, 0, 0)
	MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
	MinimizeBtn.Font = Enum.Font.Gotham
	MinimizeBtn.Text = ""
	MinimizeBtn.BorderSizePixel = 0
	MinimizeBtn.AutoButtonColor = false

	local MinimizeBtnCorner = Instance.new("UICorner")
	MinimizeBtnCorner.CornerRadius = UDim.new(0, 6)
	MinimizeBtnCorner.Parent = MinimizeBtn

	MinimizeIcon.Name = "MinimizeIcon"
	MinimizeIcon.Parent = MinimizeBtn
	MinimizeIcon.BackgroundTransparency = 1
	MinimizeIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	MinimizeIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	MinimizeIcon.Size = UDim2.new(0, 16, 0, 16)
	MinimizeIcon.Image = "http://www.roblox.com/asset/?id=6035067836"
	MinimizeIcon.ImageColor3 = Colors.TextMuted

	ServersHolder.Name = "ServersHolder"
	ServersHolder.Parent = TopFrameHolder

	-- ============================================================
	-- USER PAD (нижняя панель пользователя, как в Discord)
	-- ============================================================
	Userpad.Name = "Userpad"
	Userpad.Parent = TopFrameHolder
	Userpad.BackgroundColor3 = Colors.BackgroundDark
	Userpad.BorderSizePixel = 0
	Userpad.Position = UDim2.new(0.008, 0, 1.2, 0)
	Userpad.Size = UDim2.new(0, 240, 0, 52)

	UserpadCorner.CornerRadius = UDim.new(0, 8)
	UserpadCorner.Parent = Userpad

	UserIcon.Name = "UserIcon"
	UserIcon.Parent = Userpad
	UserIcon.BackgroundColor3 = Colors.BackgroundDark
	UserIcon.BorderSizePixel = 0
	UserIcon.Position = UDim2.new(0.025, 0, 0.15, 0)
	UserIcon.Size = UDim2.new(0, 36, 0, 36)

	UserIconCorner.CornerRadius = UDim.new(1, 0)
	UserIconCorner.Parent = UserIcon

	UserImage.Name = "UserImage"
	UserImage.Parent = UserIcon
	UserImage.BackgroundTransparency = 1
	UserImage.Size = UDim2.new(1, 0, 1, 0)
	UserImage.Image = pfp
	UserImage.ZIndex = 2

	UserCircleImage.Name = "UserCircleImage"
	UserCircleImage.Parent = UserImage
	UserCircleImage.BackgroundTransparency = 1
	UserCircleImage.Size = UDim2.new(1, 0, 1, 0)
	UserCircleImage.Image = "rbxassetid://4031889928"
	UserCircleImage.ImageColor3 = Colors.BackgroundDark
	UserCircleImage.ZIndex = 3

	-- Индикатор онлайн
	StatusDot.Name = "StatusDot"
	StatusDot.Parent = UserIcon
	StatusDot.AnchorPoint = Vector2.new(0.5, 0.5)
	StatusDot.BackgroundColor3 = Colors.Green
	StatusDot.Position = UDim2.new(1, -2, 1, -2)
	StatusDot.Size = UDim2.new(0, 13, 0, 13)
	StatusDot.ZIndex = 5

	StatusDotCorner.CornerRadius = UDim.new(1, 0)
	StatusDotCorner.Parent = StatusDot

	StatusDotOutline.Name = "StatusDotOutline"
	StatusDotOutline.Parent = StatusDot
	StatusDotOutline.AnchorPoint = Vector2.new(0.5, 0.5)
	StatusDotOutline.BackgroundColor3 = Colors.BackgroundDark
	StatusDotOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
	StatusDotOutline.Size = UDim2.new(1, 4, 1, 4)
	StatusDotOutline.ZIndex = -1

	StatusDotOutlineCorner.CornerRadius = UDim.new(1, 0)
	StatusDotOutlineCorner.Parent = StatusDotOutline

	UserName.Name = "UserName"
	UserName.Parent = Userpad
	UserName.BackgroundTransparency = 1
	UserName.BorderSizePixel = 0
	UserName.Position = UDim2.new(0.2, 0, 0.15, 0)
	UserName.Size = UDim2.new(0, 140, 0, 18)
	UserName.Font = Enum.Font.GothamBold
	UserName.TextColor3 = Colors.TextNormal
	UserName.TextSize = 14
	UserName.TextXAlignment = Enum.TextXAlignment.Left
	UserName.ClipsDescendants = true
	UserName.Text = user

	UserTag.Name = "UserTag"
	UserTag.Parent = Userpad
	UserTag.BackgroundTransparency = 1
	UserTag.BorderSizePixel = 0
	UserTag.Position = UDim2.new(0.2, 0, 0.53, 0)
	UserTag.Size = UDim2.new(0, 140, 0, 16)
	UserTag.Font = Enum.Font.Gotham
	UserTag.TextColor3 = Colors.TextMuted
	UserTag.TextSize = 12
	UserTag.TextXAlignment = Enum.TextXAlignment.Left
	UserTag.Text = "#" .. tag

	ServersHoldFrame.Name = "ServersHoldFrame"
	ServersHoldFrame.Parent = MainFrame
	ServersHoldFrame.BackgroundTransparency = 1
	ServersHoldFrame.BorderSizePixel = 0
	ServersHoldFrame.Position = UDim2.new(0, 0, 0, 26)
	ServersHoldFrame.Size = UDim2.new(0, 72, 0, 474)

	ServersHold.Name = "ServersHold"
	ServersHold.Parent = ServersHoldFrame
	ServersHold.Active = true
	ServersHold.BackgroundTransparency = 1
	ServersHold.BorderSizePixel = 0
	ServersHold.Position = UDim2.new(0, 0, 0, 8)
	ServersHold.Size = UDim2.new(0, 72, 0, 466)
	ServersHold.ScrollBarThickness = 2
	ServersHold.ScrollBarImageTransparency = 1
	ServersHold.CanvasSize = UDim2.new(0, 0, 0, 0)

	ServersHoldLayout.Name = "ServersHoldLayout"
	ServersHoldLayout.Parent = ServersHold
	ServersHoldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	ServersHoldLayout.Padding = UDim.new(0, 8)

	ServersHoldPadding.Name = "ServersHoldPadding"
	ServersHoldPadding.Parent = ServersHold
	ServersHoldPadding.PaddingLeft = UDim.new(0, 13)

	-- Кнопки управления окном
	CloseBtn.MouseButton1Click:Connect(function()
		MainFrame:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .25, true)
	end)

	CloseBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Red}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
	end)

	CloseBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Background}):Play()
		TweenService:Create(CloseIcon, TweenInfo.new(.15), {ImageColor3 = Colors.TextMuted}):Play()
	end)

	MinimizeBtn.MouseEnter:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.BackgroundHover}):Play()
		TweenService:Create(MinimizeIcon, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
	end)

	MinimizeBtn.MouseLeave:Connect(function()
		TweenService:Create(MinimizeBtn, TweenInfo.new(.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundColor3 = Colors.Background}):Play()
		TweenService:Create(MinimizeIcon, TweenInfo.new(.15), {ImageColor3 = Colors.TextMuted}):Play()
	end)

	MinimizeBtn.MouseButton1Click:Connect(function()
		if minimized == false then
			MainFrame:TweenSize(UDim2.new(0, 780, 0, 26), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .25, true)
		else
			MainFrame:TweenSize(UDim2.new(0, 780, 0, 500), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .25, true)
		end
		minimized = not minimized
	end)

	-- ============================================================
	-- SETTINGS
	-- ============================================================
	local SettingsOpenBtn = Instance.new("TextButton")
	local SettingsOpenBtnIco = Instance.new("ImageLabel")

	SettingsOpenBtn.Name = "SettingsOpenBtn"
	SettingsOpenBtn.Parent = Userpad
	SettingsOpenBtn.BackgroundTransparency = 1
	SettingsOpenBtn.AnchorPoint = Vector2.new(1, 0.5)
	SettingsOpenBtn.Position = UDim2.new(1, -10, 0.5, 0)
	SettingsOpenBtn.Size = UDim2.new(0, 28, 0, 28)
	SettingsOpenBtn.Text = ""

	local SettingsHoverBg = Instance.new("Frame")
	SettingsHoverBg.Name = "HoverBg"
	SettingsHoverBg.Parent = SettingsOpenBtn
	SettingsHoverBg.AnchorPoint = Vector2.new(0.5, 0.5)
	SettingsHoverBg.BackgroundColor3 = Colors.BackgroundHover
	SettingsHoverBg.BackgroundTransparency = 1
	SettingsHoverBg.Position = UDim2.new(0.5, 0, 0.5, 0)
	SettingsHoverBg.Size = UDim2.new(1, 4, 1, 4)

	local SettingsHoverBgCorner = Instance.new("UICorner")
	SettingsHoverBgCorner.CornerRadius = UDim.new(0, 6)
	SettingsHoverBgCorner.Parent = SettingsHoverBg

	SettingsOpenBtnIco.Name = "SettingsOpenBtnIco"
	SettingsOpenBtnIco.Parent = SettingsOpenBtn
	SettingsOpenBtnIco.BackgroundTransparency = 1
	SettingsOpenBtnIco.AnchorPoint = Vector2.new(0.5, 0.5)
	SettingsOpenBtnIco.Position = UDim2.new(0.5, 0, 0.5, 0)
	SettingsOpenBtnIco.Size = UDim2.new(0, 18, 0, 18)
	SettingsOpenBtnIco.Image = "http://www.roblox.com/asset/?id=6031280882"
	SettingsOpenBtnIco.ImageColor3 = Colors.TextMuted
	SettingsOpenBtnIco.ZIndex = 2

	local SettingsFrame = Instance.new("Frame")
	local Settings = Instance.new("Frame")
	local SettingsHolder = Instance.new("Frame")
	local CloseSettingsBtn = Instance.new("TextButton")
	local CloseSettingsBtnCorner = Instance.new("UICorner")
	local CloseSettingsBtnIcon = Instance.new("ImageLabel")
	local TextLabel = Instance.new("TextLabel")
	local UserPanel = Instance.new("Frame")
	local UserPanelCorner = Instance.new("UICorner")
	local UserSettingsPad = Instance.new("Frame")
	local UserSettingsPadCorner = Instance.new("UICorner")
	local UsernameText = Instance.new("TextLabel")
	local UserSettingsPadUserTag = Instance.new("Frame")
	local UserSettingsPadUser = Instance.new("TextLabel")
	local UserSettingsPadUserTagLayout = Instance.new("UIListLayout")
	local UserSettingsPadTag = Instance.new("TextLabel")
	local EditBtn = Instance.new("TextButton")
	local EditBtnCorner = Instance.new("UICorner")
	local UserPanelUserIcon = Instance.new("TextButton")
	local UserPanelUserIconCorner = Instance.new("UICorner")
	local UserPanelUserImage = Instance.new("ImageLabel")
	local UserPanelUserCircle = Instance.new("ImageLabel")
	local BlackFrame = Instance.new("Frame")
	local BlackFrameCorner = Instance.new("UICorner")
	local ChangeAvatarText = Instance.new("TextLabel")
	local SearchIcoFrame = Instance.new("Frame")
	local SearchIcoFrameCorner = Instance.new("UICorner")
	local SearchIco = Instance.new("ImageLabel")
	local UserPanelUserTag = Instance.new("Frame")
	local UserPanelUser = Instance.new("TextLabel")
	local UserPanelUserTagLayout = Instance.new("UIListLayout")
	local UserPanelTag = Instance.new("TextLabel")
	local LeftFrame = Instance.new("Frame")
	local MyAccountBtn = Instance.new("TextButton")
	local MyAccountBtnCorner = Instance.new("UICorner")
	local MyAccountBtnTitle = Instance.new("TextLabel")
	local SettingsTitle = Instance.new("TextLabel")
	local DiscordInfo = Instance.new("TextLabel")
	local CurrentSettingOpen = Instance.new("TextLabel")

	SettingsFrame.Name = "SettingsFrame"
	SettingsFrame.Parent = MainFrame
	SettingsFrame.BackgroundTransparency = 1
	SettingsFrame.Size = UDim2.new(0, 780, 0, 500)
	SettingsFrame.Visible = false
	SettingsFrame.ZIndex = 5

	Settings.Name = "Settings"
	Settings.Parent = SettingsFrame
	Settings.BackgroundColor3 = Colors.Background
	Settings.BorderSizePixel = 0
	Settings.Position = UDim2.new(0, 0, 0.052, 0)
	Settings.Size = UDim2.new(0, 780, 0, 474)
	Settings.ZIndex = 5

	SettingsHolder.Name = "SettingsHolder"
	SettingsHolder.Parent = Settings
	SettingsHolder.AnchorPoint = Vector2.new(0.5, 0.5)
	SettingsHolder.BackgroundTransparency = 1
	SettingsHolder.ClipsDescendants = true
	SettingsHolder.Position = UDim2.new(0.5, 0, 0.5, 0)
	SettingsHolder.Size = UDim2.new(0, 0, 0, 0)
	SettingsHolder.ZIndex = 6

	CloseSettingsBtn.Name = "CloseSettingsBtn"
	CloseSettingsBtn.Parent = SettingsHolder
	CloseSettingsBtn.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtn.BackgroundColor3 = Colors.BackgroundDark
	CloseSettingsBtn.Position = UDim2.new(0.955, 0, 0.09, 0)
	CloseSettingsBtn.Size = UDim2.new(0, 36, 0, 36)
	CloseSettingsBtn.AutoButtonColor = false
	CloseSettingsBtn.Text = ""
	CloseSettingsBtn.ZIndex = 10

	CloseSettingsBtnCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnCorner.Parent = CloseSettingsBtn

	CloseSettingsBtnIcon.Name = "CloseSettingsBtnIcon"
	CloseSettingsBtnIcon.Parent = CloseSettingsBtn
	CloseSettingsBtnIcon.BackgroundTransparency = 1
	CloseSettingsBtnIcon.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtnIcon.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseSettingsBtnIcon.Size = UDim2.new(0, 18, 0, 18)
	CloseSettingsBtnIcon.Image = "http://www.roblox.com/asset/?id=6035047409"
	CloseSettingsBtnIcon.ImageColor3 = Colors.TextNormal
	CloseSettingsBtnIcon.ZIndex = 11

	local CloseSettingsBtnBorder = Instance.new("Frame")
	CloseSettingsBtnBorder.Name = "Border"
	CloseSettingsBtnBorder.Parent = CloseSettingsBtn
	CloseSettingsBtnBorder.AnchorPoint = Vector2.new(0.5, 0.5)
	CloseSettingsBtnBorder.BackgroundTransparency = 1
	CloseSettingsBtnBorder.Position = UDim2.new(0.5, 0, 0.5, 0)
	CloseSettingsBtnBorder.Size = UDim2.new(1, 4, 1, 4)
	CloseSettingsBtnBorder.ZIndex = 9

	local CloseSettingsBtnBorderStroke = Instance.new("UIStroke")
	CloseSettingsBtnBorderStroke.Color = Colors.Divider
	CloseSettingsBtnBorderStroke.Thickness = 2
	CloseSettingsBtnBorderStroke.Parent = CloseSettingsBtnBorder

	local CloseSettingsBtnBorderCorner = Instance.new("UICorner")
	CloseSettingsBtnBorderCorner.CornerRadius = UDim.new(1, 0)
	CloseSettingsBtnBorderCorner.Parent = CloseSettingsBtnBorder

	local function CloseSettings()
		settingsopened = false
		TopFrameHolder.Visible = true
		ServersHoldFrame.Visible = true
		SettingsHolder:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .25, true)
		TweenService:Create(Settings, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
		for _, v in next, SettingsHolder:GetChildren() do
			if v:IsA("GuiObject") and v.Name ~= "CloseSettingsBtn" then
				TweenService:Create(v, TweenInfo.new(.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 1}):Play()
			end
		end
		task.wait(.25)
		SettingsFrame.Visible = false
	end

	CloseSettingsBtn.MouseButton1Click:Connect(CloseSettings)

	CloseSettingsBtn.MouseEnter:Connect(function()
		TweenService:Create(CloseSettingsBtnIcon, TweenInfo.new(.15), {ImageColor3 = Colors.Red}):Play()
	end)

	CloseSettingsBtn.MouseLeave:Connect(function()
		TweenService:Create(CloseSettingsBtnIcon, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
	end)

	UserInputService.InputBegan:Connect(function(io, p)
		if io.KeyCode == Enum.KeyCode.RightControl and settingsopened == true then
			CloseSettings()
		end
	end)

	TextLabel.Parent = CloseSettingsBtn
	TextLabel.BackgroundTransparency = 1
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.Position = UDim2.new(0.5, 0, 1.6, 0)
	TextLabel.Size = UDim2.new(0, 80, 0, 18)
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.Text = "rightctrl"
	TextLabel.TextColor3 = Colors.TextMuted
	TextLabel.TextSize = 11
	TextLabel.ZIndex = 11

	-- ============================================================
	-- USER PANEL (в настройках)
	-- ============================================================
	UserPanel.Name = "UserPanel"
	UserPanel.Parent = SettingsHolder
	UserPanel.BackgroundColor3 = Colors.BackgroundAlt
	UserPanel.Position = UDim2.new(0.36, 0, 0.13, 0)
	UserPanel.Size = UDim2.new(0, 420, 0, 200)
	UserPanel.ZIndex = 7

	UserPanelCorner.CornerRadius = UDim.new(0, 8)
	UserPanelCorner.Parent = UserPanel

	local UserPanelBanner = Instance.new("Frame")
	UserPanelBanner.Name = "Banner"
	UserPanelBanner.Parent = UserPanel
	UserPanelBanner.BackgroundColor3 = Colors.Blurple
	UserPanelBanner.BorderSizePixel = 0
	UserPanelBanner.Size = UDim2.new(1, 0, 0, 60)
	UserPanelBanner.ZIndex = 7

	local UserPanelBannerCorner = Instance.new("UICorner")
	UserPanelBannerCorner.CornerRadius = UDim.new(0, 8)
	UserPanelBannerCorner.Parent = UserPanelBanner

	local UserPanelBannerBottom = Instance.new("Frame")
	UserPanelBannerBottom.Parent = UserPanelBanner
	UserPanelBannerBottom.AnchorPoint = Vector2.new(0.5, 1)
	UserPanelBannerBottom.BackgroundColor3 = Colors.Blurple
	UserPanelBannerBottom.BorderSizePixel = 0
	UserPanelBannerBottom.Position = UDim2.new(0.5, 0, 1, 0)
	UserPanelBannerBottom.Size = UDim2.new(1, 0, 0, 8)
	UserPanelBannerBottom.ZIndex = 7

	UserPanelUserIcon.Name = "UserPanelUserIcon"
	UserPanelUserIcon.Parent = UserPanel
	UserPanelUserIcon.BackgroundColor3 = Colors.BackgroundDark
	UserPanelUserIcon.BorderSizePixel = 0
	UserPanelUserIcon.Position = UDim2.new(0.04, 0, 0.13, 0)
	UserPanelUserIcon.Size = UDim2.new(0, 80, 0, 80)
	UserPanelUserIcon.AutoButtonColor = false
	UserPanelUserIcon.Text = ""
	UserPanelUserIcon.ZIndex = 9

	UserPanelUserIconCorner.CornerRadius = UDim.new(1, 0)
	UserPanelUserIconCorner.Parent = UserPanelUserIcon

	local IconOutline = Instance.new("Frame")
	IconOutline.Name = "Outline"
	IconOutline.Parent = UserPanelUserIcon
	IconOutline.AnchorPoint = Vector2.new(0.5, 0.5)
	IconOutline.BackgroundColor3 = Colors.BackgroundAlt
	IconOutline.BorderSizePixel = 0
	IconOutline.Position = UDim2.new(0.5, 0, 0.5, 0)
	IconOutline.Size = UDim2.new(1, 6, 1, 6)
	IconOutline.ZIndex = 8

	local IconOutlineCorner = Instance.new("UICorner")
	IconOutlineCorner.CornerRadius = UDim.new(1, 0)
	IconOutlineCorner.Parent = IconOutline

	UserPanelUserImage.Name = "UserPanelUserImage"
	UserPanelUserImage.Parent = UserPanelUserIcon
	UserPanelUserImage.BackgroundTransparency = 1
	UserPanelUserImage.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserImage.Image = pfp
	UserPanelUserImage.ZIndex = 10

	UserPanelUserCircle.Name = "UserPanelUserCircle"
	UserPanelUserCircle.Parent = UserPanelUserImage
	UserPanelUserCircle.BackgroundTransparency = 1
	UserPanelUserCircle.Size = UDim2.new(1, 0, 1, 0)
	UserPanelUserCircle.Image = "rbxassetid://4031889928"
	UserPanelUserCircle.ImageColor3 = Colors.BackgroundDark
	UserPanelUserCircle.ZIndex = 11

	BlackFrame.Name = "BlackFrame"
	BlackFrame.Parent = UserPanelUserIcon
	BlackFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	BlackFrame.BackgroundTransparency = 0.5
	BlackFrame.BorderSizePixel = 0
	BlackFrame.Size = UDim2.new(1, 0, 1, 0)
	BlackFrame.Visible = false
	BlackFrame.ZIndex = 12

	BlackFrameCorner.CornerRadius = UDim.new(1, 0)
	BlackFrameCorner.Parent = BlackFrame

	ChangeAvatarText.Name = "ChangeAvatarText"
	ChangeAvatarText.Parent = BlackFrame
	ChangeAvatarText.BackgroundTransparency = 1
	ChangeAvatarText.Size = UDim2.new(1, 0, 1, 0)
	ChangeAvatarText.Font = Enum.Font.GothamBold
	ChangeAvatarText.Text = "СМЕНИТЬ\nАВАТАР"
	ChangeAvatarText.TextColor3 = Colors.TextNormal
	ChangeAvatarText.TextSize = 11
	ChangeAvatarText.TextWrapped = true
	ChangeAvatarText.ZIndex = 13

	SearchIcoFrame.Name = "SearchIcoFrame"
	SearchIcoFrame.Parent = UserPanelUserIcon
	SearchIcoFrame.BackgroundColor3 = Colors.BackgroundDark
	SearchIcoFrame.Position = UDim2.new(0.72, 0, 0.72, 0)
	SearchIcoFrame.Size = UDim2.new(0, 22, 0, 22)
	SearchIcoFrame.ZIndex = 13

	SearchIcoFrameCorner.CornerRadius = UDim.new(1, 0)
	SearchIcoFrameCorner.Parent = SearchIcoFrame

	SearchIco.Name = "SearchIco"
	SearchIco.Parent = SearchIcoFrame
	SearchIco.BackgroundTransparency = 1
	SearchIco.AnchorPoint = Vector2.new(0.5, 0.5)
	SearchIco.Position = UDim2.new(0.5, 0, 0.5, 0)
	SearchIco.Size = UDim2.new(0, 14, 0, 14)
	SearchIco.Image = "http://www.roblox.com/asset/?id=6034407084"
	SearchIco.ImageColor3 = Colors.TextMuted
	SearchIco.ZIndex = 14

	-- Ник и тег
	UserPanelUserTag.Name = "UserPanelUserTag"
	UserPanelUserTag.Parent = UserPanel
	UserPanelUserTag.BackgroundTransparency = 1
	UserPanelUserTag.Position = UDim2.new(0.27, 0, 0.4, 0)
	UserPanelUserTag.Size = UDim2.new(0, 200, 0, 22)

	UserPanelUser.Name = "UserPanelUser"
	UserPanelUser.Parent = UserPanelUserTag
	UserPanelUser.BackgroundTransparency = 1
	UserPanelUser.Font = Enum.Font.GothamBold
	UserPanelUser.TextColor3 = Colors.TextNormal
	UserPanelUser.TextSize = 18
	UserPanelUser.TextXAlignment = Enum.TextXAlignment.Left
	UserPanelUser.Text = user
	UserPanelUser.Size = UDim2.new(0, UserPanelUser.TextBounds.X + 4, 0, 22)
	UserPanelUser.ZIndex = 9

	UserPanelUserTagLayout.Name = "UserPanelUserTagLayout"
	UserPanelUserTagLayout.Parent = UserPanelUserTag
	UserPanelUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
	UserPanelUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UserPanelTag.Name = "UserPanelTag"
	UserPanelTag.Parent = UserPanelUserTag
	UserPanelTag.BackgroundTransparency = 1
	UserPanelTag.Font = Enum.Font.Gotham
	UserPanelTag.Text = "#" .. tag
	UserPanelTag.TextColor3 = Colors.TextMuted
	UserPanelTag.TextSize = 18
	UserPanelTag.TextXAlignment = Enum.TextXAlignment.Left
	UserPanelTag.Size = UDim2.new(0, 100, 0, 22)
	UserPanelTag.ZIndex = 9

	-- Панель с юзернеймом и кнопкой
	UserSettingsPad.Name = "UserSettingsPad"
	UserSettingsPad.Parent = UserPanel
	UserSettingsPad.BackgroundColor3 = Colors.BackgroundDark
	UserSettingsPad.Position = UDim2.new(0.035, 0, 0.62, 0)
	UserSettingsPad.Size = UDim2.new(0, 390, 0, 62)
	UserSettingsPad.ZIndex = 8

	UserSettingsPadCorner.CornerRadius = UDim.new(0, 6)
	UserSettingsPadCorner.Parent = UserSettingsPad

	UsernameText.Name = "UsernameText"
	UsernameText.Parent = UserSettingsPad
	UsernameText.BackgroundTransparency = 1
	UsernameText.Position = UDim2.new(0.04, 0, 0.12, 0)
	UsernameText.Size = UDim2.new(0, 200, 0, 14)
	UsernameText.Font = Enum.Font.GothamBold
	UsernameText.Text = "USERNAME"
	UsernameText.TextColor3 = Colors.TextMuted
	UsernameText.TextSize = 10
	UsernameText.TextXAlignment = Enum.TextXAlignment.Left
	UsernameText.ZIndex = 9

	UserSettingsPadUserTag.Name = "UserSettingsPadUserTag"
	UserSettingsPadUserTag.Parent = UserSettingsPad
	UserSettingsPadUserTag.BackgroundTransparency = 1
	UserSettingsPadUserTag.Position = UDim2.new(0.04, 0, 0.44, 0)
	UserSettingsPadUserTag.Size = UDim2.new(0, 200, 0, 20)
	UserSettingsPadUserTag.ZIndex = 9

	UserSettingsPadUser.Name = "UserSettingsPadUser"
	UserSettingsPadUser.Parent = UserSettingsPadUserTag
	UserSettingsPadUser.BackgroundTransparency = 1
	UserSettingsPadUser.Font = Enum.Font.GothamMedium
	UserSettingsPadUser.TextColor3 = Colors.TextNormal
	UserSettingsPadUser.TextSize = 14
	UserSettingsPadUser.TextXAlignment = Enum.TextXAlignment.Left
	UserSettingsPadUser.Text = user
	UserSettingsPadUser.Size = UDim2.new(0, UserSettingsPadUser.TextBounds.X + 2, 0, 20)
	UserSettingsPadUser.ZIndex = 9

	UserSettingsPadUserTagLayout.Name = "UserSettingsPadUserTagLayout"
	UserSettingsPadUserTagLayout.Parent = UserSettingsPadUserTag
	UserSettingsPadUserTagLayout.FillDirection = Enum.FillDirection.Horizontal
	UserSettingsPadUserTagLayout.SortOrder = Enum.SortOrder.LayoutOrder

	UserSettingsPadTag.Name = "UserSettingsPadTag"
	UserSettingsPadTag.Parent = UserSettingsPadUserTag
	UserSettingsPadTag.BackgroundTransparency = 1
	UserSettingsPadTag.Font = Enum.Font.Gotham
	UserSettingsPadTag.Text = "#" .. tag
	UserSettingsPadTag.TextColor3 = Colors.TextMuted
	UserSettingsPadTag.TextSize = 14
	UserSettingsPadTag.TextXAlignment = Enum.TextXAlignment.Left
	UserSettingsPadTag.Size = UDim2.new(0, 100, 0, 20)
	UserSettingsPadTag.ZIndex = 9

	EditBtn.Name = "EditBtn"
	EditBtn.Parent = UserSettingsPad
	EditBtn.AnchorPoint = Vector2.new(1, 0.5)
	EditBtn.BackgroundColor3 = Colors.Blurple
	EditBtn.Position = UDim2.new(1, -10, 0.5, 0)
	EditBtn.Size = UDim2.new(0, 60, 0, 32)
	EditBtn.Font = Enum.Font.GothamMedium
	EditBtn.Text = "Edit"
	EditBtn.TextColor3 = Colors.TextNormal
	EditBtn.TextSize = 13
	EditBtn.AutoButtonColor = false
	EditBtn.ZIndex = 10

	EditBtnCorner.CornerRadius = UDim.new(0, 4)
	EditBtnCorner.Parent = EditBtn

	EditBtn.MouseEnter:Connect(function()
		TweenService:Create(EditBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BlurpleHover}):Play()
	end)

	EditBtn.MouseLeave:Connect(function()
		TweenService:Create(EditBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
	end)

	UserPanelUserIcon.MouseEnter:Connect(function()
		BlackFrame.Visible = true
	end)

	UserPanelUserIcon.MouseLeave:Connect(function()
		BlackFrame.Visible = false
	end)

	-- ============================================================
	-- AVATAR CHANGE MODAL
	-- ============================================================
	UserPanelUserIcon.MouseButton1Click:Connect(function()
		local NotificationHolder = Instance.new("TextButton")
		NotificationHolder.Name = "NotificationHolder"
		NotificationHolder.Parent = SettingsHolder
		NotificationHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotificationHolder.Position = UDim2.new(-0.0088, 0, -0.0026, 0)
		NotificationHolder.Size = UDim2.new(0, 787, 0, 474)
		NotificationHolder.AutoButtonColor = false
		NotificationHolder.Text = ""
		NotificationHolder.BackgroundTransparency = 1
		NotificationHolder.ZIndex = 20
		TweenService:Create(NotificationHolder, TweenInfo.new(.2), {BackgroundTransparency = 0.4}):Play()

		local AvatarChange = Instance.new("Frame")
		local UserChangeCorner = Instance.new("UICorner")
		local UnderBar = Instance.new("Frame")
		local UnderBarCorner = Instance.new("UICorner")
		local Text1 = Instance.new("TextLabel")
		local Text2 = Instance.new("TextLabel")
		local TextBoxFrame = Instance.new("Frame")
		local TextBoxFrameCorner = Instance.new("UICorner")
		local AvatarTextbox = Instance.new("TextBox")
		local ChangeBtn = Instance.new("TextButton")
		local ChangeCorner = Instance.new("UICorner")
		local CloseBtn2 = Instance.new("TextButton")
		local Close2Icon = Instance.new("ImageLabel")
		local CloseBtn1 = Instance.new("TextButton")
		local CloseBtn1Corner = Instance.new("UICorner")
		local ResetBtn = Instance.new("TextButton")
		local ResetCorner = Instance.new("UICorner")

		AvatarChange.Name = "AvatarChange"
		AvatarChange.Parent = NotificationHolder
		AvatarChange.AnchorPoint = Vector2.new(0.5, 0.5)
		AvatarChange.BackgroundColor3 = Colors.BackgroundAlt
		AvatarChange.ClipsDescendants = true
		AvatarChange.Position = UDim2.new(0.5, 0, 0.5, 0)
		AvatarChange.Size = UDim2.new(0, 0, 0, 0)
		AvatarChange.BackgroundTransparency = 1
		AvatarChange.ZIndex = 21

		AvatarChange:TweenSize(UDim2.new(0, 400, 0, 220), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
		TweenService:Create(AvatarChange, TweenInfo.new(.3), {BackgroundTransparency = 0}):Play()

		UserChangeCorner.CornerRadius = UDim.new(0, 10)
		UserChangeCorner.Parent = AvatarChange

		UnderBar.Name = "UnderBar"
		UnderBar.Parent = AvatarChange
		UnderBar.BackgroundColor3 = Colors.BackgroundDark
		UnderBar.Position = UDim2.new(0, 0, 1, -16)
		UnderBar.Size = UDim2.new(1, 0, 0, 16)
		UnderBar.ZIndex = 21

		UnderBarCorner.CornerRadius = UDim.new(0, 10)
		UnderBarCorner.Parent = UnderBar

		Text1.Name = "Text1"
		Text1.Parent = AvatarChange
		Text1.BackgroundTransparency = 1
		Text1.Position = UDim2.new(0.05, 0, 0.05, 0)
		Text1.Size = UDim2.new(0, 350, 0, 26)
		Text1.Font = Enum.Font.GothamBold
		Text1.Text = "Изменить аватар"
		Text1.TextColor3 = Colors.TextNormal
		Text1.TextSize = 18
		Text1.TextXAlignment = Enum.TextXAlignment.Left
		Text1.ZIndex = 22

		Text2.Name = "Text2"
		Text2.Parent = AvatarChange
		Text2.BackgroundTransparency = 1
		Text2.Position = UDim2.new(0.05, 0, 0.18, 0)
		Text2.Size = UDim2.new(0, 350, 0, 20)
		Text2.Font = Enum.Font.Gotham
		Text2.Text = "Вставьте ссылку на Roblox decal."
		Text2.TextColor3 = Colors.TextMuted
		Text2.TextSize = 13
		Text2.TextXAlignment = Enum.TextXAlignment.Left
		Text2.ZIndex = 22

		TextBoxFrame.Name = "TextBoxFrame"
		TextBoxFrame.Parent = AvatarChange
		TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame.BackgroundColor3 = Colors.Blurple
		TextBoxFrame.Position = UDim2.new(0.5, 0, 0.52, 0)
		TextBoxFrame.Size = UDim2.new(0, 360, 0, 40)
		TextBoxFrame.ZIndex = 22

		TextBoxFrameCorner.CornerRadius = UDim.new(0, 6)
		TextBoxFrameCorner.Parent = TextBoxFrame

		local TextBoxFrame1 = Instance.new("Frame")
		TextBoxFrame1.Name = "TextBoxFrame1"
		TextBoxFrame1.Parent = TextBoxFrame
		TextBoxFrame1.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame1.BackgroundColor3 = Colors.InputBackground
		TextBoxFrame1.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBoxFrame1.Size = UDim2.new(1, -4, 1, -4)
		TextBoxFrame1.ZIndex = 23

		local TextBoxFrame1Corner = Instance.new("UICorner")
		TextBoxFrame1Corner.CornerRadius = UDim.new(0, 5)
		TextBoxFrame1Corner.Parent = TextBoxFrame1

		AvatarTextbox.Name = "AvatarTextbox"
		AvatarTextbox.Parent = TextBoxFrame1
		AvatarTextbox.BackgroundTransparency = 1
		AvatarTextbox.Position = UDim2.new(0.03, 0, 0, 0)
		AvatarTextbox.Size = UDim2.new(0, 340, 0, 36)
		AvatarTextbox.Font = Enum.Font.Gotham
		AvatarTextbox.Text = ""
		AvatarTextbox.PlaceholderText = "https://..."
		AvatarTextbox.PlaceholderColor3 = Colors.TextMuted
		AvatarTextbox.TextColor3 = Colors.TextNormal
		AvatarTextbox.TextSize = 13
		AvatarTextbox.TextXAlignment = Enum.TextXAlignment.Left
		AvatarTextbox.ZIndex = 24

		ChangeBtn.Name = "ChangeBtn"
		ChangeBtn.Parent = AvatarChange
		ChangeBtn.BackgroundColor3 = Colors.Blurple
		ChangeBtn.AnchorPoint = Vector2.new(1, 0)
		ChangeBtn.Position = UDim2.new(0.95, 0, 0.78, 0)
		ChangeBtn.Size = UDim2.new(0, 90, 0, 32)
		ChangeBtn.Font = Enum.Font.GothamMedium
		ChangeBtn.Text = "Изменить"
		ChangeBtn.TextColor3 = Colors.TextNormal
		ChangeBtn.TextSize = 13
		ChangeBtn.AutoButtonColor = false
		ChangeBtn.ZIndex = 22

		ChangeBtn.MouseEnter:Connect(function()
			TweenService:Create(ChangeBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BlurpleHover}):Play()
		end)

		ChangeBtn.MouseLeave:Connect(function()
			TweenService:Create(ChangeBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
		end)

		ChangeCorner.CornerRadius = UDim.new(0, 4)
		ChangeCorner.Parent = ChangeBtn

		CloseBtn2.Name = "CloseBtn2"
		CloseBtn2.Parent = AvatarChange
		CloseBtn2.BackgroundTransparency = 1
		CloseBtn2.Position = UDim2.new(0.91, 0, 0.04, 0)
		CloseBtn2.Size = UDim2.new(0, 26, 0, 26)
		CloseBtn2.Text = ""
		CloseBtn2.ZIndex = 22

		Close2Icon.Name = "Close2Icon"
		Close2Icon.Parent = CloseBtn2
		Close2Icon.BackgroundTransparency = 1
		Close2Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Close2Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Close2Icon.Size = UDim2.new(0, 18, 0, 18)
		Close2Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
		Close2Icon.ImageColor3 = Colors.TextMuted
		Close2Icon.ZIndex = 23

		CloseBtn1.Name = "CloseBtn1"
		CloseBtn1.Parent = AvatarChange
		CloseBtn1.BackgroundColor3 = Colors.BackgroundHover
		CloseBtn1.AnchorPoint = Vector2.new(1, 0)
		CloseBtn1.Position = UDim2.new(0.95, -100, 0.78, 0)
		CloseBtn1.Size = UDim2.new(0, 90, 0, 32)
		CloseBtn1.Font = Enum.Font.GothamMedium
		CloseBtn1.Text = "Отмена"
		CloseBtn1.TextColor3 = Colors.TextNormal
		CloseBtn1.TextSize = 13
		CloseBtn1.AutoButtonColor = false
		CloseBtn1.ZIndex = 22

		CloseBtn1.MouseEnter:Connect(function()
			TweenService:Create(CloseBtn1, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundActive}):Play()
		end)

		CloseBtn1.MouseLeave:Connect(function()
			TweenService:Create(CloseBtn1, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundHover}):Play()
		end)

		CloseBtn1Corner.CornerRadius = UDim.new(0, 4)
		CloseBtn1Corner.Parent = CloseBtn1

		ResetBtn.Name = "ResetBtn"
		ResetBtn.Parent = AvatarChange
		ResetBtn.BackgroundColor3 = Colors.BackgroundHover
		ResetBtn.AnchorPoint = Vector2.new(1, 0)
		ResetBtn.Position = UDim2.new(0.95, -200, 0.78, 0)
		ResetBtn.Size = UDim2.new(0, 90, 0, 32)
		ResetBtn.Font = Enum.Font.GothamMedium
		ResetBtn.Text = "Сброс"
		ResetBtn.TextColor3 = Colors.TextNormal
		ResetBtn.TextSize = 13
		ResetBtn.AutoButtonColor = false
		ResetBtn.ZIndex = 22

		ResetBtn.MouseEnter:Connect(function()
			TweenService:Create(ResetBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundActive}):Play()
		end)

		ResetBtn.MouseLeave:Connect(function()
			TweenService:Create(ResetBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundHover}):Play()
		end)

		ResetCorner.CornerRadius = UDim.new(0, 4)
		ResetCorner.Parent = ResetBtn

		local function CloseAvatarModal()
			AvatarChange:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(AvatarChange, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(NotificationHolder, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
			task.wait(.2)
			NotificationHolder:Destroy()
		end

		ChangeBtn.MouseButton1Click:Connect(function()
			pfp = tostring(AvatarTextbox.Text)
			UserImage.Image = pfp
			UserPanelUserImage.Image = pfp
			SaveInfo()
			CloseAvatarModal()
		end)

		ResetBtn.MouseButton1Click:Connect(function()
			pfp = "https://www.roblox.com/headshot-thumbnail/image?userId=" .. game.Players.LocalPlayer.UserId .. "&width=420&height=420&format=png"
			UserImage.Image = pfp
			UserPanelUserImage.Image = pfp
			SaveInfo()
			CloseAvatarModal()
		end)

		CloseBtn1.MouseButton1Click:Connect(CloseAvatarModal)
		CloseBtn2.MouseButton1Click:Connect(CloseAvatarModal)

		CloseBtn2.MouseEnter:Connect(function()
			TweenService:Create(Close2Icon, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
		end)

		CloseBtn2.MouseLeave:Connect(function()
			TweenService:Create(Close2Icon, TweenInfo.new(.15), {ImageColor3 = Colors.TextMuted}):Play()
		end)

		AvatarTextbox.Focused:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
		end)

		AvatarTextbox.FocusLost:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Colors.Blurple}):Play()
		end)
	end)

	-- ============================================================
	-- SETTINGS LEFT PANEL
	-- ============================================================
	LeftFrame.Name = "LeftFrame"
	LeftFrame.Parent = SettingsHolder
	LeftFrame.BackgroundColor3 = Colors.BackgroundDark
	LeftFrame.BorderSizePixel = 0
	LeftFrame.Position = UDim2.new(0, 0, 0, 0)
	LeftFrame.Size = UDim2.new(0, 260, 0, 474)
	LeftFrame.ZIndex = 7

	MyAccountBtn.Name = "MyAccountBtn"
	MyAccountBtn.Parent = LeftFrame
	MyAccountBtn.BackgroundColor3 = Colors.BackgroundActive
	MyAccountBtn.BorderSizePixel = 0
	MyAccountBtn.Position = UDim2.new(0.04, 0, 0.12, 0)
	MyAccountBtn.Size = UDim2.new(0, 240, 0, 36)
	MyAccountBtn.AutoButtonColor = false
	MyAccountBtn.Text = ""
	MyAccountBtn.ZIndex = 8

	MyAccountBtnCorner.CornerRadius = UDim.new(0, 6)
	MyAccountBtnCorner.Parent = MyAccountBtn

	MyAccountBtnTitle.Name = "MyAccountBtnTitle"
	MyAccountBtnTitle.Parent = MyAccountBtn
	MyAccountBtnTitle.BackgroundTransparency = 1
	MyAccountBtnTitle.Position = UDim2.new(0.06, 0, 0, 0)
	MyAccountBtnTitle.Size = UDim2.new(0, 200, 0, 36)
	MyAccountBtnTitle.Font = Enum.Font.GothamMedium
	MyAccountBtnTitle.Text = "Мой аккаунт"
	MyAccountBtnTitle.TextColor3 = Colors.TextNormal
	MyAccountBtnTitle.TextSize = 14
	MyAccountBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
	MyAccountBtnTitle.ZIndex = 9

	SettingsTitle.Name = "SettingsTitle"
	SettingsTitle.Parent = LeftFrame
	SettingsTitle.BackgroundTransparency = 1
	SettingsTitle.Position = UDim2.new(0.06, 0, 0.03, 0)
	SettingsTitle.Size = UDim2.new(0, 200, 0, 20)
	SettingsTitle.Font = Enum.Font.GothamBold
	SettingsTitle.Text = "НАСТРОЙКИ"
	SettingsTitle.TextColor3 = Colors.TextMuted
	SettingsTitle.TextSize = 11
	SettingsTitle.TextXAlignment = Enum.TextXAlignment.Left
	SettingsTitle.ZIndex = 8

	DiscordInfo.Name = "DiscordInfo"
	DiscordInfo.Parent = LeftFrame
	DiscordInfo.BackgroundTransparency = 1
	DiscordInfo.Position = UDim2.new(0.06, 0, 0.87, 0)
	DiscordInfo.Size = UDim2.new(0, 220, 0, 50)
	DiscordInfo.Font = Enum.Font.Gotham
	DiscordInfo.Text = "Stable 2.0.0 (00001)\nHost 0.0.0.1\nRoblox Lua Engine"
	DiscordInfo.TextColor3 = Colors.TextMuted
	DiscordInfo.TextSize = 11
	DiscordInfo.TextWrapped = true
	DiscordInfo.TextXAlignment = Enum.TextXAlignment.Left
	DiscordInfo.TextYAlignment = Enum.TextYAlignment.Top
	DiscordInfo.ZIndex = 8

	SettingsOpenBtn.MouseButton1Click:Connect(function()
		settingsopened = true
		TopFrameHolder.Visible = false
		ServersHoldFrame.Visible = false
		SettingsFrame.Visible = true
		SettingsHolder:TweenSize(UDim2.new(0, 780, 0, 474), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .25, true)
		Settings.BackgroundTransparency = 1
		TweenService:Create(Settings, TweenInfo.new(.25), {BackgroundTransparency = 0}):Play()
		for _, v in next, SettingsHolder:GetChildren() do
			if v:IsA("GuiObject") and v.ClassType ~= "TextButton" then
				v.BackgroundTransparency = 1
				TweenService:Create(v, TweenInfo.new(.25), {BackgroundTransparency = 0}):Play()
			end
		end
	end)

	SettingsOpenBtn.MouseEnter:Connect(function()
		TweenService:Create(SettingsHoverBg, TweenInfo.new(.15), {BackgroundTransparency = 0}):Play()
		TweenService:Create(SettingsOpenBtnIco, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
	end)

	SettingsOpenBtn.MouseLeave:Connect(function()
		TweenService:Create(SettingsHoverBg, TweenInfo.new(.15), {BackgroundTransparency = 1}):Play()
		TweenService:Create(SettingsOpenBtnIco, TweenInfo.new(.15), {ImageColor3 = Colors.TextMuted}):Play()
	end)

	-- ============================================================
	-- EDIT USER MODAL
	-- ============================================================
	EditBtn.MouseButton1Click:Connect(function()
		local NotificationHolder = Instance.new("TextButton")
		NotificationHolder.Name = "NotificationHolder"
		NotificationHolder.Parent = SettingsHolder
		NotificationHolder.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotificationHolder.Position = UDim2.new(-0.0088, 0, -0.0026, 0)
		NotificationHolder.Size = UDim2.new(0, 787, 0, 474)
		NotificationHolder.AutoButtonColor = false
		NotificationHolder.Text = ""
		NotificationHolder.BackgroundTransparency = 1
		NotificationHolder.ZIndex = 20
		TweenService:Create(NotificationHolder, TweenInfo.new(.2), {BackgroundTransparency = 0.4}):Play()

		local UserChange = Instance.new("Frame")
		local UserChangeCorner = Instance.new("UICorner")
		local UnderBar = Instance.new("Frame")
		local UnderBarCorner = Instance.new("UICorner")
		local Text1 = Instance.new("TextLabel")
		local Text2 = Instance.new("TextLabel")
		local TextBoxFrame = Instance.new("Frame")
		local TextBoxFrameCorner = Instance.new("UICorner")
		local TextBoxFrame1 = Instance.new("Frame")
		local TextBoxFrame1Corner = Instance.new("UICorner")
		local UsernameTextbox = Instance.new("TextBox")
		local Seperator = Instance.new("Frame")
		local HashtagLabel = Instance.new("TextLabel")
		local TagTextbox = Instance.new("TextBox")
		local ChangeBtn = Instance.new("TextButton")
		local ChangeCorner = Instance.new("UICorner")
		local CloseBtn2 = Instance.new("TextButton")
		local Close2Icon = Instance.new("ImageLabel")
		local CloseBtn1 = Instance.new("TextButton")
		local CloseBtn1Corner = Instance.new("UICorner")

		UserChange.Name = "UserChange"
		UserChange.Parent = NotificationHolder
		UserChange.AnchorPoint = Vector2.new(0.5, 0.5)
		UserChange.BackgroundColor3 = Colors.BackgroundAlt
		UserChange.ClipsDescendants = true
		UserChange.Position = UDim2.new(0.5, 0, 0.5, 0)
		UserChange.Size = UDim2.new(0, 0, 0, 0)
		UserChange.BackgroundTransparency = 1
		UserChange.ZIndex = 21

		UserChange:TweenSize(UDim2.new(0, 400, 0, 220), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
		TweenService:Create(UserChange, TweenInfo.new(.3), {BackgroundTransparency = 0}):Play()

		UserChangeCorner.CornerRadius = UDim.new(0, 10)
		UserChangeCorner.Parent = UserChange

		UnderBar.Name = "UnderBar"
		UnderBar.Parent = UserChange
		UnderBar.BackgroundColor3 = Colors.BackgroundDark
		UnderBar.Position = UDim2.new(0, 0, 1, -16)
		UnderBar.Size = UDim2.new(1, 0, 0, 16)
		UnderBar.ZIndex = 21

		UnderBarCorner.CornerRadius = UDim.new(0, 10)
		UnderBarCorner.Parent = UnderBar

		Text1.Name = "Text1"
		Text1.Parent = UserChange
		Text1.BackgroundTransparency = 1
		Text1.Position = UDim2.new(0.05, 0, 0.05, 0)
		Text1.Size = UDim2.new(0, 350, 0, 26)
		Text1.Font = Enum.Font.GothamBold
		Text1.Text = "Изменить имя пользователя"
		Text1.TextColor3 = Colors.TextNormal
		Text1.TextSize = 18
		Text1.TextXAlignment = Enum.TextXAlignment.Left
		Text1.ZIndex = 22

		Text2.Name = "Text2"
		Text2.Parent = UserChange
		Text2.BackgroundTransparency = 1
		Text2.Position = UDim2.new(0.05, 0, 0.18, 0)
		Text2.Size = UDim2.new(0, 350, 0, 20)
		Text2.Font = Enum.Font.Gotham
		Text2.Text = "Введите новое имя и тег."
		Text2.TextColor3 = Colors.TextMuted
		Text2.TextSize = 13
		Text2.TextXAlignment = Enum.TextXAlignment.Left
		Text2.ZIndex = 22

		TextBoxFrame.Name = "TextBoxFrame"
		TextBoxFrame.Parent = UserChange
		TextBoxFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame.BackgroundColor3 = Colors.Blurple
		TextBoxFrame.Position = UDim2.new(0.5, 0, 0.52, 0)
		TextBoxFrame.Size = UDim2.new(0, 360, 0, 40)
		TextBoxFrame.ZIndex = 22

		TextBoxFrameCorner.CornerRadius = UDim.new(0, 6)
		TextBoxFrameCorner.Parent = TextBoxFrame

		TextBoxFrame1.Name = "TextBoxFrame1"
		TextBoxFrame1.Parent = TextBoxFrame
		TextBoxFrame1.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBoxFrame1.BackgroundColor3 = Colors.InputBackground
		TextBoxFrame1.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBoxFrame1.Size = UDim2.new(1, -4, 1, -4)
		TextBoxFrame1.ZIndex = 23

		TextBoxFrame1Corner.CornerRadius = UDim.new(0, 5)
		TextBoxFrame1Corner.Parent = TextBoxFrame1

		UsernameTextbox.Name = "UsernameTextbox"
		UsernameTextbox.Parent = TextBoxFrame1
		UsernameTextbox.BackgroundTransparency = 1
		UsernameTextbox.Position = UDim2.new(0.03, 0, 0, 0)
		UsernameTextbox.Size = UDim2.new(0, 230, 0, 36)
		UsernameTextbox.Font = Enum.Font.Gotham
		UsernameTextbox.Text = user
		UsernameTextbox.TextColor3 = Colors.TextNormal
		UsernameTextbox.TextSize = 13
		UsernameTextbox.TextXAlignment = Enum.TextXAlignment.Left
		UsernameTextbox.ZIndex = 24

		Seperator.Name = "Seperator"
		Seperator.Parent = TextBoxFrame1
		Seperator.AnchorPoint = Vector2.new(0.5, 0.5)
		Seperator.BackgroundColor3 = Colors.Divider
		Seperator.BorderSizePixel = 0
		Seperator.Position = UDim2.new(0.75, 0, 0.5, 0)
		Seperator.Size = UDim2.new(0, 1, 0, 24)
		Seperator.ZIndex = 24

		HashtagLabel.Name = "HashtagLabel"
		HashtagLabel.Parent = TextBoxFrame1
		HashtagLabel.BackgroundTransparency = 1
		HashtagLabel.Position = UDim2.new(0.78, 0, 0, 0)
		HashtagLabel.Size = UDim2.new(0, 20, 0, 36)
		HashtagLabel.Font = Enum.Font.Gotham
		HashtagLabel.Text = "#"
		HashtagLabel.TextColor3 = Colors.TextMuted
		HashtagLabel.TextSize = 14
		HashtagLabel.ZIndex = 24

		TagTextbox.Name = "TagTextbox"
		TagTextbox.Parent = TextBoxFrame1
		TagTextbox.BackgroundTransparency = 1
		TagTextbox.Position = UDim2.new(0.83, 0, 0, 0)
		TagTextbox.Size = UDim2.new(0, 60, 0, 36)
		TagTextbox.Font = Enum.Font.Gotham
		TagTextbox.Text = tag
		TagTextbox.TextColor3 = Colors.TextNormal
		TagTextbox.TextSize = 13
		TagTextbox.TextXAlignment = Enum.TextXAlignment.Left
		TagTextbox.ZIndex = 24

		ChangeBtn.Name = "ChangeBtn"
		ChangeBtn.Parent = UserChange
		ChangeBtn.BackgroundColor3 = Colors.Blurple
		ChangeBtn.AnchorPoint = Vector2.new(1, 0)
		ChangeBtn.Position = UDim2.new(0.95, 0, 0.78, 0)
		ChangeBtn.Size = UDim2.new(0, 90, 0, 32)
		ChangeBtn.Font = Enum.Font.GothamMedium
		ChangeBtn.Text = "Изменить"
		ChangeBtn.TextColor3 = Colors.TextNormal
		ChangeBtn.TextSize = 13
		ChangeBtn.AutoButtonColor = false
		ChangeBtn.ZIndex = 22

		ChangeBtn.MouseEnter:Connect(function()
			TweenService:Create(ChangeBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BlurpleHover}):Play()
		end)

		ChangeBtn.MouseLeave:Connect(function()
			TweenService:Create(ChangeBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
		end)

		ChangeCorner.CornerRadius = UDim.new(0, 4)
		ChangeCorner.Parent = ChangeBtn

		CloseBtn2.Name = "CloseBtn2"
		CloseBtn2.Parent = UserChange
		CloseBtn2.BackgroundTransparency = 1
		CloseBtn2.Position = UDim2.new(0.91, 0, 0.04, 0)
		CloseBtn2.Size = UDim2.new(0, 26, 0, 26)
		CloseBtn2.Text = ""
		CloseBtn2.ZIndex = 22

		Close2Icon.Name = "Close2Icon"
		Close2Icon.Parent = CloseBtn2
		Close2Icon.BackgroundTransparency = 1
		Close2Icon.AnchorPoint = Vector2.new(0.5, 0.5)
		Close2Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
		Close2Icon.Size = UDim2.new(0, 18, 0, 18)
		Close2Icon.Image = "http://www.roblox.com/asset/?id=6035047409"
		Close2Icon.ImageColor3 = Colors.TextMuted
		Close2Icon.ZIndex = 23

		CloseBtn1.Name = "CloseBtn1"
		CloseBtn1.Parent = UserChange
		CloseBtn1.BackgroundColor3 = Colors.BackgroundHover
		CloseBtn1.AnchorPoint = Vector2.new(1, 0)
		CloseBtn1.Position = UDim2.new(0.95, -100, 0.78, 0)
		CloseBtn1.Size = UDim2.new(0, 90, 0, 32)
		CloseBtn1.Font = Enum.Font.GothamMedium
		CloseBtn1.Text = "Отмена"
		CloseBtn1.TextColor3 = Colors.TextNormal
		CloseBtn1.TextSize = 13
		CloseBtn1.AutoButtonColor = false
		CloseBtn1.ZIndex = 22

		CloseBtn1.MouseEnter:Connect(function()
			TweenService:Create(CloseBtn1, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundActive}):Play()
		end)

		CloseBtn1.MouseLeave:Connect(function()
			TweenService:Create(CloseBtn1, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundHover}):Play()
		end)

		CloseBtn1Corner.CornerRadius = UDim.new(0, 4)
		CloseBtn1Corner.Parent = CloseBtn1

		local function CloseUserModal()
			UserChange:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(UserChange, TweenInfo.new(.3), {BackgroundTransparency = 1}):Play()
			TweenService:Create(NotificationHolder, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
			task.wait(.2)
			NotificationHolder:Destroy()
		end

		ChangeBtn.MouseButton1Click:Connect(function()
			user = UsernameTextbox.Text
			tag = TagTextbox.Text
			UserSettingsPadUser.Text = user
			UserSettingsPadUser.Size = UDim2.new(0, UserSettingsPadUser.TextBounds.X + 2, 0, 20)
			UserSettingsPadTag.Text = "#" .. tag
			UserPanelTag.Text = "#" .. tag
			UserPanelUser.Text = user
			UserPanelUser.Size = UDim2.new(0, UserPanelUser.TextBounds.X + 2, 0, 22)
			UserName.Text = user
			UserTag.Text = "#" .. tag
			SaveInfo()
			CloseUserModal()
		end)

		CloseBtn1.MouseButton1Click:Connect(CloseUserModal)
		CloseBtn2.MouseButton1Click:Connect(CloseUserModal)

		CloseBtn2.MouseEnter:Connect(function()
			TweenService:Create(Close2Icon, TweenInfo.new(.15), {ImageColor3 = Colors.TextNormal}):Play()
		end)

		CloseBtn2.MouseLeave:Connect(function()
			TweenService:Create(Close2Icon, TweenInfo.new(.15), {ImageColor3 = Colors.TextMuted}):Play()
		end)

		TagTextbox.Changed:Connect(function()
			if #TagTextbox.Text > 4 then
				TagTextbox.Text = TagTextbox.Text:sub(1, 4)
			end
		end)

		TagTextbox:GetPropertyChangedSignal("Text"):Connect(function()
			TagTextbox.Text = TagTextbox.Text:gsub('%D+', '')
		end)

		UsernameTextbox.Changed:Connect(function()
			if #UsernameTextbox.Text > 13 then
				UsernameTextbox.Text = UsernameTextbox.Text:sub(1, 13)
			end
		end)

		TagTextbox.Focused:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
		end)

		TagTextbox.FocusLost:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Colors.Blurple}):Play()
		end)

		UsernameTextbox.Focused:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
		end)

		UsernameTextbox.FocusLost:Connect(function()
			TweenService:Create(TextBoxFrame, TweenInfo.new(.2), {BackgroundColor3 = Colors.Blurple}):Play()
		end)
	end)

	-- ============================================================
	-- NOTIFICATION
	-- ============================================================
	function DiscordLib:Notification(titletext, desctext, btntext)
		local NotificationHolderMain = Instance.new("TextButton")
		local Notification = Instance.new("Frame")
		local NotificationCorner = Instance.new("UICorner")
		local UnderBar = Instance.new("Frame")
		local UnderBarCorner = Instance.new("UICorner")
		local Text1 = Instance.new("TextLabel")
		local Text2 = Instance.new("TextLabel")
		local AlrightBtn = Instance.new("TextButton")
		local AlrightCorner = Instance.new("UICorner")

		NotificationHolderMain.Name = "NotificationHolderMain"
		NotificationHolderMain.Parent = MainFrame
		NotificationHolderMain.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		NotificationHolderMain.BackgroundTransparency = 1
		NotificationHolderMain.BorderSizePixel = 0
		NotificationHolderMain.Position = UDim2.new(0, 0, 0, 26)
		NotificationHolderMain.Size = UDim2.new(0, 780, 0, 474)
		NotificationHolderMain.AutoButtonColor = false
		NotificationHolderMain.Text = ""
		NotificationHolderMain.ZIndex = 30
		TweenService:Create(NotificationHolderMain, TweenInfo.new(.2), {BackgroundTransparency = 0.4}):Play()

		Notification.Name = "Notification"
		Notification.Parent = NotificationHolderMain
		Notification.AnchorPoint = Vector2.new(0.5, 0.5)
		Notification.BackgroundColor3 = Colors.BackgroundAlt
		Notification.ClipsDescendants = true
		Notification.Position = UDim2.new(0.5, 0, 0.5, 0)
		Notification.Size = UDim2.new(0, 0, 0, 0)
		Notification.BackgroundTransparency = 1
		Notification.ZIndex = 31

		Notification:TweenSize(UDim2.new(0, 400, 0, 200), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
		TweenService:Create(Notification, TweenInfo.new(.2), {BackgroundTransparency = 0}):Play()

		NotificationCorner.CornerRadius = UDim.new(0, 10)
		NotificationCorner.Parent = Notification

		UnderBar.Name = "UnderBar"
		UnderBar.Parent = Notification
		UnderBar.BackgroundColor3 = Colors.BackgroundDark
		UnderBar.Position = UDim2.new(0, 0, 1, -16)
		UnderBar.Size = UDim2.new(1, 0, 0, 16)
		UnderBar.ZIndex = 31

		UnderBarCorner.CornerRadius = UDim.new(0, 10)
		UnderBarCorner.Parent = UnderBar

		Text1.Name = "Text1"
		Text1.Parent = Notification
		Text1.BackgroundTransparency = 1
		Text1.Position = UDim2.new(0.05, 0, 0.05, 0)
		Text1.Size = UDim2.new(0, 360, 0, 30)
		Text1.Font = Enum.Font.GothamBold
		Text1.Text = titletext
		Text1.TextColor3 = Colors.TextNormal
		Text1.TextSize = 18
		Text1.TextXAlignment = Enum.TextXAlignment.Left
		Text1.ZIndex = 32

		Text2.Name = "Text2"
		Text2.Parent = Notification
		Text2.BackgroundTransparency = 1
		Text2.Position = UDim2.new(0.05, 0, 0.22, 0)
		Text2.Size = UDim2.new(0, 360, 0, 80)
		Text2.Font = Enum.Font.Gotham
		Text2.Text = desctext
		Text2.TextColor3 = Colors.TextMuted
		Text2.TextSize = 13
		Text2.TextWrapped = true
		Text2.TextXAlignment = Enum.TextXAlignment.Left
		Text2.TextYAlignment = Enum.TextYAlignment.Top
		Text2.ZIndex = 32

		AlrightBtn.Name = "AlrightBtn"
		AlrightBtn.Parent = Notification
		AlrightBtn.BackgroundColor3 = Colors.Blurple
		AlrightBtn.AnchorPoint = Vector2.new(0.5, 0)
		AlrightBtn.Position = UDim2.new(0.5, 0, 0.72, 0)
		AlrightBtn.Size = UDim2.new(0, 360, 0, 32)
		AlrightBtn.Font = Enum.Font.GothamMedium
		AlrightBtn.Text = btntext
		AlrightBtn.TextColor3 = Colors.TextNormal
		AlrightBtn.TextSize = 13
		AlrightBtn.AutoButtonColor = false
		AlrightBtn.ZIndex = 32

		AlrightCorner.CornerRadius = UDim.new(0, 4)
		AlrightCorner.Parent = AlrightBtn

		AlrightBtn.MouseButton1Click:Connect(function()
			TweenService:Create(NotificationHolderMain, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
			Notification:TweenSize(UDim2.new(0, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			TweenService:Create(Notification, TweenInfo.new(.2), {BackgroundTransparency = 1}):Play()
			task.wait(.2)
			NotificationHolderMain:Destroy()
		end)

		AlrightBtn.MouseEnter:Connect(function()
			TweenService:Create(AlrightBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BlurpleHover}):Play()
		end)

		AlrightBtn.MouseLeave:Connect(function()
			TweenService:Create(AlrightBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
		end)
	end

	MakeDraggable(TopFrame, MainFrame)

	-- ============================================================
	-- SERVERS
	-- ============================================================
	local ServerHold = {}
	function ServerHold:Server(text, img)
		local fc = false
		local currentchanneltoggled = ""
		local Server = Instance.new("TextButton")
		local ServerBtnCorner = Instance.new("UICorner")
		local ServerIco = Instance.new("ImageLabel")
		local ServerWhiteFrame = Instance.new("Frame")
		local ServerWhiteFrameCorner = Instance.new("UICorner")

		Server.Name = text .. "Server"
		Server.Parent = ServersHold
		Server.BackgroundColor3 = Colors.BackgroundDark
		Server.Position = UDim2.new(0.125, 0, 0, 0)
		Server.Size = UDim2.new(0, 48, 0, 48)
		Server.AutoButtonColor = false
		Server.Font = Enum.Font.GothamBold
		Server.Text = ""
		Server.TextColor3 = Colors.TextNormal
		Server.TextSize = 18

		ServerBtnCorner.CornerRadius = UDim.new(1, 0)
		ServerBtnCorner.Name = "ServerCorner"
		ServerBtnCorner.Parent = Server

		ServerIco.Name = "ServerIco"
		ServerIco.Parent = Server
		ServerIco.AnchorPoint = Vector2.new(0.5, 0.5)
		ServerIco.BackgroundTransparency = 1
		ServerIco.Position = UDim2.new(0.5, 0, 0.5, 0)
		ServerIco.Size = UDim2.new(0, 28, 0, 28)
		ServerIco.Image = ""

		ServerWhiteFrame.Name = "ServerWhiteFrame"
		ServerWhiteFrame.Parent = Server
		ServerWhiteFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ServerWhiteFrame.BackgroundColor3 = Colors.TextNormal
		ServerWhiteFrame.Position = UDim2.new(-0.45, 0, 0.5, 0)
		ServerWhiteFrame.Size = UDim2.new(0, 8, 0, 0)

		ServerWhiteFrameCorner.CornerRadius = UDim.new(1, 0)
		ServerWhiteFrameCorner.Parent = ServerWhiteFrame
		ServersHold.CanvasSize = UDim2.new(0, 0, 0, ServersHoldLayout.AbsoluteContentSize.Y)

		local ServerFrame = Instance.new("Frame")
		local ServerFrameCorner = Instance.new("UICorner")
		local ServerTitleFrame = Instance.new("Frame")
		local ServerTitle = Instance.new("TextLabel")
		local ServerContentFrame = Instance.new("Frame")
		local ChannelTitleFrame = Instance.new("Frame")
		local Hashtag = Instance.new("TextLabel")
		local ChannelTitle = Instance.new("TextLabel")
		local ChannelContentFrame = Instance.new("Frame")
		local ServerChannelHolder = Instance.new("ScrollingFrame")
		local ServerChannelHolderLayout = Instance.new("UIListLayout")
		local ServerChannelHolderPadding = Instance.new("UIPadding")

		ServerFrame.Name = "ServerFrame"
		ServerFrame.Parent = ServersHolder
		ServerFrame.BackgroundColor3 = Colors.BackgroundAlt
		ServerFrame.BorderSizePixel = 0
		ServerFrame.ClipsDescendants = true
		ServerFrame.Position = UDim2.new(0, 72, 0, 26)
		ServerFrame.Size = UDim2.new(0, 708, 0, 474)
		ServerFrame.Visible = false

		ServerFrameCorner.CornerRadius = UDim.new(0, 10)
		ServerFrameCorner.Parent = ServerFrame

		ServerTitleFrame.Name = "ServerTitleFrame"
		ServerTitleFrame.Parent = ServerFrame
		ServerTitleFrame.BackgroundTransparency = 1
		ServerTitleFrame.BorderSizePixel = 0
		ServerTitleFrame.Position = UDim2.new(0, 0, 0, 0)
		ServerTitleFrame.Size = UDim2.new(0, 240, 0, 48)

		ServerTitle.Name = "ServerTitle"
		ServerTitle.Parent = ServerTitleFrame
		ServerTitle.BackgroundTransparency = 1
		ServerTitle.BorderSizePixel = 0
		ServerTitle.Position = UDim2.new(0, 16, 0, 0)
		ServerTitle.Size = UDim2.new(0, 220, 0, 48)
		ServerTitle.Font = Enum.Font.GothamBold
		ServerTitle.Text = text
		ServerTitle.TextColor3 = Colors.TextNormal
		ServerTitle.TextSize = 15
		ServerTitle.TextXAlignment = Enum.TextXAlignment.Left

		ServerContentFrame.Name = "ServerContentFrame"
		ServerContentFrame.Parent = ServerFrame
		ServerContentFrame.BackgroundTransparency = 1
		ServerContentFrame.BorderSizePixel = 0
		ServerContentFrame.Position = UDim2.new(0, 0, 0, 48)
		ServerContentFrame.Size = UDim2.new(0, 240, 0, 426)

		ChannelTitleFrame.Name = "ChannelTitleFrame"
		ChannelTitleFrame.Parent = ServerFrame
		ChannelTitleFrame.BackgroundColor3 = Colors.Background
		ChannelTitleFrame.BorderSizePixel = 0
		ChannelTitleFrame.Position = UDim2.new(0, 240, 0, 0)
		ChannelTitleFrame.Size = UDim2.new(0, 468, 0, 48)

		Hashtag.Name = "Hashtag"
		Hashtag.Parent = ChannelTitleFrame
		Hashtag.BackgroundTransparency = 1
		Hashtag.BorderSizePixel = 0
		Hashtag.Position = UDim2.new(0, 16, 0, 0)
		Hashtag.Size = UDim2.new(0, 22, 0, 48)
		Hashtag.Font = Enum.Font.GothamMedium
		Hashtag.Text = "#"
		Hashtag.TextColor3 = Colors.TextMuted
		Hashtag.TextSize = 22

		ChannelTitle.Name = "ChannelTitle"
		ChannelTitle.Parent = ChannelTitleFrame
		ChannelTitle.BackgroundTransparency = 1
		ChannelTitle.BorderSizePixel = 0
		ChannelTitle.Position = UDim2.new(0, 44, 0, 0)
		ChannelTitle.Size = UDim2.new(0, 300, 0, 48)
		ChannelTitle.Font = Enum.Font.GothamBold
		ChannelTitle.Text = ""
		ChannelTitle.TextColor3 = Colors.TextNormal
		ChannelTitle.TextSize = 15
		ChannelTitle.TextXAlignment = Enum.TextXAlignment.Left

		ChannelContentFrame.Name = "ChannelContentFrame"
		ChannelContentFrame.Parent = ServerFrame
		ChannelContentFrame.BackgroundColor3 = Colors.Background
		ChannelContentFrame.BorderSizePixel = 0
		ChannelContentFrame.ClipsDescendants = true
		ChannelContentFrame.Position = UDim2.new(0, 240, 0, 48)
		ChannelContentFrame.Size = UDim2.new(0, 468, 0, 426)

		ServerChannelHolder.Name = "ServerChannelHolder"
		ServerChannelHolder.Parent = ServerContentFrame
		ServerChannelHolder.Active = true
		ServerChannelHolder.BackgroundTransparency = 1
		ServerChannelHolder.BorderSizePixel = 0
		ServerChannelHolder.Position = UDim2.new(0, 8, 0, 8)
		ServerChannelHolder.Size = UDim2.new(0, 224, 0, 410)
		ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
		ServerChannelHolder.ScrollBarThickness = 3
		ServerChannelHolder.ScrollBarImageColor3 = Colors.Divider
		ServerChannelHolder.ScrollBarImageTransparency = 1

		ServerChannelHolderLayout.Name = "ServerChannelHolderLayout"
		ServerChannelHolderLayout.Parent = ServerChannelHolder
		ServerChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
		ServerChannelHolderLayout.Padding = UDim.new(0, 2)

		ServerChannelHolderPadding.Name = "ServerChannelHolderPadding"
		ServerChannelHolderPadding.Parent = ServerChannelHolder
		ServerChannelHolderPadding.PaddingLeft = UDim.new(0, 0)
		ServerChannelHolderPadding.PaddingTop = UDim.new(0, 4)

		ServerChannelHolder.MouseEnter:Connect(function()
			ServerChannelHolder.ScrollBarImageTransparency = 0
		end)

		ServerChannelHolder.MouseLeave:Connect(function()
			ServerChannelHolder.ScrollBarImageTransparency = 1
		end)

		-- Hover
		Server.MouseEnter:Connect(function()
			if currentservertoggled ~= Server.Name then
				TweenService:Create(Server, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
				TweenService:Create(ServerBtnCorner, TweenInfo.new(.15), {CornerRadius = UDim.new(0, 16)}):Play()
				ServerWhiteFrame:TweenSize(UDim2.new(0, 8, 0, 24), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			end
		end)

		Server.MouseLeave:Connect(function()
			if currentservertoggled ~= Server.Name then
				TweenService:Create(Server, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundDark}):Play()
				TweenService:Create(ServerBtnCorner, TweenInfo.new(.15), {CornerRadius = UDim.new(1, 0)}):Play()
				ServerWhiteFrame:TweenSize(UDim2.new(0, 8, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			end
		end)

		Server.MouseButton1Click:Connect(function()
			currentservertoggled = Server.Name
			for _, v in next, ServersHolder:GetChildren() do
				if v.Name == "ServerFrame" then
					v.Visible = false
				end
			end
			ServerFrame.Visible = true
			for _, v in next, ServersHold:GetChildren() do
				if v.ClassName == "TextButton" then
					TweenService:Create(v, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundDark}):Play()
					TweenService:Create(v.ServerCorner, TweenInfo.new(.15), {CornerRadius = UDim.new(1, 0)}):Play()
					v.ServerWhiteFrame:TweenSize(UDim2.new(0, 8, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
				end
			end
			TweenService:Create(Server, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
			TweenService:Create(ServerBtnCorner, TweenInfo.new(.15), {CornerRadius = UDim.new(0, 16)}):Play()
			ServerWhiteFrame:TweenSize(UDim2.new(0, 8, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
		end)

		if img == "" then
			Server.Text = string.sub(text, 1, 1)
		else
			Server.Text = ""
			ServerIco.Image = img
		end

		if fs == false then
			fs = true
			TweenService:Create(Server, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
			TweenService:Create(ServerBtnCorner, TweenInfo.new(.15), {CornerRadius = UDim.new(0, 16)}):Play()
			ServerWhiteFrame:TweenSize(UDim2.new(0, 8, 0, 30), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
			ServerFrame.Visible = true
			currentservertoggled = Server.Name
		end

		local ChannelHold = {}
		function ChannelHold:Channel(text)
			local ChannelBtn = Instance.new("TextButton")
			local ChannelBtnCorner = Instance.new("UICorner")
			local ChannelBtnHashtag = Instance.new("TextLabel")
			local ChannelBtnTitle = Instance.new("TextLabel")

			ChannelBtn.Name = text .. "ChannelBtn"
			ChannelBtn.Parent = ServerChannelHolder
			ChannelBtn.BackgroundColor3 = Colors.BackgroundAlt
			ChannelBtn.BorderSizePixel = 0
			ChannelBtn.Size = UDim2.new(1, 0, 0, 32)
			ChannelBtn.AutoButtonColor = false
			ChannelBtn.Font = Enum.Font.GothamMedium
			ChannelBtn.Text = ""
			ChannelBtn.TextColor3 = Colors.ChannelDefault
			ChannelBtn.TextSize = 14

			ChannelBtnCorner.CornerRadius = UDim.new(0, 4)
			ChannelBtnCorner.Parent = ChannelBtn

			ChannelBtnHashtag.Name = "ChannelBtnHashtag"
			ChannelBtnHashtag.Parent = ChannelBtn
			ChannelBtnHashtag.BackgroundTransparency = 1
			ChannelBtnHashtag.Position = UDim2.new(0, 6, 0, 0)
			ChannelBtnHashtag.Size = UDim2.new(0, 22, 0, 32)
			ChannelBtnHashtag.Font = Enum.Font.GothamMedium
			ChannelBtnHashtag.Text = "#"
			ChannelBtnHashtag.TextColor3 = Colors.ChannelDefault
			ChannelBtnHashtag.TextSize = 20

			ChannelBtnTitle.Name = "ChannelBtnTitle"
			ChannelBtnTitle.Parent = ChannelBtn
			ChannelBtnTitle.BackgroundTransparency = 1
			ChannelBtnTitle.BorderSizePixel = 0
			ChannelBtnTitle.Position = UDim2.new(0, 32, 0, 0)
			ChannelBtnTitle.Size = UDim2.new(1, -40, 1, 0)
			ChannelBtnTitle.Font = Enum.Font.GothamMedium
			ChannelBtnTitle.Text = text
			ChannelBtnTitle.TextColor3 = Colors.ChannelDefault
			ChannelBtnTitle.TextSize = 14
			ChannelBtnTitle.TextXAlignment = Enum.TextXAlignment.Left
			ServerChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ServerChannelHolderLayout.AbsoluteContentSize.Y)

			local ChannelHolder = Instance.new("ScrollingFrame")
			local ChannelHolderLayout = Instance.new("UIListLayout")
			local ChannelHolderPadding = Instance.new("UIPadding")

			ChannelHolder.Name = "ChannelHolder"
			ChannelHolder.Parent = ChannelContentFrame
			ChannelHolder.Active = true
			ChannelHolder.BackgroundTransparency = 1
			ChannelHolder.BorderSizePixel = 0
			ChannelHolder.Position = UDim2.new(0, 16, 0, 16)
			ChannelHolder.Size = UDim2.new(0, 436, 0, 394)
			ChannelHolder.ScrollBarThickness = 5
			ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
			ChannelHolder.ScrollBarImageTransparency = 0
			ChannelHolder.ScrollBarImageColor3 = Colors.BackgroundDark
			ChannelHolder.Visible = false
			ChannelHolder.ClipsDescendants = false

			ChannelHolderLayout.Name = "ChannelHolderLayout"
			ChannelHolderLayout.Parent = ChannelHolder
			ChannelHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
			ChannelHolderLayout.Padding = UDim.new(0, 6)

			ChannelHolderPadding.Name = "Padding"
			ChannelHolderPadding.Parent = ChannelHolder
			ChannelHolderPadding.PaddingRight = UDim.new(0, 4)

			ChannelBtn.MouseEnter:Connect(function()
				if currentchanneltoggled ~= ChannelBtn.Name then
					TweenService:Create(ChannelBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundHover}):Play()
					TweenService:Create(ChannelBtnTitle, TweenInfo.new(.15), {TextColor3 = Colors.ChannelHover}):Play()
					TweenService:Create(ChannelBtnHashtag, TweenInfo.new(.15), {TextColor3 = Colors.ChannelHover}):Play()
				end
			end)

			ChannelBtn.MouseLeave:Connect(function()
				if currentchanneltoggled ~= ChannelBtn.Name then
					TweenService:Create(ChannelBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundAlt}):Play()
					TweenService:Create(ChannelBtnTitle, TweenInfo.new(.15), {TextColor3 = Colors.ChannelDefault}):Play()
					TweenService:Create(ChannelBtnHashtag, TweenInfo.new(.15), {TextColor3 = Colors.ChannelDefault}):Play()
				end
			end)

			ChannelBtn.MouseButton1Click:Connect(function()
				for _, v in next, ChannelContentFrame:GetChildren() do
					if v.Name == "ChannelHolder" then
						v.Visible = false
					end
				end
				ChannelHolder.Visible = true
				for _, v in next, ServerChannelHolder:GetChildren() do
					if v.ClassName == "TextButton" then
						TweenService:Create(v, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundAlt}):Play()
						TweenService:Create(v.ChannelBtnTitle, TweenInfo.new(.15), {TextColor3 = Colors.ChannelDefault}):Play()
						TweenService:Create(v.ChannelBtnHashtag, TweenInfo.new(.15), {TextColor3 = Colors.ChannelDefault}):Play()
					end
				end
				ChannelTitle.Text = text
				TweenService:Create(ChannelBtn, TweenInfo.new(.15), {BackgroundColor3 = Colors.BackgroundActive}):Play()
				TweenService:Create(ChannelBtnTitle, TweenInfo.new(.15), {TextColor3 = Colors.TextNormal}):Play()
				TweenService:Create(ChannelBtnHashtag, TweenInfo.new(.15), {TextColor3 = Colors.TextNormal}):Play()
				currentchanneltoggled = ChannelBtn.Name
			end)

			if fc == false then
				fc = true
				ChannelTitle.Text = text
				ChannelBtn.BackgroundColor3 = Colors.BackgroundActive
				ChannelBtnTitle.TextColor3 = Colors.TextNormal
				ChannelBtnHashtag.TextColor3 = Colors.TextNormal
				currentchanneltoggled = ChannelBtn.Name
				ChannelHolder.Visible = true
			end

			local ChannelContent = {}

			function ChannelContent:Button(text, callback)
				local Button = Instance.new("TextButton")
				local ButtonCorner = Instance.new("UICorner")

				Button.Name = "Button"
				Button.Parent = ChannelHolder
				Button.BackgroundColor3 = Colors.Blurple
				Button.Size = UDim2.new(1, -4, 0, 34)
				Button.AutoButtonColor = false
				Button.Font = Enum.Font.GothamMedium
				Button.TextColor3 = Colors.TextNormal
				Button.TextSize = 14
				Button.Text = text

				ButtonCorner.CornerRadius = UDim.new(0, 4)
				ButtonCorner.Parent = Button

				Button.MouseEnter:Connect(function()
					TweenService:Create(Button, TweenInfo.new(.15), {BackgroundColor3 = Colors.BlurpleHover}):Play()
				end)

				Button.MouseLeave:Connect(function()
					TweenService:Create(Button, TweenInfo.new(.15), {BackgroundColor3 = Colors.Blurple}):Play()
				end)

				Button.MouseButton1Click:Connect(function()
					pcall(callback)
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Toggle(text, default, callback)
				local toggled = default or false
				local Toggle = Instance.new("TextButton")
				local ToggleTitle = Instance.new("TextLabel")
				local ToggleFrame = Instance.new("Frame")
				local ToggleFrameCorner = Instance.new("UICorner")
				local ToggleFrameCircle = Instance.new("Frame")
				local ToggleFrameCircleCorner = Instance.new("UICorner")

				Toggle.Name = "Toggle"
				Toggle.Parent = ChannelHolder
				Toggle.BackgroundColor3 = Colors.BackgroundHover
				Toggle.BorderSizePixel = 0
				Toggle.Size = UDim2.new(1, -4, 0, 34)
				Toggle.AutoButtonColor = false
				Toggle.Font = Enum.Font.Gotham
				Toggle.Text = ""

				local ToggleCorner = Instance.new("UICorner")
				ToggleCorner.CornerRadius = UDim.new(0, 4)
				ToggleCorner.Parent = Toggle

				ToggleTitle.Name = "ToggleTitle"
				ToggleTitle.Parent = Toggle
				ToggleTitle.BackgroundTransparency = 1
				ToggleTitle.Position = UDim2.new(0, 10, 0, 0)
				ToggleTitle.Size = UDim2.new(0, 250, 1, 0)
				ToggleTitle.Font = Enum.Font.GothamMedium
				ToggleTitle.Text = text
				ToggleTitle.TextColor3 = Colors.TextNormal
				ToggleTitle.TextSize = 14
				ToggleTitle.TextXAlignment = Enum.TextXAlignment.Left

				ToggleFrame.Name = "ToggleFrame"
				ToggleFrame.Parent = Toggle
				ToggleFrame.AnchorPoint = Vector2.new(1, 0.5)
				ToggleFrame.BackgroundColor3 = Colors.BackgroundDark
				ToggleFrame.Position = UDim2.new(1, -8, 0.5, 0)
				ToggleFrame.Size = UDim2.new(0, 40, 0, 22)

				ToggleFrameCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameCorner.Parent = ToggleFrame

				ToggleFrameCircle.Name = "ToggleFrameCircle"
				ToggleFrameCircle.Parent = ToggleFrame
				ToggleFrameCircle.AnchorPoint = Vector2.new(0, 0.5)
				ToggleFrameCircle.BackgroundColor3 = Colors.TextNormal
				ToggleFrameCircle.Position = UDim2.new(0, 3, 0.5, 0)
				ToggleFrameCircle.Size = UDim2.new(0, 16, 0, 16)

				ToggleFrameCircleCorner.CornerRadius = UDim.new(1, 0)
				ToggleFrameCircleCorner.Parent = ToggleFrameCircle

				local function ApplyState(state)
					if state then
						TweenService:Create(ToggleFrame, TweenInfo.new(.2), {BackgroundColor3 = Colors.Green}):Play()
						ToggleFrameCircle:TweenPosition(UDim2.new(1, -3, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
						ToggleFrameCircle:TweenSize(UDim2.new(0, 16, 0, 16), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
					else
						TweenService:Create(ToggleFrame, TweenInfo.new(.2), {BackgroundColor3 = Colors.BackgroundDark}):Play()
						ToggleFrameCircle:TweenPosition(UDim2.new(0, 3, 0.5, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
						ToggleFrameCircle:TweenSize(UDim2.new(0, 16, 0, 16), Enum.EasingDirection.Out, Enum.EasingStyle.Quart, .2, true)
					end
				end

				ApplyState(toggled)

				Toggle.MouseButton1Click:Connect(function()
					toggled = not toggled
					ApplyState(toggled)
					pcall(callback, toggled)
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Slider(text, min, max, start, callback)
				local SliderFunc = {}
				local dragging = false
				local Slider = Instance.new("TextButton")
				local SliderTitle = Instance.new("TextLabel")
				local SliderFrame = Instance.new("Frame")
				local SliderFrameCorner = Instance.new("UICorner")
				local CurrentValueFrame = Instance.new("Frame")
				local CurrentValueFrameCorner = Instance.new("UICorner")
				local Zip = Instance.new("Frame")
				local ZipCorner = Instance.new("UICorner")
				local ValueBubble = Instance.new("Frame")
				local ValueBubbleCorner = Instance.new("UICorner")
				local ValueLabel = Instance.new("TextLabel")

				Slider.Name = "Slider"
				Slider.Parent = ChannelHolder
				Slider.BackgroundColor3 = Colors.BackgroundHover
				Slider.BorderSizePixel = 0
				Slider.Size = UDim2.new(1, -4, 0, 44)
				Slider.AutoButtonColor = false
				Slider.Text = ""

				local SliderCorner = Instance.new("UICorner")
				SliderCorner.CornerRadius = UDim.new(0, 4)
				SliderCorner.Parent = Slider

				SliderTitle.Name = "SliderTitle"
				SliderTitle.Parent = Slider
				SliderTitle.BackgroundTransparency = 1
				SliderTitle.Position = UDim2.new(0, 10, 0, 4)
				SliderTitle.Size = UDim2.new(0, 250, 0, 20)
				SliderTitle.Font = Enum.Font.GothamMedium
				SliderTitle.Text = text
				SliderTitle.TextColor3 = Colors.TextNormal
				SliderTitle.TextSize = 13
				SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

				SliderFrame.Name = "SliderFrame"
				SliderFrame.Parent = Slider
				SliderFrame.AnchorPoint = Vector2.new(0.5, 0.5)
				SliderFrame.BackgroundColor3 = Colors.BackgroundDark
				SliderFrame.Position = UDim2.new(0.5, 0, 0.78, 0)
				SliderFrame.Size = UDim2.new(1, -20, 0, 6)

				SliderFrameCorner.CornerRadius = UDim.new(1, 0)
				SliderFrameCorner.Parent = SliderFrame

				CurrentValueFrame.Name = "CurrentValueFrame"
				CurrentValueFrame.Parent = SliderFrame
				CurrentValueFrame.BackgroundColor3 = Colors.Blurple
				CurrentValueFrame.Size = UDim2.new((start or 0) / max, 0, 1, 0)

				CurrentValueFrameCorner.CornerRadius = UDim.new(1, 0)
				CurrentValueFrameCorner.Parent = CurrentValueFrame

				Zip.Name = "Zip"
				Zip.Parent = SliderFrame
				Zip.AnchorPoint = Vector2.new(0.5, 0.5)
				Zip.BackgroundColor3 = Colors.TextNormal
				Zip.Position = UDim2.new((start or 0) / max, 0, 0.5, 0)
				Zip.Size = UDim2.new(0, 14, 0, 14)

				ZipCorner.CornerRadius = UDim.new(1, 0)
				ZipCorner.Parent = Zip

				ValueBubble.Name = "ValueBubble"
				ValueBubble.Parent = Zip
				ValueBubble.AnchorPoint = Vector2.new(0.5, 1)
				ValueBubble.BackgroundColor3 = Colors.BackgroundDark
				ValueBubble.Position = UDim2.new(0.5, 0, -0.6, 0)
				ValueBubble.Size = UDim2.new(0, 40, 0, 22)
				ValueBubble.Visible = false

				ValueBubbleCorner.CornerRadius = UDim.new(0, 4)
				ValueBubbleCorner.Parent = ValueBubble

				ValueLabel.Name = "ValueLabel"
				ValueLabel.Parent = ValueBubble
				ValueLabel.BackgroundTransparency = 1
				ValueLabel.Size = UDim2.new(1, 0, 1, 0)
				ValueLabel.Font = Enum.Font.GothamBold
				ValueLabel.Text = tostring(start or min)
				ValueLabel.TextColor3 = Colors.TextNormal
				ValueLabel.TextSize = 11

				local function move(input)
					local pos = UDim2.new(
						math.clamp((input.Position.X - SliderFrame.AbsolutePosition.X) / SliderFrame.AbsoluteSize.X, 0, 1),
						0, 0.5, 0
					)
					CurrentValueFrame.Size = UDim2.new(pos.X.Scale, 0, 1, 0)
					Zip.Position = pos
					local value = math.floor(((pos.X.Scale * max) / max) * (max - min) + min)
					ValueLabel.Text = tostring(value)
					pcall(callback, value)
				end

				Slider.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = true
						ValueBubble.Visible = true
						move(input)
					end
				end)

				Slider.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						dragging = false
						ValueBubble.Visible = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
						move(input)
					end
				end)

				function SliderFunc:Change(tochange)
					CurrentValueFrame.Size = UDim2.new((tochange or 0) / max, 0, 1, 0)
					Zip.Position = UDim2.new((tochange or 0) / max, 0, 0.5, 0)
					ValueLabel.Text = tostring(tochange or min)
					pcall(callback, tochange)
				end

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
				return SliderFunc
			end

			function ChannelContent:Seperator()
				local Seperator1 = Instance.new("Frame")
				local Seperator2 = Instance.new("Frame")

				Seperator1.Name = "Seperator1"
				Seperator1.Parent = ChannelHolder
				Seperator1.BackgroundTransparency = 1
				Seperator1.Size = UDim2.new(1, 0, 0, 8)

				Seperator2.Name = "Seperator2"
				Seperator2.Parent = Seperator1
				Seperator2.AnchorPoint = Vector2.new(0.5, 0.5)
				Seperator2.BackgroundColor3 = Colors.Divider
				Seperator2.BorderSizePixel = 0
				Seperator2.Position = UDim2.new(0.5, 0, 0.5, 0)
				Seperator2.Size = UDim2.new(1, -8, 0, 1)
				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Dropdown(text, list, callback)
				local DropFunc = {}
				local itemcount = 0
				local framesize = 0
				local DropTog = false
				local Dropdown = Instance.new("Frame")
				local DropdownTitle = Instance.new("TextLabel")
				local DropdownFrameOutline = Instance.new("Frame")
				local DropdownFrameOutlineCorner = Instance.new("UICorner")
				local DropdownFrame = Instance.new("Frame")
				local DropdownFrameCorner = Instance.new("UICorner")
				local CurrentSelectedText = Instance.new("TextLabel")
				local ArrowImg = Instance.new("ImageLabel")
				local DropdownFrameBtn = Instance.new("TextButton")

				Dropdown.Name = "Dropdown"
				Dropdown.Parent = ChannelHolder
				Dropdown.BackgroundTransparency = 1
				Dropdown.Size = UDim2.new(1, -4, 0, 60)

				DropdownTitle.Name = "DropdownTitle"
				DropdownTitle.Parent = Dropdown
				DropdownTitle.BackgroundTransparency = 1
				DropdownTitle.Position = UDim2.new(0, 10, 0, 0)
				DropdownTitle.Size = UDim2.new(0, 250, 0, 22)
				DropdownTitle.Font = Enum.Font.GothamMedium
				DropdownTitle.Text = text
				DropdownTitle.TextColor3 = Colors.TextNormal
				DropdownTitle.TextSize = 13
				DropdownTitle.TextXAlignment = Enum.TextXAlignment.Left

				DropdownFrameOutline.Name = "DropdownFrameOutline"
				DropdownFrameOutline.Parent = Dropdown
				DropdownFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
				DropdownFrameOutline.BackgroundColor3 = Colors.Blurple
				DropdownFrameOutline.Position = UDim2.new(0.5, 0, 0, 26)
				DropdownFrameOutline.Size = UDim2.new(1, -8, 0, 34)

				DropdownFrameOutlineCorner.CornerRadius = UDim.new(0, 4)
				DropdownFrameOutlineCorner.Parent = DropdownFrameOutline

				DropdownFrame.Name = "DropdownFrame"
				DropdownFrame.Parent = Dropdown
				DropdownFrame.AnchorPoint = Vector2.new(0.5, 0)
				DropdownFrame.BackgroundColor3 = Colors.InputBackground
				DropdownFrame.ClipsDescendants = true
				DropdownFrame.Position = UDim2.new(0.5, 0, 0, 28)
				DropdownFrame.Size = UDim2.new(1, -12, 0, 30)

				DropdownFrameCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameCorner.Parent = DropdownFrame

				CurrentSelectedText.Name = "CurrentSelectedText"
				CurrentSelectedText.Parent = DropdownFrame
				CurrentSelectedText.BackgroundTransparency = 1
				CurrentSelectedText.Position = UDim2.new(0, 10, 0, 0)
				CurrentSelectedText.Size = UDim2.new(1, -40, 1, 0)
				CurrentSelectedText.Font = Enum.Font.Gotham
				CurrentSelectedText.Text = "..."
				CurrentSelectedText.TextColor3 = Colors.TextNormal
				CurrentSelectedText.TextSize = 13
				CurrentSelectedText.TextXAlignment = Enum.TextXAlignment.Left

				ArrowImg.Name = "ArrowImg"
				ArrowImg.Parent = DropdownFrame
				ArrowImg.AnchorPoint = Vector2.new(1, 0.5)
				ArrowImg.BackgroundTransparency = 1
				ArrowImg.Position = UDim2.new(1, -8, 0.5, 0)
				ArrowImg.Size = UDim2.new(0, 14, 0, 14)
				ArrowImg.Image = "http://www.roblox.com/asset/?id=6034818372"
				ArrowImg.ImageColor3 = Colors.TextMuted

				DropdownFrameBtn.Name = "DropdownFrameBtn"
				DropdownFrameBtn.Parent = DropdownFrame
				DropdownFrameBtn.BackgroundTransparency = 1
				DropdownFrameBtn.Size = UDim2.new(1, 0, 1, 0)
				DropdownFrameBtn.Text = ""

				local DropdownFrameMainOutline = Instance.new("Frame")
				local DropdownFrameMainOutlineCorner = Instance.new("UICorner")
				local DropdownFrameMain = Instance.new("Frame")
				local DropdownFrameMainCorner = Instance.new("UICorner")
				local DropItemHolder = Instance.new("ScrollingFrame")
				local DropItemHolderLayout = Instance.new("UIListLayout")

				DropdownFrameMainOutline.Name = "DropdownFrameMainOutline"
				DropdownFrameMainOutline.Parent = Dropdown
				DropdownFrameMainOutline.AnchorPoint = Vector2.new(0.5, 0)
				DropdownFrameMainOutline.BackgroundColor3 = Colors.Blurple
				DropdownFrameMainOutline.Position = UDim2.new(0.5, 0, 0, 62)
				DropdownFrameMainOutline.Size = UDim2.new(1, -8, 0, 80)
				DropdownFrameMainOutline.Visible = false

				DropdownFrameMainOutlineCorner.CornerRadius = UDim.new(0, 4)
				DropdownFrameMainOutlineCorner.Parent = DropdownFrameMainOutline

				DropdownFrameMain.Name = "DropdownFrameMain"
				DropdownFrameMain.Parent = Dropdown
				DropdownFrameMain.AnchorPoint = Vector2.new(0.5, 0)
				DropdownFrameMain.BackgroundColor3 = Colors.InputBackground
				DropdownFrameMain.ClipsDescendants = true
				DropdownFrameMain.Position = UDim2.new(0.5, 0, 0, 64)
				DropdownFrameMain.Size = UDim2.new(1, -12, 0, 76)
				DropdownFrameMain.Visible = false

				DropdownFrameMainCorner.CornerRadius = UDim.new(0, 3)
				DropdownFrameMainCorner.Parent = DropdownFrameMain

				DropItemHolder.Name = "ItemHolder"
				DropItemHolder.Parent = DropdownFrameMain
				DropItemHolder.Active = true
				DropItemHolder.BackgroundTransparency = 1
				DropItemHolder.Position = UDim2.new(0, 4, 0, 4)
				DropItemHolder.Size = UDim2.new(1, -8, 1, -8)
				DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, 0)
				DropItemHolder.ScrollBarThickness = 3
				DropItemHolder.BorderSizePixel = 0
				DropItemHolder.ScrollBarImageColor3 = Colors.Divider

				DropItemHolderLayout.Name = "ItemHolderLayout"
				DropItemHolderLayout.Parent = DropItemHolder
				DropItemHolderLayout.SortOrder = Enum.SortOrder.LayoutOrder
				DropItemHolderLayout.Padding = UDim.new(0, 2)

				DropdownFrameBtn.MouseButton1Click:Connect(function()
					if DropTog == false then
						DropdownFrameMain.Visible = true
						DropdownFrameMainOutline.Visible = true
						Dropdown.Size = UDim2.new(1, -4, 0, 64 + DropdownFrameMainOutline.AbsoluteSize.Y)
					else
						Dropdown.Size = UDim2.new(1, -4, 0, 60)
						DropdownFrameMain.Visible = false
						DropdownFrameMainOutline.Visible = false
					end
					DropTog = not DropTog
					ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
				end)

				local function createItem(textadd)
					itemcount = itemcount + 1
					framesize = math.min(itemcount * 30, 90)

					local Item = Instance.new("TextButton")
					local ItemCorner = Instance.new("UICorner")

					Item.Name = "Item"
					Item.Parent = DropItemHolder
					Item.BackgroundColor3 = Colors.BackgroundHover
					Item.BackgroundTransparency = 1
					Item.Size = UDim2.new(1, -4, 0, 28)
					Item.AutoButtonColor = false
					Item.Font = Enum.Font.Gotham
					Item.Text = textadd
					Item.TextColor3 = Colors.TextNormal
					Item.TextSize = 13
					Item.TextXAlignment = Enum.TextXAlignment.Left

					ItemCorner.CornerRadius = UDim.new(0, 4)
					ItemCorner.Parent = Item

					local ItemPadding = Instance.new("UIPadding")
					ItemPadding.PaddingLeft = UDim.new(0, 8)
					ItemPadding.Parent = Item

					Item.MouseEnter:Connect(function()
						Item.BackgroundTransparency = 0
					end)

					Item.MouseLeave:Connect(function()
						Item.BackgroundTransparency = 1
					end)

					Item.MouseButton1Click:Connect(function()
						CurrentSelectedText.Text = textadd
						pcall(callback, textadd)
						Dropdown.Size = UDim2.new(1, -4, 0, 60)
						DropdownFrameMain.Visible = false
						DropdownFrameMainOutline.Visible = false
						DropTog = false
						ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
					end)

					DropItemHolder.CanvasSize = UDim2.new(0, 0, 0, DropItemHolderLayout.AbsoluteContentSize.Y)
					DropItemHolder.Size = UDim2.new(1, -8, 0, framesize)
					DropdownFrameMain.Size = UDim2.new(1, -12, 0, framesize + 8)
					DropdownFrameMainOutline.Size = UDim2.new(1, -8, 0, framesize + 12)
				end

				for _, v in next, list do
					createItem(v)
				end

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)

				function DropFunc:Clear()
					for _, v in next, DropItemHolder:GetChildren() do
						if v.Name == "Item" then
							v:Destroy()
						end
					end
					CurrentSelectedText.Text = "..."
					itemcount = 0
					framesize = 0
					DropItemHolder.Size = UDim2.new(1, -8, 0, 0)
					DropdownFrameMain.Size = UDim2.new(1, -12, 0, 0)
					DropdownFrameMainOutline.Size = UDim2.new(1, -8, 0, 0)
					Dropdown.Size = UDim2.new(1, -4, 0, 60)
					DropdownFrameMain.Visible = false
					DropdownFrameMainOutline.Visible = false
					DropTog = false
					ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
				end

				function DropFunc:Add(textadd)
					createItem(textadd)
				end

				return DropFunc
			end

			function ChannelContent:Colorpicker(text, preset, callback)
				local ColorH, ColorS, ColorV = 1, 1, 1
				local ColorInput = nil
				local HueInput = nil

				local Colorpicker = Instance.new("Frame")
				local ColorpickerTitle = Instance.new("TextLabel")
				local ColorpickerFrameOutline = Instance.new("Frame")
				local ColorpickerFrameOutlineCorner = Instance.new("UICorner")
				local ColorpickerFrame = Instance.new("Frame")
				local ColorpickerFrameCorner = Instance.new("UICorner")
				local Color = Instance.new("ImageLabel")
				local ColorCorner = Instance.new("UICorner")
				local ColorSelection = Instance.new("ImageLabel")
				local Hue = Instance.new("ImageLabel")
				local HueCorner = Instance.new("UICorner")
				local HueGradient = Instance.new("UIGradient")
				local HueSelection = Instance.new("ImageLabel")
				local PresetClr = Instance.new("Frame")
				local PresetClrCorner = Instance.new("UICorner")

				Colorpicker.Name = "Colorpicker"
				Colorpicker.Parent = ChannelHolder
				Colorpicker.BackgroundTransparency = 1
				Colorpicker.Size = UDim2.new(1, -4, 0, 170)

				ColorpickerTitle.Name = "ColorpickerTitle"
				ColorpickerTitle.Parent = Colorpicker
				ColorpickerTitle.BackgroundTransparency = 1
				ColorpickerTitle.Position = UDim2.new(0, 10, 0, 0)
				ColorpickerTitle.Size = UDim2.new(0, 250, 0, 22)
				ColorpickerTitle.Font = Enum.Font.GothamMedium
				ColorpickerTitle.Text = text
				ColorpickerTitle.TextColor3 = Colors.TextNormal
				ColorpickerTitle.TextSize = 13
				ColorpickerTitle.TextXAlignment = Enum.TextXAlignment.Left

				ColorpickerFrameOutline.Name = "ColorpickerFrameOutline"
				ColorpickerFrameOutline.Parent = Colorpicker
				ColorpickerFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
				ColorpickerFrameOutline.BackgroundColor3 = Colors.Blurple
				ColorpickerFrameOutline.Position = UDim2.new(0.5, 0, 0, 26)
				ColorpickerFrameOutline.Size = UDim2.new(1, -8, 0, 140)

				ColorpickerFrameOutlineCorner.CornerRadius = UDim.new(0, 4)
				ColorpickerFrameOutlineCorner.Parent = ColorpickerFrameOutline

				ColorpickerFrame.Name = "ColorpickerFrame"
				ColorpickerFrame.Parent = Colorpicker
				ColorpickerFrame.AnchorPoint = Vector2.new(0.5, 0)
				ColorpickerFrame.BackgroundColor3 = Colors.InputBackground
				ColorpickerFrame.ClipsDescendants = true
				ColorpickerFrame.Position = UDim2.new(0.5, 0, 0, 28)
				ColorpickerFrame.Size = UDim2.new(1, -12, 0, 136)

				ColorpickerFrameCorner.CornerRadius = UDim.new(0, 3)
				ColorpickerFrameCorner.Parent = ColorpickerFrame

				Color.Name = "Color"
				Color.Parent = ColorpickerFrame
				Color.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
				Color.Position = UDim2.new(0, 10, 0, 10)
				Color.Size = UDim2.new(0, 250, 0, 116)
				Color.ZIndex = 10
				Color.Image = "rbxassetid://4155801252"

				ColorCorner.CornerRadius = UDim.new(0, 3)
				ColorCorner.Parent = Color

				ColorSelection.Name = "ColorSelection"
				ColorSelection.Parent = Color
				ColorSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				ColorSelection.BackgroundTransparency = 1
				ColorSelection.Position = UDim2.new(preset and select(3, Color3.toHSV(preset)))
				ColorSelection.Size = UDim2.new(0, 18, 0, 18)
				ColorSelection.Image = "http://www.roblox.com/asset/?id=4805639000"
				ColorSelection.ScaleType = Enum.ScaleType.Fit

				Hue.Name = "Hue"
				Hue.Parent = ColorpickerFrame
				Hue.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
				Hue.Position = UDim2.new(0, 270, 0, 10)
				Hue.Size = UDim2.new(0, 18, 0, 116)

				HueCorner.CornerRadius = UDim.new(0, 3)
				HueCorner.Parent = Hue

				HueGradient.Color = ColorSequence.new {
					ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
					ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
					ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
					ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
					ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
					ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
					ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
				}
				HueGradient.Rotation = 270
				HueGradient.Parent = Hue

				HueSelection.Name = "HueSelection"
				HueSelection.Parent = Hue
				HueSelection.AnchorPoint = Vector2.new(0.5, 0.5)
				HueSelection.BackgroundTransparency = 1
				HueSelection.Position = UDim2.new(0.5, 0, 1 - select(1, Color3.toHSV(preset)))
				HueSelection.Size = UDim2.new(0, 18, 0, 18)
				HueSelection.Image = "http://www.roblox.com/asset/?id=4805639000"

				PresetClr.Name = "PresetClr"
				PresetClr.Parent = ColorpickerFrame
				PresetClr.BackgroundColor3 = preset
				PresetClr.Position = UDim2.new(0, 298, 0, 10)
				PresetClr.Size = UDim2.new(0, 20, 0, 20)

				PresetClrCorner.CornerRadius = UDim.new(0, 3)
				PresetClrCorner.Parent = PresetClr

				local function UpdateColorPicker()
					PresetClr.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
					Color.BackgroundColor3 = Color3.fromHSV(ColorH, 1, 1)
					pcall(callback, PresetClr.BackgroundColor3)
				end

				ColorH = 1 - (math.clamp(HueSelection.AbsolutePosition.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
				ColorS = (math.clamp(ColorSelection.AbsolutePosition.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
				ColorV = 1 - (math.clamp(ColorSelection.AbsolutePosition.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)

				PresetClr.BackgroundColor3 = preset
				Color.BackgroundColor3 = preset
				pcall(callback, PresetClr.BackgroundColor3)

				Color.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then ColorInput:Disconnect() end
						ColorInput = RunService.RenderStepped:Connect(function()
							local ColorX = (math.clamp(Mouse.X - Color.AbsolutePosition.X, 0, Color.AbsoluteSize.X) / Color.AbsoluteSize.X)
							local ColorY = (math.clamp(Mouse.Y - Color.AbsolutePosition.Y, 0, Color.AbsoluteSize.Y) / Color.AbsoluteSize.Y)
							ColorSelection.Position = UDim2.new(ColorX, 0, ColorY, 0)
							ColorS = ColorX
							ColorV = 1 - ColorY
							UpdateColorPicker()
						end)
					end
				end)

				Color.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if ColorInput then ColorInput:Disconnect() end
					end
				end)

				Hue.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then HueInput:Disconnect() end
						HueInput = RunService.RenderStepped:Connect(function()
							local HueY = (math.clamp(Mouse.Y - Hue.AbsolutePosition.Y, 0, Hue.AbsoluteSize.Y) / Hue.AbsoluteSize.Y)
							HueSelection.Position = UDim2.new(0.5, 0, HueY, 0)
							ColorH = 1 - HueY
							UpdateColorPicker()
						end)
					end
				end)

				Hue.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 then
						if HueInput then HueInput:Disconnect() end
					end
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Textbox(text, placetext, disapper, callback)
				local Textbox = Instance.new("Frame")
				local TextboxTitle = Instance.new("TextLabel")
				local TextboxFrameOutline = Instance.new("Frame")
				local TextboxFrameOutlineCorner = Instance.new("UICorner")
				local TextboxFrame = Instance.new("Frame")
				local TextboxFrameCorner = Instance.new("UICorner")
				local TextBox = Instance.new("TextBox")

				Textbox.Name = "Textbox"
				Textbox.Parent = ChannelHolder
				Textbox.BackgroundTransparency = 1
				Textbox.Size = UDim2.new(1, -4, 0, 62)

				TextboxTitle.Name = "TextboxTitle"
				TextboxTitle.Parent = Textbox
				TextboxTitle.BackgroundTransparency = 1
				TextboxTitle.Position = UDim2.new(0, 10, 0, 0)
				TextboxTitle.Size = UDim2.new(0, 250, 0, 22)
				TextboxTitle.Font = Enum.Font.GothamMedium
				TextboxTitle.Text = text
				TextboxTitle.TextColor3 = Colors.TextNormal
				TextboxTitle.TextSize = 13
				TextboxTitle.TextXAlignment = Enum.TextXAlignment.Left

				TextboxFrameOutline.Name = "TextboxFrameOutline"
				TextboxFrameOutline.Parent = Textbox
				TextboxFrameOutline.AnchorPoint = Vector2.new(0.5, 0)
				TextboxFrameOutline.BackgroundColor3 = Colors.Blurple
				TextboxFrameOutline.Position = UDim2.new(0.5, 0, 0, 26)
				TextboxFrameOutline.Size = UDim2.new(1, -8, 0, 34)

				TextboxFrameOutlineCorner.CornerRadius = UDim.new(0, 4)
				TextboxFrameOutlineCorner.Parent = TextboxFrameOutline

				TextboxFrame.Name = "TextboxFrame"
				TextboxFrame.Parent = Textbox
				TextboxFrame.AnchorPoint = Vector2.new(0.5, 0)
				TextboxFrame.BackgroundColor3 = Colors.InputBackground
				TextboxFrame.ClipsDescendants = true
				TextboxFrame.Position = UDim2.new(0.5, 0, 0, 28)
				TextboxFrame.Size = UDim2.new(1, -12, 0, 30)

				TextboxFrameCorner.CornerRadius = UDim.new(0, 3)
				TextboxFrameCorner.Parent = TextboxFrame

				TextBox.Parent = TextboxFrame
				TextBox.BackgroundTransparency = 1
				TextBox.Position = UDim2.new(0, 10, 0, 0)
				TextBox.Size = UDim2.new(1, -20, 1, 0)
				TextBox.Font = Enum.Font.Gotham
				TextBox.PlaceholderColor3 = Colors.TextMuted
				TextBox.PlaceholderText = placetext
				TextBox.Text = ""
				TextBox.TextColor3 = Colors.TextNormal
					TextBox.TextSize = 13
				TextBox.TextXAlignment = Enum.TextXAlignment.Left

				TextBox.Focused:Connect(function()
					TweenService:Create(TextboxFrameOutline, TweenInfo.new(.2), {BackgroundColor3 = Color3.fromRGB(110, 123, 255)}):Play()
				end)

				TextBox.FocusLost:Connect(function(ep)
					TweenService:Create(TextboxFrameOutline, TweenInfo.new(.2), {BackgroundColor3 = Colors.Blurple}):Play()
					if ep then
						if #TextBox.Text > 0 then
							pcall(callback, TextBox.Text)
							if disapper then
								TextBox.Text = ""
							end
						end
					end
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Label(text)
				local Label = Instance.new("TextButton")
				local LabelTitle = Instance.new("TextLabel")

				Label.Name = "Label"
				Label.Parent = ChannelHolder
				Label.BackgroundColor3 = Colors.BackgroundHover
				Label.BorderSizePixel = 0
				Label.Size = UDim2.new(1, -4, 0, 34)
				Label.AutoButtonColor = false
				Label.Text = ""

				local LabelCorner = Instance.new("UICorner")
				LabelCorner.CornerRadius = UDim.new(0, 4)
				LabelCorner.Parent = Label

				LabelTitle.Name = "LabelTitle"
				LabelTitle.Parent = Label
				LabelTitle.BackgroundTransparency = 1
				LabelTitle.Position = UDim2.new(0, 10, 0, 0)
				LabelTitle.Size = UDim2.new(1, -20, 1, 0)
				LabelTitle.Font = Enum.Font.GothamMedium
				LabelTitle.Text = text
				LabelTitle.TextColor3 = Colors.TextNormal
				LabelTitle.TextSize = 13
				LabelTitle.TextXAlignment = Enum.TextXAlignment.Left

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			function ChannelContent:Bind(text, presetbind, callback)
				local Key = presetbind.Name
				local Keybind = Instance.new("TextButton")
				local KeybindTitle = Instance.new("TextLabel")
				local KeybindText = Instance.new("TextLabel")

				Keybind.Name = "Keybind"
				Keybind.Parent = ChannelHolder
				Keybind.BackgroundColor3 = Colors.BackgroundHover
				Keybind.BorderSizePixel = 0
				Keybind.Size = UDim2.new(1, -4, 0, 34)
				Keybind.AutoButtonColor = false
				Keybind.Text = ""

				local KeybindCorner = Instance.new("UICorner")
				KeybindCorner.CornerRadius = UDim.new(0, 4)
				KeybindCorner.Parent = Keybind

				KeybindTitle.Name = "KeybindTitle"
				KeybindTitle.Parent = Keybind
				KeybindTitle.BackgroundTransparency = 1
				KeybindTitle.Position = UDim2.new(0, 10, 0, 0)
				KeybindTitle.Size = UDim2.new(0, 250, 1, 0)
				KeybindTitle.Font = Enum.Font.GothamMedium
				KeybindTitle.Text = text
				KeybindTitle.TextColor3 = Colors.TextNormal
				KeybindTitle.TextSize = 13
				KeybindTitle.TextXAlignment = Enum.TextXAlignment.Left

				KeybindText.Name = "KeybindText"
				KeybindText.Parent = Keybind
				KeybindText.BackgroundColor3 = Colors.BackgroundDark
				KeybindText.AnchorPoint = Vector2.new(1, 0.5)
				KeybindText.Position = UDim2.new(1, -8, 0.5, 0)
				KeybindText.Size = UDim2.new(0, 70, 0, 24)
				KeybindText.Font = Enum.Font.GothamMedium
				KeybindText.Text = presetbind.Name
				KeybindText.TextColor3 = Colors.TextNormal
				KeybindText.TextSize = 12

				local KeybindTextCorner = Instance.new("UICorner")
				KeybindTextCorner.CornerRadius = UDim.new(0, 4)
				KeybindTextCorner.Parent = KeybindText

				Keybind.MouseButton1Click:Connect(function()
					KeybindText.Text = "..."
					local inputwait = UserInputService.InputBegan:Wait()
					if inputwait.KeyCode.Name ~= "Unknown" then
						KeybindText.Text = inputwait.KeyCode.Name
						Key = inputwait.KeyCode.Name
					end
				end)

				UserInputService.InputBegan:Connect(function(current, pressed)
					if not pressed then
						if current.KeyCode.Name == Key then
							pcall(callback)
						end
					end
				end)

				ChannelHolder.CanvasSize = UDim2.new(0, 0, 0, ChannelHolderLayout.AbsoluteContentSize.Y)
			end

			return ChannelContent
		end

		return ChannelHold
	end

	return ServerHold
end

return DiscordLib
