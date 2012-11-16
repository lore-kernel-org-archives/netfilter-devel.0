From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 11/11] netfilter: xtables2: support nomination for chains
Date: Fri, 16 Nov 2012 02:23:45 +0100
Message-ID: <1353029025-31635-12-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45182 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab2KPBX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:58 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So far, only live chains in the master table were eligible for
promotion to a base chain. That however leaves a gap where there would
be no base chains when the table is being replaced.

With this commit, NFXTM_PROMOTE on draft chains will prepare the
nf_hook_ops structure which will be registered later at COMMIT time,
giving a seamless switchover.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h |    7 ++-
 net/netfilter/xt_core.c         |  108 +++++++++++++++++++++++++++++++--------
 net/netfilter/xt_nfnetlink.c    |   29 +++++++----
 3 files changed, 110 insertions(+), 34 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 948956d..ba52412 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -72,12 +72,14 @@ struct xt2_rcu_block {
  * @anchor:	list anchor for parent (struct xt2_table.chain_list)
  * @name:	name of chain
  * @rcu:	rcu head for delayed deletion
+ * @table:	backpointer to accompanying table
  * @ops:	registered hook operations for promoted chain
  */
 struct xt2_chain {
 	struct xt2_rcu_block __rcu *rules;
 	struct list_head anchor;
 	char name[48];
+	struct xt2_table *table;
 	struct rcu_head rcu;
 	struct nf_hook_ops *ops;
 };
@@ -114,8 +116,9 @@ extern struct xt2_chain *xt2_chain_dup(struct xt2_table *,
 				       const struct xt2_chain *);
 extern int xt2_chain_splice(struct xt2_chain *, struct xt2_rule_buffer *,
 			    unsigned int, unsigned int);
-extern int xt2_chain_promote(struct xt2_chain *,
-			     unsigned int, int, uint8_t);
+extern int xt2_chain_hook_prepare(struct xt2_chain *,
+				  unsigned int, int, uint8_t);
+extern int xt2_chain_promote(struct xt2_chain *);
 extern int xt2_chain_demote(struct xt2_chain *);
 
 extern struct xt2_table *xt2_table_new(void);
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index ddebe3f..e0e9673 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -107,8 +107,7 @@ struct xt2_pernet_data *xtables2_pernet(struct net *net)
  */
 static int
 xt2_do_table(struct sk_buff *skb, const struct xt2_chain *chain,
-	     const struct xt2_table *table, const struct net_device *in,
-	     const struct net_device *out)
+	     const struct net_device *in, const struct net_device *out)
 {
 	return NF_ACCEPT;
 }
@@ -123,12 +122,22 @@ xt2_hook_entry(struct sk_buff *skb, const struct nf_hook_ops *ops,
 {
 	struct xt2_pernet_data *pnet;
 	struct xt2_table *table;
-	unsigned int ret;
+	struct xt2_chain *chain;
+	unsigned int ret = NF_ACCEPT;
 
 	pnet  = xtables2_pernet(dev_net((in != NULL) ? in : out));
 	rcu_read_lock();
 	table = rcu_dereference(pnet->master);
-	ret   = xt2_do_table(skb, ops->priv, table, in, out);
+	chain = ops->priv;
+	/*
+	 * When a table is replaced, the old hooks may be concurrently active
+	 * with the new ones. If we are in an old hook but noticed a new table
+	 * is already present (chain->table != table), we should simply skip
+	 * evaluation of the old table and return %NF_ACCEPT.
+	 */
+	if (chain->table == table)
+		ret = xt2_do_table(skb, chain, in, out);
+
 	rcu_read_unlock();
 	return ret;
 }
@@ -303,8 +312,10 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 	 * Something to avoid the chain becoming part of the list before
 	 * the members are initialized...
 	 */
-	if (table != NULL)
+	if (table != NULL) {
+		chain->table = table;
 		list_add_tail_rcu(&chain->anchor, &table->chain_list);
+	}
 	return chain;
 }
 
