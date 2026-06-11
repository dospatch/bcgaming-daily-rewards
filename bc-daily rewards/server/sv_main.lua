local MySQL = Config.Database == 'oxmysql' and MySQL or nil

local function query(query, params, cb)
    if Config.Database == 'oxmysql' then
        MySQL.query(query, params, cb)
    else
        exports['mysql-async']:execute(query, params, cb)
    end
end

local function escapeIdentifier(source)
    local identifier = GetPlayerIdentifierByType(source, 'license')
    return identifier or ('license:' .. GetPlayerIdentifiers(source)[1])
end

local function getPlayerData(identifier, cb)
    query('SELECT * FROM daily_rewards WHERE identifier = ?', { identifier }, function(result)
        if result and #result > 0 then
            cb(result[1])
        else
            query('INSERT INTO daily_rewards (identifier, streak, last_claim) VALUES (?, 0, 0)', { identifier }, function()
                cb({ identifier = identifier, streak = 0, last_claim = 0 })
            end)
        end
    end)
end

local function canClaim(lastClaim)
    if lastClaim == 0 then return true end
    return os.time() - lastClaim >= Config.CooldownHours * 3600
end

local function getHoursUntilNext(lastClaim)
    local elapsed = os.time() - lastClaim
    local remaining = (Config.CooldownHours * 3600) - elapsed
    if remaining <= 0 then return 0 end
    return math.ceil(remaining / 3600)
end

local function giveReward(source, day)
    local reward = Config.Rewards[day]
    if not reward then return end

    local isESX = GetResourceState('es_extended') == 'started'
    local isQB = GetResourceState('qb-core') == 'started'

    for _, item in ipairs(reward.items) do
        if item.type == 'money' then
            if isESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then xPlayer.addMoney(item.amount) end
            elseif isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then Player.Functions.AddMoney('cash', item.amount) end
            else
                TriggerClientEvent('dailyrewards:receiveMoney', source, item.amount)
            end

        elseif item.type == 'bank' then
            if isESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then xPlayer.addAccountMoney('bank', item.amount) end
            elseif isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then Player.Functions.AddMoney('bank', item.amount) end
            end

        elseif item.type == 'black_money' then
            if isESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then xPlayer.addAccountMoney('black_money', item.amount) end
            elseif isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then Player.Functions.AddMoney('markedmoney', item.amount) end
            end

        elseif item.type == 'armor' then
            if isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then Player.Functions.AddItem('armor', item.amount) end
            elseif isESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then
                    xPlayer.addInventoryItem('armor', item.amount)
                    TriggerClientEvent('esx_skin:setArmor', source, item.amount)
                end
            else
                TriggerClientEvent('dailyrewards:setArmor', source, item.amount)
            end

        elseif item.type == 'vehicle' then
            if isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then
                    TriggerClientEvent('dailyrewards:spawnVehicle', source, item.name)
                end
            elseif isESX then
                TriggerClientEvent('dailyrewards:spawnVehicle', source, item.name)
            end

        elseif item.type == 'item' or item.type == 'weapon' then
            if isESX then
                local xPlayer = ESX.GetPlayerFromId(source)
                if xPlayer then xPlayer.addInventoryItem(item.name, item.amount) end
            elseif isQB then
                local Player = QBCore.Functions.GetPlayer(source)
                if Player then Player.Functions.AddItem(item.name, item.amount) end
            end
        end
    end
end

RegisterNetEvent('dailyrewards:claim', function()
    local source = source
    local identifier = escapeIdentifier(source)

    getPlayerData(identifier, function(data)
        if not canClaim(data.last_claim) then
            local hours = getHoursUntilNext(data.last_claim)
            TriggerClientEvent('dailyrewards:notify', source, 'not_ready', hours)
            return
        end

        local day = data.streak + 1

        if day > Config.MaxStreak then
            TriggerClientEvent('dailyrewards:notify', source, 'not_available', Config.MaxStreak)
            return
        end

        giveReward(source, day)

        query('UPDATE daily_rewards SET streak = ?, last_claim = ? WHERE identifier = ?', {
            day, os.time(), identifier
        }, function() end)

        local label = Config.Rewards[day] and Config.Rewards[day].label or ('Day ' .. day)
        TriggerClientEvent('dailyrewards:notify', source, 'claimed', label)
    end)
end)

RegisterNetEvent('dailyrewards:check', function()
    local source = source
    local identifier = escapeIdentifier(source)

    getPlayerData(identifier, function(data)
        local day = data.streak + 1
        local hours = 0
        local ready = false

        if data.streak == 0 then
            ready = true
        elseif canClaim(data.last_claim) then
            ready = true
        else
            hours = getHoursUntilNext(data.last_claim)
        end

        TriggerClientEvent('dailyrewards:status', source, {
            ready = ready,
            day = day,
            streak = data.streak,
            maxStreak = Config.MaxStreak,
            hours = hours,
            rewards = Config.Rewards,
        })
    end)
end)

-- If player missed > Config.CooldownHours * 2, streak resets
RegisterNetEvent('dailyrewards:resetStreakIfMissed', function()
    local source = source
    local identifier = escapeIdentifier(source)

    getPlayerData(identifier, function(data)
        if data.streak > 0 and not canClaim(data.last_claim) then
            local elapsed = os.time() - data.last_claim
            if elapsed > Config.CooldownHours * 3600 * 2 then
                query('UPDATE daily_rewards SET streak = 0 WHERE identifier = ?', { identifier }, function()
                    TriggerClientEvent('dailyrewards:notify', source, 'streak_broken')
                end)
            end
        end
    end)
end)

-- Admin commands
RegisterCommand('dailyreset', function(source, args)
    if source > 0 then
        if not IsPlayerAceAllowed(source, Config.AdminPermission) then return end
    end

    if args[1] then
        local target = tonumber(args[1])
        if GetPlayerName(target) then
            local identifier = escapeIdentifier(target)
            query('UPDATE daily_rewards SET streak = 0, last_claim = 0 WHERE identifier = ?', { identifier }, function()
                TriggerClientEvent('dailyrewards:notify', source, 'admin_reset', GetPlayerName(target))
            end)
        end
    else
        query('UPDATE daily_rewards SET streak = 0, last_claim = 0', {}, function()
            if source > 0 then
                TriggerClientEvent('dailyrewards:notify', source, 'admin_reset_all')
            end
        end)
    end
end, true)

-- On player join, check and send status
AddEventHandler('playerJoining', function()
    local source = source
    local identifier = escapeIdentifier(source)

    getPlayerData(identifier, function(data)
        -- check missed streak
        if data.streak > 0 then
            if not canClaim(data.last_claim) then
                local elapsed = os.time() - data.last_claim
                if elapsed > Config.CooldownHours * 3600 * 2 then
                    query('UPDATE daily_rewards SET streak = 0 WHERE identifier = ?', { identifier }, function()
                        TriggerClientEvent('dailyrewards:notify', source, 'streak_broken')
                    end)
                end
            end
        end

        local day = data.streak + 1
        local hours = 0
        local ready = (data.streak == 0) or canClaim(data.last_claim)

        if not ready then
            hours = getHoursUntilNext(data.last_claim)
        end

        TriggerClientEvent('dailyrewards:status', source, {
            ready = ready,
            day = day,
            streak = data.streak,
            maxStreak = Config.MaxStreak,
            hours = hours,
            rewards = Config.Rewards,
        })
    end)
end)
