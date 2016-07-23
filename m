From: Liping Zhang <zlpnobody@163.com>
Subject: [PATCH nf-next 1/2] netfilter: nft_compat: put back match/target module if init fail
Date: Sat, 23 Jul 2016 16:00:31 +0800
Message-ID: <1469260832-58903-1-git-send-email-zlpnobody@163.com>
Cc: netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from m12-18.163.com ([220.181.12.18]:38634 "EHLO m12-18.163.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbcGWIBX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 23 Jul 2016 04:01:23 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Liping Zhang <liping.zhang@spreadtrum.com>

If the user specify the invalid NFTA_MATCH_INFO/NFTA_TARGET_INFO attr
or memory alloc fail, we should call module_put to the related match
or target. Otherwise, we cannot remove the module even nobody use it.

Signed-off-by: Liping Zhang <liping.zhang@spreadtrum.com>
---
 net/netfilter/nft_compat.c | 34 ++++++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 8 deletions(-)

diff --git a/net/netfilter/nft_compat.c b/net/netfilter/nft_compat.c
index 6228c42..d74adf4 100644
--- a/net/netfilter/nft_compat.c
+++ b/net/netfilter/nft_compat.c
@@ -634,6 +634,7 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	struct xt_match *match;
 	char *mt_name;
 	u32 rev, family;
+	int err;
 
 	if (tb[NFTA_MATCH_NAME] == NULL ||
 	    tb[NFTA_MATCH_REV] == NULL ||
@@ -660,13 +661,17 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	if (IS_ERR(match))
 		return ERR_PTR(-ENOENT);
 
-	if (match->matchsize > nla_len(tb[NFTA_MATCH_INFO]))
-		return ERR_PTR(-EINVAL);
+	if (match->matchsize > nla_len(tb[NFTA_MATCH_INFO])) {
+		err = -EINVAL;
+		goto err;
+	}
 
 	/* This is the first time we use this match, allocate operations */
 	nft_match = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
-	if (nft_match == NULL)
-		return ERR_PTR(-ENOMEM);
+	if (nft_match == NULL) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	nft_match->ops.type = &nft_match_type;
 	nft_match->ops.size = NFT_EXPR_SIZE(XT_ALIGN(match->matchsize));
@@ -680,6 +685,10 @@ nft_match_select_ops(const struct nft_ctx *ctx,
 	list_add(&nft_match->head, &nft_match_list);
 
 	return &nft_match->ops;
+
+err:
+	module_put(match->me);
+	return ERR_PTR(err);
 }
 
 static void nft_match_release(void)
@@ -717,6 +726,7 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	struct xt_target *target;
 	char *tg_name;
 	u32 rev, family;
+	int err;
 
 	if (tb[NFTA_TARGET_NAME] == NULL ||
 	    tb[NFTA_TARGET_REV] == NULL ||
@@ -743,13 +753,17 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	if (IS_ERR(target))
 		return ERR_PTR(-ENOENT);
 
-	if (target->targetsize > nla_len(tb[NFTA_TARGET_INFO]))
-		return ERR_PTR(-EINVAL);
+	if (target->targetsize > nla_len(tb[NFTA_TARGET_INFO])) {
+		err = -EINVAL;
+		goto err;
+	}
 
 	/* This is the first time we use this target, allocate operations */
 	nft_target = kzalloc(sizeof(struct nft_xt), GFP_KERNEL);
-	if (nft_target == NULL)
-		return ERR_PTR(-ENOMEM);
+	if (nft_target == NULL) {
+		err = -ENOMEM;
+		goto err;
+	}
 
 	nft_target->ops.type = &nft_target_type;
 	nft_target->ops.size = NFT_EXPR_SIZE(XT_ALIGN(target->targetsize));
@@ -767,6 +781,10 @@ nft_target_select_ops(const struct nft_ctx *ctx,
 	list_add(&nft_target->head, &nft_target_list);
 
 	return &nft_target->ops;
+
+err:
+	module_put(target->me);
+	return ERR_PTR(err);
 }
 
 static void nft_target_release(void)
-- 
2.5.5


