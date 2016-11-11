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
						},
						
			-- Legion Dungeons
			-- Black Rook Hold
						{	TITLE = "The Amalgam of Souls: Tank",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Grand Sepulcher",
							ROLE = "TANK",
							NOTE = {"Move out of the way of [Reap Soul] to avoid heavy damage."}
						},
						{ 	TITLE = "The Amalgam of Souls: Healer",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Grand Sepulcher",
							ROLE = "HEALER",
							NOTE = {"Keep moving and avoid other players while afflicted with [Soul Echoes].",
							"When Targeted by [Swirling Scythe] or [Glaive Toss], move to avoid placing it in an inconvenient location.",
							"[Reap Soul] will deal high damage to the tank if it hits."}
						},
						{ 	TITLE = "The Amalgam of Souls: Damage Dealers",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Grand Sepulcher",
							ROLE = "DAMAGER",
							NOTE = {"Keep moving and avoid other players while afflicted with [Soul Echoes].",
							"When Targeted by [Swirling Scythe] or [Glaive Toss], move to avoid placing it in an inconvenient location."}
						},
						{ 	TITLE = "Illysanna Ravencrest: Tank",
							ZONE = "Black Rook Hold",
							SUBZONE = "Ravenswatch",
							ROLE = "TANK",
							NOTE = {"Use Active Mitigation fo [Vengeful Shear] to reduce damage and avoid the damage taken debuff.",
							"Avoid Risen Vanguard's [Bonecrushing Spike]"}
						},
						{ 	TITLE = "Illysanna Ravencrest: Healer",
							ZONE = "Black Rook Hold",
							SUBZONE = "Ravenswatch",
							ROLE = "HEALER",
							NOTE = {"Players targeted by [Dark Rush] should gather together to minimize the amount of [Felblazed Ground].",
							"Otherwise, players should spread to avoid [Brutal Glaive] bouncing to them.",
							"[Vengeful Shear] deals heavy damage to tanks."}
						},
						{ 	TITLE = "Illysanna Ravencrest: Damage Dealers",
							ZONE = "Black Rook Hold",
							SUBZONE = "Ravenswatch",
							ROLE = "DAMAGER",
							NOTE = {"Players targeted by [Dark Rush] should gather together to minimize the amount of [Felblazed Ground].",
							"Otherwise, players should spread to avoid [Brutal Glaive] bouncing to them.",
							"Interrupt Risen Arcanists' [Arcane Blitz]"}
						},
						{ 	TITLE = "Smashspite the Hateful: Tank",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Rook's Roost",
							ROLE = "TANK",
							NOTE = {"Minimize damage taken by Smashspite's melee attacks to slow the rate at which his [Brutality] bar fills.",
							"When Smashspite's Brutality bar fills, he will use [Brutal Haymaker], inflicting heavy damage and increasing damage taken for a short time.",
							"Stand between Smashspite and his target to intercept [Hateful Charge] if they have the debuff from intercepting an earlier charge and you don't."}
						},
						{ 	TITLE = "Smashspite the Hateful: Healer",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Rook's Roost",
							ROLE = "HEALER",
							NOTE = {"[Earthshaking Stomp] inflicts heavy damage to the party.",
							"When Smashspite's Brutality bar fills, he will use [Brutal Haymaker] on the tank, inflicting heavy damage and increasing damage taken for a short time.",
							"Stand between Smashspite and his target to intercept [Hateful Charge] if they have the debuff from intercepting an earlier charge and you don't."}
						},
						{ 	TITLE = "Smashspite the Hateful: Damage Dealers",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Rook's Roost",
							ROLE = "DAMAGER",
							NOTE = {"Stand between Smashspite and his target to intercept [Hateful Charge] if they have the debuff from intercepting an earlier charge and you don't."}
						},
						{ 	TITLE = "Lord Kur'talos Ravencrest: Tank",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Raven's Crown",
							ROLE = "TANK",
							NOTE = {"[Unerring Shear] will deal heavy damage.",
							"Kill [Stinging Swarms] to avoid damage and being stunned by [Itchy!].",
							"Move in a circular pattern to avoid Dantalionax's casts of [Dark Obliteration] after he splits when using [Dreadlords's Guile]."}
						},
						{ 	TITLE = "Lord Kur'talos Ravencrest: Healer",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Raven's Crown",
							ROLE = "HEALER",
							NOTE = {"[Unerring Shear] will deal heavy damage to the tank.",
							"Dispel [Cloud of Hypnosis].",
							"Move in a circular pattern to avoid Dantalionax's casts of [Dark Obliteration] after he splits when using [Dreadlords's Guile]."}
						},
						{ 	TITLE = "Lord Kur'talos Ravencrest: Damage Dealers",
							ZONE = "Black Rook Hold",
							SUBZONE = "The Raven's Crown",
							ROLE = "DAMAGER",
							NOTE = {"Kill [Stinging Swarms] to avoid damage and being stunned by [Itchy!].",
							"Move in a circular pattern to avoid Dantalionax's casts of [Dark Obliteration] after he splits when using [Dreadlords's Guile]."}
						}

}						
CheatSheet:Register(CSHT_DJ)