From: Eric Leblond <eric@regit.org>
Subject: [PATCH 02/11] Fix automagic support of dbi, pcap and sqlite3
Date: Fri, 10 May 2013 08:48:49 +0200
Message-ID: <1368168538-29780-3-git-send-email-eric@regit.org>
References: <1368168538-29780-1-git-send-email-eric@regit.org>
Cc: Ilya Tumaykin <itumaykin@gmail.com>, Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:51452 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750824Ab3EJGtX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 May 2013 02:49:23 -0400
In-Reply-To: <1368168538-29780-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Ilya Tumaykin <itumaykin@gmail.com>

ulogd has automagic deps for several output plugins right now, namely dbi,
pcap and sqlite3. These plugins are built if the appropriate libs are present
on user's system. While this situation is fine with binary distros it is not OK
on source-based ones such as Gentoo.

The problem arises when such a program links against libs without user's
request and libs are later removed from system which leaves program in a
broken state.

This patch is modifying configure.ac which we apply in our package and which
fixes mentioned issue. It adds 3 new configure options: --
without-{dbi,pcap.sqlite}. I would like to emphasize that this patch doesn't
change default behaviour of configure script at all, so all other distros won't
suffer. We simply add options to explicitly disable any attempts to try and
detect libs for automagic deps, which is enough to avoid unnecessary linkage.

Signed-off-by: Eric Leblond <eric@regit.org>
---
 configure.ac |   30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/configure.ac b/configure.ac
index c94704b..7e04531 100644
--- a/configure.ac
+++ b/configure.ac
@@ -20,14 +20,6 @@ AC_PROG_LIBTOOL
 dnl Checks for libraries.
 AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libdl_LIBS])
-AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
-AC_SUBST([libpcap_LIBS])
-AM_CONDITIONAL([HAVE_PCAP], [test -n "$libpcap_LIBS"])
-if test "x$libpcap_LIBS" != "x"; then
-	enable_pcap="yes"
-else
-	enable_pcap="no"
-fi
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
@@ -88,7 +80,10 @@ else
 	enable_mysql="no"
 fi
 
-PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])
+AC_ARG_WITH([sqlite], AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]]))
+AS_IF([test "x$with_sqlite" != "xno"], [
+    PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])
+])
 AM_CONDITIONAL([HAVE_SQLITE3], [test -n "$libsqlite3_LIBS"])
 if test "x$libsqlite3_LIBS" != "x"; then
 	enable_sqlite3="yes"
@@ -96,7 +91,10 @@ else
 	enable_sqlite3="no"
 fi
 
-CT_CHECK_DBI()
+AC_ARG_WITH([dbi], AS_HELP_STRING([--without-dbi], [Build without DBI output plugin [default=test]]))
+AS_IF([test "x$with_dbi" != "xno"], [
+    CT_CHECK_DBI()
+])
 AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
 if test "x$DBI_LIB" != "x"; then
 	enable_dbi="yes"
@@ -104,6 +102,18 @@ else
 	enable_dbi="no"
 fi
 
+AC_ARG_WITH([pcap], AS_HELP_STRING([--without-pcap], [Build without PCAP output plugin [default=test]]))
+AS_IF([test "x$with_pcap" != "xno"], [
+    AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
+    AC_SUBST([libpcap_LIBS])
+])
+AM_CONDITIONAL([HAVE_PCAP], [test -n "$libpcap_LIBS"])
+if test "x$libpcap_LIBS" != "x"; then
+	enable_pcap="yes"
+else
+	enable_pcap="no"
+fi
+
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
 dnl AC_SUBST(DATABASE_LIB_DIR)
-- 
1.7.10.4

