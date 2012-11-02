From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 05/11] netfilter: xtables2: transaction commit operation
Date: Fri,  2 Nov 2012 04:38:37 +0100
Message-ID: <1351827523-10629-6-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42668 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762674Ab2KBDkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:07 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In Xtables1/iptables, atomic table replace was easy, since userspace
practically only had to do a single kernel call (SO_SET_REPLACE) and
the kernel got the entire ruleset at once.

With Netlink (and its limitations), the kernel module instead will
have to collect chain/rule modification messages first. This requires
a temporary scratch area preserved across Netlink message calls,
implemented herein in struct xtnetlink_transact, which is logically
attached to the invoking Netlink socket.

This commit adds the commit side, which does not do anything by
itself, but needs an operation that starts a transaction, like the
following NFXTM_REPLACE. (The commit split is for supposedly easier
review.)

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |    3 +
 include/uapi/linux/netfilter/nfnetlink_xtables.h |    9 ++
 net/netfilter/xt_core.c                          |    6 +-
 net/netfilter/xt_nfnetlink.c                     |  166 ++++++++++++++++++++++
 4 files changed, 182 insertions(+), 2 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index cfd09fa..b0b496f 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -44,4 +44,7 @@ extern void xt2_chain_free(struct xt2_chain *);
 extern struct xt2_chain *xt2_chain_move(struct xt2_table *, const char *,
 					const char *);
 
+extern struct xt2_table *xt2_table_new(void);
+extern void xt2_table_free(struct xt2_table *);
+
 #endif /* _NETFILTER_XTCORE_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index 1f66720..bec4d054 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -9,6 +9,8 @@
  * %NFXTM_CHAIN_NEW:	request creation of a chain by name
  * %NFXTM_CHAIN_DEL:	request deletion of a chain by name
  * %NFXTM_CHAIN_MOVE:	rename a chain
+ * %NFXTM_COMMIT:	finalize and commit a transaction
+ * %NFXTM_TABLE_REPLACE:start a table replace transaction
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
@@ -16,6 +18,8 @@ enum nfxt_msg_type {
 	NFXTM_CHAIN_NEW,
 	NFXTM_CHAIN_DEL,
 	NFXTM_CHAIN_MOVE,
+	NFXTM_COMMIT,
+	NFXTM_TABLE_REPLACE,
 };
 
 /**
@@ -40,6 +44,9 @@ enum nfxt_attr_type {
  * %NFXTE_CHAIN_EXIST:		Chain already exists
  * %NFXTE_CHAIN_NOENT:		Chain does not exist
  * %NFXTE_CHAIN_NAMETOOLONG:	New chain name is too long
+ * %NFXTE_TRANSACT_ACTIVE:	Attempted to start transaction while one was
+ * 				already active
+ * %NFXTE_TRANSACT_INACTIVE:	Commit issued when no transaction active
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
@@ -48,6 +55,8 @@ enum nfxt_errno {
 	NFXTE_CHAIN_EXISTS,
 	NFXTE_CHAIN_NOENT,
 	NFXTE_CHAIN_NAMETOOLONG,
+	NFXTE_TRANSACT_ACTIVE,
+	NFXTE_TRANSACT_INACTIVE,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 289ab5063..7c00e2d 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -132,7 +132,7 @@ struct xt2_chain *xt2_chain_move(struct xt2_table *table, const char *old_name,
 /**
  * Create a new table with no chains and no rules.
  */
-static struct xt2_table *xt2_table_new(void)
+struct xt2_table *xt2_table_new(void)
 {
 	struct xt2_table *table;
 
@@ -145,10 +145,12 @@ static struct xt2_table *xt2_table_new(void)
 	return table;
 }
 
