-- CheatSheet: An addon for World of Warcraft that provides context sensitive info or guidlines
-- Copyright (C) 2015 Sam "smarky55" Kingdon

-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU General Public License as published by
-- the Free Software Foundation, either version 3 of the License, or
-- (at your option) any later version.

-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.

-- You should have received a copy of the GNU General Public License
-- along with this program.  If not, see <http://www.gnu.org/licenses/>.

--Global Variables--
CheatSheet = {}


--Local Variables--
local ZoneEvents = {ZONE_CHANGED = true, ZONE_CHANGED_INDOORS = true, ZONE_CHANGED_NEW_AREA = true}
local EventFrame = CreateFrame("Frame")
local MainFrame = CreateFrame("Frame", "CSHT_MainFrame")
local Index = {}
local Sheets = {}

--Object Definition--
CheatSheet.Modules = {}

-- Allows external modules to make themselves known to this core addon, allowing them to be used in game
function CheatSheet:Register(module)
	table.insert(CheatSheet.Modules, module)
end

--GUI Frames--

do
	MainFrame:SetFrameStrata("MEDIUM")
	MainFrame:SetPoint("CENTER")
	MainFrame:SetSize(150, 200)
	MainFrame:SetMovable(true)
	MainFrame:EnableMouse(true)
	MainFrame:RegisterForDrag("LeftButton")
	
	MainFrame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	MainFrame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)
	
	local background = MainFrame:CreateTexture("CSHT_MFrame_BGND", "BACKGROUND")
	do
		background:SetTexture(0.5, 0.5, 0.5, 0.3)
		background:SetAllPoints()
	end
	
	
	
	MainFrame:Show()
end


--General Functions--

-- Sheet comparison function for soortin of Sheets table
-- Causes the most specific tables to be placed at the front of the list
-- Falls back on sorting based on alphabetical order of first not for each sheet if both are equally specific
function sheetComp(sheet1, sheet2)
	local s1, s2 = 0, 0
	for k, v in pairs(sheet1) do
		if v~= nil and v ~= "ANY" then
			s1 = s1 + 1
		end
	end
	for k, v in pairs(sheet2) do
		if v~= nil and v ~= "ANY" then
			s2 = s2 + 1
		end
	end
	if s1 ~= s2 then
		return s1 > s2
	else
		return sheet1.NOTE[1] < sheet2.NOTE[1]
	end
end


-- Creates index of sheets in all registered modules
-- -Creates a table where each zone that appears in any sheet has a sub-table
-- -This sub-table contains all referenced subzones, each with another sub-table
-- -This sub-table contains two element tables 
-- --where [1] is the index of the module in CheatSheet.Modules
-- --and [2] is the index of a sheet in the respective module
function buildIndex()
	print("Building Index")
	for modKey, module in ipairs(CheatSheet.Modules) do
		for sheetKey, sheet in ipairs(module.SHEETS) do
			local sublist = {}
			sublist[1] = modKey
			sublist[2] = sheetKey
			local zone
			local subzone
			if sheet.ZONE and sheet.SUBZONE then
				zone = sheet.ZONE
				subzone = sheet.SUBZONE
			elseif sheet.ZONE and sheet.SUBZONE == nil then
				zone = sheet.ZONE
				subzone = "ALL"
			elseif sheet.ZONE == nil then
				zone = "ALL"
				subzone = "ALL"
			end	
			if Index[zone] and Index[zone][subzone] == nil then
				Index[zone][subzone] = {}
			elseif Index[zone] == nil then
				Index[zone] = {}
				Index[zone][subzone] = {}
			end
			table.insert(Index[zone][subzone], sublist)
		end
	end
	print("Index Built")
end

-- Load sheets relevant to the current context
-- first creates a temporary index of all sheets that are globally relevant, relevant to the entire current zone, or relevant to the current subzone
-- Then loops through this index to find sheets relevant to the current character's class, role or spec
function loadSheets(zone, subzone, class, spec, role)
	-- Reset contenst of Sheets
	Sheets = {}
	-- Create sub-index for locationally relevent sheets
	local tempIndex = {}
	if Index["ALL"] and Index["ALL"]["ALL"] then
		for key, sheet in ipairs(Index["ALL"]["ALL"]) do
			table.insert(tempIndex, sheet)
		end
	end
	if Index[zone] and Index[zone]["ALL"] then
		for key, sheet in ipairs(Index[zone]["ALL"]) do
			table.insert(tempIndex, sheet)
		end
	end
	if subzone and Index[zone] and Index[zone][subzone] then
		for key, sheet in ipairs(Index[zone][subzone]) do
			table.insert(tempIndex, sheet)
		end
	end
	
	-- Load content of the relevent sheets
	for key, sheet in ipairs(tempIndex) do
		local thisSheet = CheatSheet.Modules[sheet[1]].SHEETS[sheet[2]]
		local role = UnitGroupRolesAssigned("player")
		local class, classToken = UnitClass("player")
		if thisSheet.ROLE and thisSheet.ROLE ~= role  and thisSheet.ROLE ~= "ANY" then
		elseif thisSheet.CLASS and thisSheet.CLASS ~=  class and thisSheet.CLASS ~= "ANY" then
		elseif thisSheet.SPEC and thisSheet.SPEC ~= spec and thisSheet.SPEC ~= "ANY" then
		else
			table.insert(Sheets, thisSheet)
		end
		
	end
	
	-- Sort sheets table
	table.sort(Sheets, sheetComp)
	
	-- Debug: Print loaded sheets
	for key, sheet in ipairs(Sheets) do
		for nkey, note in ipairs(sheet.NOTE) do
			print(note)
		end
	end
end

--Event Handler Functions--
function OnZoneChange(self, event, ...)
	print("You are in: " .. GetMinimapZoneText())
	local role = UnitGroupRolesAssigned("player")
	local class = UnitClass("player")
	local specID, spec = GetSpecializationInfo(GetSpecialization())
	loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
end

function OnReload(self, event, ...)
	print("Game Reloaded")
	-- for key, value in ipairs(CheatSheet.Modules) do
		-- print("Module loaded: " .. value.NAME)
		-- for k , v in ipairs(value.SHEETS) do
			-- print("  Has sheet for: " .. v.SUBZONE .. ":" .. v.ZONE)
		-- end
	-- end
	buildIndex()
	local role = UnitGroupRolesAssigned("player")
	local class = UnitClass("player")
	local specID, spec = GetSpecializationInfo(GetSpecialization())
	loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
end


--Event Registration--
do
	EventFrame:RegisterEvent("ZONE_CHANGED")
	EventFrame:RegisterEvent("ZONE_CHANGED_INDOORS")
	EventFrame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	EventFrame:RegisterEvent("PLAYER_LOGIN")

	EventFrame:SetScript("OnEvent", 
	function(self, event, ...)
		if ZoneEvents[event] then
			OnZoneChange(self, event, ...)
		elseif event == "PLAYER_LOGIN" then
			OnReload(self, event, ...)
		end
	end)
end