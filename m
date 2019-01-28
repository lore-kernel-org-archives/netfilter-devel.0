From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 03/33] netfilter: nf_tables: add direct calls for all builtin expressions
Date: Tue, 29 Jan 2019 00:57:20 +0100
Message-ID: <20190128235750.18412-4-pablo@netfilter.org>
References: <20190128235750.18412-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190128235750.18412-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

With CONFIG_RETPOLINE its faster to add an if (ptr == &foo_func)
check and and use direct calls for all the built-in expressions.

~15% improvement in pathological cases.

checkpatch doesn't like the X macro due to the embedded return statement,
but the macro has a very limited scope so I don't think its a problem.

I would like to avoid bugs of the form
  If (e->ops->eval == (unsigned long)nft_foo_eval)
	 nft_bar_eval();

and open-coded if ()/else if()/else cascade, thus the macro.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables_core.h | 16 ++++++++++++++++
 net/netfilter/nf_tables_core.c         | 25 ++++++++++++++++++-------
 net/netfilter/nft_bitwise.c            |  5 ++---
 net/netfilter/nft_byteorder.c          |  6 +++---
 net/netfilter/nft_cmp.c                |  6 +++---
 net/netfilter/nft_dynset.c             |  5 ++---
 net/netfilter/nft_immediate.c          |  6 +++---
 net/netfilter/nft_payload.c            |  6 +++---
 net/netfilter/nft_range.c              |  5 ++---
 net/netfilter/nft_rt.c                 |  6 +++---
 10 files changed, 55 insertions(+), 31 deletions(-)

