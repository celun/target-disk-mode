Target Disk Mode
================

This is an example *Celun* system implementing a USB Mass Storage system.

*This is WIP.*

Building
--------

```
 $ nix-build --arg device ./devices/... -A ...
```

Usage
-----

This will depend on the exact device.

For many systems, burning the `build.disk-image` output to a bootable will be
sufficient.

On EFI-based systems, using `build.efiKernel` is an alternative option. The
output is a self-contained EFI "program" consisting of the kernel and the
required userspace.
