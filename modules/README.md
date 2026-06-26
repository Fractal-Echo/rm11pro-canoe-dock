# Modules

This folder tracks optional modules and RedMagic tooling.

Examples:

- RedMagic Control Center.
- Nubia Toolkit.
- Device-specific helper modules.

Current local module/tool references:

```text
/mnt/e/Android/RM-11-Pro/MODULES/gpp-enable-module
/mnt/e/Android/RM-11-Pro/MODULES/gpp-enable-module.zip
/mnt/e/Android/RM-11-Pro/MODULES/v34.3-Integrity-Box-04-04-2026
/home/richtofen/android/toolbox/NubiaToolkit
/home/richtofen/android/toolbox/Redmagic-Control-Center
/home/richtofen/android/toolbox/reversa
```

The dock tracks only notes and manifests for these. Do not commit module zips,
DEX files, `.so` payloads, APKs, release keys, or build outputs here.

## Nebula Core Baseline Module

Checked: 2026-06-26

```text
source repo: /home/richtofen/.android/repositories/Droidspaces-Nebula
artifact: /home/richtofen/.android/repositories/Droidspaces-Nebula/build/module/Droidspaces-Nebula-Core-0.2.2.zip
size: 33759
sha256: ff3997868a9f24cf29a4eefbbf390184c6d6dd14aebf82478b462a557220a9b3
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
