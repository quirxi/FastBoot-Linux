# FastBoot-Linux
This is an updated version of the AVR bootloader ['FastBoot'](https://www.mikrocontroller.net/topic/146638) from Peter Dannegger. 
It compiles code for the ATmega328 and ATmega328P and is tested under debian 9.4 (stretch) with avr-gcc 4.9.2.

The fastboot file [*fastboot_build30.tar.gz*](https://www.mikrocontroller.net/topic/146638#5100608) was patched with the newer [*get_avr_arch.sh*](https://www.mikrocontroller.net/topic/146638#5269483).
Then them missing **m328def.inc** and **m328Pdef.inc** for ATmega328 and ATmega328P were added and integrated into the Makefiles.
The last modification was the addition of the avr include files in the avr directory and integration into the Makefiles aswell.


## Example Terminal Session
---

```BASH
> ls -lGg
total 236
drwxr-xr-- 2 4096 Apr 29 14:07 added
drwxr-xr-- 2 4096 Apr 29 14:07 atmel
drwxr-xr-x 6 4096 Apr 29 14:07 avr
-rwxr-xr-x 1 5916 Apr 29 14:07 bootload.elf
-rw-r--r-- 1 1474 Apr 29 14:07 bootload.hex
-rw-r--r-- 1 1991 Apr 29 14:07 bootload.template.x
-rw-r--r-- 1    3 Apr 29 14:07 build_no
-rwxr-x--- 1 2757 Apr 29 14:07 _conv.awk
drwxr-xr-- 2 4096 Apr 29 14:07 converted
-rwxr-xr-- 1  732 Apr 29 14:07 diff2addr.sh
-rwxr-xr-- 1  157 Apr 29 14:07 flash-m168.sh
-rwxr-xr-- 1  155 Apr 29 14:07 flash-m88.sh
-rwxr-xr-- 1  133 Apr 29 14:07 flash-m8.sh
-rwxr-xr-- 1   71 Apr 29 14:07 flash.sh
-rwxr-xr-- 1 1349 Apr 29 14:07 get_avr_arch.sh
-rwxr-xr-x 1 1680 Apr 29 14:07 get_avr_arch.sh.OLD
-rwxr-xr-- 1 1447 Apr 29 14:07 get_bootsection_addrs.sh
-rwxr-xr-- 1 2032 Apr 29 14:07 get_text_addrs.sh
lrwxrwxrwx 1   14 Apr 29 14:29 Makefile -> Makefile-m328P
-rw-r--r-- 1 8344 Apr 29 14:07 Makefile-2560
-rw-r--r-- 1 8410 Apr 29 14:07 Makefile-m16
-rw-r--r-- 1 8600 Apr 29 14:07 Makefile-m168
-rw-r--r-- 1 8339 Apr 29 14:07 Makefile-m32
-rw-r--r-- 1 8642 Apr 29 14:07 Makefile-m328
-rw-r--r-- 1 8554 Apr 29 14:07 Makefile-m328P
-rw-r--r-- 1 8549 Apr 29 14:07 Makefile-m8
-rw-r--r-- 1 8550 Apr 29 14:07 Makefile-m88
-rw-r--r-- 1 8531 Apr 29 14:07 Makefile-m8_8mhz_rx_tx
-rw-r--r-- 1 8585 Apr 29 14:07 Makefile-t43u
-rw-r--r-- 1 8487 Apr 29 14:07 Makefile-tiny44
-rw-r--r-- 1 8470 Apr 29 14:07 Makefile-tiny85
-rw-r--r-- 1 8497 Apr 29 14:07 Makefile-tiny861
-rw-r--r-- 1 3881 Apr 29 14:07 README
> rm Makefile
> ln -s Makefile-m328P Makefile
> make clean
Makefile:131: atmel_def.mak: No such file or directory
./_conv.awk atmel/m328Pdef.inc | gawk '/PAGESIZE|SIGNATURE_|SRAM_|FLASHEND|BOOT/' > atmel_def.h
gawk '{ printf "%s = %s\n", $2, $3 }' atmel_def.h > atmel_def.mak
rm -f atmel_def.h bootload.x *.defs *.o *.gas *.mak *.lst *.02x *.map
> make
Makefile:131: atmel_def.mak: No such file or directory
./_conv.awk atmel/m328Pdef.inc | gawk '/PAGESIZE|SIGNATURE_|SRAM_|FLASHEND|BOOT/' > atmel_def.h
gawk '{ printf "%s = %s\n", $2, $3 }' atmel_def.h > atmel_def.mak
avr-gcc -c -Wa,-adhlns=bootload.lst -mmcu=atmega328p -DF_CPU=11059200  -I . -I ./added -I ./converted -I./atmel -I./avr -ffreestanding -g -L,-g -DRAM_START=0x0100 -DSRAM_SIZE=2048 -DSTX_PORT=PORTD -DSTX=PD1 -DSRX_PORT=PORTD -DSRX=PD0 added/bootload.S -o bootload.o
avr-gcc -c -Wa,-adhlns=stub.lst -mmcu=atmega328p -DF_CPU=11059200  -I . -I ./added -I ./converted -I./atmel -I./avr -ffreestanding -g -L,-g -DRAM_START=0x0100 -DSRAM_SIZE=2048 -DSTX_PORT=PORTD -DSTX=PD1 -DSRX_PORT=PORTD -DSRX=PD0 added/stub.S -o stub.o
vars="$(./get_bootsection_addrs.sh 0x3fff 0x3f00 0x3e00 0x3c00 )"; \
arch="$(./get_avr_arch.sh -mmcu=atmega328p bootload.o)"; \
echo "arch=$arch";\
echo "$vars"; \
eval "$vars"; \
sed -e "s/@LOADER_START@/$LOADER_START/g" \
    -e s"/@ARCH@/$arch/" \
    -e s'/@RAM_START@/0x0100/g' \
    -e s'/@RAM_SIZE@/2048/g' \
    -e "s/@STUB_OFFSET@/$STUB_OFFSET/g" \
    bootload.template.x > bootload.x; \
avr-ld -N -E -T bootload.x -Map=bootload.map \
  --cref bootload.o stub.o -o bootload.elf --defsym Application=0
*** Note: set BOOTSZ fuses to the word address 0x3f00 ***
arch=avr5
LOADER_START=0x7e00
STUB_OFFSET=0x1fe
avr-objcopy -O ihex bootload.elf bootload.hex
> 
```


## References
---
* https://www.mikrocontroller.net/articles/AVR_Bootloader_FastBoot_von_Peter_Dannegger
* https://www.mikrocontroller.net/topic/146638
* hhttps://www.mikrocontroller.net/topic/146638#5100608
* https://www.mikrocontroller.net/topic/146638#5269483
* https://github.com/Boregard/FBoot-Linux
* https://www.mikrocontroller.net/articles/AVR_Bootloader_in_C_-_eine_einfache_Anleitung
* https://github.com/DarkSector/AVR

## Authors:
---
* quirxi (https://github.com/quirxi)
