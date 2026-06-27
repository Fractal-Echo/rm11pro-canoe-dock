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
/home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos
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
- `Fractal-Echo/WayLandIE`
- `Fractal-Echo/recovery-console`
- `Fractal-Echo/droidspaces-recovery-hack-example`

Deferred heavy repos:

- `Fractal-Echo/Droidspaces-kernel`
- `Fractal-Echo/mesa-for-android-container-rm11pro`
- `Fractal-Echo/Winlator-Ludashi-emulador-windows-acompanhar`

Reason: these are large or high-blast-radius lanes. Pull them when kernel/GPU or
recovery-boot-container experiments are intentional.

## Online Fork And Branch Leads

Checked: 2026-06-19

Fork chain:

```text
Fractal-Echo/Droidspaces-OSS -> Coding-BR/Droidspaces-OSS -> ravindu644/Droidspaces-OSS
Fractal-Echo/WayLandIE -> AstroCODEsky/WayLandIE
Fractal-Echo/recovery-console -> Coding-BR/recovery-console -> Droidspaces/recovery-console
Fractal-Echo/droidspaces-recovery-hack-example -> Coding-BR/droidspaces-recovery-hack-example -> Droidspaces/droidspaces-recovery-hack-example
Fractal-Echo/Droidspaces_Kernel_patch -> Coding-BR/Droidspaces_Kernel_patch -> Goldzxcbug/Droidspaces_Kernel_patch
```

Current Droidspaces-OSS branch signals:

```text
local main: cd95a6f Translated using Weblate (#195)
origin/main: a72fec3 Add Droidspaces support for Redmi note 7 pro (violet) (#202)
origin/dev: 899b1ae updated .gitignore and submodules
origin/ext4: 194aa4b tmp: rootfs.img improvements
origin/wayland-new: 14ad022 Translated using Weblate (#195)
```

Actionable leads:

- Fast-forwarding local `Droidspaces-OSS/main` to `origin/main` is likely useful
  before the next Android APK build. The 21 newer commits include gateway
  networking, DNS/resolv.conf fixes, deterministic container MAC generation,
  booted-config snapshot loading, and post-extraction gateway-mode service
  changes.
- `origin/ext4` is a narrow rootfs image lead. Review before relying on sparse
  ext4 or `rootfs.img` behavior.
- `origin/wayland-new` overlaps with the Wayland display bridge idea, but it is
  not a clean fast-forward from current `origin/main`. Treat it as an
  experiment branch, not an automatic merge target.
- `recovery-console` has display/input fixes on main and an `old-working`
  branch with VT/keyboard history. Useful for recovery-side inspection, not for
  launching Droidspaces from recovery.

Fork-of-fork leads checked:

- `cakroni1580/Droidspaces-OSS` default branch `wayland_test` is an active
  Wayland prototype. It adds native compositor, renderer, keyboard, IME, and
  Wayland Android UI files, but also carries backup text files and removes newer
  gateway-networking docs/components. Treat it as source material for
  display/input investigation, not a merge target.
- `Vower2993/WayLandIE` has a self-contained APK/rootfs/proot/adrenotools
  experiment. Useful to inspect for packaging ideas, but higher risk than the
  upstream `AstroCODEsky/WayLandIE` architecture because it appears to bundle
  runtime payloads.
- `Anmol6002/WayLandIE` is mostly GitHub Actions APK build workflow iteration.
  Low setup-signal value beyond CI troubleshooting.

## First Built Artifact

Droidspaces Android debug APK:

```text
/home/richtofen/.android/repositories/rm11mainassets/APK/Droidspaces-OSS-v6.3.0-debug.apk
size: 22524969
sha256: 575260b1f3a31ed0c0a05e90d52b8d461306fbd7381addeb153d68b4038817a6
```

Source:

```text
/home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/Droidspaces-OSS
commit: cd95a6fba4ad823c6bac94953cdb7ff4756fb420
date: 2026-06-10
subject: Translated using Weblate (#195)
```

