From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 03/11] netfilter: xtables2: chain creation and deletion
Date: Fri,  2 Nov 2012 04:38:35 +0100
Message-ID: <1351827523-10629-4-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42663 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762642Ab2KBDkG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:06 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This adds support for chain add/del, as well as the error code
attributes that these operations may have to return.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 include/net/netfilter/xt_core.h                  |   32 ++++-
 include/uapi/linux/netfilter/nfnetlink_xtables.h |   22 ++++
 net/netfilter/xt_core.c                          |   80 +++++++++++-
 net/netfilter/xt_nfnetlink.c                     |  145 +++++++++++++++++++++-
 4 files changed, 276 insertions(+), 3 deletions(-)

diff --git a/include/net/netfilter/xt_core.h b/include/net/netfilter/xt_core.h
index 4ddaaae..5fec51f 100644
--- a/include/net/netfilter/xt_core.h
+++ b/include/net/netfilter/xt_core.h
@@ -1,15 +1,45 @@
 #ifndef _NETFILTER_XTCORE_H
 #define _NETFILTER_XTCORE_H 1
 
+#include <linux/list.h>
+#include <linux/mutex.h>
+#include <linux/rcupdate.h>
+
 /**
  * @master:	the master table
+ * @master_lock:	protecting changes to @master
  */
 struct xt2_pernet_data {
 	struct xt2_table __rcu *master;
+	struct mutex master_lock;
 };
 
+/**
+ * @chain_list:		list of chains (struct xt2_chain)
+ * @lock:		protecting changes to @chain_list
+ */
 struct xt2_table {
-	int _dummy;
+	struct list_head chain_list;
+	struct mutex lock;
+};
+
+/**
+ * @anchor:	list anchor for parent (struct xt2_table.chain_list)
+ * @name:	name of chain
+ * @rcu:	rcu head for delayed deletion
+ */
+struct xt2_chain {
+	struct list_head anchor;
+	char name[48];
+	struct rcu_head rcu;
 };
 
+struct net;
+
+extern struct xt2_pernet_data *xtables2_pernet(struct net *);
+
+extern struct xt2_chain *xt2_chain_new(struct xt2_table *, const char *);
+extern struct xt2_chain *xt2_chain_lookup(struct xt2_table *, const char *);
+extern void xt2_chain_free(struct xt2_chain *);
+
 #endif /* _NETFILTER_XTCORE_H */
diff --git a/include/uapi/linux/netfilter/nfnetlink_xtables.h b/include/uapi/linux/netfilter/nfnetlink_xtables.h
index a548394..57dec3c 100644
--- a/include/uapi/linux/netfilter/nfnetlink_xtables.h
+++ b/include/uapi/linux/netfilter/nfnetlink_xtables.h
@@ -4,24 +4,46 @@
 /**
  * %NFXTM_IDENTIFY:	multifunction debug command to inquire about xt2
  * 			properties (e.g. match size)
+ * %NFXTM_ERROR:	used to convey nfxt error codes
+ * 			(message equipped with NFXTA_ERRNO/NFXTA_XTERRNO)
+ * %NFXTM_CHAIN_NEW:	request creation of a chain by name
+ * %NFXTM_CHAIN_DEL:	request deletion of a chain by name
  */
 enum nfxt_msg_type {
 	NFXTM_IDENTIFY = 1,
+	NFXTM_ERROR,
+	NFXTM_CHAIN_NEW,
+	NFXTM_CHAIN_DEL,
 };
 
 /**
  * %NFXTA_NAME:			name of the object being operated on
+ * %NFXTA_ERRNO:		system error code (%Exxx)
+ * %NFXTA_XTERRNO:		NFXT-specific error code (cf. enum nfxt_errno)
  */
 enum nfxt_attr_type {
 	NFXTA_UNSPEC = 0,
 	NFXTA_NAME,
+	NFXTA_ERRNO,
+	NFXTA_XTERRNO,
 };
 
 /**
  * %NFXTE_SUCCESS:		the operation completed successfully
+ * %NFXTE_ATTRSET_INCOMPLETE:	Not all required attributes are present
+ * 				in nlmsg received from userspace
+ * %NFXTE_CHAIN_INVALID_NAME:	Chain name is not acceptable
+ * %NFXTE_CHAIN_EXIST:		Chain already exists
+ * %NFXTE_CHAIN_NOENT:		Chain does not exist
+ * %NFXTE_CHAIN_NAMETOOLONG:	New chain name is too long
  */
 enum nfxt_errno {
 	NFXTE_SUCCESS = 0,
+	NFXTE_ATTRSET_INCOMPLETE,
+	NFXTE_CHAIN_INVALID_NAME,
+	NFXTE_CHAIN_EXISTS,
+	NFXTE_CHAIN_NOENT,
+	NFXTE_CHAIN_NAMETOOLONG,
 };
 
 #endif /* _LINUX_NFNETLINK_XTABLES_H */
