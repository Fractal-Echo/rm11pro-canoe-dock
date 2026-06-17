# OrangeFox Recovery Releases

Current public prebuilt:

- [OrangeFox RM11 current test](current/README.md)

Fallback baseline:

- [D2N baseline](d2n/README.md)

`OrangeFox-RM11.zip` is the short-name current test package. It includes the RM11
selectable theme and splash visual pass. D2N remains the functional recovery
baseline and fallback.

Committed prebuilt:

```text
current/OrangeFox-RM11.zip
d2n/OrangeFox-RM11-D2N.zip
```

Hashes:

```text
f2547c3ff9d43b060ba0ece1e9f497e2de0fbe0180a6eb8bdde3df01d80ce0d3  OrangeFox-RM11.zip
b3c0cdeb3efbedf0903eced3a840523fe735ec27082c9f1f2bd826884166187f  embedded current recovery.img
5394ee6e45417262f631c9783dc2904b5baeb2cbe9108561053b711c1ef62cab  OrangeFox-RM11-D2N.zip
a9c70ce885b025fc4b1618798b99bdc05b45239fa76c880415198ab26d9a5fd0  embedded D2N recovery.img
```

The raw `recovery.img` is not committed separately because it is exactly
`104857600` bytes. The committed OrangeFox zips contain that image as
`recovery.img`.

Historical failed/probe candidates remain documented in:

- [Build Result](BUILD-RESULT.md)
- [Forensics](FORENSICS.md)
- [Rollback](ROLLBACK.md)

Only test recovery with one recovery slot and stock rollback ready.
