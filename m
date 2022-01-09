Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C768C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbiAIL6n (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiAIL6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F7DFC061751
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Q3GnT5EfuCB4cqWO6SFcTq4wEiN2Ah7LoBEEpf26Xm0=; b=YrRC1M2XbKGh6/p8ff64ZX93Ax
        IljKHmmwlAnUSCoQV4Qmb0+FSvf5HjY8TKhKMR91DZMjdk60b0ddosGBNrssKPQCUUpVJHbmwN5af
        cx/WKe0hTKPrnuC0fJ4U07YYpipEwjRjP0ERToPGXGm0zl4goU+Wm65emr+KMNWO1ApfKX2UdWelH
        Fz7tGfRMPCTm2kIArmnKB5XxVRXay+Fb7DtOpw1f88OGCwLThH2YT24+fBzli3zlkkXDI0jJwfkRk
        cZp9Tqj378E8LB83dyuuYrJ3wzqMl8zX8kundv53Evy4mo3lklOYuCvEc4S0dBjOLYg37HUTXrHa0
        Sl4P0n5A==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqO-002BZm-Ff
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 03/10] build: use pkg-config or mysql_config for libmysqlclient
Date:   Sun,  9 Jan 2022 11:57:46 +0000
Message-Id: <20220109115753.1787915-4-jeremy@azazel.net>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220109115753.1787915-1-jeremy@azazel.net>
References: <20220109115753.1787915-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 192.168.96.2
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Recent versions of mariadb and mysql support pkg-config.  Older versions
provide a mysql_config script.  Use pkg-config if available, otherwise
fall back to mysql_config.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 acinclude.m4             | 93 ----------------------------------------
 configure.ac             | 53 +++++++++++++++++++++--
 output/mysql/Makefile.am |  4 +-
 3 files changed, 51 insertions(+), 99 deletions(-)

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
index a3ad198a1d33..bcdd2f8ed99f 100644
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
+  PKG_CHECK_EXISTS([mysqlclient],
+                   [PKG_CHECK_MODULES([libmysqlclient], [mysqlclient])],
+                   [
+
+    AC_ARG_WITH([mysql-config],
+                [AS_HELP_STRING([--with-mysql-config=PATH], [Path to the mysql_config script])],
+                [mysql_config="$withval"], [mysql_config=mysql_config])
+
+    AC_MSG_CHECKING([for mysql_config])
+
+    AS_IF([command -v "$mysql_config" >/dev/null], [
+
+      MYSQL_CLIENT_CFLAGS=`$mysql_config --cflags`
+      MYSQL_CLIENT_LIBS=`$mysql_config --libs`
+
+      AC_SUBST([MYSQL_CLIENT_CFLAGS])
+      AC_SUBST([MYSQL_CLIENT_LIBS])
+
+      AC_MSG_RESULT([$mysql_config])
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
+    ], [
+      AC_MSG_RESULT([no])
+    ])
+
+  ])
+
+])
+AS_IF([test "x$libmysqlclient_LIBS" != "x"], [enable_mysql=yes], [enable_mysql=no])
+AM_CONDITIONAL([HAVE_MYSQL], [test "x$libmysqlclient_LIBS" != "x"])
 
 AC_ARG_ENABLE([sqlite3],
               [AS_HELP_STRING([--enable-sqlite3], [Enable SQLITE3 output plugin [default=test]])])
diff --git a/output/mysql/Makefile.am b/output/mysql/Makefile.am
index 54abb9654eb7..69d983982cc9 100644
--- a/output/mysql/Makefile.am
+++ b/output/mysql/Makefile.am
@@ -1,9 +1,9 @@
 include $(top_srcdir)/Make_global.am
 
-AM_CPPFLAGS += $(MYSQL_INC)
+AM_CPPFLAGS += $(libmysqlclient_CFLAGS)
 
 pkglib_LTLIBRARIES = ulogd_output_MYSQL.la
 
 ulogd_output_MYSQL_la_SOURCES = ulogd_output_MYSQL.c ../../util/db.c
-ulogd_output_MYSQL_la_LIBADD  = ${MYSQL_LIB}
+ulogd_output_MYSQL_la_LIBADD  = $(libmysqlclient_LIBS)
 ulogd_output_MYSQL_la_LDFLAGS = -avoid-version -module
-- 
2.34.1

