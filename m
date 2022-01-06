Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D609C4321E
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244106AbiAFVKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244117AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F8C2C061245
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Km3TOzF07pZkfzf/onNGHKWzM4QfXqQbDIBWVG9UJkg=; b=YY5ZJr+Uex3+ElLcGZPn27WHgt
        XsZy02MAPM2JScnEOFfYCMr2H058uGG8mGWdNmOlJvHHZ7XkuEwwg6hcMrhEA3klwcdin3cuW19FP
        wPnzHQx0iL2P5Jz/A26n2eTE/YPl66i16tmCtk/8TR1M7EIqB95llYma1ZxCJP7Mn/Px9McCfJEeg
        tSHt6yZKd2t3GR1WII05kaXG+RLzYcrXqK7Z3cOXGIWzUu5+RHN4+uYd5D5HFCn9URaXYZ7zqICS2
        TDFphiv4jLbNEQizRrMcFYMMBLgPAaPagy3raP3QXw0xVoseLXYadm/GlT9OKBrIbhmz1kSu6iQhm
        8zeuJwrA==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-J6
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 07/10] build: if `--enable-mysql` is `yes` abort if MySQL is not found
Date:   Thu,  6 Jan 2022 21:09:34 +0000
Message-Id: <20220106210937.1676554-8-jeremy@azazel.net>
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

If MySQL support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index b6b44de888ec..67f489c22433 100644
--- a/configure.ac
+++ b/configure.ac
@@ -156,6 +156,12 @@ AS_IF([test "x$enable_mysql" != "xno"], [
 
     ])
 
+    AS_IF([test "x$libmysqlclient_LIBS" = "x"], [
+      AS_IF([test "x$enable_mysql" = "xyes"], [
+        AC_MSG_ERROR([libmysqlclient not found])
+      ])
+    ])
+
   ])
 
 ])
-- 
2.34.1

