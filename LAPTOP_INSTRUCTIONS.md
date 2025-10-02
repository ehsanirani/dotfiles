# Instructions for Laptop Setup

## Background
Two issues were fixed in the dotfiles:
1. Added fast home-manager rebuilds (no sudo needed for user config changes)
2. Fixed SSH key circular dependency causing rebuild errors

## Steps to Complete on Laptop

### 1. Pull the latest changes
```bash
cd ~/dotfiles
git pull
```

### 2. Get your laptop's host SSH public key
```bash
sudo cat /etc/ssh/ssh_host_ed25519_key.pub
```
Copy the output (starts with `ssh-ed25519 AAAA...`)

### 3. Update secrets configuration
Edit `secrets/secrets.nix` and replace the existing public key with your **host** public key from step 2:

```nix
{
  "id_ed25519.age".publicKeys = [
    "ssh-ed25519 AAAA... root@laptop-dell"  # <- paste your host key here
  ];
}
```

### 4. Re-encrypt the secret with the host key
```bash
cd ~/dotfiles
agenix -r -e secrets/id_ed25519.age
```
This will open your editor - just save and exit (no changes needed to the content).

### 5. Test the full system rebuild
```bash
sudo nixos-rebuild switch --flake .#laptop-dell
```
This should now work **without SSH key errors**.

### 6. Commit the re-encrypted secret
```bash
git add secrets/id_ed25519.age secrets/secrets.nix
git commit -m "Re-encrypt secret with host key"
git push
```

## Usage Going Forward

### Fast user-level rebuilds (packages, dotfiles, programs)
After editing `home/ehsan.nix`:
```bash
home-manager switch --flake .#ehsan@laptop-dell
```
⚡ Takes ~10 seconds, no sudo needed

### Full system rebuild (networking, boot, services)
After editing `hosts/laptop-dell.nix`:
```bash
sudo nixos-rebuild switch --flake .#laptop-dell
```
Takes longer, requires sudo

## What Changed

### flake.nix
- Added `homeConfigurations` section for standalone home-manager rebuilds

### hosts/laptop-dell.nix
- Changed `age.identityPaths` from user key to host key
- This breaks the circular dependency (agenix needing a key that agenix itself decrypts)
