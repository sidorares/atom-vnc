# VNC viewer for [Atom](http://atom.io) editor

![vnc](https://cloud.githubusercontent.com/assets/173025/3453038/67293c6a-01be-11e4-8109-a71fcde03a01.gif)

Currently only `None` and `VNC` security types are supported.
Tested with x11vnc, droid vnc and apple screen sharing.

## TODO (feel free to contribute)
- better connect dialog. Advanced options ( preferred security type, disconnect other clients etc)
- remember history, 'connect to last' command
- sd / mDNS browser in the background listening for rfb announces
- view toolbar: select scale, rotate screen, change cursor mode 
- reverce connections
- record results ( save as gif! )
- connect via [ssh2](https://github.com/mscdex/ssh2) to remote server and forard local vnc port

Needs [node-rfb2](https://github.com/sidorares/node-rfb2/issues) support:
- Apple Remote Display security
- more encodings (rle, hextile, TightJPEG, TightPNG)
- file transfers

## See also

- [node-rfb2](https://github.com/sidorares/node-rfb2) node rfb protocol client library
- [node-vnc](https://github.com/sidorares/node-vnc) small pure js x11 vnc client
- [vnc-over-gif](https://github.com/sidorares/vnc-over-gif) rfb to endless animated gif proxy
- [ansi-vnc](https://github.com/sidorares/ansi-vnc) terminal vnc client

## License

MIT
