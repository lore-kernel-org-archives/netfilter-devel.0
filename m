From: Florian Westphal <fw@strlen.de>
Subject: [PATCH -next] netfilter: xt_connlimit: honor conntrack zone if available
Date: Fri, 14 Nov 2014 13:21:48 +0100
Message-ID: <1415967708-15492-1-git-send-email-fw@strlen.de>
Cc: Florian Westphal <fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43013 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706AbaKNMWh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2014 07:22:37 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Currently all the conntrack lookups are done using default zone.
In case the skb has a ct attached (e.g. template) we should use this zone
for lookups instead.  This makes connlimit work with connections assigned
to other zones.

Signed-off-by: Florian Westphal <fw@strlen.de>
---
 net/netfilter/xt_connlimit.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index fbc66bb..29ba621 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -134,6 +134,7 @@ static bool add_hlist(struct hlist_head *head,
 static unsigned int check_hlist(struct net *net,
 				struct hlist_head *head,
 				const struct nf_conntrack_tuple *tuple,
+				u16 zone,
 				bool *addit)
 {
 	const struct nf_conntrack_tuple_hash *found;
@@ -147,8 +148,7 @@ static unsigned int check_hlist(struct net *net,
 
 	/* check the saved connections */
 	hlist_for_each_entry_safe(conn, n, head, node) {
-		found    = nf_conntrack_find_get(net, NF_CT_DEFAULT_ZONE,
-						 &conn->tuple);
+		found = nf_conntrack_find_get(net, zone, &conn->tuple);
 		if (found == NULL) {
 			hlist_del(&conn->node);
 			kmem_cache_free(connlimit_conn_cachep, conn);
@@ -201,7 +201,7 @@ static unsigned int
 count_tree(struct net *net, struct rb_root *root,
 	   const struct nf_conntrack_tuple *tuple,
 	   const union nf_inet_addr *addr, const union nf_inet_addr *mask,
-	   u8 family)
+	   u8 family, u16 zone)
 {
 	struct xt_connlimit_rb *gc_nodes[CONNLIMIT_GC_MAX_NODES];
 	struct rb_node **rbnode, *parent;
@@ -229,7 +229,7 @@ count_tree(struct net *net, struct rb_root *root,
 		} else {
 			/* same source network -> be counted! */
 			unsigned int count;
-			count = check_hlist(net, &rbconn->hhead, tuple, &addit);
+			count = check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
 
 			tree_nodes_free(root, gc_nodes, gc_count);
 			if (!addit)
@@ -245,7 +245,7 @@ count_tree(struct net *net, struct rb_root *root,
 			continue;
 
 		/* only used for GC on hhead, retval and 'addit' ignored */
-		check_hlist(net, &rbconn->hhead, tuple, &addit);
+		check_hlist(net, &rbconn->hhead, tuple, zone, &addit);
 		if (hlist_empty(&rbconn->hhead))
 			gc_nodes[gc_count++] = rbconn;
 	}
@@ -290,7 +290,7 @@ static int count_them(struct net *net,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
 		      const union nf_inet_addr *mask,
-		      u_int8_t family)
+		      u_int8_t family, u16 zone)
 {
 	struct rb_root *root;
 	int count;
@@ -306,7 +306,7 @@ static int count_them(struct net *net,
 
 	spin_lock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
-	count = count_tree(net, root, tuple, addr, mask, family);
+	count = count_tree(net, root, tuple, addr, mask, family, zone);
 
 	spin_unlock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
@@ -324,13 +324,16 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	enum ip_conntrack_info ctinfo;
 	const struct nf_conn *ct;
 	unsigned int connections;
+	u16 zone = NF_CT_DEFAULT_ZONE;
 
 	ct = nf_ct_get(skb, &ctinfo);
-	if (ct != NULL)
+	if (ct != NULL) {
 		tuple_ptr = &ct->tuplehash[IP_CT_DIR_ORIGINAL].tuple;
-	else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
-				    par->family, &tuple))
+		zone = nf_ct_zone(ct);
+	} else if (!nf_ct_get_tuplepr(skb, skb_network_offset(skb),
+				    par->family, &tuple)) {
 		goto hotdrop;
+	}
 
 	if (par->family == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
@@ -343,7 +346,7 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 	}
 
 	connections = count_them(net, info->data, tuple_ptr, &addr,
-	                         &info->mask, par->family);
+	                         &info->mask, par->family, zone);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
-- 
2.0.4

