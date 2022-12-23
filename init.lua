gender_select = {}

-- The version ID indicating API features.
-- Increase this number on every changes that touched
-- the behaviour of the APIs.
-- Mods can then check the compactibility by comparing
-- this value to the target version.
-- Ideally, all changes should be backward-compactible, so
-- mods should only check for a lower limit of this variable.
gender_select.version = 1

local S = minetest.get_translator("gender_select")
local storage = minetest.get_mod_storage()

local function get_player_object(p)
	if type(p) == "string" then
		return minetest.get_player_by_name(p)
	end
	return p.is_player and p:is_player() and p
end

local function get_player_name(p)
	if type(p) == "string" then	return p end
	return p.is_player and p:is_player() and p:get_player_name()
end

function gender_select.get_gender(player)
	player = get_player_name(player)
	if not player then return false, false end

	local genderMF = storage:get_string(player .. "genderMF")
	local genderN  = (storage:get_int(player .. "genderN") == 1)
	if genderMF ~= "M" and genderMF ~= "F" then
		genderMF = nil
	end
	if genderN or genderMF == nil then return "N", genderMF end
	return genderMF, genderMF
end

function gender_select.get_gender_MF(player)
	local _, genderMF = gender_select.get_gender(player)
	return genderMF
end

function gender_select.set_gender(player,genderMF,neutral)
	if genderMF ~= "M" and genderMF ~= "F" then return false end
	player = get_player_name(player)
	if not player then return false end

	storage:set_string(player .. "genderMF",genderMF)
	if neutral ~= nil then
		storage:set_int(player .. "genderN",neutral and 1 or 0)
	end
	return true
end

if minetest.get_modpath("flow") then
	local gui = flow.widgets
	gender_select.gui = flow.make_gui(function(player, ctx)
		if not ctx.tab then
			ctx.tab = "main"
		end
		print(dump(ctx))
		if ctx.tab == "main" then
			if not(ctx.genderMF) then
				ctx.gender, ctx.genderMF = gender_select.get_gender(player)
				if not ctx.form.genderN then
					ctx.form.genderN = (ctx.gender == "N")
				end
			end
			return gui.VBox {
				w = 7,
				gui.HBox {
					gui.ButtonExit {
						label = "x",
						align_h = "left",
						w = 0.6, h = 0.6,
					},
					gui.Label { label = S("Select Gender") ,expand=true, align_h="centre"},
					gui.Button {
						label = "?",
						align_h = "right",
						w = 0.6, h = 0.6,
					},
				},
				gui.Box{w = 6.5, align_h="centre", h = 0.05, color = "grey"},
				gui.HBox { align_h="centre",
					gui.VBox { expand=true, align_h="left",
						gui.Label { h=1,label = (ctx.genderMF == "M" and minetest.get_color_escape_sequence("#00FF00") ..S("@1\n(Selected)",S("Male")) or S("Male")) ,expand=true, align_h="centre"},
						gui.ImageButton { w=3,h=3,expand=true, align_h="centre",
							texture_name = "gender_select_male.png",
							on_event = function(player,ctx)
								print("BtnM")
								ctx.error = nil
								ctx.genderMF = "M"
								return true
							end,
						},
					},
					gui.VBox { align_h="right",
						gui.Label { h=1,label = (ctx.genderMF == "F" and minetest.get_color_escape_sequence("#00FF00") ..S("@1\n(Selected)",S("Female")) or S("Female")) ,expand=true, align_h="centre"},
						gui.ImageButton { w=3,h=3,expand=true, align_h="centre",
							texture_name = "gender_select_female.png",
							on_event = function(player,ctx)
								print("BtnF")
								ctx.error = nil
								ctx.genderMF = "F"
								return true
							end,
						},
					},
				},
				gui.Checkbox {align_h="centre",
					name = "genderN",
					label = S("Use gender-neutral pronouns"),
				},
				gui.Box{w = 6.5, align_h="centre", h = 0.05, color = "grey", padding = 0.25},
				gui.Button {align_h="centre",
					label = ctx.error and minetest.colorize("#FF00FF",S("ERROR")) or S("Confirm"),
					on_event = function(player,ctx)
						if ctx.genderMF ~= "M" and ctx.genderMF ~= "F" then
							ctx.error = true
							return true -- Force a redraw
						end
						gender_select.set_gender(player,ctx.genderMF,ctx.form.genderN and true or false)
						minetest.chat_send_player(player:get_player_name(),S("Gender set."))
						gender_select.gui:close(player)
					end,
				}
			}
		end
	end)

	function gender_select.open_gender_dialog(player)
		player = get_player_object(player)
		if not player then return false, "OFFLINE" end
		gender_select.gui:show(player)
		return true
	end

	minetest.register_chatcommand("gender",{
		description = S("Set the gender and the preferred pronoun"),
		func = function(name,param)
			gender_select.gui:show(name)
			return true, S("Dialog shown.")
		end
	})
else
	function gender_select.open_gender_dialog()
		return false, "DEPENDENCY"
	end
end

local function get_gender_string(g)
	if g == "M" then
		return S("Male")
	elseif g == "F" then
		return S("Female")
	else
		return "ERROR"
	end
end

minetest.register_chatcommand("get_gender",{
	description = S("Get the gender information of a player"),
	privs = {basic_privs = true},
	func = function(name,param)
		local gender, genderMF = gender_select.get_gender(name)
		if not gender then
			return false, S("Could not find the gender of @1.",param)
		end
		local genderSTR = get_gender_string(genderMF)
		if gender == "N" then
			return true, S("@1 prefer gender-neutral pronouns, and @2 as a fallback.",param,genderSTR)
		else
			return true, S("@1's gender is @2.",param,genderSTR)
		end
	end
})
