# Bootloader Unlock

Known community path uses the ZTE/Nubia toolbox EFISP unlock flow for supported devices.

Recommended starting state:

- Android boots.
- ADB works.
- Device reports `NX809J`.
- OEM Unlocking is enabled.
- USB Debugging is enabled.
- OTA services are disabled.
- Critical partitions are backed up.

High-level flow:

1. Start from booted Android with ADB connected.
2. Run toolbox as Administrator.
3. Use the EFISP unlock option for supported devices.
4. Prefer the path where the toolbox reads device info from Android first.
5. Follow the toolbox prompts into EDL when required.
6. Do not close the toolbox during restore/cleanup.
7. Confirm bootloader unlocked state after wipe/reboot.
8. Make a second backup after unlock.

If the phone can boot Android and ADB works, avoid blind EDL-first paths.

## RM11 Pro Full-Fastboot ABL

`assets/abl_unlock.elf` is intentionally tracked as the RM11 Pro / NX809J ABL
artifact used with ZTE Toolbox to expose full fastboot access. It is a
boot-chain file, not a generic payload drop.

Recorded hash:

```text
ad3d55fb8939a88c1304ae826db200c6fbeca70229f729d80dec269924d0c9b5  abl_unlock.elf
```

Use it only for RM11 Pro / NX809J after confirming the active slot and keeping a
stock rollback path. With ZTE Toolbox, use option `12` and target only `abl_a`
or `abl_b`.
