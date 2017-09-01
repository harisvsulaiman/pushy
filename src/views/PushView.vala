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
    
    class PushView : Overlay { 
        private Entry push_title;
        private Entry push_text;
        private PushBox push_box;
        private string toggled_label;
        private Granite.Widgets.OverlayBar push_status_bar;
        private Granite.Widgets.Toast toast;

        private Dbus dbus = Dbus.get_instance ();
        
        public PushView() {
            var grid = new Grid();
            grid.expand = true;
            grid.orientation = Orientation.VERTICAL;
            grid.row_homogeneous = false;
            grid.margin = 16;

            push_status_bar = new Granite.Widgets.OverlayBar(this);
            push_status_bar.hide ();

            toast = new Granite.Widgets.Toast(_(""));

            var title_label = new Label ("Title");
            title_label.get_style_context ().add_class ("h4");
            title_label.halign = Align.START;
            push_title = new Entry ();

            var text_label = new Label ("Content");
            text_label.get_style_context ().add_class ("h4");            
            text_label.halign = Align.START;         
            text_label.margin_top = 16;   
            push_text = new Entry();
            push_text.editable = true;
            push_text.hexpand = true;

            var option_label = new Label ("Send as ");
            option_label.get_style_context ().add_class ("h4");            
            option_label.halign = Align.START;    
            option_label.margin_top = 16;

            var note_radio = new RadioButton.with_label_from_widget(null, "Note");
            note_radio.toggled.connect (toggled);
            toggled_label = "Note";
            note_radio.active = true;
            note_radio.expand = true;

            var link_radio = new RadioButton.with_label_from_widget(note_radio, "Link");
            link_radio.toggled.connect (toggled);

            push_box = new PushBox();
            push_box.on_push_clicked.connect ((device) => {
                push_status_bar.status = "Sending push ...";
                push_status_bar.show ();

                if (validate ())
                dbus.SendPush (device, toggled_label, push_title.text, push_text.text, (err) => {
                    if (err == "") {
                        toast.title = "Sending the " + toggled_label + " was successfull";
                    } else {
                        toast.title = "Oops! cannot sent the " + toggled_label + ", at the moment";
                    }

                    toast.send_notification ();
                    // hide status bar.
                    push_status_bar.hide ();
                });
            });

            this.realize.connect (() => {
                push_status_bar.status = "Getting devices ...";
                push_status_bar.show ();

                dbus.GetDevices ((err, devices) => {
                    if (err == "") {
                        push_box.set_devices (devices);
                    } else {

                    }
                    // hide status bar.
                    push_status_bar.hide ();
                });
            });

            grid.add (title_label);
            grid.add (push_title);
            grid.add (text_label);
            grid.add (push_text);
            grid.add (option_label);
            grid.add (link_radio);
            grid.add (note_radio);
            grid.add (push_box);
            
            add_overlay (grid);
            add_overlay (toast);
        }


        private void toggled(ToggleButton button) {
            if (button.active) {
                if (button.label == "Note") {
                    toggled_label = "Note";
                } else {
                    toggled_label = "Link";
                }
            }
        }

        private bool validate() {
            // todo validate entries.
            return true;
        }
    }
}