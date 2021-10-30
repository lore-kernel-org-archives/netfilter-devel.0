Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79F9DC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:10:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5B26F60F4B
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Oct 2021 16:10:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbhJ3QNJ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Oct 2021 12:13:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229809AbhJ3QNI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Oct 2021 12:13:08 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:fb7d:d6d6:e0:4cff:fe83:e514])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B37D0C061570
        for <netfilter-devel@vger.kernel.org>; Sat, 30 Oct 2021 09:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FJAewqZrS0dbvimHtJ3zXe3s8rRcyxZQfK1xj34xn14=; b=EXqXmAt8UD7OIzPVanZ0IERebC
        +IQ2q7F/FrFv2qZVl8HB+kx9QjWksZC280UcRxFwO+k7NxeuGIRhjxWkuvats+EMawDZEagYTbJC/
        9m8lkLuqElKxB/fLSeO3CgQHpsw0rfL7qRYmGR5jq8DxLoy0LBFoiV2Xzz3xumhMA+tqAkv7yRnUK
        6yvu55LjDESy01qPCSATSuOR4NSF1Ia4ULLFwpdO3ofQH7HQnXc3d2RwahOzpPvx3aEE7sOTmeC46
        V/AbtTTB/r6X5p9R7rTbsVXVUilaQAUUlGRjY0UG9VJqhluHXpkON4Dz8KcKwCRJKMGzP9vQmVsOD
        eG9Csvug==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae] helo=ulthar.scientificgames.com)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1mgqng-00AFQk-C4
        for netfilter-devel@vger.kernel.org; Sat, 30 Oct 2021 17:01:44 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 11/13] build: quote and reformat some autoconf macro arguments
Date:   Sat, 30 Oct 2021 17:01:39 +0100
Message-Id: <20211030160141.1132819-12-jeremy@azazel.net>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211030160141.1132819-1-jeremy@azazel.net>
References: <20211030160141.1132819-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 48 +++++++++++++++++++++++++-----------------------
 1 file changed, 25 insertions(+), 23 deletions(-)

diff --git a/configure.ac b/configure.ac
index 2dfeee6aa4cb..e69beb2b49ce 100644
--- a/configure.ac
+++ b/configure.ac
@@ -22,7 +22,7 @@ AC_SUBST([libdl_LIBS])
 
 dnl Checks for header files.
 AC_HEADER_DIRENT
-AC_CHECK_HEADERS(fcntl.h unistd.h)
+AC_CHECK_HEADERS([fcntl.h unistd.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
@@ -32,7 +32,7 @@ AC_SYS_LARGEFILE
 
 dnl Checks for library functions.
 AC_FUNC_VPRINTF
-AC_CHECK_FUNCS(socket strerror)
+AC_CHECK_FUNCS([socket strerror])
 
 AC_SEARCH_LIBS([pthread_create], [pthread], [libpthread_LIBS="$LIBS"; LIBS=""])
 AC_SUBST([libpthread_LIBS])
@@ -155,27 +155,29 @@ AC_ARG_WITH([ulogd2libdir],
         [ulogd2libdir="${libdir}/ulogd"])
 AC_SUBST([ulogd2libdir])
 
-dnl AC_SUBST(DATABASE_DIR)
-dnl AC_SUBST(DATABASE_LIB)
-dnl AC_SUBST(DATABASE_LIB_DIR)
-dnl AC_SUBST(DB_DEF)
-dnl AC_SUBST(EXTRA_MYSQL_DEF)
-dnl AC_SUBST(EXTRA_PGSQL_DEF)
-
-dnl AC_SUBST(DATABASE_DRIVERS)
-
-dnl AM_CONDITIONAL(HAVE_MYSQL, test x$mysqldir != x)
-dnl AM_CONDITIONAL(HAVE_PGSQL, test x$pgsqldir != x)
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
+AC_CONFIG_FILES([include/Makefile
+		 include/ulogd/Makefile
+		 include/libipulog/Makefile
+		 include/linux/Makefile
+		 include/linux/netfilter/Makefile
+		 include/linux/netfilter_ipv4/Makefile
+		 libipulog/Makefile
+		 input/Makefile
+		 input/packet/Makefile
+		 input/flow/Makefile
+		 input/sum/Makefile
+		 filter/Makefile
+		 filter/raw2packet/Makefile
+		 output/Makefile
+		 output/pcap/Makefile
+		 output/mysql/Makefile
+		 output/pgsql/Makefile
+		 output/sqlite3/Makefile
+		 output/dbi/Makefile
+		 output/ipfix/Makefile
+		 src/Makefile
+		 Makefile])
+
 AC_OUTPUT
 
 define([EXPAND_VARIABLE],
-- 
2.33.0

