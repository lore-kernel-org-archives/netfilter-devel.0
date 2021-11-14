Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC369C433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A9FF5603E5
	for <netfilter-devel@archiver.kernel.org>; Sun, 14 Nov 2021 14:14:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229563AbhKNORl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 14 Nov 2021 09:17:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236073AbhKNORi (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 14 Nov 2021 09:17:38 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC4F0C061766
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Nov 2021 06:14:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=lZcfmWmclG7rj5r9cvCfYzfG+Z8t7TNJGSCdMEuUsmc=; b=CIlFpc+s+P+8tx5wRRGm34Dg+3
        avDRvHmZTXPSAqWv3MdwJyCa+c0nDTi0zq6Kq5v+WRhoCRtvk4r7eER9Zf01VzglhGRqbeEOQPsOZ
        0RiL6cc9ca23i/4cfRVQsIu57IeUUftylp0lVcFjFbuCcciWXPd68jtkh8FPs4V+sZ96oERCeYGV0
        vp+ssUevErzlC0ZngI6YeKvoq+NRdS1O8809yHu18gyXPCiq6prZj3bs3cpKOxKjeAYm3HajHFRUg
        o2iRTQ37/prOco3eNxOT2d+jVTER9gBQIx6vF6D6GBSpnl64KyjEI7th3bfE/Ak7wnQralHtSVWJm
        t6/MlmSg==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mmG4H-00Cdsh-3n
        for netfilter-devel@vger.kernel.org; Sun, 14 Nov 2021 14:01:13 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v3 14/16] build: remove unnecessary `AC_SUBST` calls
Date:   Sun, 14 Nov 2021 14:00:56 +0000
Message-Id: <20211114140058.752394-15-jeremy@azazel.net>
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

We don't use the variables being passed to `AC_SUBST` in these calls as
output variables, so remove them.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 acinclude.m4 | 13 -------------
 configure.ac |  4 ----
 2 files changed, 17 deletions(-)

diff --git a/acinclude.m4 b/acinclude.m4
index 8388c452aade..16434f4fdf0d 100644
--- a/acinclude.m4
+++ b/acinclude.m4
@@ -25,9 +25,6 @@ AC_ARG_WITH(pgsql-lib,
 	[pg_lib=$withval], [pg_lib=])
 
 
-AC_SUBST(PQINCPATH)
-AC_SUBST(PQLIBPATH)
-AC_SUBST(PQLIBS)
 PQLIBS=-lpq
 
 if test "$pg_prefix" != "no"; then
@@ -120,9 +117,6 @@ AC_ARG_WITH(mysql-lib,
 	[my_lib=$withval], [my_lib=])
 
 
-AC_SUBST(MYSQL_INC)
-AC_SUBST(MYSQL_LIB)
-
 if test "$my_prefix" != "no"; then
 
 AC_MSG_CHECKING([for MySQL mysql_config program])
@@ -212,10 +206,6 @@ AC_ARG_WITH(pcap-lib,
 	[pcap_lib=$withval], [pcap_lib=/usr/lib])
 
 
-AC_SUBST(PCAP_INC)
-AC_SUBST(PCAP_LIB)
-AC_SUBST(HAVE_PCAP_LIB)
-
 if test "$pcap_prefix" != "no"; then
 
 if test "$pcap_prefix" != ""; then
@@ -291,9 +281,6 @@ AC_ARG_WITH(dbi-lib,
 	[dbi_lib=$withval], [dbi_lib=/usr/lib])
 
 
-AC_SUBST(DBI_INC)
-AC_SUBST(DBI_LIB)
-
 if test "$dbi_prefix" != "no"; then
 
 if test "$dbi_prefix" != ""; then
diff --git a/configure.ac b/configure.ac
index 268cd10de2da..154650000fb1 100644
--- a/configure.ac
+++ b/configure.ac
@@ -18,7 +18,6 @@ LT_INIT([disable-static])
 
 dnl Checks for libraries.
 AC_SEARCH_LIBS([dlopen], [dl], [libdl_LIBS="$LIBS"; LIBS=""])
-AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
@@ -35,7 +34,6 @@ AC_FUNC_VPRINTF
 AC_CHECK_FUNCS(socket strerror)
 
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
-AC_SUBST([libpthread_LIBS])
 
 AC_ARG_ENABLE(ulog,
        AS_HELP_STRING([--enable-ulog], [Enable ulog module [default=yes]]),[enable_ulog=$enableval],[enable_ulog=yes])
@@ -128,7 +126,6 @@ fi
 AC_ARG_WITH([pcap], AS_HELP_STRING([--without-pcap], [Build without PCAP output plugin [default=test]]))
 AS_IF([test "x$with_pcap" != "xno"], [
     AC_SEARCH_LIBS([pcap_close], [pcap], [libpcap_LIBS="-lpcap"; LIBS=""])
-    AC_SUBST([libpcap_LIBS])
 ])
 AM_CONDITIONAL([HAVE_PCAP], [test -n "$libpcap_LIBS"])
 if test "x$libpcap_LIBS" != "x"; then
@@ -153,7 +150,6 @@ AC_ARG_WITH([ulogd2libdir],
         [Default directory to load ulogd2 plugin from [[LIBDIR/ulogd]]]),
         [ulogd2libdir="$withval"],
         [ulogd2libdir="${libdir}/ulogd"])
-AC_SUBST([ulogd2libdir])
 
 AC_CONFIG_FILES(include/Makefile include/ulogd/Makefile include/libipulog/Makefile \
 	  include/linux/Makefile include/linux/netfilter/Makefile \
-- 
2.33.0

