Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EDE4C47434
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EB622371F
	for <netfilter-devel@archiver.kernel.org>; Mon,  7 Dec 2020 18:18:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726467AbgLGSRl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 7 Dec 2020 13:17:41 -0500
Received: from correo.us.es ([193.147.175.20]:40680 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726427AbgLGSRk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 7 Dec 2020 13:17:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id E9641EB465
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D64CEDA789
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id CA46BDA73F; Mon,  7 Dec 2020 19:16:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 75CCFDA78D
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 07 Dec 2020 19:16:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from localhost.localdomain (unknown [90.77.255.23])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: pneira@us.es)
        by entrada.int (Postfix) with ESMTPSA id 608F641FF201
        for <netfilter-devel@vger.kernel.org>; Mon,  7 Dec 2020 19:16:48 +0100 (CET)
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next 4/5] netfilter: nftables: add nft_expr_parse() helper function
Date:   Mon,  7 Dec 2020 19:16:50 +0100
Message-Id: <20201207181651.18771-5-pablo@netfilter.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20201207181651.18771-1-pablo@netfilter.org>
References: <20201207181651.18771-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This new helper function allows you to parse a list expression netlink
attributes. This also to reuse the same funcion to support for several
expressions in a set element.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  15 ++++
 net/netfilter/nf_tables_api.c     | 140 ++++++++++++++++++------------
 2 files changed, 100 insertions(+), 55 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 572bc780609c..1a2e6ebd3610 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -331,6 +331,21 @@ void nft_expr_destroy(const struct nft_ctx *ctx, struct nft_expr *expr);
 int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 		  const struct nft_expr *expr);
 
+struct nft_expr_info {
+	const struct nft_expr_ops	*ops;
+	const struct nlattr		*attr;
+	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
+};
+
+struct nft_expr_info_array {
+	u32				size;
+	u32				num_exprs;
+	struct nft_expr_info		*info;
+};
+
+int nft_expr_parse(const struct nft_ctx *ctx, const struct nlattr *attr,
+		   struct nft_expr_info_array *info_array, u32 max_exprs);
+
 struct nft_set_ext;
 
 /**
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 41b83278efef..a98e4ce4e796 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -2575,12 +2575,6 @@ int nft_expr_dump(struct sk_buff *skb, unsigned int attr,
 	return -1;
 }
 
-struct nft_expr_info {
-	const struct nft_expr_ops	*ops;
-	const struct nlattr		*attr;
-	struct nlattr			*tb[NFT_EXPR_MAXATTR + 1];
-};
-
 static int nf_tables_expr_parse(const struct nft_ctx *ctx,
 				const struct nlattr *nla,
 				struct nft_expr_info *info)
@@ -3145,6 +3139,61 @@ static int nft_table_validate(struct net *net, const struct nft_table *table)
 	return 0;
 }
 
+static void nft_expr_info_array_free(struct nft_expr_info_array *info_array)
+{
+	struct nft_expr_info *info;
+	int i;
+
+	for (i = 0; i < info_array->num_exprs; i++) {
+		info = &info_array->info[i];
+		if (info->ops) {
+			module_put(info->ops->type->owner);
+			if (info->ops->type->release_ops)
+				info->ops->type->release_ops(info->ops);
+		}
+	}
+	kvfree(info_array->info);
+}
+
+int nft_expr_parse(const struct nft_ctx *ctx, const struct nlattr *attr,
+		   struct nft_expr_info_array *info_array, u32 max_exprs)
+{
+	unsigned int num_exprs = 0, size = 0;
+	struct nft_expr_info *info;
+	struct nlattr *tmp;
+	int rem, err;
+
+	info = kvmalloc_array(max_exprs, sizeof(struct nft_expr_info),
+			      GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
+	info_array->info = info;
+	nla_for_each_nested(tmp, attr, rem) {
+		if (nla_type(tmp) != NFTA_LIST_ELEM) {
+			err = -EINVAL;
+			goto err_expr_parse;
+		}
+		if (num_exprs == max_exprs)
+			goto err_expr_parse;
+		err = nf_tables_expr_parse(ctx, tmp, &info[num_exprs]);
+		if (err < 0)
+			goto err_expr_parse;
+		size += info[num_exprs].ops->size;
+		num_exprs++;
+	}
+	info_array->num_exprs = num_exprs;
+	info_array->size = size;
+
+	return 0;
+
+err_expr_parse:
+	info_array->num_exprs = num_exprs;
+	nft_expr_info_array_free(info_array);
+
+	return err;
+}
+
 static struct nft_rule *nft_rule_lookup_byid(const struct net *net,
 					     const struct nlattr *nla);
 
@@ -3156,8 +3205,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 			     struct netlink_ext_ack *extack)
 {
 	const struct nfgenmsg *nfmsg = nlmsg_data(nlh);
+	struct nft_expr_info_array info_array = {
+		.size		= 0,
+		.num_exprs	= 0,
+	};
 	u8 genmask = nft_genmask_next(net);
-	struct nft_expr_info *info = NULL;
 	int family = nfmsg->nfgen_family;
 	struct nft_flow_rule *flow;
 	struct nft_table *table;
@@ -3167,9 +3219,8 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	struct nft_trans *trans = NULL;
 	struct nft_expr *expr;
 	struct nft_ctx ctx;
-	struct nlattr *tmp;
-	unsigned int size, i, n, ulen = 0, usize = 0;
-	int err, rem;
+	unsigned int i, ulen = 0, usize = 0;
+	int err;
 	u64 handle, pos_handle;
 
 	lockdep_assert_held(&net->nft.commit_mutex);
@@ -3243,32 +3294,17 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 
 	nft_ctx_init(&ctx, net, skb, nlh, family, table, chain, nla);
 
-	n = 0;
-	size = 0;
 	if (nla[NFTA_RULE_EXPRESSIONS]) {
-		info = kvmalloc_array(NFT_RULE_MAXEXPRS,
-				      sizeof(struct nft_expr_info),
-				      GFP_KERNEL);
-		if (!info)
-			return -ENOMEM;
-
-		nla_for_each_nested(tmp, nla[NFTA_RULE_EXPRESSIONS], rem) {
-			err = -EINVAL;
-			if (nla_type(tmp) != NFTA_LIST_ELEM)
-				goto err1;
-			if (n == NFT_RULE_MAXEXPRS)
-				goto err1;
-			err = nf_tables_expr_parse(&ctx, tmp, &info[n]);
-			if (err < 0)
-				goto err1;
-			size += info[n].ops->size;
-			n++;
-		}
+		err = nft_expr_parse(&ctx, nla[NFTA_RULE_EXPRESSIONS],
+				     &info_array, NFT_RULE_MAXEXPRS);
+		if (err < 0)
+			return err;
 	}
+
 	/* Check for overflow of dlen field */
 	err = -EFBIG;
