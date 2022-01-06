Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C94DEC4167D
	for <netfilter-devel@archiver.kernel.org>; Thu,  6 Jan 2022 21:10:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244123AbiAFVKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 6 Jan 2022 16:10:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244039AbiAFVKI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 6 Jan 2022 16:10:08 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D55DC061201
        for <netfilter-devel@vger.kernel.org>; Thu,  6 Jan 2022 13:10:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zCgzuSZK4G6epVYWVZi0mV9vesmCgXRCuCN7+BB7fh8=; b=Bt4NPCF6qUbRJ1LXBqExtkf/mH
        qjKxImz0CcMdd9Xri8PA00pZboz8gvGjYy61qE6Ap/Awg7WX+yKId1s9ULOHlmKY7pV3qcJ6wiKtO
        Ak34SmqoEXFDHW6JEGv9ld6HtO1Sok5tTAe5TdfHBxEfoBxi7jSzG9pslzkqSk31cOqVoi5S1G8Th
        HSXFE5I+Y1L251tWLRXrn/oN08bEfUilGy6AmedQC4uEtr9+4RUVNBS0fe4yX4qnvXqGBdL1PQ4mv
        4cwQ6DGZW7XKuBVWbySR4m+aTpxQowXqwP62bUQj54MJZDL8LuKTNj8U+buUBGBmEOoXVomvKq+YG
        Jw87v7/g==;
Received: from ulthar.dreamlands ([192.168.96.2] helo=ulthar.dreamlands.azazel.net)
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1n5a1O-00H0N6-M9
        for netfilter-devel@vger.kernel.org; Thu, 06 Jan 2022 21:10:06 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [ulogd2 PATCH 08/10] build: if `--enable-pcap` is `yes` abort if libpcap is not found
Date:   Thu,  6 Jan 2022 21:09:35 +0000
Message-Id: <20220106210937.1676554-9-jeremy@azazel.net>
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

If libpcap support has been explicitly requested, abort if it is not
available.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 configure.ac | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/configure.ac b/configure.ac
index 67f489c22433..4d65d234be69 100644
--- a/configure.ac
+++ b/configure.ac
@@ -213,6 +213,12 @@ AS_IF([test "x$enable_pcap" != "xno"], [
       AC_MSG_RESULT([no])
     ])
 
+    AS_IF([test "x$libpcap_LIBS" = "x"], [
+      AS_IF([test "x$enable_pcap" = "xyes"], [
+        AC_MSG_ERROR([libpcap not found])
+      ])
+    ])
+
   ])
 
 ])
-- 
2.34.1

