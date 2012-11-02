From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 06/11] netfilter: xtables2: (atomic) table replace support
Date: Fri,  2 Nov 2012 04:38:38 +0100
Message-ID: <1351827523-10629-7-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42669 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762643Ab2KBDkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:07 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This commit introduces NFXTM_TABLE_REPLACE, which starts a new
transaction, i.e. a temporary scratch space for a table, which, at the
end (NFXTM_COMMIT) will be atomically swapped.

TABLE_REPLACE directly followed by COMMIT essentially removes all
chains and rules.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_nfnetlink.c |   95 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 95 insertions(+)

diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 02f19fa..59c603f 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -75,6 +75,31 @@ static rwlock_t xtnetlink_transact_lock;
 static LIST_HEAD(xtnetlink_transact_list);
 
 /**
+ * Create a new transaction state.
+ * @net:	network namespace of socket
+ * @nladdr:	client address (NETLINK_CB(skb).portid)
+ *
+ * Operations starting a new transaction (e.g. atomic table replace) use this
+ * helper, and shall further set xa->table before publishing the TA.
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
+	atomic_set(&xa->use_count, 0);
+	init_waitqueue_head(&xa->waitq);
+	xa->netns  = net;
+	xa->nladdr = nladdr;
+	xa->table  = NULL;
+	return xa;
+}
+
+/**
  * Find and return the transaction state.
  * @net:	network namespace of socket
  * @nladdr:	client address (NETLINK_CB(skb).portid)
@@ -113,6 +138,40 @@ xtnetlink_transact_get(struct net *netns, uint32_t nladdr)
 	return xa;
 }
 
+static void xtnetlink_transact_put(struct xtnetlink_transact *xa)
+{
+	/* Decrease beyond 0 is a code bug. */
+	WARN_ON(atomic_read(&xa->use_count) == 0);
+	atomic_dec(&xa->use_count);
+	wake_up(&xa->waitq);
+}
+
+/**
+ * Mark transaction as being active by entering it into the list.
+ *
+ * The write lock ensures that we catch the case that some other thread created
+ * a transaction for the same socket already.
+ */
+static int xtnetlink_transact_push(struct xtnetlink_transact *xa)
+{
+	/* This is a fresh entry, so should not be used anywhere. */
+	WARN_ON(atomic_read(&xa->use_count) != 0);
+
+	/*
+	 * Ensure some other thread did not create a TA
+	 * for the same socket first.
+	 */
+	write_lock(&xtnetlink_transact_lock);
+	if (xtnetlink_transact_lookup(xa->netns, xa->nladdr) != NULL) {
+		write_unlock(&xtnetlink_transact_lock);
+		return -EEXIST;
+	}
+	atomic_inc(&xa->use_count);
+	list_add_tail(&xa->anchor, &xtnetlink_transact_list);
+	write_unlock(&xtnetlink_transact_lock);
+	return 0;
+}
+
 /**
  * Drain all modifications to the transaction.
  *
@@ -401,6 +460,41 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
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
+	struct xtnetlink_pktref ref =
+		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
+	int ret;
+
+	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	if (xa == NULL)
+		return -ENOMEM;
+	xa->table = xt2_table_new();
+	if (xa->table == NULL) {
+		xtnetlink_transact_free(xa);
+		return -ENOMEM;
+	}
+	ret = xtnetlink_transact_push(xa);
+	if (ret == -EEXIST) {
+		xtnetlink_transact_free(xa);
+		return xtnetlink_error(&ref, NFXTE_TRANSACT_ACTIVE);
+	}
+
+	xtnetlink_transact_put(xa);
+	return xtnetlink_error(&ref, NFXTE_SUCCESS);
+}
+
 static int
 xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 		 const struct nlmsghdr *imsg, const struct nlattr *const *ad)
@@ -450,6 +544,7 @@ static const struct nfnl_callback xtnetlink_callback[] = {
 	[NFXTM_CHAIN_DEL] = {.call = xtnetlink_chain_del, pol},
 	[NFXTM_CHAIN_MOVE] = {.call = xtnetlink_chain_move, pol},
 	[NFXTM_COMMIT] = {.call = xtnetlink_commit, pol},
+	[NFXTM_TABLE_REPLACE] = {.call = xtnetlink_table_replace, pol},
 };
 #undef pol
 
-- 
1.7.10.4

