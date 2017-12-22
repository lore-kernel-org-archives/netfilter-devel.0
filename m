From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH RFC nf-next,v3 7/7] netfilter: nf_flow_table: add hardware offload support
Date: Fri, 22 Dec 2017 20:27:32 +0100
Message-ID: <20171222192732.13188-8-pablo@netfilter.org>
References: <20171222192732.13188-1-pablo@netfilter.org>
Cc: netdev@vger.kernel.org, f.fainelli@gmail.com,
        simon.horman@netronome.com, ronye@mellanox.com, jiri@mellanox.com,
        nbd@nbd.name, john@phrozen.org, kubakici@wp.pl, fw@strlen.de
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20171222192732.13188-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

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
 include/linux/netdevice.h             |   9 +++
 include/net/netfilter/nf_flow_table.h |   6 ++
 net/netfilter/Kconfig                 |   9 +++
 net/netfilter/Makefile                |   1 +
 net/netfilter/nf_flow_table.c         |  13 ++++
 net/netfilter/nf_flow_table_hw.c      | 127 ++++++++++++++++++++++++++++++++++
 net/netfilter/nf_tables_api.c         |   2 +
 net/netfilter/nft_flow_offload.c      |   4 ++
 8 files changed, 171 insertions(+)
 create mode 100644 net/netfilter/nf_flow_table_hw.c

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
index b22b22082733..02ac8c7e4f7f 100644
--- a/include/net/netfilter/nf_flow_table.h
+++ b/include/net/netfilter/nf_flow_table.h
@@ -23,6 +23,7 @@ struct nf_flowtable {
 	struct rhashtable		rhashtable;
 	const struct nf_flowtable_type	*type;
 	struct delayed_work		gc_work;
+	possible_net_t			ft_net;
 };
 
 enum flow_offload_tuple_dir {
@@ -65,6 +66,7 @@ struct flow_offload_tuple_rhash {
 #define FLOW_OFFLOAD_SNAT	0x1
 #define FLOW_OFFLOAD_DNAT	0x2
 #define FLOW_OFFLOAD_DYING	0x4
+#define FLOW_OFFLOAD_HW		0x8
 
 struct flow_offload {
 	struct flow_offload_tuple_rhash		tuplehash[FLOW_OFFLOAD_DIR_MAX];
@@ -116,6 +118,10 @@ unsigned int nf_flow_offload_ip_hook(void *priv, struct sk_buff *skb,
 unsigned int nf_flow_offload_ipv6_hook(void *priv, struct sk_buff *skb,
 				       const struct nf_hook_state *state);
 
+void flow_offload_hw_add(struct net *net, struct flow_offload *flow,
+			 struct nf_conn *ct);
+void flow_offload_hw_del(struct net *net, struct flow_offload *flow);
+
 #define MODULE_ALIAS_NF_FLOWTABLE(family)	\
 	MODULE_ALIAS("nf-flowtable-" __stringify(family))
 
diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index 1ada46345f3c..cc25876cf223 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -671,6 +671,15 @@ config NF_FLOW_TABLE
 
 	  To compile it as a module, choose M here.
 
+config NF_FLOW_TABLE_HW
+	tristate "Netfilter flow table hardware offload module"
+	depends on NF_FLOW_TABLE
+	help
+	  This option adds hardware offload support for the flow table core
+	  infrastructure.
+
+	  To compile it as a module, choose M here.
+
 config NETFILTER_XTABLES
 	tristate "Netfilter Xtables support (required for ip_tables)"
 	default m if NETFILTER_ADVANCED=n
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index 2c1b8de922f2..1a97a47ad4e8 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -109,6 +109,7 @@ obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
 
 # flow table infrastructure
 obj-$(CONFIG_NF_FLOW_TABLE)	+= nf_flow_table.o
+obj-$(CONFIG_NF_FLOW_TABLE_HW)	+= nf_flow_table_hw.o
 
 # generic X tables 
 obj-$(CONFIG_NETFILTER_XTABLES) += x_tables.o xt_tcpudp.o
diff --git a/net/netfilter/nf_flow_table.c b/net/netfilter/nf_flow_table.c
index e1024b17b910..a505351980fd 100644
--- a/net/netfilter/nf_flow_table.c
+++ b/net/netfilter/nf_flow_table.c
@@ -237,15 +237,22 @@ static inline bool nf_flow_is_dying(const struct flow_offload *flow)
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
 	struct nf_flowtable *flow_table;
 	struct rhashtable_iter hti;
 	struct flow_offload *flow;
+	struct net *net;
 	int err;
 
 	flow_table = container_of(work, struct nf_flowtable, gc_work.work);
+	net = read_pnet(&flow_table->ft_net);
 
 	rhashtable_walk_init(&flow_table->rhashtable, &hti, GFP_KERNEL);
 	err = rhashtable_walk_start(&hti);
@@ -265,10 +272,16 @@ void nf_flow_offload_work_gc(struct work_struct *work)
 
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
+				flow_offload_hw_del(net, flow);
 		}
 	}
 
diff --git a/net/netfilter/nf_flow_table_hw.c b/net/netfilter/nf_flow_table_hw.c
new file mode 100644
index 000000000000..2907564c8aec
--- /dev/null
+++ b/net/netfilter/nf_flow_table_hw.c
@@ -0,0 +1,127 @@
+#include <linux/kernel.h>
+#include <linux/init.h>
+#include <linux/module.h>
+#include <linux/netfilter.h>
+#include <linux/rhashtable.h>
+#include <linux/netdevice.h>
+#include <net/netfilter/nf_flow_table.h>
+#include <net/netfilter/nf_conntrack.h>
+#include <net/netfilter/nf_conntrack_core.h>
+#include <net/netfilter/nf_conntrack_tuple.h>
+
+static DEFINE_SPINLOCK(flow_offload_hw_pending_list_lock);
+static LIST_HEAD(flow_offload_hw_pending_list);
+
+static DEFINE_MUTEX(nf_flow_offload_hw_mutex);
+static struct work_struct nft_flow_offload_hw_work;
+
+struct flow_offload_hw {
+	struct list_head	list;
+	struct flow_offload	*flow;
+	struct nf_conn		*ct;
+	possible_net_t		flow_hw_net;
+};
+
+static int do_flow_offload_hw(struct net *net, struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = dev_get_by_index(net, ifindex);
+	if (WARN_ON(!indev))
+		return 0;
+
+	mutex_lock(&nf_flow_offload_hw_mutex);
+	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_ADD, flow);
+	mutex_unlock(&nf_flow_offload_hw_mutex);
+
+	if (ret >= 0)
+		flow->flags |= FLOW_OFFLOAD_HW;
+
+	dev_put(indev);
+
+	return ret;
+}
+
+static void flow_offload_hw_work(struct work_struct *work)
+{
+	struct flow_offload_hw *offload, *next;
+	LIST_HEAD(hw_offload_pending);
+	struct net *net;
+
+	spin_lock_bh(&flow_offload_hw_pending_list_lock);
+	if (!list_empty(&flow_offload_hw_pending_list))
+		list_move_tail(&flow_offload_hw_pending_list, &hw_offload_pending);
+	spin_unlock_bh(&flow_offload_hw_pending_list_lock);
+
+	list_for_each_entry_safe(offload, next, &hw_offload_pending, list) {
+		if (nf_ct_is_dying(offload->ct))
+			goto next;
+
+		net = read_pnet(&offload->flow_hw_net);
+		do_flow_offload_hw(net, offload->flow);
+next:
+		nf_conntrack_put(&offload->ct->ct_general);
+		list_del(&offload->list);
+		kfree(offload);
+	}
+}
+
+void flow_offload_hw_add(struct net *net, struct flow_offload *flow,
+			 struct nf_conn *ct)
+{
+	struct flow_offload_hw *offload;
+
+	offload = kmalloc(sizeof(struct flow_offload_hw), GFP_ATOMIC);
+	if (!offload)
+		return;
+
+	nf_conntrack_get(&ct->ct_general);
+	offload->ct = ct;
+	offload->flow = flow;
+	write_pnet(&offload->flow_hw_net, net);
+
+	spin_lock_bh(&flow_offload_hw_pending_list_lock);
+	list_add_tail(&offload->list, &flow_offload_hw_pending_list);
+	spin_unlock_bh(&flow_offload_hw_pending_list_lock);
+
+	schedule_work(&nft_flow_offload_hw_work);
+}
+EXPORT_SYMBOL_GPL(flow_offload_hw_add);
+
+void flow_offload_hw_del(struct net *net, struct flow_offload *flow)
+{
+	struct net_device *indev;
+	int ret, ifindex;
+
+	ifindex = flow->tuplehash[FLOW_OFFLOAD_DIR_ORIGINAL].tuple.iifidx;
+	indev = dev_get_by_index(net, ifindex);
+	if (WARN_ON(!indev))
+		return;
+
+	mutex_lock(&nf_flow_offload_hw_mutex);
+	ret = indev->netdev_ops->ndo_flow_offload(FLOW_OFFLOAD_DEL, flow);
+	mutex_unlock(&nf_flow_offload_hw_mutex);
+
+	dev_put(indev);
+}
+EXPORT_SYMBOL_GPL(flow_offload_hw_del);
+
+static int __init nf_flow_table_module_init(void)
+{
+	INIT_WORK(&nft_flow_offload_hw_work, flow_offload_hw_work);
+
+	return 0;
+}
+
+static void __exit nf_flow_table_module_exit(void)
+{
+	cancel_work_sync(&nft_flow_offload_hw_work);
+}
+
+module_init(nf_flow_table_module_init);
+module_exit(nf_flow_table_module_exit);
+
+MODULE_LICENSE("GPL");
+MODULE_AUTHOR("Pablo Neira Ayuso <pablo@netfilter.org>");
diff --git a/net/netfilter/nf_tables_api.c b/net/netfilter/nf_tables_api.c
index efd9405a8a5e..6583d2a0e35b 100644
--- a/net/netfilter/nf_tables_api.c
+++ b/net/netfilter/nf_tables_api.c
@@ -5095,6 +5095,8 @@ static int nf_tables_newflowtable(struct net *net, struct sock *nlsk,
 	}
 
 	flowtable->data.type = type;
+	write_pnet(&flowtable->data.ft_net, net);
+
 	err = rhashtable_init(&flowtable->data.rhashtable, type->params);
 	if (err < 0)
 		goto err3;
diff --git a/net/netfilter/nft_flow_offload.c b/net/netfilter/nft_flow_offload.c
index 4f16c37acaa3..5c8ea236e8a3 100644
--- a/net/netfilter/nft_flow_offload.c
+++ b/net/netfilter/nft_flow_offload.c
@@ -70,6 +70,7 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 {
 	struct nft_flow_offload *priv = nft_expr_priv(expr);
 	struct nf_flowtable *flowtable = &priv->flowtable->data;
+	const struct net_device *indev = nft_in(pkt);
 	enum ip_conntrack_info ctinfo;
 	struct nf_flow_route route;
 	struct flow_offload *flow;
@@ -114,6 +115,9 @@ static void nft_flow_offload_eval(const struct nft_expr *expr,
 	if (ret < 0)
 		goto err_flow_add;
 
+	if (indev->netdev_ops->ndo_flow_offload)
+		flow_offload_hw_add(nft_net(pkt), flow, ct);
+
 	return;
 
 err_flow_add:
-- 
2.11.0
