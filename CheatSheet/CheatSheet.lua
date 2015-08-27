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
local SortMethod = {}
local EventFrame = CreateFrame("Frame")
local MainFrame = CreateFrame("Frame", "CSHT_MainFrame")
local ScrollFrame = CreateFrame("ScrollFrame", "CSHT_ScrollFrame")
local SlideFrame = CreateFrame("Slider", "CSHT_SlideFrame")
local ResizeFrame = CreateFrame("Button", "CSHT_ResizeFrame")
local SheetFont = CreateFont("CSHT_SheetFont")
local Index = {}
local Sheets = {}
local SheetFrames = {}
local FrameTexts = {}
local HeightMin = 100
local WidthMin = 100


--Object Definition--
CheatSheet.Modules = {}
CheatSheet.Options = {}


-- Allows external modules to make themselves known to this core addon, allowing them to be used in game
function CheatSheet:Register(module)
	table.insert(CheatSheet.Modules, module)
end

--Default Settings
CheatSheet.Options.CollateNotes = true
CheatSheet.Options.SortMethod = "DescSpecific"


--General Functions--

-- Sheet comparison function for soortin of Sheets table
-- Causes the most specific tables to be placed at the front of the list
-- Falls back on sorting based on alphabetical order of first not for each sheet if both are equally specific
function SortMethod.DescSpecific(sheet1, sheet2)
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
	-- print("Building Index")
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
	-- print("Index Built")
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
	table.sort(Sheets, SortMethod[CheatSheet.Options.SortMethod])
	
	-- Debug: Print loaded sheets
	-- for key, sheet in ipairs(Sheets) do
		-- for nkey, note in ipairs(sheet.NOTE) do
			-- print(note)
		-- end
	-- end
end

function CreateSheetFrame(index)
	local SheetFrame = CreateFrame("Frame", "CSHT_SheetFrame" .. index, MainFrame)
	SheetFrame:SetFrameStrata("MEDIUM")
	SheetFrame:SetPoint("TOPLEFT", 5, -20*index + 15)
	SheetFrame:SetSize(140, 15)
	SheetFrame.fontString = SheetFrame:CreateFontString()
	SheetFrame.fontString:SetFontObject(SheetFont)
	SheetFrame.fontString:SetWordWrap(true)
	SheetFrame.fontString:SetPoint("TOPLEFT", 5, -5)
	SheetFrame.fontString:SetWidth(130)
	SheetFrame.BGTexture = SheetFrame:CreateTexture()
	SheetFrame.BGTexture:SetTexture(0.1,0.1,0.1,0.5)
	SheetFrame.BGTexture:SetAllPoints()
	function SheetFrame:UpdateSize()
		self:SetHeight(self.fontString:GetStringHeight()+10)
		self:SetWidth(self:GetParent():GetWidth() - 10)
		self.fontString:SetWidth(self:GetWidth() - 10)
	end
	function SheetFrame:UpdateText(text)
		self.fontString:SetText(text)
		self:UpdateSize()
	end
	return SheetFrame
end

function UpdateSheetFrames()
	local index = 0
	local offset = 5
	for key, sheet in ipairs(Sheets)do
		if CheatSheet.Options.CollateNotes then
			index = index + 1
			if not SheetFrames[index] then
				SheetFrames[index] = CreateSheetFrame(index)
			end
			local tempText = table.concat(sheet.NOTE, "\n")
			SheetFrames[index]:UpdateText(tempText)
			SheetFrames[index]:Show()
			SheetFrames[index]:SetPoint("TOPLEFT", 5, -offset)
			offset = offset + 5 + SheetFrames[index]:GetHeight()
		else
			for nKey, note in ipairs(sheet.NOTE) do
				index  = index + 1
				if not SheetFrames[index] then
					SheetFrames[index] = CreateSheetFrame(index)
				end
				SheetFrames[index]:UpdateText(note)
				SheetFrames[index]:Show()
				SheetFrames[index]:SetPoint("TOPLEFT", 5, -offset)
				offset = offset + 5 + SheetFrames[index]:GetHeight()
			end
		end
	end
	MainFrame:SetHeight(offset)
	if index < #SheetFrames then
		for i = index + 1, #SheetFrames do
			SheetFrames[i]:Hide()
		end
	end
end


--Event Handler Functions--
function OnZoneChange(self, event, ...)
	-- print("You are in: " .. GetMinimapZoneText())
	local role = UnitGroupRolesAssigned("player")
	local class = UnitClass("player")
	local specID, spec = GetSpecializationInfo(GetSpecialization())
	loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
	UpdateSheetFrames()
end

function OnReload(self, event, ...)
	-- print("Game Reloaded")
	buildIndex()
	local role = UnitGroupRolesAssigned("player")
	local class = UnitClass("player")
	local specID, spec = GetSpecializationInfo(GetSpecialization())
	loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
	UpdateSheetFrames()
end