Build command:

```bash
cd /home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/Droidspaces-OSS/Android
ANDROID_HOME=/home/richtofen/.android/sdk \
ANDROID_SDK_ROOT=/home/richtofen/.android/sdk \
./gradlew :app:assembleDebug --no-daemon
```

Build log:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-oss-android-debug-build-20260615.log
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

Installed test state:

```text
installed: 2026-06-15 03:11:04
package path: /data/app/~~ghw8gYWX-64MskUWFbmv2A==/com.droidspaces.app-usDPpzWHhzDs79T655nMHw==/base.apk
package flags: DEBUGGABLE HAS_CODE ALLOW_CLEAR_USER_DATA ALLOW_BACKUP
signature summary: PackageSignatures{3aecb9a version:2, signatures:[1390e72e], past signatures:[]}
```

Install log:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-oss-v6.3.0-debug-install-20260615.log
```

Installed package capture:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-oss-v6.3.0-debug-package-20260615.txt
```

Launchable activity:

```text
com.droidspaces.app/.MainActivity
```

The app has been installed, but first launch/checker/root prompt should be its
own evidence step.

## WayLandIE Display MVP APK

Local artifact:

```text
/home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/droid-workspace/waylandie-display-mvp.apk
size: 105K
sha256: 3c941de0915846c59725b7283cb7395be101c15b58c012383adaa85048e2faaa
```

Manifest:

```text
package: io.waylandie.display
versionName: 0.1.0
versionCode: 1
minSdkVersion: 33
targetSdkVersion: 36
debuggable: true
launcher: .MainActivity
secondary activity: .LinuxWindowActivity, exported=false
service: .BridgeKeepAliveService, exported=false, foregroundServiceType=dataSync
permissions: INTERNET, FOREGROUND_SERVICE, FOREGROUND_SERVICE_DATA_SYNC, POST_NOTIFICATIONS
signing: Android Debug certificate
```

Embedded bridge strings:

```text
unix abstract socket: waylandie.display.bridge.v1
package classes: io.waylandie.display
native library: lib/arm64-v8a/libwaylandie_display_native.so
probes: AHardwareBuffer, dmabuf, Vulkan, AdrenoTools, KGSL, SurfaceControl, sync fd
```

Interpretation:

This looks like a focused display/transport probe, not a full Droidspaces setup
APK. It is useful for the display lane because it tests Android-side
SurfaceControl/Vulkan/dmabuf assumptions and the Linux-to-Android bridge
contract. It should not be treated as a container manager or rootfs installer.

## Backend Install Fix

First-launch evidence:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-first-launch-20260615-031239
```

Initial Gradle-only APK failure:

```text
screen: Installation Failed
error: binaries/droidspaces-aarch64
```

Cause:

```text
The Android Gradle build packaged BusyBox assets only. Upstream CI/Nix injects
the musl-built Droidspaces runtime binaries into Android assets before final APK
packaging.
```

Fix path:

```bash
cd /home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/Droidspaces-OSS
make aarch64
cp output/droidspaces Android/app/src/main/assets/binaries/droidspaces-aarch64
cd Android
ANDROID_HOME=/home/richtofen/.android/sdk \
ANDROID_SDK_ROOT=/home/richtofen/.android/sdk \
./gradlew :app:assembleDebug --no-daemon
```

Toolchain:

```text
/home/richtofen/toolchains/aarch64-linux-musl-cross/bin/aarch64-linux-musl-gcc
version: GCC 14.2.0
source: https://github.com/ravindu644/Droidspaces-OSS/releases/download/compilers-25843896720/aarch64-linux-musl-cross.tar.zst
```

Fixed APK:

```text
/home/richtofen/.android/repositories/rm11mainassets/APK/Droidspaces-OSS-v6.3.0-debug-aarch64-runtime.apk
sha256: 5ea89687af96a0221d87c0739510cb7c5e18c682f1eb49602d849bcf485bd453
contains: assets/binaries/busybox-aarch64
contains: assets/binaries/droidspaces-aarch64
```

Runtime binary:

```text
local build: /home/richtofen/.android/repositories/rm11mainassets/projects/droidspace-repos/Droidspaces-OSS/output/droidspaces
sha256: 98083c45ab161a675c4c647993a1fadd29459025e0778448bc426686d7435215
type: ELF 64-bit LSB executable, ARM aarch64, statically linked, stripped
```

Installed backend after fixed APK:

```text
/data/local/Droidspaces/bin/droidspaces
sha256: 98083c45ab161a675c4c647993a1fadd29459025e0778448bc426686d7435215

