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
local ScrollUpButton = CreateFrame("Button", "CSHT_ScrlUpButton")
local ScrollDownButton = CreateFrame("Button", "CSHT_ScrlDnButton")
local SlideFrame = CreateFrame("Slider", "CSHT_SlideFrame")
local ResizeButton = CreateFrame("Button", "CSHT_ResizeButton")
local MenuFrame = CreateFrame("Frame", "CSHT_MenuFrame")
local LockButton = CreateFrame("Button", "CSHT_LockButton")
local VisibleButton = CreateFrame("Button", "CSHT_VisibleButton")
local SheetFont = CreateFont("CSHT_SheetFont")
local Index = {}
local Sheets = {}
local SheetFrames = {}
local FrameTexts = {}
local HeightMin = 100
local WidthMin = 100
local forceReload = false


--Object Definition--
CheatSheet.Modules = {}
CheatSheet.Settings = CSHT_DefaultSettings
CheatSheet.SettingsFrame = CreateFrame("Frame", "CSHT_ConfigFrame")

-- Allows external modules to make themselves known to this core addon, allowing them to be used in game
function CheatSheet:Register(module)
	table.insert(CheatSheet.Modules, module)
end

function CheatSheet:Show()
	ScrollFrame:Show()
end

function CheatSheet:Hide()
	ScrollFrame:Hide()
end

function CheatSheet:Toggle()
	if CheatSheet.Settings.core.MainVisible.VAL then
		CheatSheet:Hide()
	else
		CheatSheet:Show()
	end
	CheatSheet.Settings.core.MainVisible.VAL = not CheatSheet.Settings.core.MainVisible.VAL
end

function CheatSheet:LoadSettings()
	if not forceReload and CSHT_Settings then 
		CheatSheet.Settings = CSHT_Settings
	else
		CSHT_Settings = CheatSheet.Settings
	end
	ScrollFrame:UpdatePos(CheatSheet.Settings.core.MainFramePos.VAL)
	ScrollFrame:UpdateDim(CheatSheet.Settings.core.MainFrameDim.VAL)
end

function CheatSheet:SaveSettings()
	CSHT_Settings = CheatSheet.Settings
end


--General Functions--

do -- Sorting Functions
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

	function SortMethod.AscSpecific(sheet1, sheet2)
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
			return s1 < s2
		else
			if sheet1.TITLE and sheet2.TITLE then
				return sheet1.TITLE < sheet2.TITLE
			else
				return sheet1.NOTE[1] < sheet2.NOTE[1]
			end
		end
	end

	function SortMethod.DescAlphabet(sheet1, sheet2)
		if sheet1.TITLE and sheet2.TITLE then
			return sheet1.TITLE > sheet2.TITLE
		else
			return sheet1.NOTE[1] > sheet2.NOTE[1]
		end
	end

	function SortMethod.AscAlphabet(sheet1, sheet2)
		if sheet1.TITLE and sheet2.TITLE then
			return sheet1.TITLE < sheet2.TITLE
		else
			return sheet1.NOTE[1] < sheet2.NOTE[1]
		end
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
	table.sort(Sheets, SortMethod[CheatSheet.Settings.sheet.SortMethod.VAL])
	
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
	SheetFrame.BGTexture:SetColorTexture(0.1,0.1,0.1,0.5)
	SheetFrame.BGTexture:SetAllPoints()
	function SheetFrame:UpdateSize()
		self:SetWidth(self:GetParent():GetWidth() - 10)
		self.fontString:SetWidth(self:GetWidth() - 10)
		self:SetHeight(self.fontString:GetStringHeight()+10)
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
		if CheatSheet.Settings.sheet.CollateNotes.VAL then
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


do -- Event Handler Functions
	function OnZoneChange(self, event, ...)
		-- print("You are in: " .. GetMinimapZoneText())
		-- local role = UnitGroupRolesAssigned("player")
		local class = UnitClass("player")
		local specID, spec, d, i, b, role = GetSpecializationInfo(GetSpecialization())
		loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
		UpdateSheetFrames()
	end

	function OnReload(self, event, ...)
		-- print("Game Reloaded")
		buildIndex()
		-- local role = UnitGroupRolesAssigned("player")
		local class = UnitClass("player")
		local specID, spec, d, i, b, role = GetSpecializationInfo(GetSpecialization())
		loadSheets(GetZoneText(), GetSubZoneText(), class, spec, role)
		UpdateSheetFrames()
	end
end


