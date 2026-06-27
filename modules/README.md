# Modules

This folder tracks optional modules and RedMagic tooling.

Examples:

- RedMagic Control Center.
- Nubia Toolkit.
- ReZygisk.
- Device-specific helper modules.

Current local module/tool references:

```text
/mnt/e/Android/RM-11-Pro/MODULES/gpp-enable-module
/mnt/e/Android/RM-11-Pro/MODULES/gpp-enable-module.zip
/mnt/e/Android/RM-11-Pro/MODULES/v34.3-Integrity-Box-04-04-2026
/mnt/d/Downloads/ReZygisk-v1.0.0-rc.9-release.zip
/home/richtofen/android/toolbox/NubiaToolkit
/home/richtofen/android/toolbox/Redmagic-Control-Center
/home/richtofen/android/toolbox/reversa
```

The dock tracks only notes and manifests for these. Do not commit module zips,
DEX files, `.so` payloads, APKs, release keys, or build outputs here.

## ReZygisk Provider Artifact

Checked: 2026-06-27

```text
artifact: /mnt/d/Downloads/ReZygisk-v1.0.0-rc.9-release.zip
sha256: 5da9308aca2f1233e1b74744a86b39ab55749db352a829c7578743df6af16f4f
module id: rezygisk
name: ReZygisk
version: v1.0.0 (513-faccedf-release)
versionCode: 513
author: The PerformanC Organization
description: Standalone implementation of Zygisk.
internal sha256 sidecars: 96 checked, 0 failures
```

Use this as the standalone Zygisk provider candidate for Nebula hook-lane
testing when the normal provider path does not work. Disable Magisk built-in
Zygisk before using this module; its `service.sh` and `post-fs-data.sh` exit
when `ZYGISK_ENABLED` is already set.

## Nebula Core Baseline Module

Checked: 2026-06-27

```text
source repo: /home/richtofen/.android/repositories/Droidspaces-Nebula
artifact: /home/richtofen/.android/repositories/Droidspaces-Nebula/build/module/Droidspaces-Nebula-Core-0.2.2.zip
size: 34365
sha256: 27c6a46ff942cbf66771667128978c1ce0f16efff8b23dc95c41c3a9c0384436
module id: nebula_core
status: debug/test baseline module, not stable release
```

Current fixed-command surface:

- `integrations baseline --json`
- `display lanes --json`
- `display method-containers --json`
- `display method-profiles --json`

The module is read-first by design. Baseline status does not enable LSPosed
hooks, write fan/pump/LED/trigger/thermal nodes, disable DroidSpaces modules, or
start Proton, Wine, Steam, DXVK, or game clients.

Each module note should include:

- Version.
- Root provider used for testing.
- Required Android baseline.
- Working features.
- Broken features.
- Uninstall/rollback path.

Do not include evasion guidance.
