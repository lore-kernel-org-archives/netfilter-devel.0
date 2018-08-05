From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 01/21] netfilter: nf_tables: handle meta/lookup with direct call
Date: Sun,  5 Aug 2018 23:21:21 +0200
Message-ID: <20180805212141.3033-2-pablo@netfilter.org>
References: <20180805212141.3033-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180805212141.3033-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Currently nft uses inlined variants for common operations
such as 'ip saddr 1.2.3.4' instead of an indirect call.

Also handle meta get operations and lookups without indirect call,
both are builtin.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h |  7 +++++++
 net/netfilter/nf_tables_core.c         | 16 +++++++++++++++-
 net/netfilter/nft_lookup.c             |  6 +++---
 net/netfilter/nft_meta.c               |  6 +++---
 4 files changed, 28 insertions(+), 7 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index a05134507e7b..8da837d2aaf9 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -71,4 +71,11 @@ extern struct nft_set_type nft_set_hash_fast_type;
 extern struct nft_set_type nft_set_rbtree_type;
 extern struct nft_set_type nft_set_bitmap_type;
 
+struct nft_expr;
+struct nft_regs;
+struct nft_pktinfo;
+void nft_meta_get_eval(const struct nft_expr *expr,
+		       struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_lookup_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 8de912ca53d3..ffd5c0f9412b 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -120,6 +120,20 @@ struct nft_jumpstack {
 	struct nft_rule	*const *rules;
 };
 
+static void expr_call_ops_eval(const struct nft_expr *expr,
+			       struct nft_regs *regs,
+			       struct nft_pktinfo *pkt)
+{
+	unsigned long e = (unsigned long)expr->ops->eval;
+
+	if (e == (unsigned long)nft_meta_get_eval)
+		nft_meta_get_eval(expr, regs, pkt);
+	else if (e == (unsigned long)nft_lookup_eval)
+		nft_lookup_eval(expr, regs, pkt);
+	else
+		expr->ops->eval(expr, regs, pkt);
+}
+
 unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
@@ -153,7 +167,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 				nft_cmp_fast_eval(expr, &regs);
 			else if (expr->ops != &nft_payload_fast_ops ||
 				 !nft_payload_fast_eval(expr, &regs, pkt))
-				expr->ops->eval(expr, &regs, pkt);
+				expr_call_ops_eval(expr, &regs, pkt);
 
 			if (regs.verdict.code != NFT_CONTINUE)
 				break;
diff --git a/net/netfilter/nft_lookup.c b/net/netfilter/nft_lookup.c
index c2a1d84cdfc4..ad13e8643599 100644
--- a/net/netfilter/nft_lookup.c
+++ b/net/netfilter/nft_lookup.c
@@ -26,9 +26,9 @@ struct nft_lookup {
 	struct nft_set_binding		binding;
 };
 
-static void nft_lookup_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+void nft_lookup_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs,
+		     const struct nft_pktinfo *pkt)
 {
 	const struct nft_lookup *priv = nft_expr_priv(expr);
 	const struct nft_set *set = priv->set;
diff --git a/net/netfilter/nft_meta.c b/net/netfilter/nft_meta.c
index 2b94dcc43456..297fe7d97c18 100644
--- a/net/netfilter/nft_meta.c
+++ b/net/netfilter/nft_meta.c
@@ -41,9 +41,9 @@ static DEFINE_PER_CPU(struct rnd_state, nft_prandom_state);
 #include "../bridge/br_private.h"
 #endif
 
-static void nft_meta_get_eval(const struct nft_expr *expr,
-			      struct nft_regs *regs,
-			      const struct nft_pktinfo *pkt)
+void nft_meta_get_eval(const struct nft_expr *expr,
+		       struct nft_regs *regs,
+		       const struct nft_pktinfo *pkt)
 {
 	const struct nft_meta *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-- 
2.11.0
