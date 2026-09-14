--// APEX HUB – Key System + AI Support + Multi-Language (VIP)
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")

-- 1. CẤU HÌNH NGÔN NGỮ (LANGUAGE CONFIG)
local CurrentLang = "VN" -- Mặc định là Việt Nam

local Locales = {
    VN = {
        Title = "APEX HUB - HỆ THỐNG KEY",
        TabKey = "NHẬP KEY",
        TabAI = "HỖ TRỢ AI",
        Placeholder = "Dán key vào đây...",
        Confirm = "XÁC NHẬN",
        GetKey = "LẤY KEY",
        Video = "VIDEO HƯỚNG DẪN",
        ChangeLink = "ĐỔI LINK KHÁC",
        Note = "LƯU Ý QUAN TRỌNG:\n• Nhấn LẤY KEY để copy link\n• Truy cập link để lấy key\n• Key thay đổi mỗi 24h (UTC Time)\n• Dán key vào ô trên sau khi copy\n• Mỗi ngày được đổi link tối đa 3 lần",
        Success = "THÀNH CÔNG! Key hợp lệ.",
        Fail = "Key không đúng! Vui lòng thử lại.",
        CopyKey = "Đã copy link lấy key!",
        CopyVideo = "Đã copy link video hướng dẫn!",
        ChangeLimit = "Đã hết lượt đổi link hôm nay! (Tối đa 3 lần/ngày)",
        ChangeCooldown = "Vui lòng đợi {time} giây nữa để đổi link tiếp!",
        ChangeSuccess = "Đã chuyển sang link mới! Hãy lấy key từ link này.",
        AI_Welcome = "Xin chào! Tôi là AI Hỗ trợ. Bạn cần giúp gì không?",
        AI_Copy = "COPY LINK",
        Questions = {
            {Q = "Cách lấy Key như thế nào?", A = "Bạn hãy nhấn nút VIDEO HƯỚNG DẪN ở tab Nhập Key và dán link lên trình duyệt để xem hướng dẫn chi tiết nhé."},
            {Q = "Gặp lỗi hoặc cần hỗ trợ trực tiếp?", A = "Hãy tham gia Discord hoặc nhắn tin Tiktok cho Admin nhé:\nDiscord: https://discord.gg/Ane8eqsAz\nTiktok: www.tiktok.com/@thekinmentit"},
            {Q = "Tại sao Key bị sai?", A = "Hãy kiểm tra lại:\n1. Bạn đã copy hết Key chưa?\n2. Có khoảng trắng thừa không?\n3. Key đổi sau 24h, hãy lấy key mới nhất."}
        }
    },
    EN = {
        Title = "APEX HUB - KEY SYSTEM",
        TabKey = "ENTER KEY",
        TabAI = "AI SUPPORT",
        Placeholder = "Paste key here...",
        Confirm = "CONFIRM",
        GetKey = "GET KEY",
        Video = "TUTORIAL",
        ChangeLink = "CHANGE LINK",
        Note = "IMPORTANT NOTE:\n• Click GET KEY to copy the link\n• Visit the link to generate a key\n• Key changes every 24h (UTC Time)\n• Paste the key above after copying\n• Max 3 link changes per day",
        Success = "SUCCESS! Valid Key.",
        Fail = "Invalid Key! Please try again.",
        CopyKey = "Key link copied!",
        CopyVideo = "Tutorial link copied!",
        ChangeLimit = "No more link changes today! (Max 3/day)",
        ChangeCooldown = "Please wait {time} seconds before changing again!",
        ChangeSuccess = "Switched to a new link! Get the key from this link.",
        AI_Welcome = "Hello! I'm AI Support. How can I help you?",
        AI_Copy = "COPY LINKS",
        Questions = {
            {Q = "How do I get the Key?", A = "Please click the TUTORIAL button in the Enter Key tab and paste the link into your browser to watch the guide."},
            {Q = "Support or Contact Admin?", A = "Please join our Discord or DM us on Tiktok for help:\nDiscord: https://discord.gg/Ane8eqsAz\nTiktok: www.tiktok.com/@thekinmentit"},
            {Q = "Why is my Key invalid?", A = "Please check:\n1. Did you copy the full key?\n2. Is there any extra whitespace?\n3. Key expires every 24h, get a new one."}
        }
    }
}

