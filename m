From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: improve nft payload fast eval
Date: Thu, 15 Sep 2016 21:29:08 +0800
Message-ID: <1473946148-3730-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:40414 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752214AbcION3i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 15 Sep 2016 09:29:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

There's an off-by-one issue in nft_payload_fast_eval, skb_tail_pointer
and ptr + priv->len all point to the last valid address plus 1. So if
they are equal, we can still fetch the valid data. It's unnecessary to
fall back to nft_payload_eval.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nf_tables_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index fb8b589..36ba4e5 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -98,7 +98,7 @@ static bool nft_payload_fast_eval(const struct nft_expr *expr,
 
 	ptr += priv->offset;
 
-	if (unlikely(ptr + priv->len >= skb_tail_pointer(skb)))
+	if (unlikely(ptr + priv->len > skb_tail_pointer(skb)))
 		return false;
 
 	*dest = 0;
-- 
2.5.5


