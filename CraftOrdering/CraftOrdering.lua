-------------------------------------------------------------------------
-- Globals --
-------------------------------------------------------------------------

-- Using object or {} pattern to ensure object
-- creation regardless of load order

-- Longhand object for addon settings
CraftOrdering = CraftOrdering or {}

CraftOrdering.loadedAddons = {
}

-- Shorthand object
ECO = ECO or {}

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

-- Pending orders ready for auto crafting at stations
ECO.pendingOrders = {}
-- Saved variables
ECO.savedVariables = {}

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
  ECO.loaded = true
end

------------------------------------------------------------------
--  Initialize Function --
------------------------------------------------------------------
function CraftOrdering:Initialize()
  ZO_CreateStringId("SI_BINDING_NAME_SHOW_ECO", "Open Craft Ordering Panel")
  EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
end

----------------------------------------------------------------------
--  Register Events --
----------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)