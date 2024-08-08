Based on [James Macindoeʼs instructions](https://github.com/jmacindoe/kobo-kernel-modules/blob/main/Kobo%20Mark%2010%20-%20Clara%202E/README.md).

Run `docker build . --output type=local,dest=.`

output is uhid.ko in cwd, or wherever you set dest to.

config.gz is extracted from `/proc/config` on my Kobo Clara 2E; feel free to extract it yourself if you want.

The dtc-lexer and focaltech_flash patches are just needed to build the Kobo-provided kernel source with the linaro toolchain. Compiling the kernel wonʼt actually succeed with these patches, but enough succeeds that we can build the uhid module and thatʼs all we really care about here.

```
$ file uhid.ko
uhid.ko: ELF 32-bit LSB relocatable, ARM, EABI5 version 1 (SYSV), BuildID[sha1]=21f1064eab51d18cddd9bb52495d2968703fc859, not stripped
$ 
```
