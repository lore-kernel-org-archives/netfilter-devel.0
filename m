From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 12/17] net/neigh: Change neigh_xmit to take an address family
Date: Tue, 17 Jul 2018 05:06:46 -0700
Message-ID: <20180717120651.15748-13-dsahern@kernel.org>
References: <20180717120651.15748-1-dsahern@kernel.org>
Cc: nikita.leshchenko@oracle.com, roopa@cumulusnetworks.com,
        stephen@networkplumber.org, idosch@mellanox.com, jiri@mellanox.com,
        saeedm@mellanox.com, alex.aring@gmail.com,
        linux-wpan@vger.kernel.org, netfilter-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>
To: netdev@vger.kernel.org
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180717120651.15748-1-dsahern@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The NEIGH_*_TABLE enum is really related to *how* the tables are
stored (in an array), a detail that does not need to leave the
neighbor code. Change the neigh_xmit API to take a proper address
family.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/neighbour.h          |  2 +-
 net/core/neighbour.c             | 10 +++++-----
 net/mpls/af_mpls.c               | 33 ++++++++++++---------------------
 net/mpls/mpls_iptunnel.c         |  6 ++----
 net/netfilter/nf_flow_table_ip.c |  4 ++--
 net/netfilter/nft_fwd_netdev.c   |  6 +++---
 6 files changed, 25 insertions(+), 36 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index b70afea05f86..e968db1b7742 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -365,7 +365,7 @@ void neigh_for_each(struct neigh_table *tbl,
 		    void (*cb)(struct neighbour *, void *), void *cookie);
 void __neigh_for_each_release(struct neigh_table *tbl,
 			      int (*cb)(struct neighbour *));
-int neigh_xmit(int fam, struct net_device *, const void *, struct sk_buff *);
+int neigh_xmit(u8 fam, struct net_device *, const void *, struct sk_buff *);
 void pneigh_for_each(struct neigh_table *tbl,
 		     void (*cb)(struct pneigh_entry *));
 
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 8bdaeb080ce4..b60087d7c0bc 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -2548,15 +2548,16 @@ void __neigh_for_each_release(struct neigh_table *tbl,
 }
 EXPORT_SYMBOL(__neigh_for_each_release);
 
