--//============================================================//
--// 🌻 KYOSH GARDEN UTILITY
--// Advanced Garden UI
--//============================================================//
--//
--// GARDEN TOOLS
--//   ⚡ Instant E
--//   ☁ Float
--//   🪑 Anti Sit
--//   ☄️ Meteor TP
--//
--// GARDEN PERFORMANCE
--//   ⚡ FPS Boost
--//   ☀ Normal Graphics
--//   ✦ Effects
--//   🍂 Low Graphics
--//   🗑 Garden Remove
--//
--//============================================================//

local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

--//============================================================//
--// NETWORKING
--//============================================================//

local Networking = nil

pcall(function()
    local SharedModules = ReplicatedStorage:WaitForChild(
        "SharedModules",
        10
    )

    if SharedModules then
        local NetworkingModule = SharedModules:FindFirstChild(
            "Networking"
        )

        if NetworkingModule then
            Networking = require(NetworkingModule)
        end
    end
end)

--//============================================================//
--// REMOVE OLD GUI
--//============================================================//

local oldGui = PlayerGui:FindFirstChild(
    "GardenUtilityGUI"
)

if oldGui then
    oldGui:Destroy()
end

--// Remove old Moon Meteor GUI if it exists

local oldMeteorGui = PlayerGui:FindFirstChild(
    "MoonMeteorTeleport"
)

if oldMeteorGui then
    oldMeteorGui:Destroy()
end

--//============================================================//
--// COLORS
--//============================================================//

local colors = {

    -- Garden
    grass = Color3.fromRGB(53, 116, 51),
    grassLight = Color3.fromRGB(91, 157, 70),
    grassDark = Color3.fromRGB(31, 72, 34),
    leaf = Color3.fromRGB(71, 139, 65),
    leafDark = Color3.fromRGB(42, 91, 45),

    -- Soil
    soil = Color3.fromRGB(92, 61, 39),
    soilLight = Color3.fromRGB(123, 83, 52),
    soilDark = Color3.fromRGB(53, 35, 25),

    -- UI
    background = Color3.fromRGB(12, 21, 14),
    panel = Color3.fromRGB(21, 35, 23),
    panel2 = Color3.fromRGB(27, 45, 28),
    panel3 = Color3.fromRGB(34, 55, 34),

    -- Accents
    gold = Color3.fromRGB(242, 194, 86),
    goldDark = Color3.fromRGB(174, 128, 49),
    blue = Color3.fromRGB(64, 126, 170),
    purple = Color3.fromRGB(118, 88, 164),
    red = Color3.fromRGB(173, 69, 62),
    orange = Color3.fromRGB(190, 126, 54),

    -- Text
    text = Color3.fromRGB(239, 250, 228),
    subtext = Color3.fromRGB(157, 185, 145),
    muted = Color3.fromRGB(108, 133, 102),
    white = Color3.fromRGB(255, 255, 255),
    black = Color3.fromRGB(0, 0, 0)
}

--//============================================================//
--// FEATURE STATES
--//============================================================//

local instantEEnabled = false
local floatEnabled = false
local antiSitEnabled = false
local fpsBoostEnabled = false
local lowGraphicsEnabled = false
local effectsRemoved = false

--// Meteor

local meteorTPEnabled = false
local meteorTeleporting = false
local meteorSavedCFrame = nil

local METEOR_TRAVEL_TIME = 3

--// Garden remover

local gardenRemoveEnabled = false

--//============================================================//
--// TELEPORT STORAGE
--//============================================================//

local savedCFrame1 = nil
local savedCFrame2 = nil

--//============================================================//
--// FLOAT
--//============================================================//

local floatConnection = nil
local floatHeight = 0
local floatStartY = nil

--//============================================================//
--// HELPERS
--//============================================================//

local function create(className, properties, parent)

    local object = Instance.new(className)

    for property, value in pairs(properties or {}) do
        object[property] = value
    end

    object.Parent = parent

    return object
end

local function corner(object, radius)

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = object

    return c
end

local function stroke(
    object,
    color,
    thickness,
    transparency
)

    local s = Instance.new("UIStroke")

    s.Color = color
    s.Thickness = thickness or 1
    s.Transparency = transparency or 0
    s.Parent = object

    return s
end

local function gradient(
    object,
    color1,
    color2,
    rotation
)

    local g = Instance.new("UIGradient")

    g.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color1),
        ColorSequenceKeypoint.new(1, color2)
    })

    g.Rotation = rotation or 90
    g.Parent = object

    return g
end

local function tween(
    object,
    duration,
    properties
)

    return TweenService:Create(
        object,
        TweenInfo.new(
            duration,
            Enum.EasingStyle.Quart,
            Enum.EasingDirection.Out
        ),
        properties
    )
end

--//============================================================//
--// MAIN GUI
--//============================================================//

local gui = create("ScreenGui", {

    Name = "GardenUtilityGUI",

    ResetOnSpawn = false,

    ZIndexBehavior =
        Enum.ZIndexBehavior.Sibling

}, PlayerGui)

--//============================================================//
--// MAIN FRAME
--//============================================================//

local main = create("Frame", {

    Name = "GardenMenu",

    Size = UDim2.new(
        0,
        430,
        0,
        475
    ),

    Position = UDim2.new(
        0.5,
        -215,
        0.07,
        0
    ),

    BackgroundColor3 =
        colors.background,

    BorderSizePixel = 0,

    Active = true

}, gui)

corner(main, 22)

local mainStroke = stroke(
    main,
    colors.grassLight,
    1.5,
    0.45
)

--//============================================================//
--// SHADOW
--//============================================================//

local shadow = create("Frame", {

    Name = "Shadow",

    Size = UDim2.new(
        1,
        14,
        1,
        14
    ),

    Position = UDim2.new(
        0,
        -7,
        0,
        8
    ),

    BackgroundColor3 =
        colors.black,

    BackgroundTransparency = 0.55,

    BorderSizePixel = 0,

    ZIndex = 0

}, main)

corner(shadow, 26)

--//============================================================//
--// DRAG SYSTEM
--//============================================================//

local dragging = false
local dragStart = nil
local startPosition = nil

local function beginDrag(input)

    dragging = true
    dragStart = input.Position
    startPosition = main.Position

    input.Changed:Connect(function()

        if input.UserInputState ==
            Enum.UserInputState.End then

            dragging = false

        end

    end)

end

local function updateDrag(input)

    if not dragging then
        return
    end

    local delta =
        input.Position - dragStart

    main.Position = UDim2.new(

        startPosition.X.Scale,

        startPosition.X.Offset +
            delta.X,

        startPosition.Y.Scale,

        startPosition.Y.Offset +
            delta.Y

    )

end

main.InputBegan:Connect(function(input)

    if input.UserInputType ==
        Enum.UserInputType.MouseButton1

        or input.UserInputType ==
        Enum.UserInputType.Touch then

        beginDrag(input)

    end

end)

UserInputService.InputChanged:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            updateDrag(input)

        end

    end
)

--//============================================================//
--// HEADER
--//============================================================//

local header = create("Frame", {

    Name = "Header",

    Size = UDim2.new(
        1,
        0,
        0,
        82
    ),

    BackgroundColor3 =
        colors.soilDark,

    BorderSizePixel = 0,

    ZIndex = 3

}, main)

corner(header, 22)

gradient(
    header,
    colors.soil,
    colors.soilDark,
    90
)

local grassLine = create("Frame", {

    Size = UDim2.new(
        1,
        0,
        0,
        5
    ),

    Position = UDim2.new(
        0,
        0,
        1,
        -5
    ),

    BackgroundColor3 =
        colors.grassLight,

    BorderSizePixel = 0,

    ZIndex = 5

}, header)

corner(grassLine, 3)

--//============================================================//
--// HEADER FLOWER
--//============================================================//

local flower = create("TextLabel", {

    Size = UDim2.new(
        0,
        45,
        0,
        45
    ),

    Position = UDim2.new(
        0,
        13,
        0,
        14
    ),

    BackgroundTransparency = 1,

    Text = "🌻",

    TextSize = 29,

    ZIndex = 6

}, header)

--//============================================================//
--// TITLE
--//============================================================//

local title = create("TextLabel", {

    Size = UDim2.new(
        1,
        -135,
        0,
        27
    ),

    Position = UDim2.new(
        0,
        60,
        0,
        11
    ),

    BackgroundTransparency = 1,

    Text = "KYOSH GARDEN",

    TextColor3 = colors.text,

    TextSize = 20,

    Font = Enum.Font.GothamBlack,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    ZIndex = 6

}, header)

local subtitle = create("TextLabel", {

    Size = UDim2.new(
        1,
        -135,
        0,
        20
    ),

    Position = UDim2.new(
        0,
        61,
        0,
        39
    ),

    BackgroundTransparency = 1,

    Text = "Your personal garden utility",

    TextColor3 = Color3.fromRGB(
        205,
        170,
        117
    ),

    TextSize = 9,

    Font = Enum.Font.GothamMedium,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    ZIndex = 6

}, header)

