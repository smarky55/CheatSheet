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
local Index = {}
local Sheets = {}

--Object Definition--
CheatSheet.Modules = {}

function CheatSheet:Register(module)
	table.insert(CheatSheet.Modules, module)
end

--General Functions--
function buildIndex()
	print("Building Index")
	for modKey, module in pairs(CheatSheet.Modules) do
		for sheetKey, sheet in pairs(module.SHEETS) do
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

function loadSheets(zone, subzone)
	-- Reset contenst of Sheets
	Sheets = {}
	-- Create sub-index for locationally relevent sheets
	local tempIndex = {}
	if Index["ALL"] and Index["ALL"]["ALL"] then
		for key, sheet in pairs(Index["ALL"]["ALL"]) do
			table.insert(tempIndex, sheet)
		end
	end
	if Index[zone] and Index[zone]["ALL"] then
		for key, sheet in pairs(Index[zone]["ALL"]) do
			table.insert(tempIndex, sheet)
		end
	end
	if subzone and Index[zone] and Index[zone][subzone] then
		for key, sheet in pairs(Index[zone][subzone]) do
			table.insert(tempIndex, sheet)
		end
	end
	
	-- Load content of the relevent sheets
	for key, sheet in pairs(tempIndex) do
		table.insert(Sheets, CheatSheet.Modules[sheet[1]].SHEETS[sheet[2]])
	end
	
	-- Debug: Print loaded sheets
	for key, sheet in pairs(Sheets) do
		for nkey, note in pairs(sheet.NOTE) do
			print(note)
		end
	end
end

--Event Handler Functions--
function OnZoneChange(self, event, ...)
	print("You are in: " .. GetMinimapZoneText())
	loadSheets(GetZoneText(), GetSubZoneText())
end

function OnReload(self, event, ...)
	print("Game Reloaded")
	-- for key, value in pairs(CheatSheet.Modules) do
		-- print("Module loaded: " .. value.NAME)
		-- for k , v in pairs(value.SHEETS) do
			-- print("  Has sheet for: " .. v.SUBZONE .. ":" .. v.ZONE)
		-- end
	-- end
	buildIndex()
	loadSheets(GetZoneText(), GetSubZoneText())
end


--Event Registration--
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