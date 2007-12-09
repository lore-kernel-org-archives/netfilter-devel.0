From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: conntrack/libnetfilter_conntrack build warnings/errors
Date: Sun, 9 Dec 2007 13:19:40 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0712091318110.17491@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:58882 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748AbXLIMTm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Dec 2007 07:19:42 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


In svn7135, I get quite a lot of warnings in 
libnetfilter_conntrack/src/expect/ and a make error.

Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.55128
+ umask 022
+ cd /usr/src/packages/BUILD
+ cd /usr/src/packages/BUILD
+ rm -rf netfilter-tools-0.svn7135
+ /bin/mkdir -p netfilter-tools-0.svn7135
+ cd netfilter-tools-0.svn7135
+ /usr/bin/bzip2 -dc /usr/src/packages/SOURCES/netfilter-tools.tar.bz2
+ tar -xf -
+ STATUS=0
+ '[' 0 -ne 0 ']'
++ /usr/bin/id -u
+ '[' 25121 = 0 ']'
++ /usr/bin/id -u
+ '[' 25121 = 0 ']'
+ /bin/chmod -Rf a+rX,u+w,g-w,o-w .
+ exit 0
Executing(%build): /bin/sh -e /var/tmp/rpm-tmp.7694
+ umask 022
+ cd /usr/src/packages/BUILD
+ /bin/rm -rf /var/tmp/netfilter-tools-0.svn7135-build
++ dirname /var/tmp/netfilter-tools-0.svn7135-build
+ /bin/mkdir -p /var/tmp
+ /bin/mkdir /var/tmp/netfilter-tools-0.svn7135-build
+ cd netfilter-tools-0.svn7135
+ s=/usr/src/packages/BUILD/netfilter-tools-0.svn7135
+ export 'CFLAGS=-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2 -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
+ CFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2 -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
+ export 'LDFLAGS=-L/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/src/.libs -L/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/.libs'
+ LDFLAGS='-L/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/src/.libs -L/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/.libs'
+ export PKG_CONFIG_PATH=/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink:/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack
+ PKG_CONFIG_PATH=/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink:/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack
+ for i in libnfnetlink libnetfilter_conntrack conntrack-tools
+ pushd libnfnetlink
/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink /usr/src/packages/BUILD/netfilter-tools-0.svn7135
+ ./autogen.sh
running: aclocal
running: libtoolize -f
running: automake -a
configure.in:7: installing `./missing'
configure.in:7: installing `./install-sh'
src/Makefile.am: installing `./depcomp'
running: autoconf
+ CFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2 -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
+ export CFLAGS
+ CXXFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2'
+ export CXXFLAGS
+ FFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2'
+ export FFLAGS
+ ./configure --host=i686-suse-linux-gnu --build=i686-suse-linux-gnu --target=i586-suse-linux --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib --libexecdir=/usr/lib --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --disable-static
checking build system type... i686-suse-linux-gnu
checking host system type... i686-suse-linux-gnu
checking target system type... i586-suse-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for i686-suse-linux-gnu-gcc... no
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for ld used by gcc... /usr/i586-suse-linux/bin/ld
checking if the linker (/usr/i586-suse-linux/bin/ld) is GNU ld... yes
checking for /usr/i586-suse-linux/bin/ld option to reload object files... -r
checking for BSD-compatible nm... /usr/bin/nm -B
checking whether ln -s works... yes
checking how to recognize dependent libraries... pass_all
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
checking dlfcn.h usability... yes
checking dlfcn.h presence... yes
checking for dlfcn.h... yes
checking for i686-suse-linux-gnu-g++... no
checking for i686-suse-linux-gnu-c++... no
checking for i686-suse-linux-gnu-gpp... no
checking for i686-suse-linux-gnu-aCC... no
checking for i686-suse-linux-gnu-CC... no
checking for i686-suse-linux-gnu-cxx... no
checking for i686-suse-linux-gnu-cc++... no
checking for i686-suse-linux-gnu-cl.exe... no
checking for i686-suse-linux-gnu-FCC... no
checking for i686-suse-linux-gnu-KCC... no
checking for i686-suse-linux-gnu-RCC... no
checking for i686-suse-linux-gnu-xlC_r... no
checking for i686-suse-linux-gnu-xlC... no
checking for g++... g++
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking dependency style of g++... gcc3
checking how to run the C++ preprocessor... g++ -E
checking for i686-suse-linux-gnu-g77... no
checking for i686-suse-linux-gnu-xlf... no
checking for i686-suse-linux-gnu-f77... no
checking for i686-suse-linux-gnu-frt... no
checking for i686-suse-linux-gnu-pgf77... no
checking for i686-suse-linux-gnu-cf77... no
checking for i686-suse-linux-gnu-fort77... no
checking for i686-suse-linux-gnu-fl32... no
checking for i686-suse-linux-gnu-af77... no
checking for i686-suse-linux-gnu-xlf90... no
checking for i686-suse-linux-gnu-f90... no
checking for i686-suse-linux-gnu-pgf90... no
checking for i686-suse-linux-gnu-pghpf... no
checking for i686-suse-linux-gnu-epcf90... no
checking for i686-suse-linux-gnu-gfortran... no
checking for i686-suse-linux-gnu-g95... no
checking for i686-suse-linux-gnu-xlf95... no
checking for i686-suse-linux-gnu-f95... no
checking for i686-suse-linux-gnu-fort... no
checking for i686-suse-linux-gnu-ifort... no
checking for i686-suse-linux-gnu-ifc... no
checking for i686-suse-linux-gnu-efc... no
checking for i686-suse-linux-gnu-pgf95... no
checking for i686-suse-linux-gnu-lf95... no
checking for i686-suse-linux-gnu-ftn... no
checking for g77... no
checking for xlf... no
checking for f77... no
checking for frt... no
checking for pgf77... no
checking for cf77... no
checking for fort77... no
checking for fl32... no
checking for af77... no
checking for xlf90... no
checking for f90... no
checking for pgf90... no
checking for pghpf... no
checking for epcf90... no
checking for gfortran... no
checking for g95... no
checking for xlf95... no
checking for f95... no
checking for fort... no
checking for ifort... no
checking for ifc... no
checking for efc... no
checking for pgf95... no
checking for lf95... no
checking for ftn... no
checking whether we are using the GNU Fortran 77 compiler... no
checking whether  accepts -g... no
checking the maximum length of command line arguments... 98304
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for objdir... .libs
checking for i686-suse-linux-gnu-ar... no
checking for ar... ar
checking for i686-suse-linux-gnu-ranlib... no
checking for ranlib... ranlib
checking for i686-suse-linux-gnu-strip... no
checking for strip... strip
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC
checking if gcc PIC flag -fPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking whether the gcc linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
configure: creating libtool
appending configuration tag "CXX" to libtool
checking for ld used by g++... /usr/i586-suse-linux/bin/ld
checking if the linker (/usr/i586-suse-linux/bin/ld) is GNU ld... yes
checking whether the g++ linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking for g++ option to produce PIC... -fPIC
checking if g++ PIC flag -fPIC works... yes
checking if g++ static flag -static works... yes
checking if g++ supports -c -o file.o... yes
checking whether the g++ linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
appending configuration tag "F77" to libtool
configure: creating ./config.status
config.status: creating Makefile
config.status: creating src/Makefile
config.status: creating include/Makefile
config.status: creating include/libnfnetlink/Makefile
config.status: creating utils/Makefile
config.status: creating libnfnetlink.pc
config.status: executing depfiles commands
+ make
Making all in src
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/src'
  CC       libnfnetlink.lo
  CC       iftable.lo
iftable.c:201: warning: 'iftable_up' defined but not used
  CC       rtnl.lo
  CCLD     libnfnetlink.la
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/src'
Making all in include
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include'
Making all in libnfnetlink
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include/libnfnetlink'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include/libnfnetlink'
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include'
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include'
Making all in utils
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/utils'
  CC       iftest.o
  CCLD     iftest
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/utils'
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink'
make[1]: Nothing to be done for `all-am'.
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink'
+ popd
/usr/src/packages/BUILD/netfilter-tools-0.svn7135
+ for i in libnfnetlink libnetfilter_conntrack conntrack-tools
+ pushd libnetfilter_conntrack
/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack /usr/src/packages/BUILD/netfilter-tools-0.svn7135
+ ./autogen.sh
running: aclocal
running: libtoolize -f
running: automake -a
configure.in:7: installing `./missing'
configure.in:7: installing `./install-sh'
src/Makefile.am: installing `./depcomp'
running: autoconf
+ CFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2 -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnfnetlink/include -I/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
+ export CFLAGS
+ CXXFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2'
+ export CXXFLAGS
+ FFLAGS='-O2 -g -m32 -march=i586 -mtune=i686 -fmessage-length=0 -D_FORTIFY_SOURCE=2'
+ export FFLAGS
+ ./configure --host=i686-suse-linux-gnu --build=i686-suse-linux-gnu --target=i586-suse-linux --program-prefix= --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --sysconfdir=/etc --datadir=/usr/share --includedir=/usr/include --libdir=/usr/lib --libexecdir=/usr/lib --localstatedir=/var --sharedstatedir=/usr/com --mandir=/usr/share/man --infodir=/usr/share/info --disable-static
checking build system type... i686-suse-linux-gnu
checking host system type... i686-suse-linux-gnu
checking target system type... i586-suse-linux-gnu
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking for i686-suse-linux-gnu-gcc... no
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for ld used by gcc... /usr/i586-suse-linux/bin/ld
checking if the linker (/usr/i586-suse-linux/bin/ld) is GNU ld... yes
checking for /usr/i586-suse-linux/bin/ld option to reload object files... -r
checking for BSD-compatible nm... /usr/bin/nm -B
checking whether ln -s works... yes
checking how to recognize dependent libraries... pass_all
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
checking dlfcn.h usability... yes
checking dlfcn.h presence... yes
checking for dlfcn.h... yes
checking for i686-suse-linux-gnu-g++... no
checking for i686-suse-linux-gnu-c++... no
checking for i686-suse-linux-gnu-gpp... no
checking for i686-suse-linux-gnu-aCC... no
checking for i686-suse-linux-gnu-CC... no
checking for i686-suse-linux-gnu-cxx... no
checking for i686-suse-linux-gnu-cc++... no
checking for i686-suse-linux-gnu-cl.exe... no
checking for i686-suse-linux-gnu-FCC... no
checking for i686-suse-linux-gnu-KCC... no
checking for i686-suse-linux-gnu-RCC... no
checking for i686-suse-linux-gnu-xlC_r... no
checking for i686-suse-linux-gnu-xlC... no
checking for g++... g++
checking whether we are using the GNU C++ compiler... yes
checking whether g++ accepts -g... yes
checking dependency style of g++... gcc3
checking how to run the C++ preprocessor... g++ -E
checking for i686-suse-linux-gnu-g77... no
checking for i686-suse-linux-gnu-xlf... no
checking for i686-suse-linux-gnu-f77... no
checking for i686-suse-linux-gnu-frt... no
checking for i686-suse-linux-gnu-pgf77... no
checking for i686-suse-linux-gnu-cf77... no
checking for i686-suse-linux-gnu-fort77... no
checking for i686-suse-linux-gnu-fl32... no
checking for i686-suse-linux-gnu-af77... no
checking for i686-suse-linux-gnu-xlf90... no
checking for i686-suse-linux-gnu-f90... no
checking for i686-suse-linux-gnu-pgf90... no
checking for i686-suse-linux-gnu-pghpf... no
checking for i686-suse-linux-gnu-epcf90... no
checking for i686-suse-linux-gnu-gfortran... no
checking for i686-suse-linux-gnu-g95... no
checking for i686-suse-linux-gnu-xlf95... no
checking for i686-suse-linux-gnu-f95... no
checking for i686-suse-linux-gnu-fort... no
checking for i686-suse-linux-gnu-ifort... no
checking for i686-suse-linux-gnu-ifc... no
checking for i686-suse-linux-gnu-efc... no
checking for i686-suse-linux-gnu-pgf95... no
checking for i686-suse-linux-gnu-lf95... no
checking for i686-suse-linux-gnu-ftn... no
checking for g77... no
checking for xlf... no
checking for f77... no
checking for frt... no
checking for pgf77... no
checking for cf77... no
checking for fort77... no
checking for fl32... no
checking for af77... no
checking for xlf90... no
checking for f90... no
checking for pgf90... no
checking for pghpf... no
checking for epcf90... no
checking for gfortran... no
checking for g95... no
checking for xlf95... no
checking for f95... no
checking for fort... no
checking for ifort... no
checking for ifc... no
checking for efc... no
checking for pgf95... no
checking for lf95... no
checking for ftn... no
checking whether we are using the GNU Fortran 77 compiler... no
checking whether  accepts -g... no
checking the maximum length of command line arguments... 98304
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking for objdir... .libs
checking for i686-suse-linux-gnu-ar... no
checking for ar... ar
checking for i686-suse-linux-gnu-ranlib... no
checking for ranlib... ranlib
checking for i686-suse-linux-gnu-strip... no
checking for strip... strip
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC
checking if gcc PIC flag -fPIC works... yes
checking if gcc static flag -static works... yes
checking if gcc supports -c -o file.o... yes
checking whether the gcc linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... no
configure: creating libtool
appending configuration tag "CXX" to libtool
checking for ld used by g++... /usr/i586-suse-linux/bin/ld
checking if the linker (/usr/i586-suse-linux/bin/ld) is GNU ld... yes
checking whether the g++ linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking for g++ option to produce PIC... -fPIC
checking if g++ PIC flag -fPIC works... yes
checking if g++ static flag -static works... yes
checking if g++ supports -c -o file.o... yes
checking whether the g++ linker (/usr/i586-suse-linux/bin/ld) supports shared libraries... yes
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
appending configuration tag "F77" to libtool
checking for a BSD-compatible install... /usr/bin/install -c
checking whether ln -s works... yes
checking for i686-suse-linux-gnu-pkg-config... no
checking for pkg-config... /usr/bin/pkg-config
checking pkg-config is at least version 0.9.0... yes
checking for LIBNFNETLINK... yes
checking arpa/inet.h usability... yes
checking arpa/inet.h presence... yes
checking for arpa/inet.h... yes
checking for inet_ntop... yes
checking if inet_ntop supports IPv6... yes
configure: creating ./config.status
config.status: creating Makefile
config.status: creating src/Makefile
config.status: creating include/Makefile
config.status: creating utils/Makefile
config.status: creating include/libnetfilter_conntrack/Makefile
config.status: creating l3extensions/Makefile
config.status: creating extensions/Makefile
config.status: creating src/conntrack/Makefile
config.status: creating src/expect/Makefile
config.status: creating libnetfilter_conntrack.pc
config.status: executing depfiles commands
+ make
Making all in include
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
Making all in libnetfilter_conntrack
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include/libnetfilter_conntrack'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include/libnetfilter_conntrack'
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
make[2]: Nothing to be done for `all-am'.
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/include'
Making all in src
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src'
Making all in conntrack
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/conntrack'
  CC       api.lo
