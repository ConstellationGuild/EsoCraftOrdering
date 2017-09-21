
--*****************************--
-- Circonians FilterIt Library --
--*****************************--

--Register with LibStub
local MAJOR, MINOR = "LibFilterIt-1.0", 9
local lfi, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lfi then return end	--the same or newer version of this lib is already loaded into memory 


-------------------------------------------------
--  Colors  --
-------------------------------------------------
local colorRed 			= "|cFF0000" 	-- Red
local colorYellow 		= "|cFFFF00" 	-- yellow 

-------------------------------------------------
--  Custom Filter IDs --
-------------------------------------------------
FILTERIT_NONE				= 0		-- THIS DOESN'T DO ANYTHING
FILTERIT_BACKPACK 			= 1
FILTERIT_BANK 				= 3
FILTERIT_GUILDBANK 			= 4

FILTERIT_TRADINGHOUSE 		= 5
FILTERIT_TRADE 				= 6
FILTERIT_VENDOR 			= 7
FILTERIT_MAIL 				= 8
--FILTERIT_CRAFTING = 9		-- not used, reserved in case I want to change things

-- crafting interaction filters
FILTERIT_ALCHEMY 			= 9
FILTERIT_ENCHANTING 		= 10 	-- Hides from both creation & extraction
FILTERIT_PROVISIONING 		= 11

-- other filters 
FILTERIT_DECONSTRUCTION		= 12
FILTERIT_IMPROVEMENT		= 13
FILTERIT_REFINEMENT			= 14
FILTERIT_RESEARCH 			= 15
FILTERIT_ALL				= 16		-- THIS DOESN'T DO ANYTHING, Used in FilterIt code only
FILTERIT_QUICKSLOT          = 17

--------------------------------------------------
-- Holds the registered callback filters 		--
--------------------------------------------------
local tFilterItFilters = {
	[FILTERIT_BACKPACK] = {},
	[FILTERIT_BANK] = {},
	[FILTERIT_GUILDBANK] = {},
	
	[FILTERIT_TRADINGHOUSE] = {},
	[FILTERIT_TRADE] = {},
	[FILTERIT_VENDOR] = {},
	[FILTERIT_MAIL] = {},
	
	[FILTERIT_ALCHEMY] = {},
	[FILTERIT_ENCHANTING] = {},
	[FILTERIT_PROVISIONING] = {},
	
	[FILTERIT_IMPROVEMENT] = {},
	[FILTERIT_DECONSTRUCTION] = {},
	[FILTERIT_REFINEMENT] = {},
	[FILTERIT_RESEARCH] = {},
	
	[FILTERIT_QUICKSLOT] = {},
}
GLOBAL_ACTIVE_FILTERS = tFilterItFilters
--*******************************************************--
--***  Setup Backpack Layout View Additional Filters  ***--
--*******************************************************--
-------------------------------------------------
-- Filter stuff for layout fragments
-- Used to setup the different layout views for the backpack, bank, & guild bank.
-------------------------------------------------
local tInventoryFilters = {
	[1] = {["Data"] = BACKPACK_BANK_LAYOUT_FRAGMENT.layoutData, 		["FilterType"] = FILTERIT_BACKPACK},
	[2] = {["Data"] = BACKPACK_MENU_BAR_LAYOUT_FRAGMENT.layoutData, 	["FilterType"] = FILTERIT_BACKPACK},
	[3] = {["Data"] = BACKPACK_GUILD_BANK_LAYOUT_FRAGMENT.layoutData, 	["FilterType"] = FILTERIT_BACKPACK},
	[4] = {["Data"] = BACKPACK_MAIL_LAYOUT_FRAGMENT.layoutData, 		["FilterType"] = FILTERIT_MAIL},
	[5] = {["Data"] = BACKPACK_PLAYER_TRADE_LAYOUT_FRAGMENT.layoutData, ["FilterType"] = FILTERIT_TRADE},
	[6] = {["Data"] = BACKPACK_STORE_LAYOUT_FRAGMENT.layoutData, 		["FilterType"] = FILTERIT_VENDOR},
	[7] = {["Data"] = BACKPACK_TRADING_HOUSE_LAYOUT_FRAGMENT.layoutData, ["FilterType"] = FILTERIT_TRADINGHOUSE},
	[8] = {["Data"] = PLAYER_INVENTORY.inventories[INVENTORY_BANK], 	["FilterType"] = FILTERIT_BANK},
	[9] = {["Data"] = PLAYER_INVENTORY.inventories[INVENTORY_GUILD_BANK], ["FilterType"] = FILTERIT_GUILDBANK},
	[10] = {["Data"] = BACKPACK_FENCE_LAYOUT_FRAGMENT.layoutData, 		["FilterType"] = FILTERIT_VENDOR},
	[11] = {["Data"] = BACKPACK_LAUNDER_LAYOUT_FRAGMENT.layoutData, 		["FilterType"] = FILTERIT_VENDOR},
}


