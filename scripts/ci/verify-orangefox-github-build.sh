#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
DEVICE_TREE="recovery/device/zte/sm88XX"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'PASS: %s\n' "$*"
}

need_file() {
  [ -f "$REPO_ROOT/$1" ] || fail "missing file: $1"
  pass "file exists: $1"
}

contains_literal() {
  local file="$1"
  local text="$2"
  grep -Fq "$text" "$REPO_ROOT/$file" || fail "missing expected text in $file: $text"
  pass "$file contains: $text"
}

reject_regex() {
  local label="$1"
  local pattern="$2"
  shift 2
  if grep -n -E "$pattern" "$@" >/tmp/rm11-orangefox-verify-hit.txt 2>/dev/null; then
    sed -n '1,80p' /tmp/rm11-orangefox-verify-hit.txt >&2
    fail "$label"
  fi
  pass "$label absent"
}

is_forbidden_tracked_path() {
  local path="$1"
  local lower
  lower="$(printf '%s' "$path" | tr '[:upper:]' '[:lower:]')"

  if [ "$lower" = "assets/abl_unlock.elf" ]; then
    return 1
  fi

  case "$lower" in
    out/*|.repo/*|*/.repo/*|payloads/*|*/payloads/*|payload-dumps/*|*/payload-dumps/*|payload_dumps/*|*/payload_dumps/*)
      return 0
      ;;
    edl/*|*/edl/*|edl-dumps/*|*/edl-dumps/*|edl_dumps/*|*/edl_dumps/*)
      return 0
      ;;
    raw-partition-backups/*|*/raw-partition-backups/*|raw_partition_backups/*|*/raw_partition_backups/*|partition-backups/*|*/partition-backups/*)
      return 0
      ;;
    private/*|*/private/*|secrets/*|*/secrets/*|tokens/*|*/tokens/*|personal-logs/*|*/personal-logs/*|logs/*|*/logs/*)
      return 0
      ;;
  esac

  case "$lower" in
    *.img|*.bin|*.elf|*.mbn|*.zip|*.7z|*.rar|*.tar|*.tar.*|*.log|*.raw|*.dump|*.bak|*.backup)
      return 0
      ;;
    *.apk|*.apex|*.so|*.ko|*.pem|*.pk8|*.key|*.p12|*.jks|*.keystore|*.token|*.secret)
      return 0
      ;;
    *id_rsa*|*id_ed25519*|*token*|*secret*)
      return 0
      ;;
  esac

  return 1
}

cd "$REPO_ROOT"

for file in \
  .gitignore \
  .github/workflows/orangefox-recovery-build.yml \
  "$DEVICE_TREE/AndroidProducts.mk" \
  "$DEVICE_TREE/orangefox_NX809J.mk" \
  "$DEVICE_TREE/BoardConfig.mk" \
  "$DEVICE_TREE/device.mk" \
  "$DEVICE_TREE/recovery.fstab" \
  "$DEVICE_TREE/recovery/root/init.recovery.qcom.rc" \
  "$DEVICE_TREE/recovery/root/init.recovery.usb.rc" \
  "$DEVICE_TREE/recovery/root/init.recovery.wifi.rc" \
  "$DEVICE_TREE/recovery/root/vendor/etc/vintf/manifest.xml" \
  assets/README.md \
  assets/abl_unlock.elf \
  assets/abl_unlock.sha256 \
  scripts/ci/verify-orangefox-github-build.sh \
  scripts/ci/verify-recovery-route1.sh \
  scripts/local-build/build-orangefox-nx809j-local.sh \
  scripts/local-build/env-orangefox-nx809j.example \
  scripts/orangefox-sync/orangefox_sync.sh
do
  need_file "$file"
done

contains_literal "$DEVICE_TREE/AndroidProducts.mk" '$(LOCAL_DIR)/orangefox_NX809J.mk'
contains_literal "$DEVICE_TREE/AndroidProducts.mk" 'orangefox_NX809J-ap2a-eng'
contains_literal "$DEVICE_TREE/orangefox_NX809J.mk" 'DEVICE_PATH := device/nubia/NX809J'
contains_literal "$DEVICE_TREE/orangefox_NX809J.mk" 'PRODUCT_DEVICE := NX809J'
contains_literal "$DEVICE_TREE/orangefox_NX809J.mk" 'PRODUCT_NAME := orangefox_NX809J'
contains_literal "$DEVICE_TREE/orangefox_NX809J.mk" 'PRODUCT_MODEL := REDMAGIC 11 Pro'

contains_literal "$DEVICE_TREE/BoardConfig.mk" 'DEVICE_PATH := device/nubia/NX809J'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'PRODUCT_PLATFORM := canoe'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'TARGET_BOOTLOADER_BOARD_NAME := canoe'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'TARGET_BOARD_PLATFORM := sm8850'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'TARGET_CPU_VARIANT_RUNTIME := oryon'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'BOARD_BOOT_HEADER_VERSION := 4'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'BOARD_RECOVERYIMAGE_PARTITION_SIZE := 104857600'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'BOARD_EXCLUDE_KERNEL_FROM_RECOVERY_IMAGE := true'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/recovery.fstab'
contains_literal "$DEVICE_TREE/BoardConfig.mk" 'external/avb/test/data/testkey_rsa4096.pem'

contains_literal "$DEVICE_TREE/device.mk" '$(DEVICE_PATH)/recovery.fstab:$(TARGET_COPY_OUT_RECOVERY)/root/system/etc/recovery.fstab'
contains_literal "$DEVICE_TREE/device.mk" '$(DEVICE_PATH)/recovery.fstab:$(TARGET_VENDOR_RAMDISK_OUT)/first_stage_ramdisk/fstab.qcom'
contains_literal "$DEVICE_TREE/device.mk" '$(DEVICE_PATH)/recovery/root/init.recovery.qcom.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.qcom.rc'
contains_literal "$DEVICE_TREE/device.mk" '$(DEVICE_PATH)/recovery/root/init.recovery.usb.rc:$(TARGET_COPY_OUT_RECOVERY)/root/init.recovery.usb.rc'
contains_literal "$DEVICE_TREE/device.mk" '$(DEVICE_PATH)/recovery/root/vendor/etc/vintf/manifest.xml:$(TARGET_COPY_OUT_RECOVERY)/root/vendor/etc/vintf/manifest.xml'
contains_literal "$DEVICE_TREE/device.mk" 'RM11_INCLUDE_ANDROID16_PREBUILTS'

contains_literal scripts/local-build/build-orangefox-nx809j-local.sh 'DEVICE_TREE_DEST_REL:=device/nubia/NX809J'
contains_literal scripts/local-build/env-orangefox-nx809j.example 'DEVICE_TREE_DEST_REL="device/nubia/NX809J"'

contains_literal .github/workflows/orangefox-recovery-build.yml 'workflow_dispatch:'
contains_literal .github/workflows/orangefox-recovery-build.yml 'orangefox_NX809J-ap2a-eng'
contains_literal .github/workflows/orangefox-recovery-build.yml 'RM11_INCLUDE_ANDROID16_PREBUILTS=false'
contains_literal .github/workflows/orangefox-recovery-build.yml 'scripts/local-build/build-orangefox-nx809j-local.sh'
contains_literal assets/abl_unlock.sha256 'ad3d55fb8939a88c1304ae826db200c6fbeca70229f729d80dec269924d0c9b5  abl_unlock.elf'

actual_abl_sha="$(sha256sum assets/abl_unlock.elf | awk '{print $1}')"
[ "$actual_abl_sha" = "ad3d55fb8939a88c1304ae826db200c6fbeca70229f729d80dec269924d0c9b5" ] || fail "abl_unlock.elf SHA-256 mismatch: $actual_abl_sha"
pass 'abl_unlock.elf SHA-256 matches manifest'

critical_files=(
  "$DEVICE_TREE/AndroidProducts.mk"
  "$DEVICE_TREE/orangefox_NX809J.mk"
  "$DEVICE_TREE/BoardConfig.mk"
  "$DEVICE_TREE/device.mk"
  "$DEVICE_TREE/recovery.fstab"
  "$DEVICE_TREE/system.prop"
  "$DEVICE_TREE/recovery/root/init.recovery.qcom.rc"
  "$DEVICE_TREE/recovery/root/init.recovery.usb.rc"
  "$DEVICE_TREE/recovery/root/init.recovery.wifi.rc"
)

reject_regex 'stale RM10/build identity in active build files' 'RM10|rm10|REDMAGIC 10|sm8550|NX769|NX729' "${critical_files[@]}"
reject_regex 'workflow release mutation' 'gh release|git push --force|contents:[[:space:]]*write|secrets\.' .github/workflows/orangefox-recovery-build.yml
reject_regex 'device-write commands in workflow' '(^|[[:space:]])(adb|fastboot)([[:space:]]|$)|(^|[[:space:]])dd[[:space:]]+if=' .github/workflows/orangefox-recovery-build.yml

while IFS= read -r -d '' path; do
  if is_forbidden_tracked_path "$path"; then
    fail "forbidden tracked artifact/path: $path"
  fi
done < <(git ls-files -z)
pass 'no forbidden tracked artifacts or private paths'

git diff --check
git diff --cached --check
pass 'git diff --check passed for working tree and index'

bash_syntax_scripts=(
  scripts/ci/verify-recovery-route1.sh
  scripts/ci/verify-orangefox-github-build.sh
  scripts/local-build/build-orangefox-nx809j-local.sh
  scripts/orangefox-sync/orangefox_sync.sh
)

while IFS= read -r script; do
  bash_syntax_scripts+=("$script")
done < <(find scripts/recovery -maxdepth 1 -type f -name '*.sh' | sort)

for script in "${bash_syntax_scripts[@]}"; do
  bash -n "$script"
  pass "bash syntax ok: $script"
done

shellcheck_scripts=(
  scripts/ci/verify-recovery-route1.sh
  scripts/ci/verify-orangefox-github-build.sh
  scripts/local-build/build-orangefox-nx809j-local.sh
)

if command -v shellcheck >/dev/null 2>&1; then
  shellcheck -S warning "${shellcheck_scripts[@]}"
  pass 'shellcheck passed for maintained shell scripts'
else
  printf 'WARN: shellcheck unavailable; bash -n checks completed.\n'
fi

printf '\nRESULT: PASS. OrangeFox GitHub build verifier completed.\n'
