From: pablo@netfilter.org
Subject: [nftables 1/9] netfilter: nf_tables: fix compilation if CONFIG_COMPAT is disabled
Date: Thu, 31 Jan 2013 01:03:57 +0100
Message-ID: <1359590645-4703-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net, tomasz.bursztyka@linux.intel.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([209.236.71.68]:46728 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755073Ab3AaAER (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 19:04:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_compat.c |   42 ++++++++++++++++++++++++++++++++++--------
 1 file changed, 34 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 591bba0..dc156f6 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -85,17 +85,28 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 
 static void target_compat_from_user(struct xt_target *t, void *in, void *out)
 {
-	int pad;
-
+#ifdef CONFIG_COMPAT
 	if (t->compat_from_user) {
+		int pad;
+
 		t->compat_from_user(out, in);
 		pad = XT_ALIGN(t->targetsize) - t->targetsize;
 		if (pad > 0)
 			memset(out + t->targetsize, 0, pad);
 	} else
+#endif
 		memcpy(out, in, XT_ALIGN(t->targetsize));
 }
 
+static inline int nft_compat_target_offset(struct xt_target *target)
+{
+#ifdef CONFIG_COMPAT
+	return xt_compat_target_offset(target);
+#else
+	return 0;
+#endif
+}
+
 static int
 nft_target_init(const struct nft_ctx *ctx, const struct nft_expr *expr,
 		const struct nlattr * const tb[])
@@ -138,11 +149,12 @@ nft_target_destroy(const struct nft_expr *expr)
 static int
 target_dump_info(struct sk_buff *skb, const struct xt_target *t, const void *in)
 {
-	void *out;
 	int ret;
 
+#ifdef CONFIG_COMPAT
 	if (t->compat_to_user) {
 		mm_segment_t old_fs;
+		void *out;
 
 		out = kmalloc(XT_ALIGN(t->targetsize), GFP_ATOMIC);
 		if (out == NULL)
@@ -156,6 +168,7 @@ target_dump_info(struct sk_buff *skb, const struct xt_target *t, const void *in)
 		ret = nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(t->targetsize), out);
 		kfree(out);
 	} else
+#endif
 		ret = nla_put(skb, NFTA_TARGET_INFO, XT_ALIGN(t->targetsize), in);
 
 	return ret;
@@ -255,14 +268,16 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 
 static void match_compat_from_user(struct xt_match *m, void *in, void *out)
 {
-	int pad;
-
+#ifdef CONFIG_COMPAT
 	if (m->compat_from_user) {
+		int pad;
+
 		m->compat_from_user(out, in);
 		pad = XT_ALIGN(m->matchsize) - m->matchsize;
 		if (pad > 0)
 			memset(out + m->matchsize, 0, pad);
 	} else
+#endif
 		memcpy(out, in, XT_ALIGN(m->matchsize));
 }
 
@@ -302,11 +317,12 @@ nft_match_destroy(const struct nft_expr *expr)
 static int
 match_dump_info(struct sk_buff *skb, const struct xt_match *m, const void *in)
 {
-	void *out;
 	int ret;
 
+#ifdef CONFIG_COMPAT
 	if (m->compat_to_user) {
 		mm_segment_t old_fs;
+		void *out;
 
 		out = kmalloc(XT_ALIGN(m->matchsize), GFP_ATOMIC);
 		if (out == NULL)
@@ -320,11 +336,21 @@ match_dump_info(struct sk_buff *skb, const struct xt_match *m, const void *in)
 		ret = nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(m->matchsize), out);
 		kfree(out);
 	} else
+#endif
 		ret = nla_put(skb, NFTA_MATCH_INFO, XT_ALIGN(m->matchsize), in);
 
 	return ret;
 }
 
+static inline int nft_compat_match_offset(struct xt_match *match)
+{
+#ifdef CONFIG_COMPAT
+	return xt_compat_match_offset(match);
+#else
+	return 0;
+#endif
+}
+
 static int nft_match_dump(struct sk_buff *skb, const struct nft_expr *expr)
 {
 	void *info = nft_expr_priv(expr);
@@ -528,7 +554,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 
 	nft_match->ops.type = &nft_match_type;
 	nft_match->ops.size = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize) +
-					    xt_compat_match_offset(match));
+					    nft_compat_match_offset(match));
 	nft_match->ops.eval = nft_match_eval;
 	nft_match->ops.init = nft_match_init;
 	nft_match->ops.destroy = nft_match_destroy;
@@ -599,7 +625,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize) +
-					     xt_compat_target_offset(target));
+					     nft_compat_target_offset(target));
 	nft_target->ops.eval = nft_target_eval;
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
-- 
1.7.10.4

