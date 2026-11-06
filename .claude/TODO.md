# Homelab: Open Recommendations

Claude keeps this list of recommendations. Check it at the start of each session.
Status: **ready** = can do now · **blocked** = waiting on something · **done** = finished (keep a short note)

## Ready

- [ ] **Move the Incus trust token and address out of `main.tf`** into `variables.tf` + gitignored `terraform.tfvars` (+ committed `terraform.tfvars.example`). Use a `sensitive = true` variable read from a gitignored `*.tfvars` or `TF_VAR_incus_token`. It's one-time use, so it can be removed once the client cert is trusted.
- [ ] **Optional:** guest example `lxc-carbon` doesn't follow the OS-prefix rule (`lxc` is an instance type). Something like `deb-carbon` would. Only if Tim wants it.
- [ ] **Optional:** explain the `ln-` folder prefix (`ln-incus`) in the README.

- [ ] **Settle the conflicts between the network plan doc and the README** ([Homelab Network Plan – Router on a Stick](https://claude.ai/artifact/919GFdUjErPfpxeFPFM3aS), 2026-11-06):
  - Reach the lab remotely by Tailscale MagicDNS name, not LAN IP. Keep the Incus API (8443) and SSH off public interfaces.
  - Addressing: the doc uses DHCP reservations in OpenWrt, not static IPs per guest. That's compatible with the element scheme (reserve `.6` for carbon, etc.). Update the README wording and the "Guest networking" item below.
  - The OpenWrt plan replaces the "router DHCP pool" blocker. The house router becomes just the WAN.
- [ ] **OpenWrt networking: pick Option A or B** (from the doc). A = VLAN 10/20 subinterfaces plus a bridge each on the host, one NIC per bridge in the VM. B = trunk into the VM, and OpenWrt does the tagging. Check Incus bridged NIC `vlan` / `vlan.tagged` keys first (devices_nic docs).
- [ ] **Leftovers from the `incus.tf` review:** add `lan_bridge` and `wan_interface` to `terraform.tfvars.example`; fix the token comment in `variables.tf` (the command is `incus config trust add <name>`); commit `.terraform.lock.hcl`.
- [ ] **Decide the hydrogen NIC layout.** The `.tf` uses two NICs (onboard = WAN passthrough, USB-C = LAN bridge); the network plan doc uses one port trunked with VLANs 10/20. Update the doc to whichever wins. With passthrough, the onboard NIC disappears from the host. Then kodama-lets reaches the internet, Tailscale and the Incus API only *through* hydrogen, so keep a local console fallback. The LAN bridge must already exist (host bridge, or an Incus-managed `incus_network`); Terraform doesn't create it from the variable.
- [ ] **Run `terraform init` in `kodama-lets/`** so terraform-ls in Neovim gets the provider schema (completion and hover for `incus_*` resources).

## Blocked

- [ ] **Lock down the Incus API on kodama-lets** (when Incus and Tailscale are up). Bind `core.https_address` to the Tailscale IP, not `0.0.0.0` or `[::]`. Add a Tailscale ACL so only kodama-envy can reach 8443. Consider a `--restricted` trust cert scoped to a project. If envy is lost, revoke it with `incus config trust remove`. Treat `~/.config/incus/client.key` on envy as a root-level secret.

- [ ] **`ln-incus/main.tf`: real remote address.** Blocked: `kodama-lets` has no address yet.
  - Set `address` (`"https://<ip-or-tailscale-name>:8443"`); a Tailscale MagicDNS name could work.
- [ ] **Tailscale on `kodama-lets`.** Blocked: server setup. Afterwards, decide whether Terraform and admin traffic use Tailscale names or LAN IPs.
- [ ] **DHCP pool in OpenWrt (hydrogen) limited to `10.9.0.119`–`.254`, with reservations for element guests.** Blocked: OpenWrt VM not built yet. (This replaced the old "house router DHCP" blocker.)
  - Until then: if a guest's element IP is already taken, rename the guest (Tim's chosen workaround).
- [ ] **Guest networking in Incus.** Blocked: host setup. Guests must be on the LAN (`10.9.0.0/24`) for element = last octet to work. That needs a bridged or macvlan NIC, not the default NAT `incusbr0`. Give each guest a static `ipv4.address` matching its element.
- [ ] **First Incus resources in Terraform.** Blocked: on the remote above. Include an element-to-IP map in `locals`. The instance name becomes the hostname automatically.

## Done

- [x] 2026-11-06: `incus.tf`: resource moved out of the provider block, `resource` spelled correctly, `virtual-machine` fixed. Validate, fmt and plan are all clean.

- [x] 2026-11-05: Neovim terraform-ls confirmed working. It looked dead because there were no providers or `terraform init` yet.
- [x] 2026-11-05: Provider attribute fixed: `accept_remote_certificate` (singular).
- [x] 2026-11-05: Remote renamed to `kodama-lets`; `default_remote` set to it.
- [x] 2026-11-05: `.gitignore` filled in (.terraform/, tfstate, *.tfvars, crash.log). Remember to commit `.terraform.lock.hcl`.
- [x] 2026-11-05: README: private IPs, hydrogen = gateway, host names `<tier>-<4 letters>`, address ranges, atomic *number*, `.254` limit, typos.

## Decisions (don't re-suggest)

- The OpenWrt gateway is **`wrt-hydrogen`** (`.1`).
- Guest prefix = **OS** (e.g. `nix-`), not container/VM type. Tim only cares what's running inside.
- Hosts: `<shinkansen-tier>-<4-letter-id>`. Tier = form factor (nozomi desktop, hikari mini-PC, kodama laptop). No OS prefix, no counter.
- One flat subnet **`10.9.0.0/24`** (decided 2026-11-06: easy to type, and avoids OpenVPN's default `10.8.0.0/24`; README and network plan doc updated). `.1` hydrogen/OpenWrt gateway, `.2`–`.118` guests (element), `.119`–`.254` hosts and everything else.
- Long-term: move OpenWrt to a dedicated router box (Tim wants this eventually).
