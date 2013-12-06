From: Vincent Li <vincent.mc.li@gmail.com>
Subject: Re: xtables-addons compiling warning/error Kernels below 3.7 not
 supported on ubuntu running mainline kernel
Date: Fri, 6 Dec 2013 10:37:54 -0800
Message-ID: <CAK3+h2zYCdB6yfMuZE9Zv56zFdsw6a4S3p3NvOqNfjEjF87aog@mail.gmail.com>
References: <CAK3+h2w-qq1suyE8_oL0o0EFH076Vx9TLhAYOi-VfUJtR9jhww@mail.gmail.com>
	<alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:51211 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab3LFShz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Dec 2013 13:37:55 -0500
Received: by mail-oa0-f46.google.com with SMTP id o6so1227554oag.33
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Dec 2013 10:37:54 -0800 (PST)
In-Reply-To: <alpine.LSU.2.11.1312061836360.1933@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

here it is:

root@vincent-hp:/usr/src/xtables-addons# ./configure
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking whether gcc and cc understand -c and -o together... yes
checking build system type... i686-pc-linux-gnu
checking host system type... i686-pc-linux-gnu
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for ar... ar
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking linux/netfilter/x_tables.h usability... yes
checking linux/netfilter/x_tables.h presence... yes
checking for linux/netfilter/x_tables.h... yes
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libxtables... yes
checking Xtables module directory... /usr/local/lib/xtables
checking kernel version that we will build against... 3.13.0.0 in
/lib/modules/3.13.0-rc2-custom/build
WARNING: That kernel version is not officially supported yet. Continue
at own luck.
configure: creating ./config.status
config.status: creating Makefile
config.status: creating Makefile.iptrules
config.status: creating Makefile.mans
config.status: creating geoip/Makefile
config.status: creating extensions/Makefile
config.status: creating extensions/ACCOUNT/Makefile
config.status: creating extensions/pknock/Makefile
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands

On Fri, Dec 6, 2013 at 9:37 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Friday 2013-12-06 01:14, Vincent Li wrote:
>>
>>I am running mainline git kernel according to link instruction
>>https://wiki.ubuntu.com/KernelTeam/GitKernelBuild
>>
>>I also git cloned the xtables-addons and get compiling error as below:
>>
>>if [ -n "/lib/modules/3.13.0-rc2-custom/build" ]; then make -C
>>/lib/modules/3.13.0-rc2-custom/build
>>M=/usr/src/xtables-addons/extensions modules; fi;
>>make[3]: Entering directory `/usr/src/linux-headers-3.13.0-rc2-custom'
>>  CC [M]  /usr/src/xtables-addons/extensions/compat_xtables.o
>>  CC [M]  /usr/src/xtables-addons/extensions/xt_CHAOS.o
>>In file included from /usr/src/xtables-addons/extensions/xt_CHAOS.c:24:
>>/usr/src/xtables-addons/extensions/compat_xtables.h:12:3: warning:
>>#warning Kernels below 3.7 not supported.
>
> What was your configure output?
