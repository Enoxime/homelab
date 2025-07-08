# The nas server

The nas is a
[Truenas Scale](https://www.truenas.com/download-truenas-community-edition/).
As the system do a lot of checks and simplify a lot of tasks instead of doing it
all separately. [Houston](https://www.45drives.com/solutions/houston/) could be
considered as a direct concurrent but with less options. My final goal will be
to switch to Houston once it does all I need.

There are three disks pool. One with 4x500GB of SSD disks, one with 4x12TB of
HDD disks and one with 3x3TB of HDD disks. The first pool is for temporary and
fast storage. The second pool is for everything storage. The third pool is
encrypted and serve as a backup storage for the most important stuff.

TODO: Host somewhere else outside home a mini nas connected via
[Wireguard](https://www.wireguard.com/) for external backup for the worst-case
scenario.
