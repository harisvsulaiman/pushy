module.exports = {
  name: "com.github.harisvsulaiman.pushy.dbus",
  signals: {
    LoggedIn: ["b", ["isLoggedIn"]],
    LoginCb_: ["s", ["error"]],
    GetDevicesCb_: ["sa(ss)", ["error", "devices"]],
    GetUserDetailCb_: ["s(sb)", ["error", "userDetails"]],
    SendPushCb_: ["s", ["error"]],
    SendFileCb_: ["s", ["error"]]
  },

  methods: {
    Start: ["", "", [], ""],
    Stop: ["", "", [], ""],
    Login_: ["", "", [], ""],
    GetDevices_: ["", "", [], ""],
    GetUserDetail_: ["", "", [], ""],
    SendPush_: ["ssss", "", ["deviceId", "type", "title", "content"], ""],
    SendFile_: ["sss", "", ["deviceId", "path", "message"], ""]
  },
  properties: {}
};
