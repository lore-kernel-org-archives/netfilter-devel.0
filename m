From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 4/9] netfilter: nft_limit: fix packet ratelimiting
Date: Tue, 29 May 2018 01:42:16 +0200
Message-ID: <20180528234221.31254-5-pablo@netfilter.org>
References: <20180528234221.31254-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180528234221.31254-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Credit calculations for the packet ratelimiting are not correct, as per
the applied ratelimit of 25/second and burst 8, a total of 33 packets
should have been accepted.  This is true in iptables(33) but not in
nftables (~65). For packet ratelimiting, use:

	div_u64(limit->nsecs, limit->rate) * limit->burst;

to calculate credit, just like in iptables' xt_limit does.

Moreover, use default burst in iptables, users are expecting similar
behaviour.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_limit.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/nft_limit.c b/net/netfilter/nft_limit.c
index a9fc298ef4c3..72f13a1144dd 100644
--- a/net/netfilter/nft_limit.c
+++ b/net/netfilter/nft_limit.c
@@ -51,10 +51,13 @@ static inline bool nft_limit_eval(struct nft_limit *limit, u64 cost)
 	return !limit->invert;
 }
 
+/* Use same default as in iptables. */
+#define NFT_LIMIT_PKT_BURST_DEFAULT	5
+
 static int nft_limit_init(struct nft_limit *limit,
-			  const struct nlattr * const tb[])
+			  const struct nlattr * const tb[], bool pkts)
 {
-	u64 unit;
+	u64 unit, tokens;
 
 	if (tb[NFTA_LIMIT_RATE] == NULL ||
 	    tb[NFTA_LIMIT_UNIT] == NULL)
@@ -68,18 +71,25 @@ static int nft_limit_init(struct nft_limit *limit,
 
 	if (tb[NFTA_LIMIT_BURST])
 		limit->burst = ntohl(nla_get_be32(tb[NFTA_LIMIT_BURST]));
-	else
-		limit->burst = 0;
+
+	if (pkts && limit->burst == 0)
+		limit->burst = NFT_LIMIT_PKT_BURST_DEFAULT;
 
 	if (limit->rate + limit->burst < limit->rate)
 		return -EOVERFLOW;
 
-	/* The token bucket size limits the number of tokens can be
-	 * accumulated. tokens_max specifies the bucket size.
-	 * tokens_max = unit * (rate + burst) / rate.
-	 */
-	limit->tokens = div_u64(limit->nsecs * (limit->rate + limit->burst),
-				limit->rate);
+	if (pkts) {
+		tokens = div_u64(limit->nsecs, limit->rate) * limit->burst;
+	} else {
+		/* The token bucket size limits the number of tokens can be
+		 * accumulated. tokens_max specifies the bucket size.
+		 * tokens_max = unit * (rate + burst) / rate.
+		 */
+		tokens = div_u64(limit->nsecs * (limit->rate + limit->burst),
+				 limit->rate);
+	}
+
+	limit->tokens = tokens;
 	limit->tokens_max = limit->tokens;
 
 	if (tb[NFTA_LIMIT_FLAGS]) {
@@ -144,7 +154,7 @@ static int nft_limit_pkts_init(const struct nft_ctx *ctx,
 	struct nft_limit_pkts *priv = nft_expr_priv(expr);
 	int err;
 
-	err = nft_limit_init(&priv->limit, tb);
+	err = nft_limit_init(&priv->limit, tb, true);
 	if (err < 0)
 		return err;
 
@@ -185,7 +195,7 @@ static int nft_limit_bytes_init(const struct nft_ctx *ctx,
 {
 	struct nft_limit *priv = nft_expr_priv(expr);
 
-	return nft_limit_init(priv, tb);
+	return nft_limit_init(priv, tb, false);
 }
 
 static int nft_limit_bytes_dump(struct sk_buff *skb,
@@ -246,7 +256,7 @@ static int nft_limit_obj_pkts_init(const struct nft_ctx *ctx,
 	struct nft_limit_pkts *priv = nft_obj_data(obj);
 	int err;
 
-	err = nft_limit_init(&priv->limit, tb);
+	err = nft_limit_init(&priv->limit, tb, true);
 	if (err < 0)
 		return err;
 
@@ -289,7 +299,7 @@ static int nft_limit_obj_bytes_init(const struct nft_ctx *ctx,
 {
 	struct nft_limit *priv = nft_obj_data(obj);
 
-	return nft_limit_init(priv, tb);
+	return nft_limit_init(priv, tb, false);
 }
 
 static int nft_limit_obj_bytes_dump(struct sk_buff *skb,
-- 
2.11.0
