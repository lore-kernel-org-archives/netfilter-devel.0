Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63784C6FA99
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Mar 2023 23:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229651AbjCGXbn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Mar 2023 18:31:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41250 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbjCGXbj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Mar 2023 18:31:39 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 007C3A8C70
        for <netfilter-devel@vger.kernel.org>; Tue,  7 Mar 2023 15:31:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qlxpCSoK+NhgMUfeaKi8he8/WKGyekBfAjCcxpgsWb4=; b=pqNsFhGCYpUpuwRoWfQOb8zjk0
        bo5l110k8AofdKa3FMCNT/ihkrijA/H35arG2Wsq2w65Zl/ayN/SCJBnmuafeyVfi8fELtqY1+tJK
        oI2chKilv8M5yrL15f3Tx+jhzhpAYmmfsQ+sMWkFkCJgwcN0StEK6d3w1FTCVSK2O80HY7wWAk74u
        ToTdmSWrcsDJ/co4C5CZGi7d6jwWuh9GyJ5GvzYV9EShH7pOc5Cc9LJwjklGogwhjJgbG00lTyXO/
        pJMliUV0OzyK07ZQw5/f7BZ9tjxU2bp0V1Q6YUn7g9x7irn2Egkm+dxZCisZm5lXjwegPX+tHtKX4
        /s7Encrw==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pZgmM-00H2Ov-Q2
        for netfilter-devel@vger.kernel.org; Tue, 07 Mar 2023 23:31:34 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next v2 1/9] netfilter: conntrack: fix typo
Date:   Tue,  7 Mar 2023 23:30:48 +0000
Message-Id: <20230307233056.2681361-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307233056.2681361-1-jeremy@azazel.net>
References: <20230307233056.2681361-1-jeremy@azazel.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae
X-SA-Exim-Mail-From: jeremy@azazel.net
X-SA-Exim-Scanned: No (on kadath.azazel.net); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

There's a spelling mistake in a comment.  Fix it.

Signed-off-by: Jeremy Sowden <jeremy@azazel.net>
---
 net/netfilter/nf_conntrack_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
index 7250082e7de5..004c54132a3b 100644
--- a/net/netfilter/nf_conntrack_core.c
+++ b/net/netfilter/nf_conntrack_core.c
@@ -1294,7 +1294,7 @@ __nf_conntrack_confirm(struct sk_buff *skb)
 }
 EXPORT_SYMBOL_GPL(__nf_conntrack_confirm);
 
-/* Returns true if a connection correspondings to the tuple (required
+/* Returns true if a connection corresponds to the tuple (required
    for NAT). */
 int
 nf_conntrack_tuple_taken(const struct nf_conntrack_tuple *tuple,
-- 
2.39.2

