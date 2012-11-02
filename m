From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 08/11] netfilter: xtables2: redirect writes into transaction buffer
Date: Fri,  2 Nov 2012 04:38:40 +0100
Message-ID: <1351827523-10629-9-git-send-email-jengelh@inai.de>
References: <1351827523-10629-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:42671 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762692Ab2KBDkH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Nov 2012 23:40:07 -0400
In-Reply-To: <1351827523-10629-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While a transaction is active, operations like chain add/del/move
should be done against the temporary table, of course.

This commit adds convenience functions to grab the desired table
object and contain all the locking details.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_nfnetlink.c |   76 ++++++++++++++++++++++++++++++------------
 1 file changed, 54 insertions(+), 22 deletions(-)

diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index 133a4a8..c53902e 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -294,6 +294,47 @@ xtnetlink_error(const struct xtnetlink_pktref *old, int errcode)
 }
 
 /**
+ * @xa:		place for returning transaction, if any
+ * @net:	network namespace of the client
+ * @nladdr:	Netlink address of the same
+ *
+ * Return a pointer to either the live table, or to the transaction's temporary
+ * buffer (if there is a transaction open by the client identified by the
+ * {@net,@nladdr} tuple). All appropriate data structures are locked for write.
+ * A symmetric call to xtnetlink_table_wput is required afterwards.
+ */
+static struct xt2_table *
+xtnetlink_table_wget(struct xtnetlink_transact **xa, struct net *net,
+		     uint32_t nladdr)
+{
+	struct xt2_pernet_data *pnet;
+	struct xt2_table *table;
+
+	*xa = xtnetlink_transact_get(net, nladdr);
+	if (*xa == NULL) {
+		pnet = xtables2_pernet(net);
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
+xtnetlink_table_wput(struct xtnetlink_transact *xa, struct net *net,
+		     struct xt2_table *table)
+{
+	mutex_unlock(&table->lock);
+	if (xa == NULL)
+		/* Note to self: if @xa is NULL, there is nothing to "put". */
+		mutex_unlock(&xtables2_pernet(net)->master_lock);
+	else
+		xtnetlink_transact_put(xa);
+}
+
+/**
  * Ran too often into NULL derefs. Now there is a dummy function for unused
  * message type 0.
  */
@@ -346,9 +387,9 @@ static int xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 			       const struct nlmsghdr *imsg,
 			       const struct nlattr *const *attr)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref =
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
 	struct xt2_table *table;
 	struct xt2_chain *chain;
 	const char *name;
@@ -360,13 +401,9 @@ static int xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 	if (*name == '\0')
 		/* Anonymous chains are internal. */
 		return xtnetlink_error(&ref, NFXTE_CHAIN_INVALID_NAME);
-	/*
-	 * The table needs to stay, but note that rcu_read_lock cannot be used,
-	 * since we might sleep.
-	 */
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+
+	table = xtnetlink_table_wget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
 	if (xt2_chain_lookup(table, name) != NULL) {
 		ret = NFXTE_CHAIN_EXISTS;
 	} else {
@@ -377,8 +414,7 @@ static int xtnetlink_chain_new(struct sock *xtnl, struct sk_buff *iskb,
 		if (ret == -ENAMETOOLONG)
 			ret = NFXTE_CHAIN_NAMETOOLONG;
 	}
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_wput(xa, sock_net(xtnl), table);
 	return xtnetlink_error(&ref, ret);
 }
 
@@ -390,9 +426,9 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 		    const struct nlmsghdr *imsg,
 		    const struct nlattr *const *attr)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref =
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
 	struct xt2_table *table;
 	struct xt2_chain *chain;
 	const char *name;
@@ -404,16 +440,14 @@ xtnetlink_chain_del(struct sock *xtnl, struct sk_buff *iskb,
 	if (*name == '\0')
 		return xtnetlink_error(&ref, NFXTE_CHAIN_NOENT);
 
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+	table = xtnetlink_table_wget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
 	chain = xt2_chain_lookup(table, name);
 	if (chain != NULL)
 		xt2_chain_free(chain);
 	else
 		ret = NFXTE_CHAIN_NOENT;
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_wput(xa, sock_net(xtnl), table);
 	return xtnetlink_error(&ref, ret);
 }
 
@@ -422,9 +456,9 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 		     const struct nlmsghdr *imsg,
 		     const struct nlattr *const *attr)
 {
-	struct xt2_pernet_data *pnet = xtables2_pernet(sock_net(xtnl));
 	struct xtnetlink_pktref ref =
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
+	struct xtnetlink_transact *xa;
 	const char *old_name, *new_name;
 	const struct xt2_chain *chain;
 	struct xt2_table *table;
@@ -441,13 +475,11 @@ xtnetlink_chain_move(struct sock *xtnl, struct sk_buff *iskb,
 	if (*new_name == '\0')
 		return xtnetlink_error(&ref, NFXTE_CHAIN_INVALID_NAME);
 
-	mutex_lock(&pnet->master_lock);
-	table = pnet->master;
-	mutex_lock(&table->lock);
+	table = xtnetlink_table_wget(&xa, sock_net(xtnl),
+				     NETLINK_CB(iskb).portid);
 	chain = xt2_chain_move(table, old_name, new_name);
 	ret   = IS_ERR(chain) ? PTR_ERR(chain) : 0;
-	mutex_unlock(&table->lock);
-	mutex_unlock(&pnet->master_lock);
+	xtnetlink_table_wput(xa, sock_net(xtnl), table);
 	switch (ret) {
 	case -ENAMETOOLONG:
 		return xtnetlink_error(&ref, NFXTE_CHAIN_NAMETOOLONG);
-- 
1.7.10.4

