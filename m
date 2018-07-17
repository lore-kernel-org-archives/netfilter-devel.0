From: dsahern@kernel.org
Subject: [PATCH RFC/RFT net-next 06/17] net/ipv6: Remove open coded use of neighbor table
Date: Tue, 17 Jul 2018 05:06:40 -0700
Message-ID: <20180717120651.15748-7-dsahern@kernel.org>
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

Convert existing uses for nd_tbl to the helpers introduced in the previous
patch.

Signed-off-by: David Ahern <dsahern@gmail.com>
---
 net/ipv6/addrconf.c   | 16 ++++++++++------
 net/ipv6/ip6_output.c |  4 ++--
 net/ipv6/ndisc.c      | 41 +++++++++++++++++++++++------------------
 net/ipv6/route.c      | 12 +++++++-----
 4 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 1659a6b3cf42..104bf4c6c1f9 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -365,6 +365,8 @@ static int snmp6_alloc_dev(struct inet6_dev *idev)
 
 static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 {
+	struct net *net = dev_net(dev);
+	struct neigh_table *neigh_tbl = ipv6_neigh_table(net);
 	struct inet6_dev *ndev;
 	int err = -ENOMEM;
 
@@ -381,13 +383,13 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	ndev->dev = dev;
 	INIT_LIST_HEAD(&ndev->addr_list);
 	timer_setup(&ndev->rs_timer, addrconf_rs_timer, 0);
-	memcpy(&ndev->cnf, dev_net(dev)->ipv6.devconf_dflt, sizeof(ndev->cnf));
+	memcpy(&ndev->cnf, net->ipv6.devconf_dflt, sizeof(ndev->cnf));
 
 	if (ndev->cnf.stable_secret.initialized)
 		ndev->cnf.addr_gen_mode = IN6_ADDR_GEN_MODE_STABLE_PRIVACY;
 
 	ndev->cnf.mtu6 = dev->mtu;
-	ndev->nd_parms = neigh_parms_alloc(dev, &nd_tbl);
+	ndev->nd_parms = neigh_parms_alloc(dev, neigh_tbl);
 	if (!ndev->nd_parms) {
 		kfree(ndev);
 		return ERR_PTR(err);
@@ -400,7 +402,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	if (snmp6_alloc_dev(ndev) < 0) {
 		netdev_dbg(dev, "%s: cannot allocate memory for statistics\n",
 			   __func__);
-		neigh_parms_release(&nd_tbl, ndev->nd_parms);
+		neigh_parms_release(neigh_tbl, ndev->nd_parms);
 		dev_put(dev);
 		kfree(ndev);
 		return ERR_PTR(err);
@@ -465,7 +467,7 @@ static struct inet6_dev *ipv6_add_dev(struct net_device *dev)
 	return ndev;
 
 err_release:
-	neigh_parms_release(&nd_tbl, ndev->nd_parms);
+	neigh_parms_release(ipv6_neigh_table(net), ndev->nd_parms);
 	ndev->dead = 1;
 	in6_dev_finish_destroy(ndev);
 	return ERR_PTR(err);
@@ -3787,9 +3789,11 @@ static int addrconf_ifdown(struct net_device *dev, int how)
 
 	/* Last: Shot the device (if unregistered) */
 	if (how) {
+		struct neigh_table *tbl = ipv6_neigh_table(net);
+
 		addrconf_sysctl_unregister(idev);
-		neigh_parms_release(&nd_tbl, idev->nd_parms);
-		neigh_ifdown(&nd_tbl, dev);
+		neigh_parms_release(tbl, idev->nd_parms);
+		neigh_ifdown(tbl, dev);
 		in6_dev_put(idev);
 	}
 	return 0;
diff --git a/net/ipv6/ip6_output.c b/net/ipv6/ip6_output.c
index 8047fd41ba88..05e11f71da49 100644
--- a/net/ipv6/ip6_output.c
+++ b/net/ipv6/ip6_output.c
@@ -114,7 +114,7 @@ static int ip6_finish_output2(struct net *net, struct sock *sk, struct sk_buff *
 	nexthop = rt6_nexthop((struct rt6_info *)dst, &ipv6_hdr(skb)->daddr);
 	neigh = __ipv6_neigh_lookup_noref(dst->dev, nexthop);
 	if (unlikely(!neigh))
-		neigh = __neigh_create(&nd_tbl, nexthop, dst->dev, false);
+		neigh = ipv6_neigh_create(dst->dev, nexthop, false);
 	if (!IS_ERR(neigh)) {
 		sock_confirm_neigh(skb, neigh);
 		ret = neigh_output(neigh, skb);
@@ -462,7 +462,7 @@ int ip6_forward(struct sk_buff *skb)
 
 	/* XXX: idev->cnf.proxy_ndp? */
 	if (net->ipv6.devconf_all->proxy_ndp &&
-	    pneigh_lookup(&nd_tbl, net, &hdr->daddr, skb->dev, 0)) {
+	    ipv6_pneigh_lookup(net, &hdr->daddr, skb->dev, 0)) {
 		int proxied = ip6_forward_proxy_check(skb);
 		if (proxied > 0)
 			return ip6_input(skb);
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index e640d2f3c55c..14b925f36099 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -729,14 +729,16 @@ static void ndisc_solicit(struct neighbour *neigh, struct sk_buff *skb)
 static int pndisc_is_router(const void *pkey,
 			    struct net_device *dev)
 {
+	struct net *net = dev_net(dev);
+	struct neigh_table *neigh_tbl = ipv6_neigh_table(net);
 	struct pneigh_entry *n;
 	int ret = -1;
 
-	read_lock_bh(&nd_tbl.lock);
-	n = __pneigh_lookup(&nd_tbl, dev_net(dev), pkey, dev);
+	read_lock_bh(&neigh_tbl->lock);
+	n = __pneigh_lookup(ipv6_neigh_table(net), net, pkey, dev);
 	if (n)
 		ret = !!(n->flags & NTF_ROUTER);
-	read_unlock_bh(&nd_tbl.lock);
+	read_unlock_bh(&neigh_tbl->lock);
 
 	return ret;
 }
@@ -764,6 +766,8 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	struct inet6_dev *idev = NULL;
 	struct neighbour *neigh;
 	int dad = ipv6_addr_any(saddr);
+	struct neigh_table *neigh_tbl;
+	struct net *net;
 	bool inc;
 	int is_router = -1;
 	u64 nonce = 0;
@@ -816,7 +820,10 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 
 	inc = ipv6_addr_is_multicast(daddr);
 
-	ifp = ipv6_get_ifaddr(dev_net(dev), &msg->target, dev, 1);
+	net = dev_net(dev);
+	neigh_tbl = ipv6_neigh_table(net);
+
+	ifp = ipv6_get_ifaddr(net, &msg->target, dev, 1);
 	if (ifp) {
 have_ifp:
 		if (ifp->flags & (IFA_F_TENTATIVE|IFA_F_OPTIMISTIC)) {
@@ -851,8 +858,6 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 
 		idev = ifp->idev;
 	} else {
-		struct net *net = dev_net(dev);
-
 		/* perhaps an address on the master device */
 		if (netif_is_l3_slave(dev)) {
 			struct net_device *mdev;
@@ -888,7 +893,7 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 				 */
 				struct sk_buff *n = skb_clone(skb, GFP_ATOMIC);
 				if (n)
-					pneigh_enqueue(&nd_tbl, idev->nd_parms, n);
+					pneigh_enqueue(neigh_tbl, idev->nd_parms, n);
 				goto out;
 			}
 		} else
@@ -905,15 +910,15 @@ static void ndisc_recv_ns(struct sk_buff *skb)
 	}
 
 	if (inc)
-		NEIGH_CACHE_STAT_INC(&nd_tbl, rcv_probes_mcast);
+		NEIGH_CACHE_STAT_INC(neigh_tbl, rcv_probes_mcast);
 	else
-		NEIGH_CACHE_STAT_INC(&nd_tbl, rcv_probes_ucast);
+		NEIGH_CACHE_STAT_INC(neigh_tbl, rcv_probes_ucast);
 
 	/*
 	 *	update / create cache entry
 	 *	for the source address
 	 */
-	neigh = __neigh_lookup(&nd_tbl, saddr, dev,
+	neigh = __neigh_lookup(neigh_tbl, saddr, dev,
 			       !inc || lladdr || !dev->addr_len);
 	if (neigh)
 		ndisc_update(dev, neigh, lladdr, NUD_STALE,
@@ -1007,7 +1012,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		in6_ifa_put(ifp);
 		return;
 	}
-	neigh = neigh_lookup(&nd_tbl, &msg->target, dev);
+	neigh = ipv6_neigh_lookup(dev, &msg->target);
 
 	if (neigh) {
 		u8 old_flags = neigh->flags;
@@ -1023,7 +1028,7 @@ static void ndisc_recv_na(struct sk_buff *skb)
 		 */
 		if (lladdr && !memcmp(lladdr, dev->dev_addr, dev->addr_len) &&
 		    net->ipv6.devconf_all->forwarding && net->ipv6.devconf_all->proxy_ndp &&
-		    pneigh_lookup(&nd_tbl, net, &msg->target, dev, 0)) {
+		    ipv6_pneigh_lookup(net, &msg->target, dev, 0)) {
 			/* XXX: idev->cnf.proxy_ndp */
 			goto out;
 		}
@@ -1091,7 +1096,7 @@ static void ndisc_recv_rs(struct sk_buff *skb)
 			goto out;
 	}
 
-	neigh = __neigh_lookup(&nd_tbl, saddr, skb->dev, 1);
+	neigh = __ipv6_neigh_lookup(skb->dev, saddr, 1);
 	if (neigh) {
 		ndisc_update(skb->dev, neigh, lladdr, NUD_STALE,
 			     NEIGH_UPDATE_F_WEAK_OVERRIDE|
@@ -1384,8 +1389,8 @@ static void ndisc_router_discovery(struct sk_buff *skb)
 	 */
 
 	if (!neigh)
-		neigh = __neigh_lookup(&nd_tbl, &ipv6_hdr(skb)->saddr,
-				       skb->dev, 1);
+		neigh = __ipv6_neigh_lookup(skb->dev, &ipv6_hdr(skb)->saddr, 1);
+
 	if (neigh) {
 		u8 *lladdr = NULL;
 		if (ndopts.nd_opts_src_lladdr) {
@@ -1768,7 +1773,7 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 
 	switch (event) {
 	case NETDEV_CHANGEADDR:
-		neigh_changeaddr(&nd_tbl, dev);
+		neigh_changeaddr(ipv6_neigh_table(dev_net(dev)), dev);
 		fib6_run_gc(0, net, false);
 		/* fallthrough */
 	case NETDEV_UP:
@@ -1783,10 +1788,10 @@ static int ndisc_netdev_event(struct notifier_block *this, unsigned long event,
 	case NETDEV_CHANGE:
 		change_info = ptr;
 		if (change_info->flags_changed & IFF_NOARP)
-			neigh_changeaddr(&nd_tbl, dev);
+			neigh_changeaddr(ipv6_neigh_table(dev_net(dev)), dev);
 		break;
 	case NETDEV_DOWN:
-		neigh_ifdown(&nd_tbl, dev);
+		neigh_ifdown(ipv6_neigh_table(dev_net(dev)), dev);
 		fib6_run_gc(0, net, false);
 		break;
 	case NETDEV_NOTIFY_PEERS:
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 86a0e4333d42..17f01b8cb05f 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -207,10 +207,10 @@ struct neighbour *ip6_neigh_lookup(const struct in6_addr *gw,
 	struct neighbour *n;
 
 	daddr = choose_neigh_daddr(gw, skb, daddr);
-	n = __ipv6_neigh_lookup(dev, daddr);
+	n = __ipv6_neigh_lookup_noref(dev, daddr);
 	if (n)
 		return n;
-	return neigh_create(&nd_tbl, daddr, dev);
+	return ipv6_neigh_create(dev, daddr, true);
 }
 
 static struct neighbour *ip6_dst_neigh_lookup(const struct dst_entry *dst,
@@ -3392,7 +3392,7 @@ static void rt6_do_redirect(struct dst_entry *dst, struct sock *sk, struct sk_bu
 	 */
 	dst_confirm_neigh(&rt->dst, &ipv6_hdr(skb)->saddr);
 
-	neigh = __neigh_lookup(&nd_tbl, &msg->target, skb->dev, 1);
+	neigh = __ipv6_neigh_lookup(skb->dev, &msg->target, 1);
 	if (!neigh)
 		return;
 
@@ -4064,9 +4064,11 @@ void rt6_sync_down_dev(struct net_device *dev, unsigned long event)
 
 void rt6_disable_ip(struct net_device *dev, unsigned long event)
 {
+	struct net *net = dev_net(dev);
+
 	rt6_sync_down_dev(dev, event);
-	rt6_uncached_list_flush_dev(dev_net(dev), dev);
-	neigh_ifdown(&nd_tbl, dev);
+	rt6_uncached_list_flush_dev(net, dev);
+	neigh_ifdown(ipv6_neigh_table(net), dev);
 }
 
 struct rt6_mtu_change_arg {
-- 
2.11.0
