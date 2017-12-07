From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH nf-next RFC,v2 6/6] netfilter: nft_flow_offload: add ndo hooks for hardware offload
Date: Thu,  7 Dec 2017 13:45:01 +0100
Message-ID: <20171207124501.24325-7-pablo@netfilter.org>
References: <20171207124501.24325-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52818 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753432AbdLGMp2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Dec 2017 07:45:28 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D4BC41BFAB4
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 13:45:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 4E117DA877
        for <netfilter-devel@vger.kernel.org>; Thu,  7 Dec 2017 13:45:24 +0100 (CET)
In-Reply-To: <20171207124501.24325-1-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patch adds the infrastructure to offload flows to hardware, in case
the nic/switch comes with built-in flow tables capabilities.

If the hardware comes with no hardware flow tables or they have
limitations in terms of features, this falls back to the software
generic flow table implementation.

The software flow table garbage collector skips entries that resides in
the hardware, so the hardware will be responsible for releasing this
flow table entry too via flow_offload_dead(). In the next garbage
collector run, this removes the entries both in the software and
hardware flow table from user context.

Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
@Florian: I still owe you one here, you mentioned about inmediate schedule
of the workqueue thread, and I need to revisit this, the quick patch I made
is hitting splats when calling queue_delayed_work() from packet path, this
may be my fault though.

 include/linux/netdevice.h             |  9 ++++
 include/net/netfilter/nf_flow_table.h |  1 +
 net/netfilter/nf_flow_table.c         | 26 ++++++++++++
 net/netfilter/nft_flow_offload.c      | 79 +++++++++++++++++++++++++++++++++++
 4 files changed, 115 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f535779d9dc1..5f2919775632 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -826,6 +826,13 @@ struct xfrmdev_ops {
 };
 #endif
 
