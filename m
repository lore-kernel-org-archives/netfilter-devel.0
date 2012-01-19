From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 5/7] netfilter: xtables2: initial table replace support
Date: Thu, 19 Jan 2012 17:26:19 +0100
Message-ID: <1326990381-14534-6-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57976 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932325Ab2ASQ00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:26 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Xtables1/iptables, table replace was easy, since userspace
practically only had to do a single kernel call (SO_SET_REPLACE)
and the kernel got the entire ruleset at once.

With Netlink (and its wonderful limitations), the kernel module
instead will have to collect chain/rule modification messages first,
necessiting a temporary scratch area, implemented herein in struct
xtnetlink_transact.

This patch adds the skeletons for transactioning and the
NFXTM_TABLE_REPLACE handler, making it possible to nuke all chains
with it (that's all for this patch).

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 include/linux/netfilter/nfnetlink_xtables.h |    6 +
 include/net/netfilter/x_tables2.h           |    2 +
 net/netfilter/xt2_core.c                    |    8 +-
 net/netfilter/xt2_nfnetlink.c               |  180 +++++++++++++++++++++++++++
 4 files changed, 194 insertions(+), 2 deletions(-)

diff --git a/include/linux/netfilter/nfnetlink_xtables.h b/include/linux/netfilter/nfnetlink_xtables.h
index 296012a..2399678 100644
--- a/include/linux/netfilter/nfnetlink_xtables.h
+++ b/include/linux/netfilter/nfnetlink_xtables.h
@@ -6,6 +6,8 @@ enum nfxt_msg_type {
 	NFXTM_CHAIN_NEW,
 	NFXTM_CHAIN_DEL,
 	NFXTM_CHAIN_MOVE,
+	NFXTM_TABLE_REPLACE,
+	NFXTM_COMMIT,
 };
 
 /**
@@ -28,6 +30,8 @@ enum nfxt_attr_type {
  * %NFXTE_CHAIN_EXIST:		Chain already exists
  * %NFXTE_CHAIN_NOENT:		Chain does not exist
  * %NFXTE_CHAIN_NAMETOOLONG:	New chain name is too long
+ * %NFXTE_TRANSACT_ACTIVE:	Attempted to start transact while already active
+ * %NFXTE_TRANSACT_INACTIVE:	Commit issued when no transaction active
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
@@ -36,6 +40,8 @@ enum nfxt_errno {
 	NFXTE_CHAIN_EXISTS,
 	NFXTE_CHAIN_NOENT,
 	NFXTE_CHAIN_NAMETOOLONG,
+	NFXTE_TRANSACT_ACTIVE,
+	NFXTE_TRANSACT_INACTIVE,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/include/net/netfilter/x_tables2.h b/include/net/netfilter/x_tables2.h
index 198ec31..1744182 100644
--- a/include/net/netfilter/x_tables2.h
+++ b/include/net/netfilter/x_tables2.h
@@ -44,5 +44,7 @@ extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
 extern void xt2_chain_free(struct xt2_chain *);
 extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
 					const char *);
+extern struct xt2_table *xt2_table_new(void);
+extern void xt2_table_free(struct xt2_table *);
 
 #endif /* _NET_NETFILTER_XTABLES2_H */
diff --git a/net/netfilter/xt2_core.c b/net/netfilter/xt2_core.c
index 5d8f155..c13102d 100644
--- a/net/netfilter/xt2_core.c
+++ b/net/netfilter/xt2_core.c
@@ -133,7 +133,7 @@ EXPORT_SYMBOL_GPL(xt2_chain_move);
 /**
  * Create a new table with no chains and no rules.
  */
-static struct xt2_table *xt2_table_new(void)
+struct xt2_table *xt2_table_new(void)
 {
 	struct xt2_table *table;
 
@@ -145,15 +145,19 @@ static struct xt2_table *xt2_table_new(void)
 	INIT_LIST_HEAD(&table->chain_list);
 	return table;
 }
+EXPORT_SYMBOL_GPL(xt2_table_new);
 
-static void xt2_table_free(struct xt2_table *table)
+void xt2_table_free(struct xt2_table *table)
 {
 	struct xt2_chain *chain, *next;
 
+	if (table == NULL)
+		return;
 	list_for_each_entry_safe(chain, next, &table->chain_list, anchor)
 		xt2_chain_free(chain);
 	kfree(table);
 }
+EXPORT_SYMBOL_GPL(xt2_table_free);
 
 static int __net_init xtables2_net_init(struct net *net)
 {
diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlink.c
index 9f29b34..0ef6442 100644
--- a/net/netfilter/xt2_nfnetlink.c
+++ b/net/netfilter/xt2_nfnetlink.c
@@ -12,13 +12,16 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/notifier.h>
 #include <linux/skbuff.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_xtables.h>
 #include <net/netlink.h>
+#include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netfilter/x_tables2.h>
+#include <asm-generic/bug.h>
 
 MODULE_DESCRIPTION("Xtables2 nfnetlink interface");
 MODULE_AUTHOR("Jan Engelhardt");
@@ -39,6 +42,79 @@ struct xtnetlink_pktref {
 };
 
 /**
+ * Per-client transaction state
+ * @netns:		part of the tuple to uniquely identify client
+ * @nladdr:		client address
+ * @table:		temporary new table
+ *
+ * Because Netlink attrs can only be so big (and certain uses of Netlink are
+ * opposed to by others), the kernel won't be seeing the entire ruleset at once
+ * from userspace, but has to collect it. Also, I [j.eng] think that passing a
+ * 150 MB data stream via a __user pointer through SO_SET_REPLACE is a bit
+ * different after all, compared to a 150 MB netlink message - limited
+ * (default) size of socket buffers probably would forbid it already.
+ */
+struct xtnetlink_transact {
+	struct list_head anchor;
+	const struct net *netns;
+	uint32_t nladdr;
+	struct xt2_table *table;
+};
+
+static struct mutex xtnetlink_transact_lock;
+static LIST_HEAD(xtnetlink_transact_list);
+
+/**
+ * Create a new transaction state for the client given by @nladdr.
+ * @nladdr:	client address (NETLINK_CB(skb).pid)
+ *
+ * The caller should hold appropriate locks.
+ */
+static struct xtnetlink_transact *
+xtnetlink_transact_new(const struct net *net, uint32_t nladdr)
+{
+	struct xtnetlink_transact *xa;
+
+	xa = kmalloc(sizeof(*xa), GFP_KERNEL);
+	if (xa == NULL)
+		return NULL;
+	INIT_LIST_HEAD(&xa->anchor);
+	xa->netns  = net;
+	xa->nladdr = nladdr;
+	list_add_tail(&xa->anchor, &xtnetlink_transact_list);
+	return xa;
+}
+
+/**
+ * Find and return the transaction state for client given by @nladdr.
+ * @nladdr:	client address (NETLINK_CB(skb).pid)
+ *
+ * The caller should hold appropriate locks here as well.
+ */
+static struct xtnetlink_transact *
+xtnetlink_transact_lookup(struct net *netns, uint32_t nladdr)
+{
+	struct xtnetlink_transact *e;
+
+	list_for_each_entry(e, &xtnetlink_transact_list, anchor)
+		if (net_eq(e->netns, netns) && e->nladdr == nladdr)
+			return e;
+	return NULL;
+}
+
+/**
+ * Tear down a client's transaction state.
+ * @xa:		transaction buildup space to be freed
+ *
+ */
+static void xtnetlink_transact_free(struct xtnetlink_transact *xa)
+{
+	list_del(&xa->anchor);
+	xt2_table_free(xa->table);
+	kfree(xa);
+}
+
+/**
  * @skb:	outgoing skb
  * @old:	pointers to the original incoming skb/nl headers
  * @flags:	extra flags to set in nlmsg
@@ -298,6 +374,70 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 	}
 }
 
+/**
+ * This function initiates a new transaction, a scratch space of sorts.
+ * %NFXTM_TABLE_REPLACE starts with a clean table, and one is to issue
+ * %NFXTM_CHAIN_* to "edit" it. It will be switched for the live ruleset once
+ * %NFXTM_COMMIT is issued - the whole sequence is what makes up the atomic
+ * table replacement feature that was already in Xtables1.
+ */
+static int
+xtnetlink_table_replace(struct sock *xtnl, struct sk_buff *iskb,
+			const struct nlmsghdr *imsg,
+			const struct nlattr *const *ad)
+{
+	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
+
+	mutex_lock(&xtnetlink_transact_lock);
+	if (xtnetlink_transact_lookup(sock_net(xtnl),
+	    NETLINK_CB(iskb).pid) != NULL) {
+		mutex_unlock(&xtnetlink_transact_lock);
+		return xtnetlink_error(xtnl, &ref, NFXTE_TRANSACT_ACTIVE);
+	}
+	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).pid);
+	if (xa == NULL)
+		goto out;
+	xa->table = xt2_table_new();
+	if (xa->table == NULL)
+		goto out;
+	mutex_unlock(&xtnetlink_transact_lock);
+	return xtnetlink_error(xtnl, &ref, NFXTE_SUCCESS);
+ out:
+	xtnetlink_transact_free(xa);
+	mutex_unlock(&xtnetlink_transact_lock);
+	return -ENOMEM;
+}
+
+static int
+xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
+		 const struct nlmsghdr *imsg, const struct nlattr *const *ad)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
+	struct xt2_table *old_table;
+
+	mutex_lock(&xtnetlink_transact_lock);
+	xa = xtnetlink_transact_lookup(sock_net(xtnl), NETLINK_CB(iskb).pid);
+	if (xa == NULL) {
+		mutex_unlock(&xtnetlink_transact_lock);
+		return xtnetlink_error(xtnl, &ref, NFXTE_TRANSACT_INACTIVE);
+	}
+
+	/* <- ruleset verification/packing here */
+	mutex_lock(&pnet->master_lock);
+	old_table = pnet->master;
+	printk("Old table: %p, New table: %p\n", old_table, xa->table);
+	rcu_assign_pointer(pnet->master, xa->table);
+	mutex_unlock(&pnet->master_lock);
+	/* Just use transact_free to kill the old one off. */
+	xa->table = old_table;
+	xtnetlink_transact_free(xa);
+	mutex_unlock(&xtnetlink_transact_lock);
+	return xtnetlink_error(xtnl, &ref, NFXTE_SUCCESS);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -319,6 +459,8 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
 	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
 	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
