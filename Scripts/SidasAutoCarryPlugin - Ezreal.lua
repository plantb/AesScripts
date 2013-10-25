-- Variables --
local Target
local Config = AutoCarry.PluginMenu

-- Skills information --
local QRange, WRange, RRange = 1150, 1050, 2000
local QSpeed, WSpeed, RSpeed = 2.0, 1.6, 2.0
local QDelay, WDelay, RDelay = 251, 250, 1000
local QWidth, WWidth, RWidth = 80, 80, 160

-- Skills Table --
if IsSACReborn then
	SkillQ = AutoCarry.Skills:NewSkill(false, _Q, QRange, "Mystic Shot", AutoCarry.SPELL_LINEAR_COL, 0, false, false, QSpeed, QDelay, QWidth, true)
	SkillW = AutoCarry.Skills:NewSkill(false, _W, WRange, "Essence Flux", AutoCarry.SPELL_LINEAR, 0, false, false, WSpeed, WDelay, WWidth, false)
	SkillR = AutoCarry.Skills:NewSkill(false, _R, RRange, "Trueshot Barrage", AutoCarry.SPELL_LINEAR, 0, false, false, RSpeed, RDelay, RWidth, false)
else
	SkillQ = {spellKey = _Q, range = QRange, speed = QSpeed, delay = QDelay, width = QWidth, minions = true }
	SkillW = {spellKey = _W, range = WRange, speed = WSpeed, delay = WDelay, width = WWidth, minions = false }
	SkillR = {spellKey = _R, range = RRange, speed = RSpeed, delay = RDelay, width = RWidth, minions = false }
end

-- Plugin functions --
function PluginOnLoad()
	if AutoCarry.Skills and VIP_USER then IsSACReborn = true else IsSACReborn = false end
	
	if IsSACReborn then
		AutoCarry.Crosshair:SetSkillCrosshairRange(RRange)
	else
		AutoCarry.SkillsCrosshair.range = RRange
	end

	Menu()
end

function PluginOnTick()
	Target = AutoCarry.GetAttackTarget()

	Combo()
	Harass()
end

function PluginOnDraw()
	if Config.DrawingOptions.DrawQ then
		DrawCircle(myHero.x, myHero.y, myHero.z, QRange, 0xFFFFFF)
	end

	if Config.DrawingOptions.DrawR then
		DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFFFFFF)
	end
end

-- Spells funtions --
function Combo()
	if AutoCarry.MainMenu.AutoCarry then
		CastQ()
		CastW()
		CastR()
	end
end

function Harass()
	if AutoCarry.MainMenu.MixedMode and CheckManaHarass() then
		CastQ()
		CastW()
	end
end

function CastQ()
	if Target ~= nil and GetDistance(Target) < QRange then
		if Config.ComboOptions.ComboQ or Config.HarassOptions.HarassQ then
			if IsSACReborn then	
				SkillQ:Cast(Target)
			else
				AutoCarry.CastSkillshot(SkillQ, Target)
			end
		end
	end
end

function CastW()
	if Target ~= nil and GetDistance(Target) < WRange then
		if Config.ComboOptions.ComboW or Config.HarassOptions.HarassW then
			if IsSACReborn then	
				SkillW:Cast(Target)
			else
				AutoCarry.CastSkillshot(SkillW, Target)
			end
		end
	end
end

function CastR()
	if Target ~= nil then
		RDmg = getDmg("R", Target, myHero)
		if GetDistance(Target) < RRange and RDmg > Target.health then
			if Config.ComboOptions.ComboR or Config.FinisherOptions.FinisherR then
				if IsSACReborn then	
					SkillR:Cast(Target)
				else
					AutoCarry.CastSkillshot(SkillR, Target)
				end
			end
		end
	end
end

function CheckManaHarass()
	if myHero.mana > myHero.maxMana * (Config.HarassOptions.HarassMana / 100) then
		return true
	end
end

-- Menu --
function Menu()
	Config:addSubMenu("Combo Options", "ComboOptions")
	Config.ComboOptions:addParam("ComboQ", "Use Mystic Shot", SCRIPT_PARAM_ONOFF, true)
	Config.ComboOptions:addParam("ComboW", "Use Essence Flux", SCRIPT_PARAM_ONOFF, true)
	Config.ComboOptions:addParam("ComboR", "Use Trueshot Barrage", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Harass Options", "HarassOptions")
	Config.HarassOptions:addParam("HarassQ", "Use Mystic Shot", SCRIPT_PARAM_ONOFF, true)
	Config.HarassOptions:addParam("HarassW", "Use Essence Flux", SCRIPT_PARAM_ONOFF, true)
	Config.HarassOptions:addParam("HarassMana", "Lowest mana percent to harass", SCRIPT_PARAM_SLICE, 50, 0, 100, 0)
	Config:addSubMenu("Finisher Options","FinisherOptions")
	Config.FinisherOptions:addParam("FinisherR", "Use Trueshot Barrage", SCRIPT_PARAM_ONOFF, true)
	Config:addSubMenu("Drawing Options","DrawingOptions")
	Config.DrawingOptions:addParam("DrawQ", "Draw Mystic Shot", SCRIPT_PARAM_ONOFF, true)
	Config.DrawingOptions:addParam("DrawR", "Draw Trueshot Barrage", SCRIPT_PARAM_ONOFF, true)
end

--UPDATEURL=
--HASH=56062607C8057C3C5CCDFE56837F99F9