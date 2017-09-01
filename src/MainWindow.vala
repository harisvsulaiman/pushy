/***

    Copyright (C) 2014-2016  harisvsulaiman

    This program is free software: you can redistribute it and/or modify it
    under the terms of the GNU Lesser General Public License version 3, as
    published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful, but
    WITHOUT ANY WARRANTY; without even the implied warranties of
    MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
    PURPOSE.  See the GNU General Public License for more details.

    You should have received a copy of the GNU General Public License along
    with this program.  If not, see <http://www.gnu.org/licenses>

***/
using Granite;
using Gtk;

namespace Pushy {

    const int MIN_WIDTH = 700;
    const int MIN_HEIGHT = 480;

    const string HINT_STRING = _("Add a new task...");

    public class MainWindow : Window {
        
        private bool first = true;
        private bool isLoggedIn = false;

        private GLib.Settings pushy_settings = new GLib.Settings ("com.github.harisvsulaiman.pushy");
        private GLib.Settings privacy_setting = new GLib.Settings ("org.gnome.desktop.privacy");
        private Dbus dbus = Dbus.get_instance ();

        /* GUI components */
        private Widgets.Welcome pushy_welcome;  // The Welcome screen when there are no tasks
        private Grid grid;            // Container for everything
        private HeaderBar headerbar;
        private Widgets.ModeButton mode_button;
        private Stack stack;
        private PushView pushView;
        private SendView sendView;

        public MainWindow () {            
            dbus.Start();

            var css_provider = new CssProvider ();
            css_provider.load_from_resource ("com/github/harisvsulaiman/pushy/application.css");
            StyleContext.add_provider_for_screen (get_screen (), css_provider, Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION);

            get_style_context ().add_class ("rounded");
            set_size_request(MIN_WIDTH, MIN_HEIGHT);

            // Set up geometry
            Gdk.Geometry geo = new Gdk.Geometry ();
            geo.min_width = MIN_WIDTH;
            geo.min_height = MIN_HEIGHT;
            geo.max_width = MIN_WIDTH;
            geo.max_height = MIN_HEIGHT;

            set_geometry_hints(null, geo, Gdk.WindowHints.MIN_SIZE | Gdk.WindowHints.MAX_SIZE);

            restore_window_position ();
            first = pushy_settings.get_boolean ("first-time");
            
            setup_ui ();    // Set up the GUI
            update_view ();
        }


        /**
         * Builds all of the widgets and arranges them in the window.
         */
        private void setup_ui () {
            pushy_welcome = new Widgets.Welcome (
                _("Welcome to pushy"),
                _("A pushbullet client")
                );

            mode_button = new Widgets.ModeButton ();
            headerbar = new HeaderBar ();
            grid = new Grid ();
            stack = new Stack ();
            pushView = new PushView ();
            sendView = new SendView ();
            
            // welcome 
            pushy_welcome.append (
                "avatar-default",
                _("Login"),
                _("Login to send and recieve push notifications")
                );
                
            pushy_welcome.expand = true;
            pushy_welcome.activated.connect ( (index) => {
                dbus.Login ((err) => {
                    if (err != "") {
                        // show error that browser couldn't be opened!
                    }
                    return;
                });
            });

            
            // mode_button
            mode_button.margin = 1;
            mode_button.sensitive = true;
            mode_button.append_text (_("Push"));
            mode_button.append_text (_("Send File"));
            mode_button.selected = 0;
            mode_button.margin_right = 20;
            mode_button.notify["selected"].connect (() => {
                update_view ();
            });

            // headerbar
            headerbar.show_close_button = true;          
            headerbar.set_custom_title (mode_button);
            set_titlebar (headerbar);    
            
            
            // stack
            stack.add_named (pushy_welcome, "welcome");
            stack.add_named (pushView, "push_view");  
            stack.add_named (sendView, "send_view"); 
            stack.transition_type = Gtk.StackTransitionType.SLIDE_LEFT_RIGHT;
            stack.transition_duration = 300;
            stack.interpolate_size = true;         

            // main grid
            grid.add (stack);
            grid.expand = true;   // expand the box to fill the whole window
            grid.row_homogeneous = false;
            add (grid);

            dbus.dbusIface.LoggedIn.connect ((loggedIn) => {
                isLoggedIn = loggedIn;
                update_view ();
            });
        }

        private void update_view () {
            if (!isLoggedIn){
                mode_button.sensitive = false;
                stack.visible_child_name = "welcome";
                return;
            }

            mode_button.sensitive = true;

            switch (mode_button.selected) {
                case 0: 
                    stack.visible_child_name = "push_view";           
                    //  critical ("push button clicked");
                    break;
                case 1: 
                    stack.visible_child_name = "send_view";
                    //  critical ("send button clicked");
                    break;
                default:
                    break;
            }
        }

        /**
         *  Check if the system is in Privacy mode.
         */
        public bool privacy_mode_off () {
            return privacy_setting.get_boolean ("remember-app-usage") || privacy_setting.get_boolean ("remember-recent-files");
        }

        /**
         *  Restore window position.
         */
        public void restore_window_position () {
            var position = pushy_settings.get_value ("window-position");
            var win_size = pushy_settings.get_value ("window-size");

            if (position.n_children () == 2) {
                var x = (int32) position.get_child_value (0);
                var y = (int32) position.get_child_value (1);

                debug ("Moving window to coordinates %d, %d", x, y);
                this.move (x, y);
            } else {
                debug ("Moving window to the centre of the screen");
                this.window_position = Gtk.WindowPosition.CENTER;
            }

            if (win_size.n_children () == 2) {
                var width =  (int32) win_size.get_child_value (0);
                                var height = (int32) win_size.get_child_value (1);

                                debug ("Resizing to width and height: %d, %d", width, height);
                this.resize (width, height);
            } else {
                debug ("Not resizing window");
            }
        }

        /**
         *  Save window position.
         */
        public void save_window_position () {
            int x, y, width, height;
            this.get_position (out x, out y);
            this.get_size (out width, out height);
            debug ("Saving window position to %d, %d", x, y);
            pushy_settings.set_value ("window-position", new int[] { x, y });
            debug ("Saving window size of width and height: %d, %d", width, height); 
            pushy_settings.set_value ("window-size", new int[] { width, height });
        }

        /**
         *  Quit from the program.
         */
        public bool main_quit () {
            dbus.Stop();
            save_window_position ();
            this.destroy ();
            return false;
        }

    }
}