diff --git a/include/net/netfilter/nf_tables_core.h b/include/net/netfilter/nf_tables_core.h
index 2046d104f323..7281895fa6d9 100644
--- a/include/net/netfilter/nf_tables_core.h
+++ b/include/net/netfilter/nf_tables_core.h
@@ -80,6 +80,22 @@ struct nft_regs;
 struct nft_pktinfo;
 void nft_meta_get_eval(const struct nft_expr *expr,
 		       struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_cmp_eval(const struct nft_expr *expr,
+		  struct nft_regs *regs, const struct nft_pktinfo *pkt);
 void nft_lookup_eval(const struct nft_expr *expr,
 		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_payload_eval(const struct nft_expr *expr,
+		      struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_immediate_eval(const struct nft_expr *expr,
+			struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_bitwise_eval(const struct nft_expr *expr,
+		      struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_range_eval(const struct nft_expr *expr,
+		    struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_byteorder_eval(const struct nft_expr *expr,
+			struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_dynset_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
+void nft_rt_get_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs, const struct nft_pktinfo *pkt);
 #endif /* _NET_NF_TABLES_CORE_H */
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index a50500232b0a..2a00aef7b6d4 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -124,14 +124,25 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
 			       struct nft_regs *regs,
 			       struct nft_pktinfo *pkt)
 {
+#ifdef CONFIG_RETPOLINE
 	unsigned long e = (unsigned long)expr->ops->eval;
-
-	if (e == (unsigned long)nft_meta_get_eval)
-		nft_meta_get_eval(expr, regs, pkt);
-	else if (e == (unsigned long)nft_lookup_eval)
-		nft_lookup_eval(expr, regs, pkt);
-	else
-		expr->ops->eval(expr, regs, pkt);
+#define X(e, fun) \
+	do { if ((e) == (unsigned long)(fun)) \
+		return fun(expr, regs, pkt); } while (0)
+
+	X(e, nft_payload_eval);
+	X(e, nft_cmp_eval);
+	X(e, nft_meta_get_eval);
+	X(e, nft_lookup_eval);
+	X(e, nft_range_eval);
+	X(e, nft_immediate_eval);
+	X(e, nft_byteorder_eval);
+	X(e, nft_dynset_eval);
+	X(e, nft_rt_get_eval);
+	X(e, nft_bitwise_eval);
+#undef  X
+#endif /* CONFIG_RETPOLINE */
+	expr->ops->eval(expr, regs, pkt);
 }
 
 unsigned int
diff --git a/net/netfilter/nft_bitwise.c b/net/netfilter/nft_bitwise.c
index fff8073e2a56..2c75b9e0474e 100644
--- a/net/netfilter/nft_bitwise.c
+++ b/net/netfilter/nft_bitwise.c
@@ -25,9 +25,8 @@ struct nft_bitwise {
 	struct nft_data		xor;
 };
 
-static void nft_bitwise_eval(const struct nft_expr *expr,
-			     struct nft_regs *regs,
-			     const struct nft_pktinfo *pkt)
+void nft_bitwise_eval(const struct nft_expr *expr,
+		      struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_bitwise *priv = nft_expr_priv(expr);
 	const u32 *src = &regs->data[priv->sreg];
diff --git a/net/netfilter/nft_byteorder.c b/net/netfilter/nft_byteorder.c
index 13d4e421a6b3..19dbc34cc75e 100644
--- a/net/netfilter/nft_byteorder.c
+++ b/net/netfilter/nft_byteorder.c
@@ -26,9 +26,9 @@ struct nft_byteorder {
 	u8			size;
 };
 
-static void nft_byteorder_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
+void nft_byteorder_eval(const struct nft_expr *expr,
+			struct nft_regs *regs,
+			const struct nft_pktinfo *pkt)
 {
 	const struct nft_byteorder *priv = nft_expr_priv(expr);
 	u32 *src = &regs->data[priv->sreg];
diff --git a/net/netfilter/nft_cmp.c b/net/netfilter/nft_cmp.c
index 79d48c1d06f4..f9f1fa66a16e 100644
--- a/net/netfilter/nft_cmp.c
+++ b/net/netfilter/nft_cmp.c
@@ -24,9 +24,9 @@ struct nft_cmp_expr {
 	enum nft_cmp_ops	op:8;
 };
 
-static void nft_cmp_eval(const struct nft_expr *expr,
-			 struct nft_regs *regs,
-			 const struct nft_pktinfo *pkt)
+void nft_cmp_eval(const struct nft_expr *expr,
+		  struct nft_regs *regs,
+		  const struct nft_pktinfo *pkt)
 {
 	const struct nft_cmp_expr *priv = nft_expr_priv(expr);
 	int d;
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 07d4efd3d851..9658493d37d4 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -62,9 +62,8 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	return NULL;
 }
 
-static void nft_dynset_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+void nft_dynset_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_dynset *priv = nft_expr_priv(expr);
 	struct nft_set *set = priv->set;
diff --git a/net/netfilter/nft_immediate.c b/net/netfilter/nft_immediate.c
index 0777a93211e2..3e5ed787b1d4 100644
--- a/net/netfilter/nft_immediate.c
+++ b/net/netfilter/nft_immediate.c
@@ -17,9 +17,9 @@
 #include <net/netfilter/nf_tables_core.h>
 #include <net/netfilter/nf_tables.h>
 
-static void nft_immediate_eval(const struct nft_expr *expr,
-			       struct nft_regs *regs,
-			       const struct nft_pktinfo *pkt)
+void nft_immediate_eval(const struct nft_expr *expr,
+			struct nft_regs *regs,
+			const struct nft_pktinfo *pkt)
 {
 	const struct nft_immediate_expr *priv = nft_expr_priv(expr);
 
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index e110b0ebbf58..54e15de4b79a 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -70,9 +70,9 @@ nft_payload_copy_vlan(u32 *d, const struct sk_buff *skb, u8 offset, u8 len)
 	return skb_copy_bits(skb, offset + mac_off, dst_u8, len) == 0;
 }
 
-static void nft_payload_eval(const struct nft_expr *expr,
-			     struct nft_regs *regs,
-			     const struct nft_pktinfo *pkt)
+void nft_payload_eval(const struct nft_expr *expr,
+		      struct nft_regs *regs,
+		      const struct nft_pktinfo *pkt)
 {
 	const struct nft_payload *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
diff --git a/net/netfilter/nft_range.c b/net/netfilter/nft_range.c
index cedb96c3619f..529ac8acb19d 100644
--- a/net/netfilter/nft_range.c
+++ b/net/netfilter/nft_range.c
@@ -23,9 +23,8 @@ struct nft_range_expr {
 	enum nft_range_ops	op:8;
 };
 
-static void nft_range_eval(const struct nft_expr *expr,
-			 struct nft_regs *regs,
-			 const struct nft_pktinfo *pkt)
+void nft_range_eval(const struct nft_expr *expr,
+		    struct nft_regs *regs, const struct nft_pktinfo *pkt)
 {
 	const struct nft_range_expr *priv = nft_expr_priv(expr);
 	int d1, d2;
diff --git a/net/netfilter/nft_rt.c b/net/netfilter/nft_rt.c
index f35fa33913ae..c48daed5c46b 100644
--- a/net/netfilter/nft_rt.c
+++ b/net/netfilter/nft_rt.c
@@ -53,9 +53,9 @@ static u16 get_tcpmss(const struct nft_pktinfo *pkt, const struct dst_entry *skb
 	return mtu - minlen;
 }
 
-static void nft_rt_get_eval(const struct nft_expr *expr,
-			    struct nft_regs *regs,
-			    const struct nft_pktinfo *pkt)
+void nft_rt_get_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs,
+		     const struct nft_pktinfo *pkt)
 {
 	const struct nft_rt *priv = nft_expr_priv(expr);
 	const struct sk_buff *skb = pkt->skb;
-- 
2.11.0
