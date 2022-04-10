Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 719CBC433F5
	for <netfilter-devel@archiver.kernel.org>; Sun, 10 Apr 2022 12:10:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238644AbiDJMNG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 10 Apr 2022 08:13:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbiDJMNG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 10 Apr 2022 08:13:06 -0400
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6263D93
        for <netfilter-devel@vger.kernel.org>; Sun, 10 Apr 2022 05:10:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20190108; h=Content-Transfer-Encoding:MIME-Version:Message-Id:Date:Subject:
        To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:Content-Description:
        Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
        In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=P7OJPvg8LXm1sZUcB9HB+O4eT2CHwMn+s+8AgX8t5KI=; b=hqCCHVerwCXPMq7hiaXPlnLid7
        5mpk+oDXOuwA5nQxFZSxxzDnMlqcbNtCeFPSu/AqgtA8L5EvB24unOKEhCf8945+OVrYQSYFZi5O+
        A0SG/AMl8EQL+oG1ScKl8ExzM4uRZcVHFeYTR70f/M3yr2cy3PS5EGE1EpvlMFgQGgv0KzQatF+gy
        An+uHyym+p2yU86MLKZHhrfzcWKlPdLL+zaho6ZctfoDbAAyc8XoL+ZeDogRvqj0gOAfvCBsD+GJa
        w0zr/c2HiFefaNcYsRbwHSg0w3/Xk0QAeS+uBAcd+yRfwD/t6EiG9cTRyB1v1o83sdnZmL3LDX2cA
        CuBYI1MA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtp (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1ndWP5-00DLkQ-Cl
        for netfilter-devel@vger.kernel.org; Sun, 10 Apr 2022 13:10:51 +0100
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [libnetfilter_log PATCH] doc: correct non-native solecism
Date:   Sun, 10 Apr 2022 13:10:46 +0100
Message-Id: <20220410121046.1856691-1-jeremy@azazel.net>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The native usage is "... allows one to ...", not "... allows to ...".

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 src/libnetfilter_log.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
index 1b472426410f..cb093847f996 100644
--- a/src/libnetfilter_log.c
+++ b/src/libnetfilter_log.c
@@ -557,7 +557,7 @@ int nflog_set_mode(struct nflog_g_handle *gh,
  * \param gh Netfilter log group handle obtained by call to nflog_bind_group().
  * \param timeout Time to wait until the log buffer is pushed to userspace
  *
- * This function allows to set the maximum time that nflog waits until it
+ * This function allows one to set the maximum time that nflog waits until it
  * pushes the log buffer to userspace if no new logged packets have occured.
  * Basically, nflog implements a buffer to reduce the computational cost
  * of delivering the log message to userspace.
-- 
2.35.1

