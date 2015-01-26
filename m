From: Ana Rey Botello <ana@soleta.eu>
Subject: [nf v2 1/2] netfilter: Rename from nft_counter to nft_counter_priv
Date: Mon, 26 Jan 2015 20:43:27 +0100
Message-ID: <d08072bc36d394c2b482b06dd0d5cbbeabe85825.1422299628.git.ana@soleta.eu>
References: <cover.1422299627.git.ana@soleta.eu>
Cc: Ana Rey Botello <ana@soleta.eu>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 129.166.216.87.static.jazztel.es ([87.216.166.129]:47437 "EHLO
	correo.soleta.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754054AbbAZTmz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Jan 2015 14:42:55 -0500
In-Reply-To: <cover.1422299627.git.ana@soleta.eu>
In-Reply-To: <cover.1422299627.git.ana@soleta.eu>
References: <cover.1422299627.git.ana@soleta.eu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We need this change for the patch:
"netfilter: named counter: add support to accounters in  nftables"

Signed-off-by: Ana Rey Botello <ana@soleta.eu>
---
 net/netfilter/nft_counter.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index c89ee48..8815312 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -17,7 +17,7 @@
 #include <linux/netfilter/nf_tables.h>
 #include <net/netfilter/nf_tables.h>
 
-struct nft_counter {
+struct nft_counter_priv {
 	seqlock_t	lock;
 	u64		bytes;
 	u64		packets;
@@ -27,7 +27,7 @@ static void nft_counter_eval(const struct nft_expr *expr,
 			     struct nft_data data[NFT_REG_MAX + 1],
 			     const struct nft_pktinfo *pkt)
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 
 	write_seqlock_bh(&priv->lock);
 	priv->bytes += pkt->skb->len;
@@ -37,7 +37,7 @@ static void nft_counter_eval(const struct nft_expr *expr,
 
 static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 	unsigned int seq;
 	u64 bytes;
 	u64 packets;
@@ -67,7 +67,7 @@ static int nft_counter_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 
 	if (tb[NFTA_COUNTER_PACKETS])
 	        priv->packets = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
@@ -81,7 +81,7 @@ static int nft_counter_init(const struct nft_ctx *ctx,
 static struct nft_expr_type nft_counter_type;
 static const struct nft_expr_ops nft_counter_ops = {
 	.type		= &nft_counter_type,
-	.size		= NFT_EXPR_SIZE(sizeof(struct nft_counter)),
+	.size		= NFT_EXPR_SIZE(sizeof(struct nft_counter_priv)),
 	.eval		= nft_counter_eval,
 	.init		= nft_counter_init,
 	.dump		= nft_counter_dump,
-- 
1.7.10.4

