Received: from mail.netfilter.org (mail.netfilter.org [217.70.190.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CA125DAF4
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 10:11:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.70.190.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747735906; cv=none; b=UphhpApvLS4FK+i0SvJ0veLbin4Iz6NHDgObdmeeda8HeM8ihhYuH4c/jlX2Jj2jQybnqi7dRw0Y1CxRB/y81cAgCU8pr4SGVxqtdOFb6monrTR0f85aVQWi6WyVZKDHG+Q8LnIAsRG7i76tSzQHqlQF1nzFwo1CupJmmjx8zm4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747735906; c=relaxed/simple;
	bh=zqF0JwNkNaRs3ZjSu3Jt8zGtUJvlE10fPpRUQ8HhWiY=;
	h=From:To:Subject:Date:Message-Id:MIME-Version; b=qtigLueR76jFyrdjWiY9MK+i8PQ1wCuZ07x69+52HE/8Fx+Hkap+Pw7Yzu/u9R+Am1ZPUP7xKfrYGy0JNKrj4Yvt0BpYGNzzC2tiX7xvopVW5CZ1HoY5DRPgCc9sYur8yws8WY0ddmNjyAYlEoZ8piwlSTG0GNbl2r9e/bcSq8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org; spf=pass smtp.mailfrom=netfilter.org; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=d/5Mp3jd; dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b=FZzO2Wfr; arc=none smtp.client-ip=217.70.190.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=netfilter.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=netfilter.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="d/5Mp3jd";
	dkim=pass (2048-bit key) header.d=netfilter.org header.i=@netfilter.org header.b="FZzO2Wfr"
Received: by mail.netfilter.org (Postfix, from userid 109)
	id C842760387; Tue, 20 May 2025 12:11:41 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735901;
	bh=b7xiwciryJ3vCea0ZCz7bXmCIJGxi+eRf/+Om/ZaRT4=;
	h=From:To:Subject:Date:From;
	b=d/5Mp3jdxZx+SUp1Y5Ocl4I/x1NOraWPcHcCRdb2Gk9B9CZZxJsIb/zuSmRGS9DTV
	 zaWRsNje3/vQpUwRwfeD/tHhDO3wAHj9O+GI2s6GvSErlzDNebJJLEMDr+JN87qR1j
	 U+WNXJwqRGXxv29zaVkkwgQlmIiUCIQIEbawv1msuwkIEJoQnoo8xMiXqIv06iF0eA
	 A+K7cPDCEBS9wH1uufzMRMsvnNkW1tfyMM4FP+4dDoy3mf5sqw3f70pbhWJLmGByO+
	 MOdF+/Tx9PuPHV8QeLc2vAE88FjC60McSIdfw3LhtT3Z6oT12klaI0NrE4OXXgBeq+
	 4QSiI8kAXTOBA==
X-Spam-Level: 
Received: from localhost.localdomain (mail-agni [217.70.190.124])
	by mail.netfilter.org (Postfix) with ESMTPSA id D25446073E
	for <netfilter-devel@vger.kernel.org>; Tue, 20 May 2025 12:09:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=netfilter.org;
	s=2025; t=1747735750;
	bh=b7xiwciryJ3vCea0ZCz7bXmCIJGxi+eRf/+Om/ZaRT4=;
	h=From:To:Subject:Date:From;
	b=FZzO2Wfrouw6W3OmwEh/a6vJTpQUjWZ0nk3eNA+vuXt79qAWjLtC9yw1fn9K65UMs
	 xT1w3iy/+WcT9781fCEYzF/FFlUNeH8uZCgMHI382pqdTXW3HqIJGYd+W/FUVIK3aJ
	 bF0WpRm7eJyE4B8tbGBfb4XcauYjlA+kiy0I8QSorx03LEwst/3GQHWSmlQA6g30Bj
	 xp9ijidS5kQ3XDuZLEQOrYqKFxkIJq+q38YbfLenMI8UpHyAEkK6vB5JWHMm3gjZQQ
	 4kF0qUh6rR5gxJcLwftAVRTpQe3FXYI67wIwLpMlSZG6Sb2vhkc0CSwt22oDuvnp3G
	 MPYBhlEdLYhnw==
From: Pablo Neira Ayuso <pablo@netfilter.org>
To: netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v2 1/4] netfilter: nf_tables: add infrastructure for chain validation on updates
Date: Tue, 20 May 2025 12:09:04 +0200
Message-Id: <20250520100907.191244-1-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add infrastructure to validate rulesets at chain granularity to improve
the situation for incremental rule and set element updates.

Instead of fully validating the table on updates, annotate chains in the
table that needs to be validated again after the updates in this batch.

Add a validation list per netns that contains chains that are pending to
be validated. A chain is added to the validation list under the
following circunstances:

- A new rule is added, then add the chain that contains this rule.
  This allows to validate if the rule expressions are supported from
  this chain.
- A new rule performs a jump/goto another chain. The destination
  chain is added to the validation list.
- A new set element is added, then add the jump/goto chain via
  element (verdict maps).

Add the chain that need validation to the validation list, then from the
commit/abort path, remove from the validation list. The validation list
becomes empty after the commit/abort phase.

This is a preparation patch, note that full table validation is still
in place, the next patch adds more infrastructure to enable chain
validation.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
v2: no changes

 include/net/netfilter/nf_tables.h |  5 +++-
 net/netfilter/nf_tables_api.c     | 45 ++++++++++++++++++++++++++++---
 2 files changed, 46 insertions(+), 4 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 803d5f1601f9..d391990d1a96 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1119,11 +1119,13 @@ struct nft_chain {
 	struct nft_rule_blob		__rcu *blob_gen_1;
 	struct list_head		rules;
 	struct list_head		list;
+	struct list_head		validate_list;
 	struct rhlist_head		rhlhead;
 	struct nft_table		*table;
 	u64				handle;
 	u32				use;
-	u8				flags:5,
+	u8				flags:4,
+					validate:1,
 					bound:1,
 					genmask:2;
 	char				*name;
@@ -1910,6 +1912,7 @@ struct nftables_pernet {
 	struct list_head	binding_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
+	struct list_head	validate_list;
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	u64			tstamp;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 8ef9abac4579..397d775072f9 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -123,6 +123,25 @@ static void nft_validate_state_update(struct nft_table *table, u8 new_validate_s
 
 	table->validate_state = new_validate_state;
 }
+
+static void nft_validate_chain_pending(struct net *net, struct nft_chain *chain)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+
+	if (chain->validate)
+		return;
+
+	chain->validate = 1;
+	list_add_tail(&chain->validate_list, &nft_net->validate_list);
+}
+
+static void nft_validate_chain_need(struct nft_ctx *ctx,
+				    struct nft_chain *chain)
+{
+	nft_validate_chain_pending(ctx->net, chain);
+	nft_validate_state_update(ctx->table, NFT_VALIDATE_NEED);
+}
+
 static void nf_tables_trans_destroy_work(struct work_struct *w);
 
 static void nft_trans_gc_work(struct work_struct *work);
@@ -274,6 +293,8 @@ static void nft_chain_trans_bind(const struct nft_ctx *ctx,
 
 int nf_tables_bind_chain(const struct nft_ctx *ctx, struct nft_chain *chain)
 {
+	nft_validate_chain_need((struct nft_ctx *)ctx, chain);
+
 	if (!nft_chain_binding(chain))
 		return 0;
 
@@ -4297,7 +4318,7 @@ static int nf_tables_newrule(struct sk_buff *skb, const struct nfnl_info *info,
 		}
 
 		if (expr_info[i].ops->validate)
-			nft_validate_state_update(table, NFT_VALIDATE_NEED);
+			nft_validate_chain_need(&ctx, ctx.chain);
 
 		expr_info[i].ops = NULL;
 		expr = nft_expr_next(expr);
@@ -7392,8 +7413,7 @@ static int nft_add_set_elem(struct nft_ctx *ctx, struct nft_set *set,
 			if (desc.type == NFT_DATA_VERDICT &&
 			    (elem.data.val.verdict.code == NFT_GOTO ||
 			     elem.data.val.verdict.code == NFT_JUMP))
-				nft_validate_state_update(ctx->table,
-							  NFT_VALIDATE_NEED);
+				nft_validate_chain_need(ctx, elem.data.val.verdict.chain);
 		}
 
 		err = nft_set_ext_add_length(&tmpl, NFT_SET_EXT_DATA, desc.len);
@@ -9898,6 +9918,17 @@ static const struct nfnl_callback nf_tables_cb[NFT_MSG_MAX] = {
 	},
 };
 
+static void nft_validate_chain_release(struct net *net)
+{
+	struct nftables_pernet *nft_net = nft_pernet(net);
+	struct nft_chain *chain, *next;
+
+	list_for_each_entry_safe(chain, next, &nft_net->validate_list, validate_list) {
+		list_del(&chain->validate_list);
+		chain->validate = 0;
+	}
+}
+
 static int nf_tables_validate(struct net *net)
 {
 	struct nftables_pernet *nft_net = nft_pernet(net);
@@ -10506,6 +10537,8 @@ static void nf_tables_module_autoload_cleanup(struct net *net)
 	struct nft_module_request *req, *next;
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->validate_list));
+
 	list_for_each_entry_safe(req, next, &nft_net->module_list, list) {
 		WARN_ON_ONCE(!req->done);
 		list_del(&req->list);
@@ -10705,6 +10738,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 	int err;
 
 	if (list_empty(&nft_net->commit_list)) {
+		nft_validate_chain_release(net);
 		mutex_unlock(&nft_net->commit_mutex);
 		return 0;
 	}
@@ -10745,6 +10779,7 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 		nft_net->validate_state = NFT_VALIDATE_DO;
 		return -EAGAIN;
 	}
+	nft_validate_chain_release(net);
 
 	err = nft_flow_rule_offload_commit(net);
 	if (err < 0)
@@ -11099,6 +11134,7 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			err = -EAGAIN;
 		break;
 	}
+	nft_validate_chain_release(net);
 
 	list_for_each_entry_safe_reverse(trans, next, &nft_net->commit_list,
 					 list) {
@@ -11311,6 +11347,7 @@ static int nf_tables_abort(struct net *net, struct sk_buff *skb,
 	nft_gc_seq_end(nft_net, gc_seq);
 
 	WARN_ON_ONCE(!list_empty(&nft_net->commit_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->validate_list));
 
 	/* module autoload needs to happen after GC sequence update because it
 	 * temporarily releases and grabs mutex again.
@@ -11969,6 +12006,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->binding_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
+	INIT_LIST_HEAD(&nft_net->validate_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
 	nft_net->gc_seq = 0;
@@ -12013,6 +12051,7 @@ static void __net_exit nf_tables_exit_net(struct net *net)
 	WARN_ON_ONCE(!list_empty(&nft_net->module_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->notify_list));
 	WARN_ON_ONCE(!list_empty(&nft_net->destroy_list));
+	WARN_ON_ONCE(!list_empty(&nft_net->validate_list));
 }
 
 static void nf_tables_exit_batch(struct list_head *net_exit_list)
-- 
2.30.2