do -- Fonts
	do -- Set up Font object
		SheetFont:SetFont("Fonts\\FRIZQT__.TTF", 10)
		SheetFont:SetTextColor(1, 1, 1, 1)
		SheetFont:SetJustifyH("LEFT")
	end
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
		--MBG:SetColorTexture(0.5, 0, 0, 0.5)
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
		ScrollFrame:SetToplevel(true)
		-- ScrollFrame:SetDontSavePositon(true)
		
		ScrollFrame:SetScript("OnDragStart", function(self)
			self:StartMoving()
		end)
		ScrollFrame:SetScript("OnDragStop", function(self)
			self:StopMovingOrSizing()
			CheatSheet.Settings.core.MainFramePos.VAL[1] = ScrollFrame:GetLeft()
			CheatSheet.Settings.core.MainFramePos.VAL[2] = ScrollFrame:GetBottom()			
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
			CheatSheet.Settings.core.MainFrameDim.VAL[1] = width
			CheatSheet.Settings.core.MainFrameDim.VAL[2] = height
		end)
		
		local background = ScrollFrame:CreateTexture(nil, "BACKGROUND")
		background:SetColorTexture(0.5, 0.5, 0.5, 0.5)
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
			SlideFrame:SetHeight(Height - 30)
		end
		
		function ScrollFrame:UpdatePos(pos)
			self:ClearAllPoints()
			self:SetPoint("CENTER", pos[1], pos[2])
		end
		
		function ScrollFrame:UpdateDim(dim)
			self:SetSize(dim[1], dim[2])
		end
	end
	
	do -- Set up scroll up button
		ScrollUpButton:SetFrameStrata("MEDIUM")
		ScrollUpButton:SetParent(ScrollFrame)
		ScrollUpButton:SetPoint("TOPRIGHT")
		ScrollUpButton:SetSize(10, 10)
		ScrollUpButton:EnableMouse(true)
		ScrollUpButton:RegisterForClicks("LeftButton")
		ScrollUpButton:Enable()
		
		ScrollUpButton:SetScript("OnMouseUp", function(self, button)
			local scroll = math.max(math.min(ScrollFrame:GetVerticalScroll() + (-10), (MainFrame:GetHeight() - ScrollFrame:GetHeight())) , 0)
			ScrollFrame:SetVerticalScroll(scroll)
			SlideFrame:SetValue(scroll)
		end)
		
		local background = ScrollUpButton:CreateTexture()
		--background:SetColorTexture(0.1, 0.1, 0.1, 0.5)
		background:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Up.blp")
		background:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		background:SetAllPoints()
		ScrollUpButton:SetNormalTexture(background)
		
		local highlight = ScrollUpButton:CreateTexture()
		highlight:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Highlight.blp")
		highlight:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		highlight:SetAllPoints()
		ScrollUpButton:SetHighlightTexture(highlight)
		
		local pushed = ScrollUpButton:CreateTexture()
		pushed:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollUpButton-Down.blp")
		pushed:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		pushed:SetAllPoints()
		ScrollUpButton:SetPushedTexture(pushed)
		
	end
	
	do
		ScrollDownButton:SetFrameStrata("MEDIUM")
		ScrollDownButton:SetParent(ScrollFrame)
		ScrollDownButton:SetPoint("BOTTOMRIGHT", 0, 10)
		ScrollDownButton:SetSize(10, 10)
		ScrollDownButton:EnableMouse(true)
		ScrollDownButton:RegisterForClicks("LeftButton")
		ScrollDownButton:Enable()
		
		ScrollDownButton:SetScript("OnMouseUp", function(self, button)
			local scroll = math.max(math.min(ScrollFrame:GetVerticalScroll() + (10), (MainFrame:GetHeight() - ScrollFrame:GetHeight())) , 0)
			ScrollFrame:SetVerticalScroll(scroll)
			SlideFrame:SetValue(scroll)
		end)
		
		local background = ScrollDownButton:CreateTexture()
		background:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Up.blp")
		background:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		background:SetAllPoints()
		ScrollDownButton:SetNormalTexture(background)
		
		local highlight = ScrollDownButton:CreateTexture()
		highlight:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Highlight.blp")
		highlight:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		highlight:SetAllPoints()
		ScrollDownButton:SetHighlightTexture(highlight)
		
		local pushed = ScrollDownButton:CreateTexture()
		pushed:SetTexture("Interface\\Buttons\\UI-ScrollBar-ScrollDownButton-Down.blp")
		pushed:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		pushed:SetAllPoints()
		ScrollDownButton:SetPushedTexture(pushed)
	end
	
	do -- Set up vertical scroll bar
		SlideFrame:SetFrameStrata("MEDIUM")
		SlideFrame:SetParent(ScrollFrame)
		SlideFrame:SetPoint("TOPRIGHT", 0, -10)
		SlideFrame:SetSize(10, 170)
		SlideFrame:EnableMouse(true)
		SlideFrame:SetMinMaxValues(0, math.max(MainFrame:GetHeight() - ScrollFrame:GetHeight(), 0))
		SlideFrame:Enable()
		SlideFrame:SetValue(0)
		
		SlideFrame:SetScript("OnValueChanged", function (self, value) 
			self:GetParent():SetVerticalScroll(value) 
		end)
		
		local SlideBG = SlideFrame:CreateTexture(nil, "BACKGROUND")
		SlideBG:SetColorTexture(0.1, 0.1, 0.1, 0.3)
		SlideBG:SetAllPoints()
		
		local SlideThumb = SlideFrame:CreateTexture()
		SlideThumb:SetTexture("Interface\\Buttons\\UI-ScrollBar-Knob.blp")
		SlideThumb:SetTexCoord(0.203125, 0.796875, 0.203125, 0.796875)
		SlideThumb:SetSize(10, 10)
		SlideFrame:SetThumbTexture(SlideThumb)
	end
	
	do -- Set up resize button
		ResizeButton:SetFrameStrata("MEDIUM")
		ResizeButton:SetParent(ScrollFrame)
		ResizeButton:SetPoint("BOTTOMRIGHT")
		ResizeButton:SetSize(10, 10)
		ResizeButton:EnableMouse(true)
		ResizeButton:RegisterForClicks("LeftButton")
		ResizeButton:Enable()
		
		ResizeButton:SetScript("OnMouseDown", function(self, button)
			self:GetParent():StartSizing()
		end)
		ResizeButton:SetScript("OnMouseUp", function(self, button)
			self:GetParent():StopMovingOrSizing()
		end)
		
		local ResizeBG = ResizeButton:CreateTexture()
		ResizeBG:SetColorTexture(0.1, 0.1, 0.1, 0.5)
		ResizeBG:SetAllPoints()
		ResizeButton:SetNormalTexture(ResizeBG)
		
		local ResizeHL = ResizeButton:CreateTexture()
		ResizeHL:SetColorTexture(0.5, 0.5, 0.5, 1)
		ResizeBG:SetAllPoints()
		ResizeButton:SetHighlightTexture(ResizeHL)
		
		local ResizePSH = ResizeButton:CreateTexture()
		ResizePSH:SetColorTexture(0.8, 0.8, 0.8, 0.5)
		ResizePSH:SetAllPoints()
		ResizeButton:SetPushedTexture(ResizePSH)
	end
	
	do -- Set up visible toggle button
		function VisibleButton:CalcPos(radius, angle)
			self.pos[1] = radius * math.sin(angle)
			self.pos[2] = radius * math.cos(angle)
		end
		function VisibleButton:CalcAngle(xPos, yPos)
			CheatSheet.Settings.core.VisMMAngle.VAL = math.atan2(xPos, yPos)
			-- print(CheatSheet.Settings.VisMMAngle)
		end
		VisibleButton.pos = {}
		VisibleButton.IsMoving = false
		VisibleButton:CalcPos(CheatSheet.Settings.core.VisMMRad.VAL, CheatSheet.Settings.core.VisMMAngle.VAL)
		VisibleButton:SetFrameStrata("MEDIUM")
		VisibleButton:SetParent("Minimap")
		VisibleButton:SetSize(20, 20)
		VisibleButton:ClearAllPoints()
		VisibleButton:SetPoint("CENTER", VisibleButton.pos[1], VisibleButton.pos[2])
		VisibleButton:SetMovable(true)
		VisibleButton:EnableMouse(true)
		VisibleButton:RegisterForClicks("LeftButton", "RightButton")
		VisibleButton:RegisterForDrag("LeftButton")
		VisibleButton:Enable()
		
		local VisibleBG = VisibleButton:CreateTexture()
		VisibleBG:SetColorTexture(0.1, 0.1, 0.1, 0.7)
		VisibleBG:SetAllPoints()
		VisibleButton:SetNormalTexture(VisibleBG)
		
		local VisiblePSH = VisibleButton:CreateTexture()
		VisiblePSH:SetColorTexture(0.8, 0.8, 0.8, 0.7)
		VisiblePSH:SetAllPoints()
		VisibleButton:SetPushedTexture(VisiblePSH)
		
		VisibleButton:SetScript("OnMouseUp", function(self, button)
			if button == "LeftButton" then
				CheatSheet:Toggle()
			elseif button == "RightButton" then
				CheatSheet.SettingsFrame:Toggle()
			end
		end)
		VisibleButton:SetScript("OnDragStart", function(self)
			self.IsMoving = true
		end)
		VisibleButton:SetScript("OnDragStop", function(self)
			self.IsMoving = false
		end)
		VisibleButton:SetScript("OnUpdate", function(self)
			if self.IsMoving then
				local x, y = GetCursorPosition()
				local mmX, mmY = Minimap:GetCenter()
				x, y = x / self:GetEffectiveScale() - mmX, y / self:GetEffectiveScale() - mmY
				self:CalcAngle(x, y)
				self:CalcPos(CheatSheet.Settings.core.VisMMRad.VAL, CheatSheet.Settings.core.VisMMAngle.VAL)
				self:ClearAllPoints()
				self:SetPoint("CENTER", self.pos[1], self.pos[2])
			end
		end)
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
	EventFrame:RegisterEvent("ADDON_LOADED")
	EventFrame:RegisterEvent("PLAYER_LOGOUT")

	EventFrame:SetScript("OnEvent", 
	function(self, event, ...)
		arg1, arg2 = ...
		if ZoneEvents[event] then
			OnZoneChange(self, event, ...)
		elseif event == "PLAYER_LOGIN" then
			OnReload(self, event, ...)
		elseif event == "PLAYER_LOGOUT" then
			CheatSheet:SaveSettings()
		elseif event == "ADDON_LOADED" and arg1 == "CheatSheet" then
			CheatSheet:LoadSettings()
			CSHT_CFG_TabL_Frame:Select(1)
		end
	end)
	
end