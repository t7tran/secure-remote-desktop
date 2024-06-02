# Ubuntu docker container image with XFCE4 Desktop for "headless" VNC environments

**Credits** with enhancements from https://github.com/kincsescsaba/remote-desktop-in-docker

Installed with the following components:

* XFCE4 Desktop Environment with full DateTime on the top in order to get Screenshot Evidences
* vnc server (default VNC port `5901`)
* [**noVNC**](https://github.com/novnc/noVNC) - HTML5 VNC client (default http port `6901`)
* Browsers:
  * Chrome

## Usage

- Run with readonly filesystem

      docker run -p 6901:6901 --read-only --mount type=tmpfs,destination=/tmp,tmpfs-mode=1777 --mount type=tmpfs,destination=/home/viewer,tmpfs-mode=1777 t7tran/tiny-remote-desktop

- Run command with mapping to local `6901` (vnc web access) with specific resolution:

      docker run -p 6901:6901 -e RESOLUTION=1600x1200 t7tran/tiny-remote-desktop

