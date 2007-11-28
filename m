From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: IPT [PATCH] autotools, number 2
Date: Wed, 28 Nov 2007 14:11:59 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711281410440.16364@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0711280140320.4181@fbirervta.pbzchgretzou.qr>
 <474D2B75.9070301@trash.net> <Pine.LNX.4.64.0711281149100.16364@fbirervta.pbzchgretzou.qr>
 <474D5010.10609@trash.net> <Pine.LNX.4.64.0711281246420.16364@fbirervta.pbzchgretzou.qr>
 <474D57DF.1030002@trash.net> <Pine.LNX.4.64.0711281305260.16364@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47737 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753248AbXK1NMB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Nov 2007 08:12:01 -0500
In-Reply-To: <Pine.LNX.4.64.0711281305260.16364@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


	=E2=80=9CRound 2.=E2=80=9D

Converts the iptables build infrastructure to autotools.

	- Can build both static and dynamic at the same time

	- iptables-static will be a multi-binary, semi-static
	  (link against libc but w/o dynamic plugins)

	- Always build IPv6 modules unconditionally

	- not happy with .*-test as it interferes with wildcarding

	- consider INSTALL

	(- consider enhancing your automake installation by
	  automake-tranquility.diff to get kbuild-style silent building)

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Patch instructions:
 delete Makefile
 delete Rules.make
 delete extensions/Makefile
 delete libiptc/Makefile
 create autogen.sh with mode 0755
 rename libipt_dscp_helper.c to dscp_helper.c (delete hunks before appl=
ying)

---
 INSTALL                         |   47 +++++----
 Makefile.am                     |   89 +++++++++++++++++
 autogen.sh                      |    4=20
 configure.ac                    |   54 ++++++++++
 extensions/.condition-test      |    5=20
 extensions/.condition-test6     |    5=20
 extensions/.set-test            |    4=20
 extensions/GNUmakefile.in       |  204 +++++++++++++++++++++++++++++++=
+++++++++
 extensions/dscp_helper.c        |   81 +++++++++++++++
 extensions/libipt_dscp_helper.c |   81 ---------------
 extensions/libxt_DSCP.c         |    2=20
 extensions/libxt_dscp.c         |    2=20
 include/xtables.h               |   13 +-
 libipq/Makefile.am              |   11 ++
 14 files changed, 487 insertions(+), 115 deletions(-)

Index: iptables/INSTALL
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/INSTALL
+++ iptables/INSTALL
@@ -5,15 +5,21 @@ FOLLOW THESE STEPS:
    in a seperate package, called patch-o-matic.  It is available from
    ftp://ftp.netfilter.org/pub/patch-o-matic/
=20
-1) Next, make the package.
-	% make KERNEL_DIR=3D<<where-you-built-your-kernel>>
+1) Next, make the package. If you use a standard distribution kernel,
+   just run ./configure.
=20
-2) Finally, you need to to install the shared libraries, and the binar=
y:
-	# make install KERNEL_DIR=3D<<where-you-built-your-kernel>>
+   If you want to build against an own kernel tree:
=20
-If you are a developer, you can install the headers, development libra=
ries
-and associated development man pages, with:
-	# make install-devel
+	$ ./configure --with-kernel=3D/home/jengelh/mykernel
+
+   or whereever you put it. If you are using a dedicated kernel build
+   directory, you use:
+
+	$ ./configure --with-kbuild=3D<<where-built>> --with-ksource=3D<<sour=
ce>>
+
+2) Finally, you need to install the binaries and shared libraries:
+
+	# make install
=20
 That's it!
 =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
@@ -21,27 +27,26 @@ PROBLEMS YOU MAY ENCOUNTER:
=20
 1) This package requires a 2.4.4 kernel, or above.
=20
-2) If you get the kernel directory wrong, you may see a message like:
-	Please try `make KERNEL_DIR=3Dpath-to-correct-kernel'
+2) If you get the kernel directory wrong, you may get compile failures=
=2E
=20
 3) If you want to specify alternate directories for installation
 (instead of /usr/local/ bin lib man), do this:
=20
-	% make BINDIR=3D/usr/bin LIBDIR=3D/usr/lib MANDIR=3D/usr/man
-	# make BINDIR=3D/usr/bin LIBDIR=3D/usr/lib MANDIR=3D/usr/man install
+	$ ./configure --prefix=3D/usr
+	$ make
+	# make install
+
+4) The make process will automatically build a multipurpose binary und=
er the
+   names iptables-multi and ip6tables-multi.
=20
-4) If you want to build a statically linked version of the iptables bi=
nary,
+5) If you want to build a statically linked version of the iptables bi=
nary,
    without the need for loading the plugins at runtime (e.g. for an em=
bedded
    device or router-on-a-disk), please use
=20
-	% make NO_SHARED_LIBS=3D1
-
-5) If you want to build a single BusyBox style multipurpose binary ins=
tead of
-   the individual iptables, iptables-save and iptables-restore binarie=
s, then
-   please use
+	$ ./configure --enable-static
=20
-	% make DO_MULTI=3D1
+   which will build both a semi-static multi binary (iptables-mtss, us=
es
+   libc but not plugins) and a fully static multi binary (iptables-sta=
tic).
=20
-NOTE: make sure you build with at least the correct LIBDIR=3D
-specification, otherwise iptables(8) won't know where to find the
-dynamic objects.
+6) If you want to install libipq (old interface), add --enable-devel t=
o
+   ./configure.
Index: iptables/Makefile.am
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/Makefile.am
@@ -0,0 +1,89 @@
+# -*- Makefile -*-
+
+AUTOMAKE_OPTIONS =3D foreign subdir-objects
+AM_CFLAGS        =3D ${regular_CFLAGS} -I${top_srcdir}/include
+SUBDIRS         :=3D extensions
+if ENABLE_DEVEL
+SUBDIRS         +=3D libipq
+endif
+
+# libiptc
+libiptc_libiptc_a_SOURCES =3D libiptc/libip4tc.c libiptc/libip6tc.c
+
+# iptables, dynamic
+iptables_SOURCES          =3D iptables-standalone.c iptables.c xtables=
=2Ec
+iptables_LDFLAGS          =3D -rdynamic
+iptables_LDADD            =3D -ldl libiptc/libiptc.a extensions/libext=
4.a
+
+iptables_multi_SOURCES    =3D iptables-multi.c iptables-save.c \
+                            iptables-restore.c iptables-xml.c \
+                            iptables-standalone.c iptables.c xtables.c
+iptables_multi_CFLAGS     =3D ${AM_CFLAGS} -DIPTABLES_MULTI
+iptables_multi_LDFLAGS    =3D ${iptables_LDFLAGS}
+iptables_multi_LDADD      =3D ${iptables_LDADD}
+
+iptables_restore_SOURCES  =3D iptables-restore.c iptables.c xtables.c
+iptables_restore_LDFLAGS  =3D ${iptables_LDFLAGS}
+iptables_restore_LDADD    =3D ${iptables_LDADD}
+
+iptables_save_SOURCES     =3D iptables-save.c iptables.c xtables.c
+iptables_save_LDFLAGS     =3D ${iptables_LDFLAGS}
+iptables_save_LDADD       =3D ${iptables_LDADD}
+
+# iptables-multi, semi-static
+iptables_static_SOURCES   =3D ${iptables_multi_SOURCES}
+iptables_static_CFLAGS    =3D ${iptables_multi_CFLAGS} -DNO_SHARED_LIB=
S=3D1
+iptables_static_LDADD     =3D libiptc/libiptc.a extensions/libext4.a
+
+iptables_xml_SOURCES      =3D iptables-xml.c
+
+# ip6tables, dynamic
+ip6tables_SOURCES         =3D ip6tables-standalone.c ip6tables.c xtabl=
es.c
+ip6tables_LDFLAGS         =3D -rdynamic
+ip6tables_LDADD           =3D -ldl libiptc/libiptc.a extensions/libext=
6.a
+
+ip6tables_multi_SOURCES   =3D ip6tables-multi.c ip6tables-save.c \
+                            ip6tables-restore.c ip6tables-standalone.c=
 \
+                            ip6tables.c xtables.c
+ip6tables_multi_CFLAGS    =3D ${AM_CFLAGS} -DIPTABLES_MULTI
+ip6tables_multi_LDFLAGS   =3D ${ip6tables_LDFLAGS}
+ip6tables_multi_LDADD     =3D ${ip6tables_LDADD}
+
+ip6tables_restore_SOURCES =3D ip6tables-restore.c ip6tables.c xtables.=
c
+ip6tables_restore_LDFLAGS =3D ${ip6tables_LDFLAGS}
+ip6tables_restore_LDADD   =3D ${ip6tables_LDADD}
+
+ip6tables_save_SOURCES    =3D ip6tables-save.c ip6tables.c xtables.c
+ip6tables_save_LDFLAGS    =3D ${ip6tables_LDFLAGS}
+ip6tables_save_LDADD      =3D ${ip6tables_LDADD}
+
+# iptables-multi, semi-static
+ip6tables_static_SOURCES    =3D ${ip6tables_multi_SOURCES}
+ip6tables_static_CFLAGS     =3D ${ip6tables_multi_CFLAGS} -DNO_SHARED_=
LIBS=3D1
+ip6tables_static_LDADD      =3D libiptc/libiptc.a extensions/libext6.a
+
+noinst_LIBRARIES :=3D libiptc/libiptc.a
+bin_PROGRAMS     :=3D iptables-xml
+sbin_PROGRAMS    :=3D
+noinst_PROGRAMS  :=3D
+man_MANS         :=3D iptables.8 iptables-restore.8 iptables-save.8 \
+                    iptables-xml.8 ip6tables.8 ip6tables-restore.8 \
+                    ip6tables-save.8
+CLEANFILES       :=3D iptables.8 ip6tables.8
+
+if ENABLE_STATIC
+sbin_PROGRAMS +=3D iptables-static ip6tables-static
+endif
+if ENABLE_SHARED
+sbin_PROGRAMS +=3D iptables iptables-multi iptables-restore iptables-s=
ave \
+                 ip6tables ip6tables-multi ip6tables-restore ip6tables=
-save
+endif
+
+iptables.8: ${srcdir}/iptables.8.in extensions/matches4.man extensions=
/targets4.man
+	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches4.man' -e '/@=
TARGET@/ r extensions/targets4.man' $< >$@;
+
+ip6tables.8: ${srcdir}/ip6tables.8.in extensions/matches6.man extensio=
ns/targets6.man
+	${AM_VERBOSE_GEN} sed -e '/@MATCH@/ r extensions/matches6.man' -e '/@=
TARGET@/ r extensions/targets6.man' $< >$@;
+
+extensions/%:
+	${MAKE} ${AM_MAKEFLAGS} -C $(@D) $(@F)
Index: iptables/autogen.sh
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/autogen.sh
@@ -0,0 +1,4 @@
+#!/bin/bash
+
+autoreconf -fi;
+rm -Rf autom4te*.cache;
Index: iptables/configure.ac
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/configure.ac
@@ -0,0 +1,54 @@
+
+AC_INIT(iptables, 1.4.0rc1)
+AC_CONFIG_HEADERS(config.h)
+AC_PROG_INSTALL
+AM_INIT_AUTOMAKE
+AC_PROG_CC
+AM_PROG_CC_C_O
+AC_DISABLE_STATIC
+AC_PROG_LIBTOOL
+
+AC_ARG_WITH([kernel],
+	AS_HELP_STRING([--with-kernel=3DPATH],
+	[Path to kernel source/build directory]),
+	[kbuilddir=3D"$withval"; ksourcedir=3D"$withval";])
+AC_ARG_WITH([kbuild],
+	AS_HELP_STRING([--with-kbuild=3DPATH],
+	[Path to kernel build directory [[/lib/modules/CURRENT/build]]]),
+	[kbuilddir=3D"$withval"],
+	[kbuilddir=3D"/lib/modules/$(uname -r)/build"])
+AC_ARG_WITH([ksource],
+	AS_HELP_STRING([--with-ksource=3DPATH],
+	[Path to kernel source directory [[/lib/modules/CURRENT/source]]]),
+	[ksourcedir=3D"$withval"],
+	[ksourcedir=3D"/lib/modules/$(uname -r)/source"])
+AC_ARG_WITH([iptdir],
+	AS_HELP_STRING([--with-iptdir=3DPATH],
+	[Path to iptables modules [[LIBEXECDIR/iptables]]]),
+	[iptdir=3D"$withval"],
+	[iptdir=3D"${libexecdir}/iptables"])
+AC_ARG_ENABLE([devel],
+	AS_HELP_STRING([--enable-devel],
+	[Build and install development files (libipq, libipq-devel, iptables-=
devel)]))
+
+AC_CHECK_HEADER([netinet/ip6.h], [], [AC_MSG_ERROR(but we need that fo=
r IPv6)])
+AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" =3D=3D "yes"])
+AM_CONDITIONAL([ENABLE_SHARED], [test "$enable_shared" =3D=3D "yes"])
+AM_CONDITIONAL([ENABLE_DEVEL], [test "$enable_devel" =3D=3D "yes"])
+
+regular_CFLAGS=3D"-D_LARGEFILE_SOURCE=3D1 -D_LARGE_FILES -D_FILE_OFFSE=
T_BITS=3D64 \
+	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
+	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
+	-Winline -pipe -DIPTABLES_VERSION=3D\\\"$PACKAGE_VERSION\\\" \
+	-I\"$kbuilddir/include\" -I\"$ksourcedir/include\""
+
+# Remove workarounds soon
+regular_CFLAGS=3D"$regular_CFLAGS -Wno-aggregate-return \
+	-Wno-missing-declarations -Wno-missing-prototypes \
+	-Wno-redundant-decls -Wno-shadow -Wno-strict-prototypes -Wno-inline"
+
+AC_SUBST([regular_CFLAGS])
+AC_SUBST([kbuilddir])
+AC_SUBST([ksourcedir])
+AC_SUBST([iptdir])
+AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile])
Index: iptables/extensions/.condition-test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/.condition-test
+++ iptables/extensions/.condition-test
@@ -1,3 +1,4 @@
 #!/bin/sh
-# True if condition is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h ] && ech=
o condition
+[ "$1" =3D=3D "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv4/ipt_condition.h" ] && \
+echo "condition";
Index: iptables/extensions/.condition-test6
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/.condition-test6
+++ iptables/extensions/.condition-test6
@@ -1,3 +1,4 @@
 #!/bin/sh
-# True if condition6 is applied.
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h ] && ec=
ho condition
+[ "$1" =3D=3D "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv6/ip6t_condition.h" ] && \
+echo "condition";
Index: iptables/extensions/.set-test
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/.set-test
+++ iptables/extensions/.set-test
@@ -1,2 +1,4 @@
 #! /bin/sh
-[ -f $KERNEL_DIR/include/linux/netfilter_ipv4/ip_set.h ] && echo set S=
ET
+[ "$1" =3D=3D "provides" -o \
+-f "$KERNEL_DIR/include/linux/netfilter_ipv4/ip_set.h" ] && \
+echo "set SET";
Index: iptables/extensions/GNUmakefile.in
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/GNUmakefile.in
@@ -0,0 +1,204 @@
+# -*- Makefile -*-
+
+top_srcdir  :=3D @top_srcdir@
+srcdir      :=3D @srcdir@
+ksourcedir  :=3D @ksourcedir@
+prefix      :=3D @prefix@
+exec_prefix :=3D @exec_prefix@
+libdir      :=3D @libdir@
+libexecdir  :=3D @libexecdir@
+iptdir      :=3D @iptdir@
+
+CC             :=3D @CC@
+CCLD           :=3D ${CC}
+CFLAGS         :=3D @CFLAGS@
+LDFLAGS        :=3D @LDFLAGS@
+regular_CFLAGS :=3D @regular_CFLAGS@
+
+AM_CFLAGS      :=3D ${regular_CFLAGS} -I${top_srcdir}/include
+AM_DEPFLAGS     =3D -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
+
+ifeq (${V},)
+AM_LIBTOOL_SILENT =3D --silent
+AM_VERBOSE_CC     =3D @echo "  CC      " $@;
+AM_VERBOSE_CCLD   =3D @echo "  CCLD    " $@;
+AM_VERBOSE_CXX    =3D @echo "  CXX     " $@;
+AM_VERBOSE_CXXLD  =3D @echo "  CXXLD   " $@;
+AM_VERBOSE_AR     =3D @echo "  AR      " $@;
+AM_VERBOSE_GEN    =3D @echo "  GEN     " $@;
+endif
+
+#
+#	Wildcard module list
+#
+pfx_all_mod :=3D $(patsubst ${srcdir}/libxt_%.c,%,$(wildcard ${srcdir}=
/libxt_*.c))
+pf4_all_mod :=3D $(patsubst ${srcdir}/libipt_%.c,%,$(wildcard ${srcdir=
}/libipt_*.c))
+pf6_all_mod :=3D $(patsubst ${srcdir}/libip6t_%.c,%,$(wildcard ${srcdi=
r}/libip6t_*.c))
+
+#
+#	Conditional module list
+#
+pfx_cond_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell K=
ERNEL_DIR=3D${ksourcedir} ${i} provides))
+pf4_cond_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KE=
RNEL_DIR=3D${ksourcedir} ${i} provides))
+pf6_cond_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell K=
ERNEL_DIR=3D${ksourcedir} ${i} provides))
+
+#
+#	Conditional modules to build
+#
+pfx_bc_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-testx),$(shell KER=
NEL_DIR=3D${ksourcedir} ${i}))
+pf4_bc_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-test),$(shell KERN=
EL_DIR=3D${ksourcedir} ${i}))
+pf6_bc_mod :=3D $(foreach i,$(wildcard ${srcdir}/.*-test6),$(shell KER=
NEL_DIR=3D${ksourcedir} ${i}))
+
+#
+#	Total list of modules to build
+#
+pfx_build_mod :=3D $(filter-out ${pfx_cond_mod},${pfx_all_mod}) ${pfx_=
bc_mod}
+pf4_build_mod :=3D $(filter-out ${pf4_cond_mod},${pf4_all_mod}) ${pf4_=
bc_mod}
+pf6_build_mod :=3D $(filter-out ${pf6_cond_mod},${pf6_all_mod}) ${pf6_=
bc_mod}
+pfx_objs      :=3D $(patsubst %,libxt_%.o,${pfx_build_mod})
+pf4_objs      :=3D $(patsubst %,libipt_%.o,${pf4_build_mod})
+pf6_objs      :=3D $(patsubst %,libip6t_%.o,${pf6_build_mod})
+pfx_solibs    :=3D $(patsubst %,libxt_%.so,${pfx_build_mod})
+pf4_solibs    :=3D $(patsubst %,libipt_%.so,${pf4_build_mod})
+pf6_solibs    :=3D $(patsubst %,libip6t_%.so,${pf6_build_mod})
+
+
+#
+# Building blocks
+#
+targets :=3D libext4.a libext6.a matches4.man matches6.man \
+           targets4.man targets6.man
+targets_install :=3D
+@ENABLE_STATIC_TRUE@ libext4_objs :=3D ${pfx_objs} ${pf4_objs}
+@ENABLE_STATIC_TRUE@ libext6_objs :=3D ${pfx_objs} ${pf6_objs}
+@ENABLE_SHARED_TRUE@ targets +=3D ${pfx_solibs} ${pf4_solibs} ${pf6_so=
libs}
+@ENABLE_SHARED_TRUE@ targets_install +=3D ${pfx_solibs} ${pf4_solibs} =
${pf6_solibs}
+
+.SECONDARY:
+
+.PHONY: all install clean distclean
+
+all: ${targets}
+
+install: ${targets_install}
+	@mkdir -p "${DESTDIR}${iptdir}";
+	install -pm0755 $^ "${DESTDIR}${iptdir}/";
+
+clean:
+	rm -f *.o *.oo *.so *.a *.man initext4.c initext6.c;
+
+distclean: clean
+	rm -f .*.d .*.dd;
+
+%.o: %.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} ${CFLAGS} -o $@ -c=
 $<;
+
+-include .*.d
+
+
+#
+#	Shared libraries
+#
+lib%.so: lib%.oo
+	${AM_VERBOSE_CCLD} ${CCLD} ${AM_LDFLAGS} -shared ${LDFLAGS} -o $@ $<;
+
+lib%.oo: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=3D$*_init =
-DPIC -fPIC ${CFLAGS} -o $@ -c $<;
+
+
+#
+#	Static bits
+#
+#	If static building is disabled, libext*.a will still be generated,
+#	but will be empty. This is good since we can do with less case
+#	handling code in the Makefiles.
+#
+lib%.o: ${srcdir}/lib%.c
+	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -DNO_SHARED_LIBS=3D=
1 -D_INIT=3D$*_init ${CFLAGS} -o $@ -c $<;
+
+libext4.a: initext4.o ${libext4_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
+libext6.a: initext6.o ${libext6_objs}
+	${AM_VERBOSE_AR} ${AR} crs $@ $^;
+
+initext_func  :=3D $(addprefix xt_,${pfx_build_mod}) $(addprefix ipt_,=
${pf4_build_mod})
+initext6_func :=3D $(addprefix xt_,${pfx_build_mod}) $(addprefix ip6t_=
,${pf6_build_mod})
+
+.initext4.dd:
+	@echo "${initext_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
+.initext6.dd:
+	@echo "${initext6_func}" >$@.tmp; \
+	cmp -s $@ $@.tmp || mv $@.tmp $@; \
+	rm -f $@.tmp;
+
+initext4.c: .initext4.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initext_func}; do \
+		echo "extern void $${i}_init(void);" >>$@; \
+	done; \
+	echo -en "void init_extensions(void)\n""{\n" >>$@; \
+	for i in ${initext_func}; do \
+		echo -e "\t""$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
+initext6.c: .initext6.dd
+	${AM_VERBOSE_GEN}
+	@( \
+	echo "" >$@; \
+	for i in ${initext6_func}; do \
+		echo "extern void $${i}_init(void);" >>$@; \
+	done; \
+	echo -en "void init_extensions(void)\n""{\n" >>$@; \
+	for i in ${initext6_func}; do \
+		echo -e "\t""$${i}_init();" >>$@; \
+	done; \
+	echo "}" >>$@; \
+	);
+
+#
+#	Manual pages
+#
+ex_matches =3D $(sort $(shell echo $(1) | grep -Eo '\b[a-z0-9]+\b'))
+ex_targets =3D $(sort $(shell echo $(1) | grep -Eo '\b[A-Z0-9]+\b'))
+man_run    =3D \
+	${AM_VERBOSE_GEN} \
+	for ext in $(1); do \
+		f=3D"${srcdir}/libxt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+		f=3D"${srcdir}/libipt_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+		f=3D"${srcdir}/libip6t_$$ext.man"; \
+		if [ -f "$$f" ]; then \
+			echo ".SS $$ext"; \
+			cat "$$f"; \
+			continue; \
+		fi; \
+	done >$@;
+
+matches4.man: .initext4.dd
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf4_build_mod}))
+
+matches6.man: .initext6.dd
+	$(call man_run,$(call ex_matches,${pfx_build_mod} ${pf6_build_mod}))
+
+targets4.man: .initext4.dd
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf4_build_mod}))
+
+targets6.man: .initext6.dd
+	$(call man_run,$(call ex_targets,${pfx_build_mod} ${pf6_build_mod}))
Index: iptables/extensions/dscp_helper.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/extensions/dscp_helper.c
@@ -0,0 +1,81 @@
+/*
+ * DiffServ classname <-> DiffServ codepoint mapping functions.
+ *
+ * The latest list of the mappings can be found at:
+ * <http://www.iana.org/assignments/dscp-registry>
+ *
+ * This code is released under the GNU GPL v2, 1991
+ *
+ * Author: Iain Barnes
+ */
+
+#include <stdio.h>
+#include <string.h>
+#include <xtables.h>
+
+
+static const struct ds_class
+{
+	const char *name;
+	unsigned int dscp;
+} ds_classes[] =3D
+{
+	{ "CS0", 0x00 },
+	{ "CS1", 0x08 },
+	{ "CS2", 0x10 },
+	{ "CS3", 0x18 },
+	{ "CS4", 0x20 },
+	{ "CS5", 0x28 },
+	{ "CS6", 0x30 },
+	{ "CS7", 0x38 },
+	{ "BE", 0x00 },
+	{ "AF11", 0x0a },
+	{ "AF12", 0x0c },
+	{ "AF13", 0x0e },
+	{ "AF21", 0x12 },
+	{ "AF22", 0x14 },
+	{ "AF23", 0x16 },
+	{ "AF31", 0x1a },
+	{ "AF32", 0x1c },
+	{ "AF33", 0x1e },
+	{ "AF41", 0x22 },
+	{ "AF42", 0x24 },
+	{ "AF43", 0x26 },
+	{ "EF", 0x2e }
+};
+
+
+
+static unsigned int
+class_to_dscp(const char *name)
+{
+	int i;
+
+	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) =
{
+		if (!strncasecmp(name, ds_classes[i].name,
+					strlen(ds_classes[i].name)))
+			return ds_classes[i].dscp;
+	}
+
+	exit_error(PARAMETER_PROBLEM,
+			"Invalid DSCP value `%s'\n", name);
+}
+
+
+#if 0
+static const char *
+dscp_to_name(unsigned int dscp)
+{
+	int i;
+
+	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) =
{
+		if (dscp =3D=3D ds_classes[i].dscp)
+			return ds_classes[i].name;
+	}
+
+
+	exit_error(PARAMETER_PROBLEM,
+			"Invalid DSCP value `%d'\n", dscp);
+}
+#endif
+
Index: iptables/extensions/libipt_dscp_helper.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libipt_dscp_helper.c
+++ /dev/null
@@ -1,81 +0,0 @@
-/*
- * DiffServ classname <-> DiffServ codepoint mapping functions.
- *
- * The latest list of the mappings can be found at:
- * <http://www.iana.org/assignments/dscp-registry>
- *
- * This code is released under the GNU GPL v2, 1991
- *=20
- * Author: Iain Barnes
- */
-
-#include <stdio.h>
-#include <string.h>
-#include <xtables.h>
-
-
-static const struct ds_class
-{
-	const char *name;
-	unsigned int dscp;
-} ds_classes[] =3D=20
-{
-	{ "CS0", 0x00 },
-	{ "CS1", 0x08 },
-	{ "CS2", 0x10 },
-	{ "CS3", 0x18 },
-	{ "CS4", 0x20 },
-	{ "CS5", 0x28 },
-	{ "CS6", 0x30 },
-	{ "CS7", 0x38 },
-	{ "BE", 0x00 },
-	{ "AF11", 0x0a },
-	{ "AF12", 0x0c },
-	{ "AF13", 0x0e },
-	{ "AF21", 0x12 },
-	{ "AF22", 0x14 },
-	{ "AF23", 0x16 },
-	{ "AF31", 0x1a },
-	{ "AF32", 0x1c },
-	{ "AF33", 0x1e },
-	{ "AF41", 0x22 },
-	{ "AF42", 0x24 },
-	{ "AF43", 0x26 },
-	{ "EF", 0x2e }
-};
-
-
-
-static unsigned int=20
-class_to_dscp(const char *name)
-{
-	int i;
-
-	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) =
{
-		if (!strncasecmp(name, ds_classes[i].name,
-					strlen(ds_classes[i].name)))=20
-			return ds_classes[i].dscp;
-	}
-
-	exit_error(PARAMETER_PROBLEM,=20
-			"Invalid DSCP value `%s'\n", name);
-}
-
-
-#if 0
-static const char *
-dscp_to_name(unsigned int dscp)
-{
-	int i;
-
-	for (i =3D 0; i < sizeof(ds_classes) / sizeof(struct ds_class); i++) =
{
-		if (dscp =3D=3D ds_classes[i].dscp)
-			return ds_classes[i].name;
-	}
-
-=09
-	exit_error(PARAMETER_PROBLEM,
-			"Invalid DSCP value `%d'\n", dscp);
-}
-#endif
-
Index: iptables/extensions/libxt_DSCP.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_DSCP.c
+++ iptables/extensions/libxt_DSCP.c
@@ -19,7 +19,7 @@
 #include <linux/netfilter/xt_DSCP.h>
=20
 /* This is evil, but it's my code - HW*/
-#include "libipt_dscp_helper.c"
+#include "dscp_helper.c"
=20
 static void DSCP_help(void)
 {
Index: iptables/extensions/libxt_dscp.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/extensions/libxt_dscp.c
+++ iptables/extensions/libxt_dscp.c
@@ -22,7 +22,7 @@
 #include <linux/netfilter/xt_dscp.h>
=20
 /* This is evil, but it's my code - HW*/
-#include "libipt_dscp_helper.c"
+#include "dscp_helper.c"
=20
 static void dscp_help(void)
 {
Index: iptables/include/xtables.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- iptables.orig/include/xtables.h
+++ iptables/include/xtables.h
@@ -225,13 +225,14 @@ void exit_error(enum exittype, const cha
 							  format(printf,2,3)));
 extern const char *program_name, *program_version;
=20
-#define _init __attribute__((constructor)) my_init
 #ifdef NO_SHARED_LIBS
-# ifdef _INIT
-#  undef _init
-#  define _init _INIT
-# endif
-  extern void init_extensions(void);
+#	ifdef _INIT
+#		undef _init
+#		define _init _INIT
+#	endif
+	extern void init_extensions(void);
+#else
+#	define _init __attribute__((constructor)) _INIT
 #endif
=20
 #define __be32	u_int32_t
Index: iptables/libipq/Makefile.am
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- /dev/null
+++ iptables/libipq/Makefile.am
@@ -0,0 +1,11 @@
+# -*- Makefile -*-
+
+AM_CFLAGS =3D ${regular_CFLAGS} -I${top_srcdir}/include
+
+libipq_a_SOURCES =3D libipq.c
+lib_LIBRARIES    =3D libipq.a
+include_HEADERS  =3D ${top_srcdir}/include/libipq/libipq.h
+man_MANS         =3D ipq_create_handle.3 ipq_destroy_handle.3 ipq_errs=
tr.3 \
+                   ipq_get_msgerr.3 ipq_get_packet.3 ipq_message_type.=
3 \
+                   ipq_perror.3 ipq_read.3 ipq_set_mode.3 ipq_set_verd=
ict.3 \
+                   libipq.3
-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