+struct flow_offload;
+
+enum flow_offload_type {
+	FLOW_OFFLOAD_ADD	= 0,
+	FLOW_OFFLOAD_DEL,
+};
+
 /*
  * This structure defines the management hooks for network devices.
  * The following hooks can be defined; unless noted otherwise, they are
@@ -1281,6 +1288,8 @@ struct net_device_ops {
 	int			(*ndo_bridge_dellink)(struct net_device *dev,
 						      struct nlmsghdr *nlh,
 						      u16 flags);
+	int			(*ndo_flow_offload)(enum flow_offload_type type,
+						    struct flow_offload *flow);
 	int			(*ndo_change_carrier)(struct net_device *dev,
 						      bool new_carrier);
 	int			(*ndo_get_phys_port_id)(struct net_device *dev,
diff --git a/include/net/netfilter/nf_flow_table.h b/include/net/netfilter/nf_flow_table.h
index 1a2598b4a58f..317049d5ff25 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -67,6 +67,7 @@ struct flow_offload_tuple_rhash {
 #define	FLOW_OFFLOAD_SNAT	0x1
 #define	FLOW_OFFLOAD_DNAT	0x2
 #define	FLOW_OFFLOAD_DYING	0x4
+#define	FLOW_OFFLOAD_HW		0x8
 
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index ff27dad268c3..c578c3aec0e0 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -212,6 +212,21 @@ int nf_flow_table_iterate(struct nf_flowtable *flow_table,
 }
 EXPORT_SYMBOL_GPL(nf_flow_table_iterate);
 
+static void flow_offload_hw_del(struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	rtnl_lock();
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = __dev_get_by_index(&init_net, ifindex);
+	if (WARN_ON(!indev))
+		return;
+
+	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_DEL, flow);
+	rtnl_unlock();
+}
+
 static inline bool nf_flow_has_expired(const struct flow_offload *flow)
 {
 	return (__s32)(flow->timeout - (u32)jiffies) <= 0;
@@ -222,6 +237,11 @@ static inline bool nf_flow_is_dying(const struct flow_offload *flow)
 	return flow->flags & FLOW_OFFLOAD_DYING;
 }
 
+static inline bool nf_flow_in_hw(const struct flow_offload *flow)
+{
+	return flow->flags & FLOW_OFFLOAD_HW;
+}
+
 void nf_flow_offload_work_gc(struct work_struct *work)
 {
 	struct flow_offload_tuple_rhash *tuplehash;
@@ -250,10 +270,16 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 
 		flow = container_of(tuplehash, struct flow_offload, tuplehash[0]);
 
+		if (nf_flow_in_hw(flow) &&
+		    !nf_flow_is_dying(flow))
+			continue;
+
 		if (nf_flow_has_expired(flow) ||
 		    nf_flow_is_dying(flow)) {
 			flow_offload_del(flow_table, flow);
 			nf_flow_release_ct(flow);
+			if (nf_flow_in_hw(flow))
+				flow_offload_hw_del(flow);
 		}
 		counter++;
 	}
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index f1d98a03175f..c4ee1df25a16 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -13,6 +13,64 @@
 #include <linux/netfilter/nf_conntrack_common.h>
 #include <net/netfilter/nf_flow_table.h>
 
+static LIST_HEAD(flow_hw_offload_pending_list);
+static DEFINE_SPINLOCK(flow_hw_offload_lock);
+
+struct flow_hw_offload {
+	struct list_head	list;
+	struct flow_offload	*flow;
+	struct nf_conn		*ct;
+};
+
+static int do_flow_offload(struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	rtnl_lock();
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = __dev_get_by_index(&init_net, ifindex);
+	if (WARN_ON(!indev))
+		return 0;
+
+	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_ADD, flow);
+	if (ret >= 0)
+		flow->flags |= FLOW_OFFLOAD_HW;
+	rtnl_unlock();
+
+	return ret;
+}
+
+/* Schedule worker every 100 ms. */
+#define FLOW_HW_WORK_TIMEOUT	msecs_to_jiffies(100)
+
+static struct delayed_work nft_flow_offload_dwork;
+
+static void flow_offload_work(struct work_struct *work)
+{
+	struct flow_hw_offload *offload, *next;
+	LIST_HEAD(hw_offload_pending);
+
+	spin_lock_bh(&flow_hw_offload_lock);
+	if (!list_empty(&flow_hw_offload_pending_list))
+		list_move_tail(&flow_hw_offload_pending_list, &hw_offload_pending);
+	spin_unlock_bh(&flow_hw_offload_lock);
+
+	list_for_each_entry_safe(offload, next, &hw_offload_pending, list) {
+		if (nf_ct_is_dying(offload->ct))
+			goto next;
+
+		do_flow_offload(offload->flow);
+next:
+		nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+
+	queue_delayed_work(system_power_efficient_wq, &nft_flow_offload_dwork,
+			   FLOW_HW_WORK_TIMEOUT);
+}
+
 struct nft_flow_offload {
 	struct nft_flowtable	*flowtable;
 };
@@ -86,6 +144,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	struct net_device *outdev = pkt->xt.state->out;
 	struct net_device *indev = pkt->xt.state->in;
 	union nf_inet_addr gateway[IP_CT_DIR_MAX];
+	struct flow_hw_offload *offload;
 	enum ip_conntrack_info ctinfo;
 	int iifindex[IP_CT_DIR_MAX];
 	struct flow_offload *flow;
@@ -133,6 +192,21 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err2;
 
+	if (!indev->netdev_ops->ndo_flow_offload)
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
 	flow_offload_free(flow);
@@ -251,6 +325,10 @@ static int __init nft_flow_offload_module_init(void)
 {
 	register_netdevice_notifier(&flow_offload_netdev_notifier);
 
+	INIT_DEFERRABLE_WORK(&nft_flow_offload_dwork, flow_offload_work);
+	queue_delayed_work(system_power_efficient_wq, &nft_flow_offload_dwork,
+			   FLOW_HW_WORK_TIMEOUT);
+
 	return nft_register_expr(&nft_flow_offload_type);
 }
 
@@ -259,6 +337,7 @@ static void __exit nft_flow_offload_module_exit(void)
 	struct net *net;
 
 	nft_unregister_expr(&nft_flow_offload_type);
+	cancel_delayed_work_sync(&nft_flow_offload_dwork);
 	unregister_netdevice_notifier(&flow_offload_netdev_notifier);
 	rtnl_lock();
 	for_each_net(net)
-- 
2.11.0

