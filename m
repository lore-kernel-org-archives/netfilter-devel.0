From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next 1/2] netfilter: nft_counter: split out counters from nft_counter
Date: Thu, 18 Jun 2015 20:21:36 +0200
Message-ID: <1434651697-9905-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, fw@strlen.de, eric.dumazet@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932091AbbFRSQX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Jun 2015 14:16:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch comes in preparation to the percpu support, so struct nft_counter
only contains the byte and packet counter fields that can be reused.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_counter.c |   32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/net/netfilter/nft_counter.c b/net/netfilter/nft_counter.c
index 1759123..ad78fda 100644
--- a/net/netfilter/nft_counter.c
+++ b/net/netfilter/nft_counter.c
@@ -18,34 +18,38 @@
 #include <net/netfilter/nf_tables.h>
 
 struct nft_counter {
-	seqlock_t	lock;
-	u64		bytes;
-	u64		packets;
+	u64			bytes;
+	u64			packets;
+};
+
+struct nft_counter_priv {
+	seqlock_t		lock;
+	struct nft_counter	counter;
 };
 
 static void nft_counter_eval(const struct nft_expr *expr,
 			     struct nft_regs *regs,
 			     const struct nft_pktinfo *pkt)
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 
 	write_seqlock_bh(&priv->lock);
-	priv->bytes += pkt->skb->len;
-	priv->packets++;
+	priv->counter.bytes += pkt->skb->len;
+	priv->counter.packets++;
 	write_sequnlock_bh(&priv->lock);
 }
 
 static int nft_counter_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 	unsigned int seq;
 	u64 bytes;
 	u64 packets;
 
 	do {
 		seq = read_seqbegin(&priv->lock);
-		bytes	= priv->bytes;
-		packets	= priv->packets;
+		bytes	= priv->counter.bytes;
+		packets	= priv->counter.packets;
 	} while (read_seqretry(&priv->lock, seq));
 
 	if (nla_put_be64(skb, NFTA_COUNTER_BYTES, cpu_to_be64(bytes)))
@@ -67,12 +71,14 @@ static int nft_counter_init(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr,
 			    const struct nlattr * const tb[])
 {
-	struct nft_counter *priv = nft_expr_priv(expr);
+	struct nft_counter_priv *priv = nft_expr_priv(expr);
 
 	if (tb[NFTA_COUNTER_PACKETS])
-	        priv->packets = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
+	        priv->counter.packets =
+			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_PACKETS]));
 	if (tb[NFTA_COUNTER_BYTES])
-		priv->bytes = be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
+		priv->counter.bytes =
+			be64_to_cpu(nla_get_be64(tb[NFTA_COUNTER_BYTES]));
 
 	seqlock_init(&priv->lock);
 	return 0;
@@ -81,7 +87,7 @@ static int nft_counter_init(const struct nft_ctx *ctx,
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

