# bloc

VM on QEMU:
-----------

Use u-boot

```
qemu-system-aarch64 -m 4096M -cpu cortex-a57 -M virt  \
        -bios u-boot.bin \
        -serial telnet::4444,server -nographic \
        -drive if=none,file=VMDISK,id=hd0 \
        -device virtio-blk-device,drive=hd0 \
        -device virtio-net-device,netdev=net0 \
        -netdev user,id=net0
```

VMDISK: *.qcom

domU on Roc:
------------

Not ready
