Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59EB0C0018C
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AC2C23877
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726459AbgLGSRk (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:17:40 -0500
Received: from correo.us.es ([193.147.175.20]:40670 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726410AbgLGSRk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 13:17:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CC904DA710
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B9272DA73D
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:49 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id AD82EDA791; Mon,  7 Dec 2020 19:16:49 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 5F38BDA73D
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:47 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 07 Dec 2020 19:16:47 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 4F92541FF201
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:47 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 1/5] netfilter: nftables: generalize set expressions support
Date:   Mon,  7 Dec 2020 19:16:47 +0100
Message-Id: <20201207181651.18771-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207181651.18771-1-pablo@netfilter.org>
References: <20201207181651.18771-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Currently, the set infrastucture allows for one single expressions per
element. This patch extends the existing infrastructure to allow for up
to two expressions. This is not updating the netlink API yet, this is
coming as an initial preparation patch.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  5 +-
 net/netfilter/nf_tables_api.c     | 87 ++++++++++++++++++++++---------
 net/netfilter/nft_dynset.c        |  3 +-
 3 files changed, 67 insertions(+), 28 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 55b4cadf290a..aad7e1381200 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -396,6 +396,8 @@ struct nft_set_type {
 };
 #define to_set_type(o) container_of(o, struct nft_set_type, ops)
 
+#define NFT_SET_EXPR_MAX	2
+
 /**
  * 	struct nft_set - nf_tables set instance
  *
@@ -448,13 +450,14 @@ struct nft_set {
 	u16				policy;
 	u16				udlen;
 	unsigned char			*udata;
-	struct nft_expr			*expr;
 	/* runtime data below here */
 	const struct nft_set_ops	*ops ____cacheline_aligned;
 	u16				flags:14,
 					genmask:2;
 	u8				klen;
 	u8				dlen;
+	u8				num_exprs;
+	struct nft_expr			*exprs[NFT_SET_EXPR_MAX];
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(u64))));
 };
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 65aa98fc5eb6..9230eac9ed3d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3841,9 +3841,9 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 
 	nla_nest_end(skb, nest);
 
-	if (set->expr) {
+	if (set->num_exprs == 1) {
 		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPR);
-		if (nf_tables_fill_expr_info(skb, set->expr) < 0)
+		if (nf_tables_fill_expr_info(skb, set->exprs[0]) < 0)
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
@@ -4279,6 +4279,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			err = PTR_ERR(expr);
 			goto err_set_alloc_name;
 		}
+		set->exprs[0] = expr;
+		set->num_exprs++;
 	}
 
 	udata = NULL;
@@ -4296,7 +4298,6 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 	set->dtype = dtype;
 	set->objtype = objtype;
 	set->dlen  = desc.dlen;
-	set->expr = expr;
 	set->flags = flags;
 	set->size  = desc.size;
 	set->policy = policy;
@@ -4325,8 +4326,8 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 err_set_trans:
 	ops->destroy(set);
 err_set_init:
-	if (expr)
-		nft_expr_destroy(&ctx, expr);
+	for (i = 0; i < set->num_exprs; i++)
+		nft_expr_destroy(&ctx, set->exprs[i]);
 err_set_alloc_name:
 	kfree(set->name);
 err_set_name:
@@ -4336,11 +4337,13 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 
 static void nft_set_destroy(const struct nft_ctx *ctx, struct nft_set *set)
 {
+	int i;
+
 	if (WARN_ON(set->use > 0))
 		return;
 
-	if (set->expr)
-		nft_expr_destroy(ctx, set->expr);
+	for (i = 0; i < set->num_exprs; i++)
+		nft_expr_destroy(ctx, set->exprs[i]);
 
 	set->ops->destroy(set);
 	kfree(set->name);
@@ -5139,9 +5142,39 @@ static void nf_tables_set_elem_destroy(const struct nft_ctx *ctx,
 	kfree(elem);
 }
 
+static int nft_set_elem_expr_clone(const struct nft_ctx *ctx,
+				   struct nft_set *set,
+				   struct nft_expr *expr_array[])
+{
+	struct nft_expr *expr;
+	int err, i, k;
+
+	for (i = 0; i < set->num_exprs; i++) {
+		expr = kzalloc(set->exprs[i]->ops->size, GFP_KERNEL);
+		if (!expr)
+			goto err_expr;
+
+		err = nft_expr_clone(expr, set->exprs[i]);
+		if (err < 0) {
+			nft_expr_destroy(ctx, expr);
+			goto err_expr;
+		}
+		expr_array[i] = expr;
+	}
+
+	return 0;
+
+err_expr:
+	for (k = i - 1; k >= 0; k++)
+		nft_expr_destroy(ctx, expr_array[i]);
+
+	return -ENOMEM;
+}
+
 static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			    const struct nlattr *attr, u32 nlmsg_flags)
 {
+	struct nft_expr *expr_array[NFT_SET_EXPR_MAX];
 	struct nlattr *nla[NFTA_SET_ELEM_MAX + 1];
 	u8 genmask = nft_genmask_next(ctx->net);
 	struct nft_set_ext_tmpl tmpl;
@@ -5149,7 +5182,6 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	struct nft_set_elem elem;
 	struct nft_set_binding *binding;
 	struct nft_object *obj = NULL;
-	struct nft_expr *expr = NULL;
 	struct nft_userdata *udata;
 	struct nft_data_desc desc;
 	enum nft_registers dreg;
@@ -5158,7 +5190,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	u64 timeout;
 	u64 expiration;
 	u8 ulen;
-	int err;
+	int err, i;
 
 	err = nla_parse_nested_deprecated(nla, NFTA_SET_ELEM_MAX, attr,
 					  nft_set_elem_policy, NULL);
@@ -5216,23 +5248,24 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			return err;
 	}
 
