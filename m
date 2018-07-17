From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 15/17] net/ipv6: Convert neighbor table to per-namespace
Date: Tue, 17 Jul 2018 05:06:49 -0700
Message-ID: <20180717120651.15748-16-dsahern@kernel.org>
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

Convert IPv6 neighbor table to per-namespace.

This patch is a transition patch for the core neighbor code, so update
the init_net reference as needed for AF_INET6. With the per-namespace
table allow gc parameters to be changed per namespace.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/ndisc.h      |   6 ++-
 include/net/netns/ipv6.h |   1 +
 net/core/neighbour.c     |  16 +++++--
 net/ipv6/ndisc.c         | 120 +++++++++++++++++++++++------------------------
 4 files changed, 76 insertions(+), 67 deletions(-)

diff --git a/include/net/ndisc.h b/include/net/ndisc.h
index 6fc58a61acdd..ce8ccc45cb4e 100644
--- a/include/net/ndisc.h
+++ b/include/net/ndisc.h
@@ -374,7 +374,11 @@ static inline u32 ndisc_hashfn(const void *pkey, const struct net_device *dev, _
 
 static inline struct neigh_table *ipv6_neigh_table(struct net *net)
 {
-	return neigh_find_table(net, AF_INET6);
+#if IS_ENABLED(CONFIG_IPV6)
+	return net->ipv6.nd_tbl;
+#else
+	return NULL;
+#endif
 }
 
 static inline struct neighbour *ipv6_neigh_create(struct net_device *dev,
diff --git a/include/net/netns/ipv6.h b/include/net/netns/ipv6.h
index 762ac9931b62..62fd0ce9ab0b 100644
--- a/include/net/netns/ipv6.h
+++ b/include/net/netns/ipv6.h
@@ -66,6 +66,7 @@ struct netns_ipv6 {
 	struct rt6_statistics   *rt6_stats;
 	struct timer_list       ip6_fib_timer;
 	struct hlist_head       *fib_table_hash;
+	struct neigh_table	*nd_tbl;
 	struct fib6_table       *fib6_main_tbl;
 	struct list_head	fib6_walkers;
 	struct dst_ops		ip6_dst_ops;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 95b9269e3f35..35c41c4876e5 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1488,7 +1488,7 @@ static inline struct neigh_parms *lookup_neigh_parms(struct neigh_table *tbl,
 	struct net *def_net = &init_net;
 	struct neigh_parms *p;
 
-	if (tbl->family == AF_INET)
+	if (tbl->family != AF_DECnet)
 		def_net = neigh_parms_net(p);
 
 	list_for_each_entry(p, &tbl->parms_list, list) {
@@ -1617,9 +1617,11 @@ void neigh_table_init(struct net *net, struct neigh_table *tbl)
 	case AF_INET:
 		net->ipv4.arp_tbl = tbl;
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		neigh_tables[NEIGH_ND_TABLE] = tbl;
+		net->ipv6.nd_tbl = tbl;
 		break;
+#endif
 	case AF_DECnet:
 		neigh_tables[NEIGH_DN_TABLE] = tbl;
 		break;
@@ -1635,9 +1637,11 @@ int neigh_table_clear(struct net *net, struct neigh_table *tbl)
 	case AF_INET:
 		net->ipv4.arp_tbl = NULL;
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		neigh_tables[NEIGH_ND_TABLE] = NULL;
+		net->ipv6.nd_tbl = NULL;
 		break;
+#endif
 	case AF_DECnet:
 		neigh_tables[NEIGH_DN_TABLE] = NULL;
 		break;
@@ -1675,9 +1679,11 @@ struct neigh_table *neigh_find_table(struct net *net, u8 family)
 	case AF_INET:
 		tbl = net->ipv4.arp_tbl;
 		break;
+#if IS_ENABLED(CONFIG_IPV6)
 	case AF_INET6:
-		tbl = neigh_tables[NEIGH_ND_TABLE];
+		tbl = net->ipv6.nd_tbl;
 		break;
+#endif
 	case AF_DECnet:
 		tbl = neigh_tables[NEIGH_DN_TABLE];
 		break;
@@ -2177,7 +2183,7 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = -ENOENT;
-	if (tbl->family != AF_INET) {
+	if (tbl->family == AF_DECnet) {
 		if ((tb[NDTA_THRESH1] || tb[NDTA_THRESH2] ||
 		     tb[NDTA_THRESH3] || tb[NDTA_GC_INTERVAL]) &&
 		    !net_eq(net, &init_net))
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 6105530fe865..ae78984c4c94 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -107,39 +107,18 @@ static const struct neigh_ops ndisc_direct_ops = {
 	.connected_output =	neigh_direct_output,
 };
 
-struct neigh_table nd_tbl = {
-	.family =	AF_INET6,
-	.key_len =	sizeof(struct in6_addr),
-	.protocol =	cpu_to_be16(ETH_P_IPV6),
-	.hash =		ndisc_hash,
-	.key_eq =	ndisc_key_eq,
-	.constructor =	ndisc_constructor,
-	.pconstructor =	pndisc_constructor,
-	.pdestructor =	pndisc_destructor,
-	.proxy_redo =	pndisc_redo,
-	.id =		"ndisc_cache",
-	.parms = {
-		.tbl			= &nd_tbl,
-		.reachable_time		= ND_REACHABLE_TIME,
-		.data = {
-			[NEIGH_VAR_MCAST_PROBES] = 3,
-			[NEIGH_VAR_UCAST_PROBES] = 3,
-			[NEIGH_VAR_RETRANS_TIME] = ND_RETRANS_TIMER,
-			[NEIGH_VAR_BASE_REACHABLE_TIME] = ND_REACHABLE_TIME,
-			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
-			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
-			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
-			[NEIGH_VAR_PROXY_QLEN] = 64,
-			[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
-			[NEIGH_VAR_PROXY_DELAY] = (8 * HZ) / 10,
-		},
-	},
-	.gc_interval =	  30 * HZ,
-	.gc_thresh1 =	 128,
-	.gc_thresh2 =	 512,
-	.gc_thresh3 =	1024,
+static int parms_data[NEIGH_VAR_DATA_MAX] = {
+	[NEIGH_VAR_MCAST_PROBES] = 3,
+	[NEIGH_VAR_UCAST_PROBES] = 3,
+	[NEIGH_VAR_RETRANS_TIME] = ND_RETRANS_TIMER,
+	[NEIGH_VAR_BASE_REACHABLE_TIME] = ND_REACHABLE_TIME,
+	[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+	[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
+	[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
+	[NEIGH_VAR_PROXY_QLEN] = 64,
+	[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
+	[NEIGH_VAR_PROXY_DELAY] = (8 * HZ) / 10,
 };
-EXPORT_SYMBOL_GPL(nd_tbl);
 
 void __ndisc_fill_addr_option(struct sk_buff *skb, int type, void *data,
 			      int data_len, int pad)
@@ -1865,16 +1844,22 @@ int ndisc_ifinfo_sysctl_change(struct ctl_table *ctl, int write, void __user *bu
 
 static int __net_init ndisc_net_init(struct net *net)
 {
+	struct neigh_table *nd_tbl;
 	struct ipv6_pinfo *np;
 	struct sock *sk;
 	int err;
 
+	nd_tbl = kzalloc(sizeof(*nd_tbl), GFP_KERNEL);
+	if (!nd_tbl)
+		return -ENOMEM;
+
 	err = inet_ctl_sock_create(&sk, PF_INET6,
 				   SOCK_RAW, IPPROTO_ICMPV6, net);
 	if (err < 0) {
 		ND_PRINTK(0, err,
 			  "NDISC: Failed to initialize the control socket (err %d)\n",
 			  err);
+		kfree(nd_tbl);
 		return err;
 	}
 
@@ -1885,12 +1870,52 @@ static int __net_init ndisc_net_init(struct net *net)
 	/* Do not loopback ndisc messages */
 	np->mc_loop = 0;
 
-	return 0;
+	rwlock_init(&nd_tbl->lock);
+	nd_tbl->family		= AF_INET6;
+	nd_tbl->key_len		= sizeof(struct in6_addr);
+	nd_tbl->protocol	= cpu_to_be16(ETH_P_IPV6);
+	nd_tbl->hash		= ndisc_hash;
+	nd_tbl->key_eq		= ndisc_key_eq;
+	nd_tbl->constructor	= ndisc_constructor;
+	nd_tbl->pconstructor	= pndisc_constructor;
+	nd_tbl->pdestructor	= pndisc_destructor;
+	nd_tbl->proxy_redo	= pndisc_redo;
+	nd_tbl->id		= "ndisc_cache";
+	nd_tbl->gc_interval	= 30 * HZ;
+	nd_tbl->gc_thresh1	= 128;
+	nd_tbl->gc_thresh2	= 512;
+	nd_tbl->gc_thresh3	= 1024;
+
+	nd_tbl->parms.tbl	= nd_tbl;
+	nd_tbl->parms.reachable_time = ND_REACHABLE_TIME;
+	memcpy(nd_tbl->parms.data, parms_data, sizeof(parms_data));
+
+	neigh_table_init(net, nd_tbl);
+
+	err = 0;
+#ifdef CONFIG_SYSCTL
+	err = neigh_sysctl_register(NULL, &nd_tbl->parms,
+				    ndisc_ifinfo_sysctl_change);
+	if (err) {
+		inet_ctl_sock_destroy(net->ipv6.ndisc_sk);
+		kfree(nd_tbl);
+	}
+#endif
+	return err;
 }
 
 static void __net_exit ndisc_net_exit(struct net *net)
 {
+	struct neigh_table *nd_tbl = net->ipv6.nd_tbl;
+
 	inet_ctl_sock_destroy(net->ipv6.ndisc_sk);
+
+#ifdef CONFIG_SYSCTL
+	neigh_sysctl_unregister(&nd_tbl->parms);
+#endif
+	net->ipv6.nd_tbl = NULL;
+	neigh_table_clear(net, nd_tbl);
+	kfree(nd_tbl);
 }
 
 static struct pernet_operations ndisc_net_ops = {
@@ -1900,30 +1925,7 @@ static struct pernet_operations ndisc_net_ops = {
 
 int __init ndisc_init(void)
 {
-	int err;
-
-	err = register_pernet_subsys(&ndisc_net_ops);
-	if (err)
-		return err;
-	/*
-	 * Initialize the neighbour table
-	 */
-	neigh_table_init(&init_net, &nd_tbl);
-
-#ifdef CONFIG_SYSCTL
-	err = neigh_sysctl_register(NULL, &nd_tbl.parms,
-				    ndisc_ifinfo_sysctl_change);
-	if (err)
-		goto out_unregister_pernet;
-out:
-#endif
-	return err;
-
-#ifdef CONFIG_SYSCTL
-out_unregister_pernet:
-	unregister_pernet_subsys(&ndisc_net_ops);
-	goto out;
-#endif
+	return register_pernet_subsys(&ndisc_net_ops);
 }
 
 int __init ndisc_late_init(void)
@@ -1938,9 +1940,5 @@ void ndisc_late_cleanup(void)
 
 void ndisc_cleanup(void)
 {
-#ifdef CONFIG_SYSCTL
-	neigh_sysctl_unregister(&nd_tbl.parms);
-#endif
-	neigh_table_clear(&init_net, &nd_tbl);
 	unregister_pernet_subsys(&ndisc_net_ops);
 }
-- 
2.11.0
