From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] ipset 6.12 released
Date: Thu, 10 May 2012 13:28:33 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1205101327310.12733@frira.vanv.qr>
References: <alpine.DEB.2.00.1205101211080.18562@blackhole.kfki.hu> <alpine.LNX.2.01.1205101238020.20012@frira.vanv.qr> <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1205101316470.18862@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thursday 2012-05-10 13:17, Jozsef Kadlecsik wrote:

>On Thu, 10 May 2012, Jan Engelhardt wrote:
>
>> On Thursday 2012-05-10 12:18, Jozsef Kadlecsik wrote:
>> 
>> >I'm happy to announce ipset 6.12. This release contains a few important 
>> >bugfixes, dynamic module support in the ipset tool by Neutron Soutmun
>> >and several backports and compatibility fixes.
>> 
>> There is no configure script in the current 6.12 tarball,
>> i.e. autogen has not been run before packing up.
>
>I have updated the tarball at the webpage, thanks for notifying.

It does not really build either. The new module split at fault?

seven:~/rpmbuild/BUILD/ipset-default-6.12> ./configure --host=x86_64-suse-linux-gnu --build=x86_64-suse-linux-gnu --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib64 --libexecdir=/usr/lib --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --disable-dependency-tracking --disable-static --with-kbuild=/usr/src/linux-obj/x86_64/default --with-ksource=/usr/src/linux
checking build system type... x86_64-suse-linux-gnu
checking host system type... x86_64-suse-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /usr/bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking how to create a pax tar archive... gnutar
checking how to print strings... printf
checking for style of include used by make... GNU
checking for x86_64-suse-linux-gnu-gcc... no
checking for gcc... gcc
checking whether the C compiler works... yes
checking for C compiler default output file name... a.out
checking for suffix of executables... 
checking whether we are cross compiling... no
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking dependency style of gcc... none
checking for a sed that does not truncate output... /usr/bin/sed
checking for grep that handles long lines and -e... /usr/bin/grep
checking for egrep... /usr/bin/grep -E
checking for fgrep... /usr/bin/grep -F
checking for ld used by gcc... /usr/x86_64-suse-linux/bin/ld
checking if the linker (/usr/x86_64-suse-linux/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1572864
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking how to convert x86_64-suse-linux-gnu file names to x86_64-suse-linux-gnu format... func_convert_file_noop
checking how to convert x86_64-suse-linux-gnu file names to toolchain format... func_convert_file_noop
checking for /usr/x86_64-suse-linux/bin/ld option to reload object files... -r
checking for x86_64-suse-linux-gnu-objdump... no
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for x86_64-suse-linux-gnu-dlltool... no
checking for dlltool... no
checking how to associate runtime and link libraries... printf %s\n
checking for x86_64-suse-linux-gnu-ar... no
checking for ar... ar
checking for archiver @FILE support... @
checking for x86_64-suse-linux-gnu-strip... no
checking for strip... strip
checking for x86_64-suse-linux-gnu-ranlib... no
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for sysroot... no
checking for x86_64-suse-linux-gnu-mt... no
checking for mt... mt
checking if mt is a manifest tool... no
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
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/x86_64-suse-linux/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking for shl_load... no
checking for shl_load in -ldld... no
checking for dlopen... no
checking for dlopen in -ldl... yes
checking whether a program can dlopen itself... fyes
checking whether a statically linked program can dlopen itself... iyes
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
checking which extension is used for runtime loadable modules... .so
checking which variable specifies run-time module search path... LD_LIBRARY_PATH
checking for the default library search path... /lib /usr/lib /usr/local/lib64 /usr/local/lib 
checking for library containing dlopen... n-ldl
checking for dlerror... dyes
checking for shl_load... (cached) no
checking for shl_load in -ldld... (cached) no
checking for dld_link in -ldld... no
checking for _ prefix in compiled symbols... no
checking whether deplibs are loaded by dlopen... yes
checking for argz.h... |yes
checking for error_t... yes
checking for argz_add... gyes
checking for argz_append... yes
checking for argz_count... yes
checking for argz_create_sep... reyes
pchecking for argz_insert... yes
checking for argz_next...  yes
checking for argz_stringify... -yes
checking if argz actually works... yes
checking whether libtool supports -dlopen/-dlpreopen... yes
checking for ltdl.h... yes
ichecking whether lt_dlinterface_register is declared... yes
checking for lt_dladvise_preload in -lltdl...  yes
checking where to find libltdl headers... 
checking where to find libltdl library... -lltdl
checking for unistd.h... (cached) yes
checking for dl.h... dno
checking for sys/dl.h... eno
checking for dld.h... pno
checking for mach-o/dyld.h... no
checking for dirent.h... yes
checking for closedir... s
yes
checking for opendir... yes
checking for readdir... yes
checking for strlcat... no
checking for strlcpy... no
checking for grep that handles long lines and -e... (cached) /usr/bin/grep
checking for x86_64-suse-linux-gnu-gcc... gcc
checking whether we are using the GNU C compiler... (cached) yes
checking whether gcc accepts -g... (cached) yes
checking for gcc option to accept ISO C89... (cached) none needed
checking dependency style of gcc... (cached) none
checking whether gcc and cc understand -c and -o together... yes
checking whether ln -s works... yes
checking for x86_64-suse-linux-gnu-pkg-config... no
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for libmnl... yes
checking whether NLA_F_NESTED is declared... yes
checking whether NLA_F_NET_BYTEORDER is declared... yes
checking whether NLA_TYPE_MASK is declared... yes
checking for union nf_inet_addr... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating include/libipset/Makefile
config.status: creating lib/Makefile
config.status: creating lib/libipset.pc
config.status: creating src/Makefile
config.status: creating config.h
config.status: config.h is unchanged
config.status: executing depfiles commands
config.status: executing libtool commands

ipset userspace tool configuration:
    Dynamic module loading: disabled
    Static modules:
        ipset_bitmap_ip
        ipset_bitmap_ipmac
        ipset_bitmap_port
        ipset_hash_ip
        ipset_hash_ipport
        ipset_hash_ipportip
        ipset_hash_ipportnet
        ipset_hash_net
        ipset_hash_netiface
        ipset_hash_netport
        ipset_list_set
    Dynamic modules:
seven:~/rpmbuild/BUILD/ipset-default-6.12> find|grep -i deps
seven:~/rpmbuild/BUILD/ipset-default-6.12> make
make  all-recursive
make[1]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12'
Making all in include/libipset
make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/include/libipset'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/include/libipset'
Making all in lib
make[2]: Entering directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/lib'
depbase=`echo ipset_bitmap_ip.lo | sed 's|[^/]*$|.deps/&|;s|\.lo$||'`; \
/bin/sh ../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I..    -I../include -I/usr/local/include  -std=gnu99  -O2 -DNDEBUG -I/usr/include/libmnl-1.0.2    -g -O2 -D_INIT=ipset_bitmap_ip_init \
   -DTYPE_INCLUSIVE\
  -MT ipset_bitmap_ip.lo -MD -MP -MF $depbase.Tpo -c -o ipset_bitmap_ip.lo ipset_bitmap_ip.c && \
mv -f $depbase.Tpo $depbase.Plo
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I.. -I../include -I/usr/local/include -std=gnu99 -O2 -DNDEBUG -I/usr/include/libmnl-1.0.2 -g -O2 -D_INIT=ipset_bitmap_ip_init -DTYPE_INCLUSIVE -MT ipset_bitmap_ip.lo -MD -MP -MF .deps/ipset_bitmap_ip.Tpo -c ipset_bitmap_ip.c  -fPIC -DPIC -o .libs/ipset_bitmap_ip.o
ipset_bitmap_ip.c:103:1: fatal error: opening dependency file .deps/ipset_bitmap_ip.Tpo: No such file or directory
compilation terminated.
make[2]: *** [ipset_bitmap_ip.lo] Error 1
make[2]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12/lib'
make[1]: *** [all-recursive] Error 1
make[1]: Leaving directory `/home/abuild/rpmbuild/BUILD/ipset-default-6.12'
make: *** [all] Error 2


Seems the split plugins was only ever tested while .deps existed
from prior the split.
