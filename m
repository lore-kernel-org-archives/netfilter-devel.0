From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Build failure with Linux 4.13+: ERROR: "__udivdi3"
 [net/netfilter/xt_hashlimit.ko] undefined!
Date: Sat, 09 Sep 2017 10:37:25 +0200
Message-ID: <02adf29d4b82dde97be78b0a9b20a3a6@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Cc: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
To: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3.molgen.mpg.de ([141.14.17.11]:56411 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1757372AbdIIIh2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Sep 2017 04:37:28 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear Linux folks,


Building the latest master branch from Linus, commit 0e271fd59fe9
(Merge tag 'platform-drivers-x86-v4.14-1' of
git://git.infradead.org/linux-platform-drivers-x86) fails with the error
below. The same development environment worked up to the release of 
Linux
4.13.

```
[…]
   XZKERN  arch/x86/boot/compressed/vmlinux.bin.xz
   CC      arch/x86/boot/compressed/misc.o
ERROR: "__udivdi3" [net/netfilter/xt_hashlimit.ko] undefined!
scripts/Makefile.modpost:91: recipe for target '__modpost' failed
make[3]: *** [__modpost] Error 1
Makefile:1216: recipe for target 'modules' failed
make[2]: *** [modules] Error 2
make[2]: *** Waiting for unfinished jobs....
   MKPIGGY arch/x86/boot/compressed/piggy.S
   AS      arch/x86/boot/compressed/piggy.o
   DATAREL arch/x86/boot/compressed/vmlinux
   LD      arch/x86/boot/compressed/vmlinux
   ZOFFSET arch/x86/boot/zoffset.h
   OBJCOPY arch/x86/boot/vmlinux.bin
   AS      arch/x86/boot/header.o
   LD      arch/x86/boot/setup.elf
   OBJCOPY arch/x86/boot/setup.bin
   BUILD   arch/x86/boot/bzImage
Setup is 17340 bytes (padded to 17408 bytes).
System is 3817 kB
CRC dcf6a07b
Kernel: arch/x86/boot/bzImage is ready  (#124)
scripts/package/Makefile:91: recipe for target 'deb-pkg' failed
make[1]: *** [deb-pkg] Error 2
Makefile:1349: recipe for target 'deb-pkg' failed
make: *** [deb-pkg] Error 2

real    8m28.838s
user    209m25.359s
sys     17m19.136s
```

The same error is mentioned in the review of a patch in September 2016 
[1],
and, indeed, I am build *for* a 32-bit system, `CONFIG_X86_32=y`, *on* a 
64-bit system.


Kind regards,

Paul


[1] https://patchwork.ozlabs.org/patch/674586/
