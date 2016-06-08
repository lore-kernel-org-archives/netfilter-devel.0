From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 2/4] netfilter: nft_log: no need to deal with NFPROTO_INET family
Date: Wed,  8 Jun 2016 20:43:18 +0800
Message-ID: <1465389800-27842-3-git-send-email-zlpnobody@163.com>
References: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-15.163.com ([220.181.12.15]:33373 "EHLO m12-15.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422659AbcFHMoO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2016 08:44:14 -0400
In-Reply-To: <1465389800-27842-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Since nf_logger_find_get and nf_logger_put can handle NFPROTO_INET
properly, we can remove the special process logic now.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_log.c | 21 +--------------------
 1 file changed, 1 insertion(+), 20 deletions(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 319c22b..713d668 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -52,7 +52,6 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	struct nft_log *priv = nft_expr_priv(expr);
 	struct nf_loginfo *li = &priv->loginfo;
 	const struct nlattr *nla;
-	int ret;
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
@@ -97,19 +96,6 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		break;
 	}
 
-	if (ctx->afi->family == NFPROTO_INET) {
-		ret = nf_logger_find_get(NFPROTO_IPV4, li->type);
-		if (ret < 0)
-			return ret;
-
-		ret = nf_logger_find_get(NFPROTO_IPV6, li->type);
-		if (ret < 0) {
-			nf_logger_put(NFPROTO_IPV4, li->type);
-			return ret;
-		}
-		return 0;
-	}
-
 	return nf_logger_find_get(ctx->afi->family, li->type);
 }
 
@@ -122,12 +108,7 @@ static void nft_log_destroy(const struct nft_ctx *ctx,
 	if (priv->prefix != nft_log_null_prefix)
 		kfree(priv->prefix);
 
-	if (ctx->afi->family == NFPROTO_INET) {
-		nf_logger_put(NFPROTO_IPV4, li->type);
-		nf_logger_put(NFPROTO_IPV6, li->type);
-	} else {
-		nf_logger_put(ctx->afi->family, li->type);
-	}
+	nf_logger_put(ctx->afi->family, li->type);
 }
 
 static int nft_log_dump(struct sk_buff *skb, const struct nft_expr *expr)
-- 
2.5.5


