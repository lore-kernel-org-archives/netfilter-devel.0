From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 12/15] netfilter: nft_compat: prepare for indirect info storage
Date: Mon, 14 May 2018 00:36:53 +0200
Message-ID: <20180513223656.10077-13-pablo@netfilter.org>
References: <20180513223656.10077-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180513223656.10077-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Next patch will make it possible for *info to be stored in
a separate allocation instead of the expr private area.

This removes the 'expr priv area is info blob' assumption
from the match init/destroy/eval functions.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c | 47 +++++++++++++++++++++++++++++++++++-----------
 1 file changed, 36 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 870d8c29dae9..dec0afb0ffe0 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -324,11 +324,11 @@ static int nft_target_validate(const struct nft_ctx *ctx,
 	return 0;
 }
 
-static void nft_match_eval(const struct nft_expr *expr,
-			   struct nft_regs *regs,
-			   const struct nft_pktinfo *pkt)
+static void __nft_match_eval(const struct nft_expr *expr,
+			     struct nft_regs *regs,
+			     const struct nft_pktinfo *pkt,
+			     void *info)
 {
-	void *info = nft_expr_priv(expr);
 	struct xt_match *match = expr->ops->data;
 	struct sk_buff *skb = pkt->skb;
 	bool ret;
@@ -352,6 +352,13 @@ static void nft_match_eval(const struct nft_expr *expr,
 	}
 }
 
+static void nft_match_eval(const struct nft_expr *expr,
+			   struct nft_regs *regs,
+			   const struct nft_pktinfo *pkt)
+{
+	__nft_match_eval(expr, regs, pkt, nft_expr_priv(expr));
+}
+
 static const struct nla_policy nft_match_policy[NFTA_MATCH_MAX + 1] = {
 	[NFTA_MATCH_NAME]	= { .type = NLA_NUL_STRING },
 	[NFTA_MATCH_REV]	= { .type = NLA_U32 },
@@ -412,10 +419,10 @@ static void match_compat_from_user(struct xt_match *m, void *in, void *out)
 }
 
 static int
-nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
-		const struct nlattr * const tb[])
+__nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		 const struct nlattr * const tb[],
+		 void *info)
 {
-	void *info = nft_expr_priv(expr);
 	struct xt_match *match = expr->ops->data;
 	struct xt_mtchk_param par;
 	size_t size = XT_ALIGN(nla_len(tb[NFTA_MATCH_INFO]));
@@ -444,11 +451,18 @@ nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 	return 0;
 }
 
+static int
+nft_match_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
+	       const struct nlattr * const tb[])
+{
+	return __nft_match_init(ctx, expr, tb, nft_expr_priv(expr));
+}
+
 static void
-nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+__nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr,
+		    void *info)
 {
 	struct xt_match *match = expr->ops->data;
-	void *info = nft_expr_priv(expr);
 	struct xt_mtdtor_param par;
 
 	par.net = ctx->net;
@@ -462,9 +476,15 @@ nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
 		module_put(match->me);
 }
 
-static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
+static void
+nft_match_destroy(const struct nft_ctx *ctx, const struct nft_expr *expr)
+{
+	__nft_match_destroy(ctx, expr, nft_expr_priv(expr));
+}
+
+static int __nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr,
+			    void *info)
 {
-	void *info = nft_expr_priv(expr);
 	struct xt_match *match = expr->ops->data;
 
 	if (nla_put_string(skb, NFTA_MATCH_NAME, match->name) ||
@@ -478,6 +498,11 @@ static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	return -1;
 }
 
+static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
+{
+	return __nft_match_dump(skb, expr, nft_expr_priv(expr));
+}
+
 static int nft_match_validate(const struct nft_ctx *ctx,
 			      const struct nft_expr *expr,
 			      const struct nft_data **data)
-- 
2.11.0
