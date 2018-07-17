From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 07/17] drivers/net: remove open coding of neighbor tables
Date: Tue, 17 Jul 2018 05:06:41 -0700
Message-ID: <20180717120651.15748-8-dsahern@kernel.org>
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

Remove open use of arp_tbl and nd_tbl in favor of the new
ipv{4,6}_neigh_table helpers. Since the existence of the IPv6 table
is managed by the core networking, the IS_ENABLED checks for IPv6
can be removed in favor of "is the table non-NULL".

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 drivers/infiniband/ulp/ipoib/ipoib_main.c          | 14 ++++++---
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   | 35 +++++++++++-----------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 11 ++-----
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  | 27 ++++++++---------
 .../net/ethernet/mellanox/mlxsw/spectrum_span.c    |  8 +++--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    |  2 +-
 drivers/net/ethernet/rocker/rocker_main.c          |  4 +--
 drivers/net/ethernet/rocker/rocker_ofdpa.c         |  2 +-
 drivers/net/vrf.c                                  |  4 +--
 drivers/net/vxlan.c                                | 10 +++----
 net/atm/clip.c                                     | 14 +++++----
 net/ieee802154/6lowpan/tx.c                        |  2 +-
 12 files changed, 70 insertions(+), 63 deletions(-)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_main.c b/drivers/infiniband/ulp/ipoib/ipoib_main.c
