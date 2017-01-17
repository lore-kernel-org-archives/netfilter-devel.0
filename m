From: Phil Sutter <phil@nwl.cc>
Subject: [nf-next PATCH] netfilter: nf_tables: cmp: support boolean operation
Date: Tue, 17 Jan 2017 22:50:57 +0100
Message-ID: <20170117215057.13212-1-phil@nwl.cc>
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from orbyte.nwl.cc ([151.80.46.58]:59307 "EHLO mail.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751015AbdAQVsQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 17 Jan 2017 16:48:16 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 include/uapi/linux/netfilter/nf_tables.h |  2 ++
 net/netfilter/nft_cmp.c                  | 12 +++++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index b00a05d1ee566..77e318e6ff9d2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -535,6 +535,7 @@ enum nft_byteorder_attributes {
  * @NFT_CMP_LTE: less than or equal to
  * @NFT_CMP_GT: greater than
  * @NFT_CMP_GTE: greater than or equal to
+ * @NFT_CMP_BOOL: boolean comparison
  */
 enum nft_cmp_ops {
 	NFT_CMP_EQ,
@@ -543,6 +544,7 @@ enum nft_cmp_ops {
 	NFT_CMP_LTE,
 	NFT_CMP_GT,
 	NFT_CMP_GTE,
+	NFT_CMP_BOOL,
 };
 
 /**
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 2b96effeadc1b..addf75739367e 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -29,9 +29,14 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 			 const struct nft_pktinfo *pkt)
 {
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
+	static const u32 nulldata[4] = { 0 };
+	const void *data = &priv->data;
 	int d;
 
-	d = memcmp(&regs->data[priv->sreg], &priv->data, priv->len);
+	if (priv->op == NFT_CMP_BOOL)
+		data = nulldata;
+
+	d = memcmp(&regs->data[priv->sreg], data, priv->len);
 	switch (priv->op) {
 	case NFT_CMP_EQ:
 		if (d != 0)
@@ -55,6 +60,10 @@ static void nft_cmp_eval(const struct nft_expr *expr,
 		if (d < 0)
 			goto mismatch;
 		break;
+	case NFT_CMP_BOOL:
+		if (!!priv->data.data[0] ^ !!d)
+			goto mismatch;
+		break;
 	}
 	return;
 
@@ -191,6 +200,7 @@ nft_cmp_select_ops(const struct nft_ctx *ctx, const struct nlattr * const tb[])
 	case NFT_CMP_LTE:
 	case NFT_CMP_GT:
 	case NFT_CMP_GTE:
+	case NFT_CMP_BOOL:
 		break;
 	default:
 		return ERR_PTR(-EINVAL);
-- 
2.11.0

