From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 3/8] netfilter: xtables2: store netns in table and rule blob
Date: Tue,  4 Dec 2012 02:00:44 +0100
Message-ID: <1354582849-26888-4-git-send-email-jengelh@inai.de>
References: <1354582849-26888-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:49565 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497Ab2LDBA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Dec 2012 20:00:58 -0500
In-Reply-To: <1354582849-26888-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The destroy and checkentry functions for matches and targets want to
know the network namespace, so it needs to be made available to those.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h |    9 +++++++++
 net/netfilter/xt_core.c         |   18 +++++++++++++++++-
 2 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index a5b3ab6..9e79f77 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -95,10 +95,14 @@ struct xt2_pernet_data {
 /**
  * @chain_list:		list of chains (struct xt2_chain)
  * @lock:		protecting changes to @chain_list
+ * @netns:		network namespace this table belongs to
  */
 struct xt2_table {
 	struct list_head chain_list;
 	struct mutex lock;
+#if IS_ENABLED(CONFIG_NET_NS)
+	struct net *netns;
+#endif
 };
 
 /**
@@ -107,12 +111,17 @@ struct xt2_table {
  * structure, we also follow up on the xt2_p_chain idea from the commit
  * "netfilter: xtables2: chain renaming support", i.e. jumps and gotos will
  * always point to the chain while the "rules" pointer can change.
+ *
+ * @netns:		network namespace this table belongs to
  */
 struct xt2_rule_block {
 	union {
 		struct rcu_head rcu;
 		struct work_struct work;
 	};
+#if IS_ENABLED(CONFIG_NET_NS)
+	struct net *netns;
+#endif
 	size_t size;
 	char data[] __xt_int_aligned;
 };
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 4bde992..865da3b 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -29,6 +29,14 @@
 	     (rule) != NULL && (rule) < xt2_chain_stop_rule(chain); \
 	     (rule) = xt2_chain_next_rule(rule))
 
+#if IS_ENABLED(CONFIG_NET_NS)
+#	define xt2_net_get(net) (net)
+#	define xt2_net_set(obj, net) do { (obj) = (net); } while (false)
+#else
+#	define xt2_net_get(net) NULL
+#	define xt2_net_set(obj, net) do { (obj) = (net); } while (false)
+#endif
+
 /**
  * The rule buffer, which collects multiple prototype rules for use with
  * xt2_chain_splice(). While there is only one member here, struct
@@ -437,6 +445,8 @@ xt2_chain_dup(struct xt2_table *new_table, const struct xt2_chain *old)
 		xt2_chain_free(chain);
 		return ERR_PTR(ret);
 	}
+	if (old->rules != NULL && chain->rules != NULL)
+		xt2_net_set(chain->rules->netns, old->rules->netns);
 	return chain;
 }
 
@@ -576,6 +586,8 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 		if (spl.b_insert != 0 || !list_empty(spl.rule_list))
 			/* Should not happen, but safe guards are cool. */
 			return -EOVERFLOW;
+	} else {
+		xt2_net_set(blob->netns, chain->table->netns);
 	}
 
 	/* Read proto rules and stream them into the blob. */
@@ -690,7 +702,8 @@ int xt2_chain_demote(struct xt2_chain *chain)
 }
 
 /**
- * Create a new table with no chains and no rules.
+ * Create a new table with no chains and no rules. The caller should set
+ * the namespace to which it belongs.
  */
 struct xt2_table *xt2_table_new(void)
 {
@@ -702,6 +715,7 @@ struct xt2_table *xt2_table_new(void)
 
 	mutex_init(&table->lock);
 	INIT_LIST_HEAD(&table->chain_list);
+	table->netns = NULL;
 	return table;
 }
 
@@ -739,6 +753,7 @@ xt2_table_replace(struct xt2_pernet_data *pnet, struct xt2_table *new_table)
 	struct xt2_chain *chain;
 	struct xt2_table *old_table;
 
+	xt2_net_set(new_table->netns, pnet->master->netns);
 	list_for_each_entry(chain, &new_table->chain_list, anchor)
 		if (chain->ops != NULL)
 			xt2_chain_promote(chain);
@@ -763,6 +778,7 @@ static int __net_init xtables2_net_init(struct net *net)
 	pnet->master = xt2_table_new();
 	if (IS_ERR(pnet->master))
 		return PTR_ERR(pnet->master);
+	pnet->master->netns = net;
 	return 0;
 }
 
-- 
1.7.10.4

