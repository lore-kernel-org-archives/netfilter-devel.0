Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DF70C4321E
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiAIL6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233893AbiAIL6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A73D4C06175B
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=URBlujcejAUWLMWk0U/mn1cZ8euRprIzJwIP+neA1M8=; b=k7Mxv5k22oVoThPERo7lrlszaP
        RmZUZWCq2DqAUNBLQ057F4xlvAvJ78tDjm99L3fWEAm0SrK3qy1YoBBfD7EI0KJoRTlyh0cmIk1so
        td4WfAEZMZpXWVHKHtKqg+o67Ajnh6KVCWWrtD7vddMz08JLISd6HitadJiFc1ixLOVQck9ITd0VN
        AnZgm4kCZ/p//2Y6hvJ4PKs+zivXmnEjpaeZaeMXUZF0+lyzz6EwK+8P0XXc75/xPTkM76qETDNkO
        0NLAfjcvnQ30p2yyVRjJD2JGDwfFA4HClI4HzFI14XTTDarQ9ZfEEnt4Ey82pMXInyH+cPOIIqocF
        LvrUaxWw==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqO-002BZm-W8
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:41 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 09/10] build: if `--enable-pgsql` is `yes`, abort if libpq is not found
Date:   Sun,  9 Jan 2022 11:57:52 +0000
Message-Id: <20220109115753.1787915-10-jeremy@azazel.net>
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

If PostgreSQL support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index 41eeb52b9121..62c43d630b29 100644
--- a/configure.ac
+++ b/configure.ac
@@ -104,6 +104,12 @@ AS_IF([test "x$enable_pgsql" != "xno"], [
       AC_MSG_RESULT([no])
     ])
 
+    AS_IF([test "x$libpq_LIBS" = "x"], [
+      AS_IF([test "x$enable_pgsql" = "xyes"], [
+        AC_MSG_ERROR([libpq not found])
+      ])
+    ])
+
   ])
 
 ])
-- 
2.34.1

