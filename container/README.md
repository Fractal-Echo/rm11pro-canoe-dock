# Container Lane

Droidspaces and Linux-container work is tracked separately from recovery release
work.

Current status, 2026-06-26:

```text
Anland/DroidSpaces visible proof: captured
Nebula method map: implemented in nebula-core
Nebula method profiles: implemented as read-only templates
Termux:X11 profile: rootfs image created and container started; DroidSpaces injected DISPLAY=:0; Termux:X11 loader/socket and PulseAudio socket are still missing
```

Current maintainer note:

```text
../docs/project-notes/15-droidspace-container-lane.md
```

Keep raw APKs, rootfs images, logs, and build trees local under
`/home/richtofen/.android/repositories/rm11mainassets`.

Public docs should point users to:

- `apks/README.md` for the Nebula APK and related APK hashes.
- `modules/README.md` for the Nebula Core module hash and command surface.
- `docs/project-notes/15-droidspace-container-lane.md` for detailed DroidSpaces
  evidence.