/data/local/Droidspaces/bin/busybox
sha256: 66209775327d12294acacfeb7ead3a0ef704aa1c5520106070b0cf5e39b6e407

/data/adb/modules/droidspaces
module: Droidspaces: Daemon & Init
daemon_mode: 1
```

Post-boot verification:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-first-launch-20260615-031239/postboot-20260615-033041
```

Observed:

```text
module description: Daemon: green/running (PID 1567) | Containers: 0 started, 0 failed
processes: droidspaces PID 1567 and child PID 1568
droidspaces version: v6.3.0
droidspaces check: All required features found
app UI: Home, 0 containers, 0 running
```

Known caveat:

```text
service.sh reported network not ready after 25s and proceeded anyway. This is
not blocking for backend install, but the first container networking test should
capture routing and DNS explicitly.
```

## First Minimal Rootfs

Evidence:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspaces-minrootfs-alpine-20260615-20260615-033936
```

Container:

```text
name: rm11-alpine-min
rootfs mode: sparse ext4 image
image path: /data/local/Droidspaces/Containers/rm11-alpine-min/rootfs.img
image size: 4G
network mode: host
run_at_boot: 0
final state: stopped
```

Rootfs source:

```text
Alpine Linux 3.22 ARM64 default LXC rootfs
source: https://images.linuxcontainers.org/images/alpine/3.22/arm64/default/20260614_13%3A00/rootfs.tar.xz
sha256: 0d392a9e0743e3e5282adeede36d7ad8959c891a1e99e2eff33a0e2f70a555c6
local: /home/richtofen/.android/repositories/rm11mainassets/rootfs/alpine-3.22-arm64-default-20260614-rootfs.tar.xz
```

Lifecycle result:

```text
droidspaces --conf=/data/local/Droidspaces/Containers/rm11-alpine-min/container.config start
started PID: 10804
monitor PID: 10802
container OS: Alpine Linux v3.22
apk-tools: 2.14.9, compiled for aarch64
droidspaces --name=rm11-alpine-min stop
pid after stop: NONE
```

App visibility:

```text
Containers tab lists rm11-alpine-min as STOPPED, Host, 4GB.
```

Network caveat:

```text
Container ping failed with "Network unreachable".
Host Android also had no default route at probe time:
adb shell ip route get 1.1.1.1 => RTNETLINK answers: Network is unreachable
wlan0 was down; rmnet_data0 had link-local IPv6 only.

Conclusion: network remains untested until the host has Wi-Fi or mobile data
with a default route.
```

## Droidspaces Bridge And Gamescope Proof

Evidence:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/rm11-droidspaces-bridge-gamescope-durable-proof-20260619.md
```

Goal:

```text
Make the proven Droidspaces Android bridge fd path durable enough for
recovery-style reuse, then verify direct Wayland and gamescope Wayland-child
presentation through the Android bridge.
```

Durable changes captured in evidence:

- Installed KernelSU module `rm11-droidspace-bridge-fd`.
- Persisted SELinux policy rule: `allow untrusted_app droidspacesd fd use`.
- Recreated container `/dev/shm` with mode `1777`.
- Updated the future packaged Droidspaces module source at
  `/home/richtofen/.android/repositories/root-repos/RM11Plus_KernelSU_SUSFS/vendor/droidspaces-module/sepolicy.rule`.
