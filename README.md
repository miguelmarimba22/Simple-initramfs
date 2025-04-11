# Simple-initramfs


<h3>About build.sh</h3>

```
./build.sh lessiso
```

it will compile linux kernel, initramfs, but do not generate a .iso file

```
./build.sh vmlinuz
```

it will compile only vmlinuz

```
./build.sh initramfs
```

it will compress initramfs using cpio in newc and gzip.

```
./build.sh geniso
```

it will generate a iso using grub-mkrescue

```
./build.sh clean
```

it will clean vmlinuz (compiled), initramfs of iso/boot or src

```
./build.sh clean nLinux
```

it will clean linux kernel, initramfs, iso files.

<h3>About Me!</h3>

i'm learing about linux, how it work, so i did this to test my capacities
