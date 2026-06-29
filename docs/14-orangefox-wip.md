# OrangeFox WIP

Current OrangeFox status for RM11 Pro / NX809J:

```text
build-pass / flash-pass / boot-fail history retained / rollback-pass / D2N retained baseline / GitHub validation lane added / manual full-build lane added
```

Known facts:

- The expected lunch target is `orangefox_NX809J-ap2a-eng`.
- The device tree is stored in this repo at `recovery/device/zte/sm88XX` and is
  installed into OrangeFox source at `device/nubia/NX809J`.
- `fastboot boot` is not a useful test for this output. The recovery artifact is
  a ramdisk-only recovery partition image.
- Stock and OrangeFox recovery images are Android boot image header v4
  ramdisk-only images.
- Early failed images reached build/flash evidence but did not prove boot.
- D2N remains retained baseline/rollback evidence, not a stable public release.

Current warning:

- Do not publish OrangeFox as usable.
- Do not retest obsolete failed candidates.
- Keep stock `recovery_a` rollback available before any recovery test.
- Test only one recovery slot first.
- Treat any GitHub-built image as build evidence only until device-side UI,
  touch, ADB, MTP, decryption, fastbootd, reboot, and rollback are tested.

Detailed evidence:

- [OrangeFox port notes](orangefox-port/README.md)
- [Local build lane](orangefox-port/17-local-orangefox-build-lane.md)
- [D2N baseline](orangefox-port/d2n-recovery-baseline-2026-06-15.md)
- [Recovery image forensics](orangefox-port/rm11-orangefox-image-format-forensics-2026-06-07.md)
- [AVBTEST1 comparison](orangefox-port/rm11-orangefox-avbtest1-image-format-comparison-2026-06-07.md)
