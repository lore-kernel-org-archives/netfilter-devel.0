From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 8/9] netfilter: nft_log: request explicit logger when loading rules
Date: Wed, 25 Jun 2014 14:32:42 +0200
Message-ID: <1403699563-3604-9-git-send-email-pablo@netfilter.org>
References: <1403699563-3604-1-git-send-email-pablo@netfilter.org>
Cc: kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46735 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756821AbaFYMc6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:32:58 -0400
In-Reply-To: <1403699563-3604-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This includes the special handling for NFPROTO_INET. There is
no real inet logger since we don't see packets of this family.
However, rules are loaded using this special family type. So
let's just request both IPV4 and IPV6 loggers.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nft_log.c |   24 +++++++++++++++++++++++-
 1 file changed, 23 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 10cfb15..55d4297 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -50,6 +50,7 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	struct nft_log *priv = nft_expr_priv(expr);
 	struct nf_loginfo *li = &priv->loginfo;
 	const struct nlattr *nla;
+	int ret;
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
@@ -71,16 +72,37 @@ static int nft_log_init(const struct nft_ctx *ctx,
 			ntohs(nla_get_be16(tb[NFTA_LOG_QTHRESHOLD]));
 	}
 
-	return 0;
+	if (ctx->afi->family == NFPROTO_INET) {
+		ret = nf_logger_find_get(NFPROTO_IPV4, li->type);
+		if (ret < 0)
+			return ret;
+
+		ret = nf_logger_find_get(NFPROTO_IPV6, li->type);
+		if (ret < 0) {
+			nf_logger_put(NFPROTO_IPV4, li->type);
+			return ret;
+		}
+		return 0;
+	}
+
+	return nf_logger_find_get(ctx->afi->family, li->type);
 }
 
 static void nft_log_destroy(const struct nft_ctx *ctx,
 			    const struct nft_expr *expr)
 {
 	struct nft_log *priv = nft_expr_priv(expr);
+	struct nf_loginfo *li = &priv->loginfo;
 
 	if (priv->prefix != nft_log_null_prefix)
 		kfree(priv->prefix);
+
+	if (ctx->afi->family == NFPROTO_INET) {
+		nf_logger_put(NFPROTO_IPV4, li->type);
+		nf_logger_put(NFPROTO_IPV6, li->type);
+	} else {
+		nf_logger_put(ctx->afi->family, li->type);
+	}
 }
 
 static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
1.7.10.4

