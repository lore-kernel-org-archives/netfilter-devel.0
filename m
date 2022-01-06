Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 066E6C43217
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244055AbiAFVKJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244063AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A03C0611FD
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fjiT2tVARixapa2R6d/XiD3V9Mk9QVfZnaoyj0+HIRI=; b=MgWBwzmovH8RWfxOlAq6sa6wur
        Cx+qPqUsugdDg8n0mQN2GqgIFsBvZMgUqHa3loOAm/bW1EyCGX+RFxN9LhCzMAhvjMhY3wldBKfx4
        DSniKWS1M6aVe6VDkxolpo3nYoyhD/OCrWJogI9iWhaYtcjBSUTUnlyQdG56Jvx981o4yW7sLRnHy
        rc/UqyfsFpdUxcW/BKZU42YzEdFlm220jWk8RQjxpHFxhmnsOC4hK8wzcbDjoVH3R6KfX4tJjLQWm
        3jDzQL72pHxUJFR8ZEz2O8tAQeM+fSBeHKTOFsE6EH+BNTAOY7zTALZL0nM0nOFjE7AxJ5utVusJ7
        Cp1ir2qA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-3h
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 03/10] build: use pkg-config or upstream M4 for mysql
Date:   Thu,  6 Jan 2022 21:09:30 +0000
Message-Id: <20220106210937.1676554-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220106210937.1676554-1-jeremy@azazel.net>
References: <20220106210937.1676554-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent versions of mariadb and mysql have supported pkg-config.  Older
versions provide an m4 file containing macros for use with autoconf.
Use them in preference to rolling our own.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 acinclude.m4 | 93 ----------------------------------------------------
 configure.ac | 53 +++++++++++++++++++++++++++---
 2 files changed, 49 insertions(+), 97 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index c7a1c67280f7..a49ed316e65a 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -93,99 +93,6 @@ fi
 
 ])
 
-dnl @synopsis CT_CHECK_MYSQL_DB
-dnl
-dnl This macro tries to find the headers and librariess for the
-dnl MySQL database to build client applications.
-dnl
-dnl If includes are found, the variable MYSQL_INC will be set. If
-dnl libraries are found, the variable MYSQL_LIB will be set. if no check
-dnl was successful, the script exits with a error message.
-dnl
-dnl @category InstalledPackages
-dnl @author Harald Welte <laforge@gnumonks.org>
-dnl @version 2006-01-07
-dnl @license AllPermissive
-
-AC_DEFUN([CT_CHECK_MYSQL_DB], [
-
-AC_ARG_WITH(mysql,
-	[  --with-mysql=PREFIX		Prefix of your MySQL installation],
-	[my_prefix=$withval], [my_prefix=])
-AC_ARG_WITH(mysql-inc,
-	[  --with-mysql-inc=PATH		Path to the include directory of MySQL],
-	[my_inc=$withval], [my_inc=])
-AC_ARG_WITH(mysql-lib,
-	[  --with-mysql-lib=PATH		Path to the libraries of MySQL],
-	[my_lib=$withval], [my_lib=])
-
-
-AC_SUBST(MYSQL_INC)
-AC_SUBST(MYSQL_LIB)
-
-if test "$my_prefix" != "no"; then
-
-AC_MSG_CHECKING([for MySQL mysql_config program])
-for d in $my_prefix/bin /usr/bin /usr/local/bin /usr/local/mysql/bin /opt/mysql/bin /opt/packages/mysql/bin
-do
-	if test -x $d/mysql_config -a "$cross_compiling" = "no";
-	then
-		AC_MSG_RESULT(found mysql_config in $d)
-		MYSQL_INC=`$d/mysql_config --include`
-		MYSQL_LIB=`$d/mysql_config --libs`
-		break
-	fi
-done
-
-if test "$MYSQL_INC" = ""; then
-   if test "$my_prefix" != ""; then
-      AC_MSG_CHECKING([for MySQL includes in $my_prefix/include])
-      if test -f "$my_prefix/include/mysql.h" ; then
-         MYSQL_INC="-I$my_prefix/include"
-         AC_MSG_RESULT([yes])
-      else
-         AC_MSG_WARN(mysql.h not found)
-      fi
-      AC_MSG_CHECKING([for MySQL libraries in $my_prefix/lib])
-      if test -f "$my_prefix/lib/libmysql.so" ; then
-         MYSQL_LIB="-L$my_prefix/lib -lmysqlclient"
-         AC_MSG_RESULT([yes])
-      else
-         AC_MSG_WARN(libmysqlclient.so not found)
-      fi
-   else
-     if test "$my_inc" != ""; then
-       AC_MSG_CHECKING([for MySQL includes in $my_inc])
-       if test -f "$my_inc/mysql.h" ; then
-         MYSQL_INC="-I$my_inc"
-         AC_MSG_RESULT([yes])
-       else
-         AC_MSG_WARN(mysql.h not found)
-       fi
-     fi
-     if test "$my_lib" != ""; then
-       AC_MSG_CHECKING([for MySQL libraries in $my_lib])
-       if test -f "$my_lib/libmysqlclient.so" ; then
-         MYSQL_LIB="-L$my_lib -lmysqlclient"
-         AC_MSG_RESULT([yes])
-       else
-         AC_MSG_WARN(libmysqlclient.so not found)
-       fi
-     fi
-   fi
-fi
-
-if test "$MYSQL_INC" = "" ; then
-  AC_CHECK_HEADER([mysql.h], [], AC_MSG_WARN(mysql.h not found))
-fi
-if test "$MYSQL_LIB" = "" ; then
-  AC_CHECK_LIB(mysqlclient, mysql_close, [], AC_MSG_WARN(libmysqlclient.so not found))
-fi
-
-fi
-
-])
-
 dnl @synopsis CT_CHECK_PCAP
 dnl
 dnl This macro tries to find the headers and libraries for libpcap.
