From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 2/5][IPTABLES]: Give preference to iptables header files
Date: Thu, 24 Jan 2008 20:01:58 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801242001410.12676@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42589 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbYAXTB7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Jan 2008 14:01:59 -0500
In-Reply-To: <Pine.LNX.4.64.0801242000350.12676@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Have the header files in the iptables source tree take precedence
over those from the kernel source. Otherwise, building the current
iptables from subversion just fails with kernels < 2.6.25.

Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

---
 Makefile.am               |    5 ++++-
 configure.ac              |    6 +++---
 extensions/GNUmakefile.in |    5 +++--
 3 files changed, 10 insertions(+), 6 deletions(-)

Index: iptables-modules/Makefile.am
===================================================================
--- iptables-modules.orig/Makefile.am
+++ iptables-modules/Makefile.am
@@ -1,7 +1,10 @@
 # -*- Makefile -*-
 
 AUTOMAKE_OPTIONS = foreign subdir-objects
-AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include
+
+regular_CFLAGS  := @regular_CFLAGS@
+kinclude_CFLAGS := @kinclude_CFLAGS@
+AM_CFLAGS        = ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
 SUBDIRS         := extensions
 if ENABLE_DEVEL
 SUBDIRS         += libipq
Index: iptables-modules/configure.ac
===================================================================
--- iptables-modules.orig/configure.ac
+++ iptables-modules/configure.ac
@@ -40,15 +40,15 @@ regular_CFLAGS="-D_LARGEFILE_SOURCE=1 -D
 	-D_REENTRANT -Wall -Waggregate-return -Wmissing-declarations \
 	-Wmissing-prototypes -Wredundant-decls -Wshadow -Wstrict-prototypes \
 	-Winline -pipe -DIPTABLES_VERSION=\\\"$PACKAGE_VERSION\\\" \
-	-DIPT_LIB_DIR=\\\"\${iptdir}\\\" \
-	-I\"$kbuilddir/include\" -I\"$ksourcedir/include\""
+	-DIPT_LIB_DIR=\\\"\${iptdir}\\\"";
+kinclude_CFLAGS="-I\"$kbuilddir/include\" -I\"$ksourcedir/include\"";
 
 # Remove workarounds soon
 regular_CFLAGS="$regular_CFLAGS -Wno-aggregate-return \
 	-Wno-missing-declarations -Wno-missing-prototypes \
 	-Wno-redundant-decls -Wno-shadow -Wno-strict-prototypes -Wno-inline"
 
-AC_SUBST([regular_CFLAGS])
+AC_SUBST([regular_CFLAGS kinclude_CFLAGS])
 AC_SUBST([kbuilddir])
 AC_SUBST([ksourcedir])
 AC_SUBST([iptdir])
Index: iptables-modules/extensions/GNUmakefile.in
===================================================================
--- iptables-modules.orig/extensions/GNUmakefile.in
+++ iptables-modules/extensions/GNUmakefile.in
@@ -14,8 +14,9 @@ CCLD           := ${CC}
 CFLAGS         := @CFLAGS@
 LDFLAGS        := @LDFLAGS@
 regular_CFLAGS := @regular_CFLAGS@
+kinclude_CFLAGS := @kinclude_CFLAGS@
 
-AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include
+AM_CFLAGS      := ${regular_CFLAGS} -I${top_srcdir}/include ${kinclude_CFLAGS}
 AM_DEPFLAGS     = -Wp,-MMD,$(@D)/.$(@F).d,-MT,$@
 
 ifeq (${V},)
@@ -88,7 +89,7 @@ clean:
 	rm -f *.o *.oo *.so *.a {matches,targets}[46].man initext4.c initext6.c;
 
 distclean: clean
-	rm -f .*.d *.dd;
+	rm -f .*.d .*.dd;
 
 %.o: %.c
 	${AM_VERBOSE_CC} ${CC} ${AM_DEPFLAGS} ${AM_CFLAGS} -D_INIT=$*_init ${CFLAGS} -o $@ -c $<;
