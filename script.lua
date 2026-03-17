local GITHUB_KEYS_URL = "https://raw.githubusercontent.com/soloxhubop/test2/refs/heads/main/keys.txt"; local WEBHOOK_URL = "https://discord.com/api/webhooks/1479874056097632256/f95iwk7QqvFqVkwd_1_BMVeRr_3JqZjtGnlcCPgUAT2aOLSNoY9CcejnJV3CB8xEc1-S"
local DISCORD_LINK = "https://discord.gg/METTI_QUI_IL_LINK"; local KEY_SAVE_FILE = "Meloska_Key.txt"; local ADMIN_ID = 2641454068; local ADMIN_NAME2 = "SKINLALAL5"
local _CoreGui = game:GetService("CoreGui"); local _Players = game:GetService("Players"); local _HttpService = game:GetService("HttpService"); local _UIS = game:GetService("UserInputService")
local _LocalPlayer = _Players.LocalPlayer
local function isAdmin()
    return _LocalPlayer.UserId == ADMIN_ID or _LocalPlayer.Name == ADMIN_NAME2 end
local function generateKey(keyType)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local function seg(n)
        local s = ""
        for i = 1, n do local r = math.random(1, #chars); s = s .. chars:sub(r, r) end
        return s end
    return "MELOSKA-" .. seg(4) .. "-" .. seg(4) .. "-" .. seg(4) .. "-" .. (keyType or "LT") end
local function getExpiryDate(keyType)
    local now = os.time()
    if keyType == "1D" then return os.date("!%Y-%m-%d", now + 86400)
    elseif keyType == "2W" then return os.date("!%Y-%m-%d", now + 1209600)
    else return "lifetime" end end
local function isKeyExpired(expiryStr)
    if expiryStr == "lifetime" then return false end
    local y, m, d = expiryStr:match("(%d+)-(%d+)-(%d+)")
    if not y then return true end
    return os.time() > os.time({year=tonumber(y), month=tonumber(m), day=tonumber(d), hour=23, min=59, sec=59}) end
local function checkKeyValid(inputKey)
    local ok, result = pcall(function() return game:HttpGet(GITHUB_KEYS_URL) end)
    if not ok or not result then return false, "Errore connessione" end
    local clean = inputKey:match("^%s*(.-)%s*$"); clean = clean:match("^([^|]+)") or clean
    clean = clean:match("^%s*(.-)%s*$")
    for line in result:gmatch("[^\r\n]+") do
        line = line:match("^%s*(.-)%s*$")
        if line ~= "" and not line:match("^%-%-") then
            local key, expiry = line:match("^([^|]+)|(.+)$")
            if key then
                key = key:match("^%s*(.-)%s*$"); expiry = expiry:match("^%s*(.-)%s*$")
                if key == clean then
                    if isKeyExpired(expiry) then return false, "Key scaduta!" end
                    return true, expiry end
            else
                if line == clean then return true, "lifetime" end end end end
    return false, "Key non valida!" end
local function saveKeyLocally(key) pcall(function() writefile(KEY_SAVE_FILE, key) end) end
local function loadSavedKey()
    local ok, result = pcall(function()
        if isfile(KEY_SAVE_FILE) then return readfile(KEY_SAVE_FILE) end end)
    if ok and result and result ~= "" then return result:match("^%s*(.-)%s*$") end
    return nil end
local function sendKeyToWebhook(keyLine)
    pcall(function(); local data = _HttpService:JSONEncode({
            username = "Meloska Key System",; embeds = {{
                title = "Nuova Key Generata",; description = "**Copia nel GitHub:**\n```" .. keyLine .. "```\n**Copia nel TextBox in-game:**\n```" .. (keyLine:match("^([^|]+)") or keyLine) .. "```",
                color = 7930480,; footer = { text = "Meloska Development" }
            }}; })
        local reqOpts = {Url=WEBHOOK_URL, Method="POST", Headers={["Content-Type"]="application/json"}, Body=data}
        if http_request then
            http_request(reqOpts)
        elseif request then
            request(reqOpts)
        elseif syn and syn.request then
            syn.request(reqOpts)
        elseif (fluxus and fluxus.request) then
            fluxus.request(reqOpts) end end) end
if _CoreGui:FindFirstChild("Meloska_KeySystem") then _CoreGui.Meloska_KeySystem:Destroy() end
local keyGui = Instance.new("ScreenGui", _CoreGui); keyGui.Name = "Meloska_KeySystem"; keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; keyGui.ResetOnSpawn = false; local _winW, _winH = 320, 400; local win = Instance.new("Frame", keyGui)
win.Size = UDim2.new(0,_winW,0,_winH); win.Position = UDim2.new(0.5,-_winW/2,0.5,-_winH/2); win.BackgroundColor3 = Color3.fromRGB(8,5,18); win.BackgroundTransparency = 0.05
win.BorderSizePixel = 0; win.ZIndex = 11; win.ClipsDescendants = true
Instance.new("UICorner", win).CornerRadius = UDim.new(0, 16); local winStroke = Instance.new("UIStroke", win); winStroke.Color = Color3.fromRGB(140,60,255); winStroke.Thickness = 2; local topBar = Instance.new("Frame", win)
topBar.Size = UDim2.new(1,0,0,46); topBar.BackgroundColor3 = Color3.fromRGB(90,30,180); topBar.BorderSizePixel = 0; topBar.ZIndex = 12; Instance.new("UICorner", topBar).CornerRadius = UDim.new(0, 16); local topFix = Instance.new("Frame", topBar)
topFix.Size = UDim2.new(1,0,0.5,0); topFix.Position = UDim2.new(0,0,0.5,0); topFix.BackgroundColor3 = Color3.fromRGB(90,30,180); topFix.BorderSizePixel = 0; topFix.ZIndex = 12; local titleLbl = Instance.new("TextLabel", topBar)
titleLbl.Size = UDim2.new(1,-60,1,0); titleLbl.Position = UDim2.new(0,12,0,0); titleLbl.BackgroundTransparency = 1; titleLbl.Text = "welcome to the"; titleLbl.TextColor3 = Color3.fromRGB(200,200,200)
titleLbl.Font = Enum.Font.Gotham; titleLbl.TextSize = 12; titleLbl.TextXAlignment = Enum.TextXAlignment.Left; titleLbl.ZIndex = 13; local closeBtn = Instance.new("TextButton", topBar); closeBtn.Size = UDim2.new(0,26,0,26); closeBtn.Position = UDim2.new(1,-34,0.5,-13)
closeBtn.BackgroundColor3 = Color3.fromRGB(200,50,50); closeBtn.BorderSizePixel = 0; closeBtn.Text = "X"; closeBtn.TextColor3 = Color3.fromRGB(255,255,255); closeBtn.Font = Enum.Font.GothamBold; closeBtn.TextSize = 11; closeBtn.AutoButtonColor = false; closeBtn.ZIndex = 13
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0.5, 0); closeBtn.MouseButton1Click:Connect(function() keyGui:Destroy() end)
do; local dragging, dragStart, startPos
    topBar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging=true; dragStart=i.Position; startPos=win.Position; i.Changed:Connect(function() if i.UserInputState == Enum.UserInputState.End then dragging=false end end) end end)
    _UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            local d = i.Position - dragStart; win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+d.X, startPos.Y.Scale, startPos.Y.Offset+d.Y) end end)
    _UIS.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dragging=false end end) end
