Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 212D3C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:13:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244140AbiAFVNR (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244131AbiAFVNQ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:13:16 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80E7EC061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:13:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=YeaT7lPnI0JcTOrGmW5HgtySOqpyXTJUh19uufgD/AU=; b=deMyhMIvm3efXiDSzjQAklznHC
        OBNv6gS2Iej3a6C/Deyi6Z29Vk47vJLcj44UmdonTZSM5Np+zQPK6gVd0DzJF6dWdCfjW1KxaBzIn
        afl7fMWDnHTeKdzTInA/55DIolpx3zGsfYa932RDvmlBT3eec5r/ljcfTlSIsWKWcGNAgYRLclhLb
        iIkbuYORuRBrtFVpDebYbF9KVsNdqiXfcNIPK3d2yzccC76z6rvvY8B1oK8UECiy9wwacJIeYk1DJ
        +yjAohwEztCo+7F+lEgERAuNM0t1N5BB9whhOVpJd9AvFAPgoeWTVULMPV53RYQWmUK83vm6vUQ2P
        hA9goT2w==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-Sq
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 10/10] build: if `--enable-sqlite3` is `yes` abort if libsqlite3 is not found
Date:   Thu,  6 Jan 2022 21:09:37 +0000
Message-Id: <20220106210937.1676554-11-jeremy@azazel.net>
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

If SQLITE3 support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index fd033164b872..1469f0f253d7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -176,8 +176,13 @@ AM_CONDITIONAL([HAVE_MYSQL], [test "x$libmysqlclient_LIBS" != "x"])
 
 AC_ARG_ENABLE([sqlite3],
               [AS_HELP_STRING([--enable-sqlite3], [Enable SQLITE3 output plugin [default=test]])])
-AS_IF([test "x$enable_sqlite3" != "xno"],
-      [PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [:])])
+AS_IF([test "x$enable_sqlite3" != "xno"], [
+  PKG_CHECK_MODULES([libsqlite3], [sqlite3], [], [
+    AS_IF([test "x$enable_sqlite3" = "xyes"], [
+      AC_MSG_ERROR([$libsqlite3_PKG_ERRORS])
+    ])
+  ])
+])
 AS_IF([test "x$libsqlite3_LIBS" != "x"], [enable_sqlite3=yes], [enable_sqlite3=no])
 AM_CONDITIONAL([HAVE_SQLITE3], [test "x$libsqlite3_LIBS" != "x"])
 
-- 
2.34.1

