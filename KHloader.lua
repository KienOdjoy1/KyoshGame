--//============================================================//
--// 🛡️ KYOSH UNIVERSAL LOADER
--//============================================================//

local PlaceId = game.PlaceId

local Scripts = {

    --// 🥚 STEAL AN EGG
    [107778070777162] = {
        "https://raw.githubusercontent.com/KienOdjoy1/KyoshGame/refs/heads/main/KHsae.lua"
    },

    --// 🌱 GROW A GARDEN 2
    [97598239454123] = {
        "https://raw.githubusercontent.com/KienOdjoy1/gag2/refs/heads/main/wgag2.lua"
    }

}

local SelectedScripts = Scripts[PlaceId]

if not SelectedScripts then
    error(
        "❌ KYOSH: Unsupported game\n" ..
        "PlaceId: " .. tostring(PlaceId)
    )
end

print("🎮 KYOSH GAME DETECTED")
print("📌 PlaceId:", PlaceId)

for _, URL in ipairs(SelectedScripts) do

    print("📡 Loading:", URL)

    local Success, Result = pcall(function()
        return game:HttpGet(URL)
    end)

    if not Success then
        warn("❌ Failed to download script")
        warn(Result)
        continue
    end

    if not Result or Result == "" then
        warn("❌ Empty script received")
        continue
    end

    local Function, CompileError =
        loadstring(Result)

    if not Function then
        warn("❌ Script compilation failed")
        warn(CompileError)
        continue
    end

    local ExecuteSuccess, ExecuteError =
        pcall(Function)

    if not ExecuteSuccess then
        warn("❌ Script execution failed")
        warn(ExecuteError)
    else
        print("✅ Script loaded successfully")
    end

    task.wait(0.5)
end

print("🛡️ KYOSH Universal Loader finished")