---------------------------------------------------------------------------
-- Used to dirty the provisioner list, then the game refreshes the list  --
---------------------------------------------------------------------------
local function DirtyList(_FilterId)
	if _FilterId == FILTERIT_PROVISIONING then
		PROVISIONER:DirtyRecipeList()
	end
end

--*******************************************************--
--*********   Handle Filter Registering   **************--
--*******************************************************--
--------------------------------------------------
-- Unregister Fitler 							--
--------------------------------------------------
function lfi:UnregisterFilter(_AddonName, _FilterName, _FilterId)
	if not(tFilterItFilters[_FilterId]) then
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid Filter Id: "..tostring(_FilterId)
	end
	if not _AddonName or _AddonName == "" then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid Addon Name" 
	end
	if not tFilterItFilters[_FilterId][_FilterName] then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Filter Name: "..tostring(_FilterName).." does not exist." 
	end
	if  tFilterItFilters[_FilterId][_FilterName]["AddonName"] ~= _AddonName  then 
		return false, colorRed.."libFilterIt: "..colorYellow.."That filter does not belong to your addon, it belongs to addon: "..tostring(tFilterItFilters[_FilterId][_FilterName]["AddonName"])
	end
	
	tFilterItFilters[_FilterId][_FilterName] = nil
	DirtyList(_FilterId)
	return true
end

--------------------------------------------------
-- Register Filter 								--
--------------------------------------------------
function lfi:RegisterFilter(_AddonName, _FilterName, _FilterId, _Func)
	if not(tFilterItFilters[_FilterId]) then
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid Filter Id: "..tostring(_FilterId)
	end
	if not _FilterName or _FilterName == "" then
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid Filter Name: "..tostring(_FilterName)
	end
	if not _AddonName or _AddonName == "" then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid Addon Name" 
	end
	
	if tFilterItFilters[_FilterId] and tFilterItFilters[_FilterId][_FilterName] then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Filter Name already registered to addon: "..tostring(tFilterItFilters[_FilterId][_FilterName]["AddonName"] )
	end
	
	if type(_Func) ~= "function" then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Your Callback is not a function" 
	end
	
	tFilterItFilters[_FilterId][_FilterName] = {["AddonName"] = _AddonName, ["Callback"] = _Func}
	DirtyList(_FilterId)
	return true
end

--------------------------------------------------
-- Is Filter Registered							--
--------------------------------------------------
function lfi:IsFilterRegistered(_FilterName, _FilterId)
	if not(tFilterItFilters[_FilterId]) then
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid FilterId"
	end
	
	if not _FilterName or _FilterName == "" then 
		return false, colorRed.."libFilterIt: "..colorYellow.."Invalid FilterName" 
	end
	
	if tFilterItFilters[_FilterId][_FilterName] then 
		return true, colorRed.."libFilterIt: "..colorYellow.."Filter Name is registered to addon: "..tFilterItFilters[_FilterId][_FilterName]["AddonName"] 
	end
	return false
end

--*******************************************************--
--***********   Run Registered Filters   ****************--
--*******************************************************--
--------------------------------------------------
-- Check Filters								--
-- Checks the slot against the registered 		--
-- filters for the given filter type			--
--------------------------------------------------
local function CheckFilters(_tSlot, _FilterType)
	if not(tFilterItFilters and tFilterItFilters[_FilterType]) then return true end

	for k,v in pairs(tFilterItFilters[_FilterType]) do
		if not v.Callback(_tSlot) then
			return false
		end
	end
	return true
end

local function RunFilterFromBagIdSlotId(_iBagId, _iSlotId, _FilterItFilter)
	local iInventoryId = PLAYER_INVENTORY.bagToInventoryType[_iBagId]
	local tSlot = PLAYER_INVENTORY.inventories[iInventoryId].slots[_iSlotId]
	-- banks don't populate until you open them, check & refresh if necessary
	if not tSlot then
		PLAYER_INVENTORY:RefreshAllInventorySlots(iInventoryId)
		tSlot = PLAYER_INVENTORY.inventories[iInventoryId].slots[_iSlotId]
	end
	return CheckFilters(tSlot, _FilterItFilter)
end

