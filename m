From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next PATCH v2] netfilter: nft_compat: add ebtables support
Date: Thu, 29 Jan 2015 19:34:42 +0100
Message-ID: <20150129183432.12221.94390.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp3.cica.es ([150.214.5.190]:46343 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752129AbbA2Seq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 13:34:46 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch extends nft_compat to support ebtables extensions.

ebtables verdict codes are translated to the ones used by the nf_tables engine,
so we can properly use ebtables target extensions from nft_compat.

This patch extends previous work by Giuseppe Longo <giuseppelng@gmail.com>.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
v2: this patch merges these two:
 * http://patchwork.ozlabs.org/patch/432853/ (by Giuseppe Longo)
 * http://patchwork.ozlabs.org/patch/434602/ (by myself)

Plus addressing comments by Pablo regarding code factorization.

 net/netfilter/nft_compat.c |   64 +++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 59 insertions(+), 5 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 265e190..73ec6ef 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -19,6 +19,7 @@
 #include <linux/netfilter/x_tables.h>
 #include <linux/netfilter_ipv4/ip_tables.h>
 #include <linux/netfilter_ipv6/ip6_tables.h>
+#include <linux/netfilter_bridge/ebtables.h>
 #include <net/netfilter/nf_tables.h>
 
 static int nft_compat_chain_validate_dependency(const char *tablename,
@@ -40,6 +41,7 @@ static int nft_compat_chain_validate_dependency(const char *tablename,
 union nft_entry {
 	struct ipt_entry e4;
 	struct ip6t_entry e6;
+	struct ebt_entry ebt;
 };
 
 static inline void
@@ -50,9 +52,9 @@ nft_compat_set_par(struct xt_action_param *par, void *xt, const void *xt_info)
 	par->hotdrop	= false;
 }
 
-static void nft_target_eval(const struct nft_expr *expr,
-			    struct nft_data data[NFT_REG_MAX + 1],
-			    const struct nft_pktinfo *pkt)
+static void nft_target_eval_xt(const struct nft_expr *expr,
+			       struct nft_data data[NFT_REG_MAX + 1],
+			       const struct nft_pktinfo *pkt)
 {
 	void *info = nft_expr_priv(expr);
 	struct xt_target *target = expr->ops->data;
@@ -66,7 +68,7 @@ static void nft_target_eval(const struct nft_expr *expr,
 	if (pkt->xt.hotdrop)
 		ret = NF_DROP;
 
-	switch(ret) {
+	switch (ret) {
 	case XT_CONTINUE:
 		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 		break;
@@ -74,6 +76,44 @@ static void nft_target_eval(const struct nft_expr *expr,
 		data[NFT_REG_VERDICT].verdict = ret;
 		break;
 	}
+
+	return;
+}
+
+static void nft_target_eval_bridge(const struct nft_expr *expr,
+				   struct nft_data data[NFT_REG_MAX + 1],
+				   const struct nft_pktinfo *pkt)
+{
+	void *info = nft_expr_priv(expr);
+	struct xt_target *target = expr->ops->data;
+	struct sk_buff *skb = pkt->skb;
+	int ret;
+
+	nft_compat_set_par((struct xt_action_param *)&pkt->xt, target, info);
+
+	ret = target->target(skb, &pkt->xt);
+
+	if (pkt->xt.hotdrop)
+		ret = NF_DROP;
+
+	switch (ret) {
+	case EBT_ACCEPT:
+		data[NFT_REG_VERDICT].verdict = NF_ACCEPT;
+		break;
+	case EBT_DROP:
+		data[NFT_REG_VERDICT].verdict = NF_DROP;
+		break;
+	case EBT_CONTINUE:
+		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
+		break;
+	case EBT_RETURN:
+		data[NFT_REG_VERDICT].verdict = NFT_RETURN;
+		break;
+	default:
+		data[NFT_REG_VERDICT].verdict = ret;
+		break;
+	}
+
 	return;
 }
 
@@ -100,6 +140,10 @@ nft_target_set_tgchk_param(struct xt_tgchk_param *par,
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
+	case NFPROTO_BRIDGE:
+		entry->ebt.ethproto = proto;
+		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
+		break;
 	}
 	par->entryinfo	= entry;
 	par->target	= target;
@@ -307,6 +351,9 @@ nft_match_set_mtchk_param(struct xt_mtchk_param *par, const struct nft_ctx *ctx,
 		entry->e6.ipv6.proto = proto;
 		entry->e6.ipv6.invflags = inv ? IP6T_INV_PROTO : 0;
 		break;
+	case NFPROTO_BRIDGE:
+		entry->ebt.ethproto = proto;
+		entry->ebt.invflags = inv ? EBT_IPROTO : 0;
 	}
 	par->entryinfo	= entry;
 	par->match	= match;
@@ -490,6 +537,9 @@ nfnl_compat_get(struct sock *nfnl, struct sk_buff *skb,
 	case AF_INET6:
 		fmt = "ip6t_%s";
 		break;
+	case NFPROTO_BRIDGE:
+		fmt = "ebt_%s";
+		break;
 	default:
 		pr_err("nft_compat: unsupported protocol %d\n",
 			nfmsg->nfgen_family);
@@ -663,13 +713,17 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
-	nft_target->ops.eval = nft_target_eval;
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
 	nft_target->ops.data = target;
 
+	if (family == NFPROTO_BRIDGE)
+		nft_target->ops.eval = nft_target_eval_bridge;
+	else
+		nft_target->ops.eval = nft_target_eval_xt;
+
 	list_add(&nft_target->head, &nft_target_list);
 
 	return &nft_target->ops;

