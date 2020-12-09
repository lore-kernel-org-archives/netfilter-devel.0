Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71F34C4167B
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:38:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21C8623B81
	for <netfilter-devel@archiver.kernel.org>; Wed,  9 Dec 2020 09:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729193AbgLIJiX (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 9 Dec 2020 04:38:23 -0500
Received: from correo.us.es ([193.147.175.20]:45390 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728311AbgLIJiN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 9 Dec 2020 04:38:13 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 048B1C1252
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:37:21 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id E686EDA4C7
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:37:20 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E5AD6DA4DE; Wed,  9 Dec 2020 10:37:20 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 90357DA4C7
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:37:18 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Wed, 09 Dec 2020 10:37:18 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 7D71A42EE399
        for <netfilter-devel@vger.kernel.org>; Wed,  9 Dec 2020 10:37:18 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH 5/5 nf-next,v2] netfilter: nftables: netlink support for several set element expressions
Date:   Wed,  9 Dec 2020 10:37:24 +0100
Message-Id: <20201209093724.16462-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This patch adds three new netlink attribute to encapsulate a list of
expressions per set elements:

- NFTA_SET_EXPRESSIONS: this attribute provides the set definition in
  terms of expressions. New set elements get attached the list of
  expressions that is specified by this new netlink attribute.
- NFTA_SET_ELEM_EXPRESSIONS: this attribute allows users to restore (or
  initialize) the stateful information of set elements when adding an
  element to the set.
- NFTA_DYNSET_EXPRESSIONS: this attribute specifies the list of
  expressions that the set element gets when it is inserted from the
  packet path.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: missing check for NFTA_DYNSET_EXPRESSION (Florian)
    Remove unnecessary nest attribute in NFTA_SET_ELEM_EXPR, use
    NFTA_LIST_ITEM instead.

 include/uapi/linux/netfilter/nf_tables.h |  3 +
 net/netfilter/nf_tables_api.c            | 88 +++++++++++++++++++++++-
 net/netfilter/nft_dynset.c               | 43 +++++++++++-
 3 files changed, 128 insertions(+), 6 deletions(-)

diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index 98272cb5f617..42e4c4cb0daa 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -381,6 +381,7 @@ enum nft_set_attributes {
 	NFTA_SET_OBJ_TYPE,
 	NFTA_SET_HANDLE,
 	NFTA_SET_EXPR,
+	NFTA_SET_EXPRESSIONS,
 	__NFTA_SET_MAX
 };
 #define NFTA_SET_MAX		(__NFTA_SET_MAX - 1)
@@ -419,6 +420,7 @@ enum nft_set_elem_attributes {
 	NFTA_SET_ELEM_PAD,
 	NFTA_SET_ELEM_OBJREF,
 	NFTA_SET_ELEM_KEY_END,
+	NFTA_SET_ELEM_EXPRESSIONS,
 	__NFTA_SET_ELEM_MAX
 };
 #define NFTA_SET_ELEM_MAX	(__NFTA_SET_ELEM_MAX - 1)
@@ -725,6 +727,7 @@ enum nft_dynset_attributes {
 	NFTA_DYNSET_SREG_DATA,
 	NFTA_DYNSET_TIMEOUT,
 	NFTA_DYNSET_EXPR,
+	NFTA_DYNSET_EXPRESSIONS,
 	NFTA_DYNSET_PAD,
 	NFTA_DYNSET_FLAGS,
 	__NFTA_DYNSET_MAX,
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index a98e4ce4e796..2707c65cdb1d 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -3596,6 +3596,7 @@ static const struct nla_policy nft_set_policy[NFTA_SET_MAX + 1] = {
 	[NFTA_SET_OBJ_TYPE]		= { .type = NLA_U32 },
 	[NFTA_SET_HANDLE]		= { .type = NLA_U64 },
 	[NFTA_SET_EXPR]			= { .type = NLA_NESTED },
+	[NFTA_SET_EXPRESSIONS]		= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_desc_policy[NFTA_SET_DESC_MAX + 1] = {
@@ -3803,6 +3804,7 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 	u32 portid = ctx->portid;
 	struct nlattr *nest;
 	u32 seq = ctx->seq;
+	int i;
 
 	event = nfnl_msg_type(NFNL_SUBSYS_NFTABLES, event);
 	nlh = nlmsg_put(skb, portid, seq, event, sizeof(struct nfgenmsg),
@@ -3877,6 +3879,17 @@ static int nf_tables_fill_set(struct sk_buff *skb, const struct nft_ctx *ctx,
 			goto nla_put_failure;
 
 		nla_nest_end(skb, nest);
+	} else if (set->num_exprs > 1) {
+		nest = nla_nest_start_noflag(skb, NFTA_SET_EXPRESSIONS);
+		if (nest == NULL)
+			goto nla_put_failure;
+
+		for (i = 0; i < set->num_exprs; i++) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+					  set->exprs[i]) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
 	}
 
 	nlmsg_end(skb, nlh);
@@ -4245,7 +4258,7 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 			return err;
 	}
 
-	if (nla[NFTA_SET_EXPR])
+	if (nla[NFTA_SET_EXPR] || nla[NFTA_SET_EXPRESSIONS])
 		desc.expr = true;
 
 	table = nft_table_lookup(net, nla[NFTA_SET_TABLE], family, genmask);
@@ -4311,6 +4324,33 @@ static int nf_tables_newset(struct net *net, struct sock *nlsk,
 		}
 		set->exprs[0] = expr;
 		set->num_exprs++;
+	} else if (nla[NFTA_SET_EXPRESSIONS]) {
+		struct nft_expr_info_array info_array = {
+			.size		= 0,
+			.num_exprs	= 0,
+		};
+		struct nft_expr *expr;
+		int err;
+
+		err = nft_expr_parse(&ctx, nla[NFTA_SET_EXPRESSIONS],
+				     &info_array, NFT_SET_EXPR_MAX);
+		if (err < 0)
+			return err;
+
+		for (i = 0; i < info_array.num_exprs; i++) {
+			expr = nft_set_elem_expr_alloc(&ctx, set,
+						       info_array.info[i].attr);
+			if (IS_ERR(expr))
+				goto err_set_init;
+
+			set->exprs[i] = expr;
+			set->num_exprs++;
+		}
+
+		if (set->num_exprs != info_array.num_exprs) {
+			err = -EOPNOTSUPP;
+			goto err_set_init;
+		}
 	}
 
 	udata = NULL;
@@ -4570,6 +4610,7 @@ static const struct nla_policy nft_set_elem_policy[NFTA_SET_ELEM_MAX + 1] = {
 	[NFTA_SET_ELEM_OBJREF]		= { .type = NLA_STRING,
 					    .len = NFT_OBJ_MAXNAMELEN - 1 },
 	[NFTA_SET_ELEM_KEY_END]		= { .type = NLA_NESTED },
+	[NFTA_SET_ELEM_EXPRESSIONS]	= { .type = NLA_NESTED },
 };
 
 static const struct nla_policy nft_set_elem_list_policy[NFTA_SET_ELEM_LIST_MAX + 1] = {
@@ -4610,6 +4651,7 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 	struct nft_set_elem_expr *elem_expr;
 	u32 size, num_exprs = 0;
 	struct nft_expr *expr;
+	struct nlattr *nest;
 
 	elem_expr = nft_set_ext_expr(ext);
 	nft_setelem_expr_foreach(expr, elem_expr, size)
@@ -4621,9 +4663,22 @@ static int nft_set_elem_expr_dump(struct sk_buff *skb,
 			return -1;
 
 		return 0;
-	}
+	} else if (num_exprs > 1) {
+		nest = nla_nest_start_noflag(skb, NFTA_SET_ELEM_EXPRESSIONS);
+		if (nest == NULL)
+			goto nla_put_failure;
 
+		nft_setelem_expr_foreach(expr, elem_expr, size) {
+			expr = nft_setelem_expr_at(elem_expr, size);
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM, expr) < 0)
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
+	}
 	return 0;
+
+nla_put_failure:
+	return -1;
 }
 
 static int nf_tables_fill_setelem(struct sk_buff *skb,
@@ -5298,7 +5353,8 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 	      nla[NFTA_SET_ELEM_TIMEOUT] ||
 	      nla[NFTA_SET_ELEM_EXPIRATION] ||
 	      nla[NFTA_SET_ELEM_USERDATA] ||
-	      nla[NFTA_SET_ELEM_EXPR]))
+	      nla[NFTA_SET_ELEM_EXPR] ||
+	      nla[NFTA_SET_ELEM_EXPRESSIONS]))
 		return -EINVAL;
 
 	timeout = 0;
