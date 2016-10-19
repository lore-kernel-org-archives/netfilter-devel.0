From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nft_numgen: start round robin from zero
Date: Wed, 19 Oct 2016 23:29:53 +0800
Message-ID: <1476890993-3518-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
        Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:44006 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S945125AbcJSPaf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Oct 2016 11:30:35 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Currently we start round robin from 1, but it's better to start round
robin from 0. This is to keep consistent with xt_statistic in iptables.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_numgen.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/netfilter/nft_numgen.c b/net/netfilter/nft_numgen.c
index 55bc5ab..a66b360 100644
--- a/net/netfilter/nft_numgen.c
+++ b/net/netfilter/nft_numgen.c
@@ -65,7 +65,7 @@ static int nft_ng_inc_init(const struct nft_ctx *ctx,
 		return -EOVERFLOW;
 
 	priv->dreg = nft_parse_register(tb[NFTA_NG_DREG]);
-	atomic_set(&priv->counter, 0);
+	atomic_set(&priv->counter, priv->modulus - 1);
 
 	return nft_validate_register_store(ctx, priv->dreg, NULL,
 					   NFT_DATA_VALUE, sizeof(u32));
-- 
2.5.5


