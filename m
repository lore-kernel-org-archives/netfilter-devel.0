From: Eric Leblond <eric@regit.org>
Subject: [PATCH 4/4] configure: display info about build plugins
Date: Sat,  3 Nov 2012 12:33:01 +0100
Message-ID: <1351942382-24791-5-git-send-email-eric@regit.org>
References: <1351942382-24791-1-git-send-email-eric@regit.org>
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49004 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754062Ab2KCMDW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 3 Nov 2012 08:03:22 -0400
In-Reply-To: <1351942382-24791-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch modifies configure to display the list of plugins that
will be built.
---
 configure.ac |   42 ++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 40 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 930aef0..c70887d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,6 +22,11 @@ AC_SUBST([libdl_LIBS])
 AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
 AC_SUBST([libpcap_LIBS])
 AM_CONDITIONAL([HAVE_PCAP], [test -n "$libpcap_LIBS"])
+if test "x$libpcap_LIBS" != "x"; then
+	enable_pcap="yes"
+else
+	enable_pcap="no"
+fi
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
@@ -68,17 +73,35 @@ AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" = "xyes"])
 
 CT_CHECK_POSTGRES_DB()
 AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
+if test "x$PQLIBPATH" != "x"; then
+	enable_pgsql="yes"
+else
+	enable_pgsql="no"
+fi
 
 CT_CHECK_MYSQL_DB()
 AM_CONDITIONAL(HAVE_MYSQL, test "x$MYSQL_LIB" != "x")
+if test "x$MYSQL_LIB" != "x"; then
+	enable_mysql="yes"
+else
+	enable_mysql="no"
+fi
 
 PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])
 AM_CONDITIONAL([HAVE_SQLITE3], [test -n "$libsqlite3_LIBS"])
+if test "x$libsqlite3_LIBS" != "x"; then
+	enable_sqlite3="yes"
+else
+	enable_sqlite3="no"
+fi
 
 CT_CHECK_DBI()
 AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
-
-
+if test "x$DBI_LIB" != "x"; then
+	enable_dbi="yes"
+else
+	enable_dbi="no"
+fi
 
 dnl AC_SUBST(DATABASE_DIR)
 dnl AC_SUBST(DATABASE_LIB)
@@ -102,3 +125,18 @@ AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefi
 	  output/dbi/Makefile \
 	  src/Makefile Makefile Rules.make)
 AC_OUTPUT
+
+echo "
+Ulogd configuration:
+  Input plugins:
+    NFLOG plugin:			${enable_nflog}
+    NFCT plugin:			${enable_nfct}
+    NFACCT plugin:			${enable_nfacct}
+  Output plugins:
+    PCAP plugin:			${enable_pcap}
+    PGSQL plugin:			${enable_pgsql}
+    MySQL plugin:			${enable_mysql}
+    SQLITE3 plugin:			${enable_sqlite3}
+    DBI plugin:				${enable_dbi}
+"
+echo "You can now run 'make' and 'make install'"
-- 
1.7.10.4