diff --git a/configure.ac b/configure.ac
index a3ad198a1d33..524fc151e2f3 100644
--- a/configure.ac
+++ b/configure.ac
@@ -87,10 +87,55 @@ AM_CONDITIONAL([HAVE_PGSQL], [test "x$PQLIBPATH" != "x"])
 
 AC_ARG_ENABLE([mysql],
               [AS_HELP_STRING([--enable-mysql], [Enable MySQL output plugin [default=test]])])
-AS_IF([test "x$enable_mysql" != "xno"],
-      [CT_CHECK_MYSQL_DB()])
-AS_IF([test "x$MYSQL_LIB" != "x"], [enable_mysql=yes], [enable_mysql=no])
-AM_CONDITIONAL([HAVE_MYSQL], [test "x$MYSQL_LIB" != "x"])
+AS_IF([test "x$enable_mysql" != "xno"], [
+
+  dnl Recent versions of MySQL and MariaDB have included pkg-config support.
+  dnl Older versions have included an mysql.m4 file which provides macros to
+  dnl find mysql_config and use it to define `CFLAGS` and `LIBS` variables.
+  dnl Therefore, we try pkg-config first and fall back to the M4 macros.
+
+  PKG_CHECK_EXISTS([mysqlclient],
+                   [PKG_CHECK_MODULES([libmysqlclient], [mysqlclient])],
+                   [
+
+    dnl The [MYSQL_CLIENT] macro calls [_MYSQL_CONFIG] to locate mysql_config.
+    dnl However, [MYSQL_CLIENT] will fail with an error if it can't exec it.
+    dnl That would be fine if the user had explicitly requested the mysql output
+    dnl plug-in, but if not, we should like to enable it if it's available and
+    dnl ignore it, otherwise.  Therefore, we call [_MYSQL_CONFIG] ourselves, and
+    dnl only call [MYSQL_CLIENT] if mysql_config is present.
+
+    _MYSQL_CONFIG
+
+    AS_IF([command -v "$mysql_config" >/dev/null], [
+
+      MYSQL_CLIENT([], [client])
+
+      dnl Some distro's don't put mysql_config in the same package as the
+      dnl headers and .so sym-links.  Therefore, it is possible that the former
+      dnl may be available, but the latter may not.  Hence, we check explicitly
+      dnl for mysql.h.
+
+      ulogd_save_CPPFLAGS="$CPPFLAGS"
+      CPPFLAGS="$MYSQL_CLIENT_CFLAGS"
+      AC_CHECK_HEADER([mysql.h], [
+
+        libmysqlclient_CFLAGS="$MYSQL_CLIENT_CFLAGS"
+        libmysqlclient_LIBS="$MYSQL_CLIENT_LIBS"
+
+        AC_SUBST([libmysqlclient_CFLAGS])
+        AC_SUBST([libmysqlclient_LIBS])
+
+      ])
+      CPPFLAGS="$ulogd_save_CPPFLAGS"
+
+    ])
+
+  ])
+
+])
+AS_IF([test "x$libmysqlclient_LIBS" != "x"], [enable_mysql=yes], [enable_mysql=no])
+AM_CONDITIONAL([HAVE_MYSQL], [test "x$libmysqlclient_LIBS" != "x"])
 
 AC_ARG_ENABLE([sqlite3],
               [AS_HELP_STRING([--enable-sqlite3], [Enable SQLITE3 output plugin [default=test]])])
-- 
2.34.1

