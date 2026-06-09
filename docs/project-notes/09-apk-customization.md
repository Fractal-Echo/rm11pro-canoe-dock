# APK Customization

## Status

The scanned notes and assets contain APK/tool references, but not enough direct RM11-specific APK customization evidence to promote as an active lane.

Known APK/tool assets:

- `/mnt/e/Android/RM-11-Pro/Tools/ToolBox1.2.1-beta4/Magisk29.0.apk`
- `/mnt/e/Android/RM-11-Pro/Tools/toolv1.2.6-beta2/Magisk29.0.apk`
- ZTE Family Toolbox 1.2.7 folder under `/mnt/e/Android/RM-11-Pro/Tools/`
- `/mnt/e/Android/RM-11-Pro/MODULES/v34.3-Integrity-Box-04-04-2026/`

## Useful Boundary

APK customization should stay separate from:

- root install.
- kernel testing.
- recovery testing.
- GSI validation.

If an APK is modified, record:

- original APK path and hash.
- modified APK path and hash.
- package name.
- signature handling.
- install method.
- required root provider.
- rollback/uninstall path.
- features tested.

## Current Recommendation

No APK customization action now.

Keep tools as assets. Promote only installation/compatibility facts that are directly useful for RM11 access, root, or validation.

## What Helps Canoe Dock

Promote:

- exact tool/app versions used for validation.
- root manager version.
- RM11-specific compatibility notes.

Do not promote:

- cracked/unknown APK modifications.
- app bypass guidance.
- generic APKTool/JADX notes without RM11 result.
