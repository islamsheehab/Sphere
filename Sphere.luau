local RunService = game:GetService("RunService")

local noiseFrequency = 0.1
local sphereVerticalOffset = 80
local shellThickness = 1

local sphereContainer = Instance.new("Folder")
sphereContainer.Name = "Sphere"
sphereContainer.Parent = workspace

local function getColorFromNoise(x: number, y: number, z: number, frequency: number): Color3
    local red = math.noise(x * frequency, y * frequency, z * frequency) * 0.5 + 0.5
    local green = math.noise(z * frequency, x * frequency, y * frequency) * 0.5 + 0.5
    local blue = math.noise(y * frequency, z * frequency, x * frequency) * 0.5 + 0.5
    return Color3.new(red, green, blue)
end

local function isWithinShell(position: Vector3, radius: number, thickness: number): boolean
    local distance = position.Magnitude
    return distance <= radius and distance >= (radius - thickness)
end

local function createAnchoredPart(): Part
    local part = Instance.new("Part")
    part.Anchored = true
    part.Size = Vector3.new(1, 1, 1)
    part.Material = Enum.Material.SmoothPlastic
    part.Locked = true
    part.Parent = sphereContainer
    return part
end

local function drawShellLayer(radius: number)
    local reusableParts = sphereContainer:GetChildren()

    for x = -radius, radius do
        for y = -radius, radius do
            for z = -radius, radius do
                local position = Vector3.new(x, y, z)
                if isWithinShell(position, radius, shellThickness) then
                    local part = table.remove(reusableParts) or createAnchoredPart()
                    part.Position = Vector3.new(x, y + sphereVerticalOffset, z)
                    part.Color = getColorFromNoise(x, y, z, noiseFrequency)
                end
            end
        end
    end
end

for currentRadius = 5, 50, 0.1 do
    drawShellLayer(currentRadius)
    RunService.Stepped:Wait()
end