api.c: In function 'nfct_parse_conntrack':
api.c:545: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
  CC       callback.lo
callback.c: In function '__callback':
callback.c:30: warning: passing argument 2 of '__parse_conntrack' from incompatible pointer type
  CC       getter.lo
  CC       setter.lo
  CC       parse.lo
  CC       build.lo
  CC       snprintf.lo
  CC       snprintf_default.lo
  CC       snprintf_xml.lo
  CC       objopt.lo
objopt.c: In function '__autocomplete':
objopt.c:26: warning: control reaches end of non-void function
  CC       compare.lo
  CCLD     libnetfilter_conntrack_new_api.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/conntrack'
Making all in expect
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/expect'
  CC       api.lo
api.c: In function 'nfexp_parse_expect':
api.c:491: warning: passing argument 2 of '__parse_expect' from incompatible pointer type
api.c: In function 'nfexp_snprintf':
api.c:573: warning: implicit declaration of function '__snprintf_expect'
  CC       callback.lo
callback.c: In function '__expect_callback':
callback.c:30: warning: passing argument 2 of '__parse_expect' from incompatible pointer type
  CC       getter.lo
  CC       setter.lo
  CC       parse.lo
  CC       build.lo
build.c: In function '__build_expect':
build.c:24: warning: 'l3num' may be used uninitialized in this function
  CC       snprintf.lo
