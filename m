From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 1/7] build: use autoconf-suggested naming of files
Date: Sun, 31 Oct 2010 00:49:35 +0200
Message-ID: <1288478982-6758-2-git-send-email-jengelh@medozas.de>
References: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:44507 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889Ab0J3Wtq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 30 Oct 2010 18:49:46 -0400
In-Reply-To: <1288478982-6758-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 configure.ac |  135 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |  135 ----------------------------------------------------------
 2 files changed, 135 insertions(+), 135 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..88faede
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,135 @@
+AC_INIT(conntrack-tools, 0.9.15, pablo@netfilter.org)
+
+AC_CANONICAL_SYSTEM
+
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall])
+
+AC_PROG_CC
+AM_PROG_LIBTOOL
+AC_PROG_INSTALL
+AC_PROG_LN_S
+AM_PROG_LEX
+AC_PROG_YACC
+
+case $target in
+*-*-linux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
+dnl Dependencies
+LIBNFNETLINK_REQUIRED=1.0.0
+LIBNETFILTER_CONNTRACK_REQUIRED=0.0.102
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
+        AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
+
+PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,,
+        AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
+
+AC_CHECK_PROGS(XYACC,$YACC bison yacc,none)
+if test "$XYACC" = "none"
+then
+	echo "*** Error: No suitable bison/yacc found. ***"
+	echo "    Please install the 'bison' package."
+	exit 1
+fi
+AC_CHECK_PROGS(XLEX,$LEX flex lex,none)
+if test "$XLEX" = "none"
+then
+	echo "*** Error: No suitable flex/lex found. ***"
+	echo "    Please install the 'flex' package."
+	exit 1
+fi
+
+AC_MSG_CHECKING(flex version)
+flex_version=`$LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
+flex_major=`echo $flex_version| cut -d . -f 1`
+flex_minor=`echo $flex_version| cut -d . -f 2`
+flex_rev=`echo $flex_version| cut -d . -f 3`
+ 
+if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
+	AC_MSG_RESULT([$flex_version. OK])
+else
+	AC_MSG_WARN([flex version $flex_version found.
+	Version 2.5.33 or greater is required. You may experience problems
+	while compilating the conntrack-tools. Please, consider to upgrade 
+	flex.])
+fi
+
+AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
+
+# Checks for libraries.
+# FIXME: Replace `main' with a function in `-lc':
+dnl AC_CHECK_LIB([c], [main])
+# FIXME: Replace `main' with a function in `-ldl':
+
+AC_CHECK_LIB([nfnetlink], [nfnl_query] ,,,[-lnfnetlink])
+AC_CHECK_LIB([netfilter_conntrack], [nfct_query] ,,,[-lnetfilter_conntrack])
+
+AC_CHECK_HEADERS(arpa/inet.h)
+dnl check for inet_pton
+AC_CHECK_FUNCS(inet_pton)
+dnl Some systems have it, but not IPv6
+if test "$ac_cv_func_inet_pton" = "yes" ; then
+AC_MSG_CHECKING(if inet_pton supports IPv6)
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
+int main()
+  {
+     struct in6_addr addr6;
+     if (inet_pton(AF_INET6, "::1", &addr6) < 1)
+        exit(1);
+     else
+        exit(0);
+  }
+  ], [ AC_MSG_RESULT(yes)
+       AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
+  ], AC_MSG_RESULT(no), AC_MSG_RESULT(no))
+fi
+
+# Checks for header files.
+dnl AC_HEADER_STDC
+dnl AC_CHECK_HEADERS([netinet/in.h stdlib.h])
+
+# Checks for typedefs, structures, and compiler characteristics.
+dnl AC_C_CONST
+dnl AC_C_INLINE
+
+# Checks for library functions.
+dnl AC_FUNC_MALLOC
+dnl AC_FUNC_VPRINTF
+dnl AC_CHECK_FUNCS([memset])
+
+dnl AC_CONFIG_FILES([Makefile
+dnl                  debug/Makefile
+dnl                  debug/src/Makefile
+dnl                  extensions/Makefile
+dnl                  src/Makefile])
+
+CFLAGS="$CFLAGS $LIBNETFILTER_CONNTRACK_CFLAGS"
+
+AC_SUBST(LIBNETFILTER_CONNTRACK_LIBS)
+
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile extensions/Makefile])
+AC_OUTPUT
diff --git a/configure.in b/configure.in
deleted file mode 100644
index 88faede..0000000
--- a/configure.in
+++ /dev/null
@@ -1,135 +0,0 @@
-AC_INIT(conntrack-tools, 0.9.15, pablo@netfilter.org)
-
-AC_CANONICAL_SYSTEM
-
-AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([-Wall])
-
-AC_PROG_CC
-AM_PROG_LIBTOOL
-AC_PROG_INSTALL
-AC_PROG_LN_S
-AM_PROG_LEX
-AC_PROG_YACC
-
-case $target in
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
-dnl Dependencies
-LIBNFNETLINK_REQUIRED=1.0.0
-LIBNETFILTER_CONNTRACK_REQUIRED=0.0.102
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
-        AC_MSG_ERROR(Cannot find libnfnetlink >= $LIBNFNETLINK_REQUIRED))
-
-PKG_CHECK_MODULES(LIBNETFILTER_CONNTRACK, libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED,,
-        AC_MSG_ERROR(Cannot find libnetfilter_conntrack >= $LIBNETFILTER_CONNTRACK_REQUIRED))
-
-AC_CHECK_PROGS(XYACC,$YACC bison yacc,none)
-if test "$XYACC" = "none"
-then
-	echo "*** Error: No suitable bison/yacc found. ***"
-	echo "    Please install the 'bison' package."
-	exit 1
-fi
-AC_CHECK_PROGS(XLEX,$LEX flex lex,none)
-if test "$XLEX" = "none"
-then
-	echo "*** Error: No suitable flex/lex found. ***"
-	echo "    Please install the 'flex' package."
-	exit 1
-fi
-
-AC_MSG_CHECKING(flex version)
-flex_version=`$LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
-flex_major=`echo $flex_version| cut -d . -f 1`
-flex_minor=`echo $flex_version| cut -d . -f 2`
-flex_rev=`echo $flex_version| cut -d . -f 3`
- 
-if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
-	AC_MSG_RESULT([$flex_version. OK])
-else
-	AC_MSG_WARN([flex version $flex_version found.
-	Version 2.5.33 or greater is required. You may experience problems
-	while compilating the conntrack-tools. Please, consider to upgrade 
-	flex.])
-fi
-
-AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
-
-# Checks for libraries.
-# FIXME: Replace `main' with a function in `-lc':
-dnl AC_CHECK_LIB([c], [main])
-# FIXME: Replace `main' with a function in `-ldl':
-
-AC_CHECK_LIB([nfnetlink], [nfnl_query] ,,,[-lnfnetlink])
-AC_CHECK_LIB([netfilter_conntrack], [nfct_query] ,,,[-lnetfilter_conntrack])
-
-AC_CHECK_HEADERS(arpa/inet.h)
-dnl check for inet_pton
-AC_CHECK_FUNCS(inet_pton)
-dnl Some systems have it, but not IPv6
-if test "$ac_cv_func_inet_pton" = "yes" ; then
-AC_MSG_CHECKING(if inet_pton supports IPv6)
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
-int main()
-  {
-     struct in6_addr addr6;
-     if (inet_pton(AF_INET6, "::1", &addr6) < 1)
-        exit(1);
-     else
-        exit(0);
-  }
-  ], [ AC_MSG_RESULT(yes)
-       AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
-  ], AC_MSG_RESULT(no), AC_MSG_RESULT(no))
-fi
-
-# Checks for header files.
-dnl AC_HEADER_STDC
-dnl AC_CHECK_HEADERS([netinet/in.h stdlib.h])
-
-# Checks for typedefs, structures, and compiler characteristics.
-dnl AC_C_CONST
-dnl AC_C_INLINE
-
-# Checks for library functions.
-dnl AC_FUNC_MALLOC
-dnl AC_FUNC_VPRINTF
-dnl AC_CHECK_FUNCS([memset])
-
-dnl AC_CONFIG_FILES([Makefile
-dnl                  debug/Makefile
-dnl                  debug/src/Makefile
-dnl                  extensions/Makefile
-dnl                  src/Makefile])
-
-CFLAGS="$CFLAGS $LIBNETFILTER_CONNTRACK_CFLAGS"
-
-AC_SUBST(LIBNETFILTER_CONNTRACK_LIBS)
-
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile extensions/Makefile])
-AC_OUTPUT
-- 
1.7.1

