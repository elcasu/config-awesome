local wibox = require("wibox")
local awful = require("awful")

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()

    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100
    -- volume = string.format("% 3d", volume)

    status = string.match(status, "%[(o[^%]]*)%]")

    -- starting colour
    -- local sr, sg, sb = 0x3F, 0x3F, 0x3F
    local sr, sg, sb = 0xDC, 0xDC, 0xDC
    -- ending colour
    -- local er, eg, eb = 0xDC, 0xDC, 0xCC
    local er, eg, eb = 0x00, 0xDC, 0x00

    local ir = volume * (er - sr) + sr
    local ig = volume * (eg - sg) + sg
    local ib = volume * (eb - sb) + sb
    interpol_colour = string.format("%.2x%.2x%.2x", ir, ig, ib)
    if string.find(status, "on", 1, true) then
        volume = " <span background='#" .. interpol_colour .. "' color='#00d'> " .. volume * 100 .. "% </span>"
    else
        volume = " <span color='red' background='#" .. interpol_colour .. "'> M </span>"
    end
    widget:set_markup(volume)
end

volume_widget:buttons (awful.util.table.join (
    awful.button({ }, 4, function () awful.util.spawn("amixer -c 0 set Master 1+ unmute") end),
    awful.button({ }, 5, function () awful.util.spawn("amixer -c 0 set Master 1-") end),
    awful.button({ }, 1, function () awful.util.spawn("amixer -c 0 set Master toggle") end)
))

update_volume(volume_widget)

mytimer = timer({ timeout = 0.5 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()
