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

local orange = "|cFFA400"
local green = "|c00A400"
local red = "|cFF0000"

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
--  Debug mode output to chat  --
------------------------------------------------------------------
function ECO.d(t)
  if ECO.debug then
    d(t)
  end
end

------------------------------------------------------------------
--  OnPlayerActivated  --
------------------------------------------------------------------
local function OnPlayerActivated(eventCode)
  if ECO.loaded then return end
  ECO.d(green .. "CraftOrdering Loaded")
  ECO.loaded = true
end

------------------------------------------------------------------
--  Initialize Function --
------------------------------------------------------------------
function CraftOrdering:Initialize()
  EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_PLAYER_ACTIVATED, OnPlayerActivated)
  if ECO.debug then
    CraftOrdering:ExecuteUnitTests()
  end
end

----------------------------------------------------------------------
--  Register Events --
----------------------------------------------------------------------
EVENT_MANAGER:RegisterForEvent(CraftOrdering.name, EVENT_ADD_ON_LOADED, OnAddOnLoaded)