-------------------------------------------------
-- Set Layout Additional Filters --
-- Used to set the additional filters for the different layout
-- views of the backpack
-------------------------------------------------
local function SetLayoutAdditionalFilters()
	for k, v in pairs(tInventoryFilters) do 
		local additionalFilter = v.Data.additionalFilter
		
		if type(additionalFilter) == "function" then
			v.Data.additionalFilter = function(_tSlot)
				return additionalFilter(_tSlot) and CheckFilters(_tSlot, v.FilterType)
			end
		else
			v.Data.additionalFilter = function(_tSlot)
				return CheckFilters(_tSlot, v.FilterType)
			end
		end
	end
end	
SetLayoutAdditionalFilters()


--*******************************************************--
--***********   Scroll of Mara fix    *******************--
--*******************************************************--
function ZO_InventoryManager:AddInventoryItem(inventoryType, slotIndex)
    local inventory = self.inventories[inventoryType]
    local bagId = inventory.backingBag

    local slot = SHARED_INVENTORY:GenerateSingleSlotData(bagId, slotIndex)
    
    -- Create replacement copy of slot data with MISC replaced with CONSUMABLE 
    -- in item filter types
    if slot and slot.specializedItemType == SPECIALIZED_ITEMTYPE_TROPHY_SCROLL then
        local fixed = {}
        for key,value in pairs(slot) do
            if key == "filterData" then
                fixed[key] = {}
                for i,filterValue in ipairs(value) do
                    if filterValue == ITEMFILTERTYPE_MISCELLANEOUS then
                        fixed[key][i] = ITEMFILTERTYPE_CONSUMABLE
                    else
                        fixed[key][i] = filterValue
                    end
                end
            else
                fixed[key] = value
            end
        end
        slot = fixed
    end
    
    inventory.slots[slotIndex] = slot
end	



local OrigAlchemyDoesPassFilter = ZO_Alchemy_DoesAlchemyItemPassFilter
function ZO_Alchemy_DoesAlchemyItemPassFilter(bagId, slotIndex, filterType)
	if not OrigAlchemyDoesPassFilter(bagId, slotIndex, filterType) then
		return false
	end
	return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_ALCHEMY)
end


local function IsEnchantingItem(bagId, slotIndex)
    local usedInCraftingType, craftingSubItemType, runeType = GetItemCraftingInfo(bagId, slotIndex)

    if usedInCraftingType == CRAFTING_TYPE_ENCHANTING then
        if runeType == ENCHANTING_RUNE_ASPECT or runeType == ENCHANTING_RUNE_ESSENCE or runeType == ENCHANTING_RUNE_POTENCY then
            return true
        end
        if craftingSubItemType == ITEMTYPE_GLYPH_WEAPON or craftingSubItemType == ITEMTYPE_GLYPH_ARMOR or craftingSubItemType == ITEMTYPE_GLYPH_JEWELRY then
            return true
        end
    end

    return false
end

local function DoesEnchantingItemPassFilter(bagId, slotIndex, filterType)
    local usedInCraftingType, craftingSubItemType, runeType = GetItemCraftingInfo(bagId, slotIndex)

    if filterType == EXTRACTION_FILTER then
        return craftingSubItemType == ITEMTYPE_GLYPH_WEAPON or craftingSubItemType == ITEMTYPE_GLYPH_ARMOR or craftingSubItemType == ITEMTYPE_GLYPH_JEWELRY
    elseif filterType == NO_FILTER or filterType == runeType then
        return runeType == ENCHANTING_RUNE_ASPECT or runeType == ENCHANTING_RUNE_ESSENCE or runeType == ENCHANTING_RUNE_POTENCY
    end

    return false
end

local function EnchantingFilterPassCheck(bagId, slotIndex, filterType)
	if not DoesEnchantingItemPassFilter(bagId, slotIndex, filterType) then
		return false
	end
	return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_ENCHANTING)
end

function ZO_EnchantingInventory:Refresh(data)
    local filterType
    if self.owner:GetEnchantingMode() == ENCHANTING_MODE_CREATION then
        filterType = self.filterType
    else
        filterType = EXTRACTION_FILTER
    end
    local validItemIds = self:EnumerateInventorySlotsAndAddToScrollData(IsEnchantingItem, EnchantingFilterPassCheck, filterType, data)
    self.owner:OnInventoryUpdate(validItemIds)

    self.noRunesLabel:SetHidden(#data > 0)
end



--*******************************************************--
--**********   Deconstruction/Refinement  ***************--
--*******************************************************--
-------------------------------------------------
--[[ This handles BOTH the deconstruction list & Refinement list. Although they have separate inventories, the game populates them with the same functions passing in different parameters so we have to follow their lead and do them both in the same function...somewhere, this doesItemPassFilter check seemed cleanest since its only 1 line of code and the function name fits what we are doing, checking if the item passes filters.--]]
-------------------------------------------------

local OrigExtractionDoesPassFilter = ZO_SharedSmithingExtraction_DoesItemPassFilter
function ZO_SharedSmithingExtraction_DoesItemPassFilter(bagId, slotIndex, filterType)
	if not OrigExtractionDoesPassFilter(bagId, slotIndex, filterType) then 
		return false
	end
	-- ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_ARMOR
	-- ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_WEAPONS
	if filterType == ZO_SMITHING_EXTRACTION_SHARED_FILTER_TYPE_RAW_MATERIALS then
		return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_REFINEMENT)
	end
	return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_DECONSTRUCTION)
