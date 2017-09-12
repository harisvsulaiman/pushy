const dbus = require("dbus-native");

class SessionManager {
  constructor(...serviceNames) {
    this.sessionBus = dbus.sessionBus();
    this.serviceNames = serviceNames;
    // Check the connection was successful
    if (!this.sessionBus) {
      throw new Error("Could not connect to the DBus session bus.");
    }

    //  request service names for all names
    this.serviceNames.forEach((serviceName, index) => {
      this.requestName(serviceName);
    });
  }

  /*
	Then request our service name to the bus.
	The 0x4 flag means that we don't want to be queued if the service name we are requesting is already
	owned by another service ;we want to fail instead.
  */
  requestName(serviceName) {
    const interfaceName = `com.github.harisvsulaiman.pushy.${serviceName}`;

    this.sessionBus.requestName(interfaceName, 0x4, (e, retCode) => {
      // If there was an error, warn user and fail
      if (e) {
        throw new Error(
          `Could not request service name ${interfaceName}, the error was: ${e}.`
        );
      }

      // Return code 0x1 means we successfully had the name
      if (retCode === 1) {
        console.log(`Successfully requested service name "${interfaceName}"!`);
        this.proceed(serviceName);
      } else {
        /* Other return codes means various errors, check here
      (https://dbus.freedesktop.org/doc/api/html/group__DBusShared.html#ga37a9bc7c6eb11d212bf8d5e5ff3b50f9) for more
      information
      */
        throw new Error(
          `Failed to request service name "${interfaceName}". Check what return code "${retCode}" means.`
        );
      }
    });
  }

  /**
   * 
   * @param serviceName serviceName to be exported.
   */
  proceed(serviceName) {
    const interfaceName = `com.github.harisvsulaiman.pushy.${serviceName}`;
    const objectPath = "/" + interfaceName.replace(/\./g, "/");

    let iFace = require(`./interfaces/${serviceName}/iface.js`);
    let iFaceDesc = require(`./interfaces/${serviceName}/ifaceDesc.js`);
    
    this.sessionBus.exportInterface(iFace, objectPath, iFaceDesc);
    // Say our service is ready to receive function calls (you can use `gdbus call` to make function calls)
    console.log("Interface exposed to DBus, ready to receive function calls!");
  }
}

module.exports = SessionManager;
