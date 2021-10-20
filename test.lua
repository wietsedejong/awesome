


local updates = wibox.widget.textbox(awful.spawn.with_shell("~/.config/aweome/scripts/scripts/pacupdate.sh"))

-- Mod+ Shift +Left/Right: move client to prev/next tag and switch to it
awful.key({ modkey, "Shift" }, "Left",
    function ()
        -- get current tag
        local t = client.focus and client.focus.first_tag or nil
        if t == nil then
            return
        end
        -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
        local tag = client.focus.screen.tags[(t.name - 2) % 9 + 1]
        awful.client.movetotag(tag)
        awful.tag.viewprev()
    end,
        {description = "move client to previous tag and switch to it", group = "layout"}),
awful.key({ modkey, "Shift" }, "Right",
    function ()
        -- get current tag
        local t = client.focus and client.focus.first_tag or nil
        if t == nil then
            return
        end
        -- get next tag (modulo 9 excluding 0 to wrap from 9 to 1)
        local tag = client.focus.screen.tags[(t.name % 9) + 1]
        awful.client.movetotag(tag)
        awful.tag.viewnext()
    end,
        {description = "move client to next tag and switch to it", group = "layout"}),