- Updated the gamescope probe harness so a gamescope abort only counts as pass
  after independent graphics proof lines are present.

Container under proof:

```text
name: rm11-alpine-324-turnip
native Droidspaces autoboot: run_at_boot=1
graphics session helper: /data/local/Droidspaces/rm11-graphics-session-start.sh
bridge activity: com.codex.steamdisplay/.MainActivity
```

Verified graphics paths:

```text
syncfd-test: pass
kgsl-import-probe: pass
dmabuf-import-probe: pass
AHardwareBuffer export/present/ring: pass
direct Wayland vkcube: pass, zero-copy=dmabuf-present
gamescope Wayland-child: pass, zero-copy=dmabuf-present
fallback render node: /dev/dri/renderD128
```

Post-reboot validation:

```text
KSU module active: enabled=true, update=false
module service reran after boot
/dev/shm present as drwxrwxrwt
Droidspaces native boot module started rm11-alpine-324-turnip
bridge diagnostics passed after waking/unlocking and focusing bridge activity
direct vkcube and gamescope Wayland-child proof passed again
```

Known limits:

- The bridge APK remains in Android's shared `untrusted_app` domain, so the fd
  rule is broader than package-specific policy.
- Bridge AHB present/ring checks require the bridge activity focused and the
  keyguard out of the way.
- The helper script can recover focus and start/check the container, but it is
  invoked with `sh` because chmod executable was denied under the current
  root/SELinux context.
- The synthetic `fdtest` memfd probe still reports `received=0`; graphics fd
  paths pass independently through eventfd, dma-buf import, AHB, direct vkcube,
  and gamescope.

Next independent check:

```text
Reboot normally, run:
sh /data/local/Droidspaces/rm11-graphics-session-start.sh

Then rerun the bridge diagnostics, direct vkcube, and gamescope proof scripts
listed in the durable proof evidence file.
```

## Nebula Baseline And Method Profiles

Checked: 2026-06-27

Nebula now owns the baseline APK/module coordination layer for the RM11 Pro
container/display work:

```text
APK:
/home/richtofen/.android/repositories/Droidspaces-Nebula/app/build/outputs/apk/debug/app-debug.apk
size: 6468816
sha256: aad9d504b5e8a41a5a7bf8718024ba631ccc97c47f2ac4e413c15eb35283e286

Core module:
/home/richtofen/.android/repositories/Droidspaces-Nebula/build/module/Droidspaces-Nebula-Core-0.2.2.zip
size: 34365
sha256: 27c6a46ff942cbf66771667128978c1ce0f16efff8b23dc95c41c3a9c0384436
```

Current Nebula Core command surface:

```sh
su -c '/data/adb/modules/nebula_core/bin/nebula-core integrations baseline --json'
su -c '/data/adb/modules/nebula_core/bin/nebula-core display lanes --json'
su -c '/data/adb/modules/nebula_core/bin/nebula-core display method-containers --json'
su -c '/data/adb/modules/nebula_core/bin/nebula-core display method-profiles --json'
```

`method-containers` reports the available display/container methods:

- Phone/App WayLandIE bridge.
- Anland surface mode.
- DroidSpaces rootfs image and rootfs directory modes.
- DroidSpaces Termux:X11, VirGL, Turnip/KGSL, llvmpipe, and PulseAudio modes.
- Dock lease, compatibility/software, and recovery/safe references.

`method-profiles` emits read-only DroidSpaces templates for Anland, Termux:X11,
VirGL, Turnip/KGSL, llvmpipe, and PulseAudio. Each profile uses its own
container directory and rootfs path so methods can be tested independently
instead of rewriting one daily container in place.

Live evidence:

