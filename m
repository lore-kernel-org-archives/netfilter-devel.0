Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5AF9C4167B
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244098AbiAFVKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244106AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19139C06118C
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XZ+pb5JvRWX33ZPuycOfL/TpTWmQOHbEXluTnGpvE6Y=; b=biErvRXL9/7CkPgC1qY23lE2IV
        HpkvjAPLKrdXkSS+EfZgRwSEIjxzi/We1+lswryX/l6dGluxg5M2ShyQykr+TOVnLvRWhKOXQoyrC
        0hd9olsbEvW+V4ZGUEN7j7HRDoRveLOF93BpFosi873hTCNd+9vkXwppNmMgpUb/aRiQlwmIyNf0q
        qUAYXtg90kwtQ+GF6f8XQvtvFGHYgEgq+aiRXLeAIL/HhU85RN/JqPyZyjTQmZVasfkTwfGNAcJ/S
        Wb80Mi/aceIWJw6mEHFC7+ZUK8daJZIfRaMZhp0xPcH7N7BBU/Yj/HrR5MdmHGva7SFRVjfcRNFnq
        8EmD1vkQ==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-E0
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 06/10] build: if `--enable-dbi` is `yes` abort if DBI is not found
Date:   Thu,  6 Jan 2022 21:09:33 +0000
Message-Id: <20220106210937.1676554-7-jeremy@azazel.net>
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

If DBI support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/configure.ac b/configure.ac
index df6fa543e81f..b6b44de888ec 100644
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

