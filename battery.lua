local wibox = require("wibox")
bat_widget_text = wibox.widget.textbox()    
bat_widget = wibox.widget.background ()
bat_widget:set_widget (bat_widget_text)

bat_widget.refresh = function()    
    local fh = io.popen ("acpi")
    local output = fh:read ("*all")
    local state, value, time = string.match (output, "^[^:]+: ([^,]+), (%d+)%%, (%d+:%d+):")
    
    if value == nil then
        value = "100"
        state = "Full"
        time = ""
    end
    local wtext = ""
    if state == "Charging" then
        bat_widget:set_bg ("#0000dd")
        bat_widget:set_fg ("#ffffff")
    elseif state == "Full" then
        bat_widget:set_bg ("#333333")
    elseif tonumber (value) < 12 then
        bat_widget:set_bg ("#dd0000")
        bat_widget:set_fg ("#ffffff")
    elseif tonumber (value) < 20 then
        bat_widget:set_bg ("#ffa500")
        bat_widget:set_fg ("#0000dd")
    else
        bat_widget:set_bg ("#333333")
        bat_widget:set_fg ("#ffffff")
    end
    wtext = value .. "% " .. time
    bat_widget_text:set_text(wtext)    
    fh:close()    
end    

bat_widgettimer = timer ({ timeout = 5 })    
bat_widgettimer:connect_signal ("timeout", bat_widget.refresh)
bat_widgettimer:start ()
bat_widget.refresh ()