if isAdmin() then
    local adminBtn = Instance.new("TextButton", win); adminBtn.Size = UDim2.new(1,-20,0,28); adminBtn.Position = UDim2.new(0,10,0,50); adminBtn.BackgroundColor3 = Color3.fromRGB(70,20,140); adminBtn.BorderSizePixel = 0
    adminBtn.Text = ">> Genera Key (Admin)"; adminBtn.TextColor3 = Color3.fromRGB(220,180,255); adminBtn.Font = Enum.Font.GothamBold; adminBtn.TextSize = 11; adminBtn.AutoButtonColor = false; adminBtn.ZIndex = 13; Instance.new("UICorner", adminBtn).CornerRadius = UDim.new(0, 8)
    local adminStroke = Instance.new("UIStroke", adminBtn); adminStroke.Color = Color3.fromRGB(170,80,255); adminStroke.Thickness = 1.5; adminBtn.MouseButton1Click:Connect(function()
        if keyGui:FindFirstChild("AdminPopup") then keyGui.AdminPopup:Destroy(); return end
        local popup = Instance.new("Frame", keyGui); popup.Name = "AdminPopup"; popup.Size = UDim2.new(0,240,0,200); popup.Position = UDim2.new(0.5,-120,0.5,-100); popup.BackgroundColor3 = Color3.fromRGB(10,5,22); popup.BorderSizePixel = 0; popup.ZIndex = 50
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0, 14); local ps = Instance.new("UIStroke", popup); ps.Color = Color3.fromRGB(140,60,255); ps.Thickness = 2; local pt = Instance.new("TextLabel", popup); pt.Size = UDim2.new(1,-40,0,36); pt.Position = UDim2.new(0,10,0,0)
        pt.BackgroundTransparency=1; pt.Text="Scegli tipo key"; pt.TextColor3=Color3.fromRGB(220,180,255); pt.Font=Enum.Font.GothamBold; pt.TextSize=14; pt.ZIndex=51; local pc = Instance.new("TextButton", popup); pc.Size = UDim2.new(0,26,0,26); pc.Position = UDim2.new(1,-30,0,5)
        pc.BackgroundColor3=Color3.fromRGB(200,50,50); pc.BorderSizePixel=0; pc.Text="X"; pc.TextColor3=Color3.fromRGB(255,255,255); pc.Font=Enum.Font.GothamBold; pc.TextSize=11; pc.AutoButtonColor=false; pc.ZIndex=52
        Instance.new("UICorner", pc).CornerRadius = UDim.new(0.5, 0); pc.MouseButton1Click:Connect(function() popup:Destroy() end)
        local pStatus = Instance.new("TextLabel", popup); pStatus.Size = UDim2.new(1,-20,0,20); pStatus.Position = UDim2.new(0,10,0,172)
        pStatus.BackgroundTransparency=1; pStatus.Text=""; pStatus.TextColor3=Color3.fromRGB(100,255,150); pStatus.Font=Enum.Font.Gotham; pStatus.TextSize=11; pStatus.ZIndex=51
        for i, t in ipairs({{"1 Giorno","1D",Color3.fromRGB(180,60,60)},{"2 Settimane","2W",Color3.fromRGB(60,100,200)},{"Lifetime","LT",Color3.fromRGB(120,40,240)}}) do
            local b = Instance.new("TextButton", popup); b.Size = UDim2.new(1,-20,0,36); b.Position = UDim2.new(0,10,0,30+(i-1)*44); b.BackgroundColor3=t[3]; b.BorderSizePixel=0; b.Text=t[1]; b.TextColor3=Color3.fromRGB(255,255,255)
            b.Font=Enum.Font.GothamBold; b.TextSize=13; b.AutoButtonColor=false; b.ZIndex=51; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 8); b.MouseButton1Click:Connect(function()
                local expiry = getExpiryDate(t[2]); local newKey = generateKey(t[2]); local keyLine = (expiry == "lifetime") and newKey or (newKey.."|"..expiry)
                sendKeyToWebhook(keyLine); pStatus.Text="Inviata su Discord!"; b.Text="Inviata!"; task.delay(2, function() popup:Destroy() end) end) end end) end
local logoCircle = Instance.new("Frame", win); logoCircle.Size = UDim2.new(0,52,0,52); logoCircle.Position = UDim2.new(0.5,-26,0,84); logoCircle.BackgroundColor3 = Color3.fromRGB(120,40,240); logoCircle.BorderSizePixel = 0; logoCircle.ZIndex = 12
Instance.new("UICorner", logoCircle).CornerRadius = UDim.new(0.5, 0); local logoM = Instance.new("TextLabel", logoCircle); logoM.Size = UDim2.new(1,0,1,0); logoM.BackgroundTransparency = 1; logoM.Text = "M"
logoM.TextColor3 = Color3.fromRGB(255,255,255); logoM.Font = Enum.Font.GothamBold; logoM.TextSize = 22; logoM.ZIndex = 13; local productLbl = Instance.new("TextLabel", win); productLbl.Size = UDim2.new(1,0,0,26); productLbl.Position = UDim2.new(0,0,0,142); productLbl.BackgroundTransparency = 1
productLbl.Text = "Meloska Development"; productLbl.TextColor3 = Color3.fromRGB(255,255,255); productLbl.Font = Enum.Font.GothamBold; productLbl.TextSize = 16; productLbl.ZIndex = 12
local dotFrame = Instance.new("Frame", win); dotFrame.Size = UDim2.new(0,150,0,16); dotFrame.Position = UDim2.new(0.5,-75,0,172); dotFrame.BackgroundTransparency = 1; dotFrame.ZIndex = 12
local dotDot = Instance.new("Frame", dotFrame); dotDot.Size = UDim2.new(0,9,0,9); dotDot.Position = UDim2.new(0,0,0.5,-4)
dotDot.BackgroundColor3 = Color3.fromRGB(80,220,80); dotDot.BorderSizePixel = 0; dotDot.ZIndex = 12; Instance.new("UICorner", dotDot).CornerRadius = UDim.new(0.5, 0)
local onlineLbl = Instance.new("TextLabel", dotFrame)
onlineLbl.Size = UDim2.new(1,-16,1,0); onlineLbl.Position = UDim2.new(0,16,0,0); onlineLbl.BackgroundTransparency = 1; onlineLbl.Text = "v2 | Steal A Brainrot"; onlineLbl.TextColor3 = Color3.fromRGB(180,180,180)
onlineLbl.Font = Enum.Font.Gotham; onlineLbl.TextSize = 11; onlineLbl.TextXAlignment = Enum.TextXAlignment.Left; onlineLbl.ZIndex = 12; local sep1 = Instance.new("Frame", win); sep1.Size = UDim2.new(1,-30,0,1); sep1.Position = UDim2.new(0,15,0,196)
sep1.BackgroundColor3 = Color3.fromRGB(60,40,90); sep1.BorderSizePixel = 0; sep1.ZIndex = 12; local keyBox = Instance.new("TextBox", win); keyBox.Size = UDim2.new(1,-30,0,42); keyBox.Position = UDim2.new(0,15,0,204); keyBox.BackgroundColor3 = Color3.fromRGB(15,8,30); keyBox.BorderSizePixel = 0
keyBox.Text = ""; keyBox.PlaceholderText = "Inserisci la tua key..."; keyBox.TextColor3 = Color3.fromRGB(255,255,255); keyBox.PlaceholderColor3 = Color3.fromRGB(120,100,160); keyBox.Font = Enum.Font.Gotham; keyBox.TextSize = 12; keyBox.ClearTextOnFocus = false; keyBox.ZIndex = 12
Instance.new("UICorner", keyBox).CornerRadius = UDim.new(0, 10); local kbs = Instance.new("UIStroke", keyBox); kbs.Color = Color3.fromRGB(120,50,220); kbs.Thickness = 1.5; local redeemBtn = Instance.new("TextButton", win)
redeemBtn.Size = UDim2.new(1,-30,0,46); redeemBtn.Position = UDim2.new(0,15,0,254); redeemBtn.BackgroundColor3 = Color3.fromRGB(120,40,240); redeemBtn.BorderSizePixel = 0; redeemBtn.Text = "> Redeem"; redeemBtn.TextColor3 = Color3.fromRGB(255,255,255)
redeemBtn.Font = Enum.Font.GothamBold; redeemBtn.TextSize = 14; redeemBtn.AutoButtonColor = false; redeemBtn.ZIndex = 12; Instance.new("UICorner", redeemBtn).CornerRadius = UDim.new(0, 10); local statusLbl = Instance.new("TextLabel", win)
statusLbl.Size = UDim2.new(1,-30,0,22); statusLbl.Position = UDim2.new(0,15,0,308); statusLbl.BackgroundTransparency = 1; statusLbl.Text = ""; statusLbl.TextColor3 = Color3.fromRGB(255,100,100); statusLbl.Font = Enum.Font.Gotham; statusLbl.TextSize = 11; statusLbl.ZIndex = 12
local sep2 = Instance.new("Frame", win); sep2.Size = UDim2.new(1,-30,0,1); sep2.Position = UDim2.new(0,15,0,335); sep2.BackgroundColor3 = Color3.fromRGB(60,40,90); sep2.BorderSizePixel = 0; sep2.ZIndex = 12; local supportLbl = Instance.new("TextLabel", win)
supportLbl.Size = UDim2.new(1,0,0,20); supportLbl.Position = UDim2.new(0,0,0,340); supportLbl.BackgroundTransparency = 1; supportLbl.Text = "Need support? Join Discord"; supportLbl.TextColor3 = Color3.fromRGB(160,160,160)
supportLbl.Font = Enum.Font.Gotham; supportLbl.TextSize = 11; supportLbl.ZIndex = 12
local function makeSocialBtn(text, idx)
    local btnW = math.floor((_winW - 40) / 3); local btn = Instance.new("TextButton", win); btn.Size = UDim2.new(0,btnW,0,38); btn.Position = UDim2.new(0,15+idx*(btnW+5),0,364); btn.BackgroundColor3 = Color3.fromRGB(14,8,28); btn.BorderSizePixel = 0; btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220,220,220); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.AutoButtonColor = false; btn.ZIndex = 12; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local bs = Instance.new("UIStroke", btn); bs.Color = Color3.fromRGB(100,50,180); bs.Thickness = 1.5; return btn end
