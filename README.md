# RebirthModule

A decoupled, modular, and formula-driven Rebirth & Prestige system for Roblox games.

## Features
- **Project-Agnostic Core**: Zero hardcoded currencies or Game/DataStore dependencies.
- **Formula & Rule Engine**: Supports exponential, linear, polynomial, and custom requirement formulas.
- **Multi-Condition Checks**: Supports secondary prerequisites (e.g., reaching specific zones, maxing upgrades, badge ownership).
- **Normalized Progress Tracking**: Automatically generates continuous progress ratios `[0.0, 1.0]` for instant UI progress bars.
- **Built-in Curve Helpers**: Prepackaged math utilities (`FormulaUtil`) for smooth game balance progression.

## Quick Start

### 1. Define your Game Rebirth Config
```lua
local RebirthModule = require(ReplicatedStorage.Packages.RebirthModule)

local MyGameConfig: RebirthModule.RebirthConfig = {
    MaxRebirth = 50,
    GetRequirements = function(currentRebirth: number, playerData: any)
        local target = RebirthModule.Formula.Exponential(1000, 2.2, currentRebirth)
        return {
            Type = "Currency",
            Key = "Coins",
            Current = playerData.Coins or 0,
            Target = target,
        }
    end,
    GetMultiplier = function(currentRebirth: number)
        return 1.0 + (currentRebirth * 0.25)
    end,
    ResetCallback = function(playerData: any)
        playerData.Coins = 0
    end,
    RewardCallback = function(player: Player, newRebirth: number, playerData: any)
        playerData.Rebirths = newRebirth
    end,
}
```

### 2. Evaluate Progress
```lua
local result = RebirthModule.Evaluate(MyGameConfig, playerData.Rebirths or 0, playerData)
print("Progress:", result.OverallProgress) -- e.g. 0.75 (75%)
print("Can Rebirth?", result.AllMet)
```
