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
						},
						
				-- Court of Stars
						{ 	TITLE = "Patrol Captain Gerdo: Tank",
							ZONE = "Court of Stars",
							SUBZONE = "The Guilded Market",
							ROLE = "TANK",
							NOTE = {"Jump to free yourself from [Arcane Lockdown].",
							"Gain threat on additional Nightwatch Reinforcements when Patrol Captain Gerdo uses [Signal Beacon]."}
						},
						{ 	TITLE = "Patrol Captain Gerdo: Healer",
							ZONE = "Court of Stars",
							SUBZONE = "The Guilded Market",
							ROLE = "HEALER",
							NOTE = {"Jump to free yourself from [Arcane Lockdown].",
							"Be careful when Gerdo drinks his [Flask of the Solemn Night], as he will inflict substantially more damage."}
						},
						{ 	TITLE = "Patrol Captain Gerdo: Damage Dealers",
							ZONE = "Court of Stars",
							SUBZONE = "The Guilded Market",
							ROLE = "DAMAGER",
							NOTE = {"Jump to free yourself from [Arcane Lockdown].",
							"Quickly defeat Nightwatch Reinforcements when [Signal Beacon] occurs to prevent them from overwhelming the party."}
						},
						{ 	TITLE = "Talixae Flamewreath: Tank",
							ZONE = "Court of Stars",
							SUBZONE = "Midnight Court",
							ROLE = "TANK",
							NOTE = {"Beware that [Burning Intensity] can inflict more and more damage as the fight continues.",
							"Interrupt [Withering Soul] when possible to prevent it from stacking too much."}
						},
						{ 	TITLE = "Talixae Flamewreath: Healer",
							ZONE = "Court of Stars",
							SUBZONE = "Midnight Court",
							ROLE = "HEALER",
							NOTE = {"Dispel [Withering Soul] from allies before it stacks too much.",
							"Beware that [Burning Intensity] can inflict more and more damage as the fight continues."}
						},
						{ 	TITLE = "Talixae Flamewreath: Damage Dealers",
							ZONE = "Court of Stars",
							SUBZONE = "Midnight Court",
							ROLE = "DAMAGER",
							NOTE = {"Move out of [Infernal Eruption] to avoid being blasted into the air.",
							"Interrupt [Withering Soul] when possible to prevent it from stacking too much."}
						},
						{ 	TITLE = "Advisor Melandrus: Tank",
							ZONE = "Court of Stars",
							SUBZONE = "The Jeweled Estate",
							ROLE = "TANK",
							NOTE = {"Spread out to avoid getting multiple party members hit by [Blade Surge] at the same time.",
							"Keep an eye on the direction that the images of Melandrus are facing to predict the path of [Piercing Gale]"}
						},
						{ 	TITLE = "Advisor Melandrus: Healer",
							ZONE = "Court of Stars",
							SUBZONE = "The Jeweled Estate",
							ROLE = "HEALER",
							NOTE = {"Spread out to avoid getting multiple party members hit by [Blade Surge] at the same time.",
							"[Slicing Maelstrom] inflicts increasing damage as the fight progresses."}
						},
						{ 	TITLE = "Advisor Melandrus: Damage Dealers",
							ZONE = "Court of Stars",
							SUBZONE = "The Jeweled Estate",
							ROLE = "DAMAGER",
							NOTE = {"Spread out to avoid getting multiple party members hit by [Blade Surge] at the same time.",
							"Keep an eye on the direction that the images of Melandrus are facing to predict the path of [Piercing Gale]"}
						},
						
				-- Darkheart Thicket
						{ 	TITLE = "Archdruid Glaidalis: Tank",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Sanctum of G'hanir",
							ROLE = "TANK",
							NOTE = {"Position Archdruid Glaidalis so that [Primal Rampage] does not run over other players."}
						},
						{ 	TITLE = "Archdruid Glaidalis: Healer",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Sanctum of G'hanir",
							ROLE = "HEALER",
							NOTE = {"Avoid being in front of Archdruid Glaidalis when he is casting [Primal Rampage].",
							"Quickly heal targets affected by [Grevious Tear] to above 90% of their maximum health."}
						},
						{ 	TITLE = "Archdruid Glaidalis: Damage Dealers",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Sanctum of G'hanir",
							ROLE = "DAMGAER",
							NOTE = {"Avoid being in front of Archdruid Glaidalis when he is casting [Primal Rampage]."}
						},
						{ 	TITLE = "Oakheart: Tank",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Miasmic Gorge",
							ROLE = "TANK",
							NOTE = {"Face Oakheart away from allies so allies are not hit by [Nightmare Breath].",
							"[Crushing Grip] deals significant damage."}
						},
						{ 	TITLE = "Oakheart: Healer",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Miasmic Gorge",
							ROLE = "HEALER",
							NOTE = {"Avoid being in front of Oakheart when he is casting [Nightmare Breath].",
							"[Crushing Grip] deals significant damage."}
						},
						{ 	TITLE = "Oakheart: Damage Dealers",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Miasmic Gorge",
							ROLE = "HEALER",
							NOTE = {"Avoid being in front of Oakheart when he is casting [Nightmare Breath]."}
						},
						{ 	TITLE = "Dresaron",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Tainted Burrow",
							-- ROLE = "",
							NOTE = {"Dresaron will use [Down Draft] to push players back.",
							"Avoid disturbing the Nightmare Eggs and triggering [Hatch Welpling]."}
						},
						{ 	TITLE = "Shade of Xavius",
							ZONE = "Darkheart Thicket",
							SUBZONE = "Heart of Dread",
							-- ROLE = "",
							NOTE = {"If affected by [induced Paranoia], stay away from other players to keep them from taking damage and being feared.",
							"At 50% health, the Shade of Xavius casts [Apocalyptic Nightmare] in an attempt to burn Shaladrassil down around him."}
						},
}						
CheatSheet:Register(CSHT_DJ)
						-- { 	TITLE = "",
							-- ZONE = "",
							-- SUBZONE = "",
							-- ROLE = "",
							-- NOTE = {""}
						-- },
						