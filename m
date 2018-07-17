From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 11/17] net: Change neigh_table_init and neigh_table_clear signature
Date: Tue, 17 Jul 2018 05:06:45 -0700
Message-ID: <20180717120651.15748-12-dsahern@kernel.org>
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

Convert neigh_table_init and neigh_table_clear to use an address family
instead of the NEIGH_*_TABLE macros which are effectively the same thing
only setup as index into neigh_tables. The functions can do that mapping
internally.

Further, add net to the arg list for both and remove the dependence on
init_net.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 include/net/neighbour.h |  4 ++--
 net/core/neighbour.c    | 40 ++++++++++++++++++++++++++++++++--------
 net/decnet/dn_neigh.c   |  4 ++--
 net/ipv4/arp.c          |  2 +-
 net/ipv6/ndisc.c        |  4 ++--
 5 files changed, 39 insertions(+), 15 deletions(-)

diff --git a/include/net/neighbour.h b/include/net/neighbour.h
index 6cf9ce16eac8..b70afea05f86 100644
--- a/include/net/neighbour.h
+++ b/include/net/neighbour.h
@@ -304,8 +304,8 @@ static inline struct neighbour *__neigh_lookup_noref(struct neigh_table *tbl,
 	return ___neigh_lookup_noref(tbl, tbl->key_eq, tbl->hash, pkey, dev);
 }
 
