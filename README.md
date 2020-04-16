<p align="center">
    <img 
    src="https://raw.githubusercontent.com/harisvsulaiman/pushy/master/data/com.github.harisvsulaiman.pushy.svg?sanitize=true" height="100px" width="100px"/>
    <h1 id="title" align="center">Pushy (No Longer Maintained)</h1>
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

[![Build Status](https://travis-ci.org/harisvsulaiman/pushy.svg?branch=master)](https://travis-ci.org/harisvsulaiman/pushy)

[![Greenkeeper badge](https://badges.greenkeeper.io/harisvsulaiman/pushy.svg)](https://greenkeeper.io/)

> Pushbullet client for elementary os.

## Features

* Send push messages (Note/Link) to Android, iOS, macOS, and browsers supporting the Pushbullet extension.
* Send Files to pushbullet clients.

## Installation

Dependencies
* libsecret-1
* meson
* valac
* nodejs

Nodejs dependencies
> See package.json 


### Setup

```bash
meson build
mesonconf -Dprefix=/usr
```

### Build

```bash
cd build
ninja
```
### Install

```bash
sudo ninja install
com.github.harisvsulaiman.pushy
```

### Follow me
[![Twitter Follow](https://img.shields.io/twitter/follow/espadrine.svg?style=social&label=Follow&style=plastic)](https://twitter.com/harisvsulaiman)
