--CheatSheet copyright smarky55 (Sam Kingdon) 2015 All rights reserved--

--Global Variables--
CheatSheet = {}


--Local Variables--
local ZoneEvents = {ZONE_CHANGED = true, ZONE_CHANGED_INDOORS = true, ZONE_CHANGED_NEW_AREA = true}
local EventFrame = CreateFrame("Frame")
local Index = {}

--Object Definition--
CheatSheet.Modules = {}

function CheatSheet:Register(module)
	table.insert(CheatSheet.Modules, module)
end


--Event Handler Functions--
function OnZoneChange(self, event, ...)
	print("You are in: " .. GetMinimapZoneText())
end

function OnReload(self, event, ...)
	print("Game Reloaded")
	for key, value in pairs(CheatSheet.Modules) do
		print("Module loaded: " .. value.NAME)
		for k , v in pairs(value.SHEETS) do
			print("  Has sheet for: " .. v.SUBZONE .. ":" .. v.ZONE)
		end
	end
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