From: Jan Engelhardt <jengelh@inai.de>
Subject: [PATCH 01/11] netfilter: xtables2: prepare for addition of more transaction buffer types
Date: Fri, 16 Nov 2012 02:23:35 +0100
Message-ID: <1353029025-31635-2-git-send-email-jengelh@inai.de>
References: <1353029025-31635-1-git-send-email-jengelh@inai.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:45171 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2KPBXx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Nov 2012 20:23:53 -0500
In-Reply-To: <1353029025-31635-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

There will be another buffer type, XA_SPLICE_BUFFER, to collect
rules that userspace sent as an update.

Signed-off-by: Jan Engelhardt <jengelh@inai.de>
---
 net/netfilter/xt_nfnetlink.c |   54 +++++++++++++++++++++++++++++++-----------
 1 file changed, 40 insertions(+), 14 deletions(-)

diff --git a/net/netfilter/xt_nfnetlink.c b/net/netfilter/xt_nfnetlink.c
index cb01f5a..1690cf6 100644
--- a/net/netfilter/xt_nfnetlink.c
+++ b/net/netfilter/xt_nfnetlink.c
@@ -47,6 +47,15 @@ struct xtnetlink_pktref {
 };
 
 /**
+ * Multiple types of transaction buffers do exist -
+ * %XA_TABLE_BUFFER:	holds chains accumulating during any operation during
+ * 			%NFXTM_TABLE_REPLACE .. %NFXTM_COMMIT period
+ */
+enum xtnetlink_transact_type {
+	XA_TABLE_BUFFER,
+};
+
+/**
  * Per-client transaction state
  * @netns:		part of the tuple to uniquely identify client
  * @use_count:		tracking active operations on the TA's table
@@ -57,6 +66,8 @@ struct xtnetlink_pktref {
  * entire ruleset at once from userspace, but has to collect it piecewise.
  *
  * @use_count is necessarily zero if no xtnl kernel code currently executes.
+ * Each client (uniquely identified by <netns,nladdr>) can have one buffer
+ * of every type (hence uniquely identified by <netns,nladdr,type>).
  */
 struct xtnetlink_transact {
 	struct list_head anchor;
@@ -64,7 +75,10 @@ struct xtnetlink_transact {
 	uint32_t nladdr;
 	atomic_t use_count;
 	wait_queue_head_t waitq;
-	struct xt2_table *table;
+	enum xtnetlink_transact_type type;
+	union {
+		struct xt2_table *table;
+	};
 };
 
 /**
@@ -100,7 +114,8 @@ static const unsigned int xtnetlink_revision_min; /* = 0; */
  * helper, and shall further set xa->table before publishing the TA.
  */
 static struct xtnetlink_transact *
-xtnetlink_transact_new(const struct net *net, uint32_t nladdr)
+xtnetlink_transact_new(const struct net *net, uint32_t nladdr,
+		       enum xtnetlink_transact_type xa_type)
 {
 	struct xtnetlink_transact *xa;
 
@@ -112,6 +127,7 @@ xtnetlink_transact_new(const struct net *net, uint32_t nladdr)
 	init_waitqueue_head(&xa->waitq);
 	xa->netns  = net;
 	xa->nladdr = nladdr;
+	xa->type   = xa_type;
 	xa->table  = NULL;
 	return xa;
 }
@@ -124,12 +140,14 @@ xtnetlink_transact_new(const struct net *net, uint32_t nladdr)
  * The caller should hold appropriate locks.
  */
 static struct xtnetlink_transact *
-xtnetlink_transact_lookup(const struct net *netns, uint32_t nladdr)
+xtnetlink_transact_lookup(const struct net *netns, uint32_t nladdr,
+			  enum xtnetlink_transact_type xa_type)
 {
 	struct xtnetlink_transact *e;
 
 	list_for_each_entry(e, &xtnetlink_transact_list, anchor)
-		if (net_eq(e->netns, netns) && e->nladdr == nladdr)
+		if (net_eq(e->netns, netns) && e->nladdr == nladdr &&
+		    e->type == xa_type)
 			return e;
 	return NULL;
 }
@@ -143,12 +161,13 @@ xtnetlink_transact_lookup(const struct net *netns, uint32_t nladdr)
  * The read lock ensures that no entry is going to disappear during the search.
  */
 static struct xtnetlink_transact *
-xtnetlink_transact_get(struct net *netns, uint32_t nladdr)
+xtnetlink_transact_get(struct net *netns, uint32_t nladdr,
+		       enum xtnetlink_transact_type xa_type)
 {
 	struct xtnetlink_transact *xa;
 
 	read_lock(&xtnetlink_transact_lock);
-	xa = xtnetlink_transact_lookup(netns, nladdr);
+	xa = xtnetlink_transact_lookup(netns, nladdr, xa_type);
 	if (xa != NULL)
 		atomic_inc(&xa->use_count);
 	read_unlock(&xtnetlink_transact_lock);
@@ -179,7 +198,8 @@ static int xtnetlink_transact_push(struct xtnetlink_transact *xa)
 	 * for the same socket first.
 	 */
 	write_lock(&xtnetlink_transact_lock);
-	if (xtnetlink_transact_lookup(xa->netns, xa->nladdr) != NULL) {
+	if (xtnetlink_transact_lookup(xa->netns, xa->nladdr,
+	                              xa->type) != NULL) {
 		write_unlock(&xtnetlink_transact_lock);
 		return -EEXIST;
 	}
@@ -212,7 +232,10 @@ static void xtnetlink_transact_pop(struct xtnetlink_transact *xa)
 
 static void xtnetlink_transact_free(struct xtnetlink_transact *xa)
 {
-	xt2_table_free(xa->table);
+	if (xa->type == XA_TABLE_BUFFER) {
+		if (xa->table != NULL)
+			xt2_table_free(xa->table);
+	}
 	kfree(xa);
 }
 
@@ -327,7 +350,7 @@ xtnetlink_table_wget(struct xtnetlink_transact **xa, struct net *net,
 	struct xt2_pernet_data *pnet;
 	struct xt2_table *table;
 
-	*xa = xtnetlink_transact_get(net, nladdr);
+	*xa = xtnetlink_transact_get(net, nladdr, XA_TABLE_BUFFER);
 	if (*xa == NULL) {
 		pnet = xtables2_pernet(net);
 		mutex_lock(&pnet->master_lock);
@@ -359,7 +382,7 @@ static struct xt2_table *
 xtnetlink_table_rget(struct xtnetlink_transact **xa, struct net *net,
 		     uint32_t nladdr)
 {
-	*xa = xtnetlink_transact_get(net, nladdr);
+	*xa = xtnetlink_transact_get(net, nladdr, XA_TABLE_BUFFER);
 	rcu_read_lock();
 	if (*xa == NULL)
 		return rcu_dereference(xtables2_pernet(net)->master);
@@ -556,7 +579,8 @@ xtnetlink_table_replace(struct sock *xtnl, struct sk_buff *iskb,
 	struct xtnetlink_transact *xa;
 	int ret;
 
-	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	xa = xtnetlink_transact_new(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_TABLE_BUFFER);
 	if (xa == NULL)
 		return -ENOMEM;
 	xa->table = xt2_table_new();
@@ -584,7 +608,8 @@ xtnetlink_commit(struct sock *xtnl, struct sk_buff *iskb,
 	struct xtnetlink_transact *xa;
 	struct xt2_table *old_table;
 
-	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_TABLE_BUFFER);
 	if (xa == NULL)
 		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
 
@@ -610,7 +635,8 @@ xtnetlink_abort(struct sock *xtnl, struct sk_buff *iskb,
 		{.c_skb = iskb, .c_msg = imsg, .sock = xtnl};
 	struct xtnetlink_transact *xa;
 
-	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid);
+	xa = xtnetlink_transact_get(sock_net(xtnl), NETLINK_CB(iskb).portid,
+				    XA_TABLE_BUFFER);
 	if (xa == NULL)
 		return xtnetlink_error(&ref, NFXTE_TRANSACT_INACTIVE);
 
@@ -894,7 +920,7 @@ xtnetlink_nlevent(struct notifier_block *blk, unsigned long event, void *ptr)
 	 * 5. issue NFXTM_CHAIN_ADD, TA is reused (bad)
 	 * 6. notifier runs eventually and late
 	 */
-	xa = xtnetlink_transact_get(note->net, note->portid);
+	xa = xtnetlink_transact_get(note->net, note->portid, XA_TABLE_BUFFER);
 	if (xa != NULL) {
 		xtnetlink_transact_pop(xa);
 		xtnetlink_transact_free(xa);
-- 
1.7.10.4

