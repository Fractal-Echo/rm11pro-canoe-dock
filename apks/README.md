# APK Lane

Public CI for this lane is verifier-only for now. Future checks can validate
APK manifests, hashes, and release notes without signing or building private
apps in public Actions.

## Nebula Baseline Debug APK

Checked: 2026-06-27

```text
source repo: /home/richtofen/.android/repositories/Droidspaces-Nebula
artifact: /home/richtofen/.android/repositories/Droidspaces-Nebula/app/build/outputs/apk/debug/app-debug.apk
size: 6468816
sha256: aad9d504b5e8a41a5a7bf8718024ba631ccc97c47f2ac4e413c15eb35283e286
package: io.droidspaces.nebula
status: debug/test artifact, not stable release
```

Install order for testers:

1. Install the Nebula APK.
2. Install the matching Nebula Core module from `modules/README.md`.
3. Open Nebula and press Refresh.
4. Save the doctor/baseline report with the test result.

Nebula is the baseline control deck. It reports WayLandIE, DroidSpaces/Anland,
RedMagic, Nubia Toolkit, and PowerDeck readiness from one place. It does not
ship proprietary GameHub assets, start game clients, or enable hook/write
behavior by default.

Compatibility note: Vower WayLandIE latest is tracked as a broader-device
candidate for non-RM11Pro or lower-spec phones, but it is not the RM11 R6
sidecar proof baseline until a bounded install/launch/display proof is captured.

## Related APK References

```text
WayLandIE display MVP:
/home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/droid-workspace/waylandie-display-mvp.apk
sha256: 3c941de0915846c59725b7283cb7395be101c15b58c012383adaa85048e2faaa

DroidSpaces OSS debug with runtime binary:
/home/richtofen/.android/repositories/rm11mainassets/APK/Droidspaces-OSS-v6.3.0-debug-aarch64-runtime.apk
sha256: 5ea89687af96a0221d87c0739510cb7c5e18c682f1eb49602d849bcf485bd453
```

These APKs are referenced as local artifacts. APK payloads are not committed to
this documentation repo.
