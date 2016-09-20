From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next] netfilter: nft_lookup: remove superfluous element found check
Date: Tue, 20 Sep 2016 18:22:46 +0200
Message-ID: <1474388566-12236-1-git-send-email-pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56296 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755281AbcITQWz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 20 Sep 2016 12:22:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 895173066B0
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 18:22:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 77C67DA853
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 18:22:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CCBBFDA7FA
        for <netfilter-devel@vger.kernel.org>; Tue, 20 Sep 2016 18:22:50 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We already checked for !found just a bit before:

        if (!found) {
                regs->verdict.code = NFT_BREAK;
                return;
        }

        if (found && set->flags & NFT_SET_MAP)
            ^^^^^

So this redundant check can just go away.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_lookup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index e164325..8166b69 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -43,7 +43,7 @@ static void nft_lookup_eval(const struct nft_expr *expr,
 		return;
 	}
 
-	if (found && set->flags & NFT_SET_MAP)
+	if (set->flags & NFT_SET_MAP)
 		nft_data_copy(&regs->data[priv->dreg],
 			      nft_set_ext_data(ext), set->dlen);
 
-- 
2.1.4

