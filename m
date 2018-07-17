From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 14/17] net/ipv4: Convert arp table to per namespace
Date: Tue, 17 Jul 2018 05:06:48 -0700
Message-ID: <20180717120651.15748-15-dsahern@kernel.org>
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

Convert IPv4 neighbor table to per-namespace.

This patch is a transition patch for the core neighbor code, so update
the init_net reference as needed for AF_INET. With the per-namespace
table allow gc parameters to be changed per namespace.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/arp.h        |  2 +-
 include/net/netns/ipv4.h |  1 +
 net/core/neighbour.c     | 22 +++++++-----
 net/ipv4/arp.c           | 88 ++++++++++++++++++++++++++++--------------------
 4 files changed, 67 insertions(+), 46 deletions(-)

diff --git a/include/net/arp.h b/include/net/arp.h
index fae3561db10b..ec86b286f779 100644
--- a/include/net/arp.h
+++ b/include/net/arp.h
@@ -9,7 +9,7 @@
 
 static inline struct neigh_table *ipv4_neigh_table(struct net *net)
 {
-	return neigh_find_table(net, AF_INET);
+	return net->ipv4.arp_tbl;
 }
 
 static inline struct neighbour *ipv4_neigh_create(struct net_device *dev,
diff --git a/include/net/netns/ipv4.h b/include/net/netns/ipv4.h
index 661348f23ea5..bc1fab231500 100644
--- a/include/net/netns/ipv4.h
+++ b/include/net/netns/ipv4.h
@@ -51,6 +51,7 @@ struct netns_ipv4 {
 	struct ipv4_devconf	*devconf_dflt;
 	struct ip_ra_chain __rcu *ra_chain;
 	struct mutex		ra_mutex;
+	struct neigh_table	*arp_tbl;
 #ifdef CONFIG_IP_MULTIPLE_TABLES
 	struct fib_rules_ops	*rules_ops;
 	bool			fib_has_custom_rules;
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index afb2ee985dd1..95b9269e3f35 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1485,11 +1485,15 @@ EXPORT_SYMBOL(pneigh_enqueue);
 static inline struct neigh_parms *lookup_neigh_parms(struct neigh_table *tbl,
 						      struct net *net, int ifindex)
 {
+	struct net *def_net = &init_net;
 	struct neigh_parms *p;
 
+	if (tbl->family == AF_INET)
+		def_net = neigh_parms_net(p);
+
 	list_for_each_entry(p, &tbl->parms_list, list) {
 		if ((p->dev && p->dev->ifindex == ifindex && net_eq(neigh_parms_net(p), net)) ||
-		    (!p->dev && !ifindex && net_eq(net, &init_net)))
+		    (!p->dev && !ifindex && net_eq(net, def_net)))
 			return p;
 	}
 
@@ -1611,7 +1615,7 @@ void neigh_table_init(struct net *net, struct neigh_table *tbl)
 
 	switch (family) {
 	case AF_INET:
-		neigh_tables[NEIGH_ARP_TABLE] = tbl;
+		net->ipv4.arp_tbl = tbl;
 		break;
 	case AF_INET6:
 		neigh_tables[NEIGH_ND_TABLE] = tbl;
@@ -1629,7 +1633,7 @@ int neigh_table_clear(struct net *net, struct neigh_table *tbl)
 
 	switch (family) {
 	case AF_INET:
-		neigh_tables[NEIGH_ARP_TABLE] = NULL;
+		net->ipv4.arp_tbl = NULL;
 		break;
 	case AF_INET6:
 		neigh_tables[NEIGH_ND_TABLE] = NULL;
@@ -1669,7 +1673,7 @@ struct neigh_table *neigh_find_table(struct net *net, u8 family)
 
 	switch (family) {
 	case AF_INET:
-		tbl = neigh_tables[NEIGH_ARP_TABLE];
+		tbl = net->ipv4.arp_tbl;
 		break;
 	case AF_INET6:
 		tbl = neigh_tables[NEIGH_ND_TABLE];
@@ -2173,10 +2177,12 @@ static int neightbl_set(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	err = -ENOENT;
-	if ((tb[NDTA_THRESH1] || tb[NDTA_THRESH2] ||
-	     tb[NDTA_THRESH3] || tb[NDTA_GC_INTERVAL]) &&
-	    !net_eq(net, &init_net))
-		goto errout_tbl_lock;
+	if (tbl->family != AF_INET) {
+		if ((tb[NDTA_THRESH1] || tb[NDTA_THRESH2] ||
+		     tb[NDTA_THRESH3] || tb[NDTA_GC_INTERVAL]) &&
+		    !net_eq(net, &init_net))
+			goto errout_tbl_lock;
+	}
 
 	if (tb[NDTA_THRESH1])
 		tbl->gc_thresh1 = nla_get_u32(tb[NDTA_THRESH1]);
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 707b40f76852..61c1d02a8fad 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -152,38 +152,19 @@ static const struct neigh_ops arp_direct_ops = {
 	.connected_output =	neigh_direct_output,
 };
 
-struct neigh_table arp_tbl = {
-	.family		= AF_INET,
-	.key_len	= 4,
-	.protocol	= cpu_to_be16(ETH_P_IP),
-	.hash		= arp_hash,
-	.key_eq		= arp_key_eq,
-	.constructor	= arp_constructor,
-	.proxy_redo	= parp_redo,
-	.id		= "arp_cache",
-	.parms		= {
-		.tbl			= &arp_tbl,
-		.reachable_time		= 30 * HZ,
-		.data	= {
-			[NEIGH_VAR_MCAST_PROBES] = 3,
-			[NEIGH_VAR_UCAST_PROBES] = 3,
-			[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
-			[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
-			[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
-			[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
-			[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
-			[NEIGH_VAR_PROXY_QLEN] = 64,
-			[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
-			[NEIGH_VAR_PROXY_DELAY]	= (8 * HZ) / 10,
-			[NEIGH_VAR_LOCKTIME] = 1 * HZ,
-		},
-	},
-	.gc_interval	= 30 * HZ,
-	.gc_thresh1	= 128,
-	.gc_thresh2	= 512,
-	.gc_thresh3	= 1024,
+static int parms_data[NEIGH_VAR_DATA_MAX] = {
+	[NEIGH_VAR_MCAST_PROBES] = 3,
+	[NEIGH_VAR_UCAST_PROBES] = 3,
+	[NEIGH_VAR_RETRANS_TIME] = 1 * HZ,
+	[NEIGH_VAR_BASE_REACHABLE_TIME] = 30 * HZ,
+	[NEIGH_VAR_DELAY_PROBE_TIME] = 5 * HZ,
+	[NEIGH_VAR_GC_STALETIME] = 60 * HZ,
+	[NEIGH_VAR_QUEUE_LEN_BYTES] = SK_WMEM_MAX,
+	[NEIGH_VAR_PROXY_QLEN] = 64,
+	[NEIGH_VAR_ANYCAST_DELAY] = 1 * HZ,
+	[NEIGH_VAR_PROXY_DELAY]	= (8 * HZ) / 10,
+	[NEIGH_VAR_LOCKTIME] = 1 * HZ,
 };
-EXPORT_SYMBOL(arp_tbl);
 
 int arp_mc_map(__be32 addr, u8 *haddr, struct net_device *dev, int dir)
 {
@@ -1291,13 +1272,8 @@ static int arp_proc_init(void);
 
 void __init arp_init(void)
 {
-	neigh_table_init(&init_net, &arp_tbl);
-
 	dev_add_pack(&arp_packet_type);
 	arp_proc_init();
-#ifdef CONFIG_SYSCTL
-	neigh_sysctl_register(NULL, &arp_tbl.parms, NULL);
-#endif
 	register_netdevice_notifier(&arp_netdev_notifier);
 }
 
@@ -1426,15 +1402,53 @@ static const struct seq_operations arp_seq_ops = {
 
 static int __net_init arp_net_init(struct net *net)
 {
+	struct neigh_table *arp_tbl;
+
+	arp_tbl = kzalloc(sizeof(*arp_tbl), GFP_KERNEL);
+	if (!arp_tbl)
+		return -ENOMEM;
+
 	if (!proc_create_net("arp", 0444, net->proc_net, &arp_seq_ops,
-			sizeof(struct neigh_seq_state)))
+			sizeof(struct neigh_seq_state))) {
+		kfree(arp_tbl);
 		return -ENOMEM;
+	}
+
+	arp_tbl->family		= AF_INET;
+	arp_tbl->key_len	= 4;
+	arp_tbl->protocol	= cpu_to_be16(ETH_P_IP);
+	arp_tbl->hash		= arp_hash;
+	arp_tbl->key_eq		= arp_key_eq;
+	arp_tbl->constructor	= arp_constructor;
+	arp_tbl->proxy_redo	= parp_redo;
+	arp_tbl->id		= "arp_cache";
+	arp_tbl->gc_interval	= 30 * HZ;
+	arp_tbl->gc_thresh1	= 128;
+	arp_tbl->gc_thresh2	= 512;
+	arp_tbl->gc_thresh3	= 1024;
+
+	arp_tbl->parms.tbl	= arp_tbl;
+	arp_tbl->parms.reachable_time = 30 * HZ;
+	memcpy(arp_tbl->parms.data, parms_data, sizeof(parms_data));
+
+	neigh_table_init(net, arp_tbl);
+
+#ifdef CONFIG_SYSCTL
+	neigh_sysctl_register(NULL, &arp_tbl->parms, NULL);
+#endif
 	return 0;
 }
 
 static void __net_exit arp_net_exit(struct net *net)
 {
+	struct neigh_table *arp_tbl = ipv4_neigh_table(net);
+
 	remove_proc_entry("arp", net->proc_net);
+#ifdef CONFIG_SYSCTL
+	neigh_sysctl_unregister(&arp_tbl->parms);
+#endif
+	neigh_table_clear(net, arp_tbl);
+	kfree(arp_tbl);
 }
 
 static struct pernet_operations arp_net_ops = {
-- 
2.11.0
