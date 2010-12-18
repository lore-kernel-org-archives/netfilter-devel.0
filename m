From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] ipset-5.0 released
Date: Sat, 18 Dec 2010 22:49:00 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1012182136190.19284@obet.zrqbmnf.qr>
References: <alpine.DEB.2.00.1012172259100.10231@blackhole.kfki.hu> <1292657351.2371.73.camel@kushiel.sterenborg.info> <alpine.DEB.2.00.1012181149560.11002@blackhole.kfki.hu> <alpine.LNX.2.01.1012181635530.13544@obet.zrqbmnf.qr>
 <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "Rob Sterenborg (lists)" <lists@sterenborg.info>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45477 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932199Ab0LRVtC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Dec 2010 16:49:02 -0500
In-Reply-To: <alpine.DEB.2.00.1012182024240.11577@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2010-12-18 20:50, Jozsef Kadlecsik wrote:
>>>>
>>>> ./configure: line 11510: syntax error near unexpected token `[libm=
nl],'
>>>> ./configure: line 11510: `PKG_CHECK_MODULES([libmnl], [libmnl >=3D=
 1])'
>>>>=20
>>>> CentOS' pkg-config is installed, so, for reference: I copied
>>>> '/usr/share/aclocal/pkg.m4' into the 'm4' directory, ran 'autogen.=
sh'
>>>> again and after that 'configure' had no problems.
>>>
>>>Autoconf has its own pitfalls... I can't reproduce it so I added
>>>'aclocal -I m4' to autogen.sh.
>>=20
>>That is not necessary, because we already have ACLOCAL_AMFLAGS =3D -I=
 m4
>>in Makefile.am.
>
>Yes, I know. Still I had a little hope that that'd fix the issue.
>Do you have another idea? Should for example /usr/share/aclocal/pkg.m4=
 be=20
>unconditionally copied into m4/ by autogen.sh?

autoreconf normally has /usr/share/aclocal in its search path,
and I can say autoreconf does the job properly in CentOS 4.x.
Ima gonna setup a centos5 vm..

>> >Please read the README file: you must patch your kernel source with=
=20
>> >netlink.patch, compile and install it. Otherwise the new nfnetlink =
id=20
>> >won't handled by the kernel and thus ipset can't work.
>>=20
>> ipset could try using both nfnetlink and genetlink, in case
>> NFNL_SUBSYS_IPSET is not defined, couldn't it?
>
>Yes, it could. It's unfortunate that old ipset modules could be compil=
ed=20
>without any kernel patching while new one needs it. But we are on the=20
>right track: Dave accepted my jhash.h patch in net-next-2.6 and as it =
is=20
>propagated into Patrick's tree, I'll be able to submit the ipset 5.x=20
>kernel patches. But there's no need to rush: I hope I can get feedback=
=20
>from other architectures, like Sparc or ARM too. (On Wednesday I'll be=
=20
>able to dust off a Sparc machine and run the compilation and testsuite=
=2E)

I already made this year's presents: a PPC64 is here,
but it yet needs to be installed...

You can use my sparc. Pierre Chifflier already had his ulogd
pieces tested here in pair programming with shared screen(1)
sessions (great stuff that!).

=3D=3D sparcv9

22:30 ares:~/code/ipset > ./configure libmnl_CFLAGS=3D"-I$HOME/code/lib=
mnl/include" libmnl_LIBS=3D"-L$HOME/code/libmnl/obj32/src/.libs -Wl,-rp=
ath,$HOME/code/libmnl/obj32/src/.libs -lmnl"
checking build system type... sparc64-suse-linux-gnu
checking host system type... sparc64-suse-linux-gnu
checking target system type... sparc64-suse-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for grep that handles long lines and -e... /usr/bin/grep
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...=20
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking whether gcc and cc understand -c and -o together... yes
checking for a sed that does not truncate output... /usr/bin/sed
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
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
checking whether the gcc linker (/usr/bin/ld -m elf32_sparc) supports s=
hared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking whether ln -s works... yes
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libmnl... yes
checking for union nf_inet_addr... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating lib/Makefile
config.status: creating src/Makefile
config.status: creating config.h
config.status: executing depfiles commands
config.status: executing libtool commands
22:31 ares:~/code/ipset > make -k
make  all-recursive
make[1]: Entering directory `/home/jengelh/code/ipset'
Making all in lib
make[2]: Entering directory `/home/jengelh/code/ipset/lib'
  CC     data.lo
  CC     icmp.lo
  CC     icmpv6.lo
  CC     mnl.lo
  CC     parse.lo
cc1: warnings being treated as errors
parse.c: In function =E2=80=98get_addrinfo=E2=80=99:
parse.c:637:11: error: cast increases required alignment of target type
parse.c:640:11: error: cast increases required alignment of target type
make[2]: *** [parse.lo] Error 1
  CC     print.lo
  CC     session.lo
  CC     types.lo
