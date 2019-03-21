Return-Path: <SRS0=rW9L=RY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0592C43381
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:55:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3B9D218FD
	for <netfilter-devel@archiver.kernel.org>; Thu, 21 Mar 2019 11:55:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727874AbfCULzC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 21 Mar 2019 07:55:02 -0400
Received: from a3.inai.de ([88.198.85.195]:52430 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726551AbfCULzC (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 21 Mar 2019 07:55:02 -0400
Received: by a3.inai.de (Postfix, from userid 65534)
        id B32DBE15C9C; Thu, 21 Mar 2019 12:54:59 +0100 (CET)
Received: from a4.inai.de (a4.inai.de [IPv6:2a01:4f8:222:6c9::f8])
        by a3.inai.de (Postfix) with ESMTP id 361903BAB1E2;
        Thu, 21 Mar 2019 12:54:56 +0100 (CET)
From:   Jan Engelhardt <jengelh@inai.de>
To:     netfilter-devel@vger.kernel.org
Cc:     eric@regit.org
Subject: [PATCH] build: adjust configure for postgresql 11
Date:   Thu, 21 Mar 2019 12:54:56 +0100
Message-Id: <20190321115456.24137-1-jengelh@inai.de>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

At least in openSUSE, PostgreSQL 11 no longer ships the pg_config
program. Instead, there is has been a pkg-config file around for a
while (also in pg10), so make use of that, by default.

The old --with-pgsql-inc and --with-pgsql-lib option are going away
and replaced by the standardized mechanisms pkg-config.m4 has in
store for when there is no .pc file:

	./configure pgsql_CFLAGS="-I/opt/pgsql/include" \
	pgsql_LIBS="-L/opt/pgsql/lib -lpq"
---
 acinclude.m4             | 77 +---------------------------------------
 configure.ac             |  9 +++--
 output/pgsql/Makefile.am |  4 +--
 3 files changed, 7 insertions(+), 83 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 8388c45..3813c6c 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -14,82 +14,7 @@ dnl @license AllPermissive
 
 AC_DEFUN([CT_CHECK_POSTGRES_DB], [
 
-AC_ARG_WITH(pgsql,
-	[  --with-pgsql=PREFIX		Prefix of your PostgreSQL installation],
-	[pg_prefix=$withval], [pg_prefix=])
-AC_ARG_WITH(pgsql-inc,
-	[  --with-pgsql-inc=PATH		Path to the include directory of PostgreSQL],
-	[pg_inc=$withval], [pg_inc=])
-AC_ARG_WITH(pgsql-lib,
-	[  --with-pgsql-lib=PATH		Path to the libraries of PostgreSQL],
-	[pg_lib=$withval], [pg_lib=])
-
-
-AC_SUBST(PQINCPATH)
-AC_SUBST(PQLIBPATH)
-AC_SUBST(PQLIBS)
-PQLIBS=-lpq
-
-if test "$pg_prefix" != "no"; then
-
-AC_MSG_CHECKING([for PostgreSQL pg_config program])
-for d in $pg_prefix/bin /usr/bin /usr/local/bin /usr/local/pgsql/bin /opt/pgsql/bin /opt/packages/pgsql/bin
-do
-	if test -x $d/pg_config -a "$cross_compiling" = "no";
-	then
-		AC_MSG_RESULT(found pg_config in $d)
-		PQINCPATH=`$d/pg_config --includedir`
-		PQLIBPATH=`$d/pg_config --libdir`
-		break
-	fi
-done
-
-if test "$PQINCPATH" = ""; then
-   if test "$pg_prefix" != ""; then
-      AC_MSG_CHECKING([for PostgreSQL includes in $pg_prefix/include])
-      if test -f "$pg_prefix/include/libpq-fe.h" ; then
-         PQINCPATH="-I$pg_prefix/include"
-         AC_MSG_RESULT([yes])
-      else
-         AC_MSG_WARN(libpq-fe.h not found)
-      fi
-      AC_MSG_CHECKING([for PostgreSQL libraries in $pg_prefix/lib])
-      if test -f "$pg_prefix/lib/libpq.so" ; then
-         PQLIBPATH="-L$pg_prefix/lib"
-         AC_MSG_RESULT([yes])
-      else
-         AC_MSG_WARN(libpq.so not found)
-      fi
-   else
-     if test "$pg_inc" != ""; then
-       AC_MSG_CHECKING([for PostgreSQL includes in $pg_inc])
-       if test -f "$pg_inc/libpq-fe.h" ; then
-         PQINCPATH="-I$pg_inc"
-         AC_MSG_RESULT([yes])
-       else
-         AC_MSG_WARN(libpq-fe.h not found)
-       fi
-     fi
-     if test "$pg_lib" != ""; then
-       AC_MSG_CHECKING([for PostgreSQL libraries in $pg_lib])
-       if test -f "$pg_lib/libpq.so" ; then
-         PQLIBPATH="-L$pg_lib"
-         AC_MSG_RESULT([yes])
-       else
-         AC_MSG_WARN(libpq.so not found)
-       fi
-     fi
-   fi
-fi
-
-if test "$PQINCPATH" = "" ; then
-  AC_CHECK_HEADER([libpq-fe.h], [], AC_MSG_WARN(libpq-fe.h not found))
-fi
-if test "$PQLIBPATH" = "" ; then
-  AC_CHECK_LIB(pq, PQconnectdb, [], AC_MSG_WARN(libpq.so not found))
-fi
-
-fi
+PKG_CHECK_MODULES([pgsql], [libpq])
 
 ])
 
diff --git a/configure.ac b/configure.ac
index 3aa0624..da46e09 100644
--- a/configure.ac
+++ b/configure.ac
@@ -86,12 +86,11 @@ AC_ARG_WITH([pgsql], AS_HELP_STRING([--without-pgsql], [Build without postgresql
 AS_IF([test "x$with_pgsql" != "xno"], [
 	CT_CHECK_POSTGRES_DB()
 ])
-AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
-if test "x$PQLIBPATH" != "x"; then
-	enable_pgsql="yes"
-else
-	enable_pgsql="no"
+enable_pgsql="no"
+if test "x$pgsql_CFLAGS" != "x" || test "x$pgsql_LIBS" != "x"; then
+	enable_pgsql=yes
 fi
+AM_CONDITIONAL([HAVE_PGSQL], [test "$enable_pgsql" = yes])
 
 AC_ARG_WITH([mysql], AS_HELP_STRING([--without-mysql], [Build without mysql output plugin [default=test]]))
 AS_IF([test "x$with_mysql" != "xno"], [
diff --git a/output/pgsql/Makefile.am b/output/pgsql/Makefile.am
index bdaf1d2..6c1d35a 100644
--- a/output/pgsql/Makefile.am
+++ b/output/pgsql/Makefile.am
@@ -1,5 +1,5 @@
 
-AM_CPPFLAGS = -I$(top_srcdir)/include -I$(PQINCPATH)
+AM_CPPFLAGS = -I$(top_srcdir)/include ${pgsql_CFLAGS}
 AM_CFLAGS = ${regular_CFLAGS}
 
 if HAVE_PGSQL
@@ -7,7 +7,7 @@ if HAVE_PGSQL
 pkglib_LTLIBRARIES = ulogd_output_PGSQL.la
 
 ulogd_output_PGSQL_la_SOURCES = ulogd_output_PGSQL.c ../../util/db.c
-ulogd_output_PGSQL_la_LIBADD  = ${PQLIBS}
+ulogd_output_PGSQL_la_LIBADD  = ${pgsql_LIBS}
 ulogd_output_PGSQL_la_LDFLAGS = -avoid-version -module
 
 endif
-- 
2.21.0

