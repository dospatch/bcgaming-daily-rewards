local isReady = false
local currentDay = 1
local currentStreak = 0
local maxStreak = 30
local hoursLeft = 0
local rewardsData = {}

local function notify(msgType, ...)
    local text = Config.Locale[msgType]
    if not text then return end
    local formatted = string.format(text, ...)

    if Config.Notification == 'ox_lib' then
        lib.notify({ title = 'Daily Rewards', description = formatted, type = 'success' })
    elseif Config.Notification == 'esx' then
        ESX.ShowNotification(formatted)
    elseif Config.Notification == 'qb' then
        QBCore.Functions.Notify(formatted, 'success')
    else
        SetNotificationTextEntry('STRING')
        AddTextComponentSubstringPlayerName(formatted)
        DrawNotification(true, false)
    end
end

RegisterNetEvent('dailyrewards:notify', function(msgType, ...)
    notify(msgType, ...)
end)

RegisterNetEvent('dailyrewards:status', function(data)
    isReady = data.ready
    currentDay = data.day
    currentStreak = data.streak
    maxStreak = data.maxStreak
    hoursLeft = data.hours
    rewardsData = data.rewards
end)

RegisterNetEvent('dailyrewards:receiveMoney', function(amount)
end)

RegisterNetEvent('dailyrewards:setArmor', function(amount)
    SetPedArmour(PlayerPedId(), amount)
end)

RegisterNetEvent('dailyrewards:spawnVehicle', function(model)
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local veh = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)

    if veh ~= 0 then
        notify('claimed', 'Vehicle spawned nearby already')
        return
    end

    Citizen.CreateThread(function()
        local modelHash = GetHashKey(model)
        RequestModel(modelHash)
        while not HasModelLoaded(modelHash) do
            Citizen.Wait(100)
        end

        local offset = GetOffsetFromEntityInWorldCoords(ped, 0.0, 5.0, 0.0)
        local veh = CreateVehicle(modelHash, offset.x, offset.y, offset.z, heading, true, false)
        SetPedIntoVehicle(ped, veh, -1)
        SetVehicleNumberPlateText(veh, 'DAILY' .. math.random(100, 999))
    end)
end)

local function formatRewardItem(item)
    if item.type == 'money' then
        return '$' .. item.amount
    elseif item.type == 'bank' then
        return '$' .. item.amount .. ' (Bank)'
    elseif item.type == 'black_money' then
        return '$' .. item.amount .. ' (Black)'
    elseif item.type == 'armor' then
        return 'Armor x' .. item.amount
    elseif item.type == 'vehicle' then
        return '🚗 ' .. item.name
    elseif item.type == 'weapon' then
        return '🔫 ' .. item.name
    else
        return item.name .. ' x' .. item.amount
    end
end

local function drawClaimPrompt()
    local text = isReady and Config.Locale.claim_button or string.format(Config.Locale.not_now, hoursLeft .. 'h')
    SetTextComponentFormat('STRING')
    AddTextComponentSubstringPlayerName('~g~[E]~s~ ' .. text)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

local function showRewardsMenu()
    local options = {}

    for day, reward in pairs(rewardsData) do
        local itemsStr = ''
        for i, item in ipairs(reward.items) do
            itemsStr = itemsStr .. formatRewardItem(item) .. ' '
        end

        local status = ''
        if day == currentDay and isReady then
            status = ' ✅ READY'
        elseif day == currentDay and not isReady then
            status = ' ⏳ ' .. hoursLeft .. 'h'
        elseif day < currentDay then
            status = ' ✅'
        else
            status = ' 🔒'
        end

        options[#options + 1] = {
            title = reward.label .. status,
            description = itemsStr,
            disabled = day ~= currentDay or not isReady,
            onSelect = function()
                if day == currentDay and isReady then
                    TriggerServerEvent('dailyrewards:claim')
                end
            end,
        }
    end

    if Config.Notification == 'ox_lib' then
        lib.registerContext({
            id = 'dailyrewards_menu',
            title = Config.Locale.menu_title,
            subtitle = string.format(Config.Locale.menu_subtitle, currentStreak, maxStreak),
            options = options,
        })
        lib.showContext('dailyrewards_menu')
    end
end

RegisterCommand(Config.Command, function()
    TriggerServerEvent('dailyrewards:check')
    Citizen.Wait(300)
    showRewardsMenu()
end, false)

RegisterKeyMapping(Config.Command, 'Open Daily Rewards', 'keyboard', 'u')

-- Claim with E near reward zone (or just from menu)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        if isReady then
            drawClaimPrompt()
            if IsControlJustReleased(0, 38) then -- E key
                TriggerServerEvent('dailyrewards:claim')
                Citizen.Wait(500)
            end
        end
    end
end)

-- Recheck on respawn
RegisterNetEvent('playerSpawned', function()
    Citizen.Wait(2000)
    TriggerServerEvent('dailyrewards:check')
end)

-- Initial check
Citizen.CreateThread(function()
    Citizen.Wait(3000)
    TriggerServerEvent('dailyrewards:check')
end)
