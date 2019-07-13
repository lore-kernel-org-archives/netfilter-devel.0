Return-Path: <SRS0=nOV7=VK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58F52C742A7
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 16:03:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 321F320830
	for <netfilter-devel@archiver.kernel.org>; Sat, 13 Jul 2019 16:03:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbfGMQDM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 13 Jul 2019 12:03:12 -0400
Received: from fnsib-smtp07.srv.cat ([46.16.61.67]:45293 "EHLO
        fnsib-smtp07.srv.cat" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727638AbfGMQDL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 13 Jul 2019 12:03:11 -0400
Received: from localhost.localdomain (unknown [47.62.206.189])
        by fnsib-smtp07.srv.cat (Postfix) with ESMTPSA id C0F2881DE;
        Sat, 13 Jul 2019 18:03:06 +0200 (CEST)
From:   Ander Juaristi <a@juaristi.eus>
To:     netfilter-devel@vger.kernel.org
Cc:     Ander Juaristi <a@juaristi.eus>
Subject: [PATCH] netfilter: nft_dynset: support for element deletion
Date:   Sat, 13 Jul 2019 18:03:02 +0200
Message-Id: <20190713160302.31308-1-a@juaristi.eus>
X-Mailer: git-send-email 2.17.1
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch implements the delete operation from the ruleset.

It implements a new delete() function in nft_set_rhash. It is simpler
to use than the already existing remove(), because it only takes the set
and the key as arguments, whereas remove() expects a full
nft_set_elem structure.

Signed-off-by: Ander Juaristi <a@juaristi.eus>
---
 include/net/netfilter/nf_tables.h        |  2 ++
 include/uapi/linux/netfilter/nf_tables.h |  1 +
 net/netfilter/nft_dynset.c               | 43 +++++++++++++++++-------
 net/netfilter/nft_set_hash.c             | 20 +++++++++++
 4 files changed, 53 insertions(+), 13 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 9e8493aad49d..b24a3c8ec0a4 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -312,6 +312,8 @@ struct nft_set_ops {
 						  const struct nft_expr *expr,
 						  struct nft_regs *regs,
 						  const struct nft_set_ext **ext);
+	bool				(*delete)(const struct nft_set *set,
+						  const u32 *key);
 
 	int				(*insert)(const struct net *net,
 						  const struct nft_set *set,
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c6c8ec5c7c00..e8483e1e7146 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -634,6 +634,7 @@ enum nft_lookup_attributes {
 enum nft_dynset_ops {
 	NFT_DYNSET_OP_ADD,
 	NFT_DYNSET_OP_UPDATE,
+	NFT_DYNSET_OP_DELETE,
 };
 
 enum nft_dynset_flags {
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index bfb9f7463b03..83b88ca656d4 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -79,37 +79,53 @@ static void *nft_dynset_new(struct nft_set *set, const struct nft_expr *expr,
 	return NULL;
 }
 
-void nft_dynset_eval(const struct nft_expr *expr,
-		     struct nft_regs *regs, const struct nft_pktinfo *pkt)
+static bool nft_dynset_update(uint8_t sreg_key, int op, u64 timeout,
+			      const struct nft_expr *expr,
+			      const struct nft_pktinfo *pkt,
+			      struct nft_regs *regs, struct nft_set *set)
 {
-	const struct nft_dynset *priv = nft_expr_priv(expr);
-	struct nft_set *set = priv->set;
 	const struct nft_set_ext *ext;
 	const struct nft_expr *sexpr;
-	u64 timeout;
 
-	if (set->ops->update(set, &regs->data[priv->sreg_key], nft_dynset_new,
+	if (set->ops->update(set, &regs->data[sreg_key], nft_dynset_new,
 			     expr, regs, &ext)) {
 		sexpr = NULL;
 		if (nft_set_ext_exists(ext, NFT_SET_EXT_EXPR))
 			sexpr = nft_set_ext_expr(ext);
 
-		if (priv->op == NFT_DYNSET_OP_UPDATE &&
+		if (op == NFT_DYNSET_OP_UPDATE &&
 		    nft_set_ext_exists(ext, NFT_SET_EXT_EXPIRATION)) {
-			timeout = priv->timeout ? : set->timeout;
+			timeout = timeout ? : set->timeout;
 			*nft_set_ext_expiration(ext) = get_jiffies_64() + timeout;
 		}
 
 		if (sexpr != NULL)
 			sexpr->ops->eval(sexpr, regs, pkt);
 
-		if (priv->invert)
-			regs->verdict.code = NFT_BREAK;
-		return;
+		return true;
 	}
 
-	if (!priv->invert)
-		regs->verdict.code = NFT_BREAK;
+	return false;
+}
+
+void nft_dynset_eval(const struct nft_expr *expr,
+		     struct nft_regs *regs, const struct nft_pktinfo *pkt)
+{
+	const struct nft_dynset *priv = nft_expr_priv(expr);
+	struct nft_set *set = priv->set;
+
+	if (priv->op == NFT_DYNSET_OP_DELETE) {
+		set->ops->delete(set, &regs->data[priv->sreg_key])
+	} else {
+		if (nft_dynset_update(priv->sreg_key, priv->op, priv->timeout, expr, pkt, regs, set)) {
+			if (priv->invert)
+				regs->verdict.code = NFT_BREAK;
+			return;
+		}
+
+		if (!priv->invert)
+			regs->verdict.code = NFT_BREAK;
+	}
 }
 
 static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
@@ -165,6 +181,7 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	priv->op = ntohl(nla_get_be32(tb[NFTA_DYNSET_OP]));
 	switch (priv->op) {
 	case NFT_DYNSET_OP_ADD:
+	case NFT_DYNSET_OP_DELETE:
 		break;
 	case NFT_DYNSET_OP_UPDATE:
 		if (!(set->flags & NFT_SET_TIMEOUT))
diff --git a/net/netfilter/nft_set_hash.c b/net/netfilter/nft_set_hash.c
index 03df08801e28..aeb83dfa9583 100644
--- a/net/netfilter/nft_set_hash.c
+++ b/net/netfilter/nft_set_hash.c
@@ -237,6 +237,25 @@ static void nft_rhash_remove(const struct net *net,
 	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
 }
 
+static bool nft_rhash_delete(const struct nft_set *set,
+			     const u32 *key)
+{
+	struct nft_rhash *priv = nft_set_priv(set);
+	struct nft_rhash_elem *he;
+	struct nft_rhash_cmp_arg arg = {
+		.genmask = NFT_GENMASK_ANY,
+		.set = set,
+		.key = key,
+	};
+
+	he = rhashtable_lookup(&priv->ht, &arg, nft_rhash_params);
+	if (he == NULL)
+		return false;
+
+	rhashtable_remove_fast(&priv->ht, &he->node, nft_rhash_params);
+	return true;
+}
+
 static void nft_rhash_walk(const struct nft_ctx *ctx, struct nft_set *set,
 			   struct nft_set_iter *iter)
 {
@@ -665,6 +684,7 @@ struct nft_set_type nft_set_rhash_type __read_mostly = {
 		.remove		= nft_rhash_remove,
 		.lookup		= nft_rhash_lookup,
 		.update		= nft_rhash_update,
+		.delete		= nft_rhash_delete,
 		.walk		= nft_rhash_walk,
 		.get		= nft_rhash_get,
 	},
-- 
2.17.1

