# My Awesome Configuration

I use awesome in POP-OS, Linux mint or Manjaro (archbased) this make my set-up family friendly.
The POP-0S desktop or Linux Mint for wife and kids and Awesome for me.
Quick tip: instaling awesome window manager alongside XFCE desktop or LXQT works good beacouse XFCE and LXQT or higly modular. You can use de XFCE widgets in your taskbar.

# My Keybindings

The MODKEY is set to the Super key (aka the Windows key).

| Keybinding | Action |
| :--- | :--- |
| `ALT + Enter` | opens run launcher (dmenu is the run launcher but can be easily changed) |
| `MODKEY + Enter | opens terminal (st is the terminal but can be easily changed) |
| `MODKEY + S | Showes keybindings |
| `MODKEY + ALT + B` | Opens browser |
| `MODKEY + q` | quits tab |

## License

The project is licensed under GNU General Public License v2 or later.
You can read it online at ([v2](http://www.gnu.org/licenses/gpl-2.0.html)
or [v3](http://www.gnu.org/licenses/gpl.html)).


## Installation
============
This wil copy this awesome  config to your .config file

    $ git clone --recursive https://github.com/wietsedejong/awesomewm
    $ mkdir ~/.config/awesome
    $ mv -bv awesomewm/* ~/.config/awesome && rm -rf awesomewm

## Usage
=====

The modular structure allows to

* set variables
* define startup processes
* change keybindings and layouts
* set client properties

in ``rc.lua``, and

* configure widgets
* define wiboxes and screen settings

in ``theme.lua``, so that you just need to change ``chosen_theme`` variable in ``rc.lua`` to preserve your preferences *and* switch the theme, instead of having file redundancy.

Then, set the variable ``chosen_theme`` in ``rc.lua`` to your preferred theme, do your settings, and restart Awesome (``Mod4 + ctrl + r``).

To customize a theme, head over to ``themes/$chosen_theme/theme.lua``.

Otherwise, if you want to be synced with upstream, modify the theme path in ``rc.lua`` like this:

.. code-block:: diff

    -beautiful.init(string.format("%s/.config/awesome/themes/%s/theme.lua", os.getenv("HOME"), chosen_theme))
    +beautiful.init(string.format("%s/.config/awesome/themes/%s/theme-personal.lua", os.getenv("HOME"), chosen_theme))

## Notes
=====

Complements are provided by lain_ and freedesktop_. **Be sure** to satisfy their dependencies.

## Fonts

The fonts used in the screenshots are: Terminus_ (Multicolor, Powerarrow, Powerarrow Dark), Roboto_ (Holo, Vertex) and Tamsyn_ (other ones).

As taglist font, Blackburn and Dremora use Icons_, Vertex uses FontAwesome_: be sure to have bitmaps enabled if running under Debian or Ubuntu_.
Google is your friend in this one.

Due the removal of support for bitmap fonts in Pango 1.44_, the current main font is Terminus (OTB version). Under Arch Linux, use ``community/terminus-font-otb``.

Every theme has a colorscheme_.

## Weather

You can also configure the ``city_id`` in the following snippet in ``/.config/awesome/themes/<<CHOSEN_THEME>>/theme.lua`` to get the correct weather information (we suggest doing it in your ``theme-personal.lua``):

.. code-block::

     -- Weather
        local weathericon = wibox.widget.imagebox(theme.widget_weather)
        theme.weather = lain.widget.weather({
            city_id = 2643743, -- placeholder (London)
            notification_preset = { font = "Terminus 10", fg = theme.fg_normal },
            weather_na_markup = markup.fontfg(theme.font, "#eca4c4", "N/A "),
            settings = function()
                descr = weather_now["weather"][1]["description"]:lower()
                units = math.floor(weather_now["main"]["temp"])
                widget:set_markup(markup.fontfg(theme.font, "#eca4c4", descr .. " @ " .. units .. "°C "))
            end
        })

You can find your ``city_id`` in city.list.json.gz_ after you extract it.

## Additional default software used:

alecritty dmenu firefox mpc mpd scrot unclutter xsel slock
You can use nitrogen as a wallpaper manager
Also do'nt forget to install all dependencies in the autostart.sh
