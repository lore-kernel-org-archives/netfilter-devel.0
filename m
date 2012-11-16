From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 10/11] netfilter: xtables2: base chain functionality
Date: Fri, 16 Nov 2012 02:23:44 +0100
Message-ID: <1353029025-31635-11-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45181 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522Ab2KPBX6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:58 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Xtables1 had tables (which corresponded to priority sets, e.g. nat was
at NF_IP_PRI_NAT_SRC & -DST) and special base chains that correspond
to a certain hook priority.

There is however nothing special about these tables or chains, so in
Xtables2, the idea of different tables is done away, and any chain may
be promoted to a base chain. All that is needed is to specify when it
is to run.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    5 ++
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   14 +++
 net/netfilter/xt_core.c                          |  101 ++++++++++++++++++++--
 net/netfilter/xt_nfnetlink.c                     |   88 +++++++++++++++++++
 4 files changed, 203 insertions(+), 5 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index ae55b3b..948956d 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -72,12 +72,14 @@ struct xt2_rcu_block {
  * @anchor:	list anchor for parent (struct xt2_table.chain_list)
  * @name:	name of chain
  * @rcu:	rcu head for delayed deletion
+ * @ops:	registered hook operations for promoted chain
  */
 struct xt2_chain {
 	struct xt2_rcu_block __rcu *rules;
 	struct list_head anchor;
 	char name[48];
 	struct rcu_head rcu;
+	struct nf_hook_ops *ops;
 };
 
 /**
@@ -112,6 +114,9 @@ extern struct xt2_chain *xt2_chain_dup(struct xt2_table *,
 				       const struct xt2_chain *);
 extern int xt2_chain_splice(struct xt2_chain *, struct xt2_rule_buffer *,
 			    unsigned int, unsigned int);
+extern int xt2_chain_promote(struct xt2_chain *,
+			     unsigned int, int, uint8_t);
+extern int xt2_chain_demote(struct xt2_chain *);
 
 extern struct xt2_table *xt2_table_new(void);
 extern void xt2_table_free(struct xt2_table *);
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 2ffbf60..ac60d70 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -16,6 +16,8 @@
  * %NFXTM_TABLE_DUMP:	retrieve table (multiple chains) and their rules
  * %NFXTM_CHAIN_SPLICE:	start a splice transaction; modify rules of a chain
  * %NFXTM_RULE_ENTRY:	used to convey rule data (during both splice and dump)
+ * %NFXTM_CHAIN_PROMOTE:attach nf_hook_ops to this chain
+ * %NFXTM_CHAIN_DEMOTE:	deactivate nf_hook_ops on this chain
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -30,6 +32,8 @@ enum nfxt_msg_type {
 	NFXTM_TABLE_DUMP,
 	NFXTM_CHAIN_SPLICE,
 	NFXTM_RULE_ENTRY,
+	NFXTM_CHAIN_PROMOTE,
+	NFXTM_CHAIN_DEMOTE,
 };
 
 /**
@@ -41,6 +45,10 @@ enum nfxt_msg_type {
  * %NFXTA_REVISION_MAX:		maximum API revision supported by xtnetlink
  * %NFXTA_SPLICE_OFFSET:	rule number to start deletion from
  * %NFXTA_SPLICE_DLENGTH:	delete this many rules
+ * %NFXTA_HOOK_INDEX:		for base chains: the hook number
+ * 				(%NF_INET_*, %NF_ARP_*, %NF_BRIDGE_*, ...)
+ * %NFXTA_HOOK_PRIORITY:	(base chains:) priority for the hook
+ * %NFXTA_HOOK_NFPROTO:		(base chains:) nfproto to add the hook for
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
@@ -52,6 +60,9 @@ enum nfxt_attr_type {
 	NFXTA_REVISION_MAX,
 	NFXTA_SPLICE_OFFSET,
 	NFXTA_SPLICE_DLENGTH,
+	NFXTA_HOOK_INDEX,
+	NFXTA_HOOK_PRIORITY,
+	NFXTA_HOOK_NFPROTO,
 };
 
 /**
@@ -65,6 +76,8 @@ enum nfxt_attr_type {
  * %NFXTE_TRANSACT_ACTIVE:	Attempted to start transaction while one was
  * 				already active
  * %NFXTE_TRANSACT_INACTIVE:	Commit issued when no transaction active
+ * %NFXTE_CHAIN_PROMOSTATUS:	Chain is already at the desired
+ * 				promoted/demoted status
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
@@ -75,6 +88,7 @@ enum nfxt_errno {
 	NFXTE_CHAIN_NAMETOOLONG,
 	NFXTE_TRANSACT_ACTIVE,
 	NFXTE_TRANSACT_INACTIVE,
+	NFXTE_CHAIN_PROMOSTATUS,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 7b5d48d..ddebe3f 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -96,6 +96,44 @@ struct xt2_pernet_data *xtables2_pernet(struct net *net)
 }
 
 /**
+ * @skb:	packet to process
+ * @chain:	chain to begin traversal at
+ * @table:	table that @chain belongs to
+ * @in:		interface through which @skb was received, if any (or %NULL)
+ * @out:	interface through which @skb will leave, if any (or %NULL)
+ * @ops:	netfilter hook that got us here, if any
+ *
+ * Feed a packet through the ruleset. Caller should have entered RCU.
+ */
+static int
+xt2_do_table(struct sk_buff *skb, const struct xt2_chain *chain,
+	     const struct xt2_table *table, const struct net_device *in,
+	     const struct net_device *out)
+{
+	return NF_ACCEPT;
+}
+
+/**
+ * Hook entry point for standard table traversal.
+ */
+static unsigned int
+xt2_hook_entry(struct sk_buff *skb, const struct nf_hook_ops *ops,
+	       const struct net_device *in, const struct net_device *out,
+	       int (*okfn)(struct sk_buff *))
+{
+	struct xt2_pernet_data *pnet;
+	struct xt2_table *table;
+	unsigned int ret;
+
+	pnet  = xtables2_pernet(dev_net((in != NULL) ? in : out));
+	rcu_read_lock();
+	table = rcu_dereference(pnet->master);
+	ret   = xt2_do_table(skb, ops->priv, table, in, out);
+	rcu_read_unlock();
+	return ret;
+}
+
+/**
  * Creates a prototype rule. These use linked lists during genesis so that we
  * do not need to realloc over and over while adding matches and targets.
  */
@@ -258,6 +296,7 @@ struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
 	else
 		*chain->name = '\0';
 	chain->name[sizeof(chain->name)-1] = '\0';
+	chain->ops = NULL;
 	chain->rules = NULL;
 	/*
 	 * Do we need wmb() or something else here at this spot?
@@ -299,6 +338,7 @@ static void xt2_chain_free_rcu(struct rcu_head *rcu)
 
 void xt2_chain_free(struct xt2_chain *chain)
 {
+	xt2_chain_demote(chain);
 	list_del_rcu(&chain->anchor);
 	call_rcu(&chain->rcu, xt2_chain_free_rcu);
 }
@@ -493,6 +533,57 @@ int xt2_chain_splice(struct xt2_chain *chain, struct xt2_rule_buffer *rulebuf,
 }
 
 /**
+ * @h_index:	the hook number (%NF_INET_*, ...)
+ * @h_prio:	priority for the new hook
+ * @h_proto:	family to insert hook for (%NFPROTO_*)
+ *
+ * Turn a normal chain into a base chain, i.e. add a hook for it. This should
+ * only be used with chains in the master table, to avoid surprises, namely,
+ * that rules from a table are executed that is not committed yet and may go
+ * away at any time.
+ * Caller should hold table lock to guard against racing chain->ops setup.
+ */
+int xt2_chain_promote(struct xt2_chain *chain, unsigned int h_index,
+		      int h_prio, uint8_t h_proto)
+{
+	struct nf_hook_ops *ops;
+	int ret;
+
+	if (chain->ops != NULL)
+		return -EEXIST;
+	ops = chain->ops = kmalloc(sizeof(*ops), GFP_KERNEL);
+	if (ops == NULL)
+		return -ENOMEM;
+	ops->hook     = xt2_hook_entry;
+	ops->pf       = h_proto;
+	ops->hooknum  = h_index;
+	ops->priority = h_prio;
+	ops->priv     = chain;
+	ops->owner    = THIS_MODULE;
+	ret = nf_register_hook(ops);
+	if (ret < 0)
+		kfree(ops);
+	return ret;
+}
+
+/**
+ * "Demote" a base chain to a normal chain. There are no other requirements
+ * to removing the hook_ops.
+ * Caller has to hold the table lock.
+ */
+int xt2_chain_demote(struct xt2_chain *chain)
+{
+	if (chain->ops == NULL)
+		return -ENOENT;
+
+	nf_unregister_hook(chain->ops);
+	/* nf_unregister_hook already does RCU, so the following is safe. */
+	kfree(chain->ops);
+	chain->ops = NULL;
+	return 0;
+}
+
+/**
  * Create a new table with no chains and no rules.
  */
 struct xt2_table *xt2_table_new(void)
@@ -537,16 +628,16 @@ struct xt2_table *xt2_table_dup(const struct xt2_table *old_table)
 }
 
 struct xt2_table *
-xt2_table_replace(struct xt2_pernet_data *pnet, struct xt2_table *new)
+xt2_table_replace(struct xt2_pernet_data *pnet, struct xt2_table *new_table)
 {
-	struct xt2_table *old;
+	struct xt2_table *old_table;
 
 	mutex_lock(&pnet->master_lock);
-	old = pnet->master;
-	rcu_assign_pointer(pnet->master, new);
+	old_table = pnet->master;
+	rcu_assign_pointer(pnet->master, new_table);
 	mutex_unlock(&pnet->master_lock);
 
-	return old;
+	return old_table;
 }
 
 static int __net_init xtables2_net_init(struct net *net)
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 26a8c51..9fcf64b 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -697,6 +697,81 @@ static int xtnetlink_chain_splice(struct sock *xtnl, struct sk_buff *iskb,
 	return -ENOMEM;
 }
 
+/**
+ * Promote a normal chain to a base chain. This means that it will be hooked
+ * into Netfilter and thus starts being executed.
+ */
+static int xtnetlink_chain_promote(struct sock *xtnl, struct sk_buff *iskb,
+				   const struct nlmsghdr *imsg,
+				   const struct nlattr *const *attr)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
+	struct xt2_table *table;
+	struct xt2_chain *chain;
+	int ret;
+
+	if (attr[NFXTA_NAME] == NULL || attr[NFXTA_HOOK_INDEX] == NULL ||
+	    attr[NFXTA_HOOK_PRIORITY] == NULL ||
+	    attr[NFXTA_HOOK_NFPROTO] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+
+	table = xtnetlink_table_wget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
+	chain = xt2_chain_lookup(table, nla_data(attr[NFXTA_NAME]));
+	if (chain == NULL) {
+		ret = NFXTE_CHAIN_NOENT;
+	} else if (xa != NULL) {
+		ret = NFXTE_TRANSACT_ACTIVE;
+		/* Formal promotion of temporary chains in next patch. */
+	} else {
+		unsigned int h_index = nla_get_u32(attr[NFXTA_HOOK_INDEX]);
+		int h_prio = nla_get_u32(attr[NFXTA_HOOK_PRIORITY]);
+		uint8_t h_proto = nla_get_u8(attr[NFXTA_HOOK_NFPROTO]);
+
+		ret = xt2_chain_promote(chain, h_index, h_prio, h_proto);
+		if (ret == -EEXIST)
+			ret = NFXTE_CHAIN_PROMOSTATUS;
+	}
+	xtnetlink_table_wput(xa, sock_net(xtnl), table);
+	return xtnetlink_error(&ref, ret);
+}
+
+/**
+ * The other half for base chains: demotion.
+ */
+static int xtnetlink_chain_demote(struct sock *xtnl, struct sk_buff *iskb,
+				  const struct nlmsghdr *imsg,
+				  const struct nlattr *const *attr)
+{
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
+	struct xt2_table *table;
+	struct xt2_chain *chain;
+	int ret;
+
+	if (attr[NFXTA_NAME] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+
+	table = xtnetlink_table_wget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
+	chain = xt2_chain_lookup(table, nla_data(attr[NFXTA_NAME]));
+	if (chain == NULL) {
+		ret = NFXTE_CHAIN_NOENT;
+	} else if (xa != NULL) {
+		/* Chains in the draft table are never promoted. */
+		ret = NFXTE_CHAIN_PROMOSTATUS;
+	} else {
+		ret = xt2_chain_demote(chain);
+		if (ret == -ENOENT)
+			ret = NFXTE_CHAIN_PROMOSTATUS;
+	}
+	xtnetlink_table_wput(xa, sock_net(xtnl), table);
+	return xtnetlink_error(&ref, ret);
+}
+
 static int xtnetlink_commit_rules(const struct xtnetlink_pktref *ref,
 				  struct xtnetlink_transact *xa_rule)
 {
@@ -867,6 +942,14 @@ xtnetlink_emit_chain(struct sk_buff *skb, struct netlink_callback *nl_cb)
 	msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_CHAIN_DUMP);
 	if (nla_put_string(skb, NFXTA_NAME, chain->name) != 0)
 		goto nla_put_failure;
+	if (chain->ops != NULL) {
+		if (nla_put_u32(skb, NFXTA_HOOK_INDEX,
+		                chain->ops->hooknum) != 0 ||
+		    nla_put_u32(skb, NFXTA_HOOK_PRIORITY,
+		                chain->ops->priority) != 0 ||
+		    nla_put_u8(skb, NFXTA_HOOK_NFPROTO, chain->ops->pf) != 0)
+			goto nla_put_failure;
+	}
 	nlmsg_end(skb, msg);
 
 	if (chain->rules != NULL) {
@@ -1082,6 +1165,9 @@ static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_REVISION_MAX] = {.type = NLA_U32},
 	[NFXTA_SPLICE_OFFSET] = {.type = NLA_U32},
 	[NFXTA_SPLICE_DLENGTH] = {.type = NLA_U32},
+	[NFXTA_HOOK_INDEX] = {.type = NLA_U32},
+	[NFXTA_HOOK_PRIORITY] = {.type = NLA_U32},
+	[NFXTA_HOOK_NFPROTO] = {.type = NLA_U32},
 };
 
 /*
@@ -1105,6 +1191,8 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_TABLE_DUMP] = {.call = xtnetlink_table_dump, pol},
 	[NFXTM_CHAIN_SPLICE] = {.call = xtnetlink_chain_splice, pol},
 	[NFXTM_RULE_ENTRY] = {.call = xtnetlink_rule_entry, pol},
+	[NFXTM_CHAIN_PROMOTE] = {.call = xtnetlink_chain_promote, pol},
+	[NFXTM_CHAIN_DEMOTE] = {.call = xtnetlink_chain_demote, pol},
 };
 #undef pol
 
-- 
1.7.10.4