local discordBtn = makeSocialBtn("Discord", 0); makeSocialBtn("Twitter", 1); makeSocialBtn("YouTube", 2); discordBtn.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(DISCORD_LINK) end); discordBtn.Text = "Copiato!"; task.delay(2, function() discordBtn.Text = "Discord" end) end)
local function launchMainScript()
    keyGui:Destroy(); local CoreGui          = game:GetService("CoreGui"); local UserInputService = game:GetService("UserInputService"); local RunService       = game:GetService("RunService")
    local Players          = game:GetService("Players"); local TweenService     = game:GetService("TweenService"); local HttpService      = game:GetService("HttpService"); local LocalPlayer      = Players.LocalPlayer
    for _, n in ipairs({"BS_DuelHelper","BS_DuelUI_TopPosition","BS_HUD","BS_TpPicker","BS_AutoGrab","BS_Menu","BS_LoopKiller"}) do
        if CoreGui:FindFirstChild(n) then CoreGui[n]:Destroy() end end
    Instance.new("BoolValue", CoreGui).Name = "BS_LoopKiller"; local tag = Instance.new("StringValue", LocalPlayer); tag.Name = "BS_DUEL_USER"; tag.Value = "using bs duel"; local HUDScreen = Instance.new("ScreenGui", CoreGui)
    HUDScreen.Name = "BS_HUD"; HUDScreen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; HUDScreen.ResetOnSpawn = false
    local function AddOutline(frame)
        local s = Instance.new("UIStroke", frame); s.Color = Color3.fromRGB(255,255,255); s.Thickness = 1; s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border; s.Transparency = 0.6 end
    local TitleBox = Instance.new("Frame", HUDScreen); TitleBox.Size=UDim2.new(0,180,0,32); TitleBox.Position=UDim2.new(0.5,-90,0,8); TitleBox.BackgroundColor3=Color3.fromRGB(0,0,0); TitleBox.BackgroundTransparency=0.45; TitleBox.BorderSizePixel=0; TitleBox.ZIndex=5; Instance.new("UICorner",TitleBox).CornerRadius=UDim.new(0,8)
    local ts=Instance.new("UIStroke",TitleBox); ts.Color=Color3.fromRGB(255,255,255); ts.Thickness=1; ts.Transparency=0.6; local accent=Instance.new("Frame",TitleBox); accent.Size=UDim2.new(0,0,0,0); accent.BackgroundTransparency=1; accent.BorderSizePixel=0
    Instance.new("UICorner",accent).CornerRadius=UDim.new(0,2); local TitleLabel = Instance.new("TextLabel", TitleBox); TitleLabel.Size=UDim2.new(1,-16,1,0); TitleLabel.Position=UDim2.new(0,15,0,0); TitleLabel.BackgroundTransparency=1
    TitleLabel.Text="Meloska DUEL"; TitleLabel.TextColor3=Color3.fromRGB(255,255,255); TitleLabel.Font=Enum.Font.GothamBold; TitleLabel.TextSize=13; TitleLabel.ZIndex=6; TitleLabel.TextXAlignment=Enum.TextXAlignment.Left
    local SETTINGS = {; ENABLED=false, FLOAT=false, AUTOLEFT=false, AUTORIGHT=false,
        SPEED_ENABLED=true, LOCK_ENABLED=false, RADIUS=8,; STEAL_DURATION=0.2, TARGET_SPEED=58, LOCK_SPEED=59,
        JUMP_FORCE=58, UNWALK=false, SPIN_ENABLED=false, SPIN_SPEED=100,; STEAL_SPEED=29.40,
        TAUNT_ON=false, DROP_ON=false,
    }; local SAVE_KEYS = {"ENABLED","FLOAT","AUTOLEFT","AUTORIGHT","LOCK_ENABLED","STEAL_DURATION","TARGET_SPEED","LOCK_SPEED","JUMP_FORCE","SPIN_ENABLED","SPIN_SPEED","UNWALK","STEAL_SPEED"}; local MENU_SAVE_KEY = "BS_MenuConfig"; local LeftPhase, RightPhase = 1, 1
    local floatPart, floatHeight = nil, 0; local isStealing = false; local currentTween = nil; local tpSide = nil; local tpAutoEnabled = false; local autoSwingActive = false
    local DEFAULT_POSITIONS = {; Save      = UDim2.new(0,   8, 0,   8),
        Drop      = UDim2.new(0,   8, 0,  44),; AutoGrab  = UDim2.new(0,   8, 0,  92),
        Lock      = UDim2.new(0,   8, 0, 140),; Float     = UDim2.new(0,   8, 0, 188),
        Taunt     = UDim2.new(0,   8, 0, 236),; SilentTP  = UDim2.new(0.5,-55, 0,   8),
        MenuBtn   = UDim2.new(1,-118, 0,   8),; AutoLeft  = UDim2.new(1,-118, 0,  56),
        AutoRight = UDim2.new(1,-118, 0, 104),; }; local savedPositions = {}; local L_POS_1      = Vector3.new(-476.48, -6.28, 92.73); local L_POS_END    = Vector3.new(-483.12, -4.95, 94.80)
    local L_POS_RETURN = Vector3.new(-475, -8, 19); local L_POS_FINAL  = Vector3.new(-488, -6, 19); local R_POS_1      = Vector3.new(-476.16, -6.52, 25.62); local R_POS_END    = Vector3.new(-483.04, -5.09, 23.14)
    local R_POS_RETURN = Vector3.new(-476, -8, 99); local R_POS_FINAL  = Vector3.new(-488, -6, 102); local TP_LEFT_1    = Vector3.new(-474, -8, 95); local TP_LEFT_2    = Vector3.new(-483, -6, 98)
    local TP_RIGHT_1   = Vector3.new(-473, -8, 25); local TP_RIGHT_2   = Vector3.new(-483, -6, 21); local STP_RIGHT = { Vector3.new(-464.46,-5.85,23.38), Vector3.new(-486.15,-3.50,23.85) }; local STP_LEFT  = { Vector3.new(-469.95,-5.85,90.99), Vector3.new(-485.91,-3.55,96.77) }
    local Connections = {}; local allButtons = {}; local SAVE_KEY = "BS_DuelHelper_Config"
    local function saveConfig()
        local data = {}
        for _, k in ipairs(SAVE_KEYS) do data[k] = SETTINGS[k] end
        data.tpSide = tpSide or "NONE"; data.positions = {}
        for name, btn in pairs(allButtons) do
            data.positions[name] = {xs=btn.Position.X.Scale,xo=btn.Position.X.Offset,ys=btn.Position.Y.Scale,yo=btn.Position.Y.Offset} end
        pcall(function() writefile(SAVE_KEY..".json", HttpService:JSONEncode(data)) end) end
    local function loadConfig()
        local ok, result = pcall(function()
            if isfile(SAVE_KEY..".json") then return HttpService:JSONDecode(readfile(SAVE_KEY..".json")) end end)
        if ok and result then
            for _, k in ipairs(SAVE_KEYS) do if result[k] ~= nil then SETTINGS[k] = result[k] end end
            SETTINGS.SPEED_ENABLED = true
            if result.tpSide and result.tpSide ~= "NONE" then tpSide = result.tpSide end
            if result.positions then savedPositions = result.positions end end end
    loadConfig()
    local function saveMenuConfig()
        local d = {SPIN_ENABLED=SETTINGS.SPIN_ENABLED,SPIN_SPEED=SETTINGS.SPIN_SPEED,TARGET_SPEED=SETTINGS.TARGET_SPEED,STEAL_SPEED=SETTINGS.STEAL_SPEED,UNWALK=SETTINGS.UNWALK}
        pcall(function() writefile(MENU_SAVE_KEY..".json", HttpService:JSONEncode(d)) end) end
    local function loadMenuConfig()
        local ok, result = pcall(function()
            if isfile(MENU_SAVE_KEY..".json") then return HttpService:JSONDecode(readfile(MENU_SAVE_KEY..".json")) end end)
        if ok and result then
            if result.SPIN_ENABLED ~= nil then SETTINGS.SPIN_ENABLED = result.SPIN_ENABLED end
            if result.SPIN_SPEED   ~= nil then SETTINGS.SPIN_SPEED   = result.SPIN_SPEED end
            if result.TARGET_SPEED ~= nil then SETTINGS.TARGET_SPEED = result.TARGET_SPEED end
            if result.STEAL_SPEED  ~= nil then SETTINGS.STEAL_SPEED  = result.STEAL_SPEED end
            if result.UNWALK       ~= nil then SETTINGS.UNWALK       = result.UNWALK end end end
    loadMenuConfig()
    local function resolvePosition(name)
        local p = savedPositions[name]
        if p then return UDim2.new(p.xs,p.xo,p.ys,p.yo) end
        return DEFAULT_POSITIONS[name] end
    local function startAntiRagdoll()
        if Connections.antiRagdoll then return end
        Connections.antiRagdoll = RunService.Heartbeat:Connect(function(); local char = LocalPlayer.Character; if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart"); local hum  = char:FindFirstChildOfClass("Humanoid")
            if hum then
                local st = hum:GetState()
                if st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll or st==Enum.HumanoidStateType.FallingDown then
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                    if workspace.CurrentCamera then workspace.CurrentCamera.CameraSubject = hum end
                    pcall(function(); local PM = LocalPlayer.PlayerScripts:FindFirstChild("PlayerModule")
                        if PM then require(PM:FindFirstChild("ControlModule")):Enable() end end)
                    if root then
                        root.AssemblyLinearVelocity  = Vector3.new(0,0,0); root.AssemblyAngularVelocity = Vector3.new(0,0,0) end
                    if tpAutoEnabled and tpSide then
                        task.spawn(function(); local c2 = LocalPlayer.Character
                            local r2 = c2 and c2:FindFirstChild("HumanoidRootPart"); if not r2 then return end
                            if tpSide == "LEFT" then
                                r2.CFrame = CFrame.new(TP_LEFT_1); task.wait(0.03); r2.CFrame = CFrame.new(TP_LEFT_2)
                            elseif tpSide == "RIGHT" then
                                r2.CFrame = CFrame.new(TP_RIGHT_1); task.wait(0.03); r2.CFrame = CFrame.new(TP_RIGHT_2) end end) end end end
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then obj.Enabled = true end end end) end
    startAntiRagdoll(); UserInputService.JumpRequest:Connect(function()
        local char = LocalPlayer.Character; local hrp = char and char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, SETTINGS.JUMP_FORCE, hrp.AssemblyLinearVelocity.Z) end)
    local function MakeDraggable(frame, onClickCallback)
        local dragging, dragInput, dragStart, startPos, wasDragged = false, nil, nil, nil, false; frame.InputBegan:Connect(function(input)
            if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
                dragging=true; wasDragged=false; dragStart=input.Position; startPos=frame.Position; dragInput=input
                input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end end)
        UserInputService.InputChanged:Connect(function(input)
            if not dragging or input~=dragInput then return end
            local delta = input.Position - dragStart
            if delta.Magnitude > 6 then wasDragged = true end
            frame.Position = UDim2.new(startPos.X.Scale,startPos.X.Offset+delta.X,startPos.Y.Scale,startPos.Y.Offset+delta.Y) end)
        UserInputService.InputEnded:Connect(function(input)
            if input == dragInput then
                dragging = false
                if not wasDragged and onClickCallback then onClickCallback() end
                wasDragged = false end end) end
    local function findBat()
        local char = LocalPlayer.Character
        if char then for _, ch in ipairs(char:GetChildren()) do if ch:IsA("Tool") and ch.Name=="Bat" then return ch end end end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name=="Bat" then return ch end end end end
    local function equipBat()
        local char = LocalPlayer.Character; local hum = char and char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        if char:FindFirstChild("Bat") then return end
        local bat = findBat()
        if bat and bat.Parent==LocalPlayer:FindFirstChild("Backpack") then hum:EquipTool(bat) end end
    local function silentSwing()
        local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local bat = char:FindFirstChild("Bat"); if not bat then return end; local handle = bat:FindFirstChild("Handle"); if not handle then return end
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local eh = p.Character:FindFirstChild("HumanoidRootPart"); local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if eh and hum and hum.Health > 0 and (eh.Position-hrp.Position).Magnitude <= 10 then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            pcall(function() firetouchinterest(handle,part,0) end); pcall(function() firetouchinterest(handle,part,1) end) end end
                    break end end end end
    local function startAutoSwing()
        if autoSwingActive then return end; autoSwingActive = true
        task.spawn(function()
            while autoSwingActive and SETTINGS.LOCK_ENABLED do
                equipBat(); silentSwing(); silentSwing(); task.wait(0.18) end
            autoSwingActive = false end) end
    local function stopAutoSwing() autoSwingActive = false end
    local function findNearestEnemy(myHRP)
        local nearest, nearestDist, nearestTorso = nil, math.huge, nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                local eh = p.Character:FindFirstChild("HumanoidRootPart"); local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if eh and hum and hum.Health > 0 then
                    local d = (eh.Position - myHRP.Position).Magnitude
                    if d < nearestDist then
                        nearestDist=d; nearest=eh; nearestTorso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso") or eh end end end end
        return nearest, nearestDist, nearestTorso end
    local function set_physics(char, active)
        for _, part in pairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CustomPhysicalProperties = active and PhysicalProperties.new(0.7,0.3,0,1,100) or nil end end end
    local function applySpin()
        local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart"); if not root then return end
        set_physics(char, true)
        if root:FindFirstChild("BlaalSpin") then root.BlaalSpin:Destroy() end
        local s = Instance.new("BodyAngularVelocity"); s.Name="BlaalSpin"; s.Parent=root; s.MaxTorque=Vector3.new(0,math.huge,0); s.P=1200; s.AngularVelocity=Vector3.new(0,SETTINGS.SPIN_SPEED,0) end
    local function removeSpin()
        local char = LocalPlayer.Character; local root = char and char:FindFirstChild("HumanoidRootPart")
        if char then set_physics(char, false) end
        if root and root:FindFirstChild("BlaalSpin") then root.BlaalSpin:Destroy() end end
    LocalPlayer.CharacterAdded:Connect(function(char); char:WaitForChild("HumanoidRootPart"); task.wait(0.2)
        if SETTINGS.SPIN_ENABLED then applySpin() end end)
    RunService.PreSimulation:Connect(function()
        if SETTINGS.SPIN_ENABLED then
            local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local vel = root.AssemblyLinearVelocity
                if vel.Magnitude > 150 then root.AssemblyLinearVelocity = Vector3.new(0,vel.Y,0) end
                root.AssemblyAngularVelocity = Vector3.new(0,root.AssemblyAngularVelocity.Y,0) end end end)
    local unwalkConn = nil
    local function startUnwalk()
        if unwalkConn then unwalkConn:Disconnect() end
        unwalkConn = RunService.Heartbeat:Connect(function()
            if not SETTINGS.UNWALK then return end
            local char = LocalPlayer.Character; if not char then return end; local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
            local animator = hum:FindFirstChildOfClass("Animator"); if not animator then return end
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local n = track.Name:lower()
                if n:find("walk") or n:find("run") or n:find("jump") or n:find("fall") then track:Stop(0) end end end) end
    startUnwalk(); local speedBillboard = Instance.new("BillboardGui"); speedBillboard.Name="BS_SpeedDisplay"; speedBillboard.Size=UDim2.new(0,90,0,26); speedBillboard.StudsOffset=Vector3.new(0,3.5,0); speedBillboard.AlwaysOnTop=false; speedBillboard.ResetOnSpawn=false
    local speedLabel = Instance.new("TextLabel", speedBillboard); speedLabel.Size=UDim2.new(1,0,1,0); speedLabel.BackgroundTransparency=1; speedLabel.TextColor3=Color3.fromRGB(255,255,255); speedLabel.Font=Enum.Font.GothamBold
    speedLabel.TextSize=20; speedLabel.Text="0 sp"; speedLabel.TextStrokeTransparency=0.3; speedLabel.TextStrokeColor3=Color3.fromRGB(0,0,0)
    local function attachSpeedDisplay()
        local char = LocalPlayer.Character; if not char then return end; local hrp = char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        speedBillboard.Adornee=hrp; speedBillboard.Parent=CoreGui end
    LocalPlayer.CharacterAdded:Connect(function(char); char:WaitForChild("HumanoidRootPart"); task.wait(0.1); attachSpeedDisplay()
        if not LocalPlayer:FindFirstChild("BS_DUEL_USER") then
            local t2=Instance.new("StringValue",LocalPlayer); t2.Name="BS_DUEL_USER"; t2.Value="using bs duel" end end)
    attachSpeedDisplay(); local trackedTags = {}
    local function addTagToPlayer(p)
        if p==LocalPlayer or trackedTags[p] then return end
        local function tryBuild()
            local char=p.Character; if not char then return end; local head=char:FindFirstChild("Head"); if not head then return end
            local bb=Instance.new("BillboardGui"); bb.Name="BS_DuelTag"; bb.Size=UDim2.new(0,140,0,26); bb.StudsOffset=Vector3.new(0,2.5,0)
            bb.AlwaysOnTop=false; bb.ResetOnSpawn=false; bb.Adornee=head; bb.Parent=CoreGui
            local lbl=Instance.new("TextLabel",bb); lbl.Size=UDim2.new(1,0,1,0); lbl.BackgroundTransparency=1; lbl.TextColor3=Color3.fromRGB(255,255,255); lbl.Font=Enum.Font.GothamBold; lbl.TextSize=14
            lbl.Text="using bs duel"; lbl.TextStrokeTransparency=0.3; lbl.TextStrokeColor3=Color3.fromRGB(0,0,0); trackedTags[p]=bb
            p.CharacterAdded:Connect(function() bb:Destroy(); trackedTags[p]=nil; task.wait(1); tryBuild() end) end
        tryBuild() end
    Players.PlayerAdded:Connect(function(p); p.ChildAdded:Connect(function(child) if child.Name=="BS_DUEL_USER" then addTagToPlayer(p) end end)
        p.ChildRemoved:Connect(function(child) if child.Name=="BS_DUEL_USER" and trackedTags[p] then trackedTags[p]:Destroy(); trackedTags[p]=nil end end) end)
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            p.ChildAdded:Connect(function(child) if child.Name=="BS_DUEL_USER" then addTagToPlayer(p) end end)
            p.ChildRemoved:Connect(function(child) if child.Name=="BS_DUEL_USER" and trackedTags[p] then trackedTags[p]:Destroy(); trackedTags[p]=nil end end)
            if p:FindFirstChild("BS_DUEL_USER") then addTagToPlayer(p) end end end
    local barBox = Instance.new("Frame", HUDScreen); barBox.Size=UDim2.new(0,350,0,10); barBox.Position=UDim2.new(0.5,-175,1,-62); barBox.BackgroundColor3=Color3.fromRGB(0,0,0); barBox.BackgroundTransparency=0.5; barBox.BorderSizePixel=0; barBox.ZIndex=5; Instance.new("UICorner",barBox).CornerRadius=UDim.new(0,5)
    local bs3=Instance.new("UIStroke",barBox); bs3.Color=Color3.fromRGB(255,255,255); bs3.Thickness=1; bs3.Transparency=0.7; local ProgressBarFill = Instance.new("Frame", barBox); ProgressBarFill.Size=UDim2.new(0,0,1,0); ProgressBarFill.BackgroundColor3=Color3.fromRGB(255,255,255)
    ProgressBarFill.BorderSizePixel=0; ProgressBarFill.ZIndex=6; Instance.new("UICorner",ProgressBarFill).CornerRadius=UDim.new(0,5); local stealLbl=Instance.new("TextLabel",HUDScreen); stealLbl.Size=UDim2.new(0,350,0,14); stealLbl.Position=UDim2.new(0.5,-175,1,-78)
    stealLbl.BackgroundTransparency=1; stealLbl.Text="INSTA STEAL"; stealLbl.TextColor3=Color3.fromRGB(120,80,200); stealLbl.Font=Enum.Font.GothamBold; stealLbl.TextSize=10; stealLbl.ZIndex=5; local stealLoopRunning = false
    local stealThread = nil
    local function getPromptPos(prompt)
        if not prompt or not prompt.Parent then return nil end
        local p = prompt.Parent
        if p:IsA("BasePart") then return p.Position
        elseif p:IsA("Model") then local pr=p.PrimaryPart or p:FindFirstChildWhichIsA("BasePart"); return pr and pr.Position
        elseif p:IsA("Attachment") then return p.WorldPosition
        else local pt=p:FindFirstChildWhichIsA("BasePart",true); return pt and pt.Position end end

    local function findNearestStealPrompt()
        local c = LocalPlayer.Character; local root = c and c:FindFirstChild("HumanoidRootPart")
        if not root then return nil end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        local myPos = root.Position; local nearestPrompt, nearestDist = nil, math.huge
        for _, plot in ipairs(plots:GetChildren()) do
            for _, obj in ipairs(plot:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.ActionText=="Steal" then
                    local pos = getPromptPos(obj)
                    if pos then
                        local dist = (myPos-pos).Magnitude
                        if dist <= (obj.MaxActivationDistance + 4) and dist < nearestDist then
                            nearestPrompt=obj; nearestDist=dist end end end end end
        return nearestPrompt end
    local function firePrompt(prompt)
        if not prompt then return end
        task.spawn(function()
            for i = 1, 3 do
                pcall(function() fireproximityprompt(prompt, 99999) end); pcall(function() prompt:InputHoldBegin() end)
                task.wait(0.04); pcall(function() prompt:InputHoldEnd() end)
                task.wait(0.02) end end) end
    local function resetBar()
        if currentTween then currentTween:Cancel(); currentTween=nil end
        ProgressBarFill.Size=UDim2.new(0,0,1,0); isStealing=false end
    local lastGrab = 0
    local function stealLoopFn()
        while SETTINGS.ENABLED do
            RunService.Heartbeat:Wait(); local now = tick()
            local c = LocalPlayer.Character
            if c and (now - lastGrab >= 0.05) then
                local prompt = findNearestStealPrompt()
                if prompt then
                    lastGrab = now; firePrompt(prompt)
                    isStealing=true; ProgressBarFill.Size=UDim2.new(1,0,1,0)
                    task.delay(0.15, function(); ProgressBarFill.Size=UDim2.new(0,0,1,0); isStealing=false end) end end end
        stealLoopRunning=false end
    local function startStealLoop()
        if stealLoopRunning then return end
        stealLoopRunning=true; stealThread=task.spawn(stealLoopFn) end
    local function SetHUDState(btn, label, on)
        btn.Text=label.."\n"..(on and "ON" or "OFF")
        if on then
            btn.TextColor3=Color3.fromRGB(255,255,255); btn.BackgroundColor3=Color3.fromRGB(30,30,30)
            btn.BackgroundTransparency=0.2; local s=btn:FindFirstChildOfClass("UIStroke")
            if s then s.Color=Color3.fromRGB(255,255,255); s.Thickness=1; s.Transparency=0.3 end
        else
            btn.TextColor3=Color3.fromRGB(200,200,200); btn.BackgroundColor3=Color3.fromRGB(0,0,0)
            btn.BackgroundTransparency=0.45; local s=btn:FindFirstChildOfClass("UIStroke")
            if s then s.Color=Color3.fromRGB(255,255,255); s.Thickness=1; s.Transparency=0.6 end end end
    local function MakeHUDButton(name, label, onToggle)
        local btn = Instance.new("TextButton", HUDScreen); btn.Size=UDim2.new(0,110,0,42); btn.Position=resolvePosition(name); btn.BackgroundColor3=Color3.fromRGB(0,0,0); btn.BackgroundTransparency=0.45; btn.BorderSizePixel=0; btn.Text=label.."\nOFF"; btn.TextColor3=Color3.fromRGB(200,200,200)
        btn.Font=Enum.Font.GothamBold; btn.TextSize=11; btn.Visible=true; btn.AutoButtonColor=false; btn.ZIndex=5; Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
        local s=Instance.new("UIStroke",btn); s.Color=Color3.fromRGB(255,255,255); s.Thickness=1; s.Transparency=0.6; s.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; allButtons[name]=btn; local active=false
        MakeDraggable(btn, function() active=not active; onToggle(active); SetHUDState(btn,label,active) end); return btn, function(state) active=state; SetHUDState(btn,label,state) end end
    local AutoGrabHUD, setAutoGrabState = MakeHUDButton("AutoGrab","AUTO GRAB",function(on) SETTINGS.ENABLED=on; if not on then resetBar() end end)
    local LockHUD,     setLockState     = MakeHUDButton("Lock","LOCK ON",function(on) SETTINGS.LOCK_ENABLED=on; if on then equipBat(); startAutoSwing() else stopAutoSwing() end end)
    local FloatHUD,    setFloatState    = MakeHUDButton("Float","FLOAT",function(on) SETTINGS.FLOAT=on; if not on then if floatPart then pcall(function() floatPart:Destroy() end); floatPart=nil end end end)
    local AutoLeftHUD, setAutoLeftState = MakeHUDButton("AutoLeft","AUTO LEFT",function(on) SETTINGS.AUTOLEFT=on; if on then SETTINGS.AUTORIGHT=false; RightPhase=1 end; LeftPhase=1 end)
    local AutoRightHUD,setAutoRightState= MakeHUDButton("AutoRight","AUTO RIGHT",function(on) SETTINGS.AUTORIGHT=on; if on then SETTINGS.AUTOLEFT=false; LeftPhase=1 end; RightPhase=1 end)
    local speedPanelOpen = false; local speedPanel = nil
    local function buildSpeedPanel(anchorBtn)
        if speedPanel then speedPanel:Destroy(); speedPanel=nil; speedPanelOpen=false; return end
        speedPanelOpen = true; local panelGui = Instance.new("ScreenGui", CoreGui); panelGui.Name = "BS_SpeedPanel"; panelGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling; speedPanel = panelGui
        local panel = Instance.new("Frame", panelGui); panel.Size = UDim2.new(0, 200, 0, 110); panel.Position = UDim2.new(0.5, -100, 1, -330); panel.BackgroundColor3 = Color3.fromRGB(0,0,0); panel.BackgroundTransparency = 0.35
        panel.BorderSizePixel = 0; panel.ZIndex = 20; Instance.new("UICorner", panel).CornerRadius = UDim.new(0, 10); local ps = Instance.new("UIStroke", panel); ps.Color = Color3.fromRGB(255,255,255); ps.Thickness = 1; ps.Transparency = 0.6; local title = Instance.new("TextLabel", panel)
        title.Size = UDim2.new(1,-30,0,28); title.Position = UDim2.new(0,8,0,0); title.BackgroundTransparency = 1; title.Text = "[G]  Speed Config"; title.TextColor3 = Color3.fromRGB(255,255,255); title.Font = Enum.Font.GothamBold
        title.TextSize = 12; title.TextXAlignment = Enum.TextXAlignment.Left; title.ZIndex = 21; local closeG = Instance.new("TextButton", panel); closeG.Size = UDim2.new(0,22,0,22); closeG.Position = UDim2.new(1,-26,0,3)
        closeG.BackgroundColor3 = Color3.fromRGB(200,50,50); closeG.BorderSizePixel = 0; closeG.Text = "X"; closeG.TextColor3 = Color3.fromRGB(255,255,255); closeG.Font = Enum.Font.GothamBold; closeG.TextSize = 10; closeG.AutoButtonColor = false; closeG.ZIndex = 22
        Instance.new("UICorner", closeG).CornerRadius = UDim.new(0.5, 0); closeG.MouseButton1Click:Connect(function() panelGui:Destroy(); speedPanel=nil; speedPanelOpen=false end)
        MakeDraggable(panel, nil)
        local function MakeSpeedRow(labelTxt, getVal, setVal, yPos)
            local lbl = Instance.new("TextLabel", panel); lbl.Size = UDim2.new(0,95,0,26); lbl.Position = UDim2.new(0,8,0,yPos); lbl.BackgroundTransparency = 1; lbl.Text = labelTxt; lbl.TextColor3 = Color3.fromRGB(255,255,255); lbl.Font = Enum.Font.GothamBold
            lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 21; local box = Instance.new("TextBox", panel); box.Size = UDim2.new(0,82,0,26); box.Position = UDim2.new(1,-90,0,yPos); box.BackgroundColor3 = Color3.fromRGB(0,0,0); box.BackgroundTransparency = 0.5; box.BorderSizePixel = 0
            box.Text = tostring(getVal()); box.TextColor3 = Color3.fromRGB(255,255,255); box.Font = Enum.Font.GothamBold; box.TextSize = 11; box.ZIndex = 21; Instance.new("UICorner", box).CornerRadius = UDim.new(0, 6)
            local bs2 = Instance.new("UIStroke", box); bs2.Color = Color3.fromRGB(255,255,255); bs2.Thickness = 1; bs2.Transparency = 0.6; box.FocusLost:Connect(function()
                local v = tonumber(box.Text)
                if v then setVal(v); box.Text = tostring(v)
                else box.Text = tostring(getVal()) end end) end
        MakeSpeedRow("Run Speed:",   function() return SETTINGS.TARGET_SPEED end, function(v) SETTINGS.TARGET_SPEED=v end, 32)
        MakeSpeedRow("Steal Speed:", function() return SETTINGS.STEAL_SPEED  end, function(v) SETTINGS.STEAL_SPEED=v  end, 64); panel.Size = UDim2.new(0, 200, 0, 98) end
    local gearLeft = Instance.new("TextButton", AutoLeftHUD); gearLeft.Size = UDim2.new(0,20,0,20); gearLeft.Position = UDim2.new(1,-22,0,2); gearLeft.BackgroundColor3 = Color3.fromRGB(0,0,0); gearLeft.BackgroundTransparency = 0.4; gearLeft.BorderSizePixel = 0; gearLeft.Text = "âš™ï¸"; gearLeft.TextColor3 = Color3.fromRGB(255,255,255)
    gearLeft.Font = Enum.Font.GothamBold; gearLeft.TextSize = 14; gearLeft.AutoButtonColor = false; gearLeft.ZIndex = 7; Instance.new("UICorner", gearLeft).CornerRadius = UDim.new(0.5, 0)
    gearLeft.MouseButton1Click:Connect(function() buildSpeedPanel(AutoLeftHUD) end)
    local gearRight = Instance.new("TextButton", AutoRightHUD); gearRight.Size = UDim2.new(0,20,0,20); gearRight.Position = UDim2.new(1,-22,0,2); gearRight.BackgroundColor3 = Color3.fromRGB(0,0,0); gearRight.BackgroundTransparency = 0.4; gearRight.BorderSizePixel = 0
    gearRight.Text = "âš™ï¸"; gearRight.TextColor3 = Color3.fromRGB(255,255,255); gearRight.Font = Enum.Font.GothamBold; gearRight.TextSize = 14; gearRight.AutoButtonColor = false; gearRight.ZIndex = 7; Instance.new("UICorner", gearRight).CornerRadius = UDim.new(0.5, 0)
    gearRight.MouseButton1Click:Connect(function() buildSpeedPanel(AutoRightHUD) end); local TauntHUD,    setTauntState    = MakeHUDButton("Taunt","TAUNT",function(on)
        SETTINGS.TAUNT_ON=on
        if on then
            task.spawn(function()
                while SETTINGS.TAUNT_ON do
                    pcall(function() local TCS=game:GetService("TextChatService"); local ch=TCS.TextChannels:FindFirstChild("RBXGeneral"); if ch then ch:SendAsync("meloska duel") end end); task.wait(0.5) end end) end end)
    local _wfActive = false; local _wfConns = {}
    local function startWalkFling()
        _wfActive = true; table.insert(_wfConns, RunService.Stepped:Connect(function()
            if not _wfActive then return end
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LocalPlayer and p.Character then
                    for _, part in ipairs(p.Character:GetChildren()) do
                        if part:IsA("BasePart") then pcall(function() part.CanCollide=false end) end end end end
        end))
        task.spawn(function()
            while _wfActive do
                RunService.Heartbeat:Wait(); local char = LocalPlayer.Character
                local root = char and char:FindFirstChild("HumanoidRootPart")
                if root then
                    local vel = root.AssemblyLinearVelocity; pcall(function() root.AssemblyLinearVelocity = vel*10000 + Vector3.new(0,10000,0) end)
                    RunService.Heartbeat:Wait()
                    if root and root.Parent then pcall(function() root.AssemblyLinearVelocity = vel end) end
                    RunService.Stepped:Wait()
                    if root and root.Parent then pcall(function() root.AssemblyLinearVelocity = vel + Vector3.new(0,0.1,0) end) end end end end) end
    local function stopWalkFling()
        _wfActive = false
        for _, c in ipairs(_wfConns) do
            if typeof(c)=="RBXScriptConnection" then c:Disconnect()
            elseif typeof(c)=="thread" then pcall(task.cancel,c) end end
        _wfConns = {} end
    local DropHUD, setDropState = MakeHUDButton("Drop","DROP",function(on)
        if on then
            task.spawn(function(); startWalkFling()
                task.wait(0.4); stopWalkFling()
                SETTINGS.DROP_ON=false; setDropState(false) end) end
        SETTINGS.DROP_ON=on end)
    local function updateTpButton() end
    local silentTpEnabled = false; local silentTpWasRagdoll = false
    local silentTpHum = nil
    local function silentTpGetSide()
        local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
        for _, pl in ipairs(plots:GetChildren()) do
            local s = pl:FindFirstChild("PlotSign"); local b = pl:FindFirstChild("DeliveryHitbox")
            if s and s:FindFirstChild("YourBase") and s.YourBase.Enabled and b then
                local t = pl:FindFirstChild("AnimalTarget", true)
                if t then
                    local pos = t.Position; local dl = (pos - STP_LEFT[1]).Magnitude; local dr = (pos - STP_RIGHT[1]).Magnitude; return dl > dr and "left" or "right" end end end
        return nil end
    local function doSilentTp()
        local side = silentTpGetSide(); if not side then return end; local char = LocalPlayer.Character; if not char then return end
        char:PivotTo(CFrame.new(side=="left" and STP_LEFT[1] or STP_RIGHT[1])); task.wait(0.1); char:PivotTo(CFrame.new(side=="left" and STP_LEFT[2] or STP_RIGHT[2])) end
    if LocalPlayer.Character then
        local h = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if h then silentTpHum = h end end
    LocalPlayer.CharacterAdded:Connect(function(char); char:WaitForChild("Humanoid"); silentTpHum = char:FindFirstChildOfClass("Humanoid")
        silentTpWasRagdoll = false end)
    RunService.Heartbeat:Connect(function()
        if not silentTpEnabled or not silentTpHum then return end
        local isRagdoll = silentTpHum:GetState() == Enum.HumanoidStateType.Physics
        if isRagdoll and not silentTpWasRagdoll then
            task.spawn(doSilentTp) end
        silentTpWasRagdoll = isRagdoll end)
    local SilentTPHUD = Instance.new("TextButton", HUDScreen); SilentTPHUD.Size=UDim2.new(0,110,0,38); SilentTPHUD.Position=resolvePosition("SilentTP"); SilentTPHUD.BackgroundColor3=Color3.fromRGB(0,0,0); SilentTPHUD.BackgroundTransparency=0.45; SilentTPHUD.BorderSizePixel=0
    SilentTPHUD.Text="AUTO TP\nOFF"; SilentTPHUD.TextColor3=Color3.fromRGB(200,200,200); SilentTPHUD.Font=Enum.Font.GothamBold; SilentTPHUD.TextSize=11; SilentTPHUD.AutoButtonColor=false; SilentTPHUD.ZIndex=5
    Instance.new("UICorner",SilentTPHUD).CornerRadius=UDim.new(0,8); AddOutline(SilentTPHUD); allButtons["SilentTP"]=SilentTPHUD; MakeDraggable(SilentTPHUD, function()
        silentTpEnabled = not silentTpEnabled; SilentTPHUD.Text="AUTO TP\n"..(silentTpEnabled and "ON" or "OFF"); SilentTPHUD.TextColor3=Color3.fromRGB(255,255,255)
        SilentTPHUD.BackgroundColor3=Color3.fromRGB(0,0,0); SilentTPHUD.BackgroundTransparency=silentTpEnabled and 0.2 or 0.45 end)
    local SaveBtn=Instance.new("TextButton",HUDScreen); SaveBtn.Size=UDim2.new(0,80,0,28); SaveBtn.Position=resolvePosition("Save"); SaveBtn.BackgroundColor3=Color3.fromRGB(0,0,0); SaveBtn.BackgroundTransparency=0.45; SaveBtn.BorderSizePixel=0; SaveBtn.Text="SAVE"
    SaveBtn.TextColor3=Color3.fromRGB(255,255,255); SaveBtn.Font=Enum.Font.GothamBold; SaveBtn.TextSize=11; SaveBtn.AutoButtonColor=false; SaveBtn.ZIndex=5; Instance.new("UICorner",SaveBtn).CornerRadius=UDim.new(0,8); AddOutline(SaveBtn); allButtons["Save"]=SaveBtn
    MakeDraggable(SaveBtn, function(); saveConfig(); SaveBtn.Text="SAVED"; SaveBtn.TextColor3=Color3.fromRGB(255,255,255)
        task.delay(1.5, function() SaveBtn.Text="SAVE"; SaveBtn.TextColor3=Color3.fromRGB(200,200,200) end) end)
    local menuOpen = false; local menuPanel = nil; local MenuBtn=Instance.new("TextButton",HUDScreen); MenuBtn.Size=UDim2.new(0,110,0,38); MenuBtn.Position=resolvePosition("MenuBtn")
    MenuBtn.BackgroundColor3=Color3.fromRGB(0,0,0); MenuBtn.BackgroundTransparency=0.45; MenuBtn.BorderSizePixel=0; MenuBtn.Text="MENU"; MenuBtn.TextColor3=Color3.fromRGB(255,255,255); MenuBtn.Font=Enum.Font.GothamBold; MenuBtn.TextSize=12; MenuBtn.AutoButtonColor=false; MenuBtn.ZIndex=5
    Instance.new("UICorner",MenuBtn).CornerRadius=UDim.new(0,8); AddOutline(MenuBtn); allButtons["MenuBtn"]=MenuBtn
    local function buildMenuPanel()
        if menuPanel then menuPanel:Destroy(); menuPanel=nil end
        local panelGui=Instance.new("ScreenGui",CoreGui); panelGui.Name="BS_Menu"; panelGui.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; menuPanel=panelGui; local panel=Instance.new("Frame",panelGui); panel.Size=UDim2.new(0,220,0,10); panel.Position=UDim2.new(0.5,-110,0.5,-145)
        panel.BackgroundColor3=Color3.fromRGB(15,15,15); panel.BorderSizePixel=0; panel.ZIndex=10; Instance.new("UICorner",panel).CornerRadius=UDim.new(0,8); AddOutline(panel); local panelTitle=Instance.new("TextLabel",panel); panelTitle.Size=UDim2.new(1,0,0,32); panelTitle.BackgroundTransparency=1
        panelTitle.Text="Meloska MENU"; panelTitle.TextColor3=Color3.fromRGB(255,255,255); panelTitle.Font=Enum.Font.GothamBold; panelTitle.TextSize=13; panelTitle.ZIndex=11; local closeBtn2=Instance.new("TextButton",panel); closeBtn2.Size=UDim2.new(0,28,0,28); closeBtn2.Position=UDim2.new(1,-32,0,2)
        closeBtn2.BackgroundColor3=Color3.fromRGB(30,30,30); closeBtn2.BorderSizePixel=0; closeBtn2.Text="X"; closeBtn2.TextColor3=Color3.fromRGB(200,200,200); closeBtn2.Font=Enum.Font.GothamBold; closeBtn2.TextSize=12; closeBtn2.AutoButtonColor=false; closeBtn2.ZIndex=12
        Instance.new("UICorner",closeBtn2).CornerRadius=UDim.new(0,6); closeBtn2.MouseButton1Click:Connect(function()
            menuOpen=false; panelGui:Destroy(); menuPanel=nil; MenuBtn.Text="MENU"; MenuBtn.BackgroundColor3=Color3.fromRGB(0,0,0); MenuBtn.BackgroundTransparency=0.45; MenuBtn.TextColor3=Color3.fromRGB(255,255,255) end)
        MakeDraggable(panel, nil); local yOff = 38
        local function MakeMenuToggle(labelText, currentState, onToggle)
            local btn=Instance.new("TextButton",panel); btn.Size=UDim2.new(1,-20,0,38); btn.Position=UDim2.new(0,10,0,yOff); btn.BackgroundColor3=currentState and Color3.fromRGB(40,40,40) or Color3.fromRGB(22,22,22); btn.BorderSizePixel=0; btn.Text=labelText.."\n"..(currentState and "ON" or "OFF")
            btn.TextColor3=currentState and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,160); btn.Font=Enum.Font.GothamBold; btn.TextSize=11; btn.AutoButtonColor=false; btn.ZIndex=11; Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8); AddOutline(btn); yOff=yOff+46
            local state=currentState; btn.MouseButton1Click:Connect(function()
                state=not state; btn.Text=labelText.."\n"..(state and "ON" or "OFF"); btn.TextColor3=state and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,160); btn.BackgroundColor3=state and Color3.fromRGB(40,40,40) or Color3.fromRGB(22,22,22); onToggle(state)
            end) end
        local function MakeInputRow(labelText, currentVal, onChanged)
            local lbl=Instance.new("TextLabel",panel); lbl.Size=UDim2.new(0,100,0,28); lbl.Position=UDim2.new(0,10,0,yOff); lbl.BackgroundTransparency=1; lbl.Text=labelText; lbl.TextColor3=Color3.fromRGB(200,200,200)
            lbl.Font=Enum.Font.GothamBold; lbl.TextSize=11; lbl.TextXAlignment=Enum.TextXAlignment.Left; lbl.ZIndex=11; local box=Instance.new("TextBox",panel); box.Size=UDim2.new(0,90,0,28); box.Position=UDim2.new(1,-100,0,yOff)
            box.BackgroundColor3=Color3.fromRGB(25,25,25); box.BorderSizePixel=0; box.Text=tostring(currentVal); box.TextColor3=Color3.fromRGB(255,255,255); box.Font=Enum.Font.GothamBold; box.TextSize=11; box.ZIndex=11; Instance.new("UICorner",box).CornerRadius=UDim.new(0,6); AddOutline(box)
            box.FocusLost:Connect(function() local val=tonumber(box.Text); if val then onChanged(val); box.Text=tostring(val) else box.Text=tostring(currentVal) end end); yOff=yOff+36 end
        MakeMenuToggle("SPIN",SETTINGS.SPIN_ENABLED,function(on) SETTINGS.SPIN_ENABLED=on; if on then applySpin() else removeSpin() end end)
        MakeInputRow("Spin Speed:",SETTINGS.SPIN_SPEED,function(val) SETTINGS.SPIN_SPEED=val; if SETTINGS.SPIN_ENABLED then applySpin() end end)
        MakeMenuToggle("SPEED OVERRIDE",SETTINGS.SPEED_ENABLED,function() SETTINGS.SPEED_ENABLED=true end); MakeInputRow("Speed Value:",SETTINGS.TARGET_SPEED,function(val) SETTINGS.TARGET_SPEED=val end)
        MakeInputRow("Steal Speed:",SETTINGS.STEAL_SPEED,function(val) SETTINGS.STEAL_SPEED=val end); MakeMenuToggle("UNWALK",SETTINGS.UNWALK,function(on) SETTINGS.UNWALK=on end)
        local menuSaveBtn=Instance.new("TextButton",panel); menuSaveBtn.Size=UDim2.new(1,-20,0,34); menuSaveBtn.Position=UDim2.new(0,10,0,yOff); menuSaveBtn.BackgroundColor3=Color3.fromRGB(22,22,22); menuSaveBtn.BorderSizePixel=0; menuSaveBtn.Text="SAVE MENU CONFIG"
        menuSaveBtn.TextColor3=Color3.fromRGB(255,255,255); menuSaveBtn.Font=Enum.Font.GothamBold; menuSaveBtn.TextSize=11; menuSaveBtn.AutoButtonColor=false; menuSaveBtn.ZIndex=11; Instance.new("UICorner",menuSaveBtn).CornerRadius=UDim.new(0,8); AddOutline(menuSaveBtn)
        menuSaveBtn.MouseButton1Click:Connect(function(); saveMenuConfig(); menuSaveBtn.Text="SAVED"; menuSaveBtn.TextColor3=Color3.fromRGB(255,255,255); menuSaveBtn.BackgroundColor3=Color3.fromRGB(40,40,40)
            task.delay(1.5, function() menuSaveBtn.Text="SAVE MENU CONFIG"; menuSaveBtn.TextColor3=Color3.fromRGB(255,255,255); menuSaveBtn.BackgroundColor3=Color3.fromRGB(22,22,22) end) end)
        yOff=yOff+42; panel.Size=UDim2.new(0,220,0,yOff+12) end
    MakeDraggable(MenuBtn, function(); menuOpen=not menuOpen
        if menuOpen then
            MenuBtn.Text="MENU\nOPEN"; MenuBtn.BackgroundColor3=Color3.fromRGB(0,0,0); MenuBtn.BackgroundTransparency=0.2; MenuBtn.TextColor3=Color3.fromRGB(255,255,255); buildMenuPanel()
        else
            MenuBtn.Text="MENU"; MenuBtn.BackgroundColor3=Color3.fromRGB(0,0,0); MenuBtn.BackgroundTransparency=0.45; MenuBtn.TextColor3=Color3.fromRGB(255,255,255)
            if menuPanel then menuPanel:Destroy(); menuPanel=nil end end end)
    SETTINGS.SPEED_ENABLED=true
    if SETTINGS.ENABLED then setAutoGrabState(true) end
    if SETTINGS.LOCK_ENABLED then setLockState(true); equipBat(); startAutoSwing() end
    if SETTINGS.FLOAT then setFloatState(true) end
    if SETTINGS.AUTOLEFT then setAutoLeftState(true) end
    if SETTINGS.AUTORIGHT then setAutoRightState(true) end
    if SETTINGS.SPIN_ENABLED then applySpin() end
    RunService.Heartbeat:Connect(function(); local char = LocalPlayer.Character; if not char then return end
        local hum  = char:FindFirstChildOfClass("Humanoid"); local hrp  = char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hum then return end
        speedLabel.Text = math.floor(hrp.AssemblyLinearVelocity.Magnitude).." sp"
        if SETTINGS.AUTOLEFT and SETTINGS.AUTORIGHT then SETTINGS.AUTORIGHT=false; setAutoRightState(false) end
        if SETTINGS.LOCK_ENABLED then
            if not char:FindFirstChild("Bat") then equipBat() end
            local target, dist, torso = findNearestEnemy(hrp)
            if target and torso then
                local predicted = torso.Position + target.AssemblyLinearVelocity * 0.08; local fullDir = predicted - hrp.Position
                if fullDir.Magnitude > 0.8 then
                    local u = fullDir.Unit; local spd = SETTINGS.LOCK_SPEED * (dist < 4 and 0.4 or 1); hrp.AssemblyLinearVelocity = Vector3.new(u.X*spd, hrp.AssemblyLinearVelocity.Y, u.Z*spd)
                else
                    hrp.AssemblyLinearVelocity = Vector3.new(target.AssemblyLinearVelocity.X, hrp.AssemblyLinearVelocity.Y, target.AssemblyLinearVelocity.Z) end end
        elseif SETTINGS.SPEED_ENABLED then
            if hum.MoveDirection.Magnitude > 0 then
                local activeSpeed = LocalPlayer:GetAttribute("Stealing") and SETTINGS.STEAL_SPEED or SETTINGS.TARGET_SPEED; hrp.AssemblyLinearVelocity = Vector3.new(hum.MoveDirection.X*activeSpeed, hrp.AssemblyLinearVelocity.Y, hum.MoveDirection.Z*activeSpeed)
            end end
        if SETTINGS.ENABLED and not stealLoopRunning then startStealLoop() end
        if SETTINGS.FLOAT then
            if not floatPart then
                floatHeight = hrp.Position.Y; floatPart = Instance.new("BodyPosition", hrp)
                floatPart.Name = "MelFloatBP"; floatPart.MaxForce = Vector3.new(0, math.huge, 0)
                floatPart.D = 1000; floatPart.P = 10000; floatPart.Position = Vector3.new(hrp.Position.X, floatHeight, hrp.Position.Z)
            else
                floatPart.Position = Vector3.new(hrp.Position.X, floatHeight, hrp.Position.Z) end
        elseif floatPart then
            floatPart:Destroy(); floatPart=nil end
        local moveActive = SETTINGS.AUTOLEFT and "Left" or (SETTINGS.AUTORIGHT and "Right" or nil)
        if moveActive then
            local phase   = moveActive=="Left" and LeftPhase   or RightPhase; local p1      = moveActive=="Left" and L_POS_1     or R_POS_1; local pEnd    = moveActive=="Left" and L_POS_END   or R_POS_END; local pReturn = moveActive=="Left" and L_POS_RETURN or R_POS_RETURN
            local pFinal  = moveActive=="Left" and L_POS_FINAL  or R_POS_FINAL; local speed   = (phase >= 3) and SETTINGS.STEAL_SPEED or 59; local target2
            if    phase==1 then target2=p1
            elseif phase==2 then target2=pEnd
            elseif phase==3 then target2=p1
            elseif phase==4 then target2=pReturn
            elseif phase==5 then target2=pFinal end
            local dist2 = (Vector3.new(target2.X, hrp.Position.Y, target2.Z) - hrp.Position).Magnitude
            if dist2 < 0.5 then
                if moveActive=="Left" then
                    if LeftPhase<5 then LeftPhase=LeftPhase+1
                    else SETTINGS.AUTOLEFT=false; setAutoLeftState(false); LeftPhase=1 end
                else
                    if RightPhase<5 then RightPhase=RightPhase+1
                    else SETTINGS.AUTORIGHT=false; setAutoRightState(false); RightPhase=1 end end
            else
                local dir = (target2 - hrp.Position).Unit; hrp.AssemblyLinearVelocity = Vector3.new(dir.X*speed, hrp.AssemblyLinearVelocity.Y, dir.Z*speed) end end end) end
