local ui_get = ui.get
local package_searchpath = package.searchpath
local get_local_player = entity.get_local_player

local function file_exists(filename)
	return package_searchpath("", filename) == filename
end

local function sound_exists(name)
	return file_exists("./csgo/sound/" .. name)
end

local sounds = {
    ["AGP Achievement 1"] = "agpa1.mp3",
    ["AGP Achievement 2"] = "agpa2.mp3",
    ["Aimware"] = "cod.wav",
    ["Fatality"] = "fatality.wav",
    ["Bubble"] = "bubble.wav",
    ["Hentai 1"] = "hentai1.wav",
    ["Hentai 2"] = "hentai2.mp3",
    ["Hentai 3"] = "hentai3.mp3",
    ["osu! combobreak"] = "combobreak.wav",
    ["PUBG Pan"] = "pubg_pan.mp3",
    ["uwu daddy ft. kano"] = "kano.mp3",
}

local sound_names = {}

for k,v in pairs(sounds) do
	if sound_exists(v) then
	  table.insert(sound_names, k)
	end
end

table.sort(sound_names)

if #sound_names <= 0 then
    return error('hitmarker.lua > there is no sounds "\\csgo\\sound"')
end

local enabled_ref = ui.new_checkbox("VISUALS", "Player ESP", "Override hit marker sound")
local sound_ref = ui.new_combobox("VISUALS", "Player ESP", "\n hitsound_override", sound_names)
local sound_vol = ui.new_slider("VISUALS", "Player ESP", "Volume multiplier \n hitsound_vol_multiplier", 1, 50, 10, true, "x", 0.1)

client.set_event_callback("player_hurt", function(e)
    if not ui_get(enabled_ref) or e.attacker == nil then 
        return
    end

    local me = entity.get_local_player()

    local userid = client.userid_to_entindex(e.userid)
    local attacker = client.userid_to_entindex(e.attacker)

    local vol = ui.get(sound_vol) / 10

    for k, v in pairs(sounds) do
        if attacker == me and userid ~= me and k == ui_get(sound_ref) and sound_exists(v) then
            local command = "playvol " .. v .. " "

            if vol <= 1 then
                client.exec(command .. vol)
            else
                local m_vol = math.floor(vol + 0.9)

                for i=1, m_vol do
                    local volume = 1

                    if m_vol ~= vol and i==m_vol then
                        volume = vol-math.floor(vol)
                    end

                    client.exec(command .. volume)
                end
            end

            return
        end
    end
end)
