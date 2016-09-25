From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 08/53] netfilter: nft_quota: fix overquota logic
Date: Mon, 26 Sep 2016 01:06:18 +0200
Message-ID: <1474844823-2026-9-git-send-email-pablo@netfilter.org>
References: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54542 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S941190AbcIYXH1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 19:07:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D5D01C0B3B
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C4C85DA84B
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3924DA7FA
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2016 01:07:24 +0200 (CEST)
In-Reply-To: <1474844823-2026-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Use xor to decide to break further rule evaluation or not, since the
existing logic doesn't achieve the expected inversion.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_quota.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_quota.c b/net/netfilter/nft_quota.c
index 6eafbf987ed9..92b6ff16dbb3 100644
--- a/net/netfilter/nft_quota.c
+++ b/net/netfilter/nft_quota.c
@@ -33,7 +33,7 @@ static void nft_quota_eval(const struct nft_expr *expr,
 {
 	struct nft_quota *priv = nft_expr_priv(expr);
 
-	if (nft_quota(priv, pkt) < 0 && !priv->invert)
+	if ((nft_quota(priv, pkt) < 0) ^ priv->invert)
 		regs->verdict.code = NFT_BREAK;
 }
 
-- 
2.1.4