-void neigh_table_init(int index, struct neigh_table *tbl);
-int neigh_table_clear(int index, struct neigh_table *tbl);
+void neigh_table_init(struct net *net, struct neigh_table *tbl);
+int neigh_table_clear(struct net *net, struct neigh_table *tbl);
 struct neighbour *neigh_lookup(struct neigh_table *tbl, const void *pkey,
 			       struct net_device *dev);
 struct neighbour *neigh_lookup_nodev(struct neigh_table *tbl, struct net *net,
diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index 41841d8e4ea4..8bdaeb080ce4 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1548,14 +1548,15 @@ static struct lock_class_key neigh_table_proxy_queue_class;
 
 static struct neigh_table *neigh_tables[NEIGH_NR_TABLES] __read_mostly;
 
-void neigh_table_init(int index, struct neigh_table *tbl)
+void neigh_table_init(struct net *net, struct neigh_table *tbl)
 {
 	unsigned long now = jiffies;
+	u8 family = tbl->family;
 	unsigned long phsize;
 
 	INIT_LIST_HEAD(&tbl->parms_list);
 	list_add(&tbl->parms.list, &tbl->parms_list);
-	write_pnet(&tbl->parms.net, &init_net);
+	write_pnet(&tbl->parms.net, net);
 	refcount_set(&tbl->parms.refcnt, 1);
 	tbl->parms.reachable_time =
 			  neigh_rand_reach_time(NEIGH_VAR(&tbl->parms, BASE_REACHABLE_TIME));
@@ -1565,8 +1566,8 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 		panic("cannot create neighbour cache statistics");
 
 #ifdef CONFIG_PROC_FS
-	if (!proc_create_seq_data(tbl->id, 0, init_net.proc_net_stat,
-			      &neigh_stat_seq_ops, tbl))
+	if (!proc_create_seq_data(tbl->id, 0, net->proc_net_stat,
+				  &neigh_stat_seq_ops, tbl))
 		panic("cannot create neighbour proc dir entry");
 #endif
 
@@ -1595,13 +1596,36 @@ void neigh_table_init(int index, struct neigh_table *tbl)
 	tbl->last_flush = now;
 	tbl->last_rand	= now + tbl->parms.reachable_time * 20;
 
-	neigh_tables[index] = tbl;
+	switch (family) {
+	case AF_INET:
+		neigh_tables[NEIGH_ARP_TABLE] = tbl;
+		break;
+	case AF_INET6:
+		neigh_tables[NEIGH_ND_TABLE] = tbl;
+		break;
+	case AF_DECnet:
+		neigh_tables[NEIGH_DN_TABLE] = tbl;
+		break;
+	}
 }
 EXPORT_SYMBOL(neigh_table_init);
 
-int neigh_table_clear(int index, struct neigh_table *tbl)
+int neigh_table_clear(struct net *net, struct neigh_table *tbl)
 {
-	neigh_tables[index] = NULL;
+	u8 family = tbl->family;
+
+	switch (family) {
+	case AF_INET:
+		neigh_tables[NEIGH_ARP_TABLE] = NULL;
+		break;
+	case AF_INET6:
+		neigh_tables[NEIGH_ND_TABLE] = NULL;
+		break;
+	case AF_DECnet:
+		neigh_tables[NEIGH_DN_TABLE] = NULL;
+		break;
+	}
+
 	/* It is not clean... Fix it to unload IPv6 module safely */
 	cancel_delayed_work_sync(&tbl->gc_work);
 	del_timer_sync(&tbl->proxy_timer);
@@ -1617,7 +1641,7 @@ int neigh_table_clear(int index, struct neigh_table *tbl)
 	kfree(tbl->phash_buckets);
 	tbl->phash_buckets = NULL;
 
-	remove_proc_entry(tbl->id, init_net.proc_net_stat);
+	remove_proc_entry(tbl->id, net->proc_net_stat);
 
 	free_percpu(tbl->stats);
 	tbl->stats = NULL;
diff --git a/net/decnet/dn_neigh.c b/net/decnet/dn_neigh.c
index 74112777beb0..6d5078ddffac 100644
--- a/net/decnet/dn_neigh.c
+++ b/net/decnet/dn_neigh.c
@@ -593,7 +593,7 @@ static const struct seq_operations dn_neigh_seq_ops = {
 
 void __init dn_neigh_init(void)
 {
-	neigh_table_init(NEIGH_DN_TABLE, &dn_neigh_table);
+	neigh_table_init(&init_net, &dn_neigh_table);
 	proc_create_net("decnet_neigh", 0444, init_net.proc_net,
 			&dn_neigh_seq_ops, sizeof(struct neigh_seq_state));
 }
@@ -601,5 +601,5 @@ void __init dn_neigh_init(void)
 void __exit dn_neigh_cleanup(void)
 {
 	remove_proc_entry("decnet_neigh", init_net.proc_net);
-	neigh_table_clear(NEIGH_DN_TABLE, &dn_neigh_table);
+	neigh_table_clear(&init_net, &dn_neigh_table);
 }
diff --git a/net/ipv4/arp.c b/net/ipv4/arp.c
index 7b27faefa01b..707b40f76852 100644
--- a/net/ipv4/arp.c
+++ b/net/ipv4/arp.c
@@ -1291,7 +1291,7 @@ static int arp_proc_init(void);
 
 void __init arp_init(void)
 {
-	neigh_table_init(NEIGH_ARP_TABLE, &arp_tbl);
+	neigh_table_init(&init_net, &arp_tbl);
 
 	dev_add_pack(&arp_packet_type);
 	arp_proc_init();
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index 5103d8641b04..6105530fe865 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1908,7 +1908,7 @@ int __init ndisc_init(void)
 	/*
 	 * Initialize the neighbour table
 	 */
-	neigh_table_init(NEIGH_ND_TABLE, &nd_tbl);
+	neigh_table_init(&init_net, &nd_tbl);
 
 #ifdef CONFIG_SYSCTL
 	err = neigh_sysctl_register(NULL, &nd_tbl.parms,
@@ -1941,6 +1941,6 @@ void ndisc_cleanup(void)
 #ifdef CONFIG_SYSCTL
 	neigh_sysctl_unregister(&nd_tbl.parms);
 #endif
-	neigh_table_clear(NEIGH_ND_TABLE, &nd_tbl);
+	neigh_table_clear(&init_net, &nd_tbl);
 	unregister_pernet_subsys(&ndisc_net_ops);
 }
-- 
2.11.0
