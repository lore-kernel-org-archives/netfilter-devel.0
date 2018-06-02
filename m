From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 05/20] netfilter: nf_tables: remove synchronize_rcu in commit phase
Date: Sat,  2 Jun 2018 02:22:44 +0200
Message-ID: <20180602002259.4024-6-pablo@netfilter.org>
References: <20180602002259.4024-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180602002259.4024-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

synchronize_rcu() is expensive.

The commit phase currently enforces an unconditional
synchronize_rcu() after incrementing the generation counter.

This is to make sure that a packet always sees a consistent chain, either
nft_do_chain is still using old generation (it will skip the newly added
rules), or the new one (it will skip old ones that might still be linked
into the list).

We could just remove the synchronize_rcu(), it would not cause a crash but
it could cause us to evaluate a rule that was removed and new rule for the
same packet, instead of either-or.

To resolve this, add rule pointer array holding two generations, the
current one and the future generation.

In commit phase, allocate the rule blob and populate it with the rules that
will be active in the new generation.

Then, make this rule blob public, replacing the old generation pointer.

Then the generation counter can be incremented.

nft_do_chain() will either continue to use the current generation
(in case loop was invoked right before increment), or the new one.

Suggested-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/net/netfilter/nf_tables.h |   5 +
 net/netfilter/nf_tables_api.c     | 204 ++++++++++++++++++++++++++++++++++++--
 net/netfilter/nf_tables_core.c    |  24 +++--
 3 files changed, 215 insertions(+), 18 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 603b51401deb..6b9ddb99f3a8 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -858,6 +858,8 @@ enum nft_chain_flags {
  *	@name: name of the chain
  */
 struct nft_chain {
+	struct nft_rule			*__rcu *rules_gen_0;
+	struct nft_rule			*__rcu *rules_gen_1;
 	struct list_head		rules;
 	struct list_head		list;
 	struct nft_table		*table;
@@ -867,6 +869,9 @@ struct nft_chain {
 	u8				flags:6,
 					genmask:2;
 	char				*name;
+
+	/* Only used during control plane commit phase: */
+	struct nft_rule			**rules_next;
 };
 
 enum nft_chain_types {
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index 87b2a77add65..583673743648 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -1237,12 +1237,29 @@ static void nft_chain_stats_replace(struct nft_base_chain *chain,
 		rcu_assign_pointer(chain->stats, newstats);
 }
 
+static void nf_tables_chain_free_chain_rules(struct nft_chain *chain)
+{
+	struct nft_rule **g0 = rcu_dereference_raw(chain->rules_gen_0);
+	struct nft_rule **g1 = rcu_dereference_raw(chain->rules_gen_1);
+
+	if (g0 != g1)
+		kvfree(g1);
+	kvfree(g0);
+
+	/* should be NULL either via abort or via successful commit */
+	WARN_ON_ONCE(chain->rules_next);
+	kvfree(chain->rules_next);
+}
+
 static void nf_tables_chain_destroy(struct nft_ctx *ctx)
 {
 	struct nft_chain *chain = ctx->chain;
 
 	BUG_ON(chain->use > 0);
 
+	/* no concurrent access possible anymore */
+	nf_tables_chain_free_chain_rules(chain);
+
 	if (nft_is_base_chain(chain)) {
 		struct nft_base_chain *basechain = nft_base_chain(chain);
 
@@ -1335,6 +1352,27 @@ static void nft_chain_release_hook(struct nft_chain_hook *hook)
 	module_put(hook->type->owner);
 }
 
+struct nft_rules_old {
+	struct rcu_head h;
+	struct nft_rule **start;
+};
+
+static struct nft_rule **nf_tables_chain_alloc_rules(const struct nft_chain *chain,
+						     unsigned int alloc)
+{
+	if (alloc > INT_MAX)
+		return NULL;
+
+	alloc += 1;	/* NULL, ends rules */
+	if (sizeof(struct nft_rule *) > INT_MAX / alloc)
+		return NULL;
+
+	alloc *= sizeof(struct nft_rule *);
+	alloc += sizeof(struct nft_rules_old);
+
+	return kvmalloc(alloc, GFP_KERNEL);
+}
+
 static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 			      u8 policy, bool create)
 {
@@ -1344,6 +1382,7 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 	struct nft_stats __percpu *stats;
 	struct net *net = ctx->net;
 	struct nft_chain *chain;
+	struct nft_rule **rules;
 	int err;
 
 	if (table->use == UINT_MAX)
@@ -1406,6 +1445,16 @@ static int nf_tables_addchain(struct nft_ctx *ctx, u8 family, u8 genmask,
 		goto err1;
 	}
 
+	rules = nf_tables_chain_alloc_rules(chain, 0);
+	if (!rules) {
+		err = -ENOMEM;
+		goto err1;
+	}
+
+	*rules = NULL;
+	rcu_assign_pointer(chain->rules_gen_0, rules);
+	rcu_assign_pointer(chain->rules_gen_1, rules);
+
 	err = nf_tables_register_hook(net, table, chain);
 	if (err < 0)
 		goto err1;
@@ -5850,21 +5899,162 @@ static void nf_tables_commit_release(struct net *net)
 	}
 }
 
+static int nf_tables_commit_chain_prepare(struct net *net, struct nft_chain *chain)
+{
+	struct nft_rule *rule;
+	unsigned int alloc = 0;
+	int i;
+
+	/* already handled or inactive chain? */
+	if (chain->rules_next || !nft_is_active_next(net, chain))
+		return 0;
+
+	rule = list_entry(&chain->rules, struct nft_rule, list);
+	i = 0;
+
+	list_for_each_entry_continue(rule, &chain->rules, list) {
+		if (nft_is_active_next(net, rule))
+			alloc++;
+	}
+
+	chain->rules_next = nf_tables_chain_alloc_rules(chain, alloc);
+	if (!chain->rules_next)
+		return -ENOMEM;
+
+	list_for_each_entry_continue(rule, &chain->rules, list) {
+		if (nft_is_active_next(net, rule))
+			chain->rules_next[i++] = rule;
+	}
+
+	chain->rules_next[i] = NULL;
+	return 0;
+}
+
+static void nf_tables_commit_chain_prepare_cancel(struct net *net)
+{
+	struct nft_trans *trans, *next;
+
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		struct nft_chain *chain = trans->ctx.chain;
+
+		if (trans->msg_type == NFT_MSG_NEWRULE ||
+		    trans->msg_type == NFT_MSG_DELRULE) {
+			kvfree(chain->rules_next);
+			chain->rules_next = NULL;
+		}
+	}
+}
+
+static void __nf_tables_commit_chain_free_rules_old(struct rcu_head *h)
+{
+	struct nft_rules_old *o = container_of(h, struct nft_rules_old, h);
+
+	kvfree(o->start);
+}
+
+static void nf_tables_commit_chain_free_rules_old(struct nft_rule **rules)
+{
+	struct nft_rule **r = rules;
+	struct nft_rules_old *old;
+
+	while (*r)
+		r++;
+
+	r++;	/* rcu_head is after end marker */
+	old = (void *) r;
+	old->start = rules;
+
+	call_rcu(&old->h, __nf_tables_commit_chain_free_rules_old);
+}
+
+static void nf_tables_commit_chain_active(struct net *net, struct nft_chain *chain)
+{
+	struct nft_rule **g0, **g1;
+	bool next_genbit;
+
+	next_genbit = nft_gencursor_next(net);
+
+	g0 = rcu_dereference_protected(chain->rules_gen_0,
+				       lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+	g1 = rcu_dereference_protected(chain->rules_gen_1,
+				       lockdep_nfnl_is_held(NFNL_SUBSYS_NFTABLES));
+
+	/* No changes to this chain? */
+	if (chain->rules_next == NULL) {
+		/* chain had no change in last or next generation */
+		if (g0 == g1)
+			return;
+		/*
+		 * chain had no change in this generation; make sure next
+		 * one uses same rules as current generation.
+		 */
+		if (next_genbit) {
+			rcu_assign_pointer(chain->rules_gen_1, g0);
+			nf_tables_commit_chain_free_rules_old(g1);
+		} else {
+			rcu_assign_pointer(chain->rules_gen_0, g1);
+			nf_tables_commit_chain_free_rules_old(g0);
+		}
+
+		return;
+	}
+
+	if (next_genbit)
+		rcu_assign_pointer(chain->rules_gen_1, chain->rules_next);
+	else
+		rcu_assign_pointer(chain->rules_gen_0, chain->rules_next);
+
+	chain->rules_next = NULL;
+
+	if (g0 == g1)
+		return;
+
+	if (next_genbit)
+		nf_tables_commit_chain_free_rules_old(g1);
+	else
+		nf_tables_commit_chain_free_rules_old(g0);
+}
+
 static int nf_tables_commit(struct net *net, struct sk_buff *skb)
 {
 	struct nft_trans *trans, *next;
 	struct nft_trans_elem *te;
+	struct nft_chain *chain;
+	struct nft_table *table;
 
-	/* Bump generation counter, invalidate any dump in progress */
-	while (++net->nft.base_seq == 0);
+	/* 1.  Allocate space for next generation rules_gen_X[] */
+	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
+		int ret;
 
-	/* A new generation has just started */
-	net->nft.gencursor = nft_gencursor_next(net);
+		if (trans->msg_type == NFT_MSG_NEWRULE ||
+		    trans->msg_type == NFT_MSG_DELRULE) {
+			chain = trans->ctx.chain;
+
+			ret = nf_tables_commit_chain_prepare(net, chain);
+			if (ret < 0) {
+				nf_tables_commit_chain_prepare_cancel(net);
+				return ret;
+			}
+		}
+	}
 
-	/* Make sure all packets have left the previous generation before
-	 * purging old rules.
+	/* step 2.  Make rules_gen_X visible to packet path */
+	list_for_each_entry(table, &net->nft.tables, list) {
+		list_for_each_entry(chain, &table->chains, list) {
+			if (!nft_is_active_next(net, chain))
+				continue;
+			nf_tables_commit_chain_active(net, chain);
+		}
+	}
+
+	/*
+	 * Bump generation counter, invalidate any dump in progress.
+	 * Cannot fail after this point.
 	 */
-	synchronize_rcu();
+	while (++net->nft.base_seq == 0);
+
+	/* step 3. Start new generation, rules_gen_X now in use. */
+	net->nft.gencursor = nft_gencursor_next(net);
 
 	list_for_each_entry_safe(trans, next, &net->nft.commit_list, list) {
 		switch (trans->msg_type) {
diff --git a/net/netfilter/nf_tables_core.c b/net/netfilter/nf_tables_core.c
index 4f46d2f4e167..0548cd50ec26 100644
--- a/net/netfilter/nf_tables_core.c
+++ b/net/netfilter/nf_tables_core.c
@@ -133,7 +133,7 @@ static noinline void nft_update_chain_stats(const struct nft_chain *chain,
 
 struct nft_jumpstack {
 	const struct nft_chain	*chain;
-	const struct nft_rule	*rule;
+	struct nft_rule	*const *rules;
 };
 
 unsigned int
@@ -141,27 +141,29 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 {
 	const struct nft_chain *chain = priv, *basechain = chain;
 	const struct net *net = nft_net(pkt);
+	struct nft_rule *const *rules;
 	const struct nft_rule *rule;
 	const struct nft_expr *expr, *last;
 	struct nft_regs regs;
 	unsigned int stackptr = 0;
 	struct nft_jumpstack jumpstack[NFT_JUMP_STACK_SIZE];
-	unsigned int gencursor = nft_genmask_cur(net);
+	bool genbit = READ_ONCE(net->nft.gencursor);
 	struct nft_traceinfo info;
 
 	info.trace = false;
 	if (static_branch_unlikely(&nft_trace_enabled))
 		nft_trace_init(&info, pkt, &regs.verdict, basechain);
 do_chain:
-	rule = list_entry(&chain->rules, struct nft_rule, list);
+	if (genbit)
+		rules = rcu_dereference(chain->rules_gen_1);
+	else
+		rules = rcu_dereference(chain->rules_gen_0);
+
 next_rule:
+	rule = *rules;
 	regs.verdict.code = NFT_CONTINUE;
-	list_for_each_entry_continue_rcu(rule, &chain->rules, list) {
-
-		/* This rule is not active, skip. */
-		if (unlikely(rule->genmask & gencursor))
-			continue;
-
+	for (; *rules ; rules++) {
+		rule = *rules;
 		nft_rule_for_each_expr(expr, last, rule) {
 			if (expr->ops == &nft_cmp_fast_ops)
 				nft_cmp_fast_eval(expr, &regs);
@@ -199,7 +201,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	case NFT_JUMP:
 		BUG_ON(stackptr >= NFT_JUMP_STACK_SIZE);
 		jumpstack[stackptr].chain = chain;
-		jumpstack[stackptr].rule  = rule;
+		jumpstack[stackptr].rules = rules + 1;
 		stackptr++;
 		/* fall through */
 	case NFT_GOTO:
@@ -221,7 +223,7 @@ nft_do_chain(struct nft_pktinfo *pkt, void *priv)
 	if (stackptr > 0) {
 		stackptr--;
 		chain = jumpstack[stackptr].chain;
-		rule  = jumpstack[stackptr].rule;
+		rules = jumpstack[stackptr].rules;
 		goto next_rule;
 	}
 
-- 
2.11.0