make[2]: Target `all' not remade because of errors.
make[2]: Leaving directory `/home/jengelh/code/ipset/lib'
Making all in src
make[2]: Entering directory `/home/jengelh/code/ipset/src'
  CC     ipset.o
  CC     errcode.o
  CC     ipset_bitmap_ip.o
  CC     ipset_bitmap_ipmac.o
  CC     ipset_bitmap_port.o
  CC     ipset_hash_ip.o
  CC     ipset_hash_ipport.o
  CC     ipset_hash_ipportip.o
  CC     ipset_hash_ipportnet.o
  CC     ipset_hash_net.o
  CC     ipset_hash_netport.o
  CC     ipset_list_set.o
  CC     ui.o
make[2]: *** No rule to make target `../lib/libipset.la', needed by `ip=
set'.
make[2]: Target `all' not remade because of errors.
make[2]: Leaving directory `/home/jengelh/code/ipset/src'
make[2]: Entering directory `/home/jengelh/code/ipset'
make[2]: Leaving directory `/home/jengelh/code/ipset'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/jengelh/code/ipset'
make: *** [all] Error 2

22:43 ares:../ipset/kernel > make
make -C /lib/modules/`uname -r`/build M=3D`pwd` all
make[1]: Entering directory `/home/jengelh/code/linux'
  kernel: arch/sparc/boot/image is ready
make[1]: Leaving directory `/home/jengelh/code/linux'

That doesn't look right... hm.

The fix is:

-        $(MAKE) -C $(KERNELDIR) M=3D$$PWD $@
+        $(MAKE) -C $(KERNELDIR) M=3D$$PWD

One must not call make with 'all' as a target for modules. (And I am
surprised it happened to work on x86; normally it does not either.
Probably because on x86, I had a pure object dir, and on the sparc,
KERNELDIR refers to a source-object-dir)


=3D=3D=3D sparc64

22:33 ares:~/code/ipset > ./configure libmnl_CFLAGS=3D"-I$HOME/code/lib=
mnl/include" libmnl_LIBS=3D"-L$HOME/code/libmnl/obj64/src/.libs -Wl,-rp=
ath,$HOME/code/libmnl/obj64/src/.libs -lmnl" CFLAGS=3D"-m64 -O2" LDFLAG=
S=3D-m64
checking build system type... sparc64-suse-linux-gnu
checking host system type... sparc64-suse-linux-gnu
checking target system type... sparc64-suse-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for grep that handles long lines and -e... /usr/bin/grep
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables...=20
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking whether gcc and cc understand -c and -o together... yes
checking for a sed that does not truncate output... /usr/bin/sed
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+=3D"... yes
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
checking whether the gcc linker (/usr/bin/ld -m elf64_sparc) supports s=
hared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking whether ln -s works... yes
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libmnl... yes
checking for union nf_inet_addr... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating lib/Makefile
config.status: creating src/Makefile
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands
22:34 ares:~/code/ipset > make -k
make  all-recursive
make[1]: Entering directory `/home/jengelh/code/ipset'
Making all in lib
make[2]: Entering directory `/home/jengelh/code/ipset/lib'
  CC     data.lo
  CC     icmp.lo
  CC     icmpv6.lo
  CC     mnl.lo
  CC     parse.lo
cc1: warnings being treated as errors
parse.c: In function =E2=80=98get_addrinfo=E2=80=99:
parse.c:637:11: error: cast increases required alignment of target type
parse.c:640:11: error: cast increases required alignment of target type
make[2]: *** [parse.lo] Error 1
  CC     print.lo
  CC     session.lo
  CC     types.lo
make[2]: Target `all' not remade because of errors.
make[2]: Leaving directory `/home/jengelh/code/ipset/lib'
Making all in src
make[2]: Entering directory `/home/jengelh/code/ipset/src'
  CC     ipset.o
  CC     errcode.o
  CC     ipset_bitmap_ip.o
  CC     ipset_bitmap_ipmac.o
  CC     ipset_bitmap_port.o
  CC     ipset_hash_ip.o
  CC     ipset_hash_ipport.o
  CC     ipset_hash_ipportip.o
  CC     ipset_hash_ipportnet.o
  CC     ipset_hash_net.o
  CC     ipset_hash_netport.o
  CC     ipset_list_set.o
  CC     ui.o
make[2]: *** No rule to make target `../lib/libipset.la', needed by `ip=
set'.
make[2]: Target `all' not remade because of errors.
make[2]: Leaving directory `/home/jengelh/code/ipset/src'
make[2]: Entering directory `/home/jengelh/code/ipset'
make[2]: Leaving directory `/home/jengelh/code/ipset'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/jengelh/code/ipset'
make: *** [all] Error 2
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
