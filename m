From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Can't build iptables (git as of today)
Date: Sun, 18 Sep 2011 15:12:11 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109181509580.16287@frira.zrqbmnf.qr>
References: <4E75E21D.6050000@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:41230 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1IRNMN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Sep 2011 09:12:13 -0400
In-Reply-To: <4E75E21D.6050000@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-09-18 14:20, Richard Weinberger wrote:

>Hi!
>
>I'm trying to build the most recent iptables version but the build fails
>with:
>
>make[2]: *** No rule to make target `../extensions/libext.a', needed by
>`xtables-multi'.  Stop.
>
>It this a known problem?

Now it is; and this is the fix

git://dev.medozas.de/iptables master
parent 0ab10b11093ec250b404e3bead1d39177d1cbfa0 (v1.4.12.1-28-g0ab10b1)
commit f65d798473255d1bc1a5cd31bb586a60ad8fdf3d
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Sun Sep 18 15:06:05 2011 +0200

build: restore build order of modules

iptables(exe) requires libext.a, but extensions/ require libxtables.la
(in iptables/). This circular dependency does not work out, so
separate libxtables into its own directory and put it in front.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 Makefile.am                          |    5 ++++-
 configure.ac                         |    2 +-
 iptables/Makefile.am                 |   18 +-----------------
 libxtables/Makefile.am               |   20 ++++++++++++++++++++
 {iptables => libxtables}/xtables.c   |    0
 {iptables => libxtables}/xtoptions.c |    0
 6 files changed, 26 insertions(+), 19 deletions(-)
 create mode 100644 libxtables/Makefile.am
 rename {iptables => libxtables}/xtables.c (100%)
 rename {iptables => libxtables}/xtoptions.c (100%)

diff --git a/Makefile.am b/Makefile.am
index 9167e8e..4eb63eb 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -3,7 +3,7 @@
 ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
-SUBDIRS          = libiptc iptables
+SUBDIRS          = libiptc libxtables
 if ENABLE_DEVEL
 SUBDIRS         += include
 endif
@@ -13,7 +13,10 @@ endif
 if HAVE_LIBNFNETLINK
 SUBDIRS         += utils
 endif
+# Depends on libxtables:
 SUBDIRS         += extensions
+# Depends on extensions/libext.a:
+SUBDIRS         += iptables
 
 .PHONY: tarball
 tarball:
diff --git a/configure.ac b/configure.ac
index 22b7bf1..8afba8c 100644
--- a/configure.ac
+++ b/configure.ac
@@ -112,6 +112,6 @@ AC_SUBST([libxtables_vmajor])
 AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile
 	iptables/Makefile iptables/xtables.pc
 	libipq/Makefile libipq/libipq.pc
-	libiptc/Makefile libiptc/libiptc.pc utils/Makefile
+	libiptc/Makefile libiptc/libiptc.pc libxtables/Makefile utils/Makefile
 	include/xtables.h include/iptables/internal.h])
 AC_OUTPUT
diff --git a/iptables/Makefile.am b/iptables/Makefile.am
index af620f7..bdd4da1 100644
--- a/iptables/Makefile.am
+++ b/iptables/Makefile.am
@@ -3,22 +3,6 @@
 AM_CFLAGS        = ${regular_CFLAGS}
 AM_CPPFLAGS      = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CPPFLAGS}
 
-lib_LTLIBRARIES       = libxtables.la
-libxtables_la_SOURCES = xtables.c xtoptions.c
-libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
-libxtables_la_LIBADD  =
-if ENABLE_STATIC
-# With --enable-static, shipped extensions are linked into the main executable,
-# so we need all the LIBADDs here too
-libxtables_la_LIBADD += -lm
-endif
-if ENABLE_SHARED
-libxtables_la_CFLAGS  = ${AM_CFLAGS}
-libxtables_la_LIBADD += -ldl
-else
-libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
-endif
-
 xtables_multi_SOURCES  = xtables-multi.c iptables-xml.c
 xtables_multi_CFLAGS   = ${AM_CFLAGS}
 xtables_multi_LDADD    = ../extensions/libext.a
@@ -38,7 +22,7 @@ xtables_multi_CFLAGS  += -DENABLE_IPV6
 xtables_multi_LDADD   += ../libiptc/libip6tc.la ../extensions/libext6.a
 endif
 xtables_multi_SOURCES += xshared.c
-xtables_multi_LDADD   += libxtables.la -lm
+xtables_multi_LDADD   += ../libxtables/libxtables.la -lm
 
 sbin_PROGRAMS    = xtables-multi
 man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
diff --git a/libxtables/Makefile.am b/libxtables/Makefile.am
new file mode 100644
index 0000000..c5795fe
--- /dev/null
+++ b/libxtables/Makefile.am
@@ -0,0 +1,20 @@
+# -*- Makefile -*-
+
+AM_CFLAGS   = ${regular_CFLAGS}
+AM_CPPFLAGS = ${regular_CPPFLAGS} -I${top_builddir}/include -I${top_srcdir}/include -I${top_srcdir}/iptables ${kinclude_CPPFLAGS}
+
+lib_LTLIBRARIES       = libxtables.la
+libxtables_la_SOURCES = xtables.c xtoptions.c
+libxtables_la_LDFLAGS = -version-info ${libxtables_vcurrent}:0:${libxtables_vage}
+libxtables_la_LIBADD  =
+if ENABLE_STATIC
+# With --enable-static, shipped extensions are linked into the main executable,
+# so we need all the LIBADDs here too
+libxtables_la_LIBADD += -lm
+endif
+if ENABLE_SHARED
+libxtables_la_CFLAGS  = ${AM_CFLAGS}
+libxtables_la_LIBADD += -ldl
+else
+libxtables_la_CFLAGS  = ${AM_CFLAGS} -DNO_SHARED_LIBS=1
+endif
diff --git a/iptables/xtables.c b/libxtables/xtables.c
similarity index 100%
rename from iptables/xtables.c
rename to libxtables/xtables.c
diff --git a/iptables/xtoptions.c b/libxtables/xtoptions.c
similarity index 100%
rename from iptables/xtoptions.c
rename to libxtables/xtoptions.c
-- 
# Created with git-export-patch
