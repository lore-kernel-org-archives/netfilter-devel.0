Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC051C7EE26
	for <netfilter-devel@archiver.kernel.org>; Fri,  5 May 2023 15:32:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232951AbjEEPcO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 5 May 2023 11:32:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbjEEPcM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 5 May 2023 11:32:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D66A9150C5
        for <netfilter-devel@vger.kernel.org>; Fri,  5 May 2023 08:31:55 -0700 (PDT)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Subject: [PATCH nf-next,v1 11/12] netfilter: nf_tables: add expression prefetch infrastructure
Date:   Fri,  5 May 2023 17:31:29 +0200
Message-Id: <20230505153130.2385-12-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230505153130.2385-1-pablo@netfilter.org>
References: <20230505153130.2385-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Use the register tracking state information that is provided by the
chain to decide whether it is worth to prefetch the expression.

Extend ruleset blob representation to store a prefetch rule which
inconditionally runs expressions before evaluating the ruleset.

Enable expression reduction if register tracking information via
prefetch is available.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h        |   5 +
 include/uapi/linux/netfilter/nf_tables.h |   2 +
 net/netfilter/nf_tables_api.c            | 192 ++++++++++++++++++++++-
 net/netfilter/nf_tables_core.c           |  30 +++-
 4 files changed, 221 insertions(+), 8 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 744beb30f105..ae7242aabda3 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1172,6 +1172,7 @@ static inline const struct nft_rule_dp *nft_rule_next(const struct nft_rule_dp *
 }
 
 struct nft_rule_blob {
+	unsigned long			prefetch_size;
 	unsigned long			size;
 	unsigned char			data[]
 		__attribute__((aligned(__alignof__(struct nft_rule_dp))));
@@ -1196,6 +1197,7 @@ struct nft_chain {
 	struct list_head		list;
 	struct rhlist_head		rhlhead;
 	struct nft_table		*table;
+	struct nft_rule			*prefetch;
 	u64				handle;
 	u32				use;
 	u8				flags:5,
@@ -1723,6 +1725,7 @@ struct nft_trans_chain {
 	u8				policy;
 	u32				chain_id;
 	struct nft_base_chain		*basechain;
+	struct nft_rule			*prefetch;
 	struct list_head		hook_list;
 };
 
@@ -1740,6 +1743,8 @@ struct nft_trans_chain {
 	(((struct nft_trans_chain *)trans->data)->basechain)
 #define nft_trans_chain_hooks(trans)	\
 	(((struct nft_trans_chain *)trans->data)->hook_list)
+#define nft_trans_chain_prefetch(trans)	\
+	(((struct nft_trans_chain *)trans->data)->prefetch)
 
 struct nft_trans_table {
 	bool				update;
diff --git a/include/uapi/linux/netfilter/nf_tables.h b/include/uapi/linux/netfilter/nf_tables.h
index c4d4d8e42dc8..e5cc5dd1f7f2 100644
--- a/include/uapi/linux/netfilter/nf_tables.h
+++ b/include/uapi/linux/netfilter/nf_tables.h
@@ -230,6 +230,7 @@ enum nft_chain_flags {
  * @NFTA_CHAIN_FLAGS: chain flags
  * @NFTA_CHAIN_ID: uniquely identifies a chain in a transaction (NLA_U32)
  * @NFTA_CHAIN_USERDATA: user data (NLA_BINARY)
+ * @NFTA_CHAIN_EXPRESSIONS: list of expressions to prefetch (NLA_NESTED: nft_expr_attributes)
  */
 enum nft_chain_attributes {
 	NFTA_CHAIN_UNSPEC,
@@ -245,6 +246,7 @@ enum nft_chain_attributes {
 	NFTA_CHAIN_FLAGS,
 	NFTA_CHAIN_ID,
 	NFTA_CHAIN_USERDATA,
+	NFTA_CHAIN_EXPRESSIONS,
 	__NFTA_CHAIN_MAX
 };
 #define NFTA_CHAIN_MAX		(__NFTA_CHAIN_MAX - 1)
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 3e43e5eab4be..d0c80e11557e 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1959,6 +1959,9 @@ static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
 	kvfree(chain->blob_next);
 }
 
+static void nf_tables_rule_destroy(const struct nft_ctx *ctx,
+				   struct nft_rule *rule);
+
 void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
@@ -1970,6 +1973,9 @@ void nf_tables_chain_destroy(struct nft_ctx *ctx)
 	/* no concurrent access possible anymore */
 	nf_tables_chain_free_chain_rules(chain);
 
+	if (chain->prefetch)
+		nf_tables_rule_destroy(ctx, chain->prefetch);
+
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
@@ -2247,6 +2253,7 @@ static struct nft_rule_blob *nf_tables_chain_alloc_rules(const struct nft_chain
 		return NULL;
 
 	blob->size = 0;
+	blob->prefetch_size = 0;
 	nft_last_rule(chain, blob->data);
 
 	return blob;
@@ -2308,6 +2315,62 @@ static int nft_chain_add(struct nft_table *table, struct nft_chain *chain)
 	return 0;
 }
 
+static int nf_tables_newexpr(const struct nft_ctx *ctx,
+			     const struct nft_expr_info *expr_info,
+			     struct nft_expr *expr);
+
+static int nft_chain_prefetch(struct nft_ctx *ctx, const struct nlattr *nla,
+			      struct nft_rule **prefetch,
+			      struct netlink_ext_ack *extack)
+{
+	struct nft_expr_info *expr_info;
+	unsigned int size = 0, n = 0;
+	struct nft_expr *expr;
+	struct nft_rule *rule;
+	int i, err;
+
+	expr_info = nft_expr_info_setup(ctx, nla, &size, &n, extack);
+	if (IS_ERR(expr_info))
+		return PTR_ERR(expr_info);
+
+	rule = kzalloc(sizeof(*rule) + size, GFP_KERNEL_ACCOUNT);
+	if (!rule) {
+		err = -ENOMEM;
+		goto err_destroy_prefetch;
+	}
+	rule->dlen = size;
+
+	expr = nft_expr_first(rule);
+	for (i = 0; i < n; i++) {
+		err = nf_tables_newexpr(ctx, &expr_info[i], expr);
+		if (err < 0) {
+			NL_SET_BAD_ATTR(extack, expr_info[i].attr);
+			goto err_destroy_prefetch_rule;
+		}
+		expr_info[i].ops = NULL;
+		expr = nft_expr_next(expr);
+	}
+	kvfree(expr_info);
+
+	*prefetch = rule;
+
+	return 0;
+
+err_destroy_prefetch_rule:
+	nf_tables_rule_destroy(ctx, rule);
+err_destroy_prefetch:
+	for (i = 0; i < n; i++) {
+		if (expr_info[i].ops) {
+			module_put(expr_info[i].ops->type->owner);
+			if (expr_info[i].ops->type->release_ops)
+				expr_info[i].ops->type->release_ops(expr_info[i].ops);
+		}
+	}
+	kvfree(expr_info);
+
+	return err;
+}
+
 static u64 chain_id;
 
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
@@ -2409,6 +2472,13 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		chain->udlen = nla_len(nla[NFTA_CHAIN_USERDATA]);
 	}
 
+	if (nla[NFTA_CHAIN_EXPRESSIONS]) {
+		err = nft_chain_prefetch(ctx, nla[NFTA_CHAIN_EXPRESSIONS],
+					 &chain->prefetch, extack);
+		if (err < 0)
+			goto err_destroy_chain;
+	}
+
 	blob = nf_tables_chain_alloc_rules(chain, 0);
 	if (!blob) {
 		err = -ENOMEM;
@@ -2457,6 +2527,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	struct nft_base_chain *basechain = NULL;
 	struct nft_table *table = ctx->table;
 	struct nft_chain *chain = ctx->chain;
+	struct nft_rule *prefetch = NULL;
 	struct nft_chain_hook hook = {};
 	struct nft_stats *stats = NULL;
 	struct nft_hook *h, *next;
@@ -2538,6 +2609,13 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 		}
 	}
 
+	if (nla[NFTA_CHAIN_EXPRESSIONS]) {
+		err = nft_chain_prefetch(ctx, nla[NFTA_CHAIN_EXPRESSIONS],
+					 &prefetch, extack);
+		if (err < 0)
+			goto err_hooks;
+	}
+
 	if (!(table->flags & NFT_TABLE_F_DORMANT) &&
 	    nft_is_base_chain(chain) &&
 	    !list_empty(&hook.list)) {
@@ -2560,6 +2638,7 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 
 	nft_trans_chain_stats(trans) = stats;
 	nft_trans_chain_update(trans) = true;
+	nft_trans_chain_prefetch(trans) = prefetch;
 
 	if (nla[NFTA_CHAIN_POLICY])
 		nft_trans_chain_policy(trans) = policy;
@@ -2605,6 +2684,9 @@ static int nf_tables_updchain(struct nft_ctx *ctx, u8 genmask, u8 policy,
 	free_percpu(stats);
 	kfree(trans);
 err_hooks:
+	if (prefetch)
+		nf_tables_rule_destroy(ctx, prefetch);
+
 	if (nla[NFTA_CHAIN_HOOK]) {
 		list_for_each_entry_safe(h, next, &hook.list, list) {
 			if (unregister)
@@ -8921,10 +9003,15 @@ static void nft_commit_release(struct nft_trans *trans)
 		break;
 	case NFT_MSG_DELCHAIN:
 	case NFT_MSG_DESTROYCHAIN:
-		if (nft_trans_chain_update(trans))
+		if (nft_trans_chain_update(trans)) {
+			if (nft_trans_chain_prefetch(trans)) {
+				nf_tables_rule_destroy(&trans->ctx,
+						       nft_trans_chain_prefetch(trans));
+			}
 			nft_hooks_destroy(&nft_trans_chain_hooks(trans));
-		else
+		} else {
 			nf_tables_chain_destroy(&trans->ctx);
+		}
 		break;
 	case NFT_MSG_DELRULE:
 	case NFT_MSG_DESTROYRULE:
@@ -8985,6 +9072,81 @@ void nf_tables_trans_destroy_flush_work(void)
 }
 EXPORT_SYMBOL_GPL(nf_tables_trans_destroy_flush_work);
 
+static unsigned int nft_prefetch_prepare(struct nft_regs_track *track,
+					 struct nft_chain *chain)
+{
+	const struct nft_expr *expr, *last;
+	unsigned int data_size = 0;
+	struct nft_rule *rule;
+	int i;
+
+	if (!chain->prefetch)
+		return 0;
+
+	rule = chain->prefetch;
+	nft_rule_for_each_expr(expr, last, rule) {
+		if (expr->ops->track)
+			expr->ops->track(track, expr);
+	}
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+		if (track->regs[i].selector == NFT_TRACK_SKIP_PTR) {
+			track->regs[i].selector = NULL;
+			continue;
+		}
+
+		expr = track->regs[i].selector;
+		data_size += expr->ops->size;
+	}
+	if (data_size == 0)
+		return 0;
+
+	data_size += offsetof(struct nft_rule_dp, data);	/* prefetch rule */
+
+	return data_size;
+}
+
+static int nft_prefetch_build(struct nft_regs_track *track,
+			      struct nft_chain *chain, void *data,
+			      void *data_boundary, unsigned int prefetch_size)
+{
+	const struct nft_expr *expr;
+	struct nft_rule_dp *prule;
+	unsigned int size = 0;
+	int i;
+
+	prule = (struct nft_rule_dp *)data;
+	data += offsetof(struct nft_rule_dp, data);
+	if (WARN_ON_ONCE(data > data_boundary))
+		return -ENOMEM;
+
+	for (i = 0; i < NFT_REG32_NUM; i++) {
+		if (!track->regs[i].selector)
+			continue;
+
+		expr = track->regs[i].selector;
+		if (WARN_ON_ONCE(data + expr->ops->size > data_boundary))
+			return -ENOMEM;
+
+		memcpy(data + size, expr, expr->ops->size);
+		size += expr->ops->size;
+	}
+
+	prule->handle = 0;
+	prule->dlen = size;
+	prule->is_last = 0;
+
+	data += size;
+	size = (unsigned long)(data - (void *)prule);
+
+	if (WARN_ON_ONCE(prefetch_size != size))
+		return -EINVAL;
+
+	return 0;
+}
+
 static bool nft_expr_reduce(struct nft_regs_track *track,
 			    const struct nft_expr *expr)
 {
@@ -8993,12 +9155,13 @@ static bool nft_expr_reduce(struct nft_regs_track *track,
 
 static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
 {
+	unsigned int size, data_size, prefetch_size;
 	const struct nft_expr *expr, *last;
 	struct nft_regs_track track = {};
-	unsigned int size, data_size;
 	void *data, *data_boundary;
 	struct nft_rule_dp *prule;
 	struct nft_rule *rule;
+	int err;
 
 	/* already handled or inactive chain? */
 	if (chain->blob_next || !nft_is_active_next(net, chain))
@@ -9013,6 +9176,9 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		}
 	}
 
+	prefetch_size = nft_prefetch_prepare(&track, chain);
+	data_size += prefetch_size;
+
 	chain->blob_next = nf_tables_chain_alloc_rules(chain, data_size);
 	if (!chain->blob_next)
 		return -ENOMEM;
@@ -9021,6 +9187,16 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 	data_boundary = data + data_size;
 	size = 0;
 
+	if (prefetch_size) {
+		err = nft_prefetch_build(&track, chain, data, data_boundary,
+					 prefetch_size);
+		if (err < 0)
+			return err;
+	}
+	chain->blob_next->prefetch_size = prefetch_size;
+
+	data += prefetch_size;
+
 	list_for_each_entry(rule, &chain->rules, list) {
 		if (!nft_is_active_next(net, rule))
 			continue;
@@ -9035,7 +9211,7 @@ static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *cha
 		nft_rule_for_each_expr(expr, last, rule) {
 			track.cur = expr;
 
-			if (nft_expr_reduce(&track, expr)) {
+			if (prefetch_size && nft_expr_reduce(&track, expr)) {
 				expr = track.cur;
 				continue;
 			}
@@ -9095,7 +9271,7 @@ static void nf_tables_commit_chain_free_rules_old(struct nft_rule_blob *blob)
 	struct nft_rule_dp_last *last;
 
 	/* last rule trailer is after end marker */
-	last = (void *)blob + sizeof(*blob) + blob->size;
+	last = (void *)blob + sizeof(*blob) + blob->prefetch_size + blob->size;
 	last->blob = blob;
 
 	call_rcu(&last->h, __nf_tables_commit_chain_free_rules);
@@ -9406,6 +9582,8 @@ static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 						       &nft_trans_chain_hooks(trans));
 				list_splice(&nft_trans_chain_hooks(trans),
 					    &nft_trans_basechain(trans)->hook_list);
+				if (nft_trans_chain_prefetch(trans))
+					swap(chain->prefetch, nft_trans_chain_prefetch(trans));
 				/* trans destroyed after rcu grace period */
 			} else {
 				nft_chain_commit_drop_policy(trans);
@@ -9662,6 +9840,10 @@ static int __nf_tables_abort(struct net *net, enum nfnl_abort_action action)
 				nft_netdev_unregister_hooks(net,
 							    &nft_trans_chain_hooks(trans),
 							    true);
+				if (nft_trans_chain_prefetch(trans)) {
+					nf_tables_rule_destroy(&trans->ctx,
+							       nft_trans_chain_prefetch(trans));
+				}
 				free_percpu(nft_trans_chain_stats(trans));
 				kfree(nft_trans_chain_name(trans));
 				nft_trans_destroy(trans);
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 2adfe443898a..37bc07b5b1e1 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -207,6 +207,7 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 }
 
 struct nft_jumpstack {
+	const struct nft_rule_blob *blob;
 	const struct nft_rule_dp *rule;
 };
 
@@ -256,6 +257,25 @@ static void expr_call_ops_eval(const struct nft_expr *expr,
              (expr) != (last); \
              (expr) = nft_rule_expr_next(expr))
 
+static void nft_do_prefetch(const struct nft_rule_blob *blob,
+			    struct nft_regs *regs, struct nft_pktinfo *pkt)
+{
+	const struct nft_expr *expr, *last;
+	const struct nft_rule_dp *rule;
+
+	regs->valid = 0;
+
+	if (!blob->prefetch_size)
+		return;
+
+	rule = (struct nft_rule_dp *)blob->data;
+	nft_rule_dp_for_each_expr(expr, last, rule) {
+		if (expr->ops != &nft_payload_fast_ops ||
+		    !nft_payload_fast_eval(expr, regs, pkt))
+			expr_call_ops_eval(expr, regs, pkt);
+	}
+}
+
 unsigned int
 nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
@@ -266,11 +286,10 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
 	bool genbit = READ_ONCE(net->nft.gencursor);
-	struct nft_rule_blob *blob;
+	const struct nft_rule_blob *blob;
 	struct nft_traceinfo info;
 	struct nft_regs regs;
 
-	regs.valid = 0;
 	info.trace = false;
 	if (static_branch_unlikely(&nft_trace_enabled))
 		nft_trace_init(&info, pkt, basechain);
@@ -280,7 +299,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	else
 		blob = rcu_dereference(chain->blob_gen_0);
 
-	rule = (struct nft_rule_dp *)blob->data;
+	nft_do_prefetch(blob, &regs, pkt);
+	rule = (struct nft_rule_dp *)(blob->data + blob->prefetch_size);
 next_rule:
 	regs.verdict.code = NFT_CONTINUE;
 	for (; !rule->is_last ; rule = nft_rule_next(rule)) {
@@ -326,6 +346,8 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NFT_JUMP:
 		if (WARN_ON_ONCE(stackptr >= NFT_JUMP_STACK_SIZE))
 			return NF_DROP;
+
+		jumpstack[stackptr].blob = blob;
 		jumpstack[stackptr].rule = nft_rule_next(rule);
 		stackptr++;
 		fallthrough;
@@ -341,7 +363,9 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 
 	if (stackptr > 0) {
 		stackptr--;
+		blob = jumpstack[stackptr].blob;
 		rule = jumpstack[stackptr].rule;
+		nft_do_prefetch(blob, &regs, pkt);
 		goto next_rule;
 	}
 
-- 
2.30.2

