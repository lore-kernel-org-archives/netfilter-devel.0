From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/3] netfilter: nft_log: fix possible memory leak if log expr init fail
Date: Mon, 18 Jul 2016 20:44:15 +0800
Message-ID: <1468845857-30291-2-git-send-email-zlpnobody@163.com>
References: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-11.163.com ([220.181.12.11]:53894 "EHLO m12-11.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752125AbcGRMpD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jul 2016 08:45:03 -0400
In-Reply-To: <1468845857-30291-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

Suppose that we specify the NFTA_LOG_PREFIX, then NFTA_LOG_LEVEL
and NFTA_LOG_GROUP are specified together or nf_logger_find_get
call returns fail, i.e. expr init fail, memory leak will happen.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_log.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_log.c b/net/netfilter/nft_log.c
index 713d668..e1b34ff 100644
--- a/net/netfilter/nft_log.c
+++ b/net/netfilter/nft_log.c
@@ -52,6 +52,14 @@ static int nft_log_init(const struct nft_ctx *ctx,
 	struct nft_log *priv = nft_expr_priv(expr);
 	struct nf_loginfo *li = &priv->loginfo;
 	const struct nlattr *nla;
+	int err;
+
+	li->type = NF_LOG_TYPE_LOG;
+	if (tb[NFTA_LOG_LEVEL] != NULL &&
+	    tb[NFTA_LOG_GROUP] != NULL)
+		return -EINVAL;
+	if (tb[NFTA_LOG_GROUP] != NULL)
+		li->type = NF_LOG_TYPE_ULOG;
 
 	nla = tb[NFTA_LOG_PREFIX];
 	if (nla != NULL) {
@@ -63,13 +71,6 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		priv->prefix = (char *)nft_log_null_prefix;
 	}
 
-	li->type = NF_LOG_TYPE_LOG;
-	if (tb[NFTA_LOG_LEVEL] != NULL &&
-	    tb[NFTA_LOG_GROUP] != NULL)
-		return -EINVAL;
-	if (tb[NFTA_LOG_GROUP] != NULL)
-		li->type = NF_LOG_TYPE_ULOG;
-
 	switch (li->type) {
 	case NF_LOG_TYPE_LOG:
 		if (tb[NFTA_LOG_LEVEL] != NULL) {
@@ -96,7 +97,16 @@ static int nft_log_init(const struct nft_ctx *ctx,
 		break;
 	}
 
-	return nf_logger_find_get(ctx->afi->family, li->type);
+	err = nf_logger_find_get(ctx->afi->family, li->type);
+	if (err < 0)
+		goto err1;
+
+	return 0;
+
+err1:
+	if (priv->prefix != nft_log_null_prefix)
+		kfree(priv->prefix);
+	return err;
 }
 
 static void nft_log_destroy(const struct nft_ctx *ctx,
-- 
2.5.5


