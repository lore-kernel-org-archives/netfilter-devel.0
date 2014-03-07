From: Florian Westphal <fw@strlen.de>
Subject: [PATCH 1/7] netfilter: connlimit: factor hlist search into new function
Date: Fri,  7 Mar 2014 14:37:09 +0100
Message-ID: <1394199435-14395-2-git-send-email-fw@strlen.de>
References: <1394199435-14395-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:45170 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752232AbaCGNlV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 08:41:21 -0500
In-Reply-To: <1394199435-14395-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Simplifies followup patch that introduces separate locks for each of
the hash slots.

Reviewed-by: Jesper Dangaard Brouer <brouer@redhat.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_connlimit.c | 49 +++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 16 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index c40b269..6988818 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -92,30 +92,24 @@ same_source_net(const union nf_inet_addr *addr,
 	}
 }
 
-static int count_them(struct net *net,
-		      struct xt_connlimit_data *data,
-		      const struct nf_conntrack_tuple *tuple,
-		      const union nf_inet_addr *addr,
-		      const union nf_inet_addr *mask,
-		      u_int8_t family)
+static int count_hlist(struct net *net,
+		       struct hlist_head *head,
+		       const struct nf_conntrack_tuple *tuple,
+		       const union nf_inet_addr *addr,
+		       const union nf_inet_addr *mask,
+		       u_int8_t family)
 {
 	const struct nf_conntrack_tuple_hash *found;
 	struct xt_connlimit_conn *conn;
 	struct hlist_node *n;
 	struct nf_conn *found_ct;
-	struct hlist_head *hash;
 	bool addit = true;
 	int matches = 0;
 
-	if (family == NFPROTO_IPV6)
-		hash = &data->iphash[connlimit_iphash6(addr, mask)];
-	else
-		hash = &data->iphash[connlimit_iphash(addr->ip & mask->ip)];
-
 	rcu_read_lock();
 
 	/* check the saved connections */
-	hlist_for_each_entry_safe(conn, n, hash, node) {
+	hlist_for_each_entry_safe(conn, n, head, node) {
 		found    = nf_conntrack_find_get(net, NF_CT_DEFAULT_ZONE,
 						 &conn->tuple);
 		found_ct = NULL;
@@ -166,13 +160,38 @@ static int count_them(struct net *net,
 			return -ENOMEM;
 		conn->tuple = *tuple;
 		conn->addr = *addr;
-		hlist_add_head(&conn->node, hash);
+		hlist_add_head(&conn->node, head);
 		++matches;
 	}
 
 	return matches;
 }
 
+static int count_them(struct net *net,
+		      struct xt_connlimit_data *data,
+		      const struct nf_conntrack_tuple *tuple,
+		      const union nf_inet_addr *addr,
+		      const union nf_inet_addr *mask,
+		      u_int8_t family)
+{
+	struct hlist_head *hhead;
+	int count;
+	u32 hash;
+
+	if (family == NFPROTO_IPV6)
+		hash = connlimit_iphash6(addr, mask);
+	else
+		hash = connlimit_iphash(addr->ip & mask->ip);
+
+	hhead = &data->iphash[hash];
+
+	spin_lock_bh(&data->lock);
+	count = count_hlist(net, hhead, tuple, addr, mask, family);
+	spin_unlock_bh(&data->lock);
+
+	return count;
+}
+
 static bool
 connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 {
@@ -202,10 +221,8 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 			  iph->daddr : iph->saddr;
 	}
 
-	spin_lock_bh(&info->data->lock);
 	connections = count_them(net, info->data, tuple_ptr, &addr,
 	                         &info->mask, par->family);
-	spin_unlock_bh(&info->data->lock);
 
 	if (connections < 0)
 		/* kmalloc failed, drop it entirely */
-- 
1.8.1.5

