# Homelab Build - 2026/11-05 onward

## Device Naming Convention

Host: Host machines are named after Shinkansen speed tiers. The operating system name abbreviated will precede the Shinkansen tier.

- nozomi: fastest service.    (full sized desktop hardware)
- hikari: middle tier.        (mini-pc or similar sized hardware)
- kodama: stops everywhere.   (laptops)

- ex. hp-envy (daily driver)  : fed-kodama-00
- ex. lets-note 2018          : ubu-kodama-01
- ex. desktop (sot/pmx)       : pmx-nozomi-00

Guest: Guest machines will be named from the periodic table of elements
    
- the last octet of the guest machine's ipv4 address will be the atomic number of that element 
- ex. container carbon-0001 -> ex. address 128.10.0.006 


