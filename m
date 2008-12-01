From: Pierre Chifflier <chifflier@inl.fr>
Subject: [PATCH 4/4] Search for libdbi includes during configure
Date: Mon,  1 Dec 2008 13:41:56 +0100
Message-ID: <1228135316-12578-5-git-send-email-chifflier@inl.fr>
References: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Cc: Pierre Chifflier <chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55880 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLANYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:24:50 -0500
In-Reply-To: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

libdbi is a database-independent abstraction layer in C, similar
to the DBI/DBD layer in Perl.

Signed-off-by: Pierre Chifflier <chifflier@inl.fr>
---
 acinclude.m4 |   86 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 configure.in |    3 ++
 2 files changed, 89 insertions(+), 0 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index ae6988a..4d80f10 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -367,3 +367,89 @@ fi
 fi
 
 ])
+
+
+dnl @synopsis CT_CHECK_DBI
+dnl
+dnl This macro tries to find the headers and libraries for libdbi.
+dnl
+dnl If includes are found, the variable DBI_INC will be set. If
+dnl libraries are found, the variable DBI_LIB will be set. if no check
+dnl was successful, the script exits with a error message.
+dnl
+dnl @category InstalledPackages
+dnl @author Pierre Chifflier <chifflier@inl.fr>
+dnl @version 2008-10-30
+dnl @license AllPermissive
+
+AC_DEFUN([CT_CHECK_DBI], [
+
+AC_ARG_WITH(dbi,
+	[  --with-dbi=PREFIX		Prefix of your libdbi installation],
+	[dbi=$withval], [dbi_prefix=])
+AC_ARG_WITH(dbi-inc,
+	[  --with-dbi-inc=PATH		Path to the include directory of dbi],
+	[dbi_inc=$withval], [dbi_inc=/usr/include])
+AC_ARG_WITH(dbi-lib,
+	[  --with-dbi-lib=PATH		Path to the libraries of dbi],
+	[dbi_lib=$withval], [dbi_lib=/usr/lib])
+
+
+AC_SUBST(DBI_INC)
+AC_SUBST(DBI_LIB)
+
+if test "$dbi_prefix" != "no"; then
+
+if test "$dbi_prefix" != ""; then
+   AC_MSG_CHECKING([for libdbi includes in $dbi_prefix/include])
+   if test -f "$dbi_prefix/include/dbi.h" ; then
+      DBI_INC="-I$dbi_prefix/include"
+      AC_MSG_RESULT([yes])
+   elif test -f "$dbi_prefix/include/dbi/dbi.h" ; then
+      DBI_INC="-I$dbi_prefix/include/dbi"
+      AC_MSG_RESULT([yes])
+   else
+      AC_MSG_WARN(dbi.h not found)
+   fi
+   AC_MSG_CHECKING([for libdbi in $dbi_prefix/lib])
+   if test -f "$dbi_prefix/lib/libdbi.so" ; then
+      DBI_LIB="-L$dbi_prefix/lib -ldbi";
+      AC_MSG_RESULT([yes])
+   else
+      AC_MSG_WARN(libdbi.so not found)
+   fi
+else
+  if test "$dbi_inc" != ""; then
+    AC_MSG_CHECKING([for libdbi includes in $dbi_inc])
+    if test -f "$dbi_inc/dbi.h" ; then
+      DBI_INC="-I$dbi_inc"
+      AC_MSG_RESULT([yes])
+    elif test -f "$dbi_inc/dbi/dbi.h" ; then
+      DBI_INC="-I$dbi_inc/dbi"
+      AC_MSG_RESULT([yes])
+    else
+      AC_MSG_WARN(dbi.h not found)
+    fi
+  fi
+  if test "$dbi_lib" != ""; then
+    AC_MSG_CHECKING([for libdbi in $dbi_lib])
+    if test -f "$dbi_lib/libdbi.so" ; then
+      DBI_LIB="-L$dbi_lib -ldbi";
+      AC_MSG_RESULT([yes])
+    else
+      AC_MSG_WARN(libdbi.so not found)
+    fi
+  fi
+fi
+
+if test "$DBI_INC" = "" ; then
+  AC_CHECK_HEADER([dbi.h], [], AC_MSG_WARN(dbi.h not found))
+fi
+if test "$DBI_LIB" = "" ; then
+  AC_CHECK_LIB(dbi, dbi_close, [], AC_MSG_WARN(libdbi.so not found))
+fi
+
+fi
+
+])
+
diff --git a/configure.in b/configure.in
index 5e9a02b..9d3f02a 100644
--- a/configure.in
+++ b/configure.in
@@ -53,6 +53,9 @@ AM_CONDITIONAL(HAVE_MYSQL, test "x$MYSQL_LIB" != "x")
 CT_CHECK_SQLITE3_DB()
 AM_CONDITIONAL(HAVE_SQLITE3, test "x$SQLITE3_LIB" != "x")
 
+CT_CHECK_DBI()
+AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
+
 CT_CHECK_PCAP()
 AM_CONDITIONAL(HAVE_PCAP, test "x$PCAP_LIB" != "x")
 
-- 
1.5.6.5