--GUI Frames--
do
	do -- Setup Main Frame
		MainFrame:SetFrameStrata("MEDIUM")
		--MainFrame:SetParent(ScrollFrame)
		MainFrame:SetPoint("TOPLEFT")
		MainFrame:SetHeight(400)
		MainFrame:SetWidth(150)
		MainFrame:SetMovable(true)
		
		--local MBG = MainFrame:CreateTexture(nil, "BACKGROUND")
		--MBG:SetTexture(0.5, 0, 0, 0.5)
		--MBG:SetAllPoints()
	end
	
	do -- Set up scroll frame to contain main frame
		ScrollFrame:SetFrameStrata("MEDIUM")
		ScrollFrame:SetPoint("CENTER")
		ScrollFrame:SetSize(160, 200)
		ScrollFrame:SetMovable(true)
		ScrollFrame:EnableMouse(true)
		ScrollFrame:EnableMouseWheel(true)
		ScrollFrame:RegisterForDrag("LeftButton")
		ScrollFrame:SetScrollChild(MainFrame)
		ScrollFrame:SetResizable(true)
		
		ScrollFrame:SetScript("OnDragStart", function(self)
			self:StartMoving()
		end)
		ScrollFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
		end)
		ScrollFrame:SetScript("OnMouseWheel", function(self, delta)
			local scroll = math.max(math.min(self:GetVerticalScroll() + (-10 * delta), (MainFrame:GetHeight() - ScrollFrame:GetHeight())) , 0)
			self:SetVerticalScroll(scroll)
			SlideFrame:SetValue(scroll)
		end)
		ScrollFrame:SetScript("OnSizeChanged", function(self, width, height)
			if width < WidthMin then 
				width = WidthMin
				self:SetWidth(width)
			end
			if height < HeightMin then
				height = HeightMin
				self:SetHeight(height)
			end
			self:UpdateFrameSizes(width, height)
		end)
		
		local background = ScrollFrame:CreateTexture(nil, "BACKGROUND")
		background:SetTexture(0.5, 0.5, 0.5, 0.5)
		background:SetAllPoints()
		
		function ScrollFrame:UpdateFrameSizes(Width, Height)
			-- local Children = {}
			-- Children = ScrollFrame:GetChildren()
			--local Width = self:GetWidth()
			--local Height = self:GetHeight()
			-- for key, child in ipairs(Children) do
				-- if child:GetName() == "CSHT_MainFrame" then
					-- child:SetWidth(Width - 10)
					-- UpdateSheetFrames()
					-- SlideFrame:SetMinMaxValues(0, child:GetHeight() - Height)
				-- elseif child:GetName() == "CSHT_SlideFrame" then
					-- child:SetHeight(Height)
				-- end
			-- end
			MainFrame:SetWidth(Width - 10)
			UpdateSheetFrames()
			SlideFrame:SetMinMaxValues(0, math.max(MainFrame:GetHeight() - Height, 0))
			SlideFrame:SetHeight(Height)
		end

	end
	
	do -- Set up vertical scroll bar
		SlideFrame:SetFrameStrata("MEDIUM")
		SlideFrame:SetParent(ScrollFrame)
		SlideFrame:SetPoint("TOPRIGHT")
		SlideFrame:SetSize(10, 200)
		SlideFrame:EnableMouse(true)
		SlideFrame:SetMinMaxValues(0, math.max(MainFrame:GetHeight() - ScrollFrame:GetHeight(), 0))
		SlideFrame:Enable()
		SlideFrame:SetValue(0)
		
		SlideFrame:SetScript("OnValueChanged", function (self, value) 
			self:GetParent():SetVerticalScroll(value) 
		end)
		
		local SlideBG = SlideFrame:CreateTexture(nil, "BACKGROUND")
		SlideBG:SetTexture(0.1, 0.1, 0.1, 0.3)
		SlideBG:SetAllPoints()
		
		local SlideThumb = SlideFrame:CreateTexture()
		SlideThumb:SetTexture(0.1, 0.1, 0.1, 0.5)
		SlideFrame:SetThumbTexture(SlideThumb)
	end
	
	do -- Set up resize button
		ResizeFrame:SetFrameStrata("MEDIUM")
		ResizeFrame:SetParent(ScrollFrame)
		ResizeFrame:SetPoint("BOTTOMRIGHT", -10, 0)
		ResizeFrame:SetSize(10, 10)
		ResizeFrame:EnableMouse(true)
		ResizeFrame:RegisterForClicks("LeftButton")
		ResizeFrame:Enable()
		
		ResizeFrame:SetScript("OnMouseDown", function(self)
			self:GetParent():StartSizing()
		end)
		ResizeFrame:SetScript("OnMouseUp", function(self)
			self:GetParent():StopMovingOrSizing()
		end)
		
		local ResizeBG = ResizeFrame:CreateTexture()
		ResizeBG:SetTexture(0.1, 0.1, 0.1, 0.5)
		ResizeBG:SetAllPoints()
		ResizeFrame:SetNormalTexture(ResizeBG)
		
		local ResizeHL = ResizeFrame:CreateTexture()
		ResizeHL:SetTexture(0.5, 0.5, 0.5, 0.5)
		ResizeBG:SetAllPoints()
		ResizeFrame:SetHighlightTexture(ResizeHL, "BLEND")
		
		local ResizePSH = ResizeFrame:CreateTexture()
		ResizePSH:SetTexture(0.8, 0.8, 0.8, 0.5)
		ResizePSH:SetAllPoints()
		ResizeFrame:SetPushedTexture(ResizePSH)
	end
	
	do -- Set up Font object
		SheetFont:SetFont("Fonts\\FRIZQT__.TTF", 10)
		SheetFont:SetTextColor(1, 1, 1, 1)
		SheetFont:SetJustifyH("LEFT")
	end
	
	SheetFrames[1] = CreateSheetFrame(1)
end


--Initial Setup--
do
	-- Event Registration and handling
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