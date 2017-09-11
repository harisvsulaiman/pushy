// @ts-check
const opn = require("opn");
const path = require("path");
const Raven = require("raven");
const LOGIN_LINK =
  `https://www.pushbullet.com/authorize?client_id=tqvr0F5ZpvKaEwdG7kLZ0JJpNhkxY4OQ&redirect_uri=http%3A%2F%2Flocalhost%3A3201%2Flogin&response_type=token&scope=everything`;

const express = require("express");
const app = express();
const tokenManager = require("../../token");
const pushBulletManager = require("../../pushbullet");
let push = null;

let server;
const PORT = 3201;

app.get("/login", (request, response) => {
  // todo check for hostname.
  console.log(`hostaname ${request.hostname}`);
  response.sendFile(__dirname + "/index.html");
});

app.get("/", (request, response) => {
  let token = request.query.token;

  tokenManager
    .saveToken(token)
    .then(() => {
      // send ok response
      response.sendStatus(200);
      LoggedIn(true);
      console.log("logged in");

      // close the express server.
      if (server) {
        console.log("closing server!");
        server.close();
      }
    })
    .catch(err => {
      // send error code and dbus signal
      response.sendStatus(500);
      LoggedIn(false);
      // @ts-ignore
      Raven.captureException(err); 
    });
});

let iface = {
  Start: () => {
    console.log("dbus started");
    tokenManager
      .getToken()
      .then(token => {
        if (token) {
          LoggedIn(true);
          if (!push) {
            push = new pushBulletManager(token);
          }
        } else {
          LoggedIn(false);
        }
      })
      .catch(err => {
        LoggedIn(false);
        console.error(err);
        //@ts-ignore
        Raven.captureException(err);
      });
  },
  Stop: () => {
    console.log("dbus stopped");
    // exit process. todo: make it optional.
    process.exit();
  },
  Login_: () => {
    // listen to server for auth tokens
    server = app.listen(PORT);
    // try to open link
    opn(LOGIN_LINK)
      // @ts-ignore
      .then(() => {
        LoginCb_("");
      })
      .catch(err => {
        LoginCb_(err.toString());
        // @ts-ignore
        Raven.captureException(err);
      });
  },
  GetDevices_: () => {
    // push options // handle cursoring.
    let options = {
      limit: 10,
      active: true
    };

    tokenManager
      .getToken()
      .then(token => {
        if (token) {
          LoggedIn(true);
          if (!push) {
            push = new pushBulletManager(token);
          }
        } else {
          LoggedIn(false);
        }
        return push.getDevices(options);
      })
      .then(response => {
        let data = [];
        // make data node dbus compatible
        response.devices.forEach(device => {
          let data_struct = [];
          data_struct.push(device.nickname);
          data_struct.push(device.iden);
          data.push(data_struct);
        });

        // call callback.
        GetDevicesCb_("", data);
        console.log(data);
      })
      .catch(err => {
        GetDevicesCb_(err, []);
        console.log(err);
        // @ts-ignore
        Raven.captureException(err);
      });
  },
  GetUserDetail_: () => {
    tokenManager
      .getToken()
      .then(token => {
        if (token) {
          LoggedIn(true);
          if (!push) {
            push = new pushBulletManager(token);
          }
        } else {
          LoggedIn(false);
        }

        push = new pushBulletManager();
        return push.getUserDetail();
      })
      .then(response => {})
      .catch(err => {
        console.log(err);
        GetUserDetailCb_(err, []);
        // @ts-ignore        
        Raven.captureException(err);
      });
  },
  SendPush_: (deviceId, type, title, content) => {
    tokenManager
      .getToken()
      .then(token => {
        if (token) {
          LoggedIn(true);
          if (!push) {
            push = new pushBulletManager(token);
          }
        } else {
          LoggedIn(false);
        }
        return push.sendPush(deviceId, type, title, content);
      })
      .then(response => {
        console.log(response);
        SendPushCb_("");
      })
      .catch(err => {
        SendPushCb_(err);
        console.log(err);
        // @ts-ignore        
        Raven.captureException(err);
      });
  },
  SendFile_: (deviceId, path, message) => {
    tokenManager
      .getToken()
      .then(token => {
        if (token) {
          LoggedIn(true);
          if (!push) {
            push = new pushBulletManager(token);
          }
        } else {
          LoggedIn(false);
        }
        return push.sendFile(deviceId, path, message);
      })
      .then(response => {
        console.log(response);
        SendFileCb_("");
      })
      .catch(err => {
        console.log(err);
        SendFileCb_(err.toString());
        // @ts-ignore        
        Raven.captureException(err);
      });
  },
  emit: function(signalName, ...signalOutputParams) {
    console.log(signalName, ...signalOutputParams);
  }
};

function LoggedIn(isLoggedIn) {
  iface.emit("LoggedIn", isLoggedIn);
}

function LoginCb_(err) {
  iface.emit("LoginCb_", err.toString());
}

function GetUserDetailCb_(err, userDetail) {
  iface.emit("UserDetailCb_", err.toString(), userDetail);
}

function GetDevicesCb_(err, devices) {
  iface.emit("GetDevicesCb_", err.toString(), devices);
}

function SendPushCb_(err) {
  iface.emit("SendPushCb_", err.toString());
}

function SendFileCb_(err) {
  iface.emit("SendFileCb_", err.toString());
}

module.exports = iface;
