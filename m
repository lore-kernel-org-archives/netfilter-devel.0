From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] build: use autoconf-suggested naming of files
Date: Thu,  9 Sep 2010 01:32:36 +0200
Message-ID: <1283988763-1577-2-git-send-email-jengelh@medozas.de>
References: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48407 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756674Ab0IHXcr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 19:32:47 -0400
In-Reply-To: <1283988763-1577-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |   82 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |   82 ----------------------------------------------------------
 2 files changed, 82 insertions(+), 82 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..ae61ba0
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,82 @@
+dnl Process this file with autoconf to create configure.
+
+AC_INIT
+AC_CANONICAL_SYSTEM
+AC_CONFIG_MACRO_DIR([m4])
+
+AM_INIT_AUTOMAKE(libnetfilter_conntrack, 0.9.0)
+
+AC_PROG_CC
+AM_PROG_LIBTOOL
+AC_PROG_INSTALL
+AC_PROG_LN_S
+
+AC_SUBST(LIBTOOL_DEPS)
+
+case $target in 
+*-*-linux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=1.0.0
+
+AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)
+if test "x$HAVE_PKG_CONFIG" = "x"
+then
+	echo "*** Error: No suitable pkg-config found. ***"
+	echo "    Please install the 'pkg-config' package."
+	exit 1
+fi
+
+PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
+	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+
+AC_CHECK_HEADERS(arpa/inet.h)
+dnl Check for inet_ntop
+AC_CHECK_FUNCS(inet_ntop)
+dnl Again, some systems have it, but not IPv6
+if test "$ac_cv_func_inet_ntop" = "yes" ; then
+AC_MSG_CHECKING(if inet_ntop supports IPv6)
+AC_TRY_RUN(
+   [
+#ifdef HAVE_SYS_TYPES_H
+#include <sys/types.h>
+#endif
+#ifdef HAVE_SYS_SOCKET_H
+#include <sys/socket.h>
+#endif
+#ifdef HAVE_NETINET_IN_H
+#include <netinet/in.h>
+#endif
+#ifdef HAVE_ARPA_INET_H
+#include <arpa/inet.h>
+#endif
+#include <errno.h>
+int main()
+  {
+     struct in6_addr addr6;
+     char buf[128];
+     if (inet_ntop(AF_INET6, &addr6, buf, 128) == 0 && errno == EAFNOSUPPORT)
+        exit(1);
+     else
+        exit(0);
+  }
+  ], [ AC_MSG_RESULT(yes)
+       AC_DEFINE_UNQUOTED(HAVE_INET_NTOP_IPV6, 1, [Define to 1 if inet_ntop supports IPv6.])
+     ], AC_MSG_RESULT(no),AC_MSG_RESULT(no))
+fi
+
+if test ! -z "$libdir"; then
+	MODULE_DIR="\\\"$libdir/libnetfilter_conntrack/\\\""
+	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
+fi
+
+CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
+LIBNFCONNTRACK_LIBS="$LIBNFNETLINK_LIBS"
+
+AC_SUBST(LIBNFCONNTRACK_LIBS)
+
+dnl Output the makefile
+AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile qa/Makefile include/libnetfilter_conntrack/Makefile include/internal/Makefile src/conntrack/Makefile src/expect/Makefile libnetfilter_conntrack.pc doxygen.cfg)
+
diff --git a/configure.in b/configure.in
deleted file mode 100644
index ae61ba0..0000000
--- a/configure.in
+++ /dev/null
@@ -1,82 +0,0 @@
-dnl Process this file with autoconf to create configure.
-
-AC_INIT
-AC_CANONICAL_SYSTEM
-AC_CONFIG_MACRO_DIR([m4])
-
-AM_INIT_AUTOMAKE(libnetfilter_conntrack, 0.9.0)
-
-AC_PROG_CC
-AM_PROG_LIBTOOL
-AC_PROG_INSTALL
-AC_PROG_LN_S
-
-AC_SUBST(LIBTOOL_DEPS)
-
-case $target in 
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
-dnl Dependencies
-LIBNFNETLINK_REQUIRED=1.0.0
-
-AC_CHECK_PROG(HAVE_PKG_CONFIG, pkg-config, yes)
-if test "x$HAVE_PKG_CONFIG" = "x"
-then
-	echo "*** Error: No suitable pkg-config found. ***"
-	echo "    Please install the 'pkg-config' package."
-	exit 1
-fi
-
-PKG_CHECK_MODULES(LIBNFNETLINK, libnfnetlink >= $LIBNFNETLINK_REQUIRED,,
-	AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-AC_CHECK_HEADERS(arpa/inet.h)
-dnl Check for inet_ntop
-AC_CHECK_FUNCS(inet_ntop)
-dnl Again, some systems have it, but not IPv6
-if test "$ac_cv_func_inet_ntop" = "yes" ; then
-AC_MSG_CHECKING(if inet_ntop supports IPv6)
-AC_TRY_RUN(
-   [
-#ifdef HAVE_SYS_TYPES_H
-#include <sys/types.h>
-#endif
-#ifdef HAVE_SYS_SOCKET_H
-#include <sys/socket.h>
-#endif
-#ifdef HAVE_NETINET_IN_H
-#include <netinet/in.h>
-#endif
-#ifdef HAVE_ARPA_INET_H
-#include <arpa/inet.h>
-#endif
-#include <errno.h>
-int main()
-  {
-     struct in6_addr addr6;
-     char buf[128];
-     if (inet_ntop(AF_INET6, &addr6, buf, 128) == 0 && errno == EAFNOSUPPORT)
-        exit(1);
-     else
-        exit(0);
-  }
-  ], [ AC_MSG_RESULT(yes)
-       AC_DEFINE_UNQUOTED(HAVE_INET_NTOP_IPV6, 1, [Define to 1 if inet_ntop supports IPv6.])
-     ], AC_MSG_RESULT(no),AC_MSG_RESULT(no))
-fi
-
-if test ! -z "$libdir"; then
-	MODULE_DIR="\\\"$libdir/libnetfilter_conntrack/\\\""
-	CFLAGS="$CFLAGS -DLIBNETFILTER_CONNTRACK_DIR=$MODULE_DIR"
-fi
-
-CFLAGS="$CFLAGS $LIBNFNETLINK_CFLAGS"
-LIBNFCONNTRACK_LIBS="$LIBNFNETLINK_LIBS"
-
-AC_SUBST(LIBNFCONNTRACK_LIBS)
-
-dnl Output the makefile
-AC_OUTPUT(Makefile src/Makefile include/Makefile utils/Makefile qa/Makefile include/libnetfilter_conntrack/Makefile include/internal/Makefile src/conntrack/Makefile src/expect/Makefile libnetfilter_conntrack.pc doxygen.cfg)
-
-- 
1.7.1