--//============================================================//
--// MINIMIZE BUTTON
--//============================================================//

local minimize = create("TextButton", {

    Name = "Minimize",

    Size = UDim2.new(
        0,
        36,
        0,
        30
    ),

    Position = UDim2.new(
        1,
        -48,
        0,
        11
    ),

    BackgroundColor3 =
        colors.soilDark,

    BorderSizePixel = 0,

    Text = "−",

    TextColor3 = colors.text,

    TextSize = 20,

    Font = Enum.Font.GothamBold,

    AutoButtonColor = false,

    ZIndex = 10

}, main)

corner(minimize, 9)

stroke(
    minimize,
    colors.gold,
    1,
    0.45
)

--//============================================================//
--// CONTENT
--//============================================================//

local content = create("Frame", {

    Name = "Content",

    Size = UDim2.new(
        1,
        -30,
        1,
        -137
    ),

    Position = UDim2.new(
        0,
        15,
        0,
        95
    ),

    BackgroundTransparency = 1,

    ZIndex = 5

}, main)

--//============================================================//
--// STATUS
--//============================================================//

local statusContainer = create("Frame", {

    Name = "Status",

    Size = UDim2.new(
        1,
        -30,
        0,
        28
    ),

    Position = UDim2.new(
        0,
        15,
        1,
        -39
    ),

    BackgroundColor3 =
        colors.panel,

    BorderSizePixel = 0,

    ZIndex = 8

}, main)

corner(statusContainer, 9)

stroke(
    statusContainer,
    colors.grass,
    1,
    0.7
)

local statusDot = create("TextLabel", {

    Size = UDim2.new(
        0,
        24,
        1,
        0
    ),

    Position = UDim2.new(
        0,
        6,
        0,
        0
    ),

    BackgroundTransparency = 1,

    Text = "●",

    TextColor3 =
        colors.grassLight,

    TextSize = 11,

    ZIndex = 9

}, statusContainer)

local status = create("TextLabel", {

    Size = UDim2.new(
        1,
        -38,
        1,
        0
    ),

    Position = UDim2.new(
        0,
        30,
        0,
        0
    ),

    BackgroundTransparency = 1,

    Text = "Garden ready",

    TextColor3 =
        colors.subtext,

    TextSize = 9,

    Font = Enum.Font.GothamMedium,

    TextXAlignment =
        Enum.TextXAlignment.Left,

    ZIndex = 9

}, statusContainer)

local function setStatus(
    text,
    color
)

    status.Text = text

    status.TextColor3 =
        color or colors.subtext

    statusDot.TextColor3 =
        color or colors.grassLight

end

--//============================================================//
--// ADVANCED MENU BUTTON
--//============================================================//

