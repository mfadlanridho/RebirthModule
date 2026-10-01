--!strict
--[[
    RebirthEngine.luau
    Core evaluation and calculation engine for RebirthModule.
    Decoupled from DataStore and Network - works purely with configs and state tables.
--]]

local script = script
local Types = require(script.Parent.Types)
local FormulaUtil = require(script.Parent.FormulaUtil)

type RequirementEntry = Types.RequirementEntry
type ExtraCondition = Types.ExtraCondition
type RequirementResult = Types.RequirementResult
type RebirthConfig = Types.RebirthConfig

local RebirthEngine = {}

--- Evaluates the requirement status and progress for a given player data and rebirth level
function RebirthEngine.EvaluateRequirements(
	config: RebirthConfig,
	currentRebirth: number,
	playerData: any
): RequirementResult
	local nextRebirth = currentRebirth + 1
	local maxRebirth = config.MaxRebirth or 999

	if currentRebirth >= maxRebirth then
		local primary: RequirementEntry = {
			Type = "Max",
			Key = "MaxRebirth",
			Current = currentRebirth,
			Target = maxRebirth,
			IsMet = true,
			Ratio = 1.0,
			Description = "Max Rebirth Reached",
		}
		return {
			Primary = primary,
			ExtraConditions = nil,
			AllMet = false,
			OverallProgress = 1.0,
			NextRebirth = currentRebirth,
		}
	end

	local primaryReq, extraConditions = config.GetRequirements(currentRebirth, playerData)

	local primaryRatio = 1.0
	if primaryReq.Target > 0 then
		primaryRatio = math.clamp(primaryReq.Current / primaryReq.Target, 0, 1)
	end
	primaryReq.Ratio = primaryRatio
	primaryReq.IsMet = primaryReq.Current >= primaryReq.Target

	local allMet = primaryReq.IsMet
	local totalConditions = 1
	local metConditions = primaryReq.IsMet and 1 or 0

	if extraConditions and #extraConditions > 0 then
		for _, condition in ipairs(extraConditions) do
			totalConditions += 1
			if condition.IsMet then
				metConditions += 1
			else
				allMet = false
			end
		end
	end

	-- Weighted progress: Primary requirement counts for the smooth continuous ratio
	local overallProgress = primaryRatio
	if extraConditions and #extraConditions > 0 then
		-- Blend primary requirement ratio with boolean status of extra conditions
		local extraWeight = 0.3
		local primaryWeight = 0.7
		local extraRatio = (metConditions - (primaryReq.IsMet and 1 or 0)) / #extraConditions
		overallProgress = (primaryRatio * primaryWeight) + (extraRatio * extraWeight)
	end

	return {
		Primary = primaryReq,
		ExtraConditions = extraConditions,
		AllMet = allMet,
		OverallProgress = math.clamp(overallProgress, 0, 1),
		NextRebirth = nextRebirth,
	}
end

--- Calculates current income / cashout multiplier for a rebirth count
function RebirthEngine.GetMultiplier(config: RebirthConfig, currentRebirth: number): number
	if config.GetMultiplier then
		return config.GetMultiplier(currentRebirth)
	end
	-- Default fallback: +25% per rebirth
	return 1.0 + (math.max(0, currentRebirth) * 0.25)
end

return RebirthEngine
