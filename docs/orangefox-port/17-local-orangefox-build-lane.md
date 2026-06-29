# Local OrangeFox Build Lane

Date: 2026-06-19

Goal: make RM11 Pro / NX809J OrangeFox builds reproducible locally and
CI-verifiable on GitHub without private dumps, private keys, or private
workstation access.

## Inputs

- Public device-tree snapshot: `recovery/device/zte/sm88XX`
- Build-tree destination: `device/nubia/NX809J`
- Recovery patch sets: `recovery/patches/fox_14.1`
- Recovery prebuilt policy and manifests: `recovery/prebuilts`,
  `recovery/manifests`
- OrangeFox source sync helper: `scripts/orangefox-sync/orangefox_sync.sh`

## Build

```bash
scripts/local-build/build-orangefox-nx809j-local.sh --env scripts/local-build/env-orangefox-nx809j.local
```

Inside a prepared OrangeFox source tree, the expected manual build shape is:

```bash
source build/envsetup.sh
lunch orangefox_NX809J-ap2a-eng
mka recoveryimage
```

The local helper prepares the RM11 device tree inside the OrangeFox checkout,
runs the configured lunch target, builds the configured goals, and records output
hashes under `out/local-orangefox-nx809j`.

## GitHub

`.github/workflows/orangefox-recovery-build.yml` runs lightweight validation on
PRs and pushes. Its full source-sync/build job is manual-only through
`workflow_dispatch`.

The manual GitHub lane sets `RM11_INCLUDE_ANDROID16_PREBUILTS=false` and uses
the public AOSP AVB test-key fallback if the local RM11 validation key is absent.
That is suitable for CI verification, not device-use claims.

## Retained Baseline

D2N remains retained build/rollback evidence:

- `docs/orangefox-port/d2n-recovery-baseline-2026-06-15.md`
- `recovery/manifests/d2n-baseline.sha256`

The old D2G/D2N candidate verifiers and TWRP comparison helper were removed from
the public dock because they depended on private lab trees and obsolete
candidate layouts.
