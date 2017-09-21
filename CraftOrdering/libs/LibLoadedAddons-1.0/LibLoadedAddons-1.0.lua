
--Register LAM with LibStub
local MAJOR, MINOR = "LibLoadedAddons-1.0", 2
local lla, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lla then return end	--the same or newer version of this lib is already loaded into memory 

local loadedAddons = {}

------------------------------------------------------------------------
-- 	General Functions  --
------------------------------------------------------------------------
-- Returns an unformatted link of the item
function lla:RegisterAddon(uniqueAddonName)
	if loadedAddons[uniqueAddonName] then
		return false, "Addon name is alredy registered"
	end
	
	loadedAddons[uniqueAddonName] = true
	
	return true
end

function lla:UnregisterAddon(uniqueAddonName)
	if loadedAddons[uniqueAddonName] then
		loadedAddons[uniqueAddonName] = nil
		return true
	end
	return false, "Addon name was not registered"
end

function lla:IsAddonRegistered(uniqueAddonName)
	if loadedAddons[uniqueAddonName] then
		return true
	end
	return false
end
