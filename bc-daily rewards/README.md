# BCGaming Daily Rewards

A fully configurable FiveM daily rewards system designed to boost player retention, reward loyalty, and encourage consistent server activity. Featuring streak progression, multiple reward types, framework compatibility, and administrative controls.

## Features

### Daily Login Rewards

* Claim rewards once every 24 hours
* Progressive 30-day reward streak system
* Increasing reward value as streaks grow
* Automatic streak tracking and management

### Multiple Reward Types

Reward your community with:

* Cash
* Bank Deposits
* Black Money
* Inventory Items
* Weapons
* Armor
* Vehicles
* Custom Reward Support

### Smart Streak System

* Tracks consecutive daily claims
* Maintains player progression automatically
* Streak resets after 2 or more missed days
* Configurable maximum streak length

### Framework Support

Compatible with:

* ESX Legacy
* QB-Core
* Standalone Servers

### User-Friendly Interface

* Modern reward menu
* Claim rewards through `/daily`
* Optional hotkey support (`U` by default)
* On-screen notification when rewards become available
* Multiple notification systems supported

### Administrative Tools

* Reset individual player streaks
* Reset all player streaks
* Permission-based admin commands
* Fully configurable ACE permissions

---

## Installation

### Step 1

Place the resource folder inside:

```bash
resources/[bcgaming]/
```

### Step 2

Import the included database file:

```sql
database.sql
```

into your MySQL database.

### Step 3

Add the resource to your server configuration:

```cfg
ensure bc-dailyrewards
```

### Step 4

Configure all settings inside:

```lua
config.lua
```

---

## Dependencies

### Required

* ox_lib
* oxmysql (Recommended)

### Supported Database Options

* oxmysql
* mysql-async

---

## Configuration Options

### Core Settings

```lua
Config.CooldownHours = 24
Config.MaxStreak = 30
Config.Command = "daily"
```

### Notification Systems

```lua
Config.Notification = "ox_lib"
```

Available Options:

* ox_lib
* esx
* qb
* native

### Database Selection

```lua
Config.Database = "oxmysql"
```

Available Options:

* oxmysql
* mysql-async

---

## Reward Configuration

```lua
-- Cash Reward
{ name = "Cash Bonus", type = "money", amount = 5000 }

-- Bank Deposit
{ name = "Bank Bonus", type = "bank", amount = 10000 }

-- Black Money
{ name = "Dirty Cash", type = "black_money", amount = 5000 }

-- Inventory Item
{ name = "Bread", type = "item", amount = 5 }

-- Weapon Reward
{ name = "Pistol", type = "weapon", amount = 1 }

-- Armor Reward
{ name = "Body Armor", type = "armor", amount = 100 }

-- Vehicle Reward
{ name = "Adder", type = "vehicle", amount = 1 }
```

---

## Commands

### Player Command

```bash
/daily
```

Opens the Daily Rewards menu.

### Admin Commands

```bash
/dailyreset [playerid]
```

Resets a specific player's reward streak.

```bash
/dailyreset
```

Resets all player reward streaks.

---

## Permissions

By default, administrative commands require:

```cfg
add_ace group.admin bc.daily.admin allow
```

Permission names can be modified through:

```lua
Config.AdminPermission
```

---

## Why Choose BCGaming Daily Rewards?

✔ Increase player retention

✔ Encourage daily server activity

✔ Reward loyal community members

✔ Fully configurable reward system

✔ Framework-independent support

✔ Lightweight and optimized performance

✔ Easy installation and setup

✔ Designed for serious roleplay communities

---

## Support & Community

Need help installing, configuring, or troubleshooting the script?

Join the official BCGaming Community Discord for:

* Installation Support
* Configuration Assistance
* Bug Reports
* Feature Requests
* Script Updates
* Community Announcements

Discord Invite:
https://discord.gg/ctvT7HBZ9e

---

## License

This resource is intended for use within the BCGaming community and authorized customers. Redistribution, resale, or unauthorized sharing is prohibited unless explicitly permitted by BCGaming Development.

---

Thank you for choosing BCGaming Development.

Building Quality FiveM Resources for Serious Roleplay Communities.
