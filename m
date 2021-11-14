Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BEE5C433EF
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8457360FD8
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhKNOSM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:18:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235272AbhKNOSH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:18:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37699C061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:15:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3SlGRILqGfEDbyODNfGg1wqBTQS+GWGHC6izw+NmUNc=; b=N5b+jEjpOLwSZboRz8Gqg8Lmkl
        HQ9nRjBwXQdvIb8hKm5Kyhz0zGTFzPS+SXzo+fN2X0AVV56NX5hYG7gaEA//UlNXsaewo10c+Tt9Q
        GIp48pvYv/vt7fwZGUg96FKOXKPXb8h+6j8T1ZK9dvzHGJgHDMz+vuuX3EyjK4lEpbzyJuF9UeNba
        XkMQS1AaKGT5RV+XrnbxK8md5WL7NKHYmhkf2UzDDZGOR4koozuaiqu25mqFlN5MeV72H3l5nK/i4
        AFJbv5T3aC6EO7OtHcPW9OzqiO1cTOeP8FhotPvJ/FhSrNWWcq05Jp0Rfewut2s3HV4eKu59tRdlx
        SB3Q6INQ==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4H-00Cdsh-9D
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 15/16] build: quote autoconf macro arguments
Date:   Sun, 14 Nov 2021 14:00:57 +0000
Message-Id: <20211114140058.752394-16-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114140058.752394-1-jeremy@azazel.net>
References: <20211114140058.752394-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Arguments are supposed to be quoted in square brackets.  Fix several that
weren't.

Sort and reformat the `AC_OUTPUT_FILES` argument list while we're at it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 94 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 61 insertions(+), 33 deletions(-)

diff --git a/configure.ac b/configure.ac
index 154650000fb1..1e321e6ff0a5 100644
--- a/configure.ac
+++ b/configure.ac
@@ -21,7 +21,7 @@ AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_CHECK_HEADERS(fcntl.h unistd.h)
+AC_CHECK_HEADERS([fcntl.h unistd.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -31,12 +31,14 @@ AC_SYS_LARGEFILE
 
 dnl Checks for library functions.
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS(socket strerror)
+AC_CHECK_FUNCS([socket strerror])
 
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
 
-AC_ARG_ENABLE(ulog,
-       AS_HELP_STRING([--enable-ulog], [Enable ulog module [default=yes]]),[enable_ulog=$enableval],[enable_ulog=yes])
+AC_ARG_ENABLE([ulog],
+              [AS_HELP_STRING([--enable-ulog], [Enable ulog module [default=yes]])],
+              [enable_ulog=$enableval],
+              [enable_ulog=yes])
 AM_CONDITIONAL([BUILD_ULOG], [test "x$enable_ulog" = "xyes"])
 if [! test "x$enable_ulog" = "xyes"]; then
 	enable_ulog="no"
@@ -44,8 +46,11 @@ fi
 
 dnl Check for the right nfnetlink version
 PKG_CHECK_MODULES([LIBNFNETLINK], [libnfnetlink >= 1.0.1])
-AC_ARG_ENABLE(nflog,
-       AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]]),[enable_nflog=$enableval],[enable_nflog=yes])
+
+AC_ARG_ENABLE([nflog],
+              [AS_HELP_STRING([--enable-nflog], [Enable nflog module [default=yes]])],
+              [enable_nflog=$enableval],
+              [enable_nflog=yes])
 AS_IF([test "x$enable_nflog" = "xyes"], [
     PKG_CHECK_MODULES([LIBNETFILTER_LOG], [libnetfilter_log >= 1.0.0])
     AC_DEFINE([BUILD_NFLOG], [1], [Building nflog module])
@@ -55,8 +60,10 @@ if [! test "x$enable_nflog" = "xyes"]; then
 	enable_nflog="no"
 fi
 
-AC_ARG_ENABLE(nfct,
-       AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]]),[enable_nfct=$enableval],[enable_nfct=yes])
+AC_ARG_ENABLE([nfct],
+              [AS_HELP_STRING([--enable-nfct], [Enable nfct module [default=yes]])],
+              [enable_nfct=$enableval],
+              [enable_nfct=yes])
 AS_IF([test "x$enable_nfct" = "xyes"], [
     PKG_CHECK_MODULES([LIBNETFILTER_CONNTRACK], [libnetfilter_conntrack >= 1.0.2])
     AC_DEFINE([BUILD_NFCT], [1], [Building nfct module])
@@ -66,8 +73,10 @@ if [! test "x$enable_nfct" = "xyes"]; then
 	enable_nfct="no"
 fi
 
-AC_ARG_ENABLE(nfacct,
-       AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]]),[enable_nfacct=$enableval],[enable_nfacct=yes])
+AC_ARG_ENABLE([nfacct],
+              [AS_HELP_STRING([--enable-nfacct], [Enable nfacct module [default=yes]])],
+              [enable_nfacct=$enableval],
+              [enable_nfacct=yes])
 AS_IF([test "x$enable_nfacct" = "xyes"], [
     PKG_CHECK_MODULES([LIBMNL], [libmnl >= 1.0.3])
     PKG_CHECK_MODULES([LIBNETFILTER_ACCT], [libnetfilter_acct >= 1.0.1])
@@ -78,22 +87,24 @@ if [! test "x$enable_nfacct" = "xyes"]; then
 	enable_nfacct="no"
 fi
 
-AC_ARG_WITH([pgsql], AS_HELP_STRING([--without-pgsql], [Build without postgresql output plugin [default=test]]))
+AC_ARG_WITH([pgsql],
+            [AS_HELP_STRING([--without-pgsql], [Build without postgresql output plugin [default=test]])])
 AS_IF([test "x$with_pgsql" != "xno"], [
 	CT_CHECK_POSTGRES_DB()
 ])
-AM_CONDITIONAL(HAVE_PGSQL, test "x$PQLIBPATH" != "x")
+AM_CONDITIONAL([HAVE_PGSQL], [test "x$PQLIBPATH" != "x"])
 if test "x$PQLIBPATH" != "x"; then
 	enable_pgsql="yes"
 else
 	enable_pgsql="no"
 fi
 
-AC_ARG_WITH([mysql], AS_HELP_STRING([--without-mysql], [Build without mysql output plugin [default=test]]))
+AC_ARG_WITH([mysql],
+            [AS_HELP_STRING([--without-mysql], [Build without mysql output plugin [default=test]])])
 AS_IF([test "x$with_mysql" != "xno"], [
 	CT_CHECK_MYSQL_DB()
 ])
-AM_CONDITIONAL(HAVE_MYSQL, test "x$MYSQL_LIB" != "x")
+AM_CONDITIONAL([HAVE_MYSQL], [test "x$MYSQL_LIB" != "x"])
 if test "x$MYSQL_LIB" != "x"; then
 	enable_mysql="yes"
 else
@@ -101,7 +112,8 @@ else
 fi
 
 
-AC_ARG_WITH([sqlite], AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]]))
+AC_ARG_WITH([sqlite],
+            [AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]])])
 AS_IF([test "x$with_sqlite" != "xno"], [
     PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])
 ])