-- 2. DATA & LOGIC KEY
local function normalizeKey(key)
    if not key then return "" end
    return tostring(key):gsub("^%s+", ""):gsub("%s+$", ""):gsub("[\r\n\t]", "")
end

local function saveData(data)
    pcall(function() writefile("APEX_KeyData_v4.json", HttpService:JSONEncode(data)) end)
end

local function loadData()
    local ok, data = pcall(function() return HttpService:JSONDecode(readfile("APEX_KeyData_v4.json")) end)
    return (ok and data) or {}
end

local Data = loadData()
local changeLog = Data.changeLog or {count = 0, lastChange = 0, currentIndex = nil}
Data.changeLog = changeLog
saveData(Data)

if changeLog.lastChange > 0 then
    local changeDay = math.floor(changeLog.lastChange / 86400)
    local currentDay = math.floor(DateTime.now().UnixTimestamp / 86400)
    if changeDay < currentDay then
        changeLog.count = 0
        changeLog.lastChange = 0
        changeLog.currentIndex = nil
        saveData(Data)
    end
end

local Keys = {
    "Free_apexdkwiqkfkds@38", "Free_peqaldjfjAPEX?76", "Free_rc7pucfa2184@+apex",
    "Free_vnkkqodialfjđk@apex%", "Free_2024yekystemqpapex43", "Free_qlmonieakriapex484@&",
    "Free_ApExtuwU&Ou01@:", "Free_ioytkbzma;p:e.x@eiskq", "Free_qpiwiowhdhfhfhfhfhfhfApEXKdjdjdj24939@",
    "Free_%102938#%[]aexp1", "Free_*^+=201a7k9a1p2e8x@", "Free_cahnobyamid367₫",
    "Free_conysmkdjd@282apex", "Free_90282929449ksowoa47ựp", "Free_ksjsjaqiwirupeax383sjsjsisiaiaisiwiissisi",
    "Free_ưidjdjskaie@2828410", "Free_j~#tiokhoapexyyuj", "Free_vfsddđfficiapẽ3919484",
    "Free_bino20s2y0kjsjsepeax", "Free_gjfowiwiqpwoalslskskskhvuwiwikskksqpsowoekkdjxbb20000000",
    "Free_akeieieiwiwqqjwskapex", "Free_uiwiwiwiwiakmehfhehqpapex@29", "Free_koqtehnaolakothe3382@apex",
    "Free_ituruefhfjxsk38382@1", "Free_0234711452apex@0333", "Free_apex19384839292&@",
    "Free_28192848@&₫ệkweowk", "Free_oemyameobmalnocaapex", "Free_lăjqpqqpdjcbbeheidoahfjanxbc284719576ehqp",
    "Free_ưuqurhdhchhshwhqjwpapqkcbcja;&(28", "Free_apex6237899&291", "Free_qoeiejfjfjrjdapexjfjdjeueifuwhchjwiqekjebal38584@282;",
    "Free_apexpeacpapexpapexapex@292823838", "Free_alzmxnvaoepqur:&(₫!093", "Free_tyiwkdjgjaskjnzxcmpeax@,.g",
    "Free_bsndhruwoqpdjfnfkdjs", "Free_kaldicizoeiwofjfjrfhqkdk@₫;", "Free_eeeraakkjjfdwwiruf333",
    "Free_ôrwuii!lllllaoekejfjwqpxjchfjs", "Free_mzjadksnxnzwp@@2711apex"
}
local Links = {
    "https://vuotnhanh.com/al27", "https://vuotnhanh.com/iaBy", "https://vuotnhanh.com/Wa6e",
    "https://vuotnhanh.com/8rII", "https://vuotnhanh.com/06Gz", "https://vuotnhanh.com/dqrP",
    "https://vuotnhanh.com/d0JY", "https://vuotnhanh.com/gOsI", "https://vuotnhanh.com/yZnh",
    "https://vuotnhanh.com/bXF4", "https://vuotnhanh.com/4Aez", "https://vuotnhanh.com/r87a",
    "https://vuotnhanh.com/gNvv", "https://vuotnhanh.com/AxIX", "https://vuotnhanh.com/amb6",
    "https://vuotnhanh.com/Csqa", "https://vuotnhanh.com/eXUe", "https://vuotnhanh.com/icVa",
    "https://vuotnhanh.com/skd5", "https://vuotnhanh.com/XsUV", "https://vuotnhanh.com/Ag5s",
    "https://vuotnhanh.com/62ln", "https://vuotnhanh.com/03vX", "https://vuotnhanh.com/DQMQ",
    "https://vuotnhanh.com/NO1S", "https://vuotnhanh.com/j6lk", "https://vuotnhanh.com/mWOY",
    "https://vuotnhanh.com/KYXJ", "https://vuotnhanh.com/Hk1j", "https://vuotnhanh.com/Y8km",
    "https://vuotnhanh.com/RlGa", "https://vuotnhanh.com/OFtW", "https://vuotnhanh.com/GWnN",
    "https://vuotnhanh.com/eL6q", "https://vuotnhanh.com/G304", "https://vuotnhanh.com/WzEb",
    "https://vuotnhanh.com/TOG0", "https://vuotnhanh.com/57OX", "https://vuotnhanh.com/Otbc",
    "https://vuotnhanh.com/nhEu"
}
local VideoGuideLink = "https://vt.tiktok.com/ZSahDptUF/"
local ScriptURL = "https://pastefy.app/W6PPU0J1/raw"

