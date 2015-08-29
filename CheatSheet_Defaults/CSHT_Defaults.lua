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

CSHT_Defaults = {}

CSHT_Defaults.NAME = "CSHT_Defaults"

CSHT_Defaults.SHEETS = {
							{	TITLE = "Test List",
								ZONE = "Shrine of Seven Stars", 
								SUBZONE = "The Golden Lantern", 
								NOTE = {"-Test note.", 
										"-Additional test note!"
									}
							},
							{	TITLE = "Testing Note",
								ZONE = "Shrine of Seven Stars",
								SUBZONE = "The Emperor's Step",
								NOTE = {"Test Note for the emperor's step"
									}
							},
							{	ZONE = "Shrine of Seven Stars",
								SUBZONE = "The Emperor's Step",
								NOTE = {"A second set of notes."
									}
							},
							{	ZONE = "Shrine of Seven Stars",
								SUBZONE = "The Star's Bazaar",
								NOTE = {"-Another test note",
										"-Or two"
									}
							},
							{	ZONE = "Shrine of Seven Stars",
								SUBZONE = "The Star's Bazaar",
								CLASS = "Death Knight",
								NOTE = {"Class specific note for DK",
									}
							},
						}
CheatSheet:Register(CSHT_Defaults)