--      ████████╗ ██████╗ ██████╗     ██████╗  █████╗ ███╗   ██╗███████╗██╗
--      ╚══██╔══╝██╔═══██╗██╔══██╗    ██╔══██╗██╔══██╗████╗  ██║██╔════╝██║
--         ██║   ██║   ██║██████╔╝    ██████╔╝███████║██╔██╗ ██║█████╗  ██║
--         ██║   ██║   ██║██╔═══╝     ██╔═══╝ ██╔══██║██║╚██╗██║██╔══╝  ██║
--         ██║   ╚██████╔╝██║         ██║     ██║  ██║██║ ╚████║███████╗███████╗
--         ╚═╝    ╚═════╝ ╚═╝         ╚═╝     ╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚══════╝

-- ===================================================================
-- Initialization
-- ===================================================================


local awful = require("awful")
local beautiful = require("beautiful")
local wibox = require("wibox")
local gears = require("gears")
local net_widgets = require("widgets/net_widgets")
local dpi = beautiful.xresources.apply_dpi

-- import widgets
local task_list = require("widgets.task-list")
local tag_list = require("widgets.tag-list")

-- define module table
local top_panel = {}

local modkey = "Mod4"

net_wireless = net_widgets.wireless({ interface = "wlo1" })


-- ===================================================================
-- Bar Creation
-- ===================================================================


top_panel.create = function(s)
   local panel = awful.wibar({
      screen = s,
      position = "top",
      ontop = true,
      height = beautiful.top_panel_height,
      width = s.geometry.width,
   })

   panel:setup {
      expand = "none",
      layout = wibox.layout.align.horizontal,
      {
         -- Left widgets
         layout = wibox.layout.fixed.horizontal,
         require("widgets.tag-list").create(s),
      },
      -- nil,
      require("widgets.calendar").create(s),
      {
         layout = wibox.layout.fixed.horizontal,
         wibox.container.margin(wibox.widget.systray(), dpi(5), dpi(15), dpi(5), dpi(5)),
         -- wibox.widget.textbox('  |  '),
         require("widgets.sound").create(),
         -- wibox.widget.textbox('  |  '),
         -- require("widgets.ram-usage").create(),
         -- require("widgets.bluetooth),
         -- require("widgets.network")(),
         -- net_wireless,
         require("widgets.battery"),
         -- wibox.container.margin(require("widgets.layout-box"), dpi(5), dpi(5), dpi(5), dpi(5))
      }
   }


   -- ===================================================================
   -- Functionality
   -- ===================================================================


   -- hide panel when client is fullscreen
   local function change_panel_visibility(client)
      if client.screen == s then
         panel.ontop = not client.fullscreen
      end
   end

   -- connect panel visibility function to relevant signals
   client.connect_signal("property::fullscreen", change_panel_visibility)
   client.connect_signal("focus", change_panel_visibility)
end

return top_panel