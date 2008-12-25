From: Jan Engelhardt <jengelh@medozas.de>
Subject: build: resolve autotools suggestions
Date: Thu, 25 Dec 2008 20:21:43 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:53200 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbYLYTVq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Dec 2008 14:21:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

parent cea9f71f5618250a38acb21c31fbbf93a752f7d4
commit 6fdeb9468f1bac11698b200530cd454a167e1e39
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Dec 25 20:21:36 2008 +0100

build: resolve autotools suggestions

libtool2 wants to put files into m4, so let it have it.
---
 Makefile.am   |    1 +
 configure.ac  |   10 ++++++----
 m4/.gitignore |    2 ++
 3 files changed, 9 insertions(+), 4 deletions(-)
 create mode 100644 m4/.gitignore

diff --git a/Makefile.am b/Makefile.am
index 5465db6..ced23b3 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,6 @@
 # -*- Makefile -*-
 
+ACLOCAL_AMFLAGS  = -I m4
 AUTOMAKE_OPTIONS = foreign subdir-objects
 
 AM_CFLAGS        = ${regular_CFLAGS} -I${top_builddir}/include -I${top_srcdir}/include ${kinclude_CFLAGS}
diff --git a/configure.ac b/configure.ac
index 39fa0ec..8c9c30d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -7,12 +7,13 @@ define([_XTABLES_VERSION],_XTABLES_VERSION_MAJOR._XTABLES_VERSION_MINOR._XTABLES
 
 AC_INIT([iptables], _XTABLES_VERSION)
 AC_CONFIG_HEADERS([config.h])
+AC_CONFIG_MACRO_DIR([m4])
 AC_PROG_INSTALL
-AM_INIT_AUTOMAKE
+AM_INIT_AUTOMAKE([-Wall])
 AC_PROG_CC
 AM_PROG_CC_C_O
 AC_DISABLE_STATIC
-AC_PROG_LIBTOOL
+AM_PROG_LIBTOOL
 
 AC_ARG_WITH([kernel],
 	AS_HELP_STRING([--with-kernel=PATH],
@@ -83,5 +84,6 @@ AC_SUBST([XTABLES_VERSION_MINOR])
 AC_SUBST([XTABLES_VERSION_PATCH])
 AC_SUBST([XTABLES_VERSION_EXTRA])
 
-AC_OUTPUT([Makefile extensions/GNUmakefile libipq/Makefile include/xtables.h
-	xtables.pc])
+AC_CONFIG_FILES([Makefile extensions/GNUmakefile libipq/Makefile
+	include/xtables.h xtables.pc])
+AC_OUTPUT
diff --git a/m4/.gitignore b/m4/.gitignore
new file mode 100644
index 0000000..64d9bbc
--- /dev/null
+++ b/m4/.gitignore
@@ -0,0 +1,2 @@
+/libtool.m4
+/lt*.m4

