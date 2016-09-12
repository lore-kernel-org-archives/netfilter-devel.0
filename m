From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_numgen: fix race between num generate and store it
Date: Mon, 12 Sep 2016 22:21:36 +0800
Message-ID: <1473690096-18509-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-12.163.com ([220.181.12.12]:33243 "EHLO m12-12.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755984AbcILOWW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Sep 2016 10:22:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

After we generate a new number, we still use the priv->counter and
store it to the dreg. This is not correct, another cpu may already
change it to a new number. So we must use the generated number, not
the priv->counter itself.

Fixes: 91dbc6be0a62 ("netfilter: nf_tables: add number generator expression")
Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_numgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index f51a3ed..f173ebe 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -37,7 +37,7 @@ static void nft_ng_inc_eval(const struct nft_expr *expr,
 		nval = (oval + 1 < priv->modulus) ? oval + 1 : 0;
 	} while (atomic_cmpxchg(&priv->counter, oval, nval) != oval);
 
-	memcpy(&regs->data[priv->dreg], &priv->counter, sizeof(u32));
+	regs->data[priv->dreg] = nval;
 }
 
 static const struct nla_policy nft_ng_policy[NFTA_NG_MAX + 1] = {
-- 
2.5.5