local function getCurrentKeyIndex()
    if changeLog.currentIndex then
        return changeLog.currentIndex
    end
    local unix = DateTime.now().UnixTimestamp
    return (math.floor(unix / 86400) % 40) + 1
end

local index = getCurrentKeyIndex()
local CorrectKey = Keys[index]
local KeyLink = Links[index]

if Data.used and Data.time and (DateTime.now().UnixTimestamp - Data.time) >= 86400 then
    Data = {}
    saveData(Data)
end

if Data.autoRun and Data.used then
    pcall(function() loadstring(game:HttpGet(ScriptURL))() end)
    return
end

-- 3. GUI SYSTEM
local gui = Instance.new("ScreenGui")
gui.Name = "APEX_VIP_GUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local blur = Instance.new("BlurEffect")
blur.Size = 0
blur.Parent = game:GetService("Lighting")

local function createGradient(parent, colorSeq)
    local g = Instance.new("UIGradient")
    g.Color = colorSeq
    g.Rotation = 135
    g.Parent = parent
    return g
end

local function addButtonEffects(button)
    local originalSize = button.Size
    button.MouseEnter:Connect(function() 
        TweenService:Create(button, TweenInfo.new(0.15), {
            Size = UDim2.new(originalSize.X.Scale, originalSize.X.Offset + 4, originalSize.Y.Scale, originalSize.Y.Offset + 4)
        }):Play() 
    end)
    button.MouseLeave:Connect(function() 
        TweenService:Create(button, TweenInfo.new(0.15), {Size = originalSize}):Play() 
    end)
end

local function createRunButton()
    local runBtn = Instance.new("TextButton")
    runBtn.Size = UDim2.new(0, 240, 0, 65)
    runBtn.Position = UDim2.new(0.5, -120, 0.7, -32)
    runBtn.Text = "KHỞI CHẠY SCRIPT"
    runBtn.Font = Enum.Font.GothamBlack
    runBtn.TextSize = 19
    runBtn.TextColor3 = Color3.new(1,1,1)
    runBtn.BackgroundColor3 = Color3.fromRGB(25,25,35)
    runBtn.Parent = gui
    Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 12)
    local stroke = Instance.new("UIStroke", runBtn)
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0,255,200)
    createGradient(runBtn, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0,220,180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0,140,240))
    }))
    addButtonEffects(runBtn)
    runBtn.MouseButton1Click:Connect(function()
        TweenService:Create(runBtn, TweenInfo.new(0.3), {BackgroundColor3=Color3.fromRGB(0,180,80)}):Play()
        pcall(function() loadstring(game:HttpGet(ScriptURL))() end)
        saveData({autoRun=true, used=true, time=DateTime.now().UnixTimestamp})
        task.wait(1)
        runBtn:Destroy()
        TweenService:Create(blur, TweenInfo.new(0.5), {Size=0}):Play()
    end)