-static void xt2_table_free(struct xt2_table *table)
+void xt2_table_free(struct xt2_table *table)
 {
 	struct xt2_chain *chain, *next;
 
+	if (table == NULL)
+		return;
 	list_for_each_entry_safe(chain, next, &table->chain_list, anchor)
 		xt2_chain_free(chain);
 	kfree(table);
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 9fc18c4..02f19fa 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -7,18 +7,25 @@
  *	the Free Software Foundation, either version 2 of the License, or
  *	(at your option) any later version.
  */
+#include <linux/atomic.h>
 #include <linux/err.h>
 #include <linux/errno.h>
 #include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/netlink.h>
+#include <linux/notifier.h>
+#include <linux/rwlock.h>
 #include <linux/skbuff.h>
+#include <linux/wait.h>
 #include <linux/netfilter.h>
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_xtables.h>
 #include <net/netlink.h>
+#include <net/net_namespace.h>
 #include <net/sock.h>
 #include <net/netfilter/xt_core.h>
+#include <asm-generic/bug.h>
 #include "xt_nfnetlink.h"
 
 #define MAKE_TAGGED_TYPE(x) ((x) | (NFNL_SUBSYS_XTABLES << 8))
@@ -40,6 +47,100 @@ struct xtnetlink_pktref {
 };
 
 /**
+ * Per-client transaction state
+ * @netns:		part of the tuple to uniquely identify client
+ * @use_count:		tracking active operations on the TA's table
+ * @nladdr:		client address
+ * @table:		temporary new table
+ *
+ * Because Netlink attrs can only be so big, the kernel won't be seeing the
+ * entire ruleset at once from userspace, but has to collect it piecewise.
+ *
+ * @use_count is necessarily zero if no xtnl kernel code currently executes.
+ */
+struct xtnetlink_transact {
+	struct list_head anchor;
+	const struct net *netns;
+	uint32_t nladdr;
+	atomic_t use_count;
+	wait_queue_head_t waitq;
+	struct xt2_table *table;
+};
+
+/**
+ * Write-locked: the one user may add/delete entries to/from transact_list
+ * Read-locked: users only touch transaction entries' content
+ */
+static rwlock_t xtnetlink_transact_lock;
+static LIST_HEAD(xtnetlink_transact_list);
+
+/**
+ * Find and return the transaction state.
+ * @net:	network namespace of socket
+ * @nladdr:	client address (NETLINK_CB(skb).portid)
+ *
+ * The caller should hold appropriate locks.
+ */
+static struct xtnetlink_transact *
+xtnetlink_transact_lookup(const struct net *netns, uint32_t nladdr)
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
+ * Lookup and pin the transaction state for a given client.
+ * @net:	network namespace of socket
+ * @nladdr:	client address (NETLINK_CB(skb).portid)
+ *
+ * Retrieves the current TA for the client.
+ * The read lock ensures that no entry is going to disappear during the search.
+ */
+static struct xtnetlink_transact *
+xtnetlink_transact_get(struct net *netns, uint32_t nladdr)
+{
+	struct xtnetlink_transact *xa;
+
+	read_lock(&xtnetlink_transact_lock);
+	xa = xtnetlink_transact_lookup(netns, nladdr);
+	if (xa != NULL)
+		atomic_inc(&xa->use_count);
+	read_unlock(&xtnetlink_transact_lock);
+	return xa;
+}
+
+/**
+ * Drain all modifications to the transaction.
+ *
+ * Removes the transaction from the list and wait for all outstanding
+ * operations on it to finish, so that the caller becomes the exclusive holder
+ * of the structure.
+ */
+static void xtnetlink_transact_pop(struct xtnetlink_transact *xa)
+{
+	WARN_ON(atomic_read(&xa->use_count) == 0);
+	atomic_dec(&xa->use_count);
+
+	/* Guarantee that no new modifications will come in to this TA. */
+	write_lock(&xtnetlink_transact_lock);
+	list_del(&xa->anchor);
+	write_unlock(&xtnetlink_transact_lock);
+
+	while (atomic_read(&xa->use_count) > 0)
+		wait_event(xa->waitq, atomic_read(&xa->use_count) == 0);
+}
+
+static void xtnetlink_transact_free(struct xtnetlink_transact *xa)
+{
+	xt2_table_free(xa->table);
+	kfree(xa);
+}
+
+/**
  * @skb:	outgoing skb
  * @old:	pointers to the original incoming skb/nl headers
  * @flags:	extra flags to set in nlmsg
@@ -300,6 +401,33 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 	}
 }
 
+static int
+xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
+		 const struct nlmsghdr *imsg, const struct nlattr *const *ad)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
+	struct xt2_table *old_table;
+
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	if (xa == NULL)
+		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
+
+	xtnetlink_transact_pop(xa);
+
+	/* <- ruleset verification/packing here */
+	mutex_lock(&pnet->master_lock);
+	old_table = pnet->master;
+	rcu_assign_pointer(pnet->master, xa->table);
+	mutex_unlock(&pnet->master_lock);
+	/* Just (re)use transact_free to kill the old table off. */
+	xa->table = old_table;
+	xtnetlink_transact_free(xa);
+	return xtnetlink_error(&ref, NFXTE_SUCCESS);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
 	[NFXTA_ERRNO] = {.type = NLA_U32},
@@ -321,6 +449,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
 	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
 	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
+	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
 };
 #undef pol
 
@@ -331,14 +460,51 @@ static const struct nfnetlink_subsystem xtnetlink_subsys = {
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
+	 * same nladdr value (.portid member).
+	 */
+	xa = xtnetlink_transact_get(note->net, note->portid);
+	if (xa == NULL)
+		return NOTIFY_DONE;
+	xtnetlink_transact_pop(xa);
+	xtnetlink_transact_free(xa);
+	return NOTIFY_DONE;
+}
+
+static struct notifier_block xtnetlink_nlevent_notifier __read_mostly = {
+	.notifier_call = xtnetlink_nlevent,
+};
+
 int __init xtnetlink_init(void)
 {
+	int ret;
+
+	INIT_LIST_HEAD(&xtnetlink_transact_list);
+	rwlock_init(&xtnetlink_transact_lock);
+	ret = netlink_register_notifier(&xtnetlink_nlevent_notifier);
+	if (ret < 0)
+		return ret;
 	return nfnetlink_subsys_register(&xtnetlink_subsys);
 }
 
 void __exit xtnetlink_exit(void)
 {
 	nfnetlink_subsys_unregister(&xtnetlink_subsys);
+	netlink_unregister_notifier(&xtnetlink_nlevent_notifier);
+	WARN_ON(!list_empty(&xtnetlink_transact_list));
 }
 
 MODULE_ALIAS_NFNL_SUBSYS(NFNL_SUBSYS_XTABLES);
-- 
1.7.10.4