end

--*******************************************************--
--****************   Improvement    *********************--
--*******************************************************--
--[[ Improvement does have its own separate inventory, this could have been done a lot of places but since I used the DoesItemPassFilter for extraction/refinement I figured I might as well use the improvement one as well, so the code is similar & easier to understand.
--]]
local OrigImprovDoesPassFilter = ZO_SharedSmithingImprovement_DoesItemPassFilter
function ZO_SharedSmithingImprovement_DoesItemPassFilter(bagId, slotIndex, filterType)
	if not OrigImprovDoesPassFilter(bagId, slotIndex, filterType) then
		return false
	end
	-- Not needed, but these are the filterTypes if I ever decide I want to
	-- Separate armor/weapon improvement filters
	-- ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_ARMOR = 1
	-- ZO_SMITHING_IMPROVEMENT_SHARED_FILTER_TYPE_WEAPONS = 2
	return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_IMPROVEMENT)
end




--*******************************************************--
--****************     Research     *********************--
--*******************************************************--
-------------------------------------------------
-- Set Up Dialog --
--[[ Research Dialog: Used to hide items from the research dialog box
Note the research window will still show the correct number of items available for research, the items just wont show up in the dialog box. I left it like this on purpose as sort of a hint to the player that there is an item available for research it just doesn't show up because its hidden
--local temp2 = ZO_SmithingResearchSelect.SetupDialog
-- rewrite it:
--]]
-------------------------------------------------
function ZO_SmithingResearchSelect:SetupDialog(craftingType, researchLineIndex, traitIndex)
    local listDialog = ZO_InventorySlot_GetItemListDialog()

    local _, _, _, timeRequiredForNextResearchSecs = GetSmithingResearchLineInfo(craftingType, researchLineIndex)
    local formattedTime = ZO_FormatTime(timeRequiredForNextResearchSecs, TIME_FORMAT_STYLE_COLONS, TIME_FORMAT_PRECISION_TWELVE_HOUR)

    listDialog:SetAboveText(GetString(SI_SMITHING_RESEARCH_DIALOG_SELECT))
    listDialog:SetBelowText(zo_strformat(SI_SMITHING_RESEARCH_DIALOG_CONSUME, formattedTime))
    listDialog:SetEmptyListText("")

    listDialog:ClearList()

    local function IsResearchableItem(bagId, slotIndex)
        --return CanItemBeSmithingTraitResearched(bagId, slotIndex, craftingType, researchLineIndex, traitIndex)
		-- check to see if its even researchable first, will be faster.
		if CanItemBeSmithingTraitResearched(bagId, slotIndex, craftingType, researchLineIndex, traitIndex) then
			return RunFilterFromBagIdSlotId(bagId, slotIndex, FILTERIT_RESEARCH)
		end
    end

    local virtualInventoryList = PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BANK, IsResearchableItem, PLAYER_INVENTORY:GenerateListOfVirtualStackedItems(INVENTORY_BACKPACK, IsResearchableItem))
    for itemId, itemInfo in pairs(virtualInventoryList) do
        itemInfo.name = zo_strformat(SI_TOOLTIP_ITEM_NAME, GetItemName(itemInfo.bag, itemInfo.index))
        listDialog:AddListItem(itemInfo)
    end

    listDialog:CommitList(SortComparator)

    listDialog:AddCustomControl(self.control, LIST_DIALOG_CUSTOM_CONTROL_LOCATION_BOTTOM)
end
	
	

--*******************************************************--
--****************   Quick Slots   **********************--
--*******************************************************--
function ZO_QuickslotManager:ShouldAddItemToList(itemData)

    for i = 1, #itemData.filterData do
        if(itemData.filterData[i] == ITEMFILTERTYPE_QUICKSLOT) then
            return RunFilterFromBagIdSlotId(itemData.bagId, itemData.slotIndex, FILTERIT_QUICKSLOT)
        end
    end
    
	return false
