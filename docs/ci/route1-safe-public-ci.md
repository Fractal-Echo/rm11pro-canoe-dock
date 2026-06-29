# Route 1 Safe Public CI

Date: 2026-06-15

Route 1 means public GitHub-hosted CI performs lightweight verification by
default. The OrangeFox recovery workflow also has a manual-only full-build lane
for GitHub-hosted runners. It does not run on the maintainer's machine and does
not use private paths, private keys, or private prebuilts.

## Allowed In Public Actions

- Check required docs, scripts, and lane directories exist.
- Verify recorded D2N baseline hashes.
- Run `bash -n` and ShellCheck on tracked shell scripts.
- Verify local verifier scripts are executable.
- Check packaging lanes have placeholder policy files.
- Manually sync and attempt an OrangeFox recovery build when
  `.github/workflows/orangefox-recovery-build.yml` is dispatched with
  `full_build=true`.

## Forbidden In Public Actions

- `runs-on: self-hosted`
- public PR jobs on a private workstation
- private local paths such as `<user-home>`
- secrets or tokens for build access
- automatic PR/push `repo sync`, full OrangeFox/AOSP builds, kernel builds, or
  flashing
- `adb`, `fastboot`, `dd`, or any device write action

## Full Builds

Full OrangeFox builds can run either locally with
`scripts/local-build/build-orangefox-nx809j-local.sh` or manually through
`.github/workflows/orangefox-recovery-build.yml`. GitHub-hosted runners may not
have enough disk for a full OrangeFox/AOSP sync and build; capacity failure is a
runner limit, not proof that the device tree is invalid.

The manual GitHub lane disables private Android 16 prebuilts with
`RM11_INCLUDE_ANDROID16_PREBUILTS=false` and falls back to the public AOSP AVB
test key if the RM11 validation key is absent. That makes the lane
CI-verifiable, but any image it produces remains build evidence only until
device-side boot, UI, ADB, touch, MTP, decryption, and rollback tests are
recorded.

## Current Recovery Gate

The public recovery workflow verifies the current NX809J OrangeFox build
agreement, safe artifact policy, and retained D2N rollback hashes. Old D2G/D2N
preflash verifiers and TWRP comparison helpers were removed from the public dock
because they depended on private lab trees and are no longer part of the active
GitHub build path.