local function createMenuButton(
    parent,
    icon,
    titleText,
    description,
    y,
    accentColor,
    callback
)

    local button = create("TextButton", {

        Name = titleText,

        Size = UDim2.new(
            1,
            0,
            0,
            72
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            y
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        Text = "",

        AutoButtonColor = false,

        ZIndex = 7

    }, parent)

    corner(button, 15)

    local buttonStroke = stroke(
        button,
        accentColor,
        1,
        0.72
    )

    local iconFrame = create("Frame", {

        Size = UDim2.new(
            0,
            48,
            0,
            48
        ),

        Position = UDim2.new(
            0,
            11,
            0.5,
            -24
        ),

        BackgroundColor3 =
            accentColor:Lerp(
                colors.background,
                0.55
            ),

        BorderSizePixel = 0,

        ZIndex = 8

    }, button)

    corner(iconFrame, 13)

    stroke(
        iconFrame,
        accentColor,
        1,
        0.5
    )

    local iconLabel = create("TextLabel", {

        Size = UDim2.new(
            1,
            0,
            1,
            0
        ),

        BackgroundTransparency = 1,

        Text = icon,

        TextSize = 21,

        ZIndex = 9

    }, iconFrame)

    local titleLabel = create("TextLabel", {

        Size = UDim2.new(
            1,
            -115,
            0,
            23
        ),

        Position = UDim2.new(
            0,
            72,
            0,
            12
        ),

        BackgroundTransparency = 1,

        Text = titleText,

        TextColor3 =
            colors.text,

        TextSize = 12,

        Font = Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, button)

    local descriptionLabel = create("TextLabel", {

        Size = UDim2.new(
            1,
            -115,
            0,
            20
        ),

        Position = UDim2.new(
            0,
            72,
            0,
            35
        ),

        BackgroundTransparency = 1,

        Text = description,

        TextColor3 =
            colors.subtext,

        TextSize = 8,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, button)

    local arrow = create("TextLabel", {

        Size = UDim2.new(
            0,
            30,
            0,
            30
        ),

        Position = UDim2.new(
            1,
            -42,
            0.5,
            -15
        ),

        BackgroundTransparency = 1,

        Text = "›",

        TextColor3 =
            colors.muted,

        TextSize = 25,

        Font = Enum.Font.GothamBold,

        ZIndex = 9

    }, button)

    button.MouseEnter:Connect(
        function()

            tween(button, 0.14, {

                BackgroundColor3 =
                    colors.panel2

            }):Play()

            tween(buttonStroke, 0.14, {

                Transparency = 0.25

            }):Play()

            tween(iconFrame, 0.14, {

                BackgroundColor3 =
                    accentColor:Lerp(
                        colors.background,
                        0.35
                    )

            }):Play()

            tween(arrow, 0.14, {

                TextColor3 =
                    accentColor,

                Position = UDim2.new(
                    1,
                    -38,
                    0.5,
                    -15
                )

            }):Play()

        end
    )

    button.MouseLeave:Connect(
        function()

            tween(button, 0.14, {

                BackgroundColor3 =
                    colors.panel

            }):Play()

            tween(buttonStroke, 0.14, {

                Transparency = 0.72

            }):Play()

            tween(iconFrame, 0.14, {

                BackgroundColor3 =
                    accentColor:Lerp(
                        colors.background,
                        0.55
                    )

            }):Play()

            tween(arrow, 0.14, {

                TextColor3 =
                    colors.muted,

                Position = UDim2.new(
                    1,
                    -42,
                    0.5,
                    -15
                )

            }):Play()

        end
    )

    button.MouseButton1Down:Connect(
        function()

            tween(button, 0.07, {

                BackgroundColor3 =
                    accentColor:Lerp(
                        colors.background,
                        0.72
                    )

            }):Play()

        end
    )

    button.MouseButton1Up:Connect(
        function()

            tween(button, 0.1, {

                BackgroundColor3 =
                    colors.panel2

            }):Play()

        end
    )

    button.MouseButton1Click:Connect(
        function()

            if callback then
                callback()
            end

        end
    )

    return button
end

--//============================================================//
--// TOGGLE BUTTON
--//============================================================//

local function updateToggleVisual(
    button,
    enabled,
    onColor
)

    button:SetAttribute(
        "ToggleEnabled",
        enabled
    )

    local buttonStroke =
        button:FindFirstChildOfClass(
            "UIStroke"
        )

    tween(button, 0.12, {

        BackgroundColor3 =
            enabled
            and onColor
            or colors.panel

    }):Play()

    if buttonStroke then

        tween(buttonStroke, 0.12, {

            Color =
                enabled
                and onColor
                or colors.grass,

            Transparency =
                enabled
                and 0.3
                or 0.72

        }):Play()

    end
end

local function createToggle(
    parent,
    text,
    x,
    y,
    width,
    height,
    enabled,
    onColor
)

    local button = create("TextButton", {

        Size = UDim2.new(
            0,
            width,
            0,
            height
        ),

        Position = UDim2.new(
            0,
            x,
            0,
            y
        ),

        BackgroundColor3 =
            enabled
            and onColor
            or colors.panel,

        BorderSizePixel = 0,

        Text = text,

        TextColor3 =
            colors.text,

        TextSize = 9,

        Font = Enum.Font.GothamBold,

        AutoButtonColor = false,

        ZIndex = 8

    }, parent)

    button:SetAttribute(
        "ToggleEnabled",
        enabled
    )

    corner(button, 12)

    local buttonStroke = stroke(
        button,
        enabled
        and onColor
        or colors.grass,
        1,
        enabled
        and 0.3
        or 0.72
    )

    button.MouseEnter:Connect(
        function()

            local isEnabled =
                button:GetAttribute(
                    "ToggleEnabled"
                ) == true

            tween(button, 0.12, {

                BackgroundColor3 =
                    isEnabled

                    and onColor:Lerp(
                        colors.white,
                        0.08
                    )

                    or colors.panel2

            }):Play()

            tween(buttonStroke, 0.12, {

                Color =
                    isEnabled
                    and onColor
                    or colors.grass,

                Transparency = 0.3

            }):Play()

        end
    )

    button.MouseLeave:Connect(
        function()

            local isEnabled =
                button:GetAttribute(
                    "ToggleEnabled"
                ) == true

            tween(button, 0.12, {

                BackgroundColor3 =
                    isEnabled
                    and onColor
                    or colors.panel

            }):Play()

            tween(buttonStroke, 0.12, {

                Color =
                    isEnabled
                    and onColor
                    or colors.grass,

                Transparency =
                    isEnabled
                    and 0.3
                    or 0.72

            }):Play()

        end
    )

    return button
end

--//============================================================//
--// PAGE SYSTEM
--//============================================================//

local currentPage = "MENU"
local minimized = false

local showMainMenu
local showGameFeatures
local showPerformance
local showTeleport

local function clearPage()

    for _, object in ipairs(
        content:GetChildren()
    ) do

        object:Destroy()

    end

end

local function resizeFrame(height)

    if minimized then
        return
    end

    tween(main, 0.22, {

        Size = UDim2.new(
            0,
            430,
            0,
            height
        )

    }):Play()

end

--//============================================================//
--// PLAYER AVATAR
--//============================================================//

local function createWelcomeCard()

    local card = create("Frame", {

        Size = UDim2.new(
            1,
            0,
            0,
            92
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            0
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        ZIndex = 7

    }, content)

    corner(card, 16)

    stroke(
        card,
        colors.gold,
        1,
        0.62
    )

    gradient(
        card,
        colors.panel2,
        colors.panel,
        90
    )

    local avatarFrame = create("Frame", {

        Size = UDim2.new(
            0,
            66,
            0,
            66
        ),

        Position = UDim2.new(
            0,
            13,
            0.5,
            -33
        ),

        BackgroundColor3 =
            colors.grassDark,

        BorderSizePixel = 0,

        ZIndex = 8

    }, card)

    corner(avatarFrame, 18)

    stroke(
        avatarFrame,
        colors.grassLight,
        2,
        0.35
    )

    local avatar = create("ImageLabel", {

        Size = UDim2.new(
            1,
            -6,
            1,
            -6
        ),

        Position = UDim2.new(
            0,
            3,
            0,
            3
        ),

        BackgroundTransparency = 1,

        ZIndex = 9

    }, avatarFrame)

    corner(avatar, 15)

    task.spawn(function()

        local success, image =
            pcall(function()

                return Players:
                    GetUserThumbnailAsync(
                        player.UserId,
                        Enum.ThumbnailType.HeadShot,
                        Enum.ThumbnailSize.Size100x100
                    )

            end)

        if success and image then
            avatar.Image = image
        end

    end)

    create("TextLabel", {

        Size = UDim2.new(
            1,
            -170,
            0,
            20
        ),

        Position = UDim2.new(
            0,
            91,
            0,
            12
        ),

        BackgroundTransparency = 1,

        Text = "WELCOME TO YOUR GARDEN",

        TextColor3 =
            colors.gold,

        TextSize = 10,

        Font = Enum.Font.GothamBlack,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, card)

    create("TextLabel", {

        Size = UDim2.new(
            1,
            -170,
            0,
            25
        ),

        Position = UDim2.new(
            0,
            91,
            0,
            31
        ),

        BackgroundTransparency = 1,

        Text = player.DisplayName,

        TextColor3 =
            colors.text,

        TextSize = 16,

        Font = Enum.Font.GothamBlack,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        TextTruncate =
            Enum.TextTruncate.AtEnd,

        ZIndex = 8

    }, card)

    create("TextLabel", {

        Size = UDim2.new(
            1,
            -170,
            0,
            18
        ),

        Position = UDim2.new(
            0,
            91,
            0,
            55
        ),

        BackgroundTransparency = 1,

        Text = "@" .. player.Name,

        TextColor3 =
            colors.subtext,

        TextSize = 9,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        TextTruncate =
            Enum.TextTruncate.AtEnd,

        ZIndex = 8

    }, card)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            60,
            0,
            60
        ),

        Position = UDim2.new(
            1,
            -73,
            0.5,
            -30
        ),

        BackgroundTransparency = 1,

        Text = "🌱",

        TextSize = 30,

        ZIndex = 8

    }, card)

    return card
end

--//============================================================//
--// PAGE HEADER
--//============================================================//

local function createPageHeader(
    icon,
    titleText,
    description
)

    local iconFrame = create("Frame", {

        Size = UDim2.new(
            0,
            45,
            0,
            45
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            0
        ),

        BackgroundColor3 =
            colors.grassDark,

        BorderSizePixel = 0,

        ZIndex = 8

    }, content)

    corner(iconFrame, 13)

    stroke(
        iconFrame,
        colors.grassLight,
        1,
        0.5
    )

    create("TextLabel", {

        Size = UDim2.new(
            1,
            0,
            1,
            0
        ),

        BackgroundTransparency = 1,

        Text = icon,

        TextSize = 22,

        ZIndex = 9

    }, iconFrame)

    create("TextLabel", {

        Size = UDim2.new(
            1,
            -58,
            0,
            24
        ),

        Position = UDim2.new(
            0,
            58,
            0,
            0
        ),

        BackgroundTransparency = 1,

        Text = titleText,

        TextColor3 =
            colors.text,

        TextSize = 15,

        Font = Enum.Font.GothamBlack,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, content)

    create("TextLabel", {

        Size = UDim2.new(
            1,
            -58,
            0,
            18
        ),

        Position = UDim2.new(
            0,
            58,
            0,
            25
        ),

        BackgroundTransparency = 1,

        Text = description,

        TextColor3 =
            colors.subtext,

        TextSize = 8,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, content)

end

--//============================================================//
--// BACK BUTTON
--//============================================================//

local function createBackButton()

    local back = create("TextButton", {

        Size = UDim2.new(
            0,
            80,
            0,
            30
        ),

        Position = UDim2.new(
            1,
            -80,
            0,
            7
        ),

        BackgroundColor3 =
            colors.panel2,

        BorderSizePixel = 0,

        Text = "‹  BACK",

        TextColor3 =
            colors.subtext,

        TextSize = 8,

        Font = Enum.Font.GothamBold,

        AutoButtonColor = false,

        ZIndex = 10

    }, content)

    corner(back, 9)

    back.MouseEnter:Connect(
        function()

            tween(back, 0.12, {

                BackgroundColor3 =
                    colors.panel3,

                TextColor3 =
                    colors.text

            }):Play()

        end
    )

    back.MouseLeave:Connect(
        function()

            tween(back, 0.12, {

                BackgroundColor3 =
                    colors.panel2,

                TextColor3 =
                    colors.subtext

            }):Play()

        end
    )

    back.MouseButton1Click:Connect(
        function()
            showMainMenu()
        end
    )

end

--//============================================================//
--// INSTANT E
--//============================================================//

local originalHoldDurations = {}

local function savePromptDuration(prompt)

    if originalHoldDurations[prompt] == nil then

        originalHoldDurations[prompt] =
            prompt.HoldDuration

    end

end

local function makePromptInstant(prompt)

    if not prompt
        or not prompt.Parent then
        return
    end

    savePromptDuration(prompt)

    prompt.HoldDuration = 0

end

local function enableInstantE()

    instantEEnabled = true

    for _, object in ipairs(
        Workspace:GetDescendants()
    ) do

        if object:IsA(
            "ProximityPrompt"
        ) then

            makePromptInstant(object)

        end

    end

    setStatus(
        "Instant E enabled",
        colors.grassLight
    )

end

local function disableInstantE()

    instantEEnabled = false

    for prompt, duration in pairs(
        originalHoldDurations
    ) do

        if prompt
            and prompt.Parent then

            prompt.HoldDuration =
                duration

        end

    end

    setStatus(
        "Instant E disabled",
        colors.subtext
    )

end

Workspace.DescendantAdded:Connect(
    function(object)

        if object:IsA(
            "ProximityPrompt"
        )
            and instantEEnabled then

            makePromptInstant(object)

        end

    end
)

--//============================================================//
--// FLOAT
--//============================================================//

local function stopFloat()

    if floatConnection then

        floatConnection:Disconnect()
        floatConnection = nil

    end

    floatStartY = nil

end

local function startFloat()

    stopFloat()

    local character =
        player.Character

    if not character then

        floatEnabled = false

        return false

    end

    local root =
        character:FindFirstChild(
            "HumanoidRootPart"
        )

    if not root then

        floatEnabled = false

        return false

    end

    floatStartY =
        root.Position.Y

    floatConnection =
        RunService.Heartbeat:Connect(
            function()

                if not floatEnabled then
                    return
                end

                local currentCharacter =
                    player.Character

                if not currentCharacter then
                    return
                end

                local currentRoot =
                    currentCharacter:
                    FindFirstChild(
                        "HumanoidRootPart"
                    )

                if not currentRoot then
                    return
                end

                local targetY =
                    floatStartY +
                    floatHeight

                local position =
                    currentRoot.Position

                currentRoot.AssemblyLinearVelocity =
                    Vector3.new(
                        currentRoot.AssemblyLinearVelocity.X,
                        0,
                        currentRoot.AssemblyLinearVelocity.Z
                    )

                currentRoot.CFrame =
                    CFrame.new(
                        position.X,
                        targetY,
                        position.Z
                    )
                    *
                    (
                        currentRoot.CFrame -
                        currentRoot.CFrame.Position
                    )

            end
        )

    return true
end

local function toggleFloat()

    floatEnabled =
        not floatEnabled

    if floatEnabled then

        if not startFloat() then

            setStatus(
                "Character not found",
                colors.red
            )

            return

        end

        setStatus(
            "Float enabled  •  +" ..
            tostring(floatHeight),
            colors.grassLight
        )

    else

        stopFloat()

        setStatus(
            "Float disabled",
            colors.subtext
        )

    end
end

--//============================================================//
--// ANTI SIT
--//============================================================//

local antiSitConnection = nil
local antiSitStateConnection = nil

local function disconnectAntiSit()

    if antiSitConnection then

        antiSitConnection:Disconnect()
        antiSitConnection = nil

    end

    if antiSitStateConnection then

        antiSitStateConnection:Disconnect()
        antiSitStateConnection = nil

    end

end

local function setupAntiSit(character)

    disconnectAntiSit()

    if not antiSitEnabled then
        return
    end

    local humanoid =
        character:WaitForChild(
            "Humanoid",
            10
        )

    if not humanoid then
        return
    end

    antiSitConnection =
        RunService.Heartbeat:Connect(
            function()

                if not antiSitEnabled then
                    return
                end

                if not humanoid
                    or not humanoid.Parent then
                    return
                end

                if humanoid.Sit then
                    humanoid.Sit = false
                end

                if humanoid:GetState()
                    ==
                    Enum.HumanoidStateType.Seated then

                    humanoid.Sit = false

                    humanoid:ChangeState(
                        Enum.HumanoidStateType.GettingUp
                    )

                end

            end
        )

    antiSitStateConnection =
        humanoid.StateChanged:Connect(
            function(_, newState)

                if not antiSitEnabled then
                    return
                end

                if newState ==
                    Enum.HumanoidStateType.Seated then

                    humanoid.Sit = false

                    task.defer(function()

                        if humanoid
                            and humanoid.Parent
                            and antiSitEnabled then

                            humanoid:ChangeState(
                                Enum.HumanoidStateType.GettingUp
                            )

                        end

                    end)

                end

            end
        )

end

--//============================================================//
--// PERFORMANCE
--//============================================================//

local savedEffects = {}

local savedLighting = {

    GlobalShadows =
        Lighting.GlobalShadows,

    Brightness =
        Lighting.Brightness,

    FogEnd =
        Lighting.FogEnd

}

local lowGraphicsOriginals = {}

local function saveEffect(object)

    if savedEffects[object] ~= nil then
        return
    end

    if object:IsA("ParticleEmitter")
        or object:IsA("Trail")
        or object:IsA("Beam")
        or object:IsA("Smoke")
        or object:IsA("Fire")
        or object:IsA("Sparkles")
        or object:IsA("BloomEffect")
        or object:IsA("BlurEffect")
        or object:IsA("ColorCorrectionEffect")
        or object:IsA("SunRaysEffect")
        or object:IsA("DepthOfFieldEffect") then

        savedEffects[object] = {

            Enabled =
                object.Enabled

        }

    end

end

local function enableFPSBoost()

    fpsBoostEnabled = true

    Lighting.GlobalShadows = false

    for _, object in ipairs(
        Lighting:GetChildren()
    ) do

        if object:IsA("BloomEffect")
            or object:IsA("BlurEffect")
            or object:IsA("ColorCorrectionEffect")
            or object:IsA("SunRaysEffect")
            or object:IsA("DepthOfFieldEffect") then

            saveEffect(object)

            object.Enabled = false

        end

    end

    for _, object in ipairs(
        Workspace:GetDescendants()
    ) do

        if object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Beam")
            or object:IsA("Smoke")
            or object:IsA("Fire")
            or object:IsA("Sparkles") then

            saveEffect(object)

            object.Enabled = false

        end

    end

    setStatus(
        "Garden FPS boost enabled",
        colors.grassLight
    )

end

local function disableFPSBoost()

    fpsBoostEnabled = false

    Lighting.GlobalShadows =
        savedLighting.GlobalShadows

    for object, settings in pairs(
        savedEffects
    ) do

        if object
            and object.Parent then

            object.Enabled =
                settings.Enabled

        end

    end

    setStatus(
        "Garden FPS boost disabled",
        colors.subtext
    )

end

local function enableLowGraphics()

    lowGraphicsEnabled = true

    for _, object in ipairs(
        Workspace:GetDescendants()
    ) do

        if object:IsA("BasePart") then

            if lowGraphicsOriginals[object] == nil then

                lowGraphicsOriginals[object] = {

                    Material =
                        object.Material,

                    CastShadow =
                        object.CastShadow

                }

            end

            object.Material =
                Enum.Material.SmoothPlastic

            object.CastShadow = false

        end

    end

    setStatus(
        "Low graphics enabled",
        colors.orange
    )

end

local function disableLowGraphics()

    lowGraphicsEnabled = false

    for object, data in pairs(
        lowGraphicsOriginals
    ) do

        if object
            and object.Parent
            and data then

            object.Material =
                data.Material

            object.CastShadow =
                data.CastShadow

        end

    end

    setStatus(
        "Low graphics disabled",
        colors.subtext
    )

end

local function removeAllEffects()

    effectsRemoved = true

    for _, object in ipairs(
        Workspace:GetDescendants()
    ) do

        if object:IsA("ParticleEmitter")
            or object:IsA("Trail")
            or object:IsA("Beam")
            or object:IsA("Smoke")
            or object:IsA("Fire")
            or object:IsA("Sparkles") then

            saveEffect(object)

            object.Enabled = false

        end

    end

    for _, object in ipairs(
        Lighting:GetChildren()
    ) do

        if object:IsA("BloomEffect")
            or object:IsA("BlurEffect")
            or object:IsA("ColorCorrectionEffect")
            or object:IsA("SunRaysEffect")
            or object:IsA("DepthOfFieldEffect") then

            saveEffect(object)

            object.Enabled = false

        end

    end

    setStatus(
        "Effects removed",
        colors.purple
    )

end

local function restoreEffects()

    effectsRemoved = false

    for object, settings in pairs(
        savedEffects
    ) do

        if object
            and object.Parent then

            object.Enabled =
                settings.Enabled

        end

    end

    setStatus(
        "Effects restored",
        colors.blue
    )

end

--//============================================================//
--// GARDEN REMOVER
--//============================================================//

local function getGardens()

    return Workspace:FindFirstChild(
        "Gardens"
    )

end

local function getPlotNumber(object)

    if not object then
        return nil
    end

    local number =
        string.match(
            object.Name,
            "^Plot(%d+)$"
        )

    if number then
        return tonumber(number)
    end

    return nil
end

local function getGardenPlot(object)

    local Gardens =
        getGardens()

    if not Gardens
        or not object then

        return nil

    end

    local current = object

    while current
        and current ~= Gardens do

        local plotNumber =
            getPlotNumber(current)

        if plotNumber
            and plotNumber >= 1
            and plotNumber <= 8 then

            return current

        end

        current =
            current.Parent

    end

    return nil
end

local function removeFenceObject(object)

    if not gardenRemoveEnabled then
        return
    end

    if not object then
        return
    end

    if object.Name ~=
        "FenceConnectors"

        and object.Name ~=
        "FencePole" then

        return

    end

    local plot =
        getGardenPlot(object)

    if not plot then
        return
    end

    local plotNumber =
        getPlotNumber(plot)

    if not plotNumber then
        return
    end

    if plotNumber < 1
        or plotNumber > 8 then

        return

    end

    if object.Parent then
        object:Destroy()
    end

end

local function removePlotFences(plot)

    if not gardenRemoveEnabled then
        return
    end

    if not plot then
        return
    end

    local plotNumber =
        getPlotNumber(plot)

    if not plotNumber then
        return
    end

    if plotNumber < 1
        or plotNumber > 8 then

        return

    end

    for _, object in ipairs(
        plot:GetDescendants()
    ) do

        if object.Name ==
            "FenceConnectors"

            or object.Name ==
            "FencePole" then

            object:Destroy()

        end

    end

end

local function removePlots3To8()

    if not gardenRemoveEnabled then
        return
    end

    local Gardens =
        getGardens()

    if not Gardens then
        return
    end

    for plotNumber = 3, 8 do

        local plot =
            Gardens:FindFirstChild(
                "Plot" ..
                plotNumber
            )

        if plot then
            plot:Destroy()
        end

    end

end

local function removeAllGardenFences()

    if not gardenRemoveEnabled then
        return
    end

    local Gardens =
        getGardens()

    if not Gardens then
        return
    end

    for plotNumber = 1, 8 do

        local plot =
            Gardens:FindFirstChild(
                "Plot" ..
                plotNumber
            )

        if plot then
            removePlotFences(plot)
        end

    end

end

local function removeGardenObjects()

    if not gardenRemoveEnabled then
        return
    end

    removePlots3To8()

    removeAllGardenFences()

end

--// Garden remover monitor

Workspace.DescendantAdded:Connect(
    function(object)

        if not gardenRemoveEnabled then
            return
        end

        -- Plot3 - Plot8

        local plotNumber =
            getPlotNumber(object)

        if plotNumber
            and plotNumber >= 3
            and plotNumber <= 8 then

            if object.Parent then
                object:Destroy()
            end

            return

        end

        -- Fence objects

        if object.Name ==
            "FenceConnectors"

            or object.Name ==
            "FencePole" then

            removeFenceObject(object)

        end

    end
)

--// Extra fast garden cleaner

task.spawn(function()

    while gui.Parent do

        if gardenRemoveEnabled then

            removeGardenObjects()

        end

        task.wait(0.05)

    end

end)

--//============================================================//
--// TELEPORT
--//============================================================//

local function getRoot()

    local character =
        player.Character

    if not character then
        return nil
    end

    return character:FindFirstChild(
        "HumanoidRootPart"
    )

end

local function teleportToCFrame(
    cframe,
    number
)

    if not cframe then

        setStatus(
            "Position " ..
            number ..
            " not saved",
            colors.red
        )

        return
    end

    local character =
        player.Character

    local root =
        getRoot()

    if not character
        or not root then

        return

    end

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    character:PivotTo(cframe)

    root.AssemblyLinearVelocity =
        Vector3.zero

    root.AssemblyAngularVelocity =
        Vector3.zero

    setStatus(
        "Teleported to Garden Plot " ..
        number,
        colors.blue
    )

end

local function teleportToPosition1()

    teleportToCFrame(
        savedCFrame1,
        1
    )

end

local function teleportToPosition2()

    teleportToCFrame(
        savedCFrame2,
        2
    )

end

--//============================================================//
--// ☄️ METEOR TELEPORT
--// ANCHORED PLATFORM + POSITION MAINTENANCE FIX
--//============================================================//

local meteorPlatform = nil
local meteorHoldConnection = nil

--//============================================================//
--// CREATE TEMPORARY METEOR PLATFORM
--//============================================================//

local function createMeteorPlatform(position)

    -- Remove old platform
    if meteorPlatform then

        pcall(function()
            meteorPlatform:Destroy()
        end)

        meteorPlatform = nil

    end

    local platform = Instance.new("Part")

    platform.Name = "TemporaryMeteorPlatform"

    platform.Size = Vector3.new(
        12,
        1,
        12
    )

    platform.CFrame = CFrame.new(
        position
    )

    platform.Anchored = true

    platform.CanCollide = true
    platform.CanTouch = true
    platform.CanQuery = true

    platform.Transparency = 1

    platform.CastShadow = false

    platform.Parent = workspace

    meteorPlatform = platform

    return platform

end


--//============================================================//
--// REMOVE TEMPORARY METEOR PLATFORM
--//============================================================//

local function removeMeteorPlatform()

    if meteorHoldConnection then

        meteorHoldConnection:Disconnect()

        meteorHoldConnection = nil

    end

    if meteorPlatform then

        pcall(function()
            meteorPlatform:Destroy()
        end)

        meteorPlatform = nil

    end

end


--//============================================================//
--// METEOR TELEPORT
--//============================================================//
--// FIXED: Character body is centered directly on the meteor target.
--// The temporary platform has been removed so it cannot interfere
--// with the meteor's own hit detection.
--// The character is continuously held at the strike position so
--// gravity/physics cannot make it fall away before impact.

local function handleMeteor(strikePosition)

    if not meteorTPEnabled then
        return
    end

    if meteorTeleporting then
        return
    end

    if typeof(strikePosition) ~= "Vector3" then
        return
    end

    local character = player.Character

    if not character then
        return
    end

    local root = character:FindFirstChild(
        "HumanoidRootPart"
    )

    local humanoid = character:FindFirstChildOfClass(
        "Humanoid"
    )

    if not root or not humanoid then
        return
    end

    --========================================================//
    -- SAVE ORIGINAL POSITION
    --========================================================//

    meteorSavedCFrame = character:GetPivot()
    meteorTeleporting = true

    --========================================================//
    -- REMOVE ANY OLD METEOR PLATFORM
    --========================================================//

    removeMeteorPlatform()

    --========================================================//
    -- STOP CURRENT MOVEMENT
    --========================================================//

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    humanoid:Move(
        Vector3.zero,
        false
    )

    --========================================================//
    -- TELEPORT DIRECTLY TO THE METEOR TARGET
    --========================================================//
    --
    -- Use the meteor's exact strikePosition.
    -- No head/body/height offset is applied.

    -- Use the meteor strike X/Z, but keep the character's body
    -- (HumanoidRootPart) at the strike height.
    local targetPosition = Vector3.new(
        strikePosition.X,
        strikePosition.Y,
        strikePosition.Z
    )

    local meteorCFrame = CFrame.new(targetPosition)

    character:PivotTo(meteorCFrame)

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    --========================================================//
    -- KEEP CHARACTER LOCKED TO THE METEOR TARGET
    --========================================================//

    local holdPosition = CFrame.new(targetPosition)

    meteorHoldConnection =
        RunService.Heartbeat:Connect(
            function()

                if not meteorTeleporting then
                    return
                end

                local currentCharacter = player.Character

                if not currentCharacter then
                    return
                end

                local currentRoot =
                    currentCharacter:FindFirstChild(
                        "HumanoidRootPart"
                    )

                local currentHumanoid =
                    currentCharacter:FindFirstChildOfClass(
                        "Humanoid"
                    )

                if not currentRoot or not currentHumanoid then
                    return
                end

                -- Stop gravity/physics from pulling the
                -- character away from the meteor target.
                currentRoot.AssemblyLinearVelocity =
                    Vector3.zero

                currentRoot.AssemblyAngularVelocity =
                    Vector3.zero

                currentHumanoid:Move(
                    Vector3.zero,
                    false
                )

                -- Re-apply the exact target position every frame.
                currentCharacter:PivotTo(
                    holdPosition
                )

            end
        )

    --========================================================//
    -- STATUS
    --========================================================//

    setStatus(
        "☄️ Locked onto meteor target",
        colors.gold
    )

    --========================================================//
    -- WAIT FOR METEOR
    --========================================================//

    task.wait(
        METEOR_TRAVEL_TIME
    )

    --========================================================//
    -- STOP HOLD CONNECTION
    --========================================================//

    if meteorHoldConnection then
        meteorHoldConnection:Disconnect()
        meteorHoldConnection = nil
    end

    --========================================================//
    -- CHECK TOGGLE
    --========================================================//

    if not meteorTPEnabled then

        meteorTeleporting = false
        meteorSavedCFrame = nil

        return

    end

    --========================================================//
    -- GET CHARACTER AGAIN
    --========================================================//

    character = player.Character

    if not character then

        meteorTeleporting = false
        meteorSavedCFrame = nil

        return

    end

    root = character:FindFirstChild(
        "HumanoidRootPart"
    )

    humanoid = character:FindFirstChildOfClass(
        "Humanoid"
    )

    if not root or not humanoid then

        meteorTeleporting = false
        meteorSavedCFrame = nil

        return

    end

    --========================================================//
    -- STOP MOVEMENT
    --========================================================//

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    humanoid:Move(
        Vector3.zero,
        false
    )

    --========================================================//
    -- RETURN TO ORIGINAL POSITION
    --========================================================//

    if meteorSavedCFrame then

        character:PivotTo(
            meteorSavedCFrame
        )

    end

    --========================================================//
    -- CLEAR PHYSICS
    --========================================================//

    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero

    --========================================================//
    -- RESET HUMANOID
    --========================================================//

    if humanoid.Health > 0 then

        humanoid:ChangeState(
            Enum.HumanoidStateType.GettingUp
        )

    end

    --========================================================//
    -- WAIT FOR POSITION TO REGISTER
    --========================================================//

    RunService.Heartbeat:Wait()

    --========================================================//
    -- FINAL POSITION CLEANUP
    --========================================================//

    character = player.Character

    if character then

        root = character:FindFirstChild(
            "HumanoidRootPart"
        )

        humanoid = character:FindFirstChildOfClass(
            "Humanoid"
        )

        if root then

            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

        end

        if humanoid then

            humanoid:Move(
                Vector3.zero,
                false
            )

        end

    end

    --========================================================//
    -- FINISH
    --========================================================//

    meteorSavedCFrame = nil
    meteorTeleporting = false

    setStatus(
        "☄️ Meteor completed • returned",
        colors.blue
    )

end

--//============================================================//
--// GOLD MOON
--//============================================================//

pcall(function()

    if Networking
        and Networking.WeatherEffects
        and Networking.WeatherEffects.GoldMoonStrike then

        Networking.WeatherEffects
            .GoldMoonStrike
            .OnClientEvent:Connect(
                function(strikePosition)

                    if not meteorTPEnabled then
                        return
                    end

                    task.spawn(
                        function()

                            handleMeteor(
                                strikePosition
                            )

                        end
                    )

                end
            )

    end

end)


--//============================================================//
--// RAINBOW MOON
--//============================================================//

pcall(function()

    if Networking
        and Networking.WeatherEffects
        and Networking.WeatherEffects.RainbowMoonStrike then

        Networking.WeatherEffects
            .RainbowMoonStrike
            .OnClientEvent:Connect(
                function(strikePosition)

                    if not meteorTPEnabled then
                        return
                    end

                    task.spawn(
                        function()

                            handleMeteor(
                                strikePosition
                            )

                        end
                    )

                end
            )

    end

end)

--//============================================================//
--// MOBILE TELEPORT BUTTONS
--//============================================================//

local mobileButtons = create("Frame", {

    Name = "MobileTeleportButtons",

    Size = UDim2.new(
        0,
        145,
        0,
        70
    ),

    Position = UDim2.new(
        1,
        -160,
        1,
        -155
    ),

    BackgroundTransparency = 1,

    Visible =
        UserInputService.TouchEnabled,

    Active = true,

    ZIndex = 50

}, gui)

local function createMobileTPButton(
    text,
    x,
    callback
)

    local button = create("TextButton", {

        Size = UDim2.new(
            0,
            62,
            0,
            62
        ),

        Position = UDim2.new(
            0,
            x,
            0,
            0
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        Text = text,

        TextColor3 =
            colors.text,

        TextSize = 10,

        Font = Enum.Font.GothamBlack,

        AutoButtonColor = false,

        ZIndex = 51

    }, mobileButtons)

    corner(button, 19)

    stroke(
        button,
        colors.grassLight,
        2,
        0.25
    )

    gradient(
        button,
        colors.grassDark,
        colors.soilDark,
        90
    )

    button.Activated:Connect(
        callback
    )

    return button
end

local mobileTP1 =
    createMobileTPButton(
        "🌱\nTP 1",
        0,
        teleportToPosition1
    )

local mobileTP2 =
    createMobileTPButton(
        "🌿\nTP 2",
        75,
        teleportToPosition2
    )

--//============================================================//
--// MOBILE DRAG
--//============================================================//

local mobileDragThreshold = 8

local function makeMobileButtonDraggable(
    button,
    callback
)

    local draggingButton = false
    local dragStartButton = nil
    local startButtonPosition = nil
    local moved = false

    button.InputBegan:Connect(
        function(input)

            if input.UserInputType ==
                Enum.UserInputType.Touch

                or input.UserInputType ==
                Enum.UserInputType.MouseButton1 then

                draggingButton = true
                moved = false

                dragStartButton =
                    input.Position

                startButtonPosition =
                    button.Position

                input.Changed:Connect(
                    function()

                        if input.UserInputState ==
                            Enum.UserInputState.End then

                            draggingButton = false

                            if not moved then
                                callback()
                            end

                        end

                    end
                )

            end

        end
    )

    UserInputService.InputChanged:Connect(
        function(input)

            if not draggingButton then
                return
            end

            if input.UserInputType ==
                Enum.UserInputType.Touch

                or input.UserInputType ==
                Enum.UserInputType.MouseMovement then

                local delta =
                    input.Position -
                    dragStartButton

                if math.abs(delta.X) >
                    mobileDragThreshold

                    or math.abs(delta.Y) >
                    mobileDragThreshold then

                    moved = true

                end

                button.Position =
                    UDim2.new(

                        startButtonPosition.X.Scale,

                        startButtonPosition.X.Offset +
                            delta.X,

                        startButtonPosition.Y.Scale,

                        startButtonPosition.Y.Offset +
                            delta.Y

                    )

            end

        end
    )

end

makeMobileButtonDraggable(
    mobileTP1,
    teleportToPosition1
)

makeMobileButtonDraggable(
    mobileTP2,
    teleportToPosition2
)

--//============================================================//
--// MAIN MENU
--//============================================================//

showMainMenu = function()

    currentPage = "MENU"

    clearPage()

    resizeFrame(475)

    createWelcomeCard()

    createMenuButton(
        content,
        "🎮",
        "GARDEN TOOLS",
        "Instant E, Float, Anti Sit and Meteor TP",
        103,
        colors.grass,
        showGameFeatures
    )

    createMenuButton(
        content,
        "⚡",
        "GARDEN PERFORMANCE",
        "FPS Boost, graphics, effects and Garden Remove",
        183,
        colors.blue,
        showPerformance
    )

    createMenuButton(
        content,
        "📍",
        "GARDEN TELEPORTATION",
        "Save and teleport to garden plots",
        263,
        colors.soilLight,
        showTeleport
    )

    create("TextLabel", {

        Size = UDim2.new(
            1,
            0,
            0,
            22
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            343
        ),

        BackgroundTransparency = 1,

        Text =
            "🌾  GROW  •  HARVEST  •  EXPLORE  🌾",

        TextColor3 =
            colors.muted,

        TextSize = 8,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Center,

        ZIndex = 7

    }, content)

end

--//============================================================//
--// GAME FEATURES
--//============================================================//

showGameFeatures = function()

    currentPage = "GAME"

    clearPage()

    resizeFrame(475)

    createPageHeader(
        "🎮",
        "GARDEN TOOLS",
        "Movement and gameplay utilities"
    )

    createBackButton()

    local instantE =
        createToggle(
            content,

            instantEEnabled
            and "⚡  INSTANT E  •  ON"
            or "⚡  INSTANT E  •  OFF",

            0,
            64,
            185,
            48,

            instantEEnabled,
            colors.grass
        )

    local floatButton =
        createToggle(
            content,

            floatEnabled
            and "☁  FLOAT  •  ON"
            or "☁  FLOAT  •  OFF",

            197,
            64,
            185,
            48,

            floatEnabled,
            colors.grass
        )

    --// Float card

    local floatCard = create("Frame", {

        Size = UDim2.new(
            1,
            0,
            0,
            66
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            123
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        ZIndex = 7

    }, content)

    corner(floatCard, 14)

    stroke(
        floatCard,
        colors.grass,
        1,
        0.72
    )

    create("TextLabel", {

        Size = UDim2.new(
            0,
            180,
            0,
            20
        ),

        Position = UDim2.new(
            0,
            13,
            0,
            8
        ),

        BackgroundTransparency = 1,

        Text = "☁  FLOAT HEIGHT",

        TextColor3 =
            colors.text,

        TextSize = 9,

        Font = Enum.Font.GothamBold,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, floatCard)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            180,
            0,
            17
        ),

        Position = UDim2.new(
            0,
            13,
            0,
            31
        ),

        BackgroundTransparency = 1,

        Text = "Choose a height from 0 to 10",

        TextColor3 =
            colors.muted,

        TextSize = 7,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, floatCard)

    local floatBox = create("TextBox", {

        Size = UDim2.new(
            0,
            155,
            0,
            40
        ),

        Position = UDim2.new(
            1,
            -168,
            0,
            13
        ),

        BackgroundColor3 =
            colors.panel3,

        BorderSizePixel = 0,

        Text =
            tostring(floatHeight),

        PlaceholderText = "0 - 10",

        TextColor3 =
            colors.text,

        PlaceholderColor3 =
            colors.muted,

        TextSize = 11,

        Font = Enum.Font.GothamBold,

        ClearTextOnFocus = false,

        ZIndex = 8

    }, floatCard)

    corner(floatBox, 10)

    stroke(
        floatBox,
        colors.grass,
        1,
        0.5
    )

    floatBox.FocusLost:Connect(
        function()

            local value =
                tonumber(floatBox.Text)

            if value == nil then

                floatBox.Text =
                    tostring(floatHeight)

                setStatus(
                    "Invalid float height",
                    colors.red
                )

                return

            end

            value =
                math.clamp(
                    value,
                    0,
                    10
                )

            value =
                math.round(
                    value * 100
                ) / 100

            floatHeight =
                value

            floatBox.Text =
                tostring(floatHeight)

            setStatus(
                "Float height set to " ..
                tostring(floatHeight),
                colors.subtext
            )

        end
    )

    --// Anti Sit

    local antiSit =
        createToggle(
            content,

            antiSitEnabled
            and "🪑  ANTI SIT  •  ON"
            or "🪑  ANTI SIT  •  OFF",

            0,
            202,
            185,
            48,

            antiSitEnabled,
            colors.grass
        )

    --// Meteor TP

    local meteorButton =
        createToggle(
            content,

            meteorTPEnabled
            and "☄️  METEOR TP  •  ON"
            or "☄️  METEOR TP  •  OFF",

            197,
            202,
            185,
            48,

            meteorTPEnabled,
            colors.gold
        )

    --// Instant E

    instantE.MouseButton1Click:Connect(
        function()

            if instantEEnabled then
                disableInstantE()
            else
                enableInstantE()
            end

            instantE.Text =
                instantEEnabled
                and "⚡  INSTANT E  •  ON"
                or "⚡  INSTANT E  •  OFF"

            updateToggleVisual(
                instantE,
                instantEEnabled,
                colors.grass
            )

        end
    )

    --// Float

    floatButton.MouseButton1Click:Connect(
        function()

            toggleFloat()

            floatButton.Text =
                floatEnabled
                and "☁  FLOAT  •  ON"
                or "☁  FLOAT  •  OFF"

            updateToggleVisual(
                floatButton,
                floatEnabled,
                colors.grass
            )

        end
    )

    --// Anti Sit

    antiSit.MouseButton1Click:Connect(
        function()

            antiSitEnabled =
                not antiSitEnabled

            if antiSitEnabled then

                if player.Character then

                    setupAntiSit(
                        player.Character
                    )

                end

                setStatus(
                    "Anti Sit enabled",
                    colors.grassLight
                )

            else

                disconnectAntiSit()

                setStatus(
                    "Anti Sit disabled",
                    colors.subtext
                )

            end

            antiSit.Text =
                antiSitEnabled
                and "🪑  ANTI SIT  •  ON"
                or "🪑  ANTI SIT  •  OFF"

            updateToggleVisual(
                antiSit,
                antiSitEnabled,
                colors.grass
            )

        end
    )

    --// Meteor TP

    meteorButton.MouseButton1Click:Connect(
        function()

            meteorTPEnabled =
                not meteorTPEnabled

            if meteorTPEnabled then

                setStatus(
                    "☄️ Meteor TP enabled",
                    colors.gold
                )

            else

                meteorTeleporting = false
                meteorSavedCFrame = nil

                setStatus(
                    "☄️ Meteor TP disabled",
                    colors.subtext
                )

            end

            meteorButton.Text =
                meteorTPEnabled
                and "☄️  METEOR TP  •  ON"
                or "☄️  METEOR TP  •  OFF"

            updateToggleVisual(
                meteorButton,
                meteorTPEnabled,
                colors.gold
            )

        end
    )

end

--//============================================================//
--// PERFORMANCE PAGE
--//============================================================//

showPerformance = function()

    currentPage = "PERFORMANCE"

    clearPage()

    resizeFrame(435)

    createPageHeader(
        "⚡",
        "GARDEN PERFORMANCE",
        "Optimize visuals and garden rendering"
    )

    createBackButton()

    local fpsBoost =
        createToggle(
            content,

            fpsBoostEnabled
            and "✓  FPS BOOST  •  ON"
            or "⚡  FPS BOOST  •  OFF",

            0,
            64,
            185,
            48,

            fpsBoostEnabled,
            colors.grass
        )

    local normalGraphics =
        createToggle(
            content,

            "☀  NORMAL GRAPHICS",

            197,
            64,
            185,
            48,

            false,
            colors.blue
        )

    local removeEffectsButton =
        createToggle(
            content,

            effectsRemoved
            and "✓  EFFECTS  •  ON"
            or "✦  EFFECTS  •  OFF",

            0,
            122,
            185,
            48,

            effectsRemoved,
            colors.purple
        )

    local lowGraphics =
        createToggle(
            content,

            lowGraphicsEnabled
            and "✓  LOW GRAPHICS  •  ON"
            or "🍂  LOW GRAPHICS  •  OFF",

            197,
            122,
            185,
            48,

            lowGraphicsEnabled,
            colors.orange
        )

    --// Garden Remove

    local gardenRemoveButton =
        createToggle(
            content,

            gardenRemoveEnabled
            and "✓  GARDENS REMOVED"
            or "🗑  GARDEN REMOVE",

            0,
            180,
            382,
            48,

            gardenRemoveEnabled,
            colors.red
        )

    fpsBoost.MouseButton1Click:Connect(
        function()

            if fpsBoostEnabled then
                disableFPSBoost()
            else
                enableFPSBoost()
            end

            fpsBoost.Text =
                fpsBoostEnabled
                and "✓  FPS BOOST  •  ON"
                or "⚡  FPS BOOST  •  OFF"

            updateToggleVisual(
                fpsBoost,
                fpsBoostEnabled,
                colors.grass
            )

        end
    )

    normalGraphics.MouseButton1Click:Connect(
        function()

            disableFPSBoost()
            disableLowGraphics()
            restoreEffects()

            fpsBoost.Text =
                "⚡  FPS BOOST  •  OFF"

            lowGraphics.Text =
                "🍂  LOW GRAPHICS  •  OFF"

            removeEffectsButton.Text =
                "✦  EFFECTS  •  OFF"

            updateToggleVisual(
                fpsBoost,
                false,
                colors.grass
            )

            updateToggleVisual(
                lowGraphics,
                false,
                colors.orange
            )

            updateToggleVisual(
                removeEffectsButton,
                false,
                colors.purple
            )

            setStatus(
                "Normal garden graphics restored",
                colors.blue
            )

        end
    )

    removeEffectsButton.MouseButton1Click:Connect(
        function()

            if effectsRemoved then
                restoreEffects()
            else
                removeAllEffects()
            end

            removeEffectsButton.Text =
                effectsRemoved
                and "✓  EFFECTS  •  ON"
                or "✦  EFFECTS  •  OFF"

            updateToggleVisual(
                removeEffectsButton,
                effectsRemoved,
                colors.purple
            )

        end
    )

    lowGraphics.MouseButton1Click:Connect(
        function()

            if lowGraphicsEnabled then
                disableLowGraphics()
            else
                enableLowGraphics()
            end

            lowGraphics.Text =
                lowGraphicsEnabled
                and "✓  LOW GRAPHICS  •  ON"
                or "🍂  LOW GRAPHICS  •  OFF"

            updateToggleVisual(
                lowGraphics,
                lowGraphicsEnabled,
                colors.orange
            )

        end
    )

    --//========================================================//
    --// GARDEN REMOVE
    --// ONE-TIME ACTION
    --//========================================================//

    gardenRemoveButton.MouseButton1Click:Connect(
        function()

            if gardenRemoveEnabled then
                return
            end

            gardenRemoveEnabled = true

            gardenRemoveButton.Text =
                "✓  GARDENS REMOVED"

            updateToggleVisual(
                gardenRemoveButton,
                true,
                colors.red
            )

            removeGardenObjects()

            setStatus(
                "Garden Remove active • Plot3-8 removed",
                colors.red
            )

        end
    )

end

--//============================================================//
--// TELEPORT PAGE
--//============================================================//

showTeleport = function()

    currentPage = "TELEPORT"

    clearPage()

    resizeFrame(450)

    createPageHeader(
        "📍",
        "GARDEN TELEPORTATION",
        "Save two locations and return to them"
    )

    createBackButton()

    --// Plot 1

    local plot1 = create("Frame", {

        Size = UDim2.new(
            1,
            0,
            0,
            72
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            64
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        ZIndex = 7

    }, content)

    corner(plot1, 14)

    stroke(
        plot1,
        colors.grass,
        1,
        0.7
    )

    local plot1Icon = create("TextLabel", {

        Size = UDim2.new(
            0,
            45,
            0,
            45
        ),

        Position = UDim2.new(
            0,
            10,
            0.5,
            -22
        ),

        BackgroundColor3 =
            colors.grassDark,

        BorderSizePixel = 0,

        Text = "🌱",

        TextSize = 20,

        ZIndex = 8

    }, plot1)

    corner(plot1Icon, 12)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            100,
            0,
            20
        ),

        Position = UDim2.new(
            0,
            64,
            0,
            11
        ),

        BackgroundTransparency = 1,

        Text = "GARDEN PLOT 1",

        TextColor3 =
            colors.text,

        TextSize = 9,

        Font = Enum.Font.GothamBlack,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, plot1)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            100,
            0,
            18
        ),

        Position = UDim2.new(
            0,
            64,
            0,
            34
        ),

        BackgroundTransparency = 1,

        Text = "[F] teleport",

        TextColor3 =
            colors.muted,

        TextSize = 7,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, plot1)

    local save1 =
        createToggle(
            plot1,
            "🌱 SAVE",
            170,
            14,
            92,
            44,
            false,
            colors.grass
        )

    local tp1 =
        createToggle(
            plot1,
            "🚜 GO",
            270,
            14,
            100,
            44,
            false,
            colors.blue
        )

    --// Plot 2

    local plot2 = create("Frame", {

        Size = UDim2.new(
            1,
            0,
            0,
            72
        ),

        Position = UDim2.new(
            0,
            0,
            0,
            146
        ),

        BackgroundColor3 =
            colors.panel,

        BorderSizePixel = 0,

        ZIndex = 7

    }, content)

    corner(plot2, 14)

    stroke(
        plot2,
        colors.grass,
        1,
        0.7
    )

    local plot2Icon = create("TextLabel", {

        Size = UDim2.new(
            0,
            45,
            0,
            45
        ),

        Position = UDim2.new(
            0,
            10,
            0.5,
            -22
        ),

        BackgroundColor3 =
            colors.grassDark,

        BorderSizePixel = 0,

        Text = "🌿",

        TextSize = 20,

        ZIndex = 8

    }, plot2)

    corner(plot2Icon, 12)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            100,
            0,
            20
        ),

        Position = UDim2.new(
            0,
            64,
            0,
            11
        ),

        BackgroundTransparency = 1,

        Text = "GARDEN PLOT 2",

        TextColor3 =
            colors.text,

        TextSize = 9,

        Font = Enum.Font.GothamBlack,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, plot2)

    create("TextLabel", {

        Size = UDim2.new(
            0,
            100,
            0,
            18
        ),

        Position = UDim2.new(
            0,
            64,
            0,
            34
        ),

        BackgroundTransparency = 1,

        Text = "[G] teleport",

        TextColor3 =
            colors.muted,

        TextSize = 7,

        Font = Enum.Font.GothamMedium,

        TextXAlignment =
            Enum.TextXAlignment.Left,

        ZIndex = 8

    }, plot2)

    local save2 =
        createToggle(
            plot2,
            "🌱 SAVE",
            170,
            14,
            92,
            44,
            false,
            colors.grass
        )

    local tp2 =
        createToggle(
            plot2,
            "🚜 GO",
            270,
            14,
            100,
            44,
            false,
            colors.blue
        )

    --// Clear

    local clear =
        createToggle(
            content,
            "🗑  CLEAR SAVED LOCATIONS",
            0,
            228,
            382,
            45,
            false,
            colors.red
        )

    save1.MouseButton1Click:Connect(
        function()

            local root =
                getRoot()

            if not root then
                return
            end

            savedCFrame1 =
                root.CFrame

            save1.Text =
                "✓  SAVED"

            setStatus(
                "Garden Plot 1 saved",
                colors.grassLight
            )

            task.delay(
                1,
                function()

                    if save1
                        and save1.Parent then

                        save1.Text =
                            "🌱 SAVE"

                    end

                end
            )

        end
    )

    save2.MouseButton1Click:Connect(
        function()

            local root =
                getRoot()

            if not root then
                return
            end

            savedCFrame2 =
                root.CFrame

            save2.Text =
                "✓  SAVED"

            setStatus(
                "Garden Plot 2 saved",
                colors.grassLight
            )

            task.delay(
                1,
                function()

                    if save2
                        and save2.Parent then

                        save2.Text =
                            "🌱 SAVE"

                    end

                end
            )

        end
    )

    tp1.MouseButton1Click:Connect(
        teleportToPosition1
    )

    tp2.MouseButton1Click:Connect(
        teleportToPosition2
    )

    clear.MouseButton1Click:Connect(
        function()

            savedCFrame1 = nil
            savedCFrame2 = nil

            save1.Text =
                "🌱 SAVE"

            save2.Text =
                "🌱 SAVE"

            setStatus(
                "Garden locations cleared",
                colors.red
            )

        end
    )

