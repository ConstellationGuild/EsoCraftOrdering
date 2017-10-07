-------------------------------------------------------------------------
-- Globals --
-------------------------------------------------------------------------

-- Longhand object for addon settings
CraftOrdering = {}
CraftOrdering.loadedAddons = {
}

-- Shorthand object
ECO = {}

-------------------------------------------------------------------------
-- Locals --
-------------------------------------------------------------------------
local CraftOrderingDefaultVars = {
}

-------------------------------------------------------------------------
--  Initialize Variables --
-------------------------------------------------------------------------
CraftOrdering.name = "CraftOrdering"

-- WARNING Changing version will reset saved variables
-- Only increment when you want this to happen
-- in effect verion is variable storage version
CraftOrdering.version = 1.0
CraftOrdering.RealVersion = 1.0

ECO.loaded = false
ECO.debug = true

ECO.orange = "|cFFA400"
ECO.green = "|c00A400"
ECO.red = "|cFF0000"

------------------------------------------------------------------
--  OnAddOnLoaded  --
------------------------------------------------------------------
local function OnAddOnLoaded(_event, addonName)
  if addonName == CraftOrdering.name then
    CraftOrdering:Initialize()
	else
		CraftOrdering.loadedAddons[addonName] = true
	end
  -- Can check in future if any addon isn't compatible
end

------------------------------------------------------------------
--  OnPlayerActivated  --
------------------------------------------------------------------
local function OnPlayerActivated(eventCode)
  if ECO.loaded then return end
  ECO.d(ECO.green .. "CraftOrdering Loaded")

  if ECO.debug then
    CraftOrdering:ExecuteUnitTests()
  end

  CraftOrderingPanel:SetHidden(false)

  ECO.loaded = true
end

------------------------------------------------------------------
--  Initialize Function --
------------------------------------------------------------------
function CraftOrdering:Initialize()
  EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
end

----------------------------------------------------------------------
--  Register Events --
----------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)