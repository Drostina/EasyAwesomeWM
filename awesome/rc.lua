local awesome, client, screen = awesome, client, screen
local string, os, tostring, type = string, os, tostring, type

-- Standard awesome library
local gears = require("gears") --Utilities such as color parsing and objects
local awful = require("awful") --Everything related to window managment
-- Widget and layout library
local wibox = require("wibox")

-- Theme handling library
local beautiful = require("beautiful")

-- Notification library
local naughty = require("naughty")
naughty.config.defaults['icon_size'] = 75

local lain        = require("lain")
local freedesktop = require("freedesktop")
local settings    = require("settings")

-- Enable hotkeys help widget for VIM and other apps
-- when client with a matching name is opened:
local hotkeys_popup = require("awful.hotkeys_popup").widget
require("awful.hotkeys_popup.keys")
local my_table = awful.util.table or gears.table -- 4.{0,1} compatibility

if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = tostring(err) })
        in_error = false
    end)
end


local modkey  = "Mod4"
local altkey  = "Mod1"
local modkey1 = "Control"

-- personal variables
local terminal   = "alacritty"
local editor     = os.getenv("EDITOR") or "nano"
local editor_tui = terminal .. " -e " .. editor

-- awesome variables
awful.util.terminal = terminal
awful.util.tagnames = { " Main ", " Gaming ", " Music ", " Social ", " Dev " }
awful.layout.suit.tile.left.mirror = true

awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.floating,
    --awful.layout.suit.fair,
    --awful.layout.suit.fair.horizontal,
    --awful.layout.suit.spiral,
    --awful.layout.suit.spiral.dwindle,
    --awful.layout.suit.max,
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
    awful.button({}, 1, function(t) t:view_only() end),
    awful.button({ modkey }, 1, function(t)
        if client.focus then
            client.focus:move_to_tag(t)
        end
    end),
    awful.button({}, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, function(t)
        if client.focus then
            client.focus:toggle_tag(t)
        end
    end),
    awful.button({}, 4, function(t) awful.tag.viewnext(t.screen) end),
    awful.button({}, 5, function(t) awful.tag.viewprev(t.screen) end)
)

awful.util.tasklist_buttons = my_table.join(
    awful.button({}, 1, function(c)
        if c == client.focus then
            c.minimized = true
        else
            c:emit_signal("request::activate", "tasklist", { raise = true })
        end
    end),
    awful.button({}, 3, function()
        local instance = nil

        return function()
            if instance and instance.wibox.visible then
                instance:hide()
                instance = nil
            else
                instance = awful.menu.clients({ theme = { width = 250 } })
            end
        end
    end),
    awful.button({}, 4, function() awful.client.focus.byidx(1) end),
    awful.button({}, 5, function() awful.client.focus.byidx(-1) end)
)

beautiful.init(string.format(gears.filesystem.get_configuration_dir() .. "/themes/%s/%s.lua", settings.chosen_theme,
    settings.chosen_theme))

local myawesomemenu = {
    { "hotkeys", function() return false, hotkeys_popup.show_help end },
    { "manual", terminal .. " -e 'man awesome'" },
    { "edit config", editor_tui .. " " .. awesome.conffile },
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
        { "Terminal", terminal },
        { "Log out", function() awesome.quit() end },
        { "Sleep", "systemctl suspend" },
        { "Restart", "systemctl reboot" },
        { "Shutdown", "systemctl poweroff" },
        -- other triads can be put here
    }
})

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

root.buttons(my_table.join(
    awful.button({}, 3, function() awful.util.mymainmenu:toggle() end),
    awful.button({}, 4, awful.tag.viewnext),
    awful.button({}, 5, awful.tag.viewprev)
))

globalkeys = my_table.join(

-- Hotkeys Awesome

    awful.key({ modkey, }, "s", hotkeys_popup.show_help,
        { description = "show help", group = "awesome" }),

    -- Tag browsing with modkey
    awful.key({ modkey, }, "Left", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),
    awful.key({ modkey, }, "Right", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ altkey, }, "Escape", awful.tag.history.restore,
        { description = "go back", group = "tag" }),

    -- Tag browsing alt + tab
    awful.key({ altkey, }, "Tab", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ altkey, "Shift" }, "Tab", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),

    -- Tag browsing modkey + tab
    awful.key({ modkey, }, "Tab", awful.tag.viewnext,
        { description = "view next", group = "tag" }),
    awful.key({ modkey, "Shift" }, "Tab", awful.tag.viewprev,
        { description = "view previous", group = "tag" }),


    -- Default client focus
    awful.key({ altkey, }, "j",
        function()
            awful.client.focus.byidx(1)
        end,
        { description = "focus next by index", group = "client" }
    ),
    awful.key({ altkey, }, "k",
        function()
            awful.client.focus.byidx(-1)
        end,
        { description = "focus previous by index", group = "client" }
    ),

    -- By direction client focus
    awful.key({ modkey }, "j",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    awful.key({ modkey }, "k",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey }, "h",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey }, "l",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }),


    -- By direction client focus with arrows
    awful.key({ modkey1, modkey }, "Down",
        function()
            awful.client.focus.global_bydirection("down")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus down", group = "client" }),
    awful.key({ modkey1, modkey }, "Up",
        function()
            awful.client.focus.global_bydirection("up")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus up", group = "client" }),
    awful.key({ modkey1, modkey }, "Left",
        function()
            awful.client.focus.global_bydirection("left")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus left", group = "client" }),
    awful.key({ modkey1, modkey }, "Right",
        function()
            awful.client.focus.global_bydirection("right")
            if client.focus then client.focus:raise() end
        end,
        { description = "focus right", group = "client" }),



    awful.key({ modkey, }, "w", function() awful.util.mymainmenu:show() end,
        { description = "show main menu", group = "awesome" }),

    -- Layout manipulation
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx(1) end,
        { description = "swap with next client by index", group = "client" }),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end,
        { description = "swap with previous client by index", group = "client" }),
    awful.key({ modkey }, ".", function() awful.screen.focus_relative(1) end,
        { description = "focus the next screen", group = "screen" }),
    awful.key({ modkey }, ",", function() awful.screen.focus_relative(-1) end,
        { description = "focus the previous screen", group = "screen" }),
    awful.key({ modkey, }, "u", awful.client.urgent.jumpto,
        { description = "jump to urgent client", group = "client" }),
    awful.key({ modkey1, }, "Tab",
        function()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        { description = "go back", group = "client" }),

    -- Show/Hide Wibox
    awful.key({ modkey }, "b", function()
        for s in screen do
            s.mywibox.visible = not s.mywibox.visible
            if s.mybottomwibox then
                s.mybottomwibox.visible = not s.mybottomwibox.visible
            end
        end
    end,
        { description = "toggle wibox", group = "awesome" }),

    -- Standard program
    awful.key({ modkey, }, "Return", function() awful.spawn(terminal) end,
        { description = "terminal with fish shell", group = "super" }),
    awful.key({ modkey }, "r", awesome.restart,
        { description = "reload awesome", group = "awesome" }),
    awful.key({ modkey, "Shift" }, "q",
        function() awful.spawn.with_shell('~/.dmenu/prompt "are you sure?" "killall awesome"') end,
        { description = "quit awesome", group = "awesome" }),

    awful.key({ altkey, "Shift" }, "l", function() awful.tag.incmwfact(0.05) end,
        { description = "increase master width factor", group = "layout" }),
    awful.key({ altkey, "Shift" }, "h", function() awful.tag.incmwfact(-0.05) end,
        { description = "decrease master width factor", group = "layout" }),
    awful.key({ modkey, "Shift" }, "h", function() awful.tag.incnmaster(1, nil, true) end,
        { description = "increase the number of master clients", group = "layout" }),
    awful.key({ modkey, "Shift" }, "l", function() awful.tag.incnmaster(-1, nil, true) end,
        { description = "decrease the number of master clients", group = "layout" }),
    awful.key({ modkey, "Control" }, "h", function() awful.tag.incncol(1, nil, true) end,
        { description = "increase the number of columns", group = "layout" }),
    awful.key({ modkey, "Control" }, "l", function() awful.tag.incncol(-1, nil, true) end,
        { description = "decrease the number of columns", group = "layout" }),
    awful.key({ modkey, }, "space", function() awful.layout.inc(1) end,
        { description = "select next", group = "layout" }),

    awful.key({ modkey, }, "`", function() awful.util.spawn("rofi -show") end,
        { description = "Run Rofi", group = "launcher" }),

    awful.key({ modkey, "Control" }, "n",
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                client.focus = c
                c:raise()
            end
        end,
        { description = "restore minimized", group = "client" }),

    -- Widgets popups
    awful.key({ altkey, }, "c", function() lain.widget.cal.show(7) end,
        { description = "show calendar", group = "widgets" }),
    awful.key({ altkey, }, "h", function() if beautiful.fs then beautiful.fs.show(7) end end,
        { description = "show filesystem", group = "widgets" }),
    awful.key({ altkey, }, "w", function() if beautiful.weather then beautiful.weather.show(7) end end,
        { description = "show weather", group = "widgets" }),

    -- Brightness
    awful.key({}, "XF86MonBrightnessUp", function() os.execute("xbacklight -inc 10") end,
        { description = "+10%", group = "hotkeys" }),
    awful.key({}, "XF86MonBrightnessDown", function() os.execute("xbacklight -dec 10") end,
        { description = "-10%", group = "hotkeys" }),

    -- ALSA volume control
    -- Volume Keys
    awful.key({}, "XF86AudioRaiseVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%+", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    --awful.key({ ctrlkey }, "Down",
    awful.key({}, "XF86AudioLowerVolume",
        function()
            os.execute(string.format("amixer -q set %s 1%%-", beautiful.volume.channel))
            beautiful.volume.update()
        end),
    awful.key({}, "XF86AudioMute",
        function()
            os.execute(string.format("amixer -q set %s toggle",
                beautiful.volume.togglechannel or beautiful.volume.channel))
            beautiful.volume.update()
        end),

    -- Media Keys
    awful.key({}, "XF86AudioPlay", function()
        awful.util.spawn("playerctl play-pause", false)
    end),
    awful.key({}, "XF86AudioNext", function()
        awful.util.spawn("playerctl next", false)
    end),
    awful.key({}, "XF86AudioPrev", function()
        awful.util.spawn("playerctl previous", false)
    end),

    awful.key({ altkey, "Shift" }, "x",
        function()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        { description = "lua execute prompt", group = "awesome" }))

clientkeys = my_table.join(
    awful.key({ altkey, "Shift" }, "m", lain.util.magnify_client,
        { description = "magnify client", group = "client" }),
    awful.key({ modkey, }, "f",
        function(c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        { description = "toggle fullscreen", group = "client" }),
    awful.key({ modkey, }, "q", function(c) c:kill() end,
        { description = "close", group = "hotkeys" }),
    awful.key({ modkey, "Shift" }, "space", awful.client.floating.toggle,
        { description = "toggle floating", group = "client" }),
    awful.key({ modkey, "Control" }, "Return", function(c) c:swap(awful.client.getmaster()) end,
        { description = "move to master", group = "client" }),
    awful.key({ modkey, }, "o", function(c) c:move_to_screen() end,
        { description = "move to screen", group = "client" }),
    awful.key({ modkey, }, "t", function(c) c.ontop = not c.ontop end,
        { description = "toggle keep on top", group = "client" }),
    awful.key({ modkey, }, "n",
        function(c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        { description = "minimize", group = "client" }),
    awful.key({ modkey, }, "m",
        function(c)
            c.maximized = not c.maximized
            c:raise()
        end,
        { description = "maximize", group = "client" })
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- Hack to only show tags 1 and 9 in the shortcut window (mod+s)
    local descr_view, descr_toggle, descr_move, descr_toggle_focus
    if i == 1 or i == 9 then
        descr_view = { description = "view tag #", group = "tag" }
        descr_toggle = { description = "toggle tag #", group = "tag" }
        descr_move = { description = "move focused client to tag #", group = "tag" }
        descr_toggle_focus = { description = "toggle focused client on tag #", group = "tag" }
    end
    globalkeys = my_table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            descr_view),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
            function()
                local screen = awful.screen.focused()
                local tag = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            descr_toggle),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
                end
            end,
            descr_move),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
            function()
                if client.focus then
                    local tag = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            descr_toggle_focus)
    )
end

clientbuttons = gears.table.join(
    awful.button({}, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
    end),
    awful.button({ modkey }, 1, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function(c)
        c:emit_signal("request::activate", "mouse_click", { raise = true })
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = {},
        properties = { border_width = beautiful.border_width,
            border_color = beautiful.border_normal,
            focus = awful.client.focus.filter,
            raise = true,
            keys = clientkeys,
            buttons = clientbuttons,
            screen = awful.screen.preferred,
            placement = awful.placement.no_overlap + awful.placement.no_offscreen,
            size_hints_honor = false
        }
    },

    -- Titlebars
    { rule_any = { type = { "dialog", "normal" } },
        properties = { titlebars_enabled = settings.enableTitlebar } },

}

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
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
        awful.button({}, 1, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.move(c)
        end),
        awful.button({}, 3, function()
            c:emit_signal("request::activate", "titlebar", { raise = true })
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c, { size = 21 }):setup {
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
            awful.titlebar.widget.floatingbutton(c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton(c),
            awful.titlebar.widget.ontopbutton(c),
            awful.titlebar.widget.closebutton(c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

if (settings.focusOnHover == true)
then
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", { raise = true })
end)
end

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


if (settings.useNitrogen == true)
then
    awful.spawn.with_shell("nitrogen --restore")
end

if (settings.usePicom == true)
then
    awful.spawn.with_shell("picom -b")
end

if (settings.useNMApplet == true)
then
    awful.spawn.with_shell("nm-applet")
end

-- Policy kit is an essential tool for managing privileges and permission,
-- we are using lxpolkit for this matter, if you wish to use a different polkit install and change the directory here
if (settings.useLxPolkit == true)
then
    awful.spawn.with_shell("/usr/bin/lxpolkit")
end

if (settings.useFlameShot == true)
then
    awful.spawn.with_shell("flameshot")
end
