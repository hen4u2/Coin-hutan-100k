-- Script untuk mencoba berbagai method menambah coin
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

print("═══════════════════════════════════════")
print("   COIN ADD METHOD TESTER")
print("═══════════════════════════════════════")
print("")

-- Function untuk test berbagai method
local function testAddCoin(amount)
    print("🔍 Testing method untuk menambah " .. amount .. " coin...")
    print("")
    
    local success = false
    
    -- METHOD 1: Coba semua remote dengan parameter jumlah
    print("📡 METHOD 1: Mencoba Remote Events...")
    for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local name = obj.Name:lower()
            if name:match("coin") or name:match("money") or name:match("cash") or
               name:match("add") or name:match("reward") or name:match("collect") then
                
                print("   ├─ Trying: " .. obj.Name)
                
                -- Coba berbagai format parameter
                local attempts = {
                    {amount},
                    {player, amount},
                    {tostring(amount)},
                    {player.Name, amount},
                    {amount, player},
                    {player, "add", amount},
                    {player, amount, "coin"},
                    {tonumber(amount)},
                    {player, {amount}},
                    {player, amount, true}
                }
                
                for i, args in ipairs(attempts) do
                    local success2, result = pcall(function()
                        obj:FireServer(unpack(args))
                        return true
                    end)
                    
                    if success2 then
                        print("      ✅ Success dengan args: " .. table.concat(args, ", "))
                        success = true
                        break
                    end
                end
            end
        end
    end
    
    -- METHOD 2: Coba Remote Functions
    if not success then
        print("")
        print("📞 METHOD 2: Mencoba Remote Functions...")
        for _, obj in ipairs(ReplicatedStorage:GetDescendants()) do
            if obj:IsA("RemoteFunction") then
                local name = obj.Name:lower()
                if name:match("coin") or name:match("money") or name:match("cash") or
                   name:match("add") or name:match("reward") or name:match("collect") then
                    
                    print("   ├─ Trying: " .. obj.Name)
                    
                    local attempts = {
                        {amount},
                        {player, amount},
                        {tostring(amount)},
                        {player.Name, amount},
                        {amount, player},
                        {player, "add", amount},
                        {player, amount, "coin"},
                        {player, {amount}},
                        {player, amount, true}
                    }
                    
                    for i, args in ipairs(attempts) do
                        local success2, result = pcall(function()
                            return obj:InvokeServer(unpack(args))
                        end)
                        
                        if success2 then
                            print("      ✅ Success dengan args: " .. table.concat(args, ", "))
                            print("      └─ Result: " .. tostring(result))
                            success = true
                            break
                        end
                    end
                end
            end
        end
    end
    
    -- METHOD 3: Coba melalui touch (collect coin)
    if not success then
        print("")
        print("🪙 METHOD 3: Mencoba Touch Method...")
        local character = player.Character
        if character then
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if hrp then
                -- Cari coin terdekat
                local nearestCoin = nil
                local nearestDist = math.huge
                
                for _, obj in ipairs(game:GetService("Workspace"):GetDescendants()) do
                    if obj:IsA("BasePart") and (obj.Name:lower():match("coin") or obj.Name:lower():match("money")) then
                        local dist = (hrp.Position - obj.Position).Magnitude
                        if dist < nearestDist then
                            nearestDist = dist
                            nearestCoin = obj
                        end
                    end
                end
                
                if nearestCoin then
                    print("   ├─ Found coin at: " .. tostring(nearestCoin.Position))
                    local originalPos = hrp.Position
                    hrp.CFrame = CFrame.new(nearestCoin.Position + Vector3.new(0, 2, 0))
                    task.wait(0.2)
                    hrp.CFrame = CFrame.new(originalPos)
                    print("   └─ Teleported to coin!")
                    success = true
                else
                    print("   ❌ No coin found")
                end
            end
        end
    end
    
    if success then
        print("")
        print("✅ Berhasil menambahkan coin!")
    else
        print("")
        print("❌ Gagal menambahkan coin dengan semua method")
        print("💡 Coba analisis lebih lanjut dengan Script 1")
    end
    
    print("")
    print("═══════════════════════════════════════")
end

-- Test dengan 100 coin


for i = 1, 500 do
    testAddCoin(200)
end