end

--//============================================================//
--// MINIMIZE
--//============================================================//

local minimizeDragging = false
local minimizeDragStart = nil
local minimizeStartPosition = nil
local minimizeMoved = false

minimize.InputBegan:Connect(
    function(input)

        if input.UserInputType ==
            Enum.UserInputType.MouseButton1

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            minimizeDragging = true
            minimizeMoved = false

            minimizeDragStart =
                input.Position

            minimizeStartPosition =
                main.Position

            input.Changed:Connect(
                function()

                    if input.UserInputState ==
                        Enum.UserInputState.End then

                        minimizeDragging = false

                    end

                end
            )

        end

    end
)

UserInputService.InputChanged:Connect(
    function(input)

        if not minimizeDragging then
            return
        end

        if input.UserInputType ==
            Enum.UserInputType.MouseMovement

            or input.UserInputType ==
            Enum.UserInputType.Touch then

            local delta =
                input.Position -
                minimizeDragStart

            if math.abs(delta.X) > 5
                or math.abs(delta.Y) > 5 then

                minimizeMoved = true

            end

            main.Position =
                UDim2.new(

                    minimizeStartPosition.X.Scale,

                    minimizeStartPosition.X.Offset +
                        delta.X,

                    minimizeStartPosition.Y.Scale,

                    minimizeStartPosition.Y.Offset +
                        delta.Y

                )

        end

    end
)

