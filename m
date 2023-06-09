Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1B03CC7EE43
	for <netfilter-devel@archiver.kernel.org>; Fri,  9 Jun 2023 12:01:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbjFIMBs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 9 Jun 2023 08:01:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231760AbjFIMBp (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Jun 2023 08:01:45 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 15C881BC6
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Jun 2023 05:01:43 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf 2/3] netfilter: nf_tables: disallow unbound anonymous set from commit step
Date:   Fri,  9 Jun 2023 14:01:36 +0200
Message-Id: <20230609120137.66297-2-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230609120137.66297-1-pablo@netfilter.org>
References: <20230609120137.66297-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Bail out if userspace creates an anonymous set which remains unbound
after this transaction.

Add a list of pending objects, this list is never used in iterations
as it stores object of different type.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |  3 +++
 net/netfilter/nf_tables_api.c     | 17 +++++++++++++++++
 2 files changed, 20 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 66e5c7a8ec21..d24146b526a1 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -511,6 +511,7 @@ struct nft_set_elem_expr {
  *
  *	@list: table set list node
  *	@bindings: list of set bindings
+ *	@pending_list: list of pending anonymous set not yet bound to rule
  *	@table: table this set belongs to
  *	@net: netnamespace this set belongs to
  * 	@name: name of the set
@@ -540,6 +541,7 @@ struct nft_set_elem_expr {
 struct nft_set {
 	struct list_head		list;
 	struct list_head		bindings;
+	struct list_head		pending_list;
 	struct nft_table		*table;
 	possible_net_t			net;
 	char				*name;
@@ -1707,6 +1709,7 @@ struct nftables_pernet {
 	struct list_head	commit_list;
 	struct list_head	module_list;
 	struct list_head	notify_list;
+	struct list_head	pending_list;
 	struct mutex		commit_mutex;
 	u64			table_handle;
 	unsigned int		base_seq;
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 69bceefaa5c8..11beb6750531 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -4926,6 +4926,12 @@ static int nf_tables_newset(struct sk_buff *skb, const struct nfnl_info *info,
 	if (err < 0)
 		goto err_set_expr_alloc;
 
+	if (nft_set_is_anonymous(set)) {
+		struct nftables_pernet *nft_net = nft_pernet(net);
+
+		list_add_tail(&set->pending_list, &nft_net->pending_list);
+	}
+
 	list_add_tail_rcu(&set->list, &table->sets);
 	table->use++;
 	return 0;
@@ -5108,6 +5114,9 @@ int nf_tables_bind_set(const struct nft_ctx *ctx, struct nft_set *set,
 	}
 bind:
 	binding->chain = ctx->chain;
+	if (nft_set_is_anonymous(set))
+		list_del(&set->pending_list);
+
 	list_add_tail_rcu(&binding->list, &set->bindings);
 	nft_set_trans_bind(ctx, set);
 	set->use++;
@@ -8792,6 +8801,11 @@ static int nf_tables_validate(struct net *net)
 	struct nftables_pernet *nft_net = nft_pernet(net);
 	struct nft_table *table;
 
+	if (!list_empty(&nft_net->pending_list)) {
+		pr_warn_once("rejecting nftables ruleset with pending objects\n");
+		return -EINVAL;
+	}
+
 	list_for_each_entry(table, &nft_net->tables, list) {
 		switch (table->validate_state) {
 		case NFT_VALIDATE_SKIP:
@@ -9727,6 +9741,8 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 			if (nft_trans_set_bound(trans)) {
 				nft_trans_destroy(trans);
 				break;
+			} else if (nft_set_is_anonymous(nft_trans_set(trans))) {
+				list_del(&nft_trans_set(trans)->pending_list);
 			}
 			list_del_rcu(&nft_trans_set(trans)->list);
 			break;
@@ -10599,6 +10615,7 @@ static int __net_init nf_tables_init_net(struct net *net)
 	INIT_LIST_HEAD(&nft_net->commit_list);
 	INIT_LIST_HEAD(&nft_net->module_list);
 	INIT_LIST_HEAD(&nft_net->notify_list);
+	INIT_LIST_HEAD(&nft_net->pending_list);
 	mutex_init(&nft_net->commit_mutex);
 	nft_net->base_seq = 1;
 
-- 
2.30.2