+	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
+	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
 };
 #undef pol
 
@@ -329,14 +471,52 @@ static const struct nfnetlink_subsystem xtnetlink_subsys = {
 	.cb_count  = ARRAY_SIZE(xtnetlink_callback),
 };
 
+static int
+xtnetlink_nlevent(struct notifier_block *blk, unsigned long event, void *ptr)
+{
+	const struct netlink_notify *note = ptr;
+	struct xtnetlink_transact *xa;
+
+	if (event != NETLINK_URELEASE || note->protocol != NETLINK_NETFILTER)
+		return NOTIFY_DONE;
+	/*
+	 * Freeing is non-sleeping thanks to kfree_rcu in xt2_table_free.
+	 * Is this needed, or do we have a user context in this NL notifier?
+	 *
+	 * If notifiers are not executed right when they are issued, this
+	 * becomes as a race, as a new NL socket could be created with the
+	 * same nladdr value (.pid member).
+	 */
+	mutex_lock(&xtnetlink_transact_lock);
+	xa = xtnetlink_transact_lookup(note->net, note->pid);
+	if (xa != NULL)
+		xtnetlink_transact_free(xa);
+	mutex_unlock(&xtnetlink_transact_lock);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xtnetlink_nlevent_notifier __read_mostly = {
+	.notifier_call = xtnetlink_nlevent,
+};
+
 static int __init xtnetlink_init(void)
 {
+	int ret;
+
+	INIT_LIST_HEAD(&xtnetlink_transact_list);
+	mutex_init(&xtnetlink_transact_lock);
+	ret = netlink_register_notifier(&xtnetlink_nlevent_notifier);
+	if (ret < 0)
+		return ret;
 	return nfnetlink_subsys_register(&xtnetlink_subsys);
 }
 
 static void __exit xtnetlink_exit(void)
 {
 	nfnetlink_subsys_unregister(&xtnetlink_subsys);
+	netlink_unregister_notifier(&xtnetlink_nlevent_notifier);
+	WARN_ON(!list_empty(&xtnetlink_transact_list));
+	mutex_destroy(&xtnetlink_transact_lock);
 }
 
 module_init(xtnetlink_init);
-- 
1.7.7