snprintf.c: In function '__snprintf_expect':
snprintf.c:21: warning: implicit declaration of function '__snprintf_expect_default'
  CC       snprintf_default.lo
snprintf_default.c: In function '__snprintf_expect_default':
snprintf_default.c:43: warning: implicit declaration of function '__snprintf_proto'
  CCLD     libnetfilter_conntrack_expect.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src/expect'
make[2]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src'
  CC       main.lo
  CC       deprecated.lo
deprecated.c: In function 'nfct_sprintf_conntrack':
deprecated.c:567: warning: 'nfct_sprintf_protocol' is deprecated (declared at deprecated.c:492)
deprecated.c:570: warning: 'nfct_sprintf_timeout' is deprecated (declared at deprecated.c:500)
deprecated.c:573: warning: 'nfct_sprintf_protoinfo' is deprecated (declared at deprecated.c:505)
deprecated.c:575: warning: 'nfct_sprintf_address' is deprecated (declared at deprecated.c:517)
deprecated.c:576: warning: 'nfct_sprintf_proto' is deprecated (declared at deprecated.c:529)
deprecated.c:579: warning: 'nfct_sprintf_counters' is deprecated (declared at deprecated.c:541)
deprecated.c:582: warning: 'nfct_sprintf_status_seen_reply' is deprecated (declared at deprecated.c:279)
deprecated.c:584: warning: 'nfct_sprintf_address' is deprecated (declared at deprecated.c:517)
deprecated.c:585: warning: 'nfct_sprintf_proto' is deprecated (declared at deprecated.c:529)
deprecated.c:588: warning: 'nfct_sprintf_counters' is deprecated (declared at deprecated.c:541)
deprecated.c:591: warning: 'nfct_sprintf_status_assured' is deprecated (declared at deprecated.c:269)
deprecated.c:594: warning: 'nfct_sprintf_mark' is deprecated (declared at deprecated.c:548)
deprecated.c:597: warning: 'nfct_sprintf_use' is deprecated (declared at deprecated.c:553)
deprecated.c: In function 'nfct_sprintf_conntrack_id':
deprecated.c:611: warning: 'nfct_sprintf_conntrack' is deprecated (declared at deprecated.c:564)
deprecated.c:613: warning: 'nfct_sprintf_id' is deprecated (declared at deprecated.c:558)
deprecated.c: In function 'nfct_default_conntrack_display':
deprecated.c:626: warning: 'nfct_conntrack_compare' is deprecated (declared at ../include/libnetfilter_conntrack/libnetfilter_conntrack.h:705)
deprecated.c:630: warning: 'nfct_sprintf_conntrack' is deprecated (declared at deprecated.c:564)
deprecated.c: In function 'nfct_default_conntrack_display_id':
deprecated.c:644: warning: 'nfct_conntrack_compare' is deprecated (declared at ../include/libnetfilter_conntrack/libnetfilter_conntrack.h:705)
deprecated.c:648: warning: 'nfct_sprintf_conntrack_id' is deprecated (declared at deprecated.c:607)
deprecated.c: In function 'nfct_default_conntrack_event_display':
deprecated.c:662: warning: 'nfct_conntrack_compare' is deprecated (declared at ../include/libnetfilter_conntrack/libnetfilter_conntrack.h:705)
deprecated.c:667: warning: 'nfct_sprintf_conntrack_id' is deprecated (declared at deprecated.c:607)
deprecated.c: In function 'nfct_sprintf_expect':
deprecated.c:686: warning: 'nfct_sprintf_address' is deprecated (declared at deprecated.c:517)
deprecated.c:687: warning: 'nfct_sprintf_proto' is deprecated (declared at deprecated.c:529)
deprecated.c: In function 'nfct_sprintf_expect_id':
deprecated.c:698: warning: 'nfct_sprintf_expect' is deprecated (declared at deprecated.c:682)
deprecated.c:699: warning: 'nfct_sprintf_id' is deprecated (declared at deprecated.c:558)
deprecated.c: In function 'nfct_default_expect_display':
deprecated.c:712: warning: 'nfct_sprintf_expect' is deprecated (declared at deprecated.c:682)
deprecated.c: In function 'nfct_default_expect_display_id':
deprecated.c:725: warning: 'nfct_sprintf_expect_id' is deprecated (declared at deprecated.c:694)
deprecated.c: In function 'nfct_create_conntrack':
deprecated.c:873: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c:875: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_update_conntrack':
deprecated.c:911: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c:913: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_delete_conntrack':
deprecated.c:952: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_get_conntrack':
deprecated.c:981: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_get_expectation':
deprecated.c:1104: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_create_expectation':
deprecated.c:1159: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c:1160: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c:1161: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
deprecated.c: In function 'nfct_delete_expectation':
deprecated.c:1189: warning: 'nfct_build_tuple' is deprecated (declared at deprecated.c:119)
  CCLD     libnetfilter_conntrack.la
