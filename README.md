<p align="center">
    <img 
    src="https://raw.githubusercontent.com/harisvsulaiman/pushy/master/data/com.github.harisvsulaiman.pushy.svg?sanitize=true" height="100px" width="100px"/>
    <h1 id="title" align="center">Pushy</h1>
    <p id="subtitle" align="center">Pushbullet client for elementary os.</p>
</p>
</br>
<p align="center">
    <a href="https://appcenter.elementary.io/com.github.harisvsulaiman.pushy">
        <img src="https://appcenter.elementary.io/badge.svg" alt="Get it on AppCenter">
    </a>
</p>
<p align="center">
    <img 
    src="https://raw.githubusercontent.com/harisvsulaiman/pushy/master/data/screenshots/screenshot-1.png" />
</p>

## Features

* Send pushes (Note/Link) to all the platforms supported by Pushbullet.
* Send Files to devices.

## Installation
> Nodejs is required.

Vala dependencies
* libsecret-1
* meson
* valac

Nodejs dependencies
> See package.json 

#### Important!
> Create a config.js which exports a sentry raven url for crash reporting

### Setup

```bash
npm install -g pkg # yarn global install pkg
npm install # or yarn install
meson build
mesonconf -Dprefix=/usr
```

### Build

```bash
npm run build # yarn build prebuilt binaries are also provided
cd build
ninja
```
### Install

```bash
sudo ninja install
com.github.harisvsulaiman.pushy
```

### Follow me
[![Twitter Follow](https://img.shields.io/twitter/follow/espadrine.svg?style=social&label=Follow)](https://twitter.com/harisvsulaiman)