# Kernel Lab Provenance

## Upstream Source

The deleted local `rm11-recovery-next-from-myfork-main` folder was treated as RM11 kernel-lab material derived from:

```text
https://github.com/Coding-BR/android_kernel_nubia_sm8850_qwjujube
```

Network check on 2026-06-08 showed:

```text
HEAD branch: main
HEAD commit: 470c94dfb297713b9766b8001be982cf9b0d41fc
```

This repo does not vendor or mirror that kernel tree. Canoe Dock should carry public release notes, test evidence, hashes, rollback policy, and links/provenance. Kernel source, decompiled code, compiler prebuilts, and raw build outputs belong in a dedicated kernel repo or external release assets.

## Cleanup Decision

The local folder was deleted during the dock cleanup because:

- the useful findings were summarized into Canoe Dock notes.
- its Git worktree metadata was broken.
- upstream can be re-cloned when kernel-source work resumes.

```text
https://github.com/Coding-BR/android_kernel_nubia_sm8850_qwjujube
```

## Lightweight Material Reviewed

Useful source docs reviewed before deletion:

| Local path | Use |
|---|---|
| `reversa-context/rm11_fresh_upstream_ramboot_pass.md` | RAM-boot pass evidence and touchscreen provenance caution. |
| `reversa-context/rm11_android16_root_path_plan.md` | Android 16 split-boot root target analysis. |
| `reversa-context/NEXT_STEPS.md` | Kernel lab task queue and module targets. |
| `_reversa_sdd/rm11/branch_recovery_strategy.md` | Branch/base safety analysis. |
| `artifacts/touchscreen-working/20260526-191405/README.md` | Known-working touchscreen artifact preservation note. |
| `vendor/zte/zte_tpd/analysis.md` | Touch driver reverse-engineering notes and KCFI/module risks. |
| `reversa-context/ASK_REVERSA.md` | Original repo-study prompt and safety constraints. |

These were summarized into the project-note categories instead of copied verbatim because several are local-only, broad, mixed-language, or contain experimental claims that need artifact-level proof before becoming public release guidance.

## Import Rules

Import into Canoe Dock when material is:

- Documentation, manifest, checksum, or validation evidence.
- RM11 Pro / NX809J scoped.
- Small enough for normal git.
- Free of private partition data.
- Clear about WIP status and rollback.

Keep out of Canoe Dock:

- Full kernel source mirrors.
- `decompiled/` trees.
- compiler prebuilts such as `clang-r536225/`.
- raw `.img`, `.ko`, `.zip`, `.apk`, `.log`, `.raw`, or dump files.
- private identity/calibration partitions.

## High-Value Kernel Lab Conclusions

- Known RAM-boot evidence exists, but touch working as user-visible behavior does not prove the rebuilt open-source touch driver was active.
- Android 16 Magisk-style root targets `init_boot`, not `boot`.
- Build 8 boot hang remains best tracked as an SCMI/remoteproc/keymint/vold/FBE chain.
- Blue dump on wake should be tested with a minimal evidence bundle before broad kernel edits.
- `zte_tpd` module presence is not enough; provenance needs Build-ID/hash comparison.
- Broad branches that modify core ARM64 string routines or kernel infrastructure should be treated as patch quarry, not direct bases.