-	if (size >= 1 << 12)
-		goto err1;
+	if (info_array.size >= 1 << 12)
+		goto err_rule_expressions;
 
 	if (nla[NFTA_RULE_USERDATA]) {
 		ulen = nla_len(nla[NFTA_RULE_USERDATA]);
@@ -3277,14 +3313,14 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	}
 
 	err = -ENOMEM;
-	rule = kzalloc(sizeof(*rule) + size + usize, GFP_KERNEL);
+	rule = kzalloc(sizeof(*rule) + info_array.size + usize, GFP_KERNEL);
 	if (rule == NULL)
-		goto err1;
+		goto err_rule_expressions;
 
 	nft_activate_next(net, rule);
 
 	rule->handle = handle;
-	rule->dlen   = size;
+	rule->dlen   = info_array.size;
 	rule->udata  = ulen ? 1 : 0;
 
 	if (ulen) {
@@ -3294,17 +3330,17 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	}
 
 	expr = nft_expr_first(rule);
-	for (i = 0; i < n; i++) {
-		err = nf_tables_newexpr(&ctx, &info[i], expr);
+	for (i = 0; i < info_array.num_exprs; i++) {
+		err = nf_tables_newexpr(&ctx, &info_array.info[i], expr);
 		if (err < 0) {
-			NL_SET_BAD_ATTR(extack, info[i].attr);
-			goto err2;
+			NL_SET_BAD_ATTR(extack, info_array.info[i].attr);
+			goto err_rule_release;
 		}
 
-		if (info[i].ops->validate)
+		if (info_array.info[i].ops->validate)
 			nft_validate_state_update(net, NFT_VALIDATE_NEED);
 
-		info[i].ops = NULL;
+		info_array.info[i].ops = NULL;
 		expr = nft_expr_next(expr);
 	}
 
@@ -3312,12 +3348,12 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (trans == NULL) {
 			err = -ENOMEM;
-			goto err2;
+			goto err_rule_release;
 		}
 		err = nft_delrule(&ctx, old_rule);
 		if (err < 0) {
 			nft_trans_destroy(trans);
-			goto err2;
+			goto err_rule_release;
 		}
 
 		list_add_tail_rcu(&rule->list, &old_rule->list);
@@ -3325,7 +3361,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 		trans = nft_trans_rule_add(&ctx, NFT_MSG_NEWRULE, rule);
 		if (!trans) {
 			err = -ENOMEM;
-			goto err2;
+			goto err_rule_release;
 		}
 
 		if (nlh->nlmsg_flags & NLM_F_APPEND) {
@@ -3340,7 +3376,7 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 				list_add_rcu(&rule->list, &chain->rules);
 		}
 	}
-	kvfree(info);
+	kvfree(info_array.info);
 	chain->use++;
 
 	if (net->nft.validate_state == NFT_VALIDATE_DO)
@@ -3355,17 +3391,11 @@ static int nf_tables_newrule(struct net *net, struct sock *nlsk,
 	}
 
 	return 0;
-err2:
+err_rule_release:
 	nf_tables_rule_release(&ctx, rule);
-err1:
-	for (i = 0; i < n; i++) {
-		if (info[i].ops) {
-			module_put(info[i].ops->type->owner);
-			if (info[i].ops->type->release_ops)
-				info[i].ops->type->release_ops(info[i].ops);
-		}
-	}
-	kvfree(info);
+err_rule_expressions:
+	nft_expr_info_array_free(&info_array);
+
 	return err;
 }
 
-- 
2.20.1

