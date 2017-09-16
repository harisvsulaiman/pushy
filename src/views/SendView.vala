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
using Gtk;
using Granite;

namespace Pushy { 
    
    
    class SendView : Overlay {

        private const Gtk.TargetEntry[] targets = {
            {"text/uri-list",0,0}
        };
        private Entry send_text;
        private PushBox send_box;
        private Stack upload_stack;
        private Label file_detail_label;
        private string file_path = null;
        private Granite.Widgets.OverlayBar push_status_bar;
        private Granite.Widgets.Toast toast;
        
        private Dbus dbus = Dbus.get_instance ();
        
        public SendView () {
            var grid = new Grid();
            grid.expand = true;
            grid.orientation = Orientation.VERTICAL;
            grid.row_homogeneous = false;
            grid.margin = 16;

            push_status_bar = new Granite.Widgets.OverlayBar(this);
            push_status_bar.hide ();

            toast = new Granite.Widgets.Toast(_(""));

            // message
            var message_label = new Label(_("Message"));
            message_label.get_style_context ().add_class ("h4");
            message_label.halign = Align.START;
            send_text = new Entry();
            send_text.editable = true;
            send_text.hexpand = true;

            // upload label
            var upload_label = new Label(_("Drag and Drop a file here!"));
            upload_label.get_style_context ().add_class ("upload_label");
            upload_label.halign = Align.CENTER;
            upload_label.valign = Align.CENTER; 

            var upload_button = new Button.with_label ("Open File");
            upload_button.halign = Align.CENTER;
            upload_button.valign = Align.CENTER;
            upload_button.get_style_context ().add_class ("select_file_button");
            upload_button.clicked.connect (upload_button_clicked); 
            
            upload_stack = new Stack();
            upload_stack.expand = true;
            upload_stack.margin_top = 16;
            
            var drop_box = new Box(Orientation.VERTICAL, 0);
            drop_box.get_style_context ().add_class ("drop_box");
            drop_box.pack_start (upload_label);
            drop_box.pack_start (upload_button);

            Gtk.drag_dest_set (drop_box, Gtk.DestDefaults.ALL, targets, Gdk.DragAction.COPY);
            drop_box.drag_data_received.connect (this.on_drag_data_received);
            
            file_detail_label = new Label("djskjdksdjk");
            file_detail_label.get_style_context ().add_class ("file_detail_label");
            file_detail_label.halign = Align.CENTER;
            file_detail_label.valign = Align.CENTER;
            file_detail_label.margin_left = 16;
            file_detail_label.margin_right = 16;
            file_detail_label.ellipsize = Pango.EllipsizeMode.END;

            var remove_file_button = new Button.with_label ("Remove file");
            remove_file_button.valign = Align.CENTER;
            remove_file_button.halign = Align.CENTER;
            remove_file_button.get_style_context ().add_class ("remove_file_button");
            remove_file_button.clicked.connect (remove_file_button_clicked);

            var file_detail_box = new Box(Orientation.VERTICAL, 1);
            file_detail_box.get_style_context ().add_class ("file_detail_box");
            file_detail_box.pack_start (file_detail_label);
            file_detail_box.pack_start (remove_file_button);
            
            upload_stack.add_named (drop_box, "drop_box_view");
            upload_stack.add_named (file_detail_box, "file_detail_box_view");
            upload_stack.transition_type = Gtk.StackTransitionType.CROSSFADE;
            upload_stack.transition_duration = 100;
            upload_stack.interpolate_size = true;   
            
            send_box = new PushBox();
            send_box.on_push_clicked.connect ((device) => { 
                push_status_bar.status = "Sending File...";
                push_status_bar.show ();

                if(validate ())
                dbus.SendFile (device, file_path, send_text.text, (err) => {
                    if(err == "") {
                        toast.title = "Sending the file was successfull";
                    } else {
                        toast.title = "Oops! cannot sent the file, at the moment";
                    }

                    toast.send_notification ();
                    // hide status bar.
                    push_status_bar.hide ();
                });
            });

            this.realize.connect (() => {
                dbus.GetDevices ((err, devices) => {
                    push_status_bar.status = "Getting devices ...";
                    push_status_bar.show ();

                    if (err == "") {
                        send_box.set_devices (devices);
                    } else {

                    }

                    // hide status bar.
                    push_status_bar.hide ();
                });
            });

            grid.add (message_label);
            grid.add (send_text);
            grid.add (upload_stack);
            grid.add (send_box);

            add_overlay (grid);
            add_overlay (toast);
            update_stack ();
        }

        private void upload_button_clicked () {
            var file_chooser = new Gtk.FileChooserDialog ("Select File",
                                                            this as Gtk.Window,
                                                            Gtk.FileChooserAction.OPEN,
                                                            "_Cancel", Gtk.ResponseType.CANCEL,
                                                            "_Open", Gtk.ResponseType.ACCEPT);
            file_chooser.select_multiple = false;
            file_chooser.local_only = true;
            file_chooser.set_modal (true);
            file_chooser.response.connect (file_response_cb);
            file_chooser.show ();
        }

        private void file_response_cb (Gtk.Dialog dialog, int response_id) {
            var open_dialog = dialog as Gtk.FileChooserDialog;

            switch (response_id) {
                case Gtk.ResponseType.ACCEPT:
                    var file = open_dialog.get_file ();
                    // thanking @GijsGoudzwaard
                    
                    if (file != null) {
                        file_path = sanitize (file.get_uri ());
                    } else {
                        // show error?
                        critical ("Selected file is null!");
                    }
                    break;
                default:
                    break;
                }

            dialog.destroy ();

            update_stack ();
        }

        private void remove_file_button_clicked () {
            file_path = null; 
            update_stack ();
        }
        
        private void update_stack () {
            if (file_path == null){
                critical (" drop box");
                upload_stack.visible_child_name = "drop_box_view";                
            } else {
                var file_path_array = file_path.split ("/");
                file_detail_label.label = file_path_array [file_path_array.length -1];
                upload_stack.visible_child_name = "file_detail_box_view";
            }
        }

        private void on_drag_data_received (Gdk.DragContext drag_context, int x, int y, Gtk.SelectionData data, uint info, uint time) {
            file_path = sanitize (data.get_uris () [0]);
            // thanking @GijsGoudzwaard

            update_stack ();
        }

        private string sanitize (string uri) {
            return GLib.Uri.unescape_string (uri.replace ("file://", ""));
        }

        private bool validate() {
            // todo validate entries.
            return true;
        }
    }
}