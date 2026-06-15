# Droidspace Container Lane

Date: 2026-06-15

This note starts the post-recovery Droidspace/Linux-container lane for RM11 Pro
/ NX809J. D2N OrangeFox is now the recovery baseline, so container work can move
out of recovery triage and into its own evidence stream.

Raw clones, APKs, and build logs stay local under `/home/richtofen/.android`.
The dock records reproducible commands, hashes, and risk boundaries only.

## Goal

Build toward a Steam Deck-like or alternate Windows-capable handheld workflow on
RM11 Pro:

1. Linux containers with usable shell, package manager, and rootfs management.
2. X11/display/input/audio proof.
3. GPU acceleration path for Adreno/Turnip or VirGL.
4. Windows app lane through Winlator/Box64 after the Linux base is stable.
5. Networking lane through VirtualAP only after rollback and routing safety are
   clear.

## Core Repos Synced

Synced into:

```text
/home/richtofen/.android/repositories/droidspace-core
```

Command:

```bash
scripts/repo/sync-droidspace-core.sh
```

Sync behavior:

- Clone missing repos.
- Fetch existing repos.
- Do not pull, merge, reset, clean, or build.

Cloned/fetched core set:

- `Fractal-Echo/Droidspaces-OSS`
- `Fractal-Echo/Droidspaces-rootfs-KDE-builder`
- `Fractal-Echo/Droidspaces_Kernel_patch`
- `Fractal-Echo/busybox-droidspaces`
- `Fractal-Echo/toybox-droidspaces`
- `Fractal-Echo/socketd`
- `Fractal-Echo/webui`
- `Fractal-Echo/linuxcontainers-mirror`
- `Fractal-Echo/VirtualAP`
- `Fractal-Echo/termux-app`
- `Fractal-Echo/termux-x11`

Deferred heavy repos:

- `Fractal-Echo/Droidspaces-kernel`
- `Fractal-Echo/mesa-for-android-container-rm11pro`
- `Fractal-Echo/Winlator-Ludashi-emulador-windows-acompanhar`
- `Fractal-Echo/droidspaces-recovery-hack-example`

Reason: these are large or high-blast-radius lanes. Pull them when kernel/GPU or
recovery-boot-container experiments are intentional.

## First Built Artifact

Droidspaces Android debug APK:

```text
/home/richtofen/.android/repositories/MainAssets/APK/Droidspaces-OSS-v6.3.0-debug.apk
size: 22524969
sha256: 575260b1f3a31ed0c0a05e90d52b8d461306fbd7381addeb153d68b4038817a6
```

Source:

```text
/home/richtofen/.android/repositories/droidspace-core/Droidspaces-OSS
commit: cd95a6fba4ad823c6bac94953cdb7ff4756fb420
date: 2026-06-10
subject: Translated using Weblate (#195)
```

Build command:

```bash
cd /home/richtofen/.android/repositories/droidspace-core/Droidspaces-OSS/Android
ANDROID_HOME=/home/richtofen/.android/sdk \
ANDROID_SDK_ROOT=/home/richtofen/.android/sdk \
./gradlew :app:assembleDebug --no-daemon
```

Build log:

```text
/home/richtofen/.android/repositories/MainAssets/recovery-forensics/droidspaces-oss-android-debug-build-20260615.log
```

APK metadata:

```text
package: com.droidspaces.app
versionName: 6.3.0
versionCode: 6300
compileSdkVersion: 34
minSdkVersion: 26
targetSdkVersion: 34
```

Signing mode:

```text
debug-signed with /home/richtofen/.android/debug.keystore
```

This APK is an install/test artifact, not a public release artifact.

## Mechanism Notes

Droidspaces is not just a launcher. It relies on Linux namespaces, cgroups,
seccomp behavior, device nodes, network plumbing, SELinux policy, and optional
GPU/audio bridges.

Relevant requirements from the synced docs:

- Kernel namespace and IPC support are mandatory.
- `CONFIG_SYSVIPC`, `CONFIG_POSIX_MQUEUE`, `CONFIG_PID_NS`,
  `CONFIG_IPC_NS`, and `CONFIG_DEVTMPFS` are central checks.
- Droidspaces >= `v5.9.5` on GKI 6.12 mainly points at the Android 16 / 6.12
  patch path rather than the full older-kernel patch stack.
- KDE rootfs GPU mode expects Droidspaces GPU access plus Termux:X11.
- The rootfs builder explicitly calls out Qualcomm/Adreno Mesa support, but
  that should wait for the Mesa/container GPU lane.

## Recommended Test Order

1. Reboot from D2N recovery back into Android and collect a clean Android state
   snapshot.
2. Install the debug Droidspaces APK only after verifying root manager state and
   current kernel config.
3. Run Droidspaces built-in checker first. Do not import rootfs yet.
4. If checker fails, classify failure as kernel config, SELinux, seccomp,
   cgroup, namespace, or device-node gap.
5. If checker passes, import a minimal/rootfs first, not KDE.
6. Add Termux:X11 and display test.
7. Add audio test.
8. Add GPU test.
9. Only then evaluate KDE rootfs, Mesa, Winlator, VirtualAP, and Windows app
   workflows.

## Do Not Mix

Keep these lanes separate:

- recovery flashing,
- kernel/AnyKernel flashing,
- root manager changes,
- Droidspaces APK install,
- rootfs import,
- Termux:X11 display test,
- GPU/Mesa/Turnip testing,
- VirtualAP routing,
- Winlator/Windows app testing.

One lane, one evidence folder, one rollback path.

## Next Evidence To Collect

After booting Android:

```bash
adb shell uname -a
adb shell getprop ro.build.fingerprint
adb shell getprop ro.boot.slot_suffix
adb shell getprop ro.crypto.state
adb shell getprop ro.boot.verifiedbootstate
adb shell su -c id
adb shell su -c 'zcat /proc/config.gz | grep -E "CONFIG_(SYSVIPC|POSIX_MQUEUE|NAMESPACES|PID_NS|IPC_NS|UTS_NS|USER_NS|CGROUPS|CGROUP_DEVICE|CGROUP_PIDS|MEMCG|DEVTMPFS|SECCOMP|SECCOMP_FILTER|NETFILTER|IP_SET|NTSYNC)"'
adb shell su -c getenforce
adb shell pm list packages | grep -Ei 'droidspaces|termux|x11|kernelsu|magisk|apatch'
```

Save the output under a new local evidence folder before installing or changing
anything.