@@ -532,22 +543,48 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 	return 0;
 }
 
+/*
+ * A chain can have multiple properties:
+ *
+ * 1. Be located either in a draft table (as part of an active
+ *    NFXTM_TABLE_REPLACE transaction), or be in the master table.
+ *    Shown as 'd' and 'M'.
+ *
+ * 2. Have the hook_ops prepared (chain->ops != NULL, 'h'),
+ *    having the hook_ops registered and thus active ('H'), or neither ('n').
+ *
+ * digraph {
+ * 	new -> dn; new -> mn;
+ * 	// Also: {allstates} -> deleted
+ *
+ * 	subgraph cluster_0 {
+ * 		dn -> dh; // PROMOTE nlmsg (calls prepare_hook)
+ * 		dh -> dn; // DEMOTE nlmsg (calls demote)
+ * 	};
+ * 	subgraph cluster_1 {
+ * 		// These involve an implicit intermediate Mh state
+ * 		Mn -> MH; // PROMOTE nlsmg (calls prepare_hook and promote)
+ * 		MH -> Mn; // DEMOTE nlmsg (calls demote)
+ * 	};
+ * 	dn -> mn; // inert chain during COMMIT
+ *	dh -> MH; // COMMIT nlmsg for TABLE_REPLACE (calls promote)
+ * };
+ */
+
 /**
  * @h_index:	the hook number (%NF_INET_*, ...)
  * @h_prio:	priority for the new hook
  * @h_proto:	family to insert hook for (%NFPROTO_*)
  *
- * Turn a normal chain into a base chain, i.e. add a hook for it. This should
- * only be used with chains in the master table, to avoid surprises, namely,
- * that rules from a table are executed that is not committed yet and may go
- * away at any time.
+ * Prepare the nf_hook_ops struct, and only that. The chain might live in an
+ * anonymous table (as part of an ongoing NFXTM_TABLE_REPLACE transaction), so
+ * do not hook it up yet.
  * Caller should hold table lock to guard against racing chain->ops setup.
  */