local function tryRedeem(inputKey)
    redeemBtn.Text="Checking..."; redeemBtn.BackgroundColor3=Color3.fromRGB(50,30,80); statusLbl.Text=""; local cleanKey = (inputKey:match("^([^|]+)") or inputKey):match("^%s*(.-)%s*$"); local valid, info = checkKeyValid(cleanKey)
    if valid then
        saveKeyLocally(cleanKey); statusLbl.Text="Key valida! "..(info=="lifetime" and "Lifetime" or "Scade: "..tostring(info)); statusLbl.TextColor3=Color3.fromRGB(100,255,150)
        task.spawn(function() task.wait(1); launchMainScript() end)
    else
        redeemBtn.Text="> Redeem"; redeemBtn.BackgroundColor3=Color3.fromRGB(120,40,240);statusLbl.Text="X "..(info or "Key non valida!"); statusLbl.TextColor3=Color3.fromRGB(255,80,80) end end
redeemBtn.MouseButton1Click:Connect(function(); local input = keyBox.Text:match("^%s*(.-)%s*$")
    if input=="" then statusLbl.Text="Inserisci una key!"; statusLbl.TextColor3=Color3.fromRGB(255,200,50); return end
    tryRedeem(input) end)
local savedKey = loadSavedKey()
if savedKey and savedKey ~= "" then
    local cleanSaved = (savedKey:match("^([^|]+)") or savedKey):match("^%s*(.-)%s*$"); keyBox.Text = cleanSaved; task.spawn(function() task.wait(0.5); tryRedeem(cleanSaved) end) end
