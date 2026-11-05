# Homelab Build - 2026-11-05 onward


## Device Naming Convention

Host: Host machines are named after Shinkansen speed tiers which correspond to hardware sizes. Each Shinkansen speed tier is followed by a 4-letter identifier of the host machine to make distinguishing each host easier.

- nozomi: fastest service.    (full sized desktop hardware)
- hikari: middle tier.        (mini-pc or similar sized hardware)
- kodama: stops everywhere.   (laptops)

- ex. hp-envy (daily driver)  : kodama-envy
- ex. mac mini                : hikari-macm
- ex. lets-note 2018          : kodama-lets
- ex. desktop                 : nozomi-desk

Guest: Guest machines will be named from the periodic table of elements. The operating system or container type abbreviated will precede the element name for easier lookup between a list of guests. The last octet of the guest machine's ipv4 address will be the atomic number of that element.

- ex. container       lxc-carbon  : ipv4 address 192.168.0.6
- ex. virtual-machine nix-uranium : ipv4 address 192.168.0.92
- ex. gateway         hydrogen    : ipv4 address 192.168.0.1


## Addressing Scheme

As stated in the Device Naming Convention section, the addressing scheme will be split logically between host machines and the guests running within them. Because my naming convention uses element names and their atomic numbers for the last octet of their ipv4 address, addresses `192.168.0.2` to `192.168.0.118` are reserved for guest machines in correspondence with this convention. Host machines and other items on the network will have access to addresses `192.168.0.119` to `192.168.0.254` (`192.168.0.255` is the broadcast address).

