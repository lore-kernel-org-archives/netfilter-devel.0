From: giorgio.nicole@arcor.de
Subject: [PATCH 1/1] autotools conversion fixups
Date: Sun,  9 Nov 2014 21:26:12 +0100
Message-ID: <1415564772-8873-1-git-send-email-giorgio.nicole@arcor.de>
References: <1415298349-985-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-in-05.arcor-online.net ([151.189.21.45]:38407 "EHLO
	mail-in-05.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751095AbaKIU1E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2014 15:27:04 -0500
Received: from mail-in-01-z2.arcor-online.net (mail-in-01-z2.arcor-online.net [151.189.8.13])
	by mx.arcor.de (Postfix) with ESMTP id F31FBE3FFF
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2014 21:27:01 +0100 (CET)
Received: from mail-in-05.arcor-online.net (mail-in-05.arcor-online.net [151.189.21.45])
	by mail-in-01-z2.arcor-online.net (Postfix) with ESMTP id EBFAD7DA446
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2014 21:27:01 +0100 (CET)
Received: from lord_casco.spaceball (p549AF882.dip0.t-ipconnect.de [84.154.248.130])
	(Authenticated sender: giorgio.nicole@arcor.de)
	by mail-in-05.arcor-online.net (Postfix) with ESMTPA id C2155E4056
	for <netfilter-devel@vger.kernel.org>; Sun,  9 Nov 2014 21:26:38 +0100 (CET)
In-Reply-To: <1415298349-985-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: root <root@lord_casco.spaceball>

Add some missing Makefile.am's under the include directory.

Now it is possible to build 'nftables' from a separate build directory
and produce a release tar archive with a 'make distcheck'.
---
 Make_global.am                      | 10 ----------
 Makefile.am                         |  5 ++---
 autogen.sh                          |  9 ++++++++-
 configure.ac                        |  9 +++++++--
 include/Makefile.am                 | 22 ++++++++++++++++++++++
 include/linux/Makefile.am           |  7 +++++++
 include/linux/netfilter/Makefile.am |  5 +++++
 src/Makefile.am                     | 14 ++++++++++++--
 8 files changed, 63 insertions(+), 18 deletions(-)
 delete mode 100644 Make_global.am
 create mode 100644 include/Makefile.am
 create mode 100644 include/linux/Makefile.am
 create mode 100644 include/linux/netfilter/Makefile.am

diff --git a/Make_global.am b/Make_global.am
deleted file mode 100644
index fbad2a6..0000000
--- a/Make_global.am
+++ /dev/null
@@ -1,10 +0,0 @@
-AM_CPPFLAGS = -I$(top_srcdir)/include
-AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\""
-		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
-
-AM_CFLAGS = -Wall								\
-	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
-	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
-	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
-	    -Wcast-align -Wundef -Wbad-function-cast
-	    -Waggregate-return -Wunused -Wwrite-strings
diff --git a/Makefile.am b/Makefile.am
index f48b08c..8d301f6 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,5 +1,4 @@
-include Make_global.am
-
 ACLOCAL_AMFLAGS	= -I m4
 
-SUBDIRS		= src
+SUBDIRS = 	src	\
+		include
diff --git a/autogen.sh b/autogen.sh
index a62e737..4b6b92d 100755
--- a/autogen.sh
+++ b/autogen.sh
@@ -1,4 +1,11 @@
 #!/bin/bash
 
-autoreconf -fi;
+srcdir=`dirname $0`
+test -z "$srcdir" && srcdir=.
+
+ORIGDIR=`pwd`
+cd $srcdir
+
+autoreconf -vfi || exit 1
 rm -Rf autom4te*.cache config.h.in~
+cd $ORIGDIR || exit $?
diff --git a/configure.ac b/configure.ac
index 15bb3e9..ddba5e2 100644
--- a/configure.ac
+++ b/configure.ac
@@ -119,6 +119,11 @@ AC_TYPE_UINT64_T
 # Checks for library functions.
 AC_CHECK_FUNCS([memmove memset strchr strdup strerror strtoull])
 
-AC_CONFIG_FILES([Makefile])
-AC_CONFIG_FILES([src/Makefile])
+AC_CONFIG_FILES([					\
+		Makefile				\
+		src/Makefile				\
+		include/Makefile			\
+		include/linux/Makefile			\
+		include/linux/netfilter/Makefile	\
+		])
 AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
new file mode 100644
index 0000000..f22561b
--- /dev/null
+++ b/include/Makefile.am
@@ -0,0 +1,22 @@
+SUBDIRS = linux
+
+noinst_HEADERS = 	cli.h		\
+			datatype.h	\
+			expression.h	\
+			gmputil.h	\
+			mnl.h		\
+			nftables.h	\
+			payload.h	\
+			rbtree.h	\
+			statement.h	\
+			ct.h		\
+			erec.h		\
+			exthdr.h	\
+			headers.h	\
+			list.h		\
+			meta.h		\
+			netlink.h	\
+			parser.h	\
+			proto.h		\
+			rule.h		\
+			utils.h
diff --git a/include/linux/Makefile.am b/include/linux/Makefile.am
new file mode 100644
index 0000000..9fb010b
--- /dev/null
+++ b/include/linux/Makefile.am
@@ -0,0 +1,7 @@
+SUBDIRS = netfilter
+noinst_HEADERS =	netfilter_arp.h		\
+			netfilter_bridge.h	\
+			netfilter_decnet.h	\
+			netfilter.h		\
+			netfilter_ipv4.h	\
+			netfilter_ipv6.h
diff --git a/include/linux/netfilter/Makefile.am b/include/linux/netfilter/Makefile.am
new file mode 100644
index 0000000..54b59b5
--- /dev/null
+++ b/include/linux/netfilter/Makefile.am
@@ -0,0 +1,5 @@
+noinst_HEADERS = 	nf_conntrack_common.h		\
+			nf_conntrack_tuple_common.h	\
+			nf_nat.h			\
+			nf_tables.h			\
+			nfnetlink.h
diff --git a/src/Makefile.am b/src/Makefile.am
index 8a6471a..0a67810 100644
--- a/src/Makefile.am
+++ b/src/Makefile.am
@@ -1,9 +1,19 @@
-include $(top_srcdir)/Make_global.am
-
 sbin_PROGRAMS = nft
 
 CLEANFILES = scanner.c parser_bison.c
 
+AM_CPPFLAGS = -I$(top_srcdir)/include
+AM_CPPFLAGS += -DDEFAULT_INCLUDE_PATH="\"${sysconfdir}\""
+		${LIBMNL_CFLAGS} ${LIBNFTNL_CFLAGS}
+
+AM_CFLAGS = -Wall								\
+	    -Wstrict-prototypes -Wmissing-prototypes -Wmissing-declarations	\
+	    -Wdeclaration-after-statement -Wsign-compare -Winit-self		\
+	    -Wformat-nonliteral -Wformat-security -Wmissing-format-attribute	\
+	    -Wcast-align -Wundef -Wbad-function-cast
+	    -Waggregate-return -Wunused -Wwrite-strings
+
+
 AM_YFLAGS = -d
 
 # yacc and lex generate dirty code
-- 
2.1.3