diff --git a/net/netfilter/xt_core.c b/net/netfilter/xt_core.c
index 24c418b..a0d6748 100644
--- a/net/netfilter/xt_core.c
+++ b/net/netfilter/xt_core.c
@@ -9,9 +9,13 @@
  */
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 #include <linux/err.h>
+#include <linux/kernel.h>
+#include <linux/list.h>
 #include <linux/module.h>
 #include <linux/mutex.h>
+#include <linux/rculist.h>
 #include <linux/slab.h>
+#include <linux/string.h>
 #include <net/net_namespace.h>
 #include <net/netns/generic.h>
 #include <net/netfilter/xt_core.h>
@@ -23,12 +27,79 @@ MODULE_LICENSE("GPL");
 
 static int xtables2_net_id __read_mostly;
 
-static inline struct xt2_pernet_data *xtables2_pernet(struct net *net)
+struct xt2_pernet_data *xtables2_pernet(struct net *net)
 {
 	return net_generic(net, xtables2_net_id);
 }
 
 /**
+ * @table:	table to add the new chain to
+ * @name:	name for the chain; may be %NULL
+ *
+ * Creates a new chain for @table using the given @name. @table and @name may
+ * be NULL or the empty string, in which case an anonymous chain is created.
+ * (Used by the dumper.)
+ *
+ * Caller should hold @table->lock and verify chain uniqueness.
+ */
+struct xt2_chain *xt2_chain_new(struct xt2_table *table, const char *name)
+{
+	struct xt2_chain *chain;
+
+	if (name != NULL && strlen(name) >= ARRAY_SIZE(chain->name))
+		return ERR_PTR(-ENAMETOOLONG);
+	chain = kmalloc(sizeof(*chain), GFP_KERNEL);
+	if (chain == NULL)
+		return ERR_PTR(-ENOMEM);
+	INIT_LIST_HEAD(&chain->anchor);
+	if (name != NULL)
+		strncpy(chain->name, name, sizeof(chain->name));
+	else
+		*chain->name = '\0';
+	chain->name[sizeof(chain->name)-1] = '\0';
+	if (table != NULL)
+		list_add_tail_rcu(&chain->anchor, &table->chain_list);
+	return chain;
+}
+
+/**
+ * @table:	table to search chain in
+ * @name:	name of desired chain
+ *
+ * Looks for a chain by its name in the given table.
+ * Caller should hold RCU if the chain is supposed to not go away.
+ * (= Caller can ignore RCU if it just wants an existence test.)
+ */
+struct xt2_chain *xt2_chain_lookup(struct xt2_table *table, const char *name)
+{
+	/* Future patch: Use better-suited data structure. */
+	struct xt2_chain *chain;
+
+	list_for_each_entry_rcu(chain, &table->chain_list, anchor)
+		if (strcmp(chain->name, name) == 0)
+			return chain;
+	return NULL;
+}
+
+/**
+ * Frees the chain and all its associated memory.
+ */
+static void xt2_chain_free_rcu(struct rcu_head *rcu)
+{
+	kfree(container_of(rcu, struct xt2_chain, rcu));
+}
+
+void xt2_chain_free(struct xt2_chain *chain)
+{
+	/*
+	 * Not using kfree_rcu here, as we may want to free more,
+	 * in xt2_chain_free_rcu, soon.
+	 */
+	list_del_rcu(&chain->anchor);
+	call_rcu(&chain->rcu, xt2_chain_free_rcu);
+}
+
+/**
  * Create a new table with no chains and no rules.
  */
 static struct xt2_table *xt2_table_new(void)
