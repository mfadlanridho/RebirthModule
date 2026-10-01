--!strict
--[[
    RebirthModule Types
    Standalone type definitions for modular Rebirth System.
--]]

export type RequirementEntry = {
	Type: string, -- "Currency", "Upgrade", "Zone", "Custom"
	Key: string?, -- e.g. "Coins", "SpeedLevel"
	Current: number,
	Target: number,
	IsMet: boolean,
	Ratio: number, -- Clamped 0.0 to 1.0
	Description: string?,
}

export type ExtraCondition = {
	Name: string,
	IsMet: boolean,
	Description: string?,
}

export type RequirementResult = {
	Primary: RequirementEntry,
	ExtraConditions: { ExtraCondition }?,
	AllMet: boolean,
	OverallProgress: number, -- 0.0 to 1.0
	NextRebirth: number,
}

export type RebirthConfig = {
	MaxRebirth: number?,
	GetRequirements: (currentRebirth: number, playerData: any) -> (RequirementEntry, { ExtraCondition }?),
	GetMultiplier: ((currentRebirth: number) -> number)?,
	ResetCallback: ((playerData: any) -> ())?,
	RewardCallback: ((player: Player, newRebirth: number, playerData: any) -> ())?,
	CanRebirthPredicate: ((player: Player, playerData: any) -> (boolean, string?))?,
}

export type RebirthResult = {
	Success: boolean,
	NewRebirth: number,
	ErrorReason: string?,
	Multiplier: number?,
}

return {}
