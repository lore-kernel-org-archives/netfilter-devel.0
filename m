Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 020DBC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CBE7760FD7
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 16:14:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234137AbhKNQRi (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 11:17:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbhKNQRg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 11:17:36 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33A73C061746
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 08:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=NsBB6qmn0vll8IOEsjibGariOdhNXsbDbib+WGs7seI=; b=a62hJLMRvMFRHsx6dHg5eOXTV0
        h0jxTPSTnwtJTghw9YYriiFNX2eRNV+Bg3RkebjdKjvt/7HO/q56Dg4Z9rfpthYVsT1rCCpGciYhs
        RWkYEaeiOx750zkEqLJLou+ty9r8gV14BTWfnQ5N6xmf+ArRHuIHF0joNz6ElkdBf2XUWXmtmfYPm
        Xx7MvkbQdamwPIJlj5XVIjMFFIFitYVJ1MTySbvZb+3oPoviEBR59ORDxIiOMqe2zDLQR54wHWG3i
        dcRQfxtNd6n5Xe/5Ic9SYaJgT0axVc20czwAAdI2VKzy3XAS4mVQ19P6Sqt3EvkVBwAOTfo0Xx1oZ
        iS7IqE8Q==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmHo9-00CfJ1-RG
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 15:52:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v4 14/15] build: quote autoconf macro arguments
Date:   Sun, 14 Nov 2021 15:52:30 +0000
Message-Id: <20211114155231.793594-15-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211114155231.793594-1-jeremy@azazel.net>
References: <20211114155231.793594-1-jeremy@azazel.net>
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
 configure.ac | 92 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 60 insertions(+), 32 deletions(-)

diff --git a/configure.ac b/configure.ac
index 268cd10de2da..ff18cbe194db 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,7 +22,7 @@ AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_CHECK_HEADERS(fcntl.h unistd.h)
+AC_CHECK_HEADERS([fcntl.h unistd.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -32,13 +32,15 @@ AC_SYS_LARGEFILE
 
 dnl Checks for library functions.
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS(socket strerror)
+AC_CHECK_FUNCS([socket strerror])
 
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libpthread_LIBS])
 
-AC_ARG_ENABLE(ulog,
-       AS_HELP_STRING([--enable-ulog], [Enable ulog module [default=yes]]),[enable_ulog=$enableval],[enable_ulog=yes])
+AC_ARG_ENABLE([ulog],
+              [AS_HELP_STRING([--enable-ulog], [Enable ulog module [default=yes]])],
+              [enable_ulog=$enableval],
+              [enable_ulog=yes])
 AM_CONDITIONAL([BUILD_ULOG], [test "x$enable_ulog" = "xyes"])
 if [! test "x$enable_ulog" = "xyes"]; then
 	enable_ulog="no"
@@ -46,8 +48,11 @@ fi
 
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
@@ -57,8 +62,10 @@ if [! test "x$enable_nflog" = "xyes"]; then
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
@@ -68,8 +75,10 @@ if [! test "x$enable_nfct" = "xyes"]; then
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
@@ -80,22 +89,24 @@ if [! test "x$enable_nfacct" = "xyes"]; then
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
@@ -103,7 +114,8 @@ else
 fi
 
 
-AC_ARG_WITH([sqlite], AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]]))
+AC_ARG_WITH([sqlite],
+            [AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]])])
 AS_IF([test "x$with_sqlite" != "xno"], [
     PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])
 ])
@@ -114,18 +126,20 @@ else
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
     AC_SUBST([libpcap_LIBS])
@@ -137,7 +151,8 @@ else
 	enable_pcap="no"
 fi
 
-AC_ARG_WITH([jansson], AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]]))
+AC_ARG_WITH([jansson],
+            [AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]])])
 AS_IF([test "x$with_jansson" != "xno"], [
     PKG_CHECK_MODULES([libjansson], [jansson], [], [:])
 ])
@@ -149,21 +164,34 @@ else
 fi
 
 AC_ARG_WITH([ulogd2libdir],
-	AS_HELP_STRING([--with-ulogd2libdir=PATH],
-        [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
-        [ulogd2libdir="$withval"],
-        [ulogd2libdir="${libdir}/ulogd"])
+            [AS_HELP_STRING([--with-ulogd2libdir=PATH], [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]])],
+            [ulogd2libdir="$withval"],
+            [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
-	  include/linux/Makefile include/linux/netfilter/Makefile \
-	  include/linux/netfilter_ipv4/Makefile libipulog/Makefile \
-	  input/Makefile input/packet/Makefile input/flow/Makefile \
-	  input/sum/Makefile \
-	  filter/Makefile filter/raw2packet/Makefile \
-	  output/Makefile output/pcap/Makefile output/mysql/Makefile output/pgsql/Makefile output/sqlite3/Makefile \
-	  output/dbi/Makefile output/ipfix/Makefile \
-	  src/Makefile Makefile)
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

