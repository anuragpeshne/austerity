# austerity
Stay Focused

Austerity helps you to stay focused during work hours, by preventing computer to reach certain domains and controlling access, to certain domains, to specific time.
This is meant for self control rather than for controlling others since the method is useless if sites are accessed via proxy.

How To:
* Open up `banList.txt` and add website domains (one per line) which should be banned on your machine.
* Append list of domains, which should be accessible for certain period, to `controlList.txt`.
* Edit `constants.sh` and define `PLAY_START` and `PLAY_STOP`. Websites mentioned in `controlList.txt` can be accessed after `PLAY_START` and before `PLAY_STOP`.
```
PLAY_STOP="0 1 * * *"
           │ │ │ │ │
           │ │ │ │ │
           │ │ │ │ └───── day of week (0 - 6) (0 to 6 are Sunday to Saturday)
           │ │ │ └────────── month (1 - 12)
           │ │ └─────────────── day of month (1 - 31)
           │ └──────────────────── hour (0 - 23)
           └───────────────────────── min (0 - 59)
```
* do `sudo ./install.sh && ./control.sh`
* If anything goes wrong: find backups at `/etc/hosts.orig` and `{repo}/crontab.orig`.

Inspired by http://www.catonmat.net/blog/one-weird-old-productivity-tip/
