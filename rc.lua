local awesome, client, mouse, screen, tag = awesome, client, mouse, screen, tag
local ipairs, string, os, table, tostring, tonumber, type = ipairs, string, os, table, tostring, tonumber, type

local gears         = require("gears")
local awful         = require("awful")
                      require("awful.autofocus")
local wibox         = require("wibox")
local beautiful     = require("beautiful")
local naughty       = require("naughty")
local lain          = require("lain")
--local menubar       = require("menubar")
local freedesktop   = require("freedesktop")
local hotkeys_popup = require("awful.hotkeys_popup").widget
--                      require("awful.hotkeys_popup.keys")
local my_table      = awful.util.table or gears.table -- 4.{0,1} compatibility
local dpi           = require("beautiful.xresources").apply_dpi
-- }}}

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- {{{ Autostart windowless processes

-- This function will run once every time Awesome is started
local function run_once(cmd_arr)
    for _, cmd in ipairs(cmd_arr) do
        awful.spawn.with_shell(string.format("pgrep -u $USER -fx '%s' > /dev/null || (%s)", cmd, cmd))
    end
end

--run_once({ "termite", "unclutter -root" }) -- entries must be separated by commas
run_once({ "unclutter -root" }) -- entries must be separated by commas

-- {{{ Variable definitions

local themes = {
    "batcat",          -- 1
    "copland",         -- 2
    "holo",            -- 3
    "multicolor",      -- 4
    "power",           -- 5
    "powerarrow",      -- 6
  }

-- choose your theme here
local chosen_theme = themes[6]


local theme_path = string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme)
beautiful.init(theme_path)

-- modkey or mod4 = super key
local modkey       = "Mod4"
local altkey       = "Mod1"
local modkey1      = "Control"

-- personal variables
--change these variables if you want
local browser           = "firefox"
local editor            = os.getenv("EDITOR") or "vim"
local editorgui         = "atom"
local filemanager       = "thunar"
local mailclient        = "thunderbird"
local mediaplayer       = "vlc"
--local scrlocker         = "slimlock"
local terminal          = "alacritty"
--local virtualmachine    = "virtualbox"

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = {  "1", "2", "3", "4", "5", "6", "7"}
--awful.util.tagnames = {  "➊", "➋", "➌", "➍", "➎", "➏", "➐"}
--awful.util.tagnames = {"⠐ "," ⠡ "," ⠲ "," ⠵ "," ⠻"," ⠿ "," ⠲⠵ "}
--awful.util.tagnames = { "⌘", "♐", "⌥", "ℵ" }
--awful.util.tagnames = { " DEV ", " WWW ", " SYS ", " DOC ", " VBOX ", " CHAT ", " MEDIA "}
-- Use this : https://fontawesome.com/cheatsheet
awful.layout.suit.tile.left.mirror = true
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.max,
    awful.layout.suit.floating,
    --awful.layout.suit.tile.left,
    --awful.layout.suit.tile.bottom,
    --awful.layout.suit.tile.top,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max.fullscreen,
    --awful.layout.suit.magnifier,
    --awful.layout.suit.corner.nw,
    --awful.layout.suit.corner.ne,
    --awful.layout.suit.corner.sw,
    --awful.layout.suit.corner.se,
    --lain.layout.cascade,
    --lain.layout.cascade.tile,
    --lain.layout.centerwork,
    --lain.layout.centerwork.horizontal,
    --lain.layout.termfair,
    --lain.layout.termfair.center,
}

awful.util.taglist_buttons = my_table.join(
    awful.button({ }, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)

        end
    end),
    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({ }, 1, function (c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", {raise = true})
        end
    end),
    awful.button({ }, 3, function ()
        local instance = nil

        return function ()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({theme = {width = 250}})
            end
        end
    end),
    awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
    awful.button({ }, 5, function () awful.client.focus.byidx(-1) end)
)

lain.layout.termfair.nmaster           = 3
lain.layout.termfair.ncol              = 1
lain.layout.termfair.center.nmaster    = 3
lain.layout.termfair.center.ncol       = 1
lain.layout.cascade.tile.offset_x      = 2
lain.layout.cascade.tile.offset_y      = 32
lain.layout.cascade.tile.extra_padding = 5
lain.layout.cascade.tile.nmaster       = 5
lain.layout.cascade.tile.ncol          = 2

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/theme.lua", chosen_theme))
-- }}}



-- {{{ Menu
local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", terminal .. " -e 'nano /home/wietsedejong/.config/awesome/rc.lua'" },
    { "arandr", "arandr" },
    { "restart", awesome.restart },
}

awful.util.mymainmenu = freedesktop.menu.build({
    icon_size = beautiful.menu_height or 16,
    before = {
        { "Awesome", myawesomemenu, beautiful.awesome_icon },
        --{ "Atom", "atom" },
        -- other triads can be put here
    },
    after = {
	--   { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Exit", "systemctl poweroff" },
        -- other triads can be put here
    }
})
--menubar.utils.terminal = terminal -- Set the Menubar terminal for applications that require it
-- }}}

--Launcher
 mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = awful.util.mymainmenu })


