Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1C23FC678DB
	for <netfilter-devel@archiver.kernel.org>; Sun,  5 Mar 2023 12:34:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229609AbjCEMeQ (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 5 Mar 2023 07:34:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjCEMeP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 5 Mar 2023 07:34:15 -0500
Received: from kadath.azazel.net (unknown [IPv6:2001:8b0:135f:bcd1:e0cb:4eff:fedf:e608])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F9E9EB74
        for <netfilter-devel@vger.kernel.org>; Sun,  5 Mar 2023 04:34:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=azazel.net;
        s=20220717; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:To:From:Sender:Reply-To:Cc:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qlxpCSoK+NhgMUfeaKi8he8/WKGyekBfAjCcxpgsWb4=; b=myTA+t7HM9bnkJxNRutu7sWAPx
        6Ssh+UtqPzfbLGDnZ3jpUNR8/ml6mOFJLTBC+DvrcDNyBfbmpUwJOeRRORJpIsUS/xeWK+ocXxJ+P
        RoVjYTWBBnw0tv43jLMyRKniKiRk8PmADKxOc2fIBfQjRbhOzVVjSEqa2QVR7uJQxx32GmFNriBah
        V3iSG0huYww5XcHYiHcy+Ka8sD7rCirffU4KqJFFUUYsgSNDUJ+VBktfVvG9fDS5QuTnFX8bzQWnV
        SlkNJBguiorBgLxMw2dPb9TOh/mzdhkePftBFKtZa8+RWsISXAs2EX71TsgLjtF/E1bgfR5CPeK+D
        8KlUDTuA==;
Received: from ulthar.dreamlands.azazel.net ([2001:8b0:fb7d:d6d7:2e4d:54ff:fe4b:a9ae])
        by kadath.azazel.net with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <jeremy@azazel.net>)
        id 1pYnZ6-00E3og-Db
        for netfilter-devel@vger.kernel.org; Sun, 05 Mar 2023 12:34:12 +0000
From:   Jeremy Sowden <jeremy@azazel.net>
To:     Netfilter Devel <netfilter-devel@vger.kernel.org>
Subject: [PATCH nf-next 01/13] netfilter: conntrack: fix typo
Date:   Sun,  5 Mar 2023 12:18:05 +0000
Message-Id: <20230305121817.2234734-2-jeremy@azazel.net>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230305121817.2234734-1-jeremy@azazel.net>
References: <20230305121817.2234734-1-jeremy@azazel.net>
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

