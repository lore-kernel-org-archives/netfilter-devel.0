From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC,WIP 5/5] netfilter: nft_flow_offload: add ndo hooks for hardware offload
Date: Fri,  3 Nov 2017 16:26:36 +0100
Message-ID: <20171103152636.9967-6-pablo@netfilter.org>
References: <20171103152636.9967-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43340 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755879AbdKCP0t (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 3 Nov 2017 11:26:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C9D0C0B44
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:48 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 3AC3EB7FEB
        for <netfilter-devel@vger.kernel.org>; Fri,  3 Nov 2017 16:26:48 +0100 (CET)
In-Reply-To: <20171103152636.9967-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the infrastructure to offload flows to hardware, in case
the nic/switch comes with built-in flow tables capabilities.

If the hardware comes with not hardware flow tables or they have
limitations in terms of features, this falls back to the software
generic flow table implementation.

The software flow table aging thread skips entries that resides in the
hardware, so the hardware will be responsible for releasing this flow
table entry too.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 include/linux/netdevice.h        |  4 ++
 net/netfilter/nf_flow_offload.c  |  3 ++
 net/netfilter/nft_flow_offload.c | 99 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 106 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f535779d9dc1..0787f53374b3 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -826,6 +826,8 @@ struct xfrmdev_ops {
 };
 #endif
 
+struct flow_offload;
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1281,6 +1283,8 @@ struct net_device_ops {
 	int			(*ndo_bridge_dellink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags);
+	int			(*ndo_flow_add)(struct flow_offload *flow);
+	int			(*ndo_flow_del)(struct flow_offload *flow);
 	int			(*ndo_change_carrier)(struct net_device *dev,
 						      bool new_carrier);
 	int			(*ndo_get_phys_port_id)(struct net_device *dev,
diff --git a/net/netfilter/nf_flow_offload.c b/net/netfilter/nf_flow_offload.c
index f4a3fbe11b69..ac5786976dbb 100644
--- a/net/netfilter/nf_flow_offload.c
+++ b/net/netfilter/nf_flow_offload.c
@@ -147,6 +147,9 @@ static void nf_flow_offload_work_gc(struct work_struct *work)
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
+		if (flow->flags & FLOW_OFFLOAD_HW)
+			continue;
+
 		if (nf_flow_has_expired(flow)) {
 			flow_offload_del(flow);
 			nf_flow_release_ct(tuplehash);
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index d38d185a19a5..0cb194a0aaab 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -17,6 +17,22 @@ union flow_gateway {
 	struct in6_addr	ip6;
 };
 
+static void flow_hw_offload_del(struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret;
+
+	rtnl_lock();
+	indev = __dev_get_by_index(&init_net, flow->tuplehash[0].tuple.iifidx);
+	WARN_ON(!indev);
+
+	if (indev->netdev_ops->ndo_flow_del) {
+		ret = indev->netdev_ops->ndo_flow_del(flow);
+		WARN_ON(ret < 0);
+	}
+	rtnl_unlock();
+}
+
 static int flow_offload_iterate_cleanup(struct nf_conn *ct, void *data)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -44,14 +60,40 @@ static int flow_offload_iterate_cleanup(struct nf_conn *ct, void *data)
 			    tuplehash[tuplehash->tuple.dir]);
 
 	flow_offload_del(flow);
+	if (flow->flags & FLOW_OFFLOAD_HW)
+		flow_hw_offload_del(flow);
 
 	/* Do not remove this conntrack from table. */
 	return 0;
 }
 
+static LIST_HEAD(flow_hw_offload_pending_list);
+static DEFINE_SPINLOCK(flow_hw_offload_lock);
+
+struct flow_hw_offload {
+	struct list_head	list;
+	struct flow_offload	*flow;
+	struct nf_conn		*ct;
+};
+
 static void flow_offload_cleanup(struct net *net,
 				 const struct net_device *dev)
 {
+	struct flow_hw_offload *offload, *next;
+
+	spin_lock_bh(&flow_hw_offload_lock);
+	list_for_each_entry_safe(offload, next, &flow_hw_offload_pending_list, list) {
+		if (dev == NULL ||
+		    offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx == dev->ifindex ||
+		    offload->flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.oifidx == dev->ifindex)
+			continue;
+
+		nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+	spin_unlock_bh(&flow_hw_offload_lock);
+
 	nf_ct_iterate_cleanup_net(net, flow_offload_iterate_cleanup,
 				  (void *)dev, 0, 0);
 }
@@ -156,6 +198,43 @@ flow_offload_alloc(const struct nf_conn *ct, int iifindex, int oifindex,
 	return flow;
 }
 
+static int do_flow_offload(struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	rtnl_lock();
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = __dev_get_by_index(&init_net, ifindex);
+	WARN_ON(!indev);
+
+	ret = indev->netdev_ops->ndo_flow_add(flow);
+	rtnl_unlock();
+
+	if (ret >= 0)
+		flow->flags |= FLOW_OFFLOAD_HW;
+
+	return ret;
+}
+
+static struct delayed_work nft_flow_offload_dwork;
+
+static void flow_offload_work(struct work_struct *work)
+{
+	struct flow_hw_offload *offload, *next;
+
+	spin_lock_bh(&flow_hw_offload_lock);
+	list_for_each_entry_safe(offload, next, &flow_hw_offload_pending_list, list) {
+		do_flow_offload(offload->flow);
+		nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+	spin_unlock_bh(&flow_hw_offload_lock);
+
+	queue_delayed_work(system_power_efficient_wq, &nft_flow_offload_dwork, HZ);
+}
+
 static int nft_flow_route(const struct nft_pktinfo *pkt,
 			  const struct nf_conn *ct,
 			  union flow_gateway *orig_gw,
@@ -211,6 +290,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	union flow_gateway orig_gateway, reply_gateway;
 	struct net_device *outdev = pkt->xt.state->out;
 	struct net_device *indev = pkt->xt.state->in;
+	struct flow_hw_offload *offload;
 	enum ip_conntrack_info ctinfo;
 	struct flow_offload *flow;
 	struct nf_conn *ct;
@@ -250,6 +330,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err2;
 
+	if (!indev->netdev_ops->ndo_flow_add)
+		return;
+
+	offload = kmalloc(sizeof(struct flow_hw_offload), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	nf_conntrack_get(&ct->ct_general);
+	offload->ct = ct;
+	offload->flow = flow;
+
+	spin_lock_bh(&flow_hw_offload_lock);
+	list_add_tail(&offload->list, &flow_hw_offload_pending_list);
+	spin_unlock_bh(&flow_hw_offload_lock);
+
 	return;
 err2:
 	kfree(flow);
@@ -308,6 +403,9 @@ static int __init nft_flow_offload_module_init(void)
 {
 	register_netdevice_notifier(&flow_offload_netdev_notifier);
 
+	INIT_DEFERRABLE_WORK(&nft_flow_offload_dwork, flow_offload_work);
+	queue_delayed_work(system_power_efficient_wq, &nft_flow_offload_dwork, HZ);
+
 	return nft_register_expr(&nft_flow_offload_type);
 }
 
@@ -316,6 +414,7 @@ static void __exit nft_flow_offload_module_exit(void)
 	struct net *net;
 
 	nft_unregister_expr(&nft_flow_offload_type);
+	cancel_delayed_work_sync(&nft_flow_offload_dwork);
 	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
 	rtnl_lock();
 	for_each_net(net)
-- 
2.11.0


