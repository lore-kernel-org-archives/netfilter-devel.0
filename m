From: Jan Engelhardt <jengelh@medozas.de>
Subject: [PATCH 7/7] netfilter: xtables2: redirect writes into transaction buffer
Date: Thu, 19 Jan 2012 17:26:21 +0100
Message-ID: <1326990381-14534-8-git-send-email-jengelh@medozas.de>
References: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:57978 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932290Ab2ASQ00 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 19 Jan 2012 11:26:26 -0500
In-Reply-To: <1326990381-14534-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While a transaction is active, operations like chain add/del/move
should be done against the temporary table of course.

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt2_nfnetlink.c |   77 +++++++++++++++++++++++++++++------------
 1 files changed, 55 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/xt2_nfnetlink.c b/net/netfilter/xt2_nfnetlink.c
index 08bcc5e..3138f8c 100644
--- a/net/netfilter/xt2_nfnetlink.c
+++ b/net/netfilter/xt2_nfnetlink.c
@@ -206,6 +206,51 @@ xtnetlink_error(struct sock *xtnl, const struct xtnetlink_pktref *old,
 }
 
 /**
+ * @xa:		place for returning transaction, if any
+ * @net:	network namespace of the client
+ * @nladdr:	Netlink address of the same
+ *
+ * Return a pointer to either the live table, or to the transaction's temporary
+ * buffer (if there is a transaction open by the client identified by the
+ * {@net,@nladdr} tuple). All appropriate data structures are locked against
+ * modification by other instances. A symmetric call to xtnetlink_table_put is
+ * required afterwards.
+ */
+static struct xt2_table *
+xtnetlink_table_get(struct xtnetlink_transact **xa, struct net *net,
+		    int nladdr)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(net);
+	struct xt2_table *table;
+
+	mutex_lock(&xtnetlink_transact_lock);
+	*xa = xtnetlink_transact_lookup(net, nladdr);
+	if (*xa == NULL) {
+		mutex_unlock(&xtnetlink_transact_lock);
+		mutex_lock(&pnet->master_lock);
+		table = pnet->master;
+	} else {
+		table = (*xa)->table;
+	}
+	mutex_lock(&table->lock);
+	return table;
+}
+
+static void
+xtnetlink_table_put(struct xtnetlink_transact *xa, struct net *net,
+		    struct xt2_table *table)
+{
+	struct xt2_pernet_data *pnet = xtables2_pernet(net);
+
+	mutex_unlock(&table->lock);
+	if (xa == NULL) {
+		mutex_unlock(&pnet->master_lock);
+		return;
+	}
+	mutex_unlock(&xtnetlink_transact_lock);
+}
+
+/**
  * Ran too often into NULL derefs. Now there is a dummy function for unused
  * message type 0.
  */
@@ -254,8 +299,8 @@ static int
 xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 		    const struct nlmsghdr *imsg, const struct nlattr *const *ad)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
 	const struct nlattr *attr;
 	struct xt2_table *table;
 	struct xt2_chain *chain;
@@ -269,13 +314,8 @@ xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 	if (*name == '\0')
 		/* Anonymous chains are internal. */
 		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_INVALID_NAME);
-	/*
-	 * The table needs to stay, but note that rcu_read_lock cannot be used,
-	 * since we might sleep.
-	 */
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+
+	table = xtnetlink_table_get(&xa, sock_net(xtnl), NETLINK_CB(iskb).pid);
 	if (xt2_chain_lookup(table, name) != NULL) {
 		ret = xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_EXISTS);
 	} else {
@@ -287,8 +327,7 @@ xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 			ret = NFXTE_CHAIN_NAMETOOLONG;
 		ret = xtnetlink_error(xtnl, &ref, ret);
 	}
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_put(xa, sock_net(xtnl), table);
 	return ret;
 }
 
@@ -300,8 +339,8 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 		    const struct nlmsghdr *imsg,
 		    const struct nlattr *const *ad)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
 	const struct nlattr *name_attr;
 	struct xt2_table *table;
 	struct xt2_chain *chain;
@@ -315,17 +354,14 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 	if (*name == '\0')
 		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NOENT);
 
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+	table = xtnetlink_table_get(&xa, sock_net(xtnl), NETLINK_CB(iskb).pid);
 	chain = xt2_chain_lookup(table, name);
 	if (chain != NULL)
 		xt2_chain_free(chain);
 	else
 		ret = NFXTE_CHAIN_NOENT;
 	ret = xtnetlink_error(xtnl, &ref, ret);
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_put(xa, sock_net(xtnl), table);
 	return ret;
 }
 
@@ -334,8 +370,8 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 		     const struct nlmsghdr *imsg,
 		     const struct nlattr *const *ad)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref = {.c_skb = iskb, .c_msg = imsg};
+	struct xtnetlink_transact *xa;
 	const char *old_name, *new_name;
 	const struct xt2_chain *chain;
 	const struct nlattr *attr;
@@ -355,13 +391,10 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 	if (*new_name == '\0')
 		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_INVALID_NAME);
 
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+	table = xtnetlink_table_get(&xa, sock_net(xtnl), NETLINK_CB(iskb).pid);
 	chain = xt2_chain_move(table, old_name, new_name);
 	ret   = IS_ERR(chain) ? PTR_ERR(chain) : 0;
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_put(xa, sock_net(xtnl), table);
 	switch (ret) {
 	case -ENAMETOOLONG:
 		return xtnetlink_error(xtnl, &ref, NFXTE_CHAIN_NAMETOOLONG);
-- 
1.7.7

