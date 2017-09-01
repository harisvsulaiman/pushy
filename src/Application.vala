/***

    Copyright (C) 2017 harisvsulaiman

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

using Gtk;
using Granite;

namespace Pushy {

public class Pushy : Granite.Application {

    private static Pushy app;
    private MainWindow window = null;

    public Pushy () {
        Object (
            application_id: "com.github.harisvsulaiman.pushy",
            flags: ApplicationFlags.FLAGS_NONE
        );
    }

    protected override void activate () {
        // if app is already open
        if (window != null) {
            window.present ();
            return;
        }

        window = new MainWindow ();
        window.set_application (this);
        window.delete_event.connect (window.main_quit);
        window.show_all ();
    }

    public static Pushy get_instance () {
        if (app == null)
            app = new Pushy ();

        return app;
    }

    public static int main (string[] args) {
 
        app = new Pushy ();
        if (args[1] == "-s") {
            return 0;
        }
 
        return app.run (args);
    }
}
}