@@ -39,11 +110,17 @@ static struct xt2_table *xt2_table_new(void)
 	if (table == NULL)
 		return NULL;
 
+	mutex_init(&table->lock);
+	INIT_LIST_HEAD(&table->chain_list);
 	return table;
 }
 
 static void xt2_table_free(struct xt2_table *table)
 {
+	struct xt2_chain *chain, *next;
+
+	list_for_each_entry_safe(chain, next, &table->chain_list, anchor)
+		xt2_chain_free(chain);
 	kfree(table);
 }
 
@@ -51,6 +128,7 @@ static int __net_init xtables2_net_init(struct net *net)
 {
 	struct xt2_pernet_data *pnet = xtables2_pernet(net);
 
+	mutex_init(&pnet->master_lock);
 	pnet->master = xt2_table_new();
 	if (IS_ERR(pnet->master))
 		return PTR_ERR(pnet->master);
diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 8a58bb8..88df8350a 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -17,6 +17,7 @@
 #include <linux/netfilter/nfnetlink.h>
 #include <linux/netfilter/nfnetlink_xtables.h>
 #include <net/netlink.h>
+#include <net/sock.h>
 #include <net/netfilter/xt_core.h>
 #include "xt_nfnetlink.h"
 
@@ -70,6 +71,69 @@ xtnetlink_fill(struct sk_buff *skb, const struct xtnetlink_pktref *old,
 }
 
 /**
+ * @ref:	skb/nl pointers that will be filled in (secondary return values)
+ * @old:	pointers to the original incoming skb/nl headers
+ *
+ * xtnetlink_fill can be used when the outgoing skb already exists (e.g. in
+ * case of a dump operation), but for non-dump responses, we have to create it
+ * ourselves.
+ */
+static int
+xtnetlink_new_fill(struct xtnetlink_pktref *ref,
+		   const struct xtnetlink_pktref *old)
+{
+	ref->skb = nlmsg_new(NLMSG_DEFAULT_SIZE, GFP_KERNEL);
+	if (ref->skb == NULL)
+		return -ENOMEM;
+	ref->msg = xtnetlink_fill(ref->skb, old, 0);
+	if (IS_ERR(ref->msg)) {
+		kfree_skb(ref->skb);
+		return PTR_ERR(ref->msg);
+	}
+	return 0;
+}
+
+/**
+ * @xtnl:	socket to send the error packet out on
+ * @old:	pointers to the original incoming skb/nl headers
+ * @errcode:	last error code
+ *
+ * Create and send out an NFXT error packet. If @errcode is < 0, it indicates
+ * a system-level error (such as %-ENOMEM), reported back using %NFXTA_ERRNO.
+ * If @errcode is >= 0, it indicates an NFXT-specific error codes (%NFXTE_*),
+ * which is more fine grained than the dreaded %EINVAL, and which is reported
+ * back using %NFXTA_XTERRNO.
+ */
+static int
+xtnetlink_error(const struct xtnetlink_pktref *old, int errcode)
+{
+	struct xtnetlink_pktref ref;
+	int ret;
+
+	ret = xtnetlink_new_fill(&ref, old);
+	if (ret < 0)
+		return ret;
+	ref.msg->nlmsg_type = MAKE_TAGGED_TYPE(NFXTM_ERROR);
+	if (errcode < 0) {
+		/* Prefer positive numbers on the wire */
+		if (nla_put_u32(ref.skb, NFXTA_ERRNO, -errcode) != 0)
+			goto nla_put_failure;
+	} else {
+		if (nla_put_u32(ref.skb, NFXTA_XTERRNO, errcode) != 0)
+			goto nla_put_failure;
+	}
+	nlmsg_end(ref.skb, ref.msg);
+	ret = netlink_unicast(old->sock, ref.skb, NETLINK_CB(old->skb).portid,
+			      MSG_DONTWAIT);
+	if (ret < 0)
+		return ret;
+	/* ret is skb->len, but values >0 mean error to the caller -.- */
+	return 0;
+ nla_put_failure:
+	return -ENOBUFS;
+}
+
+/**
  * Ran too often into NULL derefs. Now there is a dummy function for unused
  * message type 0.
  */
@@ -118,14 +182,91 @@ xtnetlink_identify(struct sock *xtnl, struct sk_buff *iskb,
 	return netlink_dump_start(xtnl, iskb, imsg, &ctl);
 }
 
+static int xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
+			       const struct nlmsghdr *imsg,
+			       const struct nlattr *const *attr)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xt2_table *table;
+	struct xt2_chain *chain;
+	const char *name;
+	int ret = 0;
+
+	if (attr[NFXTA_NAME] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	name = nla_data(attr[NFXTA_NAME]);
+	if (*name == '\0')
+		/* Anonymous chains are internal. */
+		return xtnetlink_error(&ref, NFXTE_CHAIN_INVALID_NAME);
+	/*
+	 * The table needs to stay, but note that rcu_read_lock cannot be used,
+	 * since we might sleep.
+	 */
+	mutex_lock(&pnet->master_lock);
+	table = pnet->master;
+	mutex_lock(&table->lock);
+	if (xt2_chain_lookup(table, name) != NULL) {
+		ret = NFXTE_CHAIN_EXISTS;
+	} else {
+		chain = xt2_chain_new(table, name);
+		if (IS_ERR(chain))
+			ret = PTR_ERR(chain);
+		/* Use NFXTE error codes whenever possible. */
+		if (ret == -ENAMETOOLONG)
+			ret = NFXTE_CHAIN_NAMETOOLONG;
+	}
+	mutex_unlock(&table->lock);
+	mutex_unlock(&pnet->master_lock);
+	return xtnetlink_error(&ref, ret);
+}
+
+/**
+ * Act on a %NFXTM_CHAIN_DEL message.
+ */
+static int
+xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
+		    const struct nlmsghdr *imsg,
+		    const struct nlattr *const *attr)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xt2_table *table;
+	struct xt2_chain *chain;
+	const char *name;
+	int ret = 0;
+
+	if (attr[NFXTA_NAME] == NULL)
+		return xtnetlink_error(&ref, NFXTE_ATTRSET_INCOMPLETE);
+	name = nla_data(attr[NFXTA_NAME]);
+	if (*name == '\0')
+		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
+
+	mutex_lock(&pnet->master_lock);
+	table = pnet->master;
+	mutex_lock(&table->lock);
+	chain = xt2_chain_lookup(table, name);
+	if (chain != NULL)
+		xt2_chain_free(chain);
+	else
+		ret = NFXTE_CHAIN_NOENT;
+	mutex_unlock(&table->lock);
+	mutex_unlock(&pnet->master_lock);
+	return xtnetlink_error(&ref, ret);
+}
+
 static const struct nla_policy xtnetlink_policy[] = {
 	[NFXTA_NAME] = {.type = NLA_NUL_STRING},
+	[NFXTA_ERRNO] = {.type = NLA_U32},
+	[NFXTA_XTERRNO] = {.type = NLA_U32},
 };
 
 /*
  * Use the same policy for all messages. I do not want to see EINVAL anytime
  * soon again just because I forgot sending an attribute from userspace.
- * (If such occurs, it will be dealt with %NFXTE_ATTRSET_INCOMPLETE, tbd.)
+ * (If such occurs, it will be dealt with %NFXTE_ATTRSET_INCOMPLETE.)
  */
 #define pol \
 	.policy = xtnetlink_policy, \
@@ -133,6 +274,8 @@ static const struct nla_policy xtnetlink_policy[] = {
 static const struct nfnl_callback xtnetlink_callback[] = {
 	[0] = {.call = xtnetlink_ignore},
 	[NFXTM_IDENTIFY] = {.call = xtnetlink_identify, pol},
+	[NFXTM_CHAIN_NEW] = {.call = xtnetlink_chain_new, pol},
+	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
 };
 #undef pol
 
-- 
1.7.10.4

