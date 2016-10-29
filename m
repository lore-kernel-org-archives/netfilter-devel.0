From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next] netfilter: nf_tables: remove useless U8_MAX validation
Date: Sat, 29 Oct 2016 21:56:27 +0800
Message-ID: <1477749387-13304-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org, Liping Zhang <zlpnobody@gmail.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-16.163.com ([220.181.12.16]:47417 "EHLO m12-16.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S933422AbcJ2N6W (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 29 Oct 2016 09:58:22 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <zlpnobody@gmail.com>

After call nft_data_init, size is already validated and desc.len will
not exceed the sizeof(struct nft_data), i.e. 16 bytes. So it will never
exceed U8_MAX.

Furthermore, in nft_immediate_init, we forget to call nft_data_uninit
when desc.len exceeds U8_MAX, although this will not happen, but it's
a logical mistake.

Now remove these redundant validation introduced by commit 36b701fae12a
("netfilter: nf_tables: validate maximum value of u32 netlink attributes")

Signed-off-by: Liping Zhang <zlpnobody@gmail.com>
---
 net/netfilter/nft_cmp.c       | 3 ---
 net/netfilter/nft_immediate.c | 3 ---
 2 files changed, 6 deletions(-)

diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 2e53739..e25b35d 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -84,9 +84,6 @@ static int nft_cmp_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	if (err < 0)
 		return err;
 
-	if (desc.len > U8_MAX)
-		return -ERANGE;
-
 	priv->op  = ntohl(nla_get_be32(tb[NFTA_CMP_OP]));
 	priv->len = desc.len;
 	return 0;
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index d17018f..4528ade 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -54,9 +54,6 @@ static int nft_immediate_init(const struct nft_ctx *ctx,
 	if (err < 0)
 		return err;
 
-	if (desc.len > U8_MAX)
-		return -ERANGE;
-
 	priv->dlen = desc.len;
 
 	priv->dreg = nft_parse_register(tb[NFTA_IMMEDIATE_DREG]);
-- 
2.5.5