-int xt2_chain_promote(struct xt2_chain *chain, unsigned int h_index,
-		      int h_prio, uint8_t h_proto)
+int xt2_chain_hook_prepare(struct xt2_chain *chain, unsigned int h_index,
+			   int h_prio, uint8_t h_proto)
 {
 	struct nf_hook_ops *ops;
-	int ret;
 
 	if (chain->ops != NULL)
 		return -EEXIST;
@@ -560,24 +597,44 @@ int xt2_chain_promote(struct xt2_chain *chain, unsigned int h_index,
 	ops->priority = h_prio;
 	ops->priv     = chain;
 	ops->owner    = THIS_MODULE;
-	ret = nf_register_hook(ops);
-	if (ret < 0)
-		kfree(ops);
+	return 0;
+}
+
+/**
+ * Turn a normal chain into a base chain, i.e. add a hook for it. Caller should
+ * have used xt2_chain_hook_prepare before. Caller should hold table lock.
+ */
+int xt2_chain_promote(struct xt2_chain *chain)
+{
+	int ret;
+
+	if (chain->ops == NULL) {
+		WARN_ON(chain->ops == NULL);
+		return -EINVAL;
+	}
+
+	ret = nf_register_hook(chain->ops);
+	/*
+	 * We really really need just one bit. So rather than clogging struct
+	 * xt2_chain with another member, use a trick like rbtree color.
+	 */
+	if (ret == 0)
+		chain->ops = (void *)((uintptr_t)chain->ops | 1);
 	return ret;
 }
 
 /**
- * "Demote" a base chain to a normal chain. There are no other requirements
- * to removing the hook_ops.
- * Caller has to hold the table lock.
+ * "Demote" a base chain to a normal chain. Caller has to hold the table lock.
  */
 int xt2_chain_demote(struct xt2_chain *chain)
 {
 	if (chain->ops == NULL)
 		return -ENOENT;
-
-	nf_unregister_hook(chain->ops);
-	/* nf_unregister_hook already does RCU, so the following is safe. */
+	if ((uintptr_t)chain->ops & 1) {
+		chain->ops = (void *)((uintptr_t)chain->ops & ~1);
+		nf_unregister_hook(chain->ops);
+	}
+	/* nf_unregister_hook already does RCU, so the free is safe. */
 	kfree(chain->ops);
 	chain->ops = NULL;
 	return 0;
@@ -630,13 +687,22 @@ struct xt2_table *xt2_table_dup(const struct xt2_table *old_table)
 struct xt2_table *
 xt2_table_replace(struct xt2_pernet_data *pnet, struct xt2_table *new_table)
 {
+	struct xt2_chain *chain;
 	struct xt2_table *old_table;
 
+	list_for_each_entry(chain, &new_table->chain_list, anchor)
+		if (chain->ops != NULL)
+			xt2_chain_promote(chain);
+
 	mutex_lock(&pnet->master_lock);
 	old_table = pnet->master;
 	rcu_assign_pointer(pnet->master, new_table);
 	mutex_unlock(&pnet->master_lock);
 
+	list_for_each_entry(chain, &old_table->chain_list, anchor)
+		if (chain->ops != NULL)
+			xt2_chain_demote(chain);
+
 	return old_table;
 }
 
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 9fcf64b..11c659a 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -710,7 +710,8 @@ static int xtnetlink_chain_promote(struct sock *xtnl, struct sk_buff *iskb,
 	struct xtnetlink_transact *xa;
 	struct xt2_table *table;
 	struct xt2_chain *chain;
-	int ret;
+	unsigned int hook_index, hook_proto;
+	int hook_prio, ret;
 
 	if (attr[NFXTA_NAME] == NULL || attr[NFXTA_HOOK_INDEX] == NULL ||
 	    attr[NFXTA_HOOK_PRIORITY] == NULL ||
@@ -722,18 +723,24 @@ static int xtnetlink_chain_promote(struct sock *xtnl, struct sk_buff *iskb,
 	chain = xt2_chain_lookup(table, nla_data(attr[NFXTA_NAME]));
 	if (chain == NULL) {
 		ret = NFXTE_CHAIN_NOENT;
-	} else if (xa != NULL) {
-		ret = NFXTE_TRANSACT_ACTIVE;
-		/* Formal promotion of temporary chains in next patch. */
-	} else {
-		unsigned int h_index = nla_get_u32(attr[NFXTA_HOOK_INDEX]);
-		int h_prio = nla_get_u32(attr[NFXTA_HOOK_PRIORITY]);
-		uint8_t h_proto = nla_get_u8(attr[NFXTA_HOOK_NFPROTO]);
+	}
 
-		ret = xt2_chain_promote(chain, h_index, h_prio, h_proto);
-		if (ret == -EEXIST)
-			ret = NFXTE_CHAIN_PROMOSTATUS;
+	hook_index = nla_get_u32(attr[NFXTA_HOOK_INDEX]);
+	hook_prio = nla_get_u32(attr[NFXTA_HOOK_PRIORITY]);
+	hook_proto = nla_get_u8(attr[NFXTA_HOOK_NFPROTO]);
+
+	ret = xt2_chain_hook_prepare(chain, hook_index, hook_prio, hook_proto);
+	if (ret == -EEXIST) {
+		xtnetlink_table_wput(xa, sock_net(xtnl), table);
+		return xtnetlink_error(&ref, NFXTE_CHAIN_PROMOSTATUS);
 	}
+	if (xa == NULL)
+		/*
+		 * Chain in master table - promote now. For draft chains,
+		 * promotion is done at commit time, in xt2_table_replace.
+		 */
+		ret = xt2_chain_promote(chain);
+
 	xtnetlink_table_wput(xa, sock_net(xtnl), table);
 	return xtnetlink_error(&ref, ret);
 }
-- 
1.7.10.4

