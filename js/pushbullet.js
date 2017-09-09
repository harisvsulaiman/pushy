const Pushbullet = require("pushbullet");

class PushBulletManager {
  constructor(token) {
    if (token === null) {
      throw new Error(" token cant be null");
    }
    this.pushbullet = new Pushbullet(token);
  }

  getDevices(options) {
    return new Promise((resolve, reject) => {
      this.pushbullet.devices(options, (err, response) => {
        if (err) {
          reject(err);
        }
        resolve(response);
      });
    });
  }
  sendPush(deviceId, type = "Note", title, content) {
    if (type === "Note") {
      return new Promise((resolve, reject) => {
        this.pushbullet.note(deviceId, title, content, (err, response) => {
          if (err) {
            reject(err);
          }
          resolve(response);
        });
      });
    } else if (type === "Link") {
      return new Promise((resolve, reject) => {
        this.pushbullet.link(deviceId, title, content, (err, response) => {
          if (err) {
            reject(err);
          }
          resolve(response);
        });
      });
    }
  }

  sendFile(deviceId, path, message) {
    return new Promise((resolve, reject) => {
      this.pushbullet.file(deviceId, path, message, (err, response) => {
        if (err) {
          reject(err);
        }
        resolve(response);
      });
    });
  }

  getUserDetail() {
    return new Promise((resolve, reject) => {
      this.pushbullet.me((err, response) => {
        if (err) {
          reject(err);
        }
        resolve(response);
      });
    });
  }
}
module.exports = PushBulletManager;
