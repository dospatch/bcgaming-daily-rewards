Config = {}

-- Database options (if not using oxmysql, change to 'mysql-async')
Config.Database = 'oxmysql' -- 'oxmysql' or 'mysql-async'

-- Notification type: 'ox_lib', 'esx', 'qb', 'native'
Config.Notification = 'ox_lib'

-- Time (in hours) before player can claim the next reward
Config.CooldownHours = 24

-- Maximum streak days before it resets
Config.MaxStreak = 30

-- Reward types available: 'money', 'bank', 'black_money', 'item', 'weapon', 'armor', 'vehicle'
-- For 'item'/'weapon'/'vehicle': name is the item's database name (e.g. 'bread', 'WEAPON_PISTOL')
-- For 'armor': amount is the armor value to give
-- For 'vehicle': name is the spawn code, e.g. 'adder'

Config.Rewards = {
    [1]  = { label = 'Day 1',  items = { { name = 'money',  type = 'money',  amount = 5000 }, { name = 'bread',    type = 'item', amount = 5 } } },
    [2]  = { label = 'Day 2',  items = { { name = 'money',  type = 'money',  amount = 6000 }, { name = 'water',    type = 'item', amount = 5 } } },
    [3]  = { label = 'Day 3',  items = { { name = 'money',  type = 'money',  amount = 7000 }, { name = 'phone',    type = 'item', amount = 1 } } },
    [4]  = { label = 'Day 4',  items = { { name = 'money',  type = 'money',  amount = 8000 }, { name = 'radio',    type = 'item', amount = 1 } } },
    [5]  = { label = 'Day 5',  items = { { name = 'money',  type = 'money',  amount = 10000 }, { name = 'armor',    type = 'armor', amount = 50 } } },
    [6]  = { label = 'Day 6',  items = { { name = 'money',  type = 'money',  amount = 12000 }, { name = 'lockpick', type = 'item', amount = 3 } } },
    [7]  = { label = 'Day 7',  items = { { name = 'money',  type = 'money',  amount = 15000 }, { name = 'WEAPON_PISTOL', type = 'weapon', amount = 1 }, { name = 'pistol_ammo', type = 'item', amount = 50 } } },
    [8]  = { label = 'Day 8',  items = { { name = 'money',  type = 'money',  amount = 20000 }, { name = 'goldchain', type = 'item', amount = 1 } } },
    [9]  = { label = 'Day 9',  items = { { name = 'bank',   type = 'bank',  amount = 25000 }, { name = 'rolex',    type = 'item', amount = 1 } } },
    [10] = { label = 'Day 10', items = { { name = 'money',  type = 'money',  amount = 25000 }, { name = 'diamond_ring', type = 'item', amount = 1 }, { name = 'armor', type = 'armor', amount = 100 } } },
    [11] = { label = 'Day 11', items = { { name = 'money',  type = 'money',  amount = 30000 }, { name = 'electronickit', type = 'item', amount = 2 } } },
    [12] = { label = 'Day 12', items = { { name = 'bank',   type = 'bank',  amount = 35000 }, { name = 'WEAPON_SMG', type = 'weapon', amount = 1 }, { name = 'smg_ammo', type = 'item', amount = 100 } } },
    [13] = { label = 'Day 13', items = { { name = 'money',  type = 'money',  amount = 40000 }, { name = 'cryptostick', type = 'item', amount = 1 } } },
    [14] = { label = 'Day 14', items = { { name = 'money',  type = 'money',  amount = 50000 }, { name = 'WEAPON_ASSAULTRIFLE', type = 'weapon', amount = 1 }, { name = 'rifle_ammo', type = 'item', amount = 100 } } },
    [15] = { label = 'Day 15', items = { { name = 'bank',   type = 'bank',  amount = 60000 }, { name = 'armor',    type = 'armor', amount = 100 }, { name = 'WEAPON_PISTOL50', type = 'weapon', amount = 1 } } },
    [16] = { label = 'Day 16', items = { { name = 'money',  type = 'money',  amount = 65000 }, { name = 'WEAPON_SNIPERRIFLE', type = 'weapon', amount = 1 }, { name = 'sniper_ammo', type = 'item', amount = 20 } } },
    [17] = { label = 'Day 17', items = { { name = 'black_money', type = 'black_money', amount = 50000 }, { name = 'WEAPON_PUMPSHOTGUN', type = 'weapon', amount = 1 } } },
    [18] = { label = 'Day 18', items = { { name = 'money',  type = 'money',  amount = 75000 }, { name = 'goldchain', type = 'item', amount = 3 }, { name = 'rolex', type = 'item', amount = 2 } } },
    [19] = { label = 'Day 19', items = { { name = 'bank',   type = 'bank',  amount = 100000 }, { name = 'diamond_ring', type = 'item', amount = 3 }, { name = 'armor', type = 'armor', amount = 100 } } },
    [20] = { label = 'Day 20', items = { { name = 'money',  type = 'money',  amount = 100000 }, { name = 'WEAPON_ASSAULTSMG', type = 'weapon', amount = 1 }, { name = 'smg_ammo', type = 'item', amount = 200 } } },
    [21] = { label = 'Day 21', items = { { name = 'black_money', type = 'black_money', amount = 100000 }, { name = 'WEAPON_HEAVYSNIPER', type = 'weapon', amount = 1 }, { name = 'sniper_ammo', type = 'item', amount = 30 } } },
    [22] = { label = 'Day 22', items = { { name = 'money',  type = 'money',  amount = 150000 }, { name = 'cryptostick', type = 'item', amount = 3 } } },
    [23] = { label = 'Day 23', items = { { name = 'bank',   type = 'bank',  amount = 200000 }, { name = 'armor',    type = 'armor', amount = 100 }, { name = 'WEAPON_CARBINERIFLE', type = 'weapon', amount = 1 } } },
    [24] = { label = 'Day 24', items = { { name = 'money',  type = 'money',  amount = 200000 }, { name = 'WEAPON_RPG', type = 'weapon', amount = 1 }, { name = 'WEAPON_GRENADE', type = 'weapon', amount = 5 } } },
    [25] = { label = 'Day 25', items = { { name = 'black_money', type = 'black_money', amount = 200000 }, { name = 'goldchain', type = 'item', amount = 5 }, { name = 'diamond_ring', type = 'item', amount = 5 } } },
    [26] = { label = 'Day 26', items = { { name = 'money',  type = 'money',  amount = 300000 }, { name = 'WEAPON_MG', type = 'weapon', amount = 1 }, { name = 'rifle_ammo', type = 'item', amount = 300 } } },
    [27] = { label = 'Day 27', items = { { name = 'bank',   type = 'bank',  amount = 400000 }, { name = 'armor',    type = 'armor', amount = 100 }, { name = 'cryptostick', type = 'item', amount = 5 } } },
    [28] = { label = 'Day 28', items = { { name = 'money',  type = 'money',  amount = 400000 }, { name = 'WEAPON_MINIGUN', type = 'weapon', amount = 1 } } },
    [29] = { label = 'Day 29', items = { { name = 'black_money', type = 'black_money', amount = 500000 }, { name = 'WEAPON_RAILGUN', type = 'weapon', amount = 1 } } },
    [30] = { label = 'Day 30', items = { { name = 'money',  type = 'money',  amount = 1000000 }, { name = 'WEAPON_MINIGUN', type = 'weapon', amount = 1 }, { name = 'adder', type = 'vehicle', amount = 1 }, { name = 'armor', type = 'armor', amount = 100 } } },
}

-- Command to open the daily reward menu
Config.Command = 'daily'

-- Admin ace permission for reset commands
Config.AdminPermission = 'admin'

-- Locale / Text
Config.Locale = {
    not_ready = 'You already claimed your daily reward! Come back in ~%s~ hours.',
    claimed = 'You claimed your ~y~Day %s~s~ reward! (+%s)',
    streak_broken = 'You missed a day! Your streak has reset.',
    not_available = 'You have already claimed all %d daily rewards.',
    admin_reset = 'Successfully reset daily rewards for %s.',
    admin_reset_all = 'Successfully reset all daily rewards.',
    menu_title = 'Daily Rewards',
    menu_subtitle = 'Day %d / %d Streak',
    claim_button = '[E] - Claim Daily Reward',
    not_now = 'Come back in %s',
}