```text
Anland visible proof:
/home/richtofen/.android/repositories/nebula-assets/logs/2026-06-26-anland-droidspaces-wayland-visible-02/result.md
classification: NEBULA_R6_ANLAND_DROIDSPACES_WAYLAND_VISIBLE
proof PNG sha256: c3682662cf486423a09c569ecd5b2ef82be857b8cdf0361f08f752efebd6cc79

DroidSpaces method profile materialization:
/home/richtofen/.android/repositories/nebula-assets/logs/2026-06-26-droidspaces-method-profiles-01/result.md
classification: NEBULA_R6_DROIDSPACES_TERMUX_X11_PROFILE_STARTED_SOCKET_BRIDGE_MISSING
```

Current caveat:

```text
Termux:X11 rootfs creation and container start are proven. The profile is not a
display pass yet because DroidSpaces reported missing Termux:X11 loader/socket
and PulseAudio socket. Live env showed DISPLAY=:0 and
PULSE_SERVER=unix:/tmp/.pulse-socket.
```

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

This was the baseline order before the June 19 bridge/gamescope proof. Keep it
as the historical safety sequence for rebuilding the lane from a clean device.

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

## Baseline Evidence Captured

Captured baseline:

```text
/home/richtofen/.android/repositories/rm11mainassets/recovery-forensics/droidspace-android-baseline-20260615-030857/summary.txt
```

Command class:

```text
read-only adb/getprop/su/proc-config/package inventory after rebooting from D2N recovery into Android
```

Observed Android state:

```text
ro.product.device=NX809J
ro.product.model=NX809J
ro.build.fingerprint=REDMAGIC/NX809J-UN/NX809J:16/BQ2A.250705.001-BP2A.250605.031.A3/20260204.221606:user/release-keys
ro.build.version.release=16
ro.build.version.sdk=36
ro.boot.slot_suffix=_a
ro.crypto.state=encrypted
ro.crypto.type=file
ro.boot.verifiedbootstate=orange
ro.boot.flash.locked=0
ro.boot.vbmeta.device_state=unlocked
sys.boot_completed=1
```

Kernel/root:

```text
Linux localhost 6.12.23-android16-OP-WILD #1 SMP PREEMPT Sat Jun  6 15:12:15 UTC 2026 aarch64 Toybox
adb shell id: uid=2000(shell)
su -c id: uid=0(root) gid=0(root) context=u:r:ksu:s0
SELinux: Enforcing
```

Package focus:

```text
No Droidspaces, Termux, Termux:X11, KernelSU Manager, Magisk, APatch, LSPosed,
Zygisk, Winlator, or VirtualAP package matched the package-focus grep at capture
time.
```

Kernel config hits:

```text
CONFIG_SYSVIPC=y
CONFIG_POSIX_MQUEUE=y
CONFIG_CGROUPS=y
CONFIG_MEMCG=y
CONFIG_MEMCG_V1=y
CONFIG_NAMESPACES=y
CONFIG_UTS_NS=y
CONFIG_IPC_NS=y
CONFIG_PID_NS=y
CONFIG_SECCOMP=y
CONFIG_SECCOMP_FILTER=y
CONFIG_NETFILTER=y
CONFIG_NETFILTER_XT_MATCH_ADDRTYPE=y
CONFIG_NETFILTER_XT_MATCH_RECENT=y
CONFIG_IP_SET=y
CONFIG_DEVTMPFS=y
CONFIG_NTSYNC=y
```

Kernel config caveats:

```text
# CONFIG_CGROUP_PIDS is not set
# CONFIG_CGROUP_DEVICE is not set
# CONFIG_USER_NS is not set
# CONFIG_DEVTMPFS_MOUNT is not set
```

Interpretation:

- Root and Android-side capture path work.
- SELinux is enforcing, so policy denials should be expected and captured
  instead of papered over.
- Core namespace and IPC requirements are present.
- The missing cgroup/user namespace options may affect Docker/nested-container
  or stricter Droidspaces modes, but the real verdict should come from the
  Droidspaces checker before any rootfs import.
- APK install completed. Later evidence in this note supersedes the original
  next action by capturing first launch, backend install, rootfs lifecycle,
  bridge fd policy, graphics proof, and native autoboot.

Useful command template:

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
