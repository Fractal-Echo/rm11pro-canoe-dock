#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "$0")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
WORKFLOW="$REPO_ROOT/.github/workflows/orangefox-recovery-build.yml"

fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}

pass() {
  printf 'PASS: %s\n' "$*"
}

need_text() {
  local text="$1"
  grep -Fq "$text" "$WORKFLOW" || fail "workflow missing text: $text"
  pass "workflow contains: $text"
}

reject_text() {
  local pattern="$1"
  local label="$2"
  if grep -n -E "$pattern" "$WORKFLOW" >/tmp/rm11-orangefox-build-workflow-hit.txt 2>/dev/null; then
    sed -n '1,40p' /tmp/rm11-orangefox-build-workflow-hit.txt >&2
    fail "workflow contains forbidden text: $label"
  fi
  pass "workflow avoids: $label"
}

[ -f "$WORKFLOW" ] || fail "missing workflow: $WORKFLOW"

need_text 'workflow_dispatch:'
need_text 'full_build:'
need_text 'github.event_name'
need_text 'inputs.full_build == true'
need_text 'RM11_INCLUDE_ANDROID16_PREBUILTS: "false"'
need_text 'DEVICE_TREE_SOURCE: recovery/device/zte/sm88XX'
need_text 'DEVICE_TREE_DEST: device/nubia/NX809J'
need_text 'LUNCH_TARGET: orangefox_NX809J-ap2a-eng'
need_text 'repo init --depth=1'
need_text 'repo sync --force-sync'
need_text 'mka recoveryimage'
need_text 'actions/upload-artifact@v4'

reject_text 'self-hosted' 'self-hosted runner'
reject_text '/home/[A-Za-z0-9._-]+' 'private maintainer path'
reject_text 'secrets\.' 'GitHub secrets'
reject_text '(^|[[:space:]])adb([[:space:]]|$)' 'device bridge command'
reject_text '(^|[[:space:]])fastboot([[:space:]]|$)' 'bootloader command'
reject_text '(^|[[:space:]])dd[[:space:]]+if=' 'partition copy command'

printf '\nRESULT: PASS. Manual OrangeFox GitHub build workflow is public-runner bounded.\n'
