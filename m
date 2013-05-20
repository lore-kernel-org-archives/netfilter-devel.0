From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [RFC 1/2] netfilter: nfnetlink: add commit operation to nfnl_subsystems
Date: Mon, 20 May 2013 15:00:42 +0200
Message-ID: <1369054843-14591-1-git-send-email-pablo@netfilter.org>
Cc: tomasz.bursztyka@linux.intel.com, kaber@trash.net
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47772 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755920Ab3ETNAz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 May 2013 09:00:55 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the commit operations, that is called after
processing a batch composed of several netlink messages. This
only allows batches composed of netlink messages going to the
same subsystem.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/nfnetlink.c |   73 ++++++++++++++++++++++++++++++++++-----------
 1 file changed, 55 insertions(+), 18 deletions(-)

diff --git a/net/netfilter/nfnetlink.c b/net/netfilter/nfnetlink.c
index ffb92c0..c470123 100644
--- a/net/netfilter/nfnetlink.c
+++ b/net/netfilter/nfnetlink.c
@@ -87,11 +87,21 @@ EXPORT_SYMBOL_GPL(nfnetlink_subsys_unregister);
 static inline const struct nfnetlink_subsystem *nfnetlink_get_subsys(u_int16_t type)
 {
 	u_int8_t subsys_id = NFNL_SUBSYS_ID(type);
+	const struct nfnetlink_subsystem *ss;
 
 	if (subsys_id >= NFNL_SUBSYS_COUNT)
 		return NULL;
 
-	return rcu_dereference(subsys_table[subsys_id]);
+	ss = rcu_dereference(subsys_table[subsys_id]);
+	if (!ss) {
+#ifdef CONFIG_MODULES
+		rcu_read_unlock();
+		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
+		rcu_read_lock();
+		ss = nfnetlink_get_subsys(type);
+#endif
+	}
+	return ss;
 }
 
 static inline const struct nfnl_callback *
@@ -150,17 +160,8 @@ replay:
 	rcu_read_lock();
 	ss = nfnetlink_get_subsys(type);
 	if (!ss) {
-#ifdef CONFIG_MODULES
 		rcu_read_unlock();
-		request_module("nfnetlink-subsys-%d", NFNL_SUBSYS_ID(type));
-		rcu_read_lock();
-		ss = nfnetlink_get_subsys(type);
-		if (!ss)
-#endif
-		{
-			rcu_read_unlock();
-			return -EINVAL;
-		}
+		return -EINVAL;
 	}
 
 	nc = nfnetlink_find_client(type, ss);
@@ -210,22 +211,58 @@ replay:
 
 static void nfnetlink_rcv(struct sk_buff *skb)
 {
+	unsigned int last_type = 0;
+
+	if (skb->len < nlmsg_total_size(0))
+		return;
+
+	/* This is a batch composed of multiple messages */
+	if (skb->len != nlmsg_hdr(skb)->nlmsg_len) {
+		struct nlmsghdr *nlh = nlmsg_hdr(skb);
+		unsigned int len = 0;
+
+		while (len < skb->len) {
+			/* We don't allow multiple messages in a batch
+			 * going to different subsystems.
+			 */
+			if (last_type &&
+			    last_type != NFNL_SUBSYS_ID(nlh->nlmsg_type))
+				return netlink_ack(skb, nlh, -EINVAL);
+
+			len += nlh->nlmsg_len;
+			last_type = NFNL_SUBSYS_ID(nlh->nlmsg_type);
+			nlh = (struct nlmsghdr *)(skb->data + len);
+		}
+	}
+
 	netlink_rcv_skb(skb, &nfnetlink_rcv_msg);
+
+	/* Post-processing of this batch, if any. */
+	if (last_type) {
+		struct net *net = sock_net(skb->sk);
+		const struct nfnetlink_subsystem *ss;
+
+		rcu_read_lock();
+		ss = nfnetlink_get_subsys(last_type);
+		if (!ss) {
+			rcu_read_unlock();
+			return netlink_ack(skb, nlmsg_hdr(skb), -EINVAL);
+		}
+
+		if (ss->commit)
+			ss->commit(skb, net);
+
+		rcu_read_unlock();
+	}
 }
 
 #ifdef CONFIG_MODULES
 static void nfnetlink_bind(int group)
 {
-	const struct nfnetlink_subsystem *ss;
 	int type = nfnl_group2type[group];
 
 	rcu_read_lock();
-	ss = nfnetlink_get_subsys(type);
-	if (!ss) {
-		rcu_read_unlock();
-		request_module("nfnetlink-subsys-%d", type);
-		return;
-	}
+	nfnetlink_get_subsys(type);
 	rcu_read_unlock();
 }
 #endif
-- 
1.7.10.4