-	if (nla[NFTA_SET_ELEM_EXPR] != NULL) {
+	if (nla[NFTA_SET_ELEM_EXPR] && set->num_exprs == 1) {
+		struct nft_expr *expr;
+
 		expr = nft_set_elem_expr_alloc(ctx, set,
 					       nla[NFTA_SET_ELEM_EXPR]);
 		if (IS_ERR(expr))
 			return PTR_ERR(expr);
 
-		err = -EOPNOTSUPP;
-		if (set->expr && set->expr->ops != expr->ops)
-			goto err_set_elem_expr;
-	} else if (set->expr) {
-		expr = kzalloc(set->expr->ops->size, GFP_KERNEL);
-		if (!expr)
-			return -ENOMEM;
+		expr_array[0] = expr;
 
-		err = nft_expr_clone(expr, set->expr);
-		if (err < 0)
+		if (set->exprs[0] && set->exprs[0]->ops != expr->ops) {
+			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
+		}
+	} else if (set->num_exprs > 0) {
+		err = nft_set_elem_expr_clone(ctx, set, expr_array);
+		if (err < 0)
+			goto err_set_elem_expr_clone;
 	}
 
 	err = nft_setelem_parse_key(ctx, set, &elem.key.val,
@@ -5257,9 +5290,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			nft_set_ext_add(&tmpl, NFT_SET_EXT_TIMEOUT);
 	}
 
-	if (expr)
+	if (set->num_exprs == 1)
 		nft_set_ext_add_length(&tmpl, NFT_SET_EXT_EXPR,
-				       expr->ops->size);
+				       expr_array[0]->ops->size);
 
 	if (nla[NFTA_SET_ELEM_OBJREF] != NULL) {
 		if (!(set->flags & NFT_SET_OBJECT)) {
@@ -5341,10 +5374,12 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 		*nft_set_ext_obj(ext) = obj;
 		obj->use++;
 	}
-	if (expr) {
+	if (set->num_exprs == 1) {
+		struct nft_expr *expr = expr_array[0];
+
 		memcpy(nft_set_ext_expr(ext), expr, expr->ops->size);
 		kfree(expr);
-		expr = NULL;
+		expr_array[0] = NULL;
 	}
 
 	trans = nft_trans_elem_alloc(ctx, NFT_MSG_NEWSETELEM, set);
@@ -5406,9 +5441,9 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 err_parse_key:
 	nft_data_release(&elem.key.val, NFT_DATA_VALUE);
 err_set_elem_expr:
-	if (expr != NULL)
-		nft_expr_destroy(ctx, expr);
-
+	for (i = 0; i < set->num_exprs; i++)
+		nft_expr_destroy(ctx, expr_array[i]);
+err_set_elem_expr_clone:
 	return err;
 }
 
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 64ca13a1885b..5f01844428a2 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -188,7 +188,8 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 		if (IS_ERR(priv->expr))
 			return PTR_ERR(priv->expr);
 
-		if (set->expr && set->expr->ops != priv->expr->ops) {
+		if (set->num_exprs == 1 &&
+		    set->exprs[0] && set->exprs[0]->ops != priv->expr->ops) {
 			err = -EOPNOTSUPP;
 			goto err_expr_free;
 		}
-- 
2.20.1

