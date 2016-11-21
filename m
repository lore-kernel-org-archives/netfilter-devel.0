From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf] netfilter: nft_range: add the missing NULL pointer check
Date: Mon, 21 Nov 2016 21:18:23 +0800
Message-ID: <1479734303-20832-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:48100 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753975AbcKUNT3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2016 08:19:29 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

Otherwise, kernel panic will happen if the user does not specify
the related attributes.

Fixes: 0f3cd9b36977 ("netfilter: nf_tables: add range expression")
Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_range.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index fbc8800..8f0aaae 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -59,6 +59,12 @@ static int nft_range_init(const struct nft_ctx *ctx, const struct nft_expr *expr
 	int err;
 	u32 op;
 
+	if (!tb[NFTA_RANGE_SREG]      ||
+	    !tb[NFTA_RANGE_OP]	      ||
+	    !tb[NFTA_RANGE_FROM_DATA] ||
+	    !tb[NFTA_RANGE_TO_DATA])
+		return -EINVAL;
+
 	err = nft_data_init(NULL, &priv->data_from, sizeof(priv->data_from),
 			    &desc_from, tb[NFTA_RANGE_FROM_DATA]);
 	if (err < 0)
-- 
2.5.5