-- {{{ Screen
-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", function(s)
    -- Wallpaper
    if beautiful.wallpaper then
        local wallpaper = beautiful.wallpaper
        -- If wallpaper is a function, call it with the screen
        if type(wallpaper) == "function" then
            wallpaper = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end)
-- Create a wibox for each screen and add it
awful.screen.connect_for_each_screen(function(s) beautiful.at_screen_connect(s) end)
-- }}}



-- {{{ Mouse bindings
root.buttons(my_table.join(
    awful.button({ }, 3, function () awful.util.mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = my_table.join(

    -- {{{ Personal keybindings
    -- dmenu
    awful.key({ altkey,  }, "Return",
    function ()
     awful.spawn(string.format("dmenu_run -i  -nb '#292d3e' -nf '#bbc5ff' -sb '#82AAFF' -sf '#292d3e' -fn 'Mononoki Nerd Font:bold:pixelsize=14'",
    --   awful.spawn(string.format("rofi",
             beautiful.bg_normal, beautiful.fg_normal, beautiful.bg_focus, beautiful.fg_focus))
	end,
    {description = "show dmenu", group = "Basic"}),

    -- My applications (Super+Alt+Key)
  awful.key({ modkey, altkey  }, "b", function () awful.util.spawn( "firefox" ) end,
        {description = "Browser - Firefox" , group = "apps" }),
  awful.key({ modkey, altkey }, "e", function () awful.util.spawn( "mailspring" ) end,
        {description = "Email - Mailspring" , group = "apps" }),
  awful.key({ modkey, altkey  }, "a", function () awful.util.spawn( "atom" ) end,
        {description = "Atom code" , group = "apps" }),
  awful.key({ modkey, altkey }, "k", function () awful.util.spawn( "keepassxc" ) end,
       {description = "keepassxc" , group = "apps" }),
  awful.key({ modkey, altkey }, "s", function () awful.util.spawn( "spotify" ) end,
            {description = "spotify" , group = "apps" }),
  awful.key({ modkey, altkey }, "z", function () awful.util.spawn( "zoom" ) end,
                 {description = "zoom" , group = "apps" }),
  awful.key({ modkey, altkey }, "f", function () awful.util.spawn( "pcmanfm" ) end,
                                {description = "Files - pcmanfm" , group = "apps" }),

awful.key({ modkey, altkey }, "1", function () awful.util.spawn( "alacritty -e htop" ) end,
                                {description = "Htop" , group = "terminal - apps" }),
awful.key({ modkey, altkey }, "2", function () awful.util.spawn( "alacritty -e ranger" ) end,
                                {description = "Ranger" , group = "terminal - apps" }),
awful.key({ modkey, altkey }, "3", function () awful.util.spawn( "alacritty -e pulsemixer" ) end,
                                {description = "Volumme control - Pulsemixer" , group = "terminal - apps" }),
awful.key({ modkey, altkey }, "4", function () awful.util.spawn( "alacritty -e neomutt" ) end,
                               {description = "Email - Neomutt" , group = "terminal - apps" }),

    -- Hotkeys Awesome
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
        {description = "show help", group="Basic"}),
    awful.key({ modkey,           }, "w", function () awful.util.mymainmenu:show() end,
                      {description = "show main menu", group = "Basic"}),
    awful.key({ modkey }, "x",  function () awful.util.spawn( "arcolinux-logout" ) end,
                        {description = "exit", group = "Basic"}),
    awful.key({ modkey, "Shift" }, "x",  function () awful.util.spawn( "systemctl poweroff" ) end,
                                            {description = "shutdown", group = "Basic"}),
    awful.key({ modkey }, "Escape", function () awful.util.spawn( "xkill" ) end,
                            {description = "Kill proces", group = "Basic"}),

  -- Show/Hide Wibox
    awful.key({ modkey }, "b", function ()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
                          end
                        end
                      end,
    {description = "toggle wibox", group = "Basic"}),

    -- Tag browsing with modkey
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
        {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
        {description = "view next", group = "tag"}),

     -- Tag browsing alt + tab
    awful.key({ altkey,           }, "Tab",   awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({ altkey, modkey1  }, "Tab",  awful.tag.viewprev,
        {description = "view previous", group = "tag"}),

     -- Tag browsing modkey + tab
    awful.key({ modkey,           }, "Tab",   awful.tag.viewnext,
        {description = "view next", group = "tag"}),
    awful.key({ modkey, modkey1   }, "Tab",  awful.tag.viewprev,
        {description = "view previous", group = "tag"}),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus down", group = "client"}),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus up", group = "client"}),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus left", group = "client"}),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        {description = "focus right", group = "client"}),

-- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
   awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey,      }, ",", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey,      }, ".", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),

-- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = terminal, group = "Basic"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, modkey1   }, "l",     function () awful.tag.incmwfact( 0.05)          end,
              {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey, modkey1  }, "h",     function () awful.tag.incmwfact(-0.05)          end,
              {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey, modkey1}, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey,  }, "space",  awful.client.floating.toggle                     ,
                        {description = "toggle floating", group = "layout"}),
    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),


-- Mod+ Shift +Left/Right: move client to prev/next tag and switch to it
              awful.key({ modkey, "Shift" }, "Left",
                  function ()
                      -- get current tag
                      local t = client.focus and client.focus.first_tag or nil
                      if t == nil then
                          return
                      end
                      -- get previous tag (modulo 9 excluding 0 to wrap from 1 to 9)
                      local tag = client.focus.screen.tags[(t.name - 2) % 7 + 1]
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
                      local tag = client.focus.screen.tags[(t.name % 7) + 1]
                      awful.client.movetotag(tag)
                      awful.tag.viewnext()
                  end,
                      {description = "move client to next tag and switch to it", group = "layout"}),


-- ALSA volume control
    --awful.key({ modkey1 }, "Up",
    awful.key({ }, "XF86AudioRaiseVolume",
        function ()
            os.execute(string.format("amixer -q set %s 2%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    --awful.key({ modkey1 }, "Down",
    awful.key({ }, "XF86AudioLowerVolume",
        function ()
            os.execute(string.format("amixer -q set %s 2%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({ }, "XF86AudioMute",
        function ()
            os.execute(string.format("amixer -q set %s toggle", beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end)
)

clientkeys = my_table.join(
    awful.key({ modkey, "Control" }, "m",      lain.util.magnify_client,
              {description = "magnify client", group = "client"}),
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "Basic"}),
    awful.key({ modkey,  }, "q",      function (c) c:kill()                         end,
              {description = "close", group = "apps"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "screen"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "maximize", group = "client"})
)



-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = {description = "view tag #", group = "tag"}
        descr_toggle = {description = "toggle tag #", group = "tag"}
        descr_move = {description = "move focused client to tag #", group = "tag"}
        descr_toggle_focus = {description = "toggle focused client on tag #", group = "tag"}
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  descr_view),
        -- Toggle tag display.
  --      awful.key({ modkey, "Control" }, "#" .. i + 9,
  --                function ()
  --                    local screen = awful.screen.focused()
  --                    local tag = screen.tags[i]
  --                    if tag then
  --                       awful.tag.viewtoggle(tag)
  --                    end
  --                end,
  --                descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  descr_move)
        -- Toggle tag on focused client.
--        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
--                  function ()
--                      if client.focus then
--                          local tag = client.focus.screen.tags[i]
--                          if tag then
--                              client.focus:toggle_tag(tag)
--                          end
--                      end
--                  end,
--                  descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                    focus = awful.client.focus.filter,

                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen,
                     size_hints_honor = false
     }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
      properties = { titlebars_enabled = false } },

    -- Set applications to always map on the tag 1 on screen 1.
    -- find class or role via xprop command

    --{ rule = { class = "Firefox" },
    --  properties = { tag = awful.util.tagnames[1] , focus=true}},

    --  { rule = { class = "termite" },
    --    properties = { tag = awful.util.tagnames[4] , focus=true}},

    --{ rule = { class = "Atom" },
    --    properties = { screen = 1, tag = awful.util.tagnames[3], }},

    --{ rule = { class = "Geary" },
    --    properties = { screen = 1, tag = awful.util.tagnames[2],}},


    -- Set applications to be maximized at
    -- find class or role via xprop command

    --{ rule = { class = "atom" },
    --      properties = { maximized = true } },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Keepassxc",
          "Galculator",
          "Zoom",
          "MessageWin",  -- kalarm.
          "Skype",
          "Zoom",
          "Wpa_gui"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
          "Preferences",
          "setup",
        }
      }, properties = { floating = true }},

}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- Custom
    if beautiful.titlebar_fun then
        beautiful.titlebar_fun(c)
        return
    end

    -- Default
    -- buttons for the titlebar
    local buttons = my_table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, {size = 21}) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = true})
end)

-- No border for maximized clients
function border_adjust(c)
    if c.maximized then -- no borders if only 1 client visible
        c.border_width = 0
    elseif #awful.screen.focused().clients > 1 then
        c.border_width = beautiful.border_width
        c.border_color = beautiful.border_focus
    end
end

client.connect_signal("focus", border_adjust)
client.connect_signal("property::maximized", border_adjust)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)


-- }}}

-- Autostart applications
awful.spawn.with_shell("~/.config/awesome/autostart.sh")
awful.spawn.with_shell("picom -b --config  $HOME/.config/awesome/picom.conf")
--awful.spawn.with_shell("compton --config  $HOME/.config/compton/compton.conf")
-- use picom or compton
