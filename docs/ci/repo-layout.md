# Repository Layout

Date: 2026-06-15

This repo is the public RM11 Pro / NX809J / canoe dock. It keeps source,
evidence, scripts, and public release notes organized without depending on the
maintainer's private workstation.

## Top-Level Lanes

```text
.github/workflows/      public validation and manual OrangeFox build workflow
assets/                 flat user-facing artifacts, hashes, and release notes
anykernel3/             AnyKernel3 packaging lane and future checks
apks/                   APK packaging lane and future checks
container/              Droidspaces and Linux-container lane, paused for now
docs/                   public guides, notes, CI policy, and archives
evidence/               tracked evidence indexes, not raw private payload dumps
modules/                Magisk/KSU module lane and future checks
recovery/               OrangeFox recovery device tree, manifests, and patches
scripts/                local helpers, CI verifiers, and repo maintenance scripts
```

## Recovery Lane

```text
recovery/
  device/zte/sm88XX/        curated RM11 Pro OrangeFox device-tree snapshot
  manifests/                recovery hash manifests and baseline records
  patches/                  OrangeFox source patch sets
  prebuilts/                public prebuilt policy and hash manifests
```

The active GitHub build target is:

- Lunch target: `orangefox_NX809J-ap2a-eng`
- Device tree source: `recovery/device/zte/sm88XX`
- OrangeFox source destination: `device/nubia/NX809J`

D2N remains retained rollback/build evidence:

- Baseline note: `docs/orangefox-port/d2n-recovery-baseline-2026-06-15.md`
- Hash manifest: `recovery/manifests/d2n-baseline.sha256`

## CI Boundary

Public GitHub-hosted PR/push Actions are lightweight validation only. Manual
workflow dispatch may run the OrangeFox source sync and recovery build on a
GitHub-hosted runner.

Full recovery builds are local/fork-owner work. The documented lane is
`scripts/local-build/build-orangefox-nx809j-local.sh` with a user-owned
OrangeFox/AOSP workspace. Any built image remains build evidence until
device-side boot, UI, ADB, MTP, fastbootd, decryption, and rollback are tested.
