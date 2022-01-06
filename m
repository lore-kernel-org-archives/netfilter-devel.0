Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D6A7C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244121AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239150AbiAFVKH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:07 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6850EC061201
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ex1+UNacHBUl+L9/BVxyDm7DgHrykhSYI4E39gMLfmw=; b=DVNKJfXAvhxAuxprOChmSeWxYA
        Mm9521txkONiZi8C5WZ4d+XMbFmC04qo20GXs0WQ/58eDpJNyk06l86OavPGYkboHu2Lfp+wQngFF
        Q2nWK29WvGYW1il40u2Yf9z20L1Ovz0nJJ+m7ycE1s7foHsveypr9xES2R1xYqh8m0Z8hHLc3aXuN
        zej5CkMGg7G+Wilh/IH/VcPvbZm3rwIeTqyo/9Kxc7d1uosv9jZNJa2eeYDnQ1sBX1QysEFM6oi58
        3PsXG/9rEPGdYALSJD4Ys2mJioT1uf66agbrTny3KShRuHHucjFSNczBg9o/qVbs+SeKes0iZhHIc
        jH7MbXKg==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1N-00H0N6-SX
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:05 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 01/10] build: use `--enable-blah` flags for output plugins
Date:   Thu,  6 Jan 2022 21:09:28 +0000
Message-Id: <20220106210937.1676554-2-jeremy@azazel.net>
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

Currently, we use `AC_ARG_WITH` for output plugins.  However, this is
not consistent with the input plugins, which use `AC_ARG_ENABLE`, and in
some cases (dbi, mysql, pgsql) the macro calls in configure.ac conflict
with other calls in acinclude.m4.  Use `AC_ARG_ENABLE` instead and
change the name of the flag for the JSON plugin from `jansson` to
`json`.

Fixes: 51ba7aec8951 ("Fix automagic support of dbi, pcap and sqlite3")
Fixes: c61c05c2d050 ("configure.ac: Add --without-{mysql,pgsql}")
Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 40 ++++++++++++++++++++--------------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/configure.ac b/configure.ac
index b3e1c8f6b926..b24357dcd4b4 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,47 +78,47 @@ AS_IF([test "x$enable_nfacct" = "xyes"],
       [enable_nfacct=no])
 AM_CONDITIONAL([BUILD_NFACCT], [test "x$enable_nfacct" = "xyes"])
 
-AC_ARG_WITH([pgsql],
-            [AS_HELP_STRING([--without-pgsql], [Build without postgresql output plugin [default=test]])])
-AS_IF([test "x$with_pgsql" != "xno"],
+AC_ARG_ENABLE([pgsql],
+              [AS_HELP_STRING([--enable-pgsql], [Enable PostgreSQL output plugin [default=test]])])
+AS_IF([test "x$enable_pgsql" != "xno"],
       [CT_CHECK_POSTGRES_DB()])
 AS_IF([test "x$PQLIBPATH" != "x"], [enable_pgsql=yes], [enable_pgsql=no])
 AM_CONDITIONAL([HAVE_PGSQL], [test "x$PQLIBPATH" != "x"])
 
-AC_ARG_WITH([mysql],
-            [AS_HELP_STRING([--without-mysql], [Build without mysql output plugin [default=test]])])
-AS_IF([test "x$with_mysql" != "xno"],
+AC_ARG_ENABLE([mysql],
+              [AS_HELP_STRING([--enable-mysql], [Enable MySQL output plugin [default=test]])])
+AS_IF([test "x$enable_mysql" != "xno"],
       [CT_CHECK_MYSQL_DB()])
 AS_IF([test "x$MYSQL_LIB" != "x"], [enable_mysql=yes], [enable_mysql=no])
 AM_CONDITIONAL([HAVE_MYSQL], [test "x$MYSQL_LIB" != "x"])
 
-AC_ARG_WITH([sqlite],
-            [AS_HELP_STRING([--without-sqlite], [Build without SQLITE3 output plugin [default=test]])])
-AS_IF([test "x$with_sqlite" != "xno"],
+AC_ARG_ENABLE([sqlite3],
+              [AS_HELP_STRING([--enable-sqlite3], [Enable SQLITE3 output plugin [default=test]])])
+AS_IF([test "x$enable_sqlite3" != "xno"],
       [PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])])
 AS_IF([test "x$libsqlite3_LIBS" != "x"], [enable_sqlite3=yes], [enable_sqlite3=no])
 AM_CONDITIONAL([HAVE_SQLITE3], [test "x$libsqlite3_LIBS" != "x"])
 
-AC_ARG_WITH([dbi],
-            [AS_HELP_STRING([--without-dbi], [Build without DBI output plugin [default=test]])])
-AS_IF([test "x$with_dbi" != "xno"],
+AC_ARG_ENABLE([dbi],
+              [AS_HELP_STRING([--enable-dbi], [Enable DBI output plugin [default=test]])])
+AS_IF([test "x$enable_dbi" != "xno"],
       [CT_CHECK_DBI()])
 AS_IF([test "x$DBI_LIB" != "x"], [enable_dbi=yes], [enable_dbi=no])
 AM_CONDITIONAL(HAVE_DBI, [test "x$DBI_LIB" != "x"])
 
-AC_ARG_WITH([pcap],
-            [AS_HELP_STRING([--without-pcap], [Build without PCAP output plugin [default=test]])])
-AS_IF([test "x$with_pcap" != "xno"],
+AC_ARG_ENABLE([pcap],
+              [AS_HELP_STRING([--enable-pcap], [Enable PCAP output plugin [default=test]])])
+AS_IF([test "x$enable_pcap" != "xno"],
       [AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
        AC_SUBST([libpcap_LIBS])])
 AS_IF([test "x$libpcap_LIBS" != "x"], [enable_pcap=yes], [enable_pcap=no])
 AM_CONDITIONAL([HAVE_PCAP], [test "x$libpcap_LIBS" != "x"])
 
-AC_ARG_WITH([jansson],
-            [AS_HELP_STRING([--without-jansson], [Build without JSON output plugin [default=test]])])
-AS_IF([test "x$with_jansson" != "xno"],
+AC_ARG_ENABLE([json],
+              [AS_HELP_STRING([--enable-json], [Enable JSON output plugin [default=test]])])
+AS_IF([test "x$enable_json" != "xno"],
       [PKG_CHECK_MODULES([libjansson], [jansson], [], [:])])
-AS_IF([test "x$libjansson_LIBS" != "x"], [enable_jansson=yes], [enable_jansson=no])
+AS_IF([test "x$libjansson_LIBS" != "x"], [enable_json=yes], [enable_json=no])
 AM_CONDITIONAL([HAVE_JANSSON], [test "x$libjansson_LIBS" != "x"])
 
 AC_ARG_WITH([ulogd2libdir],
@@ -182,6 +182,6 @@ Ulogd configuration:
     MySQL plugin:			${enable_mysql}
     SQLITE3 plugin:			${enable_sqlite3}
     DBI plugin:				${enable_dbi}
-    JSON plugin:			${enable_jansson}
+    JSON plugin:			${enable_json}
 "
 echo "You can now run 'make' and 'make install'"
-- 
2.34.1

