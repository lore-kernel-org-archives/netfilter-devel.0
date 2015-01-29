From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nf-next PATCH] netfilter: nft_compat: translate ebtables verdicts
Date: Thu, 29 Jan 2015 17:45:59 +0100
Message-ID: <20150129164559.23327.66398.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp4.cica.es ([150.214.5.182]:35387 "EHLO smtp.cica.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753079AbbA2QqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Jan 2015 11:46:09 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Translate ebtables verdict to the ones used by the nf_tables engine,
so we can properly use ebtables target extensions from nft_compat.

Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
---
 net/netfilter/nft_compat.c |   67 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 7f90d06..8ac7238 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -52,9 +52,8 @@ nft_compat_set_par(struct xt_action_param *par, void *xt, const void *xt_info)
 	par->hotdrop	= false;
 }
 
-static void nft_target_eval(const struct nft_expr *expr,
-			    struct nft_data data[NFT_REG_MAX + 1],
-			    const struct nft_pktinfo *pkt)
+static int nft_target_eval_call(const struct nft_expr *expr,
+				const struct nft_pktinfo *pkt)
 {
 	void *info = nft_expr_priv(expr);
 	struct xt_target *target = expr->ops->data;
@@ -68,14 +67,66 @@ static void nft_target_eval(const struct nft_expr *expr,
 	if (pkt->xt.hotdrop)
 		ret = NF_DROP;
 
-	switch(ret) {
+	return ret;
+}
+
+static void nft_target_eval_set_verdict(struct nft_data data[NFT_REG_MAX + 1],
+					int verdict)
+{
+	switch (verdict) {
 	case XT_CONTINUE:
 		data[NFT_REG_VERDICT].verdict = NFT_CONTINUE;
 		break;
 	default:
-		data[NFT_REG_VERDICT].verdict = ret;
+		data[NFT_REG_VERDICT].verdict = verdict;
 		break;
 	}
+}
+
+static void nft_target_eval(const struct nft_expr *expr,
+			    struct nft_data data[NFT_REG_MAX + 1],
+			    const struct nft_pktinfo *pkt)
+{
+	int verdict;
+
+	verdict = nft_target_eval_call(expr, pkt);
+	nft_target_eval_set_verdict(data, verdict);
+
+	return;
+}
+
+static void nft_compat_translate_ebt_verdict(int *verdict)
+{
+	switch (*verdict) {
+	case EBT_ACCEPT:
+		*verdict = NF_ACCEPT;
+		break;
+	case EBT_DROP:
+		*verdict = NF_DROP;
+		break;
+	case EBT_CONTINUE:
+		*verdict = XT_CONTINUE;
+		break;
+	case EBT_RETURN:
+		*verdict = NFT_RETURN;
+		break;
+	default:
+		break;
+	}
+
+	return;
+}
+
+static void nft_target_bridge_eval(const struct nft_expr *expr,
+				   struct nft_data data[NFT_REG_MAX + 1],
+				   const struct nft_pktinfo *pkt)
+{
+	int verdict;
+
+	verdict = nft_target_eval_call(expr, pkt);
+	nft_compat_translate_ebt_verdict(&verdict);
+	nft_target_eval_set_verdict(data, verdict);
+
 	return;
 }
 
@@ -696,13 +747,17 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
-	nft_target->ops.eval = nft_target_eval;
 	nft_target->ops.init = nft_target_init;
 	nft_target->ops.destroy = nft_target_destroy;
 	nft_target->ops.dump = nft_target_dump;
 	nft_target->ops.validate = nft_target_validate;
 	nft_target->ops.data = target;
 
+	if (family == NFPROTO_BRIDGE)
+		nft_target->ops.eval = nft_target_bridge_eval;
+	else
+		nft_target->ops.eval = nft_target_eval;
+
 	list_add(&nft_target->head, &nft_target_list);
 
 	return &nft_target->ops;

