-- Create a textclock widget
local beautiful = require("beautiful")
local awful = require("awful")
beautiful.tooltip_bg_color = "#333333"
beautiful.tooltip_fg_color = "#ffffff"
beautiful.tooltip_border_color = "#333333"
beautiful.tooltip_border_width = 3
mytextclock = awful.widget.textclock()
textclock_tip = awful.tooltip ({
    objects = { mytextclock },
    timeout = 1,
    timer_function = function ()
        local cal = io.popen ("cal"):read ("*all")
        local current = io.popen ("date | awk '{ print $3 }'"):read ("*n")
        cal = string.gsub (cal, "([^0-9])" .. current .. "([^0-9])", "%1<span background=\"#aaff00\" color=\"#0000ff\">" .. current .."</span>%2", 1)
        return '<span font="monospace 9">' .. cal .. '</span>'
    end
});

