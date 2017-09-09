const keytar = require("keytar");

const SERVICE = "com.github.harisvsulaiman.pushy";
const ACCOUNT = "default";

class Token {
  async isTokenAvailable() {
    let token = await keytar.findPassword(SERVICE);
    return token !== null;
  }

  saveToken(token, account = ACCOUNT) {
    return keytar.setPassword(SERVICE, account, token);
  }

  async getToken(account = ACCOUNT) {
    return keytar.getPassword(SERVICE, account);
  }

  async deleteToken(account = ACCOUNT) {
    return keytar.deletePassword(SERVICE,account);
  }
}

const token = new Token();

module.exports = token;
