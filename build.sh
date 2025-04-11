#!/bin/sh

genVmlinuz() {
	cd ./linux-6.14.1/
	make -j$(nproc)
	cd ..
	cp ./linux-6.14.1/arch/x86/boot/bzImage ./src/vmlinuz
}

genInit() {
	if [ ! -d "./initramfs" ]; then
		mkdir initramfs

		cd initramfs
		mkdir -p usr usr/lib usr/sbin usr/bin dev tmp proc sys etc mnt root
		
		ln -rs usr/bin ./bin
		ln -rs usr/sbin ./sbin
		ln -rs usr/lib ./lib
		ln -rs usr/lib ./lib64

		cd ..

		cp ./init initramfs/

		cp $(which busybox) ./initramfs/usr/bin/

		sudo chroot ./initramfs /usr/bin/busybox --install -s

		cd initramfs
		find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../src/initramfs-$(jq -r '.linuxver' ../var.json).cpio.gz
		cd ..
	else
		echo "initramfs exists, sometimes do clean of initramfs"
		cd initramfs
		find . -print0 | cpio --null -ov --format=newc | gzip -9 > ../src/initramfs-$(jq -r '.linuxver' ../var.json).cpio.gz
		cd ..
	fi
				
}

genIso() {
	mv ./src/* ./iso/boot/
	grub-mkrescue iso -o ./$(jq -r '.Name' ./var.json).iso
}

if [ "$1" = "vmlinuz" ]; then
	genVmlinuz
elif [ "$1" = "initramfs" ]; then
	genInit
elif [ "$1" = "geniso" ]; then
	genIso
elif [ "$1" = "clean" ]; then
	if [ "$2" = "nLinux" ]; then		
		cd ./linux-6.14.1
		make clean
		cd ..
	fi
	
	echo "Limpado com sucesso"
	rm -rf ./initramfs
	rm -rf ./src/*
	rm -f ./iso/boot/*
	rm -r $(find * | grep *.iso) 
elif [ "$1" = "all" ]; then
	genVmlinuz
	genInit
	genIso
else
	echo "See the README.MD"
fi