index 26cde95bc0f3..4f798a7b9cc0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_main.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_main.c
@@ -1298,6 +1298,8 @@ struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
 
 static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 {
+	struct net *net = dev_net(priv->dev);
+	struct neigh_table *arp_tbl = ipv4_neigh_table(net);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	unsigned long neigh_obsolete;
@@ -1318,7 +1320,7 @@ static void __ipoib_reap_neigh(struct ipoib_dev_priv *priv)
 		goto out_unlock;
 
 	/* neigh is obsolete if it was idle for two GC periods */
-	dt = 2 * arp_tbl.gc_interval;
+	dt = 2 * arp_tbl->gc_interval;
 	neigh_obsolete = jiffies - dt;
 	/* handle possible race condition */
 	if (test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
@@ -1357,12 +1359,14 @@ static void ipoib_reap_neigh(struct work_struct *work)
 {
 	struct ipoib_dev_priv *priv =
 		container_of(work, struct ipoib_dev_priv, neigh_reap_task.work);
+	struct net *net = dev_net(priv->dev);
+	struct neigh_table *arp_tbl = ipv4_neigh_table(net);
 
 	__ipoib_reap_neigh(priv);
 
 	if (!test_bit(IPOIB_STOP_NEIGH_GC, &priv->flags))
 		queue_delayed_work(priv->wq, &priv->neigh_reap_task,
-				   arp_tbl.gc_interval);
+				   arp_tbl->gc_interval);
 }
 
 
@@ -1514,6 +1518,8 @@ void ipoib_neigh_free(struct ipoib_neigh *neigh)
 
 static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 {
+	struct net *net = dev_net(priv->dev);
+	struct neigh_table *arp_tbl = ipv4_neigh_table(net);
 	struct ipoib_neigh_table *ntbl = &priv->ntbl;
 	struct ipoib_neigh_hash *htbl;
 	struct ipoib_neigh __rcu **buckets;
@@ -1525,7 +1531,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	if (!htbl)
 		return -ENOMEM;
 	set_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
-	size = roundup_pow_of_two(arp_tbl.gc_thresh3);
+	size = roundup_pow_of_two(arp_tbl->gc_thresh3);
 	buckets = kcalloc(size, sizeof(*buckets), GFP_KERNEL);
 	if (!buckets) {
 		kfree(htbl);
@@ -1541,7 +1547,7 @@ static int ipoib_neigh_hash_init(struct ipoib_dev_priv *priv)
 	/* start garbage collection */
 	clear_bit(IPOIB_STOP_NEIGH_GC, &priv->flags);
 	queue_delayed_work(priv->wq, &priv->neigh_reap_task,
-			   arp_tbl.gc_interval);
+			   arp_tbl->gc_interval);
 
 	return 0;
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
index 8e3c5b4b90ab..a2283a4b3a17 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rep.c
@@ -309,17 +309,19 @@ void mlx5e_remove_sqs_fwd_rules(struct mlx5e_priv *priv)
 
 static void mlx5e_rep_neigh_update_init_interval(struct mlx5e_rep_priv *rpriv)
 {
-#if IS_ENABLED(CONFIG_IPV6)
-	unsigned long ipv6_interval = NEIGH_VAR(&nd_tbl.parms,
+	struct net_device *netdev = rpriv->netdev;
+	struct net *net = dev_net(netdev);
+	struct neigh_table *arp_table = ipv4_neigh_table(net);
+	struct neigh_table *nd_table = ipv6_neigh_table(net);
+
+	unsigned long ipv4_interval = NEIGH_VAR(&arp_table->parms,
 						DELAY_PROBE_TIME);
-#else
 	unsigned long ipv6_interval = ~0UL;
-#endif
-	unsigned long ipv4_interval = NEIGH_VAR(&arp_tbl.parms,
-						DELAY_PROBE_TIME);
-	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 
+	if (nd_table)
+		ipv6_interval = NEIGH_VAR(&nd_table->parms, DELAY_PROBE_TIME);
+
 	rpriv->neigh_update.min_interval = min_t(unsigned long, ipv6_interval, ipv4_interval);
 	mlx5_fc_update_sampling_interval(priv->mdev, rpriv->neigh_update.min_interval);
 }
@@ -437,19 +439,22 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 	struct net_device *netdev = rpriv->netdev;
 	struct mlx5e_priv *priv = netdev_priv(netdev);
 	struct mlx5e_neigh_hash_entry *nhe = NULL;
+	struct net *net = dev_net(netdev);
 	struct mlx5e_neigh m_neigh = {};
+	struct neigh_table *arp_table;
+	struct neigh_table *nd_table;
 	struct neigh_parms *p;
 	struct neighbour *n;
 	bool found = false;
 
+	arp_table = ipv4_neigh_table(net);
+	nd_table = ipv6_neigh_table(net);
+
 	switch (event) {
 	case NETEVENT_NEIGH_UPDATE:
 		n = ptr;
-#if IS_ENABLED(CONFIG_IPV6)
-		if (n->tbl != &nd_tbl && n->tbl != &arp_tbl)
-#else
-		if (n->tbl != &arp_tbl)
-#endif
+
+		if (n->tbl != nd_table && n->tbl != arp_table)
 			return NOTIFY_DONE;
 
 		m_neigh.dev = n->dev;
@@ -493,11 +498,7 @@ static int mlx5e_rep_netevent_event(struct notifier_block *nb,
 		 * changes in the default table, we only care about changes
 		 * done per device delay prob time parameter.
 		 */
-#if IS_ENABLED(CONFIG_IPV6)
-		if (!p->dev || (p->tbl != &nd_tbl && p->tbl != &arp_tbl))
-#else
-		if (!p->dev || p->tbl != &arp_tbl)
-#endif
+		if (!p->dev || (p->tbl != nd_table && p->tbl != arp_table))
 			return NOTIFY_DONE;
 
 		/* We are in atomic context and can't take RTNL mutex,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 0edf4751a8ba..f4f2bace496a 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -45,7 +45,7 @@
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
 #include <net/vxlan.h>
-#include <net/arp.h>
+#include <net/neighbour.h>
 #include "en.h"
 #include "en_rep.h"
 #include "en_tc.h"
@@ -999,13 +999,8 @@ void mlx5e_tc_update_neigh_used_value(struct mlx5e_neigh_hash_entry *nhe)
 	bool neigh_used = false;
 	struct neighbour *n;
 
-	if (m_neigh->family == AF_INET)
-		tbl = &arp_tbl;
-#if IS_ENABLED(CONFIG_IPV6)
-	else if (m_neigh->family == AF_INET6)
-		tbl = &nd_tbl;
-#endif
-	else
+	tbl = neigh_find_table(dev_net(m_neigh->dev), m_neigh->family);
+	if (!tbl)
 		return;
 
 	list_for_each_entry(e, &nhe->encap_list, encap_list) {
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
index e51c8dc52f37..c5e6b2972d0f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_router.c
@@ -2019,15 +2019,15 @@ mlxsw_sp_neigh_entry_lookup(struct mlxsw_sp *mlxsw_sp, struct neighbour *n)
 static void
 mlxsw_sp_router_neighs_update_interval_init(struct mlxsw_sp *mlxsw_sp)
 {
-	unsigned long interval;
+	/* mlxsw only works with init_net at the moment */
+	struct neigh_table *arp_table = ipv4_neigh_table(&init_net);
+	struct neigh_table *nd_table = ipv6_neigh_table(&init_net);
+	unsigned long interval = NEIGH_VAR(&arp_table->parms, DELAY_PROBE_TIME);
+
+	if (nd_table)
+		interval = min_t(unsigned long, interval,
+				 NEIGH_VAR(&nd_table->parms, DELAY_PROBE_TIME));
 
-#if IS_ENABLED(CONFIG_IPV6)
-	interval = min_t(unsigned long,
-			 NEIGH_VAR(&arp_tbl.parms, DELAY_PROBE_TIME),
-			 NEIGH_VAR(&nd_tbl.parms, DELAY_PROBE_TIME));
-#else
-	interval = NEIGH_VAR(&arp_tbl.parms, DELAY_PROBE_TIME);
-#endif
 	mlxsw_sp->router->neighs_update.interval = jiffies_to_msecs(interval);
 }
 
@@ -2050,7 +2050,7 @@ static void mlxsw_sp_router_neigh_ent_ipv4_process(struct mlxsw_sp *mlxsw_sp,
 
 	dipn = htonl(dip);
 	dev = mlxsw_sp->router->rifs[rif]->dev;
-	n = neigh_lookup(&arp_tbl, &dipn, dev);
+	n = ipv4_neigh_lookup(dev, &dipn);
 	if (!n)
 		return;
 
@@ -2064,6 +2064,7 @@ static void mlxsw_sp_router_neigh_ent_ipv6_process(struct mlxsw_sp *mlxsw_sp,
 						   char *rauhtd_pl,
 						   int rec_index)
 {
+	struct neigh_table *nd_table = ipv6_neigh_table(&init_net);
 	struct net_device *dev;
 	struct neighbour *n;
 	struct in6_addr dip;
@@ -2078,7 +2079,7 @@ static void mlxsw_sp_router_neigh_ent_ipv6_process(struct mlxsw_sp *mlxsw_sp,
 	}
 
 	dev = mlxsw_sp->router->rifs[rif]->dev;
-	n = neigh_lookup(&nd_tbl, &dip, dev);
+	n = neigh_lookup(nd_table, &dip, dev);
 	if (!n)
 		return;
 
@@ -3721,7 +3722,7 @@ mlxsw_sp_nexthop4_group_create(struct mlxsw_sp *mlxsw_sp, struct fib_info *fi)
 		return ERR_PTR(-ENOMEM);
 	nh_grp->priv = fi;
 	INIT_LIST_HEAD(&nh_grp->fib_list);
-	nh_grp->neigh_tbl = &arp_tbl;
+	nh_grp->neigh_tbl = ipv4_neigh_table(&init_net);
 
 	nh_grp->gateway = mlxsw_sp_fi_is_gateway(mlxsw_sp, fi);
 	nh_grp->count = fi->fib_nhs;
@@ -4919,9 +4920,7 @@ mlxsw_sp_nexthop6_group_create(struct mlxsw_sp *mlxsw_sp,
 	if (!nh_grp)
 		return ERR_PTR(-ENOMEM);
 	INIT_LIST_HEAD(&nh_grp->fib_list);
-#if IS_ENABLED(CONFIG_IPV6)
-	nh_grp->neigh_tbl = &nd_tbl;
-#endif
+	nh_grp->neigh_tbl = ipv6_neigh_table(&init_net);
 	mlxsw_sp_rt6 = list_first_entry(&fib6_entry->rt6_list,
 					struct mlxsw_sp_rt6, list);
 	nh_grp->gateway = mlxsw_sp_rt6_is_gateway(mlxsw_sp, mlxsw_sp_rt6->rt);
diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
index e42d640cddab..8d21a340cf47 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_span.c
@@ -365,6 +365,7 @@ mlxsw_sp_span_entry_gretap4_parms(const struct net_device *to_dev,
 	bool inherit_ttl = !tparm.iph.ttl;
 	union mlxsw_sp_l3addr gw = daddr;
 	struct net_device *l3edev;
+	struct neigh_table *tbl;
 
 	if (!(to_dev->flags & IFF_UP) ||
 	    /* Reject tunnels with GRE keys, checksums, etc. */
@@ -376,9 +377,10 @@ mlxsw_sp_span_entry_gretap4_parms(const struct net_device *to_dev,
 		return mlxsw_sp_span_entry_unoffloadable(sparmsp);
 
 	l3edev = mlxsw_sp_span_gretap4_route(to_dev, &saddr.addr4, &gw.addr4);
+	tbl = ipv4_neigh_table(dev_net(l3edev));
 	return mlxsw_sp_span_entry_tunnel_parms_common(l3edev, saddr, daddr, gw,
 						       tparm.iph.ttl,
-						       &arp_tbl, sparmsp);
+						       tbl, sparmsp);
 }
 
 static int
@@ -466,6 +468,7 @@ mlxsw_sp_span_entry_gretap6_parms(const struct net_device *to_dev,
 	bool inherit_ttl = !tparm.hop_limit;
 	union mlxsw_sp_l3addr gw = daddr;
 	struct net_device *l3edev;
+	struct neigh_table *tbl;
 
 	if (!(to_dev->flags & IFF_UP) ||
 	    /* Reject tunnels with GRE keys, checksums, etc. */
@@ -477,9 +480,10 @@ mlxsw_sp_span_entry_gretap6_parms(const struct net_device *to_dev,
 		return mlxsw_sp_span_entry_unoffloadable(sparmsp);
 
 	l3edev = mlxsw_sp_span_gretap6_route(to_dev, &saddr.addr6, &gw.addr6);
+	tbl = ipv6_neigh_table(dev_net(l3edev));
 	return mlxsw_sp_span_entry_tunnel_parms_common(l3edev, saddr, daddr, gw,
 						       tparm.hop_limit,
-						       &nd_tbl, sparmsp);
+						       tbl, sparmsp);
 }
 
 static int
diff --git a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
index 78afe75129ab..2f52cbd01d31 100644
--- a/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
+++ b/drivers/net/ethernet/netronome/nfp/flower/tunnel_conf.c
@@ -201,7 +201,7 @@ void nfp_tunnel_keep_alive(struct nfp_app *app, struct sk_buff *skb)
 		if (!netdev)
 			continue;
 
-		n = neigh_lookup(&arp_tbl, &ipv4_addr, netdev);
+		n = ipv4_neigh_lookup(netdev, &ipv4_addr);
 		if (!n)
 			continue;
 
diff --git a/drivers/net/ethernet/rocker/rocker_main.c b/drivers/net/ethernet/rocker/rocker_main.c
index aeafdb9ac015..6791941b3472 100644
--- a/drivers/net/ethernet/rocker/rocker_main.c
+++ b/drivers/net/ethernet/rocker/rocker_main.c
@@ -3098,9 +3098,9 @@ static int rocker_netevent_event(struct notifier_block *unused,
 
 	switch (event) {
 	case NETEVENT_NEIGH_UPDATE:
-		if (n->tbl != &arp_tbl)
-			return NOTIFY_DONE;
 		dev = n->dev;
+		if (n->tbl != ipv4_neigh_table(dev_net(dev)))
+			return NOTIFY_DONE;
 		if (!rocker_port_dev_check(dev))
 			return NOTIFY_DONE;
 		rocker_port = netdev_priv(dev);
diff --git a/drivers/net/ethernet/rocker/rocker_ofdpa.c b/drivers/net/ethernet/rocker/rocker_ofdpa.c
index 6473cc68c2d5..5745d675aaeb 100644
--- a/drivers/net/ethernet/rocker/rocker_ofdpa.c
+++ b/drivers/net/ethernet/rocker/rocker_ofdpa.c
@@ -1356,7 +1356,7 @@ static int ofdpa_port_ipv4_resolve(struct ofdpa_port *ofdpa_port,
 	int err = 0;
 
 	if (!n) {
-		n = neigh_create(&arp_tbl, &ip_addr, dev);
+		n = ipv4_neigh_create(dev, &ip_addr);
 		if (IS_ERR(n))
 			return PTR_ERR(n);
 	}
diff --git a/drivers/net/vrf.c b/drivers/net/vrf.c
index f93547f257fb..304f452f619a 100644
--- a/drivers/net/vrf.c
+++ b/drivers/net/vrf.c
@@ -367,7 +367,7 @@ static int vrf_finish_output6(struct net *net, struct sock *sk,
 	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
 	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
 	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
+		neigh = ipv6_neigh_create(dst->dev, nexthop, false);
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb);
@@ -575,7 +575,7 @@ static int vrf_finish_output(struct net *net, struct sock *sk, struct sk_buff *s
 	nexthop = (__force u32)rt_nexthop(rt, ip_hdr(skb)->daddr);
 	neigh = __ipv4_neigh_lookup_noref(dev, nexthop);
 	if (unlikely(!neigh))
-		neigh = __neigh_create(&arp_tbl, &nexthop, dev, false);
+		neigh = ipv4_neigh_create_noref(dev, &nexthop);
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb);
diff --git a/drivers/net/vxlan.c b/drivers/net/vxlan.c
index ababba37d735..2ef9df11eaff 100644
--- a/drivers/net/vxlan.c
+++ b/drivers/net/vxlan.c
@@ -1520,8 +1520,7 @@ static int arp_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	    ipv4_is_multicast(tip))
 		goto out;
 
-	n = neigh_lookup(&arp_tbl, &tip, dev);
-
+	n = ipv4_neigh_lookup(dev, &tip);
 	if (n) {
 		struct vxlan_fdb *f;
 		struct sk_buff	*reply;
@@ -1675,8 +1674,7 @@ static int neigh_reduce(struct net_device *dev, struct sk_buff *skb, __be32 vni)
 	    ipv6_addr_is_multicast(&msg->target))
 		goto out;
 
-	n = neigh_lookup(ipv6_stub->nd_tbl, &msg->target, dev);
-
+	n = ipv6_neigh_lookup(dev, &msg->target);
 	if (n) {
 		struct vxlan_fdb *f;
 		struct sk_buff *reply;
@@ -1736,7 +1734,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 		if (!pskb_may_pull(skb, sizeof(struct iphdr)))
 			return false;
 		pip = ip_hdr(skb);
-		n = neigh_lookup(&arp_tbl, &pip->daddr, dev);
+		n = ipv4_neigh_lookup(dev, &pip->daddr);
 		if (!n && (vxlan->cfg.flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin.sin_addr.s_addr = pip->daddr,
@@ -1757,7 +1755,7 @@ static bool route_shortcircuit(struct net_device *dev, struct sk_buff *skb)
 		if (!pskb_may_pull(skb, sizeof(struct ipv6hdr)))
 			return false;
 		pip6 = ipv6_hdr(skb);
-		n = neigh_lookup(ipv6_stub->nd_tbl, &pip6->daddr, dev);
+		n = ipv6_neigh_lookup(dev, &pip6->daddr);
 		if (!n && (vxlan->cfg.flags & VXLAN_F_L3MISS)) {
 			union vxlan_addr ipa = {
 				.sin6.sin6_addr = pip6->daddr,
diff --git a/net/atm/clip.c b/net/atm/clip.c
index d795b9c5aea4..a85410000abc 100644
--- a/net/atm/clip.c
+++ b/net/atm/clip.c
@@ -155,10 +155,12 @@ static int neigh_check_cb(struct neighbour *n)
 
 static void idle_timer_check(struct timer_list *unused)
 {
-	write_lock(&arp_tbl.lock);
-	__neigh_for_each_release(&arp_tbl, neigh_check_cb);
+	struct neigh_table *tbl = ipv4_neigh_table(&init_net);
+
+	write_lock(&tbl->lock);
+	__neigh_for_each_release(tbl, neigh_check_cb);
 	mod_timer(&idle_timer, jiffies + CLIP_CHECK_INTERVAL * HZ);
-	write_unlock(&arp_tbl.lock);
+	write_unlock(&tbl->lock);
 }
 
 static int clip_arp_rcv(struct sk_buff *skb)
@@ -465,7 +467,8 @@ static int clip_setentry(struct atm_vcc *vcc, __be32 ip)
 	rt = ip_route_output(&init_net, ip, 0, 1, 0);
 	if (IS_ERR(rt))
 		return PTR_ERR(rt);
-	neigh = __neigh_lookup(&arp_tbl, &ip, rt->dst.dev, 1);
+	neigh = __neigh_lookup(ipv4_neigh_table(&init_net), &ip,
+			       rt->dst.dev, 1);
 	ip_rt_put(rt);
 	if (!neigh)
 		return -ENOMEM;
@@ -836,7 +839,8 @@ static void *clip_seq_start(struct seq_file *seq, loff_t * pos)
 {
 	struct clip_seq_state *state = seq->private;
 	state->ns.neigh_sub_iter = clip_seq_sub_iter;
-	return neigh_seq_start(seq, pos, &arp_tbl, NEIGH_SEQ_NEIGH_ONLY);
+	return neigh_seq_start(seq, pos, ipv4_neigh_table(&init_net),
+			       NEIGH_SEQ_NEIGH_ONLY);
 }
 
 static int clip_seq_show(struct seq_file *seq, void *v)
diff --git a/net/ieee802154/6lowpan/tx.c b/net/ieee802154/6lowpan/tx.c
index e6ff5128e61a..d472b08fbf25 100644
--- a/net/ieee802154/6lowpan/tx.c
+++ b/net/ieee802154/6lowpan/tx.c
@@ -64,7 +64,7 @@ int lowpan_header_create(struct sk_buff *skb, struct net_device *ldev,
 	} else {
 		__le16 short_addr = cpu_to_le16(IEEE802154_ADDR_SHORT_UNSPEC);
 
-		n = neigh_lookup(&nd_tbl, &hdr->daddr, ldev);
+		n = ipv6_neigh_lookup(ldev, &hdr->daddr);
 		if (n) {
 			llneigh = lowpan_802154_neigh(neighbour_priv(n));
 			read_lock_bh(&n->lock);
-- 
2.11.0
