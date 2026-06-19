# OrangeFox Source Sync

This folder keeps the one source-sync helper used by the RM11 Pro / NX809J
OrangeFox build lane.

Current entrypoint:

```bash
scripts/orangefox-sync/orangefox_sync.sh --branch 14.1 --path /absolute/path/to/fox_14.1
```

Notes:

- `--path` must be an absolute path.
- The active branch for this port is `14.1`.
- RM11 Pro patch payloads live in `recovery/patches/fox_14.1`.
- The local build wrapper is `scripts/local-build/build-orangefox-nx809j-local.sh`.
- GitHub PR/push validation does not run a full source sync. The full build lane
  is manual-only in `.github/workflows/orangefox-recovery-build.yml`.
