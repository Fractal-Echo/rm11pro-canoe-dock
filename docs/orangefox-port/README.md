# OrangeFox Port Notes

This folder tracks current RM11 Pro / REDMAGIC 11 Pro / NX809J OrangeFox
recovery evidence. Obsolete RM10/TWRP reference-tree notes, dead-end candidate
diffs, and private-lab verifier scripts were removed from the public dock.

## Current Build Lane

- Device tree source in this repo: `recovery/device/zte/sm88XX`
- Build-tree destination: `device/nubia/NX809J`
- Lunch target: `orangefox_NX809J-ap2a-eng`
- Platform identity: `canoe` product, `sm8850` board, `oryon` runtime CPU
- Local build helper: `scripts/local-build/build-orangefox-nx809j-local.sh`
- GitHub validation/build workflow: `.github/workflows/orangefox-recovery-build.yml`

Expected local build shape:

```bash
source build/envsetup.sh
lunch orangefox_NX809J-ap2a-eng
mka recoveryimage
```

## Retained Evidence

- `17-local-orangefox-build-lane.md`: current local/GitHub build lane.
- `d2n-recovery-baseline-2026-06-15.md`: retained D2N baseline and rollback
  evidence.
- `rm11-orangefox-build-pass-2026-06-07.md`: initial build-pass evidence.
- `rm11-orangefox-flash-pass-boot-fail-rollback-pass-2026-06-07.md`: early
  flash-pass / boot-fail / rollback-pass evidence.
- `rm11-orangefox-image-format-forensics-2026-06-07.md`: stock versus
  OrangeFox image/header/AVB facts.
- `rm11-orangefox-avbtest1-image-format-comparison-2026-06-07.md`: AVB footer
  correction evidence.
- `rm11-live-adb-baseline.md`: live Android baseline.
- `rm11-post-ksun-adb-sanity.md`: post-root Android sanity.
- `recovery-forensics-manifest.md`: local-only raw forensics policy.

## Safety Rules

- Do not label this recovery stable or broadly usable.
- Keep stock recovery rollback ready before device-side tests.
- Test one recovery slot first.
- Do not flash obsolete RM10/TWRP reference artifacts from this repo.
- Keep raw images, logs, dumps, and private prebuilts out of git.
