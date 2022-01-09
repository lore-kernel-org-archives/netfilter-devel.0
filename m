Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36E3BC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbiAIL6p (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiAIL6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 643E0C061759
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=KW+RPCt+YiJJGQ0wJiQ/U2byqI2yXtXwoDvzXSaXyR8=; b=JeICLRvOU2ZPcFAikc5MgAcaNT
        eKSsGLNfFWCfnRCEyLUYF04eJ9z6hzMjz153GNHSMLOI+Wwe8DfCYcjVVEUxdR4QfvU1HvJg0lYFw
        cuD8NWDVblhLt/H+e+1qfm2FCsn5w6XB/vGq53ISYCtOR8wbC3C6u+Be64dVa630liIZbRNag9dtM
        P0z9ygw7p2T8JGxiCJTzfMWSmZ3d5JiSBQBJsr53LuDFEe0Ri03n7+P9XUOumrjQlcz59GML0fVVu
        sLjpjbSWFQTEn4NbGKRSMZaGp/6LytFMNZiOEhxQTFSleQZm3hzyOrBvgYGg9n5KzqahmZQ2YqB4f
        9CMtJ03g==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqO-002BZm-OP
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 06/10] build: if `--enable-dbi` is `yes`, abort if libdbi is not found
Date:   Sun,  9 Jan 2022 11:57:49 +0000
Message-Id: <20220109115753.1787915-7-jeremy@azazel.net>
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

If DBI support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index 75764db8aec9..bd1059a9633b 100644
--- a/configure.ac
+++ b/configure.ac
@@ -171,8 +171,13 @@ AM_CONDITIONAL([HAVE_SQLITE3], [test "x$libsqlite3_LIBS" != "x"])
 
 AC_ARG_ENABLE([dbi],
               [AS_HELP_STRING([--enable-dbi], [Enable DBI output plugin [default=test]])])
-AS_IF([test "x$enable_dbi" != "xno"],
-      [PKG_CHECK_MODULES([libdbi], [dbi], [], [:])])
+AS_IF([test "x$enable_dbi" != "xno"], [
+  PKG_CHECK_MODULES([libdbi], [dbi], [], [
+    AS_IF([test "x$enable_dbi" = "xyes"], [
+      AC_MSG_ERROR([$libdbi_PKG_ERRORS])
+    ])
+  ])
+])
 AS_IF([test "x$libdbi_LIBS" != "x"], [enable_dbi=yes], [enable_dbi=no])
 AM_CONDITIONAL([HAVE_DBI], [test "x$libdbi_LIBS" != "x"])
 
-- 
2.34.1

