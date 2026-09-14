local Workspace = game:GetService("Workspace")

-- Remove Gardens Plots 3-8
local gardens = Workspace:FindFirstChild("Gardens")

if gardens then
    for i = 3, 8 do
        local plot = gardens:FindFirstChild("Plot" .. i)
            or gardens:FindFirstChild("Plot " .. i)

        if plot then
            plot:Destroy()
        end
    end
end

-- Keep Baseplate, remove ONLY Decor
local baseplate = Workspace:FindFirstChild("Baseplate")

if baseplate then
    local decor = baseplate:FindFirstChild("Decor")

    if decor then
        decor:Destroy()
    end
end