minimize.MouseEnter:Connect(
    function()

        if not minimized then

            tween(minimize, 0.12, {

                BackgroundColor3 =
                    colors.soil

            }):Play()

        end

    end
)

minimize.MouseLeave:Connect(
    function()

        if not minimized then

            tween(minimize, 0.12, {

                BackgroundColor3 =
                    colors.soilDark

            }):Play()

        end

    end
)

minimize.MouseButton1Click:Connect(
    function()

        if minimizeMoved then

            minimizeMoved = false

            return

        end

        minimized =
            not minimized

        if minimized then

            content.Visible = false
            statusContainer.Visible = false
            header.Visible = false

            tween(main, 0.23, {

                Size = UDim2.new(
                    0,
                    64,
                    0,
                    64
                )

            }):Play()

            minimize.Size =
                UDim2.new(
                    1,
                    -8,
                    1,
                    -8
                )

            minimize.Position =
                UDim2.new(
                    0,
                    4,
                    0,
                    4
                )

            minimize.Text =
                "🌱"

            minimize.TextSize =
                25

            minimize.TextColor3 =
                colors.gold

            minimize.BackgroundColor3 =
                colors.soilDark

            tween(shadow, 0.18, {

                BackgroundTransparency =
                    1

            }):Play()

        else

            local height

            if currentPage ==
                "MENU" then

                height = 475

            elseif currentPage ==
                "GAME" then

                height = 475

            elseif currentPage ==
                "PERFORMANCE" then

                height = 435

            else

                height = 450

            end

            tween(main, 0.23, {

                Size = UDim2.new(
                    0,
                    430,
                    0,
                    height
                )

            }):Play()

            minimize.Size =
                UDim2.new(
                    0,
                    36,
                    0,
                    30
                )

            minimize.Position =
                UDim2.new(
                    1,
                    -48,
                    0,
                    11
                )

            minimize.Text =
                "−"

            minimize.TextSize =
                20

            minimize.TextColor3 =
                colors.text

            minimize.BackgroundColor3 =
                colors.soilDark

            tween(shadow, 0.18, {

                BackgroundTransparency =
                    0.55

            }):Play()

            task.delay(
                0.12,
                function()

                    header.Visible = true
                    content.Visible = true
                    statusContainer.Visible = true

                end
            )

        end

    end
)

--//============================================================//
--// RESPAWN
--//============================================================//

player.CharacterAdded:Connect(
    function(character)

        task.wait(0.5)

        if antiSitEnabled then

            setupAntiSit(character)

        end

        if floatEnabled then

            task.wait(0.2)

            startFloat()

        end

        --// Reapply Garden Remove

        if gardenRemoveEnabled then

            task.wait(0.1)

            removeGardenObjects()

        end

        --// Meteor state reset

        meteorTeleporting = false
        meteorSavedCFrame = nil

    end
)

--//============================================================//
--// F / G TELEPORT
--//============================================================//

UserInputService.InputBegan:Connect(
    function(input, gameProcessed)

        if gameProcessed then
            return
        end

        if input.KeyCode ==
            Enum.KeyCode.F then

            teleportToPosition1()

        elseif input.KeyCode ==
            Enum.KeyCode.G then

            teleportToPosition2()

        end

    end
)

--//============================================================//
--// START
--//============================================================//

showMainMenu()

--//============================================================//
--// END
--//============================================================//