-int neigh_xmit(int index, struct net_device *dev,
+int neigh_xmit(u8 family, struct net_device *dev,
 	       const void *addr, struct sk_buff *skb)
 {
 	int err = -EAFNOSUPPORT;
-	if (likely(index < NEIGH_NR_TABLES)) {
+
+	if (likely(family != AF_UNSPEC)) {
 		struct neigh_table *tbl;
 		struct neighbour *neigh;
 
-		tbl = neigh_tables[index];
+		tbl = neigh_find_table(dev_net(dev), family);
 		if (!tbl)
 			goto out;
 		rcu_read_lock_bh();
@@ -2570,8 +2571,7 @@ int neigh_xmit(int index, struct net_device *dev,
 		}
 		err = neigh->output(neigh, skb);
 		rcu_read_unlock_bh();
-	}
-	else if (index == NEIGH_LINK_TABLE) {
+	} else {
 		err = dev_hard_header(skb, dev, ntohs(skb->protocol),
 				      addr, NULL, skb->len);
 		if (err < 0)
diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 7a4de6d618b1..a701dc055de2 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -34,7 +34,7 @@
  */
 #define MAX_MP_SELECT_LABELS 4
 
-#define MPLS_NEIGH_TABLE_UNSPEC (NEIGH_LINK_TABLE + 1)
+#define MPLS_NEIGH_TABLE_UNSPEC AF_UNSPEC
 
 static int zero = 0;
 static int one = 1;
@@ -453,7 +453,7 @@ static int mpls_forward(struct sk_buff *skb, struct net_device *dev,
 
 	/* If via wasn't specified then send out using device address */
 	if (nh->nh_via_table == MPLS_NEIGH_TABLE_UNSPEC)
-		err = neigh_xmit(NEIGH_LINK_TABLE, out_dev,
+		err = neigh_xmit(AF_UNSPEC, out_dev,
 				 out_dev->dev_addr, skb);
 	else
 		err = neigh_xmit(nh->nh_via_table, out_dev,
@@ -651,14 +651,12 @@ static struct net_device *find_outdev(struct net *net,
 
 	if (!oif) {
 		switch (nh->nh_via_table) {
-		case NEIGH_ARP_TABLE:
+		case AF_INET:
 			dev = inet_fib_lookup_dev(net, mpls_nh_via(rt, nh));
 			break;
-		case NEIGH_ND_TABLE:
+		case AF_INET6:
 			dev = inet6_fib_lookup_dev(net, mpls_nh_via(rt, nh));
 			break;
-		case NEIGH_LINK_TABLE:
-			break;
 		}
 	} else {
 		dev = dev_get_by_index(net, oif);
@@ -694,7 +692,7 @@ static int mpls_nh_assign_dev(struct net *net, struct mpls_route *rt,
 	if (!mpls_dev_get(dev))
 		goto errout;
 
-	if ((nh->nh_via_table == NEIGH_LINK_TABLE) &&
+	if ((nh->nh_via_table == MPLS_NEIGH_TABLE_UNSPEC) &&
 	    (dev->addr_len != nh->nh_via_alen))
 		goto errout;
 
@@ -739,15 +737,15 @@ static int nla_get_via(const struct nlattr *nla, u8 *via_alen, u8 *via_table,
 	/* Validate the address family */
 	switch (via->rtvia_family) {
 	case AF_PACKET:
-		*via_table = NEIGH_LINK_TABLE;
+		*via_table = MPLS_NEIGH_TABLE_UNSPEC;
 		break;
 	case AF_INET:
-		*via_table = NEIGH_ARP_TABLE;
+		*via_table = AF_INET;
 		if (alen != 4)
 			goto errout;
 		break;
 	case AF_INET6:
-		*via_table = NEIGH_ND_TABLE;
+		*via_table = AF_INET6;
 		if (alen != 16)
 			goto errout;
 		break;
@@ -1596,23 +1594,16 @@ static struct notifier_block mpls_dev_notifier = {
 	.notifier_call = mpls_dev_notify,
 };
 
-static int nla_put_via(struct sk_buff *skb,
-		       u8 table, const void *addr, int alen)
+static int nla_put_via(struct sk_buff *skb, u8 family,
+		       const void *addr, int alen)
 {
-	static const int table_to_family[NEIGH_NR_TABLES + 1] = {
-		AF_INET, AF_INET6, AF_DECnet, AF_PACKET,
-	};
 	struct nlattr *nla;
 	struct rtvia *via;
-	int family = AF_UNSPEC;
 
 	nla = nla_reserve(skb, RTA_VIA, alen + 2);
 	if (!nla)
 		return -EMSGSIZE;
 
-	if (table <= NEIGH_NR_TABLES)
-		family = table_to_family[table];
-
 	via = nla_data(nla);
 	via->rtvia_family = family;
 	memcpy(via->rtvia_addr, addr, alen);
@@ -2295,7 +2286,7 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 		rt0->rt_protocol = RTPROT_KERNEL;
 		rt0->rt_payload_type = MPT_IPV4;
 		rt0->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
-		rt0->rt_nh->nh_via_table = NEIGH_LINK_TABLE;
+		rt0->rt_nh->nh_via_table = MPLS_NEIGH_TABLE_UNSPEC;
 		rt0->rt_nh->nh_via_alen = lo->addr_len;
 		memcpy(__mpls_nh_via(rt0, rt0->rt_nh), lo->dev_addr,
 		       lo->addr_len);
@@ -2309,7 +2300,7 @@ static int resize_platform_label_table(struct net *net, size_t limit)
 		rt2->rt_protocol = RTPROT_KERNEL;
 		rt2->rt_payload_type = MPT_IPV6;
 		rt2->rt_ttl_propagate = MPLS_TTL_PROP_DEFAULT;
-		rt2->rt_nh->nh_via_table = NEIGH_LINK_TABLE;
+		rt2->rt_nh->nh_via_table = MPLS_NEIGH_TABLE_UNSPEC;
 		rt2->rt_nh->nh_via_alen = lo->addr_len;
 		memcpy(__mpls_nh_via(rt2, rt2->rt_nh), lo->dev_addr,
 		       lo->addr_len);
diff --git a/net/mpls/mpls_iptunnel.c b/net/mpls/mpls_iptunnel.c
index 6e558a419f60..6dc8370c290d 100644
--- a/net/mpls/mpls_iptunnel.c
+++ b/net/mpls/mpls_iptunnel.c
@@ -138,11 +138,9 @@ static int mpls_xmit(struct sk_buff *skb)
 	mpls_stats_inc_outucastpkts(out_dev, skb);
 
 	if (rt)
-		err = neigh_xmit(NEIGH_ARP_TABLE, out_dev, &rt->rt_gateway,
-				 skb);
+		err = neigh_xmit(AF_INET, out_dev, &rt->rt_gateway, skb);
 	else if (rt6)
-		err = neigh_xmit(NEIGH_ND_TABLE, out_dev, &rt6->rt6i_gateway,
-				 skb);
+		err = neigh_xmit(AF_INET6, out_dev, &rt6->rt6i_gateway, skb);
 	if (err)
 		net_dbg_ratelimited("%s: packet transmission failed: %d\n",
 				    __func__, err);
diff --git a/net/netfilter/nf_flow_table_ip.c b/net/netfilter/nf_flow_table_ip.c
index 15ed91309992..e56fcea9c7ba 100644
--- a/net/netfilter/nf_flow_table_ip.c
+++ b/net/netfilter/nf_flow_table_ip.c
@@ -265,7 +265,7 @@ nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 	skb->dev = outdev;
 	nexthop = rt_nexthop(rt, flow->tuplehash[!dir].tuple.src_v4.s_addr);
 	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ARP_TABLE, outdev, &nexthop, skb);
+	neigh_xmit(AF_INET, outdev, &nexthop, skb);
 
 	return NF_STOLEN;
 }
@@ -482,7 +482,7 @@ nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 	skb->dev = outdev;
 	nexthop = rt6_nexthop(rt, &flow->tuplehash[!dir].tuple.src_v6);
 	skb_dst_set_noref(skb, &rt->dst);
-	neigh_xmit(NEIGH_ND_TABLE, outdev, nexthop, skb);
+	neigh_xmit(AF_INET6, outdev, nexthop, skb);
 
 	return NF_STOLEN;
 }
diff --git a/net/netfilter/nft_fwd_netdev.c b/net/netfilter/nft_fwd_netdev.c
index 8abb9891cdf2..c361b0636a8c 100644
--- a/net/netfilter/nft_fwd_netdev.c
+++ b/net/netfilter/nft_fwd_netdev.c
@@ -84,7 +84,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 	unsigned int verdict = NF_STOLEN;
 	struct sk_buff *skb = pkt->skb;
 	struct net_device *dev;
-	int neigh_table;
+	u8 neigh_table;
 
 	switch (priv->nfproto) {
 	case NFPROTO_IPV4: {
@@ -100,7 +100,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		}
 		iph = ip_hdr(skb);
 		ip_decrease_ttl(iph);
-		neigh_table = NEIGH_ARP_TABLE;
+		neigh_table = AF_INET;
 		break;
 		}
 	case NFPROTO_IPV6: {
@@ -116,7 +116,7 @@ static void nft_fwd_neigh_eval(const struct nft_expr *expr,
 		}
 		ip6h = ipv6_hdr(skb);
 		ip6h->hop_limit--;
-		neigh_table = NEIGH_ND_TABLE;
+		neigh_table = AF_INET6;
 		break;
 		}
 	default:
-- 
2.11.0