make[2]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src'
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/src'
Making all in l3extensions
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/l3extensions'
  CC       libnetfilter_conntrack_ipv4.lo
  CCLD     nfct_l3proto_ipv4.la
  CC       libnetfilter_conntrack_ipv6.lo
  CCLD     nfct_l3proto_ipv6.la
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/l3extensions'
Making all in extensions
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/extensions'
  CC       libnetfilter_conntrack_tcp.lo
  CCLD     nfct_proto_tcp.la
  CC       libnetfilter_conntrack_udp.lo
  CCLD     nfct_proto_udp.la
  CC       libnetfilter_conntrack_icmp.lo
  CCLD     nfct_proto_icmp.la
  CC       libnetfilter_conntrack_sctp.lo
  CCLD     nfct_proto_sctp.la
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/extensions'
Making all in utils
make[1]: Entering directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/utils'
  CC       expect_dump.o
  CCLD     expect_dump
  CC       expect_create.o
  CCLD     expect_create
  CC       expect_get.o
  CCLD     expect_get
  CC       expect_delete.o
  CCLD     expect_delete
  CC       expect_flush.o
  CCLD     expect_flush
  CC       expect_events.o
  CCLD     expect_events
  CC       conntrack_create.o
  CCLD     conntrack_create
  CC       conntrack_dump.o
  CCLD     conntrack_dump
  CC       conntrack_update.o
  CCLD     conntrack_update
  CC       conntrack_delete.o
  CCLD     conntrack_delete
  CC       conntrack_flush.o
  CCLD     conntrack_flush
  CC       conntrack_create_nat.o
  CCLD     conntrack_create_nat
  CC       conntrack_get.o
  CCLD     conntrack_get
  CC       conntrack_events.o
  CCLD     conntrack_events
make[1]: *** No rule to make target `conntrack_master.o', needed by `conntrack_master'.  Stop.
make[1]: Leaving directory `/usr/src/packages/BUILD/netfilter-tools-0.svn7135/libnetfilter_conntrack/utils'
make: *** [all-recursive] Error 1
error: Bad exit status from /var/tmp/rpm-tmp.7694 (%build)


RPM build errors:
    Bad exit status from /var/tmp/rpm-tmp.7694 (%build)
