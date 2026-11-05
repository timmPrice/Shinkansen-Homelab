# Homelab: Open Recommendations

Claude keeps this list of recommendations. Check it at the start of each session.
Status: **ready** = can do now · **blocked** = waiting on something · **done** = finished (keep a short note)

## Ready

- [ ] **Fill in `.gitignore`.** It exists but is empty. Do this before the first `terraform init` or apply in the repo:
  ```
  .terraform/
  *.tfstate
  *.tfstate.*
  *.tfvars
  crash.log
  ```
  Do commit `.terraform.lock.hcl`.
- [ ] **Move the Incus trust token out of `main.tf`.** Use a `sensitive = true` variable read from a gitignored `*.tfvars` or `TF_VAR_incus_token`. It's one-time use, so it can be removed once the client cert is trusted.
- [ ] **Optional:** guest example `lxc-carbon` doesn't follow the OS-prefix rule (`lxc` is an instance type). Something like `deb-carbon` would. Only if Tim wants it.
- [ ] **Optional:** explain the `ln-` folder prefix (`ln-incus`) in the README.

## Blocked

- [ ] **`ln-incus/main.tf`: real remote address.** Blocked: `kodama-lets` has no address yet.
  - Set `address` (`"https://<ip-or-tailscale-name>:8443"`); a Tailscale MagicDNS name could work.
  - Change `default_remote` from `"local"` to `"kodama-lets"`, or resources go to the machine running Terraform.
- [ ] **Tailscale on `kodama-lets`.** Blocked: server setup. Afterwards, decide whether Terraform and admin traffic use Tailscale names or LAN IPs.
- [ ] **Router DHCP pool limited to `192.168.0.119`–`.254`.** Blocked: no router access for a few months.
  - Until then: if a guest's element IP is already taken, rename the guest (Tim's chosen workaround).
- [ ] **Guest networking in Incus.** Blocked: host setup. Guests must be on the LAN (`192.168.0.0/24`) for element = last octet to work. That needs a bridged or macvlan NIC, not the default NAT `incusbr0`. Give each guest a static `ipv4.address` matching its element.
- [ ] **First Incus resources in Terraform.** Blocked: on the remote above. Include an element-to-IP map in `locals`. The instance name becomes the hostname automatically.

## Done

- [x] 2026-11-05: Neovim terraform-ls confirmed working. It looked dead because there were no providers or `terraform init` yet.
- [x] 2026-11-05: Provider attribute fixed: `accept_remote_certificate` (singular).
- [x] 2026-11-05: Remote renamed to `kodama-lets`.
- [x] 2026-11-05: README: private IPs, hydrogen = gateway, host names `<tier>-<4 letters>`, address ranges, atomic *number*, `.254` limit, typos.

## Decisions (don't re-suggest)

- Guest prefix = **OS** (e.g. `nix-`), not container/VM type. Tim only cares what's running inside.
- Hosts: `<shinkansen-tier>-<4-letter-id>`. Tier = form factor (nozomi desktop, hikari mini-PC, kodama laptop). No OS prefix, no counter.
- One flat subnet `192.168.0.0/24`: `.1` hydrogen/gateway, `.2`–`.118` guests (element), `.119`–`.254` hosts and everything else.