end

local DATA_TYPE_COLLECTIBLE_ITEM = 2
function ZO_QuickslotManager:AppendCollectiblesData(scrollData)
    local data = COLLECTIONS_INVENTORY_SINGLETON:GetQuickslotData()
    for i = 1, #data do
        if CheckFilters(data[i], FILTERIT_QUICKSLOT) then
			table.insert(scrollData, ZO_ScrollList_CreateDataEntry(DATA_TYPE_COLLECTIBLE_ITEM, data[i]))
		end
    end
end
	

--*******************************************************--
--****************   Provisioning   *********************--
--*******************************************************--
--[[
Removed Code: LibFilterIt no longer blocks items from showing up in the provisioning window.
With no simple way to access filtered items I was forced to loop through the backpack & bank
for every check on each recipe for the number of items that could be created. This just caused
to much overhead & delay...which in turn caused problems with other addons.
--]]

--[[
-------------------------------------------------
-- loop through the backpack & bank to look for provisioning ingredients
-- As they are found run them against the current registered provisioning filters to
-- see if they are allowed. If they are not allowed (supposed to be hidden/filtered) then
-- add them to the ingredient info table. When done pass it back to the calling function.
-- The purpose of this is so I do not have to search the ENTIRE backpack and bank every
-- time an ingredient is found in a recipe to check if it is supposed to be hidden
-- For each ingredient found (when the provisioning station recipe list is populated)
-- I can just check this small table to see if that ingredient should be hidden or not
-- And then tell CalculateHowManyCouldBeCreated() that we can only create 0 of them
-------------------------------------------------
local function GetFilteredIngredients()
	local tBackpackSlots = PLAYER_INVENTORY.inventories[INVENTORY_BACKPACK].slots
	local tBankSlots = PLAYER_INVENTORY.inventories[INVENTORY_BANK].slots
	local tFilteredIngredients = {}
	
	for k,tSlot in pairs(tBackpackSlots) do
		local lLink = GetItemLink(tSlot.bagId, tSlot.slotIndex)
		local CraftingSkillType = GetItemLinkCraftingSkillType(lLink)
		if CraftingSkillType == CRAFTING_TYPE_PROVISIONING then
			if not CheckFilters(tSlot, FILTERIT_PROVISIONING) then
				local itemID = select(4,ZO_LinkHandler_ParseLink(lLink))
				table.insert(tFilteredIngredients, itemID)
			end
		end
	end
	for k,tSlot in pairs(tBankSlots) do
		local lLink = GetItemLink(tSlot.bagId, tSlot.slotIndex)
		local CraftingSkillType = GetItemLinkCraftingSkillType(lLink)
		if not CraftingSkillType == CRAFTING_TYPE_PROVISIONING then
			if not CheckFilters(tSlot, FILTERIT_PROVISIONING) then
				local itemID = select(4,ZO_LinkHandler_ParseLink(lLink))
				table.insert(tFilteredIngredients, itemID)
			end
		end
	end
	return tFilteredIngredients
end

-------------------------------------------------
-- Checks the ingredients of a recipe to see if any of the ingredients should be filtered
-- If so it returns false, so the recipe does not get added to the list.
-------------------------------------------------
local function CanUseIngredients(_tFilteredIngredients, recipeListIndex, recipeIndex, numIngredients) 
    for ingredientIndex = 1, numIngredients do
		local lIngredientLink = GetRecipeIngredientItemLink(recipeListIndex, recipeIndex, ingredientIndex) 
		local recipeIngredientItemId = select(4,ZO_LinkHandler_ParseLink(lIngredientLink))

		for k, savedIngredientItemId in pairs(_tFilteredIngredients) do
			if recipeIngredientItemId == savedIngredientItemId then return false end
		end
    end
	return true
end

local OrigCalcHowManyCouldBeCreated = ZO_SharedProvisioner.CalculateHowManyCouldBeCreated
function ZO_SharedProvisioner:CalculateHowManyCouldBeCreated(recipeListIndex, recipeIndex, numIngredients)
	-- check their code first will be much faster for all calls where we don't have
	-- the ingredients.
	local iNumCanBeCreated = OrigCalcHowManyCouldBeCreated(self, recipeListIndex, recipeIndex, numIngredients)
	
	if iNumCanBeCreated < 1 then return 0 end
	
	-- get the ingredients that are filtered:
	local tFilteredIngredients = GetFilteredIngredients()
	
	if not CanUseIngredients(tFilteredIngredients, recipeListIndex, recipeIndex, numIngredients) then
		return 0
	end
	return iNumCanBeCreated
end
--]]
