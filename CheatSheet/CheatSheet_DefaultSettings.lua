-- CheatSheat_Defaults: A set of default entries for CheatSheet
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

CSHT_DefaultSettings = {}
local settings = CSHT_DefaultSettings
settings.core = {}
settings.sheet = {}
settings.appearance = {}
settings.misc = {}

local function AddOption(category, name, friendlyName, typ, value, arg1, arg2)
	local limit = {int = true, float = true, vec2 = true}
	local option = {}
	option.NAME = name
	if friendlyName ~= "" then
		option.FNAME = friendlyName
	else
		option.FNAME = name
	end
	option.TYPE = typ
	option.VAL = value
	if limit[typ] then
		option.MAX = arg1
		option.MIN = arg2
	end
	if typ == "multi" then
		option.CHOICES = arg1
	end
	settings[category][name] = option
end

-- Add Testing Settings
AddOption("misc", "testBool", "", "bool", false)
AddOption("misc", "testInt", "", "int", 10, 50, 0)
AddOption("misc", "testFloat", "", "float", 2.5, 20, -20)
AddOption("misc", "testString", "", "string", "Test String")
AddOption("misc", "testVec2", "", "vec2", {20, 30}, {100, 100}, {0, 0})

-- Add Core Settings
AddOption("core", "MainFramePos", "", "vec2", {GetScreenWidth()/2, GetScreenHeight()/2})
AddOption("core", "MainFrameDim", "", "vec2", {160, 200})
AddOption("core", "ConfigFramePos", "", "vec2", {GetScreenWidth()/2, GetScreenHeight()/2})
AddOption("core", "ConfigFrameDim", "", "vec2", {600, 400})

AddOption("core", "VisMMRad", "", "int", 80)

AddOption("core", "VisMMAngle", "", "float", -2.2)

AddOption("core", "ConfigVisible", "", "bool", false)
AddOption("core", "MainVisible", "", "bool", true)

-- Add sheet settings
AddOption("sheet", "CollateNotes", "Collate Notes", "bool", true)

AddOption("sheet", "SortMethod", "Sorting Method", "multi", "DescSpecific", 
			{"DescSpecific", "AscSpecific", "DescAlphabet", "AscAlphabet"})
