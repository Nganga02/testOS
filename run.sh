#exec > /dev/null 2>&1

C4C -i src/main.c4 -o main -t x86_64-baremetal-gnuC --emit-c --asmfiles loader1,loader2,x86 > /dev/null
make
make clean

#qemu-system-x86_64 kernel.bin -net user -net nic,model=pcnet -device usb-ehci,id=ehci -device qemu-xhci,id=uhci

qemu-system-x86_64            \
    kernel.bin                \
    -net user                 \
    -net nic,model=pcnet      \
    -device usb-ehci,id=ehci  \
    -device qemu-xhci,id=uhci \
    -nographic

