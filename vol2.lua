local wibox = require("wibox")
local awful = require("awful")

function update_volume (widget)
    local fd = io.popen ("amixer sget Master")
    local status = fd:read ("*all")
    fd:close ()
    local volume = tonumber (string.match (status, "%d?%d?%d)%%")) / 100
    status = string.match(status, "%[(o[^%]]*)%]")
    widget:set_markup (volume)
end

volume_widget = wibox.widget.textbox()
volume_widget:set_align("right")

update_volume(volume_widget)

mytimer = timer({ timeout = 1 })
mytimer:connect_signal("timeout", function () update_volume(volume_widget) end)
mytimer:start()

