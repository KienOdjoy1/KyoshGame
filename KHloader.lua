--//============================================================//
--// 🛡️ KYOSH UNIVERSAL LOADER
--// Secure / Robust Version
--//============================================================//

local PlaceId = game.PlaceId

local Scripts = {
    --// 🥚 STEAL AN EGG
    [107778070777162] = {
        "https://raw.githubusercontent.com/KienOdjoy1/KyoshGame/refs/heads/main/KHsae.lua"
    },

    --// 🌱 GROW A GARDEN 2
    [126987765280963] = {
        "https://raw.githubusercontent.com/KienOdjoy1/KyoshGame/refs/heads/main/KHgag.lua"
    }
}

--==============================================================--
-- CONFIG
--==============================================================--

local MAX_RETRIES = 3
local RETRY_DELAY = 1
local REQUEST_DELAY = 0.5

--==============================================================--
-- HELPERS
--==============================================================--

local function log(...)
    print("[KYOSH]", ...)
end

local function warnLog(...)
    warn("[KYOSH]", ...)
end

local function downloadScript(url)
    if type(url) ~= "string" or url == "" then
        return nil, "Invalid URL"
    end

    for attempt = 1, MAX_RETRIES do
        log(("Downloading (attempt %d/%d): %s")
            :format(attempt, MAX_RETRIES, url))

        local success, result = pcall(function()
            return game:HttpGet(url)
        end)

        if success and type(result) == "string" and #result > 0 then

            -- Basic sanity check.
            -- GitHub raw Lua files should not normally begin with HTML.
            local lowered = result:lower()

            if lowered:find("<!doctype html", 1, true)
                or lowered:find("<html", 1, true) then

                warnLog("Server returned HTML instead of Lua.")
            else
                return result, nil
            end
        else
            warnLog("HTTP request failed:", tostring(result))
        end

        if attempt < MAX_RETRIES then
            task.wait(RETRY_DELAY)
        end
    end

    return nil, "Failed to download script after retries"
end

local function compileScript(source, url)
    if type(loadstring) ~= "function" then
        return nil, "loadstring is unavailable in this environment"
    end

    local fn, compileError = loadstring(source)

    if not fn then
        return nil,
            "Compilation failed for " ..
            tostring(url) ..
            "\n" ..
            tostring(compileError)
    end

    return fn, nil
end

local function executeScript(fn, url)
    local success, result = pcall(fn)

    if not success then
        return false,
            "Execution failed for " ..
            tostring(url) ..
            "\n" ..
            tostring(result)
    end

    return true, nil
end

--==============================================================--
-- PLACE CHECK
--==============================================================--

local SelectedScripts = Scripts[PlaceId]

if not SelectedScripts then
    error(
        "[KYOSH] Unsupported game\n" ..
        "PlaceId: " .. tostring(PlaceId)
    )
end

--==============================================================--
-- LOADER
--==============================================================--

log("🎮 Game detected")
log("📌 PlaceId:", PlaceId)
log("📦 Scripts:", #SelectedScripts)

for index, url in ipairs(SelectedScripts) do

    log(("━━━━━━━━ Script %d/%d ━━━━━━━━")
        :format(index, #SelectedScripts))

    -- Download
    local source, downloadError = downloadScript(url)

    if not source then
        warnLog(downloadError)
        continue
    end

    log("✅ Download successful")
    log("📏 Script size:", #source, "bytes")

    -- Compile
    local fn, compileError = compileScript(source, url)

    if not fn then
        warnLog(compileError)
        continue
    end

    log("✅ Compilation successful")

    -- Execute
    local success, executeError = executeScript(fn, url)

    if not success then
        warnLog(executeError)
        continue
    end

    log("✅ Script executed successfully")

    task.wait(REQUEST_DELAY)
end

log("━━━━━━━━━━━━━━━━━━━━━━━━━━━━")
log("🛡️ KYOSH Universal Loader finished")