@@ -5337,6 +5393,32 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			err = -EOPNOTSUPP;
 			goto err_set_elem_expr;
 		}
+	} else if (nla[NFTA_SET_ELEM_EXPRESSIONS] && set->num_exprs > 0) {
+		struct nft_expr_info_array info_array = {
+			.size		= 0,
+			.num_exprs	= 0,
+		};
+		struct nft_expr *expr;
+		int err;
+
+		err = nft_expr_parse(ctx, nla[NFTA_SET_ELEM_EXPRESSIONS],
+				     &info_array, NFT_SET_EXPR_MAX);
+		if (err < 0)
+			return err;
+
+		for (i = 0; i < info_array.num_exprs; i++) {
+			expr = nft_set_elem_expr_alloc(ctx, set,
+						       info_array.info[i].attr);
+			if (IS_ERR(expr))
+				goto err_set_elem_expr;
+
+			expr_array[i] = expr;
+		}
+
+		if (set->num_exprs != info_array.num_exprs) {
+			err = -EOPNOTSUPP;
+			goto err_set_elem_expr;
+		}
 	} else if (set->num_exprs > 0) {
 		err = nft_set_elem_expr_clone(ctx, set, expr_array);
 		if (err < 0)
diff --git a/net/netfilter/nft_dynset.c b/net/netfilter/nft_dynset.c
index 0ac9f1205b56..67c006b5cd01 100644
--- a/net/netfilter/nft_dynset.c
+++ b/net/netfilter/nft_dynset.c
@@ -153,6 +153,7 @@ static const struct nla_policy nft_dynset_policy[NFTA_DYNSET_MAX + 1] = {
 	[NFTA_DYNSET_TIMEOUT]	= { .type = NLA_U64 },
 	[NFTA_DYNSET_EXPR]	= { .type = NLA_NESTED },
 	[NFTA_DYNSET_FLAGS]	= { .type = NLA_U32 },
+	[NFTA_DYNSET_EXPRESSIONS] = { .type = NLA_NESTED, },
 };
 
 static int nft_dynset_init(const struct nft_ctx *ctx,
@@ -232,12 +233,13 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 	} else if (set->flags & NFT_SET_MAP)
 		return -EINVAL;
 
+	if ((tb[NFTA_DYNSET_EXPR] || tb[NFTA_DYNSET_EXPRESSIONS]) &&
+	    !(set->flags & NFT_SET_EVAL))
+		return -EINVAL;
+
 	if (tb[NFTA_DYNSET_EXPR]) {
 		struct nft_expr *dynset_expr;
 
-		if (!(set->flags & NFT_SET_EVAL))
-			return -EINVAL;
-
 		dynset_expr = nft_dynset_expr_alloc(ctx, set,
 						    tb[NFTA_DYNSET_EXPR], 0);
 		if (IS_ERR(dynset_expr))
@@ -245,6 +247,28 @@ static int nft_dynset_init(const struct nft_ctx *ctx,
 
 		priv->num_exprs++;
 		priv->expr_array[0] = dynset_expr;
+	} else if (tb[NFTA_DYNSET_EXPRESSIONS]) {
+		struct nft_expr_info_array info_array = {
+			.size		= 0,
+			.num_exprs	= 0,
+		};
+		struct nft_expr *dynset_expr;
+		int err;
+
+		err = nft_expr_parse(ctx, tb[NFTA_DYNSET_EXPRESSIONS],
+				     &info_array, NFT_SET_EXPR_MAX);
+		if (err < 0)
+			return err;
+
+		for (i = 0; i < info_array.num_exprs; i++) {
+			dynset_expr = nft_dynset_expr_alloc(ctx, set,
+							    info_array.info[i].attr, i);
+			if (IS_ERR(dynset_expr))
+				return PTR_ERR(dynset_expr);
+
+			priv->expr_array[i] = dynset_expr;
+			priv->num_exprs++;
+		}
 	}
 
 	nft_set_ext_prepare(&priv->tmpl);
@@ -329,6 +353,19 @@ static int nft_dynset_dump(struct sk_buff *skb, const struct nft_expr *expr)
 	if (priv->num_exprs == 1) {
 		if (nft_expr_dump(skb, NFTA_DYNSET_EXPR, priv->expr_array[i]))
 			goto nla_put_failure;
+	} else if (priv->num_exprs > 1) {
+		struct nlattr *nest;
+
+		nest = nla_nest_start_noflag(skb, NFTA_DYNSET_EXPRESSIONS);
+		if (!nest)
+			goto nla_put_failure;
+
+		for (i = 0; i < priv->num_exprs; i++) {
+			if (nft_expr_dump(skb, NFTA_LIST_ELEM,
+					  priv->expr_array[i]))
+				goto nla_put_failure;
+		}
+		nla_nest_end(skb, nest);
 	}
 	if (nla_put_be32(skb, NFTA_DYNSET_FLAGS, htonl(flags)))
 		goto nla_put_failure;
-- 
2.20.1

