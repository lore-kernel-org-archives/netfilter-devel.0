From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 17/23] netfilter: xt_connlimit: remove mask argument
Date: Tue,  7 Nov 2017 01:52:07 +0100
Message-ID: <20171107005213.22618-18-pablo@netfilter.org>
References: <20171107005213.22618-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171107005213.22618-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Florian Westphal <fw@strlen.de>

Instead of passing mask to all the helpers, just fixup the search key
early.

After rbtree conversion, each rbtree node stores connections of same
'addr & mask', so no need to pass the mask too.

Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/xt_connlimit.c | 52 +++++++++++++++++---------------------------
 1 file changed, 20 insertions(+), 32 deletions(-)

diff --git a/net/netfilter/xt_connlimit.c b/net/netfilter/xt_connlimit.c
index ce2870428631..a6214f235333 100644
--- a/net/netfilter/xt_connlimit.c
+++ b/net/netfilter/xt_connlimit.c
@@ -71,16 +71,9 @@ static inline unsigned int connlimit_iphash(__be32 addr)
 }
 
 static inline unsigned int
-connlimit_iphash6(const union nf_inet_addr *addr,
-                  const union nf_inet_addr *mask)
+connlimit_iphash6(const union nf_inet_addr *addr)
 {
-	union nf_inet_addr res;
-	unsigned int i;
-
-	for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i)
-		res.ip6[i] = addr->ip6[i] & mask->ip6[i];
-
-	return jhash2((u32 *)res.ip6, ARRAY_SIZE(res.ip6),
+	return jhash2((u32 *)addr->ip6, ARRAY_SIZE(addr->ip6),
 		       connlimit_rnd) % CONNLIMIT_SLOTS;
 }
 
@@ -94,24 +87,13 @@ static inline bool already_closed(const struct nf_conn *conn)
 }
 
 static int
-same_source_net(const union nf_inet_addr *addr,
-		const union nf_inet_addr *mask,
-		const union nf_inet_addr *u3, u_int8_t family)
+same_source(const union nf_inet_addr *addr,
+	    const union nf_inet_addr *u3, u_int8_t family)
 {
-	if (family == NFPROTO_IPV4) {
-		return ntohl(addr->ip & mask->ip) -
-		       ntohl(u3->ip & mask->ip);
-	} else {
-		union nf_inet_addr lh, rh;
-		unsigned int i;
-
-		for (i = 0; i < ARRAY_SIZE(addr->ip6); ++i) {
-			lh.ip6[i] = addr->ip6[i] & mask->ip6[i];
-			rh.ip6[i] = u3->ip6[i] & mask->ip6[i];
-		}
+	if (family == NFPROTO_IPV4)
+		return ntohl(addr->ip) - ntohl(u3->ip);
 
-		return memcmp(&lh.ip6, &rh.ip6, sizeof(lh.ip6));
-	}
+	return memcmp(addr->ip6, u3->ip6, sizeof(addr->ip6));
 }
 
 static bool add_hlist(struct hlist_head *head,
@@ -194,7 +176,7 @@ static void tree_nodes_free(struct rb_root *root,
 static unsigned int
 count_tree(struct net *net, struct rb_root *root,
 	   const struct nf_conntrack_tuple *tuple,
-	   const union nf_inet_addr *addr, const union nf_inet_addr *mask,
+	   const union nf_inet_addr *addr,
 	   u8 family, const struct nf_conntrack_zone *zone)
 {
 	struct xt_connlimit_rb *gc_nodes[CONNLIMIT_GC_MAX_NODES];
@@ -215,7 +197,7 @@ count_tree(struct net *net, struct rb_root *root,
 		rbconn = rb_entry(*rbnode, struct xt_connlimit_rb, node);
 
 		parent = *rbnode;
-		diff = same_source_net(addr, mask, &rbconn->addr, family);
+		diff = same_source(addr, &rbconn->addr, family);
 		if (diff < 0) {
 			rbnode = &((*rbnode)->rb_left);
 		} else if (diff > 0) {
@@ -282,7 +264,6 @@ static int count_them(struct net *net,
 		      struct xt_connlimit_data *data,
 		      const struct nf_conntrack_tuple *tuple,
 		      const union nf_inet_addr *addr,
-		      const union nf_inet_addr *mask,
 		      u_int8_t family,
 		      const struct nf_conntrack_zone *zone)
 {
@@ -291,14 +272,14 @@ static int count_them(struct net *net,
 	u32 hash;
 
 	if (family == NFPROTO_IPV6)
-		hash = connlimit_iphash6(addr, mask);
+		hash = connlimit_iphash6(addr);
 	else
-		hash = connlimit_iphash(addr->ip & mask->ip);
+		hash = connlimit_iphash(addr->ip);
 	root = &data->climit_root[hash];
 
 	spin_lock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
-	count = count_tree(net, root, tuple, addr, mask, family, zone);
+	count = count_tree(net, root, tuple, addr, family, zone);
 
 	spin_unlock_bh(&xt_connlimit_locks[hash % CONNLIMIT_LOCK_SLOTS]);
 
@@ -329,16 +310,23 @@ connlimit_mt(const struct sk_buff *skb, struct xt_action_param *par)
 
 	if (xt_family(par) == NFPROTO_IPV6) {
 		const struct ipv6hdr *iph = ipv6_hdr(skb);
+		unsigned int i;
+
 		memcpy(&addr.ip6, (info->flags & XT_CONNLIMIT_DADDR) ?
 		       &iph->daddr : &iph->saddr, sizeof(addr.ip6));
+
+		for (i = 0; i < ARRAY_SIZE(addr.ip6); ++i)
+			addr.ip6[i] &= info->mask.ip6[i];
 	} else {
 		const struct iphdr *iph = ip_hdr(skb);
 		addr.ip = (info->flags & XT_CONNLIMIT_DADDR) ?
 			  iph->daddr : iph->saddr;
+
+		addr.ip &= info->mask.ip;
 	}
 
 	connections = count_them(net, info->data, tuple_ptr, &addr,
-	                         &info->mask, xt_family(par), zone);
+				 xt_family(par), zone);
 	if (connections == 0)
 		/* kmalloc failed, drop it entirely */
 		goto hotdrop;
-- 
2.11.0