@@ -112,18 +124,20 @@ else
 	enable_sqlite3="no"
 fi
 
-AC_ARG_WITH([dbi], AS_HELP_STRING([--without-dbi], [Build without DBI output plugin [default=test]]))
+AC_ARG_WITH([dbi],
+            [AS_HELP_STRING([--without-dbi], [Build without DBI output plugin [default=test]])])
 AS_IF([test "x$with_dbi" != "xno"], [
     CT_CHECK_DBI()
 ])
-AM_CONDITIONAL(HAVE_DBI, test "x$DBI_LIB" != "x")
+AM_CONDITIONAL([HAVE_DBI], [test "x$DBI_LIB" != "x"])
 if test "x$DBI_LIB" != "x"; then
 	enable_dbi="yes"
 else
 	enable_dbi="no"
 fi
 
-AC_ARG_WITH([pcap], AS_HELP_STRING([--without-pcap], [Build without PCAP output plugin [default=test]]))
+AC_ARG_WITH([pcap],
+            [AS_HELP_STRING([--without-pcap], [Build without PCAP output plugin [default=test]])])
 AS_IF([test "x$with_pcap" != "xno"], [
     AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
 ])
@@ -134,7 +148,8 @@ else
 	enable_pcap="no"
 fi
 
-AC_ARG_WITH([jansson], AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]]))
+AC_ARG_WITH([jansson],
+            [AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]])])
 AS_IF([test "x$with_jansson" != "xno"], [
     PKG_CHECK_MODULES([libjansson], [jansson], [], [:])
 ])
@@ -146,20 +161,33 @@ else
 fi
 
 AC_ARG_WITH([ulogd2libdir],
-	AS_HELP_STRING([--with-ulogd2libdir=PATH],
-        [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
-        [ulogd2libdir="$withval"],
-        [ulogd2libdir="${libdir}/ulogd"])
-
-AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
-	  include/linux/Makefile include/linux/netfilter/Makefile \
-	  include/linux/netfilter_ipv4/Makefile libipulog/Makefile \
-	  input/Makefile input/packet/Makefile input/flow/Makefile \
-	  input/sum/Makefile \
-	  filter/Makefile filter/raw2packet/Makefile \
-	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
-	  output/dbi/Makefile output/ipfix/Makefile \
-	  src/Makefile Makefile)
+            [AS_HELP_STRING([--with-ulogd2libdir=PATH], [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]])],
+            [ulogd2libdir="$withval"],
+            [ulogd2libdir="${libdir}/ulogd"])
+
+AC_CONFIG_FILES([Makefile
+		 filter/Makefile
+		 filter/raw2packet/Makefile
+		 include/Makefile
+		 include/libipulog/Makefile
+		 include/linux/Makefile
+		 include/linux/netfilter/Makefile
+		 include/linux/netfilter_ipv4/Makefile
+		 include/ulogd/Makefile
+		 input/Makefile
+		 input/flow/Makefile
+		 input/packet/Makefile
+		 input/sum/Makefile
+		 libipulog/Makefile
+		 output/Makefile
+		 output/dbi/Makefile
+		 output/ipfix/Makefile
+		 output/mysql/Makefile
+		 output/pcap/Makefile
+		 output/pgsql/Makefile
+		 output/sqlite3/Makefile
+		 src/Makefile])
+
 AC_OUTPUT
 
 define([EXPAND_VARIABLE],
-- 
2.33.0

