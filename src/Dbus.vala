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
namespace Pushy { 
    // delegates
    delegate void LoginCb (string error);
    delegate void GetDevicesCb (string error, Device[] devices);
    delegate void SendPushCb (string error);
    delegate void SendFileCb (string error);
    delegate void GetUserDetailCb (string error, UserDetail userDetail);

    // Models
    struct Device {
        public string nickname;
        public string id;
    }

    struct UserDetail {
        public string name;
    }

    [DBus ( name="com.github.harisvsulaiman.pushy.dbus" ) ]
    interface DbusIface : Object{
        public signal void LoggedIn (bool isLoggedIn);
        
        public abstract void Start () throws IOError;
        public abstract void Stop () throws IOError;
        
        public abstract void Login_ ();
        public signal void LoginCb_ (string error);
        
        public abstract void GetDevices_ ();
        public signal void GetDevicesCb_ (string error, Device[] devices);

        public abstract void SendPush_ (string deviceId, string type, string title, string content);
        public signal void SendPushCb_ (string error);

        public abstract void SendFile_ (string deviceId, string path, string message);
        public signal void SendFileCb_ (string error);

        public abstract void GetUserDetail_ ();
        public signal void GetUserDetailCb_ (string error, UserDetail userDetail);
    }

    class Dbus : Object {
        private static Dbus dbus = null;
        public static DbusIface dbusIface = null;
        private Cancellable dbus_cancellable = new Cancellable();

        public Dbus (){
            try {
                dbusIface = Bus.get_proxy_sync (
                            BusType.SESSION,
                            "com.github.harisvsulaiman.pushy.dbus",
                            "/com/github/harisvsulaiman/pushy/dbus",
                            DBusProxyFlags.NONE,
                            dbus_cancellable
                        );
            } catch (Error error){
                critical(error.message);
            }
        }

        public static Dbus get_instance (){
            if(dbus == null) {
                dbus = new Dbus();
            }
            return dbus;
        }

        public void Start () {
            dbusIface.Start();
        }

        public void Stop () {
            dbus_cancellable.cancel();            
            dbusIface.Stop();
        }

        public static void Login (LoginCb loginCb) {
            debug("proxy function called");
            dbusIface.Login_();
            debug ("actual function called");                        
            dbusIface.LoginCb_.connect( (error) => {
                debug ("login signal connected");                        
                loginCb (error);
            });
        }

        public static void GetDevices (GetDevicesCb getDevicesCb) {
            debug ("proxy function called");
            dbusIface.GetDevices_();
            debug ("actual function called");                        
            dbusIface.GetDevicesCb_.connect ((error, devices) => {
                debug ("get devices signal connected");                        
                getDevicesCb (error, devices);
            });
        }

        public static void SendPush (string deviceId, string type, string title, string content,SendPushCb sendPushCb) {
            debug("proxy function called");
            dbusIface.SendPush_(deviceId, type, title, content);
            debug ("actual function called");                        
            dbusIface.SendPushCb_.connect ((error) => {
                debug ("login signal connected");                        
                sendPushCb (error);
            });       
        }

        public static void SendFile (string deviceId, string path, string message,SendFileCb sendFileCb) {
            debug("proxy function called");
            dbusIface.SendFile_(deviceId, path, message);
            debug ("actual function called");                        
            dbusIface.SendFileCb_.connect ((error) => {
                debug ("login signal connected");                        
                sendFileCb (error);
            });   
        }

        public static void GetUserDetail (GetUserDetailCb getUserDetailCb) {
            debug ("proxy function called");
            dbusIface.GetUserDetail_ ();
            debug ("actual function called");
            dbusIface.GetUserDetailCb_.connect ((error, userDetail) => {
                debug ("getuserdetail signal connected");
                getUserDetailCb (error, userDetail);
            });
        }
    }
}