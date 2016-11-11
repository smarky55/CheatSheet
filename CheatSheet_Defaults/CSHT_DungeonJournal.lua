-- CheatSheat_DungeonJournal: A set of CheatSheet entries based off of the ingame encounter journal
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

CSHT_DJ = {}

CSHT_DJ.NAME = "CSHT_DungeonJournal"

CSHT_DJ.SHEETS = {
						{	TITLE = "Trial of the King",
							ZONE = "Mogu'shan Palace", 
							--SUBZONE = "", 
							NOTE = {"This is a preliminary test note!",
									"You are in Mogu'shan Palace!"}
								}
						}
						
CheatSheet:Register(CSHT_DJ)