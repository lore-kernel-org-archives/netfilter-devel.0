Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27A6BC433FE
	for <netfilter-devel@archiver.kernel.org>; Sun,  9 Jan 2022 11:58:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiAIL6q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 9 Jan 2022 06:58:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231294AbiAIL6m (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 9 Jan 2022 06:58:42 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74743C06175A
        for <netfilter-devel@vger.kernel.org>; Sun,  9 Jan 2022 03:58:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=8qrgG4fPD7bogozFX8gcHskCxvHbu6MpB+5WB/P3dqM=; b=KvLtX+bXtp41FwW5UD3Vg1Cj8L
        Fr5TrYM65jJ7btq9LnY7rLEI/sD3IUeYcvQ/nyN/oOiT+yB2DC3+DRdzduXq+n/NRYFm649G+29HC
        s0vpalmUAF7zxIo/UvHg11KvmR8z46ZMlAJfdAv3zWAtiXeTsatDs6WjHqBl0NLKsquHaJPv6wVb6
        G340bGwY5fBnVU7S1g+CpP+CIwMK+NdORly1C4vl54UNBGeAbU8g4yR+dx1MGpQUSkCS1+ncxyJVa
        MPHps8jWcOyD+gYntL8AAPORnaxE9HEnGgVTKPw9OoKDjutRcpj4b0ENw0jvQtscnWQUlxkk/G2z5
        LZlUUF0w==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n6WqO-002BZm-QZ
        for netfilter-devel@vger.kernel.org; Sun, 09 Jan 2022 11:58:40 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH v2 07/10] build: if `--enable-mysql` is `yes`, abort if libmysqlclient is not found
Date:   Sun,  9 Jan 2022 11:57:50 +0000
Message-Id: <20220109115753.1787915-8-jeremy@azazel.net>
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

If MySQL support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index bd1059a9633b..620cb34c8537 100644
--- a/configure.ac
+++ b/configure.ac
@@ -156,6 +156,12 @@ AS_IF([test "x$enable_mysql" != "xno"], [
       AC_MSG_RESULT([no])
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