end

if not Data.used then
    TweenService:Create(blur, TweenInfo.new(0.6), {Size = 10}):Play()

    -- MAIN FRAME - Nhỏ hơn, gọn hơn
    local main = Instance.new("Frame")
    main.Size = UDim2.new(0, 420, 0, 420)
    main.Position = UDim2.new(0.5, -210, 0.5, -210)
    main.BackgroundColor3 = Color3.fromRGB(14, 14, 24)
    main.Active = true
    main.Draggable = true
    main.Parent = gui
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)
    local mainStroke = Instance.new("UIStroke", main)
    mainStroke.Color = Color3.fromRGB(80, 70, 160)
    mainStroke.Thickness = 1.5

    -- HEADER
    local header = Instance.new("Frame")
    header.Size = UDim2.new(1, 0, 0, 50)
    header.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    header.Parent = main
    Instance.new("UICorner", header).CornerRadius = UDim.new(0, 16)
    local hFix = Instance.new("Frame", header)
    hFix.Size = UDim2.new(1, 0, 0, 8)
    hFix.Position = UDim2.new(0, 0, 1, -8)
    hFix.BackgroundColor3 = header.BackgroundColor3
    hFix.BorderSizePixel = 0
    createGradient(header, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90,50,180)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(40,25,100))
    }))

    local titleLbl = Instance.new("TextLabel")
    titleLbl.Size = UDim2.new(0.5, 0, 1, 0)
    titleLbl.Position = UDim2.new(0, 14, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextColor3 = Color3.new(1,1,1)
    titleLbl.TextSize = 15
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.Parent = header

    -- LANG BUTTON
    local langBtn = Instance.new("TextButton")
    langBtn.Size = UDim2.new(0, 36, 0, 22)
    langBtn.Position = UDim2.new(1, -48, 0.5, -11)
    langBtn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    langBtn.Text = "VN"
    langBtn.TextSize = 12
    langBtn.Font = Enum.Font.GothamBold
    langBtn.TextColor3 = Color3.fromRGB(0,0,0)
    langBtn.Parent = header
    Instance.new("UICorner", langBtn).CornerRadius = UDim.new(0, 6)

    -- TAB SYSTEM
    local tabContainer = Instance.new("Frame")
    tabContainer.Size = UDim2.new(0, 170, 0, 28)
    tabContainer.Position = UDim2.new(1, -218, 0.5, -14)
    tabContainer.BackgroundColor3 = Color3.fromRGB(0,0,0)
    tabContainer.BackgroundTransparency = 0.55
    tabContainer.Parent = header
    Instance.new("UICorner", tabContainer).CornerRadius = UDim.new(1, 0)

    local function createTab(text, x, active)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0.5, 0, 1, 0)
        btn.Position = UDim2.new(x, 0, 0, 0)
        btn.BackgroundTransparency = active and 0 or 1
        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        btn.TextColor3 = active and Color3.new(0,0,0) or Color3.fromRGB(210,210,210)
        btn.Text = text
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
        btn.Parent = tabContainer
        Instance.new("UICorner", btn).CornerRadius = UDim.new(1, 0)
        return btn
    end
    local tabKeyBtn = createTab("", 0, true)
    local tabAIBtn = createTab("", 0.5, false)

    -- CONTAINERS
    local pageContainer = Instance.new("Frame", main)
    pageContainer.Size = UDim2.new(1, 0, 1, -50)
    pageContainer.Position = UDim2.new(0, 0, 0, 50)
    pageContainer.BackgroundTransparency = 1

    -- === PAGE KEY ===
    local pageKey = Instance.new("Frame", pageContainer)
    pageKey.Size = UDim2.new(1, 0, 1, 0)
    pageKey.BackgroundTransparency = 1

    -- Input frame - xoá text mặc định, dùng placeholder
    local inputFrame = Instance.new("Frame", pageKey)
    inputFrame.Size = UDim2.new(0.86, 0, 0, 44)
    inputFrame.Position = UDim2.new(0.07, 0, 0.06, 0)
    inputFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 38)
    Instance.new("UICorner", inputFrame).CornerRadius = UDim.new(0, 10)
    local inputStroke = Instance.new("UIStroke", inputFrame)
    inputStroke.Color = Color3.fromRGB(100, 80, 180)
    inputStroke.Thickness = 1
    
    local keyBox = Instance.new("TextBox", inputFrame)
    keyBox.Size = UDim2.new(1, -20, 1, 0)
    keyBox.Position = UDim2.new(0, 10, 0, 0)
    keyBox.BackgroundTransparency = 1
    keyBox.Text = "" -- Xoá text mặc định
    keyBox.TextColor3 = Color3.fromRGB(220, 220, 255)
    keyBox.Font = Enum.Font.GothamMedium
    keyBox.TextSize = 13
    keyBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 140)
    keyBox.PlaceholderText = "" -- Sẽ update sau
    keyBox.TextXAlignment = Enum.TextXAlignment.Left
    keyBox.ClearTextOnFocus = false

    -- Button Container - 3 nút chính
    local btnContainer = Instance.new("Frame", pageKey)
    btnContainer.Size = UDim2.new(0.86, 0, 0, 40)
    btnContainer.Position = UDim2.new(0.07, 0, 0.24, 0)
    btnContainer.BackgroundTransparency = 1

    local function createStyledBtn(text, color1, color2, x, scaleX)
        local btn = Instance.new("TextButton", btnContainer)
        btn.Size = UDim2.new(scaleX or 0.3, 0, 1, 0)
        btn.Position = UDim2.new(x, 0, 0, 0)
        btn.Text = text
        btn.TextColor3 = Color3.new(1,1,1)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.BackgroundColor3 = color1
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        Instance.new("UIStroke", btn).Color = color2
        createGradient(btn, ColorSequence.new({
            ColorSequenceKeypoint.new(0, color1),
            ColorSequenceKeypoint.new(1, color2)
        }))
        addButtonEffects(btn)
        return btn
    end

    local confirmBtn = createStyledBtn("XÁC NHẬN", Color3.fromRGB(0,170,55), Color3.fromRGB(0,110,35), 0, 0.3)
    local getKeyBtn = createStyledBtn("LẤY KEY", Color3.fromRGB(55,95,210), Color3.fromRGB(25,55,140), 0.33, 0.3)
    local videoBtn = createStyledBtn("HƯỚNG DẪN", Color3.fromRGB(185,80,205), Color3.fromRGB(135,40,165), 0.66, 0.3)

    -- NÚT ĐỔI LINK - Thiết kế nổi bật riêng biệt
    local changeLinkContainer = Instance.new("Frame", pageKey)
    changeLinkContainer.Size = UDim2.new(0.86, 0, 0, 36)
    changeLinkContainer.Position = UDim2.new(0.07, 0, 0.40, 0)
    changeLinkContainer.BackgroundTransparency = 1
    
    local changeLinkBtn = Instance.new("TextButton", changeLinkContainer)
    changeLinkBtn.Size = UDim2.new(1, 0, 1, 0)
    changeLinkBtn.Text = "" -- Sẽ update sau
    changeLinkBtn.TextColor3 = Color3.new(1,1,1)
    changeLinkBtn.Font = Enum.Font.GothamBold
    changeLinkBtn.TextSize = 13
    changeLinkBtn.AutoButtonColor = false
    changeLinkBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
    Instance.new("UICorner", changeLinkBtn).CornerRadius = UDim.new(0, 8)
    
    local changeStroke = Instance.new("UIStroke", changeLinkBtn)
    changeStroke.Thickness = 1.5
    changeStroke.Color = Color3.fromRGB(240, 170, 40)
    
    createGradient(changeLinkBtn, ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(55, 35, 75)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(35, 25, 55)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(55, 35, 75))
    }))
    
    -- Label hiển thị số lượt còn lại
    local changeCountLabel = Instance.new("TextLabel", changeLinkBtn)
    changeCountLabel.Size = UDim2.new(0, 110, 0, 18)
    changeCountLabel.Position = UDim2.new(1, -118, 0.5, -9)
    changeCountLabel.BackgroundTransparency = 1
    changeCountLabel.Text = "(Còn lại: 3 lượt)"
    changeCountLabel.TextColor3 = Color3.fromRGB(240, 190, 90)
    changeCountLabel.Font = Enum.Font.GothamMedium
    changeCountLabel.TextSize = 10
    changeCountLabel.TextXAlignment = Enum.TextXAlignment.Right
    
    addButtonEffects(changeLinkBtn)

    -- Note box
    local noteBox = Instance.new("Frame", pageKey)
    noteBox.Size = UDim2.new(0.86, 0, 0, 130)
    noteBox.Position = UDim2.new(0.07, 0, 0.55, 0)
    noteBox.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
    Instance.new("UICorner", noteBox).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", noteBox).Color = Color3.fromRGB(65, 50, 130)
    
    local noteLbl = Instance.new("TextLabel", noteBox)
    noteLbl.Size = UDim2.new(1, -20, 1, -20)
    noteLbl.Position = UDim2.new(0, 10, 0, 10)
    noteLbl.BackgroundTransparency = 1
    noteLbl.TextColor3 = Color3.fromRGB(170, 170, 200)
    noteLbl.Font = Enum.Font.GothamMedium
    noteLbl.TextSize = 11
    noteLbl.TextWrapped = true
    noteLbl.TextXAlignment = Enum.TextXAlignment.Left

    -- === PAGE AI ===
    local pageAI = Instance.new("Frame", pageContainer)
    pageAI.Size = UDim2.new(1, 0, 1, 0)
    pageAI.BackgroundTransparency = 1
    pageAI.Visible = false

    local chatScroll = Instance.new("ScrollingFrame", pageAI)
    chatScroll.Size = UDim2.new(0.86, 0, 0, 235)
    chatScroll.Position = UDim2.new(0.07, 0, 0.02, 0)
    chatScroll.BackgroundTransparency = 1
    chatScroll.ScrollBarThickness = 2
    chatScroll.ScrollBarImageColor3 = Color3.fromRGB(90, 70, 180)
    chatScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    chatScroll.CanvasSize = UDim2.new(0,0,0,0)
    local chatLayout = Instance.new("UIListLayout", chatScroll)
    chatLayout.Padding = UDim.new(0, 8)

    local qContainer = Instance.new("Frame", pageAI)
    qContainer.Size = UDim2.new(0.86, 0, 0, 95)
    qContainer.Position = UDim2.new(0.07, 0, 1, -103)
    qContainer.BackgroundColor3 = Color3.fromRGB(16, 16, 26)
    Instance.new("UICorner", qContainer).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", qContainer).Color = Color3.fromRGB(65, 50, 130)
    local qLayout = Instance.new("UIListLayout", qContainer)
    qLayout.Padding = UDim.new(0, 4)

    -- === LOGIC FUNCTIONS ===
    local function updateText()
        local L = Locales[CurrentLang]
        titleLbl.Text = L.Title
        tabKeyBtn.Text = L.TabKey
        tabAIBtn.Text = L.TabAI
        keyBox.PlaceholderText = L.Placeholder
        confirmBtn.Text = L.Confirm
        getKeyBtn.Text = L.GetKey
        videoBtn.Text = L.Video
        changeLinkBtn.Text = L.ChangeLink
        changeCountLabel.Text = "(Còn lại: " .. (3 - changeLog.count) .. " lượt)"
        noteLbl.Text = L.Note
        langBtn.Text = CurrentLang == "VN" and "VN" or "EN"

        for _, child in pairs(qContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        
        for i, qData in ipairs(L.Questions) do
            local btn = Instance.new("TextButton", qContainer)
            btn.Size = UDim2.new(1, 0, 0, 28)
            btn.BackgroundColor3 = Color3.fromRGB(28, 28, 44)
            btn.Text = "  " .. qData.Q
            btn.Font = Enum.Font.GothamMedium
            btn.TextColor3 = Color3.fromRGB(200, 200, 220)
            btn.TextSize = 11
            btn.TextXAlignment = Enum.TextXAlignment.Left
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
            Instance.new("UIStroke", btn).Color = Color3.fromRGB(50, 40, 90)
            
            btn.MouseButton1Click:Connect(function()
                local function createBubble(txt, isAI)
                    local bubble = Instance.new("Frame")
                    bubble.AutomaticSize = Enum.AutomaticSize.XY
                    bubble.BackgroundColor3 = isAI and Color3.fromRGB(35, 35, 52) or Color3.fromRGB(0, 120, 210)
                    Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 8)
                    local lbl = Instance.new("TextLabel", bubble)
                    lbl.Text = isAI and "" or txt
                    lbl.TextColor3 = Color3.new(1,1,1)
                    lbl.Font = Enum.Font.GothamMedium
                    lbl.TextSize = 12
                    lbl.TextWrapped = true
                    lbl.BackgroundTransparency = 1
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.AutomaticSize = Enum.AutomaticSize.XY
                    
                    local tSize = game:GetService("TextService"):GetTextSize(txt, 12, Enum.Font.GothamMedium, Vector2.new(270, 9999))
                    lbl.Size = UDim2.new(0, tSize.X, 0, tSize.Y)
                    lbl.Position = UDim2.new(0, 10, 0, 8)
                    bubble.Size = UDim2.new(0, tSize.X+20, 0, tSize.Y+16)
                    
                    if isAI then
                        bubble.LayoutOrder = 9999
                        bubble.AnchorPoint = Vector2.new(0,0)
                        bubble.Position = UDim2.new(0,0,0,0)
                        bubble.Parent = chatScroll
                        
                        task.spawn(function()
                            for k=1, #txt do
                                lbl.Text = string.sub(txt, 1, k)
                                task.wait(0.006)
                            end
                            if txt:find("http") or txt:find("www") then
                                local copy = Instance.new("TextButton", bubble)
                                copy.Size = UDim2.new(0, 75, 0, 20)
                                copy.Position = UDim2.new(0,0,1,6)
                                copy.Text = L.AI_Copy
                                copy.Font = Enum.Font.GothamBold
                                copy.TextSize = 9
                                copy.BackgroundColor3 = Color3.fromRGB(0, 145, 80)
                                copy.TextColor3 = Color3.new(1,1,1)
                                Instance.new("UICorner", copy).CornerRadius = UDim.new(0, 4)
                                bubble.Size = UDim2.new(0, bubble.Size.X.Offset, 0, bubble.Size.Y.Offset+26)
                                copy.MouseButton1Click:Connect(function()
                                    if setclipboard then setclipboard(txt) end
                                end)
                            end
                        end)
                    else
                        bubble.LayoutOrder = 9999
                        bubble.AnchorPoint = Vector2.new(1,0)
                        bubble.Position = UDim2.new(1,-5,0,0)
                        bubble.Parent = chatScroll
                    end
                    task.wait(0.05)
                    chatScroll.CanvasPosition = Vector2.new(0, chatScroll.AbsoluteCanvasSize.Y)
                end
                
                createBubble(qData.Q, false)
                task.wait(0.3)
                createBubble(qData.A, true)
            end)
        end
    end

    updateText()

    -- Events
    langBtn.MouseButton1Click:Connect(function()
        CurrentLang = (CurrentLang == "VN") and "EN" or "VN"
        updateText()
    end)

    confirmBtn.MouseButton1Click:Connect(function()
        if normalizeKey(keyBox.Text) == normalizeKey(CorrectKey) then
            saveData({used=true, time=DateTime.now().UnixTimestamp})
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "APEX HUB", 
                Text = Locales[CurrentLang].Success, 
                Duration = 4
            })
            main:Destroy()
            createRunButton()
        else
            keyBox.Text = ""
            keyBox.PlaceholderText = Locales[CurrentLang].Fail
            keyBox.PlaceholderColor3 = Color3.fromRGB(255, 70, 70)
            task.wait(2)
            keyBox.PlaceholderText = Locales[CurrentLang].Placeholder
            keyBox.PlaceholderColor3 = Color3.fromRGB(110, 110, 140)
        end
    end)

    getKeyBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(KeyLink) end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "APEX HUB", 
            Text = Locales[CurrentLang].CopyKey, 
            Duration = 3
        })
    end)
    
    videoBtn.MouseButton1Click:Connect(function()
        if setclipboard then setclipboard(VideoGuideLink) end
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "APEX HUB", 
            Text = Locales[CurrentLang].CopyVideo, 
            Duration = 3
        })
    end)

    changeLinkBtn.MouseButton1Click:Connect(function()
        local L = Locales[CurrentLang]
        local now = DateTime.now().UnixTimestamp
        
        local changeDay = math.floor(changeLog.lastChange / 86400)
        local currentDay = math.floor(now / 86400)
        if changeDay < currentDay then
            changeLog.count = 0
            changeLog.lastChange = 0
            changeLog.currentIndex = nil
        end
        
        if changeLog.count >= 3 then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "APEX HUB", 
                Text = L.ChangeLimit, 
                Duration = 3
            })
            return
        end
        
        if changeLog.lastChange > 0 and (now - changeLog.lastChange) < 180 then
            local remaining = 180 - (now - changeLog.lastChange)
            local msg = L.ChangeCooldown:gsub("{time}", tostring(remaining))
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "APEX HUB", 
                Text = msg, 
                Duration = 3
            })
            return
        end
        
        changeLog.count = changeLog.count + 1
        changeLog.lastChange = now
        
        local newIndex
        repeat
            newIndex = math.random(1, 40)
        until newIndex ~= index
        
        changeLog.currentIndex = newIndex
        saveData(Data)
        
        index = newIndex
        CorrectKey = Keys[index]
        KeyLink = Links[index]
        
        changeCountLabel.Text = "(Còn lại: " .. (3 - changeLog.count) .. " lượt)"
        
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = "APEX HUB", 
            Text = L.ChangeSuccess, 
            Duration = 4
        })
    end)

    tabKeyBtn.MouseButton1Click:Connect(function()
        pageKey.Visible = true
        pageAI.Visible = false
        tabKeyBtn.BackgroundTransparency = 0
        tabKeyBtn.TextColor3 = Color3.new(0,0,0)
        tabAIBtn.BackgroundTransparency = 1
        tabAIBtn.TextColor3 = Color3.fromRGB(210,210,210)
    end)

    tabAIBtn.MouseButton1Click:Connect(function()
        pageKey.Visible = false
        pageAI.Visible = true
        tabAIBtn.BackgroundTransparency = 0
        tabAIBtn.TextColor3 = Color3.new(0,0,0)
        tabKeyBtn.BackgroundTransparency = 1
        tabKeyBtn.TextColor3 = Color3.fromRGB(210,210,210)
        
        if #chatScroll:GetChildren() <= 1 then
            local function createBubble(txt, isAI)
                local bubble = Instance.new("Frame")
                bubble.AutomaticSize = Enum.AutomaticSize.XY
                bubble.BackgroundColor3 = isAI and Color3.fromRGB(35, 35, 52) or Color3.fromRGB(0, 120, 210)
                Instance.new("UICorner", bubble).CornerRadius = UDim.new(0, 8)
                local lbl = Instance.new("TextLabel", bubble)
                lbl.Text = txt
                lbl.TextColor3 = Color3.new(1,1,1)
                lbl.Font = Enum.Font.GothamMedium
                lbl.TextSize = 12
                lbl.TextWrapped = true
                lbl.BackgroundTransparency = 1
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.AutomaticSize = Enum.AutomaticSize.XY
                
                local tSize = game:GetService("TextService"):GetTextSize(txt, 12, Enum.Font.GothamMedium, Vector2.new(270, 9999))
                lbl.Size = UDim2.new(0, tSize.X, 0, tSize.Y)
                lbl.Position = UDim2.new(0, 10, 0, 8)
                bubble.Size = UDim2.new(0, tSize.X+20, 0, tSize.Y+16)
                bubble.LayoutOrder = 9999
                bubble.Parent = chatScroll
                
                chatScroll.CanvasPosition = Vector2.new(0, chatScroll.AbsoluteCanvasSize.Y)
            end
            createBubble(Locales[CurrentLang].AI_Welcome, true)
        end
    end)
else
    createRunButton()
end

gui.DescendantRemoving:Connect(function(d) if d == gui and blur then blur:Destroy() end end)
