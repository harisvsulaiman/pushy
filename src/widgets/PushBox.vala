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
    
    class PushBox : Box { 
        private Button push_button;
        private ComboBoxText devices_combo_box;
        public signal void on_push_clicked (string device);
        
        public PushBox() {
            Object (
                orientation: Orientation.HORIZONTAL,
                spacing: 10
               );
        }

        construct {
            margin_top = 16;
            push_button = new Button();
            push_button.label = "Push";
            push_button.get_style_context ().add_class (Gtk.STYLE_CLASS_SUGGESTED_ACTION);
            
            devices_combo_box = new ComboBoxText();
            pack_start (devices_combo_box);
            pack_end (push_button);

            push_button.clicked.connect (() => { 
                on_push_clicked(devices_combo_box.get_active_id());
             });
        }

        public void set_devices (Device[] devices) {
            devices_combo_box.remove_all ();
            foreach (Device device in devices) {
                devices_combo_box.append (device.id, device.nickname);
            }
        }
    }
}