--!strict
--[[
    FormulaUtil.luau
    Reusable mathematical scaling curves and number formatters for progression & rebirth formulas.
--]]

local FormulaUtil = {}

--- Exponential scaling: Base * (Factor ^ Level)
function FormulaUtil.Exponential(base: number, factor: number, level: number): number
	if level <= 0 then
		return base
	end
	return math.floor(base * (factor ^ level))
end

--- Linear scaling: Base + (Step * Level)
function FormulaUtil.Linear(base: number, step: number, level: number): number
	return math.floor(base + (step * math.max(0, level)))
end

--- Polynomial scaling: Base * ((Level + 1) ^ Exponent)
function FormulaUtil.Polynomial(base: number, exponent: number, level: number): number
	return math.floor(base * ((math.max(0, level) + 1) ^ exponent))
end

--- Smooth Step scaling with dampening
function FormulaUtil.SmoothStep(minVal: number, maxVal: number, level: number, maxLevel: number): number
	local t = math.clamp(level / math.max(1, maxLevel), 0, 1)
	local smoothT = t * t * (3 - 2 * t)
	return math.floor(minVal + (maxVal - minVal) * smoothT)
end

--- Compact number formatting (e.g. 1000 -> 1K, 1500000 -> 1.5M)
function FormulaUtil.FormatCompact(num: number): string
	if num < 1000 then
		return string.format("%d", math.floor(num))
	elseif num < 1_000_000 then
		local formatted = num / 1000
		if formatted % 1 == 0 or num >= 10000 then
			return string.format("%.0fK", formatted)
		else
			return string.format("%.1fK", formatted)
		end
	elseif num < 1_000_000_000 then
		local formatted = num / 1_000_000
		if formatted % 1 == 0 or num >= 10_000_000 then
			return string.format("%.0fM", formatted)
		else
			return string.format("%.1fM", formatted)
		end
	else
		local formatted = num / 1_000_000_000
		return string.format("%.2fB", formatted)
	end
end

--- Formatted with commas: 1000000 -> 1,000,000
function FormulaUtil.FormatWithCommas(num: number): string
	local formatted = tostring(math.floor(num))
	local k
	while true do
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
		if k == 0 then
			break
		end
	end
	return formatted
end

return FormulaUtil
