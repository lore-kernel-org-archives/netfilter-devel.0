From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft-sync PATCH 1/3] build: rename configure.in to configure.ac
Date: Fri, 26 Dec 2014 13:51:22 +0100
Message-ID: <20141226125122.16382.30213.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:41853 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751022AbaLZMvc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Dec 2014 07:51:32 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

% autoreconf -fi
aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
[...]
aclocal: warning: autoconf input should be named 'configure.ac', not 'configure.in'
automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'
[...]
automake: warning: autoconf input should be named 'configure.ac', not 'configure.in'

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 configure.ac |   94 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |   94 ----------------------------------------------------------
 2 files changed, 94 insertions(+), 94 deletions(-)
 create mode 100644 configure.ac
 delete mode 100644 configure.in

diff --git a/configure.ac b/configure.ac
new file mode 100644
index 0000000..d8ffef5
--- /dev/null
+++ b/configure.ac
@@ -0,0 +1,94 @@
+AC_INIT(nft-sync, 0.1-alpha, pablo@netfilter.org)
+AC_CONFIG_AUX_DIR([build-aux])
+
+AC_CANONICAL_HOST
+AC_CONFIG_MACRO_DIR([m4])
+AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
+	tar-pax no-dist-gzip dist-bzip2 1.6])
+
+dnl kernel style compile messages
+m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
+
+AC_PROG_CC
+AC_DISABLE_STATIC
+AM_PROG_LIBTOOL
+AC_PROG_INSTALL
+AC_PROG_LN_S
+AM_PROG_LEX
+AC_PROG_YACC
+
+case "$host" in
+*-*-linux*) ;;
+*) AC_MSG_ERROR([Linux only, dude!]);;
+esac
+
+dnl Dependencies
+if test -z "$ac_cv_prog_YACC"
+then
+	echo "*** Error: No suitable bison/yacc found. ***"
+	echo "    Please install the 'bison' package."
+	exit 1
+fi
+if test -z "$ac_cv_prog_LEX"
+then
+	echo "*** Error: No suitable flex/lex found. ***"
+	echo "    Please install the 'flex' package."
+	exit 1
+fi
+
+AC_MSG_CHECKING(flex version)
+flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
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
+PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
+PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.0])
+AC_CHECK_HEADER([ev.h],
+		AC_CHECK_LIB([ev], [ev_loop_new], [BUILD_LIBEV=$WITH_LIBEV],
+		[test x$WITH_LIBEV != xauto && AC_MSG_ERROR("libev not found")]),
+		[test x$WITH_LIBEV != xauto && AC_MSG_ERROR("ev.h not found")])
+
+AC_CHECK_HEADERS(arpa/inet.h)
+dnl check for inet_pton
+AC_CHECK_FUNCS(inet_pton)
+dnl Some systems have it, but not IPv6
+if test "$ac_cv_func_inet_pton" = "yes" ; then
+AC_MSG_CHECKING(if inet_pton supports IPv6)
+AC_RUN_IFELSE([AC_LANG_SOURCE([[
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
+  ]])],[ AC_MSG_RESULT(yes)
+       AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
+  ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
+fi
+
+AC_CONFIG_FILES([Makefile src/Makefile include/Makefile tests/Makefile])
+AC_OUTPUT
diff --git a/configure.in b/configure.in
deleted file mode 100644
index d8ffef5..0000000
--- a/configure.in
+++ /dev/null
@@ -1,94 +0,0 @@
-AC_INIT(nft-sync, 0.1-alpha, pablo@netfilter.org)
-AC_CONFIG_AUX_DIR([build-aux])
-
-AC_CANONICAL_HOST
-AC_CONFIG_MACRO_DIR([m4])
-AM_INIT_AUTOMAKE([-Wall foreign subdir-objects
-	tar-pax no-dist-gzip dist-bzip2 1.6])
-
-dnl kernel style compile messages
-m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])
-
-AC_PROG_CC
-AC_DISABLE_STATIC
-AM_PROG_LIBTOOL
-AC_PROG_INSTALL
-AC_PROG_LN_S
-AM_PROG_LEX
-AC_PROG_YACC
-
-case "$host" in
-*-*-linux*) ;;
-*) AC_MSG_ERROR([Linux only, dude!]);;
-esac
-
-dnl Dependencies
-if test -z "$ac_cv_prog_YACC"
-then
-	echo "*** Error: No suitable bison/yacc found. ***"
-	echo "    Please install the 'bison' package."
-	exit 1
-fi
-if test -z "$ac_cv_prog_LEX"
-then
-	echo "*** Error: No suitable flex/lex found. ***"
-	echo "    Please install the 'flex' package."
-	exit 1
-fi
-
-AC_MSG_CHECKING(flex version)
-flex_version=`$ac_cv_prog_LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
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
-PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
-PKG_CHECK_MODULES([LIBNFTNL], [libnftnl >= 1.0.0])
-AC_CHECK_HEADER([ev.h],
-		AC_CHECK_LIB([ev], [ev_loop_new], [BUILD_LIBEV=$WITH_LIBEV],
-		[test x$WITH_LIBEV != xauto && AC_MSG_ERROR("libev not found")]),
-		[test x$WITH_LIBEV != xauto && AC_MSG_ERROR("ev.h not found")])
-
-AC_CHECK_HEADERS(arpa/inet.h)
-dnl check for inet_pton
-AC_CHECK_FUNCS(inet_pton)
-dnl Some systems have it, but not IPv6
-if test "$ac_cv_func_inet_pton" = "yes" ; then
-AC_MSG_CHECKING(if inet_pton supports IPv6)
-AC_RUN_IFELSE([AC_LANG_SOURCE([[
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
-  ]])],[ AC_MSG_RESULT(yes)
-       AC_DEFINE_UNQUOTED(HAVE_INET_PTON_IPV6, 1, [Define to 1 if inet_pton supports IPv6.])
-  ],[AC_MSG_RESULT(no)],[AC_MSG_RESULT(no)])
-fi
-
-AC_CONFIG_FILES([Makefile src/Makefile include/Makefile tests/Makefile])
-AC_OUTPUT

