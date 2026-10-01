--!strict
--[[
    RebirthModule (init.luau)
    Modular, standalone Rebirth System package for Roblox experiences.
    Exposes types, formula math helpers, and the evaluation engine.
--]]

local script = script
local Types = require(script.Types)
local FormulaUtil = require(script.FormulaUtil)
local RebirthEngine = require(script.RebirthEngine)

export type RequirementEntry = Types.RequirementEntry
export type ExtraCondition = Types.ExtraCondition
export type RequirementResult = Types.RequirementResult
export type RebirthConfig = Types.RebirthConfig
export type RebirthResult = Types.RebirthResult

local RebirthModule = {}

RebirthModule.Formula = FormulaUtil
RebirthModule.Engine = RebirthEngine

--- Shortcut to evaluate requirements given a config, rebirth count, and playerData table
function RebirthModule.Evaluate(
	config: RebirthConfig,
	currentRebirth: number,
	playerData: any
): RequirementResult
	return RebirthEngine.EvaluateRequirements(config, currentRebirth, playerData)
end

--- Shortcut to get active multiplier
function RebirthModule.GetMultiplier(config: RebirthConfig, currentRebirth: number): number
	return RebirthEngine.GetMultiplier(config, currentRebirth)
end

return RebirthModule